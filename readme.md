# To Run 
    - npm install 
    - Rename file 'example.sync_logs' to 'sync_logs'
    - Rename file 'example.env' to '.env'
    - Change database name in config.js      

# Sync Data URL 
    Invoke-WebRequest -Uri "https://baseUrl/syncs/sync_data" -Method GET 


- admin, port != null
- report
-  

SELECT * FROM `users`
WHERE role not in('super_admin') AND



SELECT username, role, port FROM `users` WHERE (role = 'admin' AND port IS NOT NULL) OR (role = 'report' AND (port IS NULL OR port IS NOT NULL)) OR role = 'staff';

if admim.port = null
WHERE (role = 'admin' AND port IS NOT NULL) OR role in ('report', 'staff', 'sub_admin');

if admin != null
WHERE role in ('report', 'staff', 'sub_admin');

if(sub_admin) 
WHERE (role = 'report' AND port IS NOT NULL) OR role = 'staff';


## to update 