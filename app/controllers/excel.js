const generalLib = require('../libraries/generalLib')
const portModel = require('../models/portModel')
const reportModel = require('../models/reportModel')
const checkAuth = require('../middleware/checkAuth')
const userModel = require('../models/userModel')
const config = require('../config/config')
const xlsx = require("json-as-xlsx")


module.exports = function(app) {

    // Apply authentication
    app.use('/excel', checkAuth)

    // exel
    app.post('/excel/name', async (req, res) => {
        let deleted = 0
        let total = 0
        let recreated = 0
        let report_time_zone = 0
        const me = req.me
        const filters =  Object.assign({}, req.query)
        filters.deleted = '0'
        const deviceId = req.headers['device-id'] != undefined && req.headers['device-id'] ? req.headers['device-id'] : null 
        
         // Role and Permission
         if(me.role=='staff'){
            if(user=await userModel.get({ select: 'permissions', filters: { uid: me.id }})){
                let perms=[]
                if(!user.permissions) return res.status(403).send({'message':'The user does not have permission to request data.'})
                perms.push(...user.permissions.split(','));
                if(!perms.includes('report')) return res.status(403).send({'message':'The user does not have permission to view reports.'})
            }
        }
    
        if(me.port==null && filters.port && filters.port !='all'){
            if(port = await portModel.get(filters.port, 'code')) {
              if(port.report_time_zone) report_time_zone = port.report_time_zone
            }
        }

        if(filters.port == 'all') delete filters.port
        
        if(me.port) {
            filters.port = me.port
            if(port = await portModel.get(me.port, 'code')) {
                if(port.report_time_zone) report_time_zone = port.report_time_zone
            }
        }

        const h = report_time_zone.toString().replace('-','')
        if(start_date = req.query.start_date) filters.start_date = generalLib.dateTime({setDate: req.query.start_date, addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null})
        if(end_date = req.query.end_date) filters.end_date = generalLib.dateTime({setDate: req.query.end_date, isEndDate: true, addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null})
        
        var select = 'bin_to_uuid(v.vid) as vid, v.sex, v.visa_type, v.visa_no, v.nationality, p.full_name, p.dob, p.passport_no'
        
        if(reportList = await reportModel.excelList({ select: select, groupBy: 'bin_to_uuid(v.vid)', filters: filters})){
            reportList.forEach(val => {
                val.dob = generalLib.formatDate(val.dob)
                delete val.total;
            })
        }

        if(result = await reportModel.total({select: 'v.sex', groupBy: 'bin_to_uuid(v.vid)', filters: filters})) {
            total = result.length
            let id = 1
            result.forEach(val => {
                val.dob = generalLib.formatDate(val.dob)
                delete val.total;
            })
            await Promise.all([
                reportModel.deleted({filters: filters}).then(result => {
                    if(result) deleted = result
                }),

                reportModel.recreated(filters).then(result => {
                    if(result) recreated = result
                }),

            ])
        }

        const excelFilePath = config.pdfDir+deviceId

        if(reportList==null) return res.status(422).send({'message': "Data of report is null."})
        // Add key no: 1
        const contents = reportList.map((obj, index) => {
            return { ...obj, no: index + 1 };
        });

        const start_date_str = generalLib.date({setDate: filters.start_date})
        const end_date_str = generalLib.date({setDate: filters.end_date})
        const sheetName = start_date_str+'-'+end_date_str
        
        let data = [
                {
                sheet: sheetName,
                columns: [
                    { label: "ល.រ", value: "no" },
                    { label: "ឈ្មោះ", value: "full_name" },
                    { label: "ភេទ", value:"sex" }, 
                    { label: "សញ្ជាតិ", value: "nationality" },
                    { label: "ថ្ងៃខែឆ្នាំកំណើត", value: "dob" },
                    { label: "លិខិឆ្លងដែន", value: "passport_no" },
                    { label: "ទិដ្ធាការ", value: "visa_type" },
                    { label: "លេខទិដ្ធាការ", value: "visa_no" },
                ],
                content: contents
            },
        ]
    
        let settings = {
            fileName: excelFilePath,
            extraLength: 3,
            writeMode: "WriteFile",
            writeOptions: {},
            RTL: false,
        }
    
        // Path xlsx 
        const xlsxUrl = config.baseUrl+config.pdfDir+deviceId+'.xlsx' 
        
        // Generate xlsx
        try {
            xlsx(data , settings)
            return res.status(200).send({'url': xlsxUrl})
        } catch (error) {
            // console.log(erroe)
        }
        return res.send({'message': 'Export Fail.'})

    })
}
