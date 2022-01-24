[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ChefClientVersion,
    # Parameter help description
    [Parameter()]
    [string]
    $ValidatorKey,
    # Parameter help description
    [Parameter()]
    [string]
    $PolicyGroup,
    # Parameter help description
    [Parameter()]
    [string]
    $PolicyName,
    # Parameter help description
    [Parameter()]
    [string]
    $ChefServerURL,
    # Parameter help description
    [Parameter()]
    [string]
    $ChefValidationClientName
)

### Install chef client
. { Invoke-WebRequest -useb https://omnitruck.chef.io/install.ps1 } | Invoke-Expression; install -version $ChefClientVersion

$nodename = $env:computerName

$pathValidationKey = "C:\chef\" + $ChefValidationClientName + ".pem"
$validator = $ValidatorKey.Replace("*lb*", "`n")

Set-Content -Path $pathValidationKey -Value "$validator"

$clientrb = @"
chef_license            'accept'
log_location            STDOUT
chef_server_url         "$ChefServerURL"
validation_client_name  "$ChefValidationClientName"
validation_key          "$pathValidationKey"
node_name               "$nodename"
policy_group            "$policygroup"
policy_name             "$policyname"
"@

Set-Content -Path c:\chef\client.rb -Value $clientrb

### Run Chef-client
c:\opscode\chef\bin\chef-client.bat