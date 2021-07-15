-- Creacion de los procedimientos almacenados
USE Marketplace;

DELIMITER $$

-- Crear Usuarios
DROP PROCEDURE IF EXISTS sp_createUser$$
CREATE PROCEDURE sp_createUser(
    IN NAME_USER VARCHAR(200),
    IN PASSWORD_USER BLOB,
    IN EMAIL VARCHAR(200),
    IN PHONE VARCHAR(200),
    IN DEP INT,
    IN MUN INT,
    IN DIR TEXT
)
BEGIN
    SET @key = '1234';
    
    -- Creando una direccion para el nuevo usuario
    INSERT INTO 
        Direction(description, department_id, municipality_id)
    VALUES
        (DIR, DEP, MUN)
    ;
	
    -- Buscando la direccion
    SELECT id INTO @id_dir FROM Direction WHERE description = DIR LIMIT 1;
    
    INSERT INTO 
        Users(name_user, password_user, email, phone, direction_id) 
    VALUES
        (NAME_USER,AES_ENCRYPT(PASSWORD_USER, @key),EMAIL,PHONE,@id_dir)
    ;
END$$

-- Obtener todos los usuarios del sistema
DROP PROCEDURE IF EXISTS sp_getUsers$$
CREATE PROCEDURE sp_getUsers()
BEGIN

    SELECT 
	Users.id AS "id",email,
    Users.name_user AS "name",
    phone, name_department AS "department", 
    name_municipality AS "municipality", 
    description AS "direction", date_registered
    FROM 
    	Users 
    JOIN 
    	Direction 
    ON 
    	Users.direction_id = Direction.id 
    JOIN 
    	Municipality 
    ON 
    	Direction.municipality_id = Municipality.id 
    JOIN 
    	Departments 
    ON 
    Municipality.id_department = Departments.id
    ;
END$$

-- Obtener usuario por correo
DROP PROCEDURE IF EXISTS sp_getUserEmail$$
CREATE PROCEDURE sp_getUserEmail(
    IN EMAIL_P VARCHAR(200),
    IN PASSP VARCHAR(200)
)
BEGIN
    SET @key = '1234';

	SET @user_id = 0;
    SET @pass_query = "";

    -- Buscando Usuario
    SELECT id INTO @user_id FROM Users WHERE email = EMAIL_P LIMIT 1;
    
    -- Extraer la contraseña del usuario
    SELECT 
        CAST(AES_DECRYPT(password_user, @key) AS CHAR(1000)) 
    INTO 
        @pass_query
    FROM 
        Users
    WHERE
        id = @user_id
    ; 

    -- Sentencia de Control 
    IF (@user_id != 0 AND @pass_query = PASSP) THEN
        SELECT 
            Users.id AS "id",email,
            Users.name_user AS "name",
            phone, name_department AS "department", 
            name_municipality AS "municipality", 
            description AS "direction", date_registered
        FROM 
            Users 
        JOIN 
            Direction 
        ON 
            Users.direction_id = Direction.id 
        JOIN 
            Municipality 
        ON 
            Direction.municipality_id = Municipality.id 
        JOIN 
            Departments 
        ON 
            Municipality.id_department = Departments.id
        WHERE
            Users.id = @user_id
        ;
        ELSE
            SELECT 0;
	END IF;
END$$

-- Obtener departamento
DROP PROCEDURE IF EXISTS sp_getDep$$
CREATE PROCEDURE sp_getDep()
BEGIN
    SELECT 
        id, name_department AS "department" 
    FROM 
        Departments
    ;
END$$

-- Obtener municipio
DROP PROCEDURE IF EXISTS sp_getMun$$
CREATE PROCEDURE sp_getMun(
    IN IDD INT
)
BEGIN
    SELECT
        id, name_municipality AS "municipality"
    FROM
        Municipality
    WHERE
        id_department = IDD
    ;
END$$

-- Obtener usuario por id
DROP PROCEDURE IF EXISTS sp_getUserID$$
CREATE PROCEDURE sp_getUserID(
    IN USER INT
)
BEGIN
    SELECT 
	    Users.id AS "id",email,
        Users.name_user AS "name",
        phone, name_department AS "department", 
        name_municipality AS "municipality", 
        description AS "direction", date_registered
    FROM 
    	Users 
    JOIN 
    	Direction 
    ON 
    	Users.direction_id = Direction.id 
    JOIN 
    	Municipality 
    ON 
    	Direction.municipality_id = Municipality.id 
    JOIN 
    	Departments 
    ON 
        Municipality.id_department = Departments.id
    WHERE
        Users.id = USER
    LIMIT
        1
    ;
END$$

-- Obtener categorias
DROP PROCEDURE IF EXISTS sp_getCategories$$
CREATE PROCEDURE sp_getCategories()
BEGIN
    SELECT 
        id, name_Category
    FROM 
        Categories
    WHERE
        state_category = TRUE
    ; 
END$$

