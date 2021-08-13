## DOCUMENTACION DE LA BASE DE DATOS

### ***UPDATED*** : 13-08-2021
___
___

### ***------------------------------------------- Stored Procedures -------------------------------------------***

### ***Users***
---
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

4. **sp_getUserID()**
    - ***Parametros:***
        - id del usuario
    - ***Retorno:***
        - Retorna todo el usuario

### ***Depto and Mun***
---

5. **sp_getDep()**
    - ***Parametros:***
        - ninguno
    - ***Retorno:***
        - Todos los departamenos con su respectivo id

6. **sp_getMun()**
    - ***Parametros:***
        - id del departamento
    - ***Retorno:***
        - Retorna el id y el nombre del municipio que pertenece al departamento recibido

### ***Publications***
---

7. **sp_getCategories()**
    - ***Parametros:***
        - ninguno
    - ***Retorno:***
        - id de las categorias
        - nombre de las categorias

8. **sp_createPublication()**
    - ***Parametros:***
        - id del usuario
        - titulo de la publicacion
        - id de la categoria
        - descripcion de la publicacion
        - precio
    - ***Retorno:***
        - id de la publicacion

9. **sp_getPublicationsAll()**
    - ***Parametros:***
        - Rango minimo de las publicaciones a mostrar
        - Rango maximo de las publicaciones a mostrar
    - ***Retorno:***
        - id de la publicacion
        - titulo de la publicacion
        - precio
        - fecha de la publicacion
        - nombre de la categoria
        - id del usuario que creo la publicacion
        - nombre del usuario que creo la publicacion
        - departamento del usuario
        - municipio del usuario

10. **sp_getPublicationUserID()**
    - ***Parametros:***
        - id del usuario
    - ***Retorno:***
        - id de la publicacion
        - titulo de la publicacion
        - precio
        - fecha de la publicacion
        - nombre de la categoria
        - id del usuario que creo la publicacion
        - nombre del usuario que creo la publicacion
        - departamento del usuario
        - municipio del usuario

11. **sp_getPublicationID()**
    - ***Parametros:***
        - id de la publicacion
    - ***Retorno:***
        - id de la publicacion
        - titulo de la publicacion
        - precio
        - fecha de la publicacion
        - nombre de la categoria
        - id del usuario que creo la publicacion
        - nombre del usuario que creo la publicacion
        - departamento del usuario
        - municipio del usuario

### ***Image***
---

12. **sp_savedImagePublication()**
    - ***Parametros:***
        - nombre de la imagen
        - data de la imagen
        - id de la publicacion
        - formato de la imagen
    - ***Retorno:***
        - ninguno

13. **sp_savedImageProfile()**
    - ***Parametros:***
        - nombre de la imagen
        - data de la imagen
        - id del usuario
        - formato de la imagen(PNG/JPG)
    - ***Retorno:***
        - ninguno

14. **sp_getImageProduct()**
    - ***Parametros:***
        - id del producto
    - ***Retorno:***
        - id de las imagenes
        - nombre de las imagenes
        - fecha de subida de la imagen
        - formato de la imagen (PNG/JPG)
    
### ***Filters***
---

15. **sp_filtered()**
    - ***Parametros:***
        - Texto que desea buscar
        - Nombre del Departamento
        - Nombre del Municipio
        - Nombre de la categoria
        - Precio minimo
        - Precio maximo
        - Ordenar por fecha -> mandar string 'reciente' o 'antiguo'
        - Ordenar por precio -> mandar string 'caro' o 'barato'
        - Rango minimo del paginado
        - Rango maximo del paginado
    - ***Retorno:***
        - Todas las publicaciones con esa coincidencia

### ***Comments***
---
16. **sp_commentProfile()**
    - ***Parametros:***
        - ID del perfil que se desea comentar
        - ID del Usuario que comenta
        - Calificacion que se le da a ese usuario del 1 al 5
        - Comentario
    - ***Retorno:***
        - Ninguno

17. **sp_commentPublication()**
    - ***Parametros:***
        - ID de la publicacion
        - ID del usuario que comenta
        - Comentario
    - ***Retorno:***
        - Ninguno

18. **sp_getCommentPublicationID()**
    - ***Parametros:***
        - ID del Producto
    - ***Retorno:***
        - ID del Usuario que creo la publicacion
        - Nombre del Usuario que creo la publicacion
        - ID del usuario que comento
        - Nombre del usuario que comento
        - Comentario
        - fecha del comentario
        - ID del comentario

19. **sp_getCommentProfileID()**
    - ***Parametros:***
        - ID del Perfil
    - ***Retorno:***
        - ID del Usuario que creo la publicacion
        - Nombre del Usuario que creo la publicacion
        - ID del usuario que comento
        - Nombre del usuario que comento
        - Comentario
        - fecha del comentario
        - calificacion que le dio ese usuario al creador de la publicacion
        - ID del comentario

20. **sp_getQualificationID()**
    - ***Parametros:***
        - ID del Perfil
    - ***Retorno:***
        - Nombre del Usuario
        - Calificacion Promedio del Usuario

### ***Complaints***
---

21. **sp_addTypeComplaints()**
    - ***Parametros:***
        - Tipo de denuncia
    - ***Retorno:***
        - Ninguno
    - **NOTA: Este SP se usa para crear tipos de denuncia desde el modulo de administracion ''**

22. **sp_getTypeComplaints()**
    - ***Parametros:***
        - Ninguno
    - ***Retorno:***
        - ID del tipo de denuncia
        - nombre del tipo de denuncia

23. **sp_addComplaint()**
    - ***Parametros:***
        - ID del usuario que hace la denuncia
        - ID del usuario al que estan denunciando
        - ID del tipo de denuncia
        - Comentario de denuncia
    - ***Retorno:***
        - Ninguno

24. **sp_getComplaint()**
    - ***Parametros:***
        - Ninguno
    - ***Retorno:***
        - ID de la denuncia
        - ID del usuario que hace la denuncia
        - nombre del usuario que hace la denuncia
        - ID del usuario al que estan denunciando
        - nombre del usuario al que estan denunciando
        - ID del tipo de denuncia
        - tipo de denuncia
        - Comentario de denuncia
        - Fecha de la denuncia

### ***WishList***
---

25. **sp_getWishListUser()**
    - ***Parametros:***
        - ID del usuario
    - ***Retorno:***
        - Productos de la lista de deseos

26. **sp_addWishList()**
    - ***Parametros:***
        - ID del Producto
        - ID del Usuario
    - ***Retorno:***
        - Productos de la lista de deseos

### ***Suscriptions***
---
27. **sp_addSuscriptions()**
    - ***Parametros:***
        - ID del usuario
        - Categoria a la que se suscribio
    - ***Retorno:***
        - Ninguno

28. **sp_getSuscriptionsUser()**
    - ***Parametros:***
        - ID del usuario
    - ***Retorno:***
        - Suscripciones de categoria

### ***Admin***
---
29. **sp_removeAd()**
    - ***Parametros:***
        - ID del Anuncio
    - ***Retorno:***
        - Ninguno

30. **sp_addCategory()**
    - ***Parametros:***
        - Nombre de la categoria
    - ***Retorno:***
        - Ninguno

31. **sp_removeCategory()**
    - ***Parametros:***
        - ID de la categoria
    - ***Retorno:***
        - Ninguno

32. **sp_estimateComplaint()**
     - ***Parametros:***
        - ID del Usuario
        - Accion a realizar
        - *NOTA*: Si en la accion le manda *'baja'* se elemina el usuario y sus publicaciones, caso contrario desestima la denuncia.
    - ***Retorno:***
        - Ninguno

33. **sp_timeAnnouncement()**
     - ***Parametros:***
        - Tiempo de los anuncio 
        - Tiempo de los servicios
    - ***Retorno:***
        - Ninguno

34. **sp_getConfig()**
     - ***Parametros:***
        -Ninguno
    - ***Retorno:***
        - Tiempo de anuncio y servicios

35. **sp_removeUser()**
     - ***Parametros:***
        - ID del Usuario
    - ***Retorno:***
        - Ninguno

### ***Estadisticas***
---
36. **sp_statistics()**
    - ***Parametros:***
        - Ninguno
    - ***Retorno:***
        - Estadisticas relevantes

36. **sp_publicationsXcategories()**
    - ***Parametros:***
        - Ninguno
    - ***Retorno:***
        - Publicaciones por categorias

### ***Cambios***

- Se agrego un archivo 2_views.sql donde se manejan las vistas utilizadas en algunos sp

- Se eliminan los SP *sp_searchPublication()* y *sp_filteredPublication()* por :
    - *sp_filtered()*

- Se modifica el SP para el paginado:
    - *sp_getPublicationsAll()*


