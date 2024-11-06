$scriptDate = (Get-Date).toString("yyyyMMddHHmmss")
$logFileName = "C:\Temp\CustomScripts\WindowsUpdate_$scriptDate.log"
function logMessage( $logLevel, $msgText ) {
    $logStamp = (Get-Date).toString("yyyy-MM-dd HH:mm:ss")
    $content = "$logStamp  $logLevel  $msgText"
    Write-Host $content
    Add-Content -Value $content -Path $logFileName
}

try {
    logMessage("INFO", "Getting Proxy")
    $regKeyallusers="HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $httpProxy = "http://" + (Get-ItemProperty -path $regKeyallusers).ProxyServer
} catch {
    logMessage("ERROR", "Error Getting Proxy: $($_.Exception.Message)")
}
logMessage("INFO", "Using Proxy:  $httpProxy")

logMessage("INFO", "Checking Pre-Requisites")
$pp = Get-PackageProvider -ListAvailable | where {$_.Name -eq 'NuGet'}
if($pp.Name.Length -eq 0) {
    try {
        logMessage("INFO", "Installing NuGet Provider")
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Scope AllUsers -Name NuGet -MinimumVersion 2.8.5.201 -Force -Proxy $httpProxy
    } catch {
        logMessage("ERROR", "Package Provider Failed: $($_.Exception.Message)")
    }
}

try {
    $psr = Get-PSRepository | where {$_.Name -eq 'PSGallery'}
    if($psr.Name.Length -eq 0) {
        logMessage("INFO", "PSGallery Not Found - Installing")
        Register-PSRepository -Default -InstallationPolicy Trusted
    } else {
        logMessage("INFO", "PSGallery Found: $($psr.SourceLocation)")
    }
} catch {
    logMessage("ERROR", "Repo Setup Failed: $($_.Exception.Message)")
}

$um = Get-Module -ListAvailable | where {$_.Name -eq 'PSWindowsUpdate'}
if($um.Name.Length -eq 0) {
    try {
        logMessage("INFO", "Installing Windows Update PS Package")
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module -Scope AllUsers -Name PSWindowsUpdate -RequiredVersion 2.1.0.1 -Force
    } catch {
        logMessage("ERROR", "Windows Update Package Failed: $($_.Exception.Message)")
    }
}

try {
    $wim = (Get-WmiObject Win32_LocalTime).weekinmonth
    if($wim -eq 2) {
        logMessage("INFO", "Beginning Windows Updates")
        Start-Service -Name wuauserv
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        Stop-Service -Name wuauserv
        logMessage("INFO", "Completed Windows Updates")
    }
} catch {
    logMessage("ERROR", "Update Windows Failed: $($_.Exception.Message)")
}
   