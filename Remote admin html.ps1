
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

$credential = Get-Credential contoso\administrador


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



get-localadmins pc1,pc2,pc3 -fileLocation  C:\Scripts\
