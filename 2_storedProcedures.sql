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
            description AS "direction", 
            date_registered, rol
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
        Categories.id AS "category_id",
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
        Categories.id AS "category_id",
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
        Categories.id AS "category_id",
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

-- Buscar Publicacion
DROP PROCEDURE IF EXISTS sp_searchPublication$$
CREATE PROCEDURE sp_searchPublication(
    IN TEX VARCHAR(200),
    IN ORDATE VARCHAR(200),
    IN ORPRICE VARCHAR(200)
)
BEGIN

    IF(TEX != '' AND ORDATE = 'reciente' AND ORPRICE = '') THEN
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            AND 
                Categories.state_category = TRUE 
            AND 
                (Publications.title LIKE CONCAT('%',TEX,'%')
            OR 
                Publications.desc_publication LIKE CONCAT('%',TEX,'%'))
            )
		ORDER BY 
				Publications.date_publication DESC
        ;
        
	ELSEIF (TEX != '' AND ORDATE = '' AND ORPRICE = 'caro') THEN 
    SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            AND 
                Categories.state_category = TRUE 
            AND 
                (Publications.title LIKE CONCAT('%',TEX,'%')
            OR 
                Publications.desc_publication LIKE CONCAT('%',TEX,'%'))
            )
		ORDER BY 
				Publications.price DESC
        ;
        ELSEIF (TEX != '' AND ORDATE = 'antiguo' AND ORPRICE = '') THEN 
    SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            AND 
                Categories.state_category = TRUE 
            AND 
                (Publications.title LIKE CONCAT('%',TEX,'%')
            OR 
                Publications.desc_publication LIKE CONCAT('%',TEX,'%'))
            )
		ORDER BY 
				Publications.date_publication ASC
        ;
        
        ELSEIF (TEX != '' AND ORDATE = '' AND ORPRICE = 'barato') THEN 
    SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            AND 
                Categories.state_category = TRUE 
            AND 
                (Publications.title LIKE CONCAT('%',TEX,'%')
            OR 
                Publications.desc_publication LIKE CONCAT('%',TEX,'%'))
            )
		ORDER BY 
				Publications.price ASC
        ;
        
	ELSE
		 SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            AND 
                Categories.state_category = TRUE 
            AND 
                (Publications.title LIKE CONCAT('%',TEX,'%')
            OR 
                Publications.desc_publication LIKE CONCAT('%',TEX,'%'))
            )
        ;
    END IF;
END$$

-- Filtrar Publicacion
DROP PROCEDURE IF EXISTS sp_filteredPublication$$
CREATE PROCEDURE sp_filteredPublication(
    IN CAT VARCHAR(200),
    IN DEP VARCHAR(200),
    IN MUN VARCHAR(200),
    IN RANINF DECIMAL(10,2),
    IN RANSUP DECIMAL(10,2),
    IN ORDATE VARCHAR(200),
    IN ORPRICE VARCHAR(200)
)
BEGIN  
   IF(ORDATE = 'reciente' AND ORPRICE = '') THEN
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            (
                Categories.name_category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                Departments.name_department REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                Municipality.name_municipality REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (Publications.price BETWEEN RANINF AND RANSUP)
            )
            )
        ORDER BY 
            Publications.date_publication DESC
        ;
   ELSEIF(ORDATE = '' AND ORPRICE = 'caro') THEN
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            (
                Categories.name_category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                Departments.name_department REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                Municipality.name_municipality REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (Publications.price BETWEEN RANINF AND RANSUP)
            )
            )
        ORDER BY 
            Publications.price DESC
        ;
   ELSEIF(ORDATE = '' AND ORPRICE = 'barato') THEN
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            (
                Categories.name_category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                Departments.name_department REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                Municipality.name_municipality REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (Publications.price BETWEEN RANINF AND RANSUP)
            )
            )
        ORDER BY 
            Publications.price ASC
        ;
   ELSEIF(ORDATE = 'antiguo' AND ORPRICE = 'caro') THEN
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            (
                Categories.name_category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                Departments.name_department REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                Municipality.name_municipality REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (Publications.price BETWEEN RANINF AND RANSUP)
            )
            )
        ORDER BY 
            Publications.date_publication DESC
    ;
   ELSE
        SELECT
            Publications.id AS "id_publication", 
            title, desc_publication AS "description", 
            price,date_publication AS "date_publication",
            Categories.name_category AS "category",
            Categories.id AS "category_id",
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
            (
                Categories.name_category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                Departments.name_department REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                Municipality.name_municipality REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (Publications.price BETWEEN RANINF AND RANSUP)
            )
            );
    
   END IF;
