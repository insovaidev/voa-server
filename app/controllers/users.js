const userModel = require("../models/userModel");

module.exports = function(app){

    app.post('/users/create', async (req, res) => {
        const body = req.body
        
        const userData = {
            'username': body.username,
            'name': body.name,
            'sex': body.sex,
            'password':  body.password,
            'role': body.role,
            'permissions': body.permissions,
            'port': body.port,
            'uid': body.uid,
            'last_user_agent': body.last_user_agent,
            'last_ip': body.last_ip,
        }
        const result =  true
        // if(result = await userModel.add(userData)){
        if(result){
            return res.status(201).send({'message': 'created success'})
        }
    
        res.status(403).send({'message': 'create fail.'})
    })
}