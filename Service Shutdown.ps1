Write-Host "Stopping all Control Point Services."
Write-Host
$servers = "server01","server02","server03","server04","server05","server06"
$connectors = "Service01","Service02","Service03", "Service04", "Service05", "Service06"
$services = "Distributed Connector", "IDOL", "OGS"
#Stopping Connectors
#Only executed on CPC, CPE, Web01, and DB
for (($i=0); $i -lt 4; $i++){
	$server = $servers[$i]
	foreach ($connector in $connectors){
		if ($connector-eq "Service01"){
			$port = 7202
		} elseif ($connector -eq "Service02"){
			$port = 7802
		} elseif ($connector -eq "Service03"){
			$port = 7302
		} elseif ($connector -eq "Service04"){
            $port = 17122
        } elseif ($connector -eq "Service05"){
            $port = 17222
        } elseif ($connector -eq "Service06"){
            $port = 17036
        }
		$connectorLike = '*' + $connector + '*'
		$isRunning = Get-Service -ComputerName $server | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like $connectorLike -AND $_.DisplayName -notlike '*Framework*'}
		if ($isRunning -ne $null){
			Write-Host "Stopping $connector Connector on $server."
			Invoke-WebRequest -uri "http://${server}:$port/action=stop" | Out-Null
			while ($isRunning.status -eq "running"){
				Start-Sleep -Seconds 5
                $isRunning = Get-Service -ComputerName $server | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like $connectorLike -AND $_.DisplayName -notlike '*Framework*'}
			}
			Write-Host "$connector Connector on $server has stopped."
			Write-Host
		}else {Write-Host "No $connector Connector running on $server." 
            Write-Host
            }
	}
}
#Stopping Connector Frameworks
#Only executed on CPC, CPE, Web01, and DB
for (($i=0); $i -lt 4; $i++){
	$server = $servers[$i]
	foreach ($connector in $connectors){
		if ($connector-eq "Service01"){
			$port = 7252
		} elseif ($connector -eq "Service02"){
			$port = 7852
		} elseif ($connector -eq "Service03"){
			$port = 7352
		}
		$connectorLike = '*' + $connector + '*'
		$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $connectorLike -AND $_.status -eq 'running'}
		if ($isRunning -ne $null){
			Write-Host "Stopping $connector Connector Framework on $server."
			Invoke-WebRequest -uri "http://${server}:$port/action=stop" | Out-Null
			while ($isRunning.status -eq "running"){
				Start-Sleep -Seconds 5
                $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $connectorLike -AND $_.status -eq 'running'}
			}
			Write-Host "$connector Connector Framework on $server has stopped."
			Write-Host
		}else {Write-Host "No $connector Connector Framework running on $server."
               Write-Host
                }
	}
}
#Stopping Metastores
#Only executed on CPC, CPE, and Web01
for (($i=0); $i -lt 3; $i++){
	$server = $servers[$i]
	$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like '*metastore*'}
	if ($isRunning -ne $null){
		Write-Host "Stopping Metastore on $server."
		Invoke-WebRequest -uri "http://${server}:4502/action=stop" | Out-Null
		while ($isRunning.status -eq "running"){
			Start-Sleep -Seconds 5
            $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like '*metastore*'}
		}
		Write-Host "Metastore on $server has stopped."
		Write-Host
	}else {Write-Host "No Metastore running on $server."
        Write-Host
        }
}
#Stopping services on CPE
foreach ($service in $services){
	$server = $servers[1]
	if ($service -eq "Distributed Connector"){
		$port = 7002
	} elseif ($service -eq "IDOL"){
		$port = 9002
	} elseif ($service -eq "OGS"){
		$port = 4059
	}
	$serviceLike = '*' + $service + '*'
	$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
	if ($isRunning -ne $null){
		Write-Host "Stopping $service on $server."
		Invoke-WebRequest -uri "http://${server}:$port/action=stop" | Out-Null
		while ($isRunning.status -eq "running"){
			Start-Sleep -Seconds 5
            $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
		}
		Write-Host "$service on $server has stopped."
		Write-Host
	}else {Write-Host "No $service running on $server."
        Write-Host
        }
}
#Stopping DataAnalysis Store on CPC
$server = $servers[0]
$service = "DataAnalysis Store"
$serviceLike = '*' + $service + '*'
$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
if ($isRunning -ne $null){
	Write-Host "Stopping $service on $server."
	Invoke-WebRequest -uri "http://${server}:31502/action=stop" | Out-Null
	while ($isRunning.status -eq "running"){
		Start-Sleep -Seconds 5
        $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
	}
	Write-Host "$service on $server has stopped."
	Write-Host
}else {Write-Host "No $service running on $server."
        Write-Host
}
#Stopping Content Engines on CPE
$ports = 32002, 32052, 32102, 32152, 32202, 32252
$server = $servers[1]
for (($i=0); $i -lt 6; $i++){
	$service = "Content" + ($i+1)
	$serviceLike = '*' + $service + '*'
	$port = $ports[$i]
	$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
	if ($isRunning -ne $null){
		Write-Host "Stopping $service on $server."
		Invoke-WebRequest -uri "http://${server}:$port/action=stop" | Out-Null
		while ($isRunning.status -eq "running"){
			Start-Sleep -Seconds 5
            $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
		}
		Write-Host "$service on $server has stopped."
		Write-Host
	}else {Write-Host "No $service running on $server."
        Write-Host
        }
}
#Stopping License Server on CPC
$server = $servers[0]
$service = "License Server"
$serviceLike = '*License Server*'
$isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
if ($isRunning -ne $null){
	Write-Host "Stopping $service on $server."
	Invoke-WebRequest -uri "http://${server}:20002/action=stop" | Out-Null
	while ($isRunning.status -eq "running"){
		Start-Sleep -Seconds 5
        $isRunning = Get-Service -ComputerName $server | Where-Object {$_.DisplayName -like $serviceLike -AND $_.status -eq 'running'}
	}
	Write-Host "$service on $server has stopped."
	Write-Host
}else {Write-Host "No $service running on $server."
    Write-Host
}
#Stopping remainder services
Write-Host "Stopping ControlPoint Redirector on server02."
$service = Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*ControlPoint Redirector*'}
Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*ControlPoint Redirector*'} | Stop-Service
while ($service.status -ne "Stopped"){
    Start-Sleep -Seconds 1
    $service = Get-Service -ComputerName server02 | Where-Object {$_.DisplayName -like '*ControlPoint Redirector*'}
}
Write-Host "Stopping ControlPoint DataAnalysis Services on server02."
$service = Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*DataAnalysis*'}
Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*DataAnalysis*'} | Stop-Service
while ($service.status -ne "Stopped"){
    Start-Sleep -Seconds 1
    $service = Get-Service -ComputerName server02 | Where-Object {$_.DisplayName -like '*DataAnalysis*'}
}
Write-Host "Stopping ControlPoint Engine on server02."
$service = Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*ControlPoint Engine*'}
Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*ControlPoint Engine*'} | Stop-Service
while ($service.status -ne "Stopped"){
    Start-Sleep -Seconds 1
    $service = Get-Service -ComputerName server02 | Where-Object {$_.DisplayName -like '*ControlPoint Engine*'}
}
Write-Host "Stopping ControlPoint License Service on server02."
Get-Service -ComputerName server02 | Where-Object {$_.status -eq 'running' -AND $_.DisplayName -like '*ControlPoint License*'} | Stop-Service

