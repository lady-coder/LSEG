param (
    [Parameter(Position=0)]
    [string]$userName,
    [Parameter(Position=1)]
    [string]$Password
)
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

$user = Get-LocalUser -Name $userName -ErrorAction SilentlyContinue

if ($user) {
    Write-Output "User '$userName' already exists! Updating the password for '$userName'."
    Set-LocalUser $userName -Password $securePassword -PasswordNeverExpires $false
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $userName -ErrorAction SilentlyContinue
    Add-LocalGroupMember -Group "Administrators" -Member $userName -ErrorAction SilentlyContinue
} else {
    Write-Output "User '$userName' does not exist! Creating an account for '$userName'."
    New-LocalUser $userName -Password $securePassword
    Set-LocalUser $userName -PasswordNeverExpires $false
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $userName
    Add-LocalGroupMember -Group "Administrators" -Member $userName
    Write-Output "Added $userName to the Remote Desktop Users & Administrators Group."
}