## DOCUMENTACION DE LA BASE DE DATOS

### ***UPDATED*** : 03-07-2021
---

### ***Stored Procedures***

1. **sp_createUser()**
    - ***Parametros:***
        - nombre de usuario
        - password
        - email
        - numero de telefono
        - id del Depto
        - id del Municipio
        - direccion
    - ***Retorno:***
        - Bien-> No retorna nada
        - Error-> Retorna error en caso de algun dato incorrecto
        
2. **sp_getUsers()**
    - ***Parametros:***
        - ninguno
    - ***Retorno:***
        - Bien-> Retorna todos los usuarios
        - Error-> Retorna nada

3. **sp_getUserEmail()**
    - ***Parametros:***
        - email
        - password
    - ***Retorno:***
        - Usuario Existe -> Retorna datos del usuario
        - Usuario no Existe-> Retorna 0

