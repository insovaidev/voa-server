const { validationResult, check } = require("express-validator");
const checkAuth = require("../middleware/checkAuth");
const generalLib =  require('../libraries/generalLib')
const passwordLib = require('../libraries/passwordLib')
const lang = require('../language/en.json');
const activityLogModel = require("../models/activityLogModel");
const userModel = require("../models/userModel");
const portModel = require('../models/portModel');
const visaModel = require('../models/visaModel');
const visaTypeModel = require("../models/visaTypeModel");
const countryModel = require("../models/countryModel");
const deviceModel = require('../models/deviceModel')
const userSyncModel = require('../models/userSyncModel');
const axios = require("axios");
const config = require("../config/config");


module.exports = function (app) {
    
    // Check Auth
    app.use('/settings', checkAuth);
    
    // History Lists
    app.get('/settings/histories', async ( req, res ) => {
        let data = []
        let total = 0
        let report_time_zone = 0
        let filters = Object.assign({}, req.query)
        const me = req.me

        if(me.port) {
            filters.port = me.port
            if(port = await portModel.get(me.port, 'code')) {
                if(port.report_time_zone) report_time_zone = port.report_time_zone
            }
        }

        const h = report_time_zone.toString().replace('-','')

        if(start_date = req.query.start_date) filters.start_date = generalLib.dateTime({setDate: start_date, addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null})
        if(end_date = req.query.end_date) filters.end_date = generalLib.dateTime({setDate: end_date, isEndDate: true, addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null})
        
        if(req.query.day == 'today') {
            filters.today = { 
                start_date: generalLib.dateTime({ setDate: generalLib.date(), addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null }),  
                end_date: generalLib.dateTime({ setDate: generalLib.date(), isEndDate: true ,addHour: report_time_zone < 0 ? h : null, minusHour: report_time_zone > 0 ? h : null })
            }
        }

        if(limit = req.query.limit){
            filters.limit = limit 
        }  else {
            filters.limit = 30    
        }

        if(offset = req.query.offset) {
            filters.offset = offset 
        } else {
            filters.offset = 0
        }

        const users = {}
        if(result = await userModel.list({select:'bin_to_uuid(uid) as uid, created_at, username'})){
            result.forEach((val) => {
                users[val.uid] = val
            });
        }
        
        var select = 'bin_to_uuid(id) id, bin_to_uuid(uid) as uid, description, record_type, action, port, created_at, bin_to_uuid(record_id) as record_id'
        // For Filters User uids
        var user_select = 'bin_to_uuid(uid) as uid'
        const user_filters = {}
        const uids = [] 

        if(me.role=='admin'){
            if(me.port) filters.port = me.port
            user_filters.in_role = ['super_admin']
        }

        if(me.role=='sub_admin'){
            user_filters.in_role = ['super_admin', 'admin']
        }

        // Find User level that can not get activity 
        if(result = await userModel.list({select: user_select, filters: user_filters})){
            result.forEach(val => {
                uids.push(val.uid)
            })
            if(!user_filters.uid) filters.not_uids = uids
        }
        
        // Only Can Get Own Activity 
        if(me.role=='report' || me.role=='staff'){
            filters.uid = me.id
            delete filters.not_uids 
        }

        // Delete uid filter to get all act user level
        if(me.role=='super_admin') delete filters.not_uids
 
        // Get List Activity
        if(result=await activityLogModel.list({select: select, filters:filters})){
            result.forEach(val => {
                data.push({
                    'id': val.id,
                    'user_id': val.uid,
                    'record_id': val.record_id,
                    'username': users[val.uid] ? users[val.uid].username : null ,
                    'description': val.description,   
                    'record_type': val.record_type,
                    'action': val.action,
                    'port': val.port, 
                    'created_at': generalLib.formatDateTime(val.created_at),
                })
            })
        }
    
        if(result = await activityLogModel.gets({ filters: filters})){
            total = result[0].total
        }

        res.send({ 'total': total, 'limit': 30 , 'offset': parseInt(filters.offset), 'data': data.length > 0 ? data : null })
    })

    // Get a History
    app.get('/settings/histories/:id', async ( req, res ) => {
        let data = null
        let response = {}
        let select = 'data, record_type, port, action, bin_to_uuid(uid) as uid, created_at, description'
        var filters = { id: req.params.id }

        if(!generalLib.uuidValidate(req.params.id)) return res.status(422).send({'message': 'params uuid invalid.'})  

        // Get an Act
        if(act=await activityLogModel.list({select: select, filters: filters})){ 
            data=JSON.parse(act[0].data)    

           if(act[0].record_type=='users'){
                // Auth Action
                if(act[0].action=='login' || act[0].action=='logout'){
                    const owner = await userModel.get({select: '*', filters: {uid: act[0].uid}})
                    response.username=owner.username
                    if(act[0].port){
                        const port=await portModel.get(act[0].port, 'code')
                        response.port={
                            'code': port.code,
                            'name_km': port.name_km
                        }
                    }
                    // response.port=act[0].port
                    response.created_by=owner.username 
                    response.sex=owner.sex
                    response.role=owner.role
                    response.created_at=generalLib.formatDateTime(owner.created_at) 
                    response.permissions=owner.permissions
                }

                // Use Settings
                if(data){
                    response.username=data.username
                    if(act[0].port){
                        const port=await portModel.get(act[0].port, 'code')
                        response.port={
                            'code': port.code,
                            'name_km': port.name_km
                        }
                    }
                    const owner = await userModel.get({select: 'username', filters: {uid: act[0].uid}})
                    response.created_by=owner.username 
                    response.sex=data.sex
                    response.role=data.role
                    response.created_at=generalLib.formatDateTime(data.created_at) 
                    response.permissions=data.permissions
                } 
            }

            // Passports
            if(act[0].record_type=='passports'){
                response.passport_no=data.passport_no
                const visa = await visaModel.get(data.vid, 'vid')
                if(visa_type=await visaTypeModel.get(visa.visa_type, 'type')){
                    response.visa_type= {
                        'type': visa_type.type,
                        'entries': visa_type.entries,
                        'duration': visa_type.duration,
                        'duration_type': visa_type.duration_type
                    }
                }
                response.given_name=data.given_name 
                response.surname=data.surname 
                response.sex=data.sex
                if(data.nationality){
                    const country = await countryModel.get(data.nationality, 'code')
                    response.nationality= {
                        'country': country.name ,
                        'code': country.code
                    } 
                }
                response.dob= generalLib.formatDate(data.dob) 
                response.pob=data.pob 
                response.profession=data.profession
                response.email=data.contact
                response.issued_date= generalLib.formatDate(data.issued_date) 
                response.expire_date= generalLib.formatDate(data.expire_date) 
                response.created_at= generalLib.formatDateTime(data.created_at) 
                response.updated_at= generalLib.formatDateTime(data.updated_at) 
                response.deleted_reason=data.deleted_reason
            }

            if(act[0].record_type=='visas'){
                response.visa_no=data.visa_no
                response.passport_no=data.passport_no
                if(data.port){
                    const port=await portModel.get(data.port, 'code')
                    response.port={
                        'code': port.code,
                        'name_km': port.name_km
                    }
                }
                response.travel_from=data.travel_from
                response.final_city=data.final_city
                if(visa=await visaModel.get(data.vid, 'vid')){
                    const visa_type = await visaTypeModel.get(visa.visa_type, 'type')
                    response.visa_type = {
                        'type': visa_type.type,
                        'entries': visa_type.entries   
                    }
                    response.stay= {
                        'duration': visa_type.duration,
                        'duration_type': visa_type.duration_type,
                    }
                }
                // response.description=act.description
                response.permanent=data.address
                response.permanent=data.address
                response.address_in_cambodia=data.address_in_cambodia
                response.travel_purpose=data.travel_purpose
                response.created_at=generalLib.formatDateTime(data.created_at)
                response.updated_at= generalLib.formatDateTime(data.updated_at) 
                response.deleted_reason=data.deleted_reason  
            }
            response.description=act[0].description      
        }
        res.send({'data': response})
    })

    // Add User
    app.post('/settings/users', [
        check('password').trim().notEmpty().withMessage('Password required')
        .isLength({ min: 6 }).withMessage('password must be minimum 6 length')
        .not().matches(/^$|\s+/).withMessage('White space not allowed'),
        // confirm password validation
        check('confirmPassword').custom((value, { req }) => {
            if (value !== req.body.password) {
                throw new Error('Password Confirmation does not match password');
            }
            return true;
        })
    ],async (req, res ) => {
        var data = req.body
        const me = req.me
        const deviceId = req.headers['device-id'] != undefined && req.headers['device-id'] ? req.headers['device-id'] : null  

        // Check Validate 
        const errors = validationResult(req)
        if (!errors.isEmpty()) return res.status(422).json(generalLib.formErrors(errors.array()))

        // Role and Permission
        if(me.role=='report' || me.role=='staff') return res.status(403).send({'message': `Role ${me.role} can not add a user to this system.`})
        
        // Check duplicate user
        if(result=await userModel.get({select:'username', filters: { username: data.username }})) {
            return res.status(403).send({'code': 'invalid_username', 'type': 'users', 'message': 'Sorry! The username you provid already exist.'})
        } 

        data.uid = generalLib.generateUUID(me.port)
        data['password'] = await passwordLib.hash(data.password);
        data.last_user_agent = req.headers["user-agent"];
        data.last_ip = generalLib.getIp(req);
        
        if(me.role=='admin'){
            if(me.port==null){
                if(data.role=='super_admin') return res.status(403).send(`Role ${data.role} can not assign by ${me.role}.`)
                if(data.role=='admin' && data.port==undefined) return res.status(403).send({'message': `Need port for role ${data.role} if user create by ${me.role} that has no port.`})
            }
            if(data.role=='super_admin' || data.role=='admin') return res.status(403).send(`Role ${data.role} can not assign by ${me.role}.`)
            if(me.port) data.port = me.port
        }

        if(me.role=='sub_admin'){
            if(data.role!='report' || data.role!='staff') return res.status(403).send(`Role ${data.role} can not assign by ${me.role}.`)
            if(me.port) data.port = me.port
        }
        
        const body = generalLib.omit(data, 'confirmPassword')

        // Add User
        // await userModel.add(body)

        try {
            const addUser = await axios.post(config.centralUrl+'users/create', body)
            if(addUser){
                    const actData = addUser.data.data
                    actData.logined_at = generalLib.formatDateTime(actData.logined_at)
                    actData.created_at = generalLib.formatDateTime(actData.created_at)
                    actData.updated_at = generalLib.formatDateTime(actData.updated_at)
                    actData.logout_at = generalLib.formatDateTime(actData.logout_at)
                    // if(!me.port) device = await deviceModel.get({select: 'port', filters: { 'device_id': deviceId }}) 
                    // await activityLogModel.add({
                    //     id: generalLib.generateUUID(me.port),
                    //     uid: me.id, 
                    //     ip: generalLib.getIp(req), 
                    //     port: me.port ? me.port : device.port, 
                    //     record_id: data.uid,
                    //     ref_id: user.username,
                    //     device_id: deviceId,
                    //     record_type: 'users', 
                    //     action: 'add', 
                    //     data: JSON.stringify(actData)
                    // })
            } 
            return res.status(201).send({'message': 'success'})
        } catch (error) {
            // console.log(error.data)
            return res.status(403).send({'message': error})    
        }
    })

    // Update a User
    app.patch('/settings/users/:id', async (req, res ) => {
        var data = req.body
        const me = req.me
        const deviceId = req.headers['device-id'] != undefined && req.headers['device-id'] ? req.headers['device-id'] : null  

        if(!generalLib.uuidValidate(req.params.id)) return res.status(422).send({'message': 'params uuid invalid.'})  
   
        if(me.role=='report' || me.role=='staff') return res.status(403).send({'message': `Role ${me.role} can not update a user.`})

        if(!(result=await userModel.get({select: 'username', filters: { uid: req.params.id}}))) return res.status(404).send({'message':'User not found.'})
        
        if(me.role=='admin'){
            if(data.role && ['super_admin'].includes(data.role)) return res.send({'message': `As admin can not assign user to role super_admin.`})
            if(me.port==null){
                if(data.port==undefined) return res.send({'message': 'For admin that has no port when update any user must be has port.'})   
            }
            if(me.port && data.port && me.port!==data.port) return res.status(403).send({'message': `This Admin can only assign user to port ${me.port}.`})
        }
    
        if(me.role=='sub_admin'){
            if(data.role){
                if(['super_admin', 'admin', 'sub_admin'].includes(data.role)) return res.status(403).send({'message': `As sub_admin can not assign user to role ${data.role}.`})
            }
            if(data.port && me.port!==data.port) return res.send({'message': `This user can only assign to port ${me.port}.`})
        }

        if(data.password){
            if(data.password != data.confirmPassword) return res.status(403).send({'message': 'comfirmPassword not match.'})
            data.password = await passwordLib.hash(data.password)
        }

        const body = generalLib.omit(data, 'confirmPassword')

        // Add Log
        if(await userModel.update(req.params.id, body)){
            // Get User Just Updated & Add Log
            if(user=await userModel.get({select: 'bin_to_uuid(uid) as uid,name,username,sex,phone,email,role,permissions,port,photo,banned,banned_reason,logined_at,logout_at,last_ip,last_user_agent,created_at,updated_at', filters: { uid: req.params.id }})){
                const data_json = generalLib.omit(user, 'password') 
                data_json.logined_at = generalLib.formatDateTime(data_json.logined_at)
                data_json.created_at = generalLib.formatDateTime(data_json.created_at)
                data_json.updated_at = generalLib.formatDateTime(data_json.updated_at)
                data_json.logout_at = generalLib.formatDateTime(data_json.logout_at)
                if(!me.port) device = await deviceModel.get({select: 'port', filters: { 'device_id': deviceId }}) 

                await activityLogModel.add({
                    id: generalLib.generateUUID(me.port),
                    uid: me.id, 
                    ip: generalLib.getIp(req), 
                    port: me.port ? me.port : device.port,   
                    record_id: req.params.id,
                    device_id: deviceId,
                    ref_id: user.username,
                    record_type: 'users', 
                    action: 'edit', 
                    data: JSON.stringify(data_json)
                })
            }
        }

        res.send({'message': 'updated success'})
    })

    // Update User Profile 
    app.patch('/settings/profile', async (req, res) => {
        const data = Object.assign({}, req.body) 
        const me = req.me
        const updateData = {}
        let action = null
        const deviceId = req.headers['device-id'] != undefined && req.headers['device-id'] ? req.headers['device-id'] : null  

        if(data.username){
            if(result=await userModel.get({select: 'username', filters: { username: data.username }})){
                return res.status(403).send({'message': `User name ${data.username} already exist.`})
            } 
            updateData.username=data.username
        }
        
        if(data){
            if(('email' in data)){
                if(data.email !== ""){
                    updateData.email = data.email 
                } else {
                    updateData.email = null
                }
            } 
            if(('phone' in data)){
                if(data.phone !== ""){
                    updateData.phone = data.phone 
                } else {
                    updateData.phone = null
                }
            } 
            if(data.name) updateData.name=data.name
            if(data.sex) updateData.sex=data.sex
        }
        
        if(data.old_password && data.password){
            const user = await userModel.get({select:'password', filters: { uid: me.id }})
            if(await passwordLib.compare(data.old_password, user.password) !== true) return res.status(422).send({'type':'user', 'code':'wrong_password' ,'message':lang.incorrectPassword, 'errors': {'password':{'message': 'old password incorrect.'}}})
            if(data.password != data.confirmPassword) return res.status(403).send({'message': 'comfirmPassword not match.'})
            updateData.password = await passwordLib.hash(data.password)
            action = 'change_password'
        }

        // Update User
        if(await userModel.update(me.id, updateData)){
            // Get User Just Updated & Add Log
            if(user= await userModel.get({select:'bin_to_uuid(uid) as uid,name,username,sex,phone,email,role,permissions,port,photo,banned,banned_reason,logined_at,logout_at,last_ip,last_user_agent,created_at,updated_at', filters: {uid: me.id}})){
                const data_json = generalLib.omit(user, 'password') 
                data_json.logined_at = generalLib.formatDateTime(data_json.logined_at)
                data_json.created_at = generalLib.formatDateTime(data_json.created_at)
                data_json.updated_at = generalLib.formatDateTime(data_json.updated_at)
                data_json.logout_at = generalLib.formatDateTime(data_json.logout_at)
                if(!me.port) device = await deviceModel.get({select: 'port', filters: { 'device_id': deviceId }}) 

                // add user_sync record
                await userSyncModel.add({
                    'id': user.uid,
                    'status': 1,
                    'created_at': generalLib.formatDateTime(user.created_at),
                    'updated_at': generalLib.formatDateTime(user.updated_at),
                })

                await activityLogModel.add({
                    id: generalLib.generateUUID(me.port),
                    uid: me.id,
                    ip: generalLib.getIp(req), 
                    port: me.port ? me.port : device.port,
                    record_id: me.id,
                    ref_id: user.username, 
                    device_id: deviceId,
                    record_type: 'users', 
                    action: action ? action :'edit',
                    data: JSON.stringify(data_json)
                }) 
            }
        }
        return res.send({'message': 'updated profile'})
    })
    
    // Users Lists
    app.get('/settings/users', async (req, res) => {
        var total = 0
        let data = []
        const me = req.me
        const filters = Object.assign({}, req.query)

        // Not Allowed
        if(me.role=='report' || me.role=='staff') return res.status(403).send({'message': `Role ${me.role} can not get users.`})
        var select = 'bin_to_uuid(uid) as uid, name, username, phone, email, sex, created_at, role, port, banned, banned_reason, permissions'
        
        if(me.role=='admin'){
            if(me.port==null){
                filters.not_role = ['super_admin']
                filters.not_port = 1                     
            }

            if(me.port){
                filters.port = me.port    
                filters.not_role = ['super_admin', 'admin']        
            } 
        }
    
        if(me.role=='sub_admin'){
            filters.port = me.port
            filters.not_role = ['super_admin', 'admin', 'sub_admin']
        }

        if(limit = req.query.limit){
            filters.limit = limit 
        }  else {
            filters.limit = 30    
        }

        if(offset = req.query.offset) {
            filters.offset = offset 
        } else {
            filters.offset = 0
        }
    
        if(filters && filters.uid){
            if(!generalLib.uuidValidate(filters.uid)) return res.status(422).send({'message': 'params uuid invalid.'})
        }

        // List
        if(result = await userModel.list({select: select, filters:filters})){
            result.forEach(val => {
                data.push({...val})
            })
        }
        
        // Total
        if(result=await userModel.total({filters:filters})){
            total = result[0].total
        }
    
        res.send({'total': total, 'limit': 30 , 'offset': parseInt(filters.offset),  'data': data.length > 0 ? data : null})
    })

    // Get a User
    app.get('/settings/users/:id', async (req, res ) => {
        // const v = uuid.v5()
        const me = req.me    
        let data = null
        var select = 'bin_to_uuid(uid) as uid, name, username, sex, phone, email, role, port, banned, banned_reason, permissions'
        const filters = { uid: req.params.id }
    
        if(!generalLib.uuidValidate(req.params.id)) return res.status(422).send({'message': 'params uuid invalid.'})
        
        if(me.role=='report' || me.role=='staff') return res.status(422).status(403).send({'message': `Role ${me.role} can not get a user.`})

        if(me.role=='admin'){
            if(me.port==null){
                filters.is_port = 0
                filters.not_role = ['super_admin']    
            }

            if(me.port){
                filters.port = me.port    
                filters.not_role = ['super_admin', 'admin']
            }
        }
        
        if(me.role=='sub_admin'){
            filters.port = me.port
            filters.not_role = ['super_admin', 'admin']
        }

        if(result = await userModel.get({select: select, filters: filters})){
            data = result
        } 
        
        res.send({'data': data})
    })

    // Banned a User
    app.patch('/settings/banned/:id', async (req, res) => {
        const body = req.body
        const me = req.me
        const filters = { uid: req.params.id }
        const deviceId = req.headers['device-id'] != undefined && req.headers['device-id'] ? req.headers['device-id'] : null

        if(me.role=='report' || me.role=='staff') return res.status(403).send({'message': `Role ${me.role} can not do this action.`})
    
        if(!generalLib.uuidValidate(req.params.id)) return res.status(422).send({'message': 'params uuid invalid.'})
        if(user=await userModel.get({select: 'bin_to_uuid(uid) as uid,name,username,sex,phone,email,role,permissions,port,photo,banned,banned_reason,logined_at,logout_at,last_ip,last_user_agent,created_at,updated_at',filters: filters})){
            const data_json = generalLib.omit(user, 'password') 
            data_json.logined_at = generalLib.formatDateTime(data_json.logined_at)
            data_json.created_at = generalLib.formatDateTime(data_json.created_at)
            data_json.updated_at = generalLib.formatDateTime(data_json.updated_at)
            data_json.logout_at = generalLib.formatDateTime(data_json.logout_at)
            if(!me.port) device = await deviceModel.get({select: 'port', filters: { 'device_id': deviceId }}) 
            await activityLogModel.add({
                id: generalLib.generateUUID(me.port ? me.port : ''),
                uid: me.id, 
                ip: generalLib.getIp(req), 
                port: me.port ? me.port : device.port,
                record_id: req.params.id, 
                device_id: deviceId,
                ref_id: user.username,
                record_type: 'users', 
                action: 'edit', 
                data: JSON.stringify(data_json)
            })
            const dataBanned = {}
            let status = 'Banned'
            if(body){
                if(body.banned_reason && body.banned_reason.length) dataBanned.banned_reason = req.body.banned_reason 
                if(body.banned && body.banned.length){

                    dataBanned.banned = req.body.banned
                    if(body.banned == 0) {
                        status= 'Unbanned'
                        dataBanned.banned_reason = null
                    }
                } 
            }
            
            await userModel.update(filters.uid, {...dataBanned }, 'uid')
            return res.send({'message': `${status} success`})
        }        
        return res.status(404).send({'message': 'User Not Found'})
    })
}


