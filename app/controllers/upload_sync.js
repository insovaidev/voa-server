const config = require('../config/config')
const fileLib = require('../libraries/fileLib')
const passwordLib = require('../libraries/passwordLib')
let  formidable = require('formidable')
const sizeOf = require('image-size')


module.exports = function(app) {

    app.post('/upload_sync', async (req, res, next) => {        
        const form = new formidable.IncomingForm()
        const [fields, files] = await form.parse(req)

        if(files && files.file && files.file.length) {
            const file = files.file[0]
            const attachments = req.headers.attachments

            try {
                if(!fileLib.exist(config.uploadDir+attachments)){
                    if(fileLib.copy(file.filepath, config.uploadDir+attachments, true)){
                        // console.log('upload')          
                    }
                }
            } catch (error) {
                next()
            }
        }
        
        return res.status(200).send({'message': 'Nothing is update'})

    }) 

}