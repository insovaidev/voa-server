


        
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