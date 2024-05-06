# Script de consulta de Active Directory en PowerShell - Lucas S. Paniagua Baez -

$nueva_consulta = $true
while ($true) {
# Solicitar al usuario que ingrese el login o hostname para consultar

    if($nueva_consulta -eq $true){
    $input = Read-Host -Prompt "Ingrese el login del usuario o el nombre del equipo"
    cls
    }
    # Realizar la consulta de usuarios en Active Directory
    $usuarioAD = Get-AdUser -Filter {SamAccountName -eq $input} -Properties DisplayName,EmailAddress,SamAccountName,Department,Enabled,LockedOut,MemberOf,msDS-UserPasswordExpiryTimeComputed,PwdLastSet,Manager,OfficePhone
    $equipoAD= Get-ADComputer -Filter {Name -eq $input} -Properties Name,OperatingSystem,Description,Enabled,LastLogonDate,VersionNumber,IPv4Address,MemberOf,CanonicalName,LockedOut,OperatingSystemVersion

    # Verificar si existe el usuario
    if ($usuarioAD -ne $null) {
        Write-Host "USUARIO: $($usuarioAD.SamAccountName)"
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
            Write-Host " La cuenta se encuentra habilitada`n"
            }else{
            Write-Host " La cuenta se encuentra DESHABILITADA!!`n" }
  
            if($usuarioAD.LockedOut -eq $true){
            Write-Host " La contraseña se encuentra BLOQUEADA!!`n"
            }else{
            Write-Host " La contraseña se encuentra desbloqueada`n" }
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
    

    Write-Host "`n`nPresione 'Enter' para realizar otra consulta o 'R' para refrescar..."
    }elseif($equipoAD -ne $null){
        Write-Host "EQUIPO: $($equipoAD.Name)"
        Write-Host "`n`n    -------DATOS DEL EQUIPO-------`n"
        Write-Host "Nombre: $($equipoAD.Name)"
        Write-Host "Direccion IP: $($equipoAD.IPv4Address)"
        Write-Host "Sistema Operativo: $($equipoAD.OperatingSystem)"
        Write-Host "Version de compilacion: $($equipoAD.OperatingSystemVersion)"
        Write-Host "Ultimo acceso: $($equipoAD.LastLogonDate)"
        Write-Host "Clave SVCUAC: $(Get-LapsADPassword $input -AsPlainText | Select-Object -ExpandProperty Password)"
        Write-Host "Ruta: $($equipoAD.CanonicalName)"
    

        Write-Host "`n`n    -------SITUACION DEL EQUIPO-------`n"
        if($equipoAD.MemberOf -contains (Get-ADGroup 'ALLOW_SITM_Lock_Computers').DistinguishedName){
            Write-Host "El equipo esta BLOQUEADO!!! Falta regularizar su catastro."
            }elseif($equipoAD.Enabled -and !$equipoAD.LockedOut){
                Write-Host "El equipo se encuentra habilitado"
                }    


        Write-Host "`n`n    -------GRUPOS A LOS QUE PERTENECE EL EQUIPO-------`n"
        foreach ($grupo in $equipoAD.MemberOf) {
                  $nombreGrupo = (Get-ADGroup $grupo).Name
                  Write-Host "- $nombreGrupo"
                  }
    Write-Host "`n`nPresione 'Enter' para realizar otra consulta o 'R' para refrescar..."
    
    }else {
        Write-Host "`n`nUsuario/Equipo no encontrado en Active Directory.`n`n`n`nPresione 'Enter' para realizar otra consulta."
            
    }
    
    
    do{
        $respuesta = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        $codigo = [int][char]$respuesta
    }while(($codigo -ne '13') -and ($codigo -ne '114'))
    if($codigo -eq '114'){
        $nueva_consulta = $false
        }else{$nueva_consulta = $true}
    cls
    
}
