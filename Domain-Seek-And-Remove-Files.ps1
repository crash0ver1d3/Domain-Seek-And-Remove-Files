##############################################################################
#  Script: Domain-Seek-And-Remove-Files.ps1
#    Date: 2020.09.18
# Version: 3.5
#  Author: Blake Regan @crash0ver1d3
# Purpose: Identify and delete specific files at scale across domain
#   Legal: Script provided "AS IS" without warranties or guarantees of any
#          kind.  USE AT YOUR OWN RISK.  Public domain, no rights reserved.
#NOTE: This script requires Windows RM to be enabled and run with an account with elevated privileges on target.
#By default, this will work with a account that is a memeber of the local administrators group on the targets
#If you do not want to use domain admin to perform this, you can establish a lower privilege domain account as a member of local adminisrators using 
#Restricted groups and applying via Group Policy


$remove_psexec= {

cd "C:\Tools"

$target = dir -file | Get-ChildItem 
$psexec="PsExec.exe"
$tcpview="Tcpview.exe"
$adexplorer="AdExplorer.exe"
$targets = dir -file | Get-ChildItem
foreach ($target in $targets)
{
   if (Test-Path -Path "C:\Tools") 
   { 
    if ($target.Name -like $psexec -or $target.Name -like $tcpview)
    {
    remove-item $target.Name -force
    write-host
    write-host "$($target.Name) removed"
    }
    }
}
$targets=$null

cd "C:\Tools\Extra's"

$targets = dir -file | Get-ChildItem
foreach ($target in $targets)
{
    if (Test-Path -Path "C:\Tools\Extra's")
    {
    if ($target.Name -like $psexec -or $target.Name -like $adexplorer -or $target.Name -like $tcpview)
    {
    remove-item $target.Name -force
    write-host
    write-host "$($target.Name) removed"
    }
    }
}
exit
}

$root = [ADSI]"LDAP://RootDSE"
$DOMAIN = $root.defaultNamingContext


$hosts=Get-ADComputer -filter * -SearchBase "OU=Servers,$DOMAIN" -Properties Name,OperatingSystem  | where-object {$_.OperatingSystem -like "Windows Server 2008*" -or $_.OperatingSystem -like "Windows Server 2012*" -or $_.OperatingSystem -like "Windows Server 2016*" -or $_.OperatingSystem -like "Windows Server 2019*"} | select-object -Property Name, OperatingSystem
foreach ($server in $hosts)
{
    Invoke-Command -ComputerName $server.Name -ScriptBlock $remove_psexec

}
