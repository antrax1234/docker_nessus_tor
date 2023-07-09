$id = (docker ps | Select-String -Pattern "nessus")[0].ToString().Split(' ')[0]
cls 
docker exec -ti -u root $id bash