# Script de consulta de Active Directory en PowerShell - Lucas S. Paniagua Baez -

$nueva_consulta = $true
while ($true) {
# Solicitar al usuario que ingrese el login para consultar

    if($nueva_consulta -eq $true){
    $usuario = Read-Host -Prompt "Ingrese el login del usuario"
    cls
    }
    # Realizar la consulta en Active Directory
    $usuarioAD = Get-AdUser -Filter {SamAccountName -eq $usuario} -Properties DisplayName,EmailAddress,SamAccountName,Department,Enabled,LockedOut,MemberOf,msDS-UserPasswordExpiryTimeComputed,PwdLastSet,Manager,OfficePhone
        Write-Host "USUARIO: $($usuarioAD.SamAccountName)"
    # Verificar si existe el usuario
    if ($usuarioAD -ne $null) {
        Write-Host "`n`n    -------  Datos del usuario  -------`n"
        Write-Host " Nombre completo: $($usuarioAD.DisplayName)"
        Write-Host " Correo electronico: $($usuarioAD.EmailAddress)"
        Write-Host " Departamento: $($usuarioAD.Department)"
        Write-Host " Interno: $($usuarioAD.OfficePhone)"
        if($usuarioAD.Manager -ne $null){
            Write-Host " Superior inmediato: $((Get-AdUser -Identity $usuarioAD.Manager -Properties DisplayName).DisplayName) ($((Get-AdUser -Identity $usuarioAD.Manager -Properties DisplayName).SamAccountName))"
        }else{
            Write-Host " Superior inmediato: No tiene un superior asignado en el AD"
            }
        # Validar si no esta de vacaciones, bloqueado, deshabilitado
        Write-Host "`n`n    -------  Situacion actual del usuario  -------`n"
        if($usuarioAD.Enabled -eq $true){
        Write-Host " La cuenta se encuentra habilitada - OK`n"
        }else{
        Write-Host " La cuenta se encuentra DESHABILITADA!! - TODO MAL`n" }
  
        if($usuarioAD.LockedOut -eq $true){
        Write-Host " La contraseña se encuentra BLOQUEADA!! - TODO MAL`n"
        }else{
        Write-Host " La contraseña se encuentra desbloqueada - OK`n" }
        Write-Host " Ultimo cambio de contraseña: $([System.DateTime]::FromFileTime($usuarioAD.'PwdLastSet').ToString('dd-MM-yyyy HH:mm:ss'))"
        Write-Host " Fecha de expiracion de contraseña: $([System.DateTime]::FromFileTime($usuarioAD.'msDS-UserPasswordExpiryTimeComputed').ToString('dd-MM-yyyy HH:mm:ss'))"

        if($usuarioAD.MemberOf -contains (Get-ADGroup 'GIBSIPBLOQUEADOS').DistinguishedName){
            Write-Host "`n EL USUARIO SE ENCUENTRA BLOQUEADO POR VACACIONES!!`n"
        }
                # Consultar a que grupos pertenece
        Write-Host "`n`n    -------  Grupos a los que pertenece  -------`n"
        foreach ($grupo in $usuarioAD.MemberOf) {
              $nombreGrupo = (Get-ADGroup $grupo).Name
              Write-Host " $nombreGrupo"
            }
    
    } else {
        Write-Host "`n`nUsuario no encontrado en Active Directory."
    }
    
    Write-Host "`n`nPresione Enter para realizar otra consulta o 'R' para refrescar..."
    do{
        $respuesta = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        $codigo = [int][char]$respuesta
    }while(($codigo -ne '13') -and ($codigo -ne '114'))
    if($codigo -eq '114'){
        $nueva_consulta = $false
        }else{$nueva_consulta = $true}
    cls
    
}
