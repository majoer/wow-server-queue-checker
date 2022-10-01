param (
  $Debug = $false,
  $DiscordUserId,
  $DiscordUserName,
  $InGamePort = 6724,
  $LobbyPort = 3724,
  $QueuePort = 1119,
  $WebHook
)

function Invoke-Script() {
  $WowProcessId = (Get-Process -name "WowClassic").id

  if ($null -eq $WowProcessId) {
    Write-Host "Wow classic not found. Is it running?"
    return
  }
  
  Write-Host "Found wow process: $WowProcessId"

  $WowSockets = Get-NetTcpConnection -OwningProcess $WowProcessId

  if ($debug) { Out-Host -InputObject $WowSockets }
  
  if (Test-TcpConnectionIsEstablished $WowSockets $QueuePort) {
    Write-Host "Found connection to queue port $QueuePort. Assuming user is in queue"
    Send-Discord("$DiscordUserName is in queue")
    
    return
  }
  
  if (Test-TcpConnectionIsEstablished $WowSockets $InGamePort) {
    Write-Host "Found connection to server port $InGamePort. Assuming user is playing on a server"
    Send-Discord("$DiscordUserName is playing")
   
    return
  }

  if (Test-TcpConnectionIsEstablished $WowSockets $LobbyPort) {
    Write-Host "Found connection to lobby port $LobbyPort. Assuming user is in lobby"
    Send-Discord("Warning: <@$DiscordUserId> is in lobby")
    
    return
  }
  
  Write-Host "No checks passed. User is probably disconnected!"
  Send-Discord("Wow is running and <@$DiscordUserId> is Disconnected!")
}

function Test-TcpConnectionIsEstablished($WowSockets, $Port) {
  Foreach ($Socket in $WowSockets) {
    If (($Socket.RemotePort -eq $Port) -and ($Socket.State -eq "Established")) {
      return $true
    }
  }

  return $false
}

function Send-Discord($Message) {
  $Date = Get-Date
  $Body = "{`"content`": `"$Date - $Message`"}"
  $ContentType = "application/json"
  Invoke-RestMethod -Method "POST" -Uri "$WebHook" -Body "$Body" -ContentType "$ContentType"
}

Invoke-Script
