# To Run 
    - npm i 
    - Rename file 'example.sync_logs' to 'sync_logs'
    - Rename file 'example.env' to '.env'
    - Change database name in config.js      
# Sync Data URL
    Invoke-WebRequest -Uri "https://baseUrl/sync/sync_data" -Method GET
    