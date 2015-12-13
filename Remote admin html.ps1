
function get-localadmins{
  [cmdletbinding()]
 param( [string[]] $computerlist, [string[]] $fileLocation )
 
$date = Get-Date




#table header


$estiloEncabezado = "<style>"
$estiloEncabezado = $estiloEncabezado + "BODY{background-color:white;}"
$estiloEncabezado = $estiloEncabezado + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$estiloEncabezado = $estiloEncabezado + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:red;width: 600px}"

$estiloEncabezado = $estiloEncabezado + "TD:nth-child(2){width: 3000px}"
$estiloEncabezado = $estiloEncabezado + "</style>"

 #create folder
if(!(Test-Path -Path $fileLocation))
{
$createFolderIn = "$fileLocation"
New-Item $createFolderIn -type directory

}
else
{

}
# create header in file
$encabezado = New-Object Object
$encabezado | Add-Member NoteProperty Computadores $null
$encabezado | Add-Member NoteProperty Usuarios $null
$encabezado | ConvertTo-HTML -head $estiloEncabezado  -title "Reporte de administradores Locales" -body "<H2>Usuarios En Grupo Administrador Local $date</H2>" | Out-File -Append $fileLocation\Reporte.html



#input credentials

$credential = Get-Credential refinancia\administrador


foreach ($computer in $computerlist) { 

     





$session = new-pssession -computername $computer -Credential $credential


If ($? -eq $false )
{

$alerta = "La conexión remota de ""PSSRemoting""no pude ser establecida con este equipo por favor verifica WinRM se encuentre habilitado, el servicio de WinRM este corriendo en la máquina. Las excepciones de firewall estén para WinRM estén habilitadas. La política de grupo haya aplicado correctamente o las credenciales usadas tengan los permisos necesarios"
$objectError = New-Object Object
$objectError | Add-Member NoteProperty Computadores $computer
$objectError | Add-Member NoteProperty Usuarios $alerta
$objectError | Select-Object Computadores, Usuarios| ConvertTo-HTML | Out-File -Append $fileLocation\Reporte.html
Get-PSSession |remove-PSSession
}
else
{

$admingroup2 = Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock{

$adminsX = Gwmi win32_groupuser –computer localhost  
$adminsX = $adminsX |? {$_.groupcomponent –like '*"Administradores"' -or $_.groupcomponent -like '*"Administrators"'} 
$arrayError += $adminsX |% { 
$_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
$matches[1].trim('"') + “\” + $matches[2].trim('"') #| % {$_ 
}
  
 
 return $arrayError
}





 
 $admingroup3 = $admingroup2 |Out-String



$Pcname = Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {$env:COMPUTERNAME}



$a = "<style>"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
#$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:red}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white}"
$a = $a + "</style>"   
$object = New-Object Object
$object | Add-Member NoteProperty Computadores $Pcname
$object | Add-Member NoteProperty Usuarios $admingroup3


$object | Select-Object Computadores, Usuarios| ConvertTo-HTML -head $a | Out-File -Append $fileLocation\Reporte.html
Get-PSSession |remove-PSSession

}
Invoke-Expression C:\Scripts\Reporte.html




}
}



get-localadmins RFNSLAPACHE01.refinancia.com.co,RFNSLAPP01.refinancia.com.co,RFNSLAPP02.refinancia.com.co,RFNSLAPP03.refinancia.com.co,RFNSLAPP04.refinancia.com.co,RFNSLAPP05.refinancia.com.co,RFNSLBUS02.refinancia.com.co,RFNSLDB01BK.refinancia.internal,RFNSLDB02.refinancia.com.co,RFNSLDB04.refinancia.internal,RFNSLDB05.refinancia.internal,RFNSLDEV01.refinancia.com.co,RFNSLDEVDB01.refinancia.com.co,RFNSLDEVDB02.refinancia.com.co,RFNSLDOC01.refinancia.com.co,RFNSLLINCE01.refinancia.com.co,RFNSLLINCE01BK.refinancia.internal,RFNSLMAIL02.refinancia.com.co,RFNSLMIGLINCE01.refinancia.com.co,RFNSLRISK01.refinancia.com.co,RFNSLSAB01.refinancia.com.co,RFNSLSD01.refinancia.com.co,MAINSVR.refinancia.com.co,DBSVR.refinancia.com.co,RFNFENIX.refinancia.com.co,RFNBAQ.refinancia.com.co,RFNBUC.refinancia.com.co,RFNCAL.refinancia.com.co,RFNHYPERV.refinancia.com.co,RFNDC02.refinancia.internal,RFNSPRINT01.refinancia.com.co,RFNKASPERSKY01.refinancia.com.co,RFNKASPERSKY02.refinancia.internal,RFNHYPER01.refinancia.internal,RFNMCAFEE01.refinancia.com.co,RFNTELEFONIA.refinancia.com.co,RFNTELEFONIA02.refinancia.com.co,BANKVISION.refinancia.com.co,CTI2.refinancia.com.co,RFNAURAPORTAL01.refinancia.internal -fileLocation  C:\Scripts\
