# Step 1: Open Registry and find the ImagePath for MicrosoftEdgeUpdate.exe
$edgeUpdateRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\edgeupdate"
$imagePath = (Get-ItemProperty -Path $edgeUpdateRegPath).ImagePath

# Step 2: Extract the path to the MicrosoftEdgeUpdate.exe from ImagePath
$edgeUpdateExePath = $imagePath -replace '\"','' -replace " /svc", ""

# Step 3: Display the corresponding MicrosoftEdgeUpdate.exe and its path
if ($edgeUpdateExePath) {
    Write-Output "MicrosoftEdgeUpdate.exe found at path: $edgeUpdateExePath"
} else {
    Write-Output "MicrosoftEdgeUpdate.exe path not found in the registry."
    Exit
}

# Step 4: Open Terminal as Admin and add a firewall rule to block Edge updates
$firewallRuleName = "Disable Edge Updates"

# Check if firewall rule already exists
$ruleExists = (netsh advfirewall firewall show rule name=$firewallRuleName | Select-String $firewallRuleName)

if ($ruleExists) {
    Write-Output "Firewall rule to disable Edge updates already exists."
} else {
    Write-Output "Adding firewall rule to block Microsoft Edge updates..."
    Start-Process "netsh" -ArgumentList "advfirewall firewall add rule name='$firewallRuleName' dir=out action=block program='$edgeUpdateExePath'" -Verb RunAs
    Write-Output "Microsoft Edge updates have been disabled."
}

# Step 5: Confirm completion
Write-Output "Script execution complete. Microsoft Edge will no longer download or install updates."