-- Crear publicacion
DROP PROCEDURE IF EXISTS sp_createPublication$$
CREATE PROCEDURE sp_createPublication(
    IN USERID INT,
    IN TITLEPU VARCHAR(200),
    IN CATEGORYID INT,
    IN DESCRIP TEXT,
    IN PRICEPRO DECIMAL(10,2)
)
BEGIN
    -- obtener informacion del usuario
    SELECT
        name_user, direction_id
    INTO
        @NAMEUSER, @DIR
    FROM
        Users
    WHERE
        id = USERID
    ;

    -- obtener el dep y mun
    SELECT
        department_id, municipality_id
    INTO
        @DEPTOID, @MUNID
    FROM
        Direction
    WHERE
       id = @DIR 
    ;

    INSERT INTO
        Publications(
            title,desc_publication,user_id,
            department_id, municipality_id,
            category_id, price
        )
    VALUES
        (TITLEPU,DESCRIP,USERID,
        @DEPTOID,@MUNID,
        CATEGORYID,PRICEPRO)
    ; 

    -- retornar el id de la publicaion
    SELECT 
        id
    FROM
        Publications
    WHERE
        user_id = USERID
    ORDER BY
        id DESC
    LIMIT
        1
    ;

END$$


-- Guardar imagenes de publicacion
DROP PROCEDURE IF EXISTS sp_savedImagePublication$$
CREATE PROCEDURE sp_savedImagePublication(
    IN NAMEI VARCHAR(200),
    IN DATAIMAGE LONGBLOB,
    IN PUBLICID INT,
    IN FORIMG VARCHAR(200)
)
BEGIN
    INSERT INTO
        Images(name_img, data_img,
        type_img, publication_id, format_img)
    VALUES
        (NAMEI, DATAIMAGE,"publication", PUBLICID, FORIMG)
    ;
END$$

-- Guardar imagenes de perfil
DROP PROCEDURE IF EXISTS sp_savedImageProfile$$
CREATE PROCEDURE sp_savedImageProfile(
    IN NAMEI VARCHAR(200),
    IN DATAIMAGE LONGBLOB,
    IN USER INT,
    IN FORIMG VARCHAR(200)
)
BEGIN
    INSERT INTO
        Images(name_img, data_img,
        type_img, user_id, format_img)
    VALUES
        (NAMEI, DATAIMAGE,"profile", USER, FORIMG)
    ;
END$$

-- Obtener todas las publicaciones
DROP PROCEDURE IF EXISTS sp_getPublicationsAll$$
CREATE PROCEDURE sp_getPublicationsAll(
)
BEGIN
   SELECT
	    Publications.id AS "id_publication", 
        title, desc_publication AS "description", 
        price,date_publication AS "date_publication",
        Categories.name_category AS "category",
        user_id AS "id_user", Users.name_user AS "name_user",
        Users.email AS "email", Users.phone AS "phone",
        Departments.name_department AS "depto",
        Municipality.name_municipality AS "munic"
    FROM
    	Publications
    JOIN
    	Users
    ON 
    	Publications.user_id = Users.id
    JOIN
    	Departments
    ON
    	Publications.department_id = Departments.id
    JOIN
    	Municipality
    ON
    	Publications.municipality_id = Municipality.id
    JOIN
    	Categories
    ON 
    	Publications.category_id = Categories.id
    WHERE
    	(state_publication = TRUE AND Categories.state_category = TRUE)
    ;
END$$

-- Obtener todas las imagenes
DROP PROCEDURE IF EXISTS sp_getImageProduct$$
CREATE PROCEDURE sp_getImageProduct(
    IN ID INT
)
BEGIN
    SELECT
        Images.id AS "id_image", name_img,
        date_publication,
        data_img AS "data",
        format_img AS "format"
    FROM
        Images
    WHERE
        publication_id = ID
    ;
END$$


-- Obtener publicaciones por el id de usuario
DROP PROCEDURE IF EXISTS sp_getPublicationUserID$$
CREATE PROCEDURE sp_getPublicationUserID(
    IN IDUSER INT
)
BEGIN
     SELECT
	    Publications.id AS "id_publication", 
        title, desc_publication AS "description", 
        price,date_publication AS "date_publication",
        Categories.name_category AS "category",
        user_id AS "id_user", Users.name_user AS "name_user",
        Users.email AS "email", Users.phone AS "phone",
        Departments.name_department AS "depto",
        Municipality.name_municipality AS "munic"
    FROM
    	Publications
    JOIN
    	Users
    ON 
    	Publications.user_id = Users.id
    JOIN
    	Departments
    ON
    	Publications.department_id = Departments.id
    JOIN
    	Municipality
    ON
    	Publications.municipality_id = Municipality.id
    JOIN
    	Categories
    ON 
    	Publications.category_id = Categories.id
    WHERE
    	(state_publication = TRUE AND 
        Categories.state_category = TRUE AND
        user_id = IDUSER)
    ;
END$$

-- Obtener publicaciones por id de publicacion
DROP PROCEDURE IF EXISTS sp_getPublicationID$$
CREATE PROCEDURE sp_getPublicationID(
    IN IDP INT
)
BEGIN
    SELECT
	    Publications.id AS "id_publication", 
        title, desc_publication AS "description", 
        price,date_publication AS "date_publication",
        Categories.name_category AS "category",
        user_id AS "id_user", Users.name_user AS "name_user",
        Users.email AS "email", Users.phone AS "phone",
        Departments.name_department AS "depto",
        Municipality.name_municipality AS "munic"
    FROM
    	Publications
    JOIN
    	Users
    ON 
    	Publications.user_id = Users.id
    JOIN
    	Departments
    ON
    	Publications.department_id = Departments.id
    JOIN
    	Municipality
    ON
    	Publications.municipality_id = Municipality.id
    JOIN
    	Categories
    ON 
    	Publications.category_id = Categories.id
    WHERE
    	(state_publication = TRUE 
        AND Categories.state_category = TRUE 
        AND Publications.id = IDP)
    ;
END$$
DELIMITER ;