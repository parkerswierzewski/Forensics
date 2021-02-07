# Windows System Info v1.0
#
# author: Parker Swierzewski
# lanugage: Powershell Script
# desc: This script will obtain system information on Windows systems.
#
# Note: This was tested only on a Windows 10 system. Ouput
#			may vary on different Windows versions.

clear

# System Time Information
Write-Host -NoNewLine "---- Time ----"
Get-Date
Get-CimInstance -ClassName Win32_OperatingSystem | Select LastBootUpTime

# System OS Information
Write-Host -NoNewLine "---- OS Information ----"
Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, OSArchitecture, BootDevice

# System Spec Information
Write-Host -NoNewLine "---- System Specs ----"
Get-WmiObject -Class Win32_processor

Write-Host -NoNewLine "Amount of Free and Used Physical Memory:"
Get-WmiObject -Class Win32_LogicalDisk

Write-Host "Total Physical Memory:"
(gwmi -Class Win32_computersystem).totalphysicalmemory

Write-Host -Separator ""
Write-Host "Paritions:"
Get-Disk | Get-Partition

Write-Host -Separator ""
Write-Host "Hostname:"
(gwmi -Class Win32_operatingsystem).csname

Write-Host -Separator ""
Write-Host "Domain:"
(gwmi -Class Win32_computersystem).domain

# Network Information
Write-Host -Separator ""
Write-Host -NoNewLine "---- Network ----"
getmac /v

Write-Host -Separator ""
Write-Host -NoNewLine "IPv4 and IPv6 Address:"
Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $env:COMPUTERNAME | Where-Object { $_.IPaddress -ne $null }

Write-Host -Separator ""
Write-Host -NoNewLine "Promiscuous Mode:"
Get-NetAdapter | Format-List -Property PromiscuousMode

Write-Host -Separator ""
Write-Host "Established Network Connections:"
Get-NetTCPConnection -State Established | Select-Object -First 15

# Processes and File Information
Write-Host -Separator ""
Write-Host -NoNewLine "---- Processes and Open Files ----"
Get-Process | Select-Object -First 5

Write-Host -Separator ""
Write-Host "Netcat Process(es):"
Get-Process nc | Format-List *

Write-Host -Separator ""
Write-Host -NoNewLine "Linked Files (In Current Directory):"
dir | Where { $_.Extension -eq ".lnk" }

# Miscellaneous
Write-Host -Separator ""
Write-Host "---- Miscellaneous ----"
Write-Host "Files Modified Within a Day:"
Get-ChildItem -Path $env:HOMEPATH | Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-1) } | Select-Object FullName

Write-Host -Separator ""
Write-Host "Windows Events:"
Get-EventLog -List | %{ Get-EventLog $_.Log } | Select-Object -First 5 | Select-Object EventID, Source, EntryType, TimeGenerated, TimeWritten, Username, Site, Container, Message

Write-Host -Separator ""
Write-Host "Windows Security Logs:"
Get-WinEvent -LogName "Security" | Select-Object -First 5

Write-Host -Separator ""
Write-Host "Startup Item(s):"
Get-CimInstance win32_service -Filter "startmode = 'auto'" | Select-Object -First 5

# User Information
Write-Host -Separator ""
Write-Host "---- Users ----"
Write-Host "Currently Logged On:"
query user

Write-Host -Separator ""
Write-Host "Logged On from a Remote System:"
net sessions 

Write-Host -Separator ""
Write-Host -NoNewLine "List of Administrator User(s):"
Get-LocalGroupMember -Group "Administrators"