END$$

-- Comentarios de Pefil
DROP PROCEDURE IF EXISTS sp_commentProfile$$
CREATE PROCEDURE sp_commentProfile(
    IN IDPU INT,
    IN IDU INT,
    IN QUA INT,
    IN COM TEXT
)
BEGIN

    SET @qf = NULL;
    SELECT qualification INTO @qf FROM Comments WHERE Comments.user_id = IDPU AND Comments.user_comment = IDU LIMIT 1;
    SELECT id INTO @idf FROM Comments WHERE Comments.user_id = IDPU AND Comments.user_comment = IDU LIMIT 1;
    
    IF(@qf IS NULL) THEN
        INSERT INTO
            Comments(commentary,type_comment,user_id,user_comment,qualification)
        VALUES
            (COM,"user",IDPU,IDU,QUA)
        ;

    ELSE

        UPDATE 
            Comments
        SET
            commentary = COM, type_comment= "user", user_id = IDPU,user_comment = IDU, qualification = QUA
        WHERE
            Comments.id = @idf
        ;

    END IF;

END$$

-- Comentario de Producto
DROP PROCEDURE IF EXISTS sp_commentPublication$$
CREATE PROCEDURE sp_commentPublication(
    IN IDPU INT,
    IN IDCO INT,
    IN COM TEXT
)
BEGIN
    SELECT user_id INTO @user_ FROM Publications WHERE id = IDPU LIMIT 1;

    INSERT INTO
        Comments(commentary,type_comment,user_id,user_comment,publication_id)
    VALUES
        (COM,"publications",@user_,IDCO,IDPU)
    ;
END$$

-- Obtener comentarios de Publicacion
DROP PROCEDURE IF EXISTS sp_getCommentPublicationID$$
CREATE PROCEDURE sp_getCommentPublicationID(
    IN IDP INT
)
BEGIN
    SELECT
        Comments.user_id AS "user_Create_Publication",
        (SELECT name_user FROM Users WHERE id = Comments.user_id) AS "name_user_create_publication",
        Comments.user_comment AS "user_Comment_Publication",
        (SELECT name_user FROM Users WHERE id = Comments.user_comment) AS "name_user_comment",
        commentary, date_comments, Comments.id AS "id_comment"
    FROM
        Comments 
    JOIN 
        Users
    ON
        Comments.user_id = Users.id
    WHERE
        (Comments.publication_id = IDP AND type_comment = "publications")
    ;
END$$

-- Obtener comentaios de Perfil
DROP PROCEDURE IF EXISTS sp_getCommentProfileID$$
CREATE PROCEDURE sp_getCommentProfileID(
    IN IDP INT
)
BEGIN
    SELECT
        Comments.user_id AS "user_Create_Publication",
        (SELECT name_user FROM Users WHERE id = Comments.user_id) AS "name_user_create_publication",
        Comments.user_comment AS "user_Comment_Publication",
        (SELECT name_user FROM Users WHERE id = Comments.user_comment) AS "name_user_comment",
        commentary, date_comments, qualification, Comments.id AS "id_comment"
    FROM
        Comments 
    JOIN 
        Users
    ON
        Comments.user_id = Users.id
    WHERE
        (Comments.user_id = IDP AND type_comment = "user")
    ;
END$$

-- Obtener Calificacion de vendedor
DROP PROCEDURE IF EXISTS sp_getQualificationID$$
CREATE PROCEDURE sp_getQualificationID(
    IN IDP INT
)
BEGIN
    SELECT
		Users.name_user AS "name", AVG(Comments.qualification) AS "qualification"
    FROM
        Comments 
    JOIN 
        Users
    ON
        Comments.user_id = Users.id
    WHERE
        Comments.user_id = IDP AND type_comment = "user"
	GROUP BY 
		Users.name_user
    ;
END$$

-- Denuncia al Vendedor
DROP PROCEDURE IF EXISTS sp_addTypeComplaints$$
CREATE PROCEDURE sp_addTypeComplaints(
    IN TCOMPLAINT VARCHAR(200)
)
BEGIN
    INSERT INTO
        TypeComplaints(name_complaint)
    VALUES
        (TCOMPLAINT)
    ;
END$$

DROP PROCEDURE IF EXISTS sp_getTypeComplaints$$
CREATE PROCEDURE sp_getTypeComplaints()
BEGIN
    SELECT
         * 
    FROM 
        TypeComplaints
    ;
END$$

DROP PROCEDURE IF EXISTS sp_addComplaint$$
CREATE PROCEDURE sp_addComplaint(
    IN USERID INT,
    IN DENOUNCED INT,
    IN TCOMPLAINT INT,
    IN COMMENT TEXT
)
BEGIN
    INSERT INTO
        Complaints(user_id,denounced_id,type_complaints_id,commentary)
    VALUES
        (USERID,DENOUNCED,TCOMPLAINT,COMMENT)
    ;
END$$

DROP PROCEDURE IF EXISTS sp_getComplaint$$
CREATE PROCEDURE sp_getComplaint()
BEGIN
	SELECT
        Complaints.id AS "id",
        Complaints.user_id AS "user_id",
        (SELECT name_user FROM Users WHERE id = Complaints.user_id) AS "name_user",
        Complaints.denounced_id AS "denounced_id", 
        (SELECT name_user FROM Users WHERE id = Complaints.denounced_id) AS "name_denounced",
        Complaints.type_complaints_id AS "type_complaints_id",
        TypeComplaints.name_Complaint AS "name_type_complaints",
        Complaints.commentary AS "commentary",
        Complaints.date_complaints AS "date"
    FROM
        Complaints
    JOIN 
        Users
    ON 
        Complaints.user_id = Users.id
    JOIN
        TypeComplaints
    ON
        Complaints.type_complaints_id = TypeComplaints.id
    ;
END$$

-- Lista de Deseos
DROP PROCEDURE IF EXISTS sp_addWishList$$
CREATE PROCEDURE sp_addWishList(
    IN IDP INT,
    IN USER INT
)
BEGIN
    INSERT INTO
        WishList(publication_id, user_id, state_wish)
    VALUES
        (IDP,USER,1)
    ;
END$$

DROP PROCEDURE IF EXISTS sp_getWishListUser$$
CREATE PROCEDURE sp_getWishListUser(
    IN IDU INT
)
BEGIN

    SELECT
        Publications.id AS "id_publication",
        Publications.title AS "title",
        Publications.desc_publication AS "description", 
        Publications.price AS "price",
        Publications.date_publication AS "date_publication",
        Categories.name_category AS "category",
        Categories.id AS "category_id",
        (SELECT id FROM Users WHERE Users.id = Publications.user_id) AS "id_user",
        (SELECT name_user FROM Users WHERE Users.id = Publications.user_id) AS "name_user",
        (SELECT email FROM Users WHERE Users.id = Publications.user_id) AS "email",
        (SELECT phone FROM Users WHERE Users.id = Publications.user_id) AS "phone",
        (SELECT name_department FROM Departments WHERE Departments.id = Publications.department_id) AS "depto",
        (SELECT name_municipality FROM Municipality WHERE Municipality.id = Publications.municipality_id) AS "mun"
    FROM 
        WishList
    JOIN
        Publications
    ON
        WishList.publication_id = Publications.id
    JOIN
        Users
    ON
        WishList.user_id = Users.id
    JOIN
        Categories
    ON
        Publications.category_id = Categories.id
    JOIN
        Departments
    ON
        Publications.department_id = Departments.id
    JOIN
        Municipality
    ON
        Publications.municipality_id = Municipality.id
    WHERE
        WishList.user_id = IDU
    ;
END$$

-- Suscripcion de Categorias
DROP PROCEDURE IF EXISTS sp_addSuscriptions$$
CREATE PROCEDURE sp_addSuscriptions(
    IN IDU INT,
    IN CAT INT
)
BEGIN
    INSERT INTO 
        Suscriptions(user_id, category_id)
    VALUES
        (IDU,CAT)
    ;
END$$

DROP PROCEDURE IF EXISTS sp_getSuscriptionsUser$$
CREATE PROCEDURE sp_getSuscriptionsUser(
    IN IDU INT
)
BEGIN
    SELECT
        Suscriptions.user_id AS "user_id",
        Users.name_user AS "name_user",
        Suscriptions.category_id AS "category_id",
        Categories.name_category AS "name_category",
        Categories.id AS "category_id",
        Suscriptions.date_suscriptions AS "date"
    FROM
        Suscriptions
    JOIN
        Users
    ON
        Suscriptions.user_id = Users.id
    JOIN
        Categories
    ON
        Suscriptions.category_id = Categories.id
    WHERE
        Suscriptions.user_id = IDU
    ;
END$$

DELIMITER ;