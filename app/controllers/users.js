const userModel = require("../models/userModel");

module.exports = function(app){

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
        
        try {
            await userModel.add(userData)
            const user =  await userModel.get({select: 'bin_to_uuid(uid) as uid,username, name, phone, sex, email, permissions, port, photo, banned, role, banned_reason, logined_at,logout_at,last_ip,	updated_at, created_at', filters: {'uid': userData.uid }})
            return res.status(200).send({'data': user })
        } catch (error) {
            // console.log(error)
        }
        return res.status(200).send({'status': 403, 'message': 'create user fail.'})
    })

    app.post('/users/update/:id', async (req, res) => {
        const id = req.params.id
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

        console.log(userData)
        
        // try {
        //     await userModel.update(id, userData)
        //     const user =  await userModel.get({select: 'bin_to_uuid(uid) as uid,username, name, phone, sex, email, permissions, port, photo, banned, role, banned_reason, logined_at,logout_at,last_ip,	updated_at, created_at', filters: {'uid': userData.uid }})
        //     return res.status(200).send({'data': user })
        // } catch (error) {
        //     // console.log(error)
        // }


        return res.status(200).send({'status': 403, 'message': 'create user fail.'})
    })
}