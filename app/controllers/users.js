const userModel = require("../models/userModel");

module.exports = function(app){
    // Central
    app.post('/users/create', async (req, res) => {
        const body = req.body

        if(exist = await userModel.get({select:'username', filters: { username: body.username }})) {
            return res.status(200).send({'status': 422, 'message': 'username already exist.'})
        } 
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

        // const result = 0
        if(result = await userModel.add(userData)){
        // if(result == 1){
            const user =  await userModel.get({select: 'bin_to_uuid(uid) as uid,username, name, phone, sex, email, permissions, port, photo, banned, role, banned_reason, logined_at,logout_at,last_ip,	updated_at, created_at', filters: {'uid': userData.uid}})
          console.log(user)
            // const user = {
            //     "uid": "f5d68f76-607b-5bcd-a978-25958fb56bf1",
            //     "username": "u001",
            //     "name": "user 001",
            //     "phone": null,
            //     "sex": "f",
            //     "email": null,
            //     "permissions": null,
            //     "port": null,
            //     "photo": null,
            //     "banned": 0,
            //     "role": "staff",
            //     "banned_reason": null,
            //     "logined_at": "2023-11-17T16:25:54.000Z",
            //     "logout_at": "2023-10-04T09:57:06.000Z",
            //     "last_ip": "192.168.196.8",
            //     "updated_at": "2023-11-17T16:25:54.000Z",
            //     "created_at": "2023-08-03T19:29:11.000Z"
            // }
            return res.status(200).send({'data': user })
        }
        return res.status(200).send({'status': 403, 'message': 'create user fail.'})
    })
}