Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name vmware.powercli

# Set powercli
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers
