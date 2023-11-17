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
        const result = 1
        // if(result = await userModel.add(userData)){
        if(result==1){
            // const user =  await userModel.get({select: 'bin_to_uuid(uid) as uid,username, name, phone, sex, email, permissions, port, photo, banned, role, banned_reason, logined_at,logout_at,last_ip,	updated_at, created_at', filters: {'uid': userData.uid}})
            const user = userData
            return res.status(201).send({'data': user })
        }
       return res.status(403).send({'message': 'create fail.'})
    })
}