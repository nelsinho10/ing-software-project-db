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

DELIMITER ;