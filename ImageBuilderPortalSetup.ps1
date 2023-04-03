# For more information, see:
# https://learn.microsoft.com/en-us/azure/virtual-machines/image-builder-overview?WT.mc_id=AZ-MVP-5004159

# Register Features
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute, Microsoft.KeyVault, Microsoft.Storage, Microsoft.VirtualMachineImages, Microsoft.Network, Microsoft.ManagedIdentity |
  Where-Object RegistrationState -ne Registered |
    Register-AzResourceProvider


# Create Managed Identity and Role

# Destination image resource group name
$imageResourceGroup = '<Resource Group Name>'

# Azure region
$location = '<Location>'

# Get the subscription ID
# Be sure to log into the correct subscriptoin with Connect-AzAccount
# Your Azure Subscription ID
$subscriptionID = (Get-AzContext).Subscription.Id
Write-Output $subscriptionID

# Create the resouce group for the managed identity and deployments
New-AzResourceGroup -Name $imageResourceGroup -Location $location

# Create a unique identity name based on the time
[int]$timeInt = $(Get-Date -UFormat '%s')
$imageRoleDefName = "Azure Image Builder Image Def $timeInt"
$identityName = "myIdentity$timeInt"
Write-Output $identityName

# Create the User Idneity and store the identity as variables for the next step
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location
$identityNameResourceId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id
$identityNamePrincipalId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId

# Download the JSON role deffiniton template
$myRoleImageCreationUrl = 'https://raw.githubusercontent.com/azure/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json'
$myRoleImageCreationPath = "myRoleImageCreation.json"
Invoke-WebRequest -Uri $myRoleImageCreationUrl -OutFile $myRoleImageCreationPath -UseBasicParsing

# Update the role deffiniton template
$Content = Get-Content -Path $myRoleImageCreationPath -Raw
$Content = $Content -replace '<subscriptionID>', $subscriptionID
$Content = $Content -replace '<rgName>', $imageResourceGroup
$Content = $Content -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName
$Content | Out-File -FilePath $myRoleImageCreationPath -Force

# Create the new role deffinition
New-AzRoleDefinition -InputFile $myRoleImageCreationPath

# Grant the role deffinition to the identity at the resource group scope
$RoleAssignParams = @{
  ObjectId = $identityNamePrincipalId
  RoleDefinitionName = $imageRoleDefName
  Scope = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"
}
New-AzRoleAssignment @RoleAssignParams

# Code for image build

# Inline Command
New-Item -Type Directory -Path 'c:\\' -Name temp,
invoke-webrequest -uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'c:\\temp\\azcopy.zip',
Expand-Archive 'c:\\temp\\azcopy.zip' 'c:\\temp',
copy-item 'C:\\temp\\azcopy_windows_amd64_*\\azcopy.exe\\' -Destination 'c:\\temp'
