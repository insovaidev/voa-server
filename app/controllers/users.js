const userModel = require("../models/userModel");

module.exports = function(app){
    // Central
    app.post('/users/create', async (req, res) => {
        const body = req.body
        console.log(body)
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
        const result = 0
        // if(result = await userModel.add(userData)){
        if(result == 1){
            return res.status(201).send({'message': 'created success'})
        }
       return res.status(403).send({'message': 'create fail.'})
    })
}