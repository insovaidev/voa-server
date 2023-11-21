## update

- get users where:
    const users1 = await userModel.get({select: '*', filters: {'port': null}}) // SELECT * FROM `users` WHERE port IS NULL;
    const ports = await portModel.list({select: '*', filters: {'published':1}}) 
    const users2 = await userModel.get({select: '*', filters: {'ports': ports}}) // SELECT * FROM `users` WHERE port IN (ports);
    return users =  merge array
    
    
