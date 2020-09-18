##############################################################################
#  Script: Get-LocalMembership-Domain.ps1
#    Date: 2020.09.18
# Version: 3.5
#  Author: Blake Regan @blake_r38
# Purpose: Identify accounts in local groups on domain joined windows workstations
#   Legal: Script provided "AS IS" without warranties or guarantees of any
#          kind.  USE AT YOUR OWN RISK.  Public domain, no rights reserved.



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