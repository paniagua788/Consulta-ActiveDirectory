CONSULTA DE USUARIOS ACTIVE DIRECTORY
-------------------------------------------------------------------------------------------------------------------------------------


Este es un script escrito en powershell, que mediante el complemento RSAT realiza una consulta de usuarios y equipos del actual Directorio Activo de Windows.

Salida de ejemplo:

**CONSULTANDO USUARIO**

-----------------------------------------------------------------------------------------------------------------------------------
```
USUARIO: user


    -------  Datos del usuario  -------

 Nombre completo: "Nombre y apellido"
 Correo electronico: correo@ejemplo.com 
 Departamento: departamento dentro de la empresa
 Interno: telefono interno
 Superior inmediato: superior (gerente, jefe)


    -------  Situacion actual del usuario  -------

 La cuenta se encuentra habilitada - OK

 La contraseña se encuentra desbloqueada - OK

 Ultimo cambio de contraseña: 11-01-2024 13:41:56
 Fecha de expiracion de contraseña: 10-04-2024 12:41:56


    -------  Grupos a los que pertenece  -------

 Grupo1
 Grupo2
 ...


Presione 'Enter' para realizar otra consulta o 'R' para refrescar...
```




**CONSULTANDO EQUIPO**

-------------------------------------------------------------------------------------------------------------------------------------
```
EQUIPO: hostname


    ------- DATOS DEL EQUIPO -------

Nombre: hostname
Direccion IP: 192.168.1.10
Sistema Operativo: Windows 11 Pro
Version de compilacion: 10.0 (22621)
Ruta: <dominio>/Domain Resources/Clients/.../hostname


    ------- SITUACION DEL EQUIPO -------

Clave SVCUAC:

Actualizado: 31-12-1600 21:00:00

El equipo se encuentra habilitado / El equipo esta BLOQUEADO


    ------- GRUPOS A LOS QUE PERTENECE EL EQUIPO -------

- Grupo 1
- Grupo 2
- ...


Presione 'Enter' para realizar otra consulta o 'R' para refrescar...
```
