const db = require('../services/dbService')

const table = "countries"

module.exports = {

    get: async function(id, idType="code") {
        return await db.select('*').table(table).where(idType, id).first()
    },
    gets: async function(){

        const q = db(table)
        // Select
        q.select(db.raw('bin_to_uuid(id) as id ,code,name,nationality,published'))
        
        // Sort
        q.orderBy('name', 'ASC')

        // Return Result
        const result = await q
        return result && result.length ? result : null
    },

    sync: async function({select=null,  filters}={}){
        const q = db(table + ' as c')  

        // Select Fields
        q.select()
        if(select) q.select(db.raw(select))  
        
        // Join table
        q.join(db.raw('countries_sync'+' as s on c.id=s.id'))
        
        // Sort
        q.orderBy('s.sid', 'asc')

        // Where condition
        if(filters){
            if(filters.sid) q.where('s.sid', '>', filters.sid)
        }

        // Return 
        const result = await q;
        return result && result.length ? result : null
    },
}