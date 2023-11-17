URL
http://localhost:8081/syncs/users_from_central
http://localhost:8081/syncs/users_profile_to_central
http://localhost:8081/syncs/ports_from_central
http://localhost:8081/syncs/visa_types_from_central
http://localhost:8081/syncs/countries_from_central
http://localhost:8081/syncs/activity_logs_to_central
http://localhost:8081/syncs/checklists_to_central
http://localhost:8081/syncs/passports_to_central
http://localhost:8081/syncs/visas_to_central
http://localhost:8081/syncs/printed_visas_to_central
http://localhost:8081/syncs/deleted_visas_to_central



SCRIPT POWERSHELL

PowerShell Invoke-WebRequest -Uri "http://192.168.88.209:8081/syncs/users_from_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://192.168.66.8:8081/syncs/users_profile_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://192.168.66.8:8081/syncs/ports_from_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://192.168.66.8:8081/syncs/visa_types_from_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://localhost:8081/syncs/countries_from_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://192.168.66.8:8081/syncs/activity_logs_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://192.168.66.8:8081/syncs/checklists_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://localhost:8081/syncs/passports_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://localhost:8081/syncs/visas_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://localhost:8081/syncs/printed_visas_to_central" -Method POST;
PowerShell Invoke-WebRequest -Uri "http://localhost:8081/syncs/deleted_visas_to_central" -Method POST;


PowerShell Invoke-WebRequest -Uri "http://192.168.196.8:8081/syncs/sync_data" -Method GET;
