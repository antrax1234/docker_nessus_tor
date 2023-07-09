if (Test-Connection -ComputerName www.google.com -Count 1 -Quiet) {
    $x = Read-Host "¿Quieres Conectarte a tor? y/n: "
    Write-Host "Nessus se esta levantando, espera"
    if ($x -eq "y" -or [string]::IsNullOrEmpty($x)) {
        docker-compose up -d > $null
        $id = (docker ps | Select-String -Pattern "nessus")[0].ToString().Split(' ')[0]
        Start-Sleep -Seconds 4
        docker exec -ti -u root $id service tor start > $null
        docker exec -ti -u root $id bash /usr/bin/anonsurf start > $null
        Start-Sleep -Seconds 3
        Write-Host "Esta es la url para el acceso https://localhost:8443"
        $ip = docker exec -ti -u root $id curl -s icanhazip.com | ForEach-Object { $_.ToString().Trim() }
        Write-Host "Esta es la ip publica del contenedor"
        $response = Invoke-RestMethod -Uri "https://ipinfo.io/$ip"
        $response.PSObject.Properties.Value | ForEach-Object { $_.ToString().Replace("{", "").Replace("}", "").Replace('"', "").Replace(",", "") | Where-Object { $_ -notmatch "readme" } }
        $p = Read-Host "¿Quieres iniciar el server proxy? y/n: "
        if ($p -eq "y" -or [string]::IsNullOrEmpty($p)) {
            Write-Host "Puerto del proxy 5000"
            Write-Host "Para cerrar el server proxy pulsa ctrl + c "
            docker exec -ti -u root $id tinyproxy -d
            $port = (docker ps | Select-String -Pattern "nessus")[0].ToString().Split(' ')[12].Replace(">", "").Replace("/", "").Replace(":", "").Replace("-", "")
        }
    }
    elseif ($x -eq "n") {
        docker-compose up -d > $null
        Start-Sleep -Seconds 2
        $id = (docker ps | Select-String -Pattern "nessus")[0].ToString().Split(' ')[0]
        Write-Host "Esta es la url para el acceso https://localhost:8443"
    }
    else {
        Write-Host "Error vuelve a intentarlo"
        Start-Sleep -Seconds 2
        Clear-Host
        & ./start.sh
    }
}
else {
    $y = Read-Host "No tienes acceso a internet, seguro que quieres arrancar el contenedor? y/n: "
    if ($y -eq "y" -or [string]::IsNullOrEmpty($y)) {
        docker-compose up -d > $null
        Start-Sleep -Seconds 3
        $id = (docker ps | Select-String -Pattern "nessus")[0].ToString().Split(' ')[0]
        Start-Sleep -Seconds 2
        Write-Host "Esta es la url para el acceso https://localhost:8443"
    }
    else {
        Write-Host "Gracias por utilizar el programa"
    }
}

