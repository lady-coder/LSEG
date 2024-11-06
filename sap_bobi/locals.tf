locals {
  preferred_subnet_id = tolist(data.aws_subnets.subnet-2a.ids)[0]
  multiaz_subnets_ids = flatten(concat(data.aws_subnets.subnet-2a.ids, data.aws_subnets.subnet-2b.ids))
  common_name = [
    "sap",
    "boxi"
  ]
  additional_names = var.enable_testing ? concat(local.common_name, [join("", random_string.random.*.result)]) : local.common_name
}

locals {
  user_data_base64 = <<EOF
<powershell>
#Function to store log data
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )
    [pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $Message
    } | Export-Csv -Path "C:\Temp\CLIInstallLog.log" -Append -NoTypeInformation
}
Try {
    $CurrentUACValue = Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin
    if(-not($CurrentUACValue -match 0)) {
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0
        Restart-Computer -Force
    }
} catch {}

Try {
    $InstalledAwsVersion = $(aws --version) | Out-String -ErrorAction SilentlyContinue
} Catch{}
if (-not($InstalledAwsVersion -match "aws-cli/")) {
    Write-Log -Message "AWS CLI not installed and will be installed"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("https://nexus.lseg.stockex.local/repository/aws-cloud-engineering-release/awscli-bundle/windows/awscli-msi-64bit-1.12.106.msi", "C:\Temp\AWSCLIV1.msi")
    Start-Process msiexec.exe -Wait -ArgumentList '/i C:\Temp\AWSCLIV1.msi  /qn /l*v C:\Temp\aws-cli-install.log' -Verb runAs
    #Dont think this will work as the Proxy isn't set at this point
    #Start-Process msiexec.exe -Wait -ArgumentList '/i https://awscli.amazonaws.com/AWSCLIV2.msi  /qn /l*v C:\Temp\aws-cli-install.log' -Verb runAs
    Write-Log -Message "Installed AWS CLI"
}
$progressPreference = 'silentlyContinue'
Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"
rm -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Restart-Service AmazonSSMAgent
</powershell>
EOF
}

locals {
  lb_ec2_cms_targets = {
    for id in data.aws_instances.bobi_cms.ids : "cms-${id}" => { target_id : id, port : 8080 }
  }
  cms_lb_host_name = var.enable_testing ? join("-", [var.cms_lb_host_name], [join("", random_string.random.*.result)]) : var.cms_lb_host_name
}
