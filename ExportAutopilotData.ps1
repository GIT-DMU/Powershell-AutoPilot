<#
	This script can be used on a Windows To Go - USB/HardDrive.
	This script will get the required information for MDM to use Autopilot on the script executed Device.
#>

# Get SerialNumber
$Serialnumber = (Get-CimInstance -Class Win32_BIOS).SerialNumber

# Date 
$date = Get-Date -Format yyyyMMdd

# Create Export-Path
if(!(Test-Path
$Path = ($MyInvocation.MyCommand.Path -replace $MyInvocation.MyCommand.Name, "") + "AutoPilot-Export\"  # This will use Path of the ExportAutopilotData.ps1 and add a AutoPilot-Export directory
if(!(Test-Path $Path) {
	New-Item -ItemType Directory -Path $Path
}
$FileName = $date + "_Autopilot_$serialnumber.csv"
$FullPath = $Path + $FileName
# Get HardwareHash (requires Admin permissions)
$HardwareHash = (Get-CimInstance -Namespace root/CIMV2/mdm/dmmap -ClassName MDM_DevDetail_Ext01).DeviceHardwareData

# Create an Array which will be Exported to the CSV
$output = [PSCustomObject]@{
    "Device Serial Number" = $Serialnumber;
    "Windows Product ID" = "";
    "Hardware Hash" = $HardwareHash
} 

# Create the CSV
$output | Export-Csv -LiteralPath $FullPath -Delimiter "," -Encoding utf8 -Force -NoTypeInformation

# Restart the PC
Restart-Computer -Force
