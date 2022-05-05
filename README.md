# chef-bootstraping
chef bootstrapping for Azure VMs

the variable ValidatorKey hast to hold the validator private key as base64 encoded value, to get the value on windows use folloging powershell command:

   
$bas64Validator = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($(Get-Content -Path <path-to-your-validator.pem> -Encoding utf8 -Raw)))

the parameter -v on the linux side also needs the validator key as base64 encoded value.