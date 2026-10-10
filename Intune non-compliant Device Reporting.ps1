# ==========================================
# Intune Non-Compliant Device Reporting
# ==========================================

try {

    # Connect to Microsoft Graph

    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All" -ErrorAction Stop

    Write-Host "Connected to Microsoft Graph Successfully" -ForegroundColor Green

    # Get Non-Compliant Devices

    $Devices = Get-MgDeviceManagementManagedDevice -All |
    Where-Object {
        $_.ComplianceState -eq "noncompliant"
    }

    # Create Dynamic Report Name

    $Date = Get-Date -Format "yyyy-MM-dd_HH-mm"

    $ReportPath = "C:\Temp\NonCompliantDevices_$Date.csv"

    # Export Report

    $Devices |
    Select-Object `
        DeviceName,
        UserPrincipalName,
        Manufacturer,
        Model,
        OperatingSystem,
        OSVersion,
        ComplianceState,
        LastSyncDateTime |
    Export-Csv `
        -Path $ReportPath `
        -NoTypeInformation

    # Display Summary

    Write-Host ""
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host " Intune Compliance Report Summary " -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "Total Non-Compliant Devices : $($Devices.Count)"
    Write-Host "Report Location             : $ReportPath"
    Write-Host "Generated Time              : $(Get-Date)"
    Write-Host ""

    # Compliance Status Message

    if ($Devices.Count -gt 0)
    {
        Write-Host "ATTENTION: Non-Compliant Devices Detected!" -ForegroundColor Yellow
    }
    else
    {
        Write-Host "All Devices Are Compliant." -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Intune Non-Compliant Device Report Generated Successfully." -ForegroundColor Green

}
catch {

    Write-Host ""
    Write-Host "ERROR OCCURRED" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

}