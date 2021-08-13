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
        *
    FROM
        vw_user
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
          *
        FROM 
            vw_user 
        WHERE
            id = @user_id AND state_user = 1
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
	   *
    FROM 
    	vw_user
    WHERE
        id = USER
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
    IN MINP INT,
    IN MAXP INT
)
BEGIN
    SELECT
	   *
    FROM
        vw_publications
    LIMIT
        MINP, MAXP
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
        *
    FROM
    	vw_publications
    WHERE
    	id_user = IDUSER
    ;
END$$

-- Obtener publicaciones por id de publicacion
DROP PROCEDURE IF EXISTS sp_getPublicationID$$
CREATE PROCEDURE sp_getPublicationID(
    IN IDP INT
)
BEGIN
    SELECT
	    *
    FROM
    	vw_publications
    WHERE
        id_publication = IDP
    ;
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
       *
    FROM
        vw_complaint
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
       *
    FROM 
       vw_wishList
    WHERE
        id_user = IDU
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
       *
    FROM
        vw_suscriptions
    WHERE
        user_id = IDU
    ;
END$$

-- Baja de Anuncio
DROP PROCEDURE IF EXISTS sp_removeAd$$
CREATE PROCEDURE sp_removeAd(
    IN IDA INT
)
BEGIN
    UPDATE 
        Publications 
    SET 
        state_publication = 0 
    WHERE 
        id = IDA;
END$$

-- Baja de Usuario
DROP PROCEDURE IF EXISTS sp_removeUser$$
CREATE PROCEDURE sp_removeUser(
    IN IDU INT
)
BEGIN
    UPDATE 
        Users 
    SET
         state_user = 0 
    WHERE 
        id = IDU;
END$$

-- Agregar Categoria
DROP PROCEDURE IF EXISTS sp_addCategory$$
CREATE PROCEDURE sp_addCategory(
    IN NAMECATEGORY VARCHAR(200)
)
BEGIN
    INSERT INTO
        Categories(name_category)
    VALUES
        (NAMECATEGORY)
    ;

END$$

-- Eliminar Categoria
DROP PROCEDURE IF EXISTS sp_removeCategory$$
CREATE PROCEDURE sp_removeCategory(
    IN IDC INT
)
BEGIN
    UPDATE 
        Categories
    SET 
        state_category = 0 
    WHERE 
        id = IDC;
END$$


-- Estimar denuncia
DROP PROCEDURE IF EXISTS sp_estimateComplaint$$
CREATE PROCEDURE sp_estimateComplaint(
    IN IDU INT,
    IN ACTIONUSER VARCHAR(200)
)
BEGIN
    IF(ACTIONUSER = 'baja') THEN
        call sp_removeUser(IDU);
        UPDATE
            Complaints
        SET 
            state_complaint = 0
        WHERE
             denounced_id = IDU;
    ELSE 
        UPDATE
            Complaints
        SET 
            state_complaint = 0
        WHERE
             denounced_id = IDU;
    END IF;

END$$

-- Tiempo de Anuncios
DROP PROCEDURE IF EXISTS sp_timeAnnouncement$$
CREATE PROCEDURE sp_timeAnnouncement(
    IN TIMEA INT,
    IN TIMESE INT
)
BEGIN

    UPDATE
        Configs
    SET
        time_service = TIMESE,
        time_announcemen = TIMEA
    WHERE
        id = 1
    ;

    UPDATE
        Publications
    SET
        state_publication = 0
    WHERE
        (DATEDIFF(date_publication,NOW()) = TIMEA
        AND category_id != 1)
    ;

    UPDATE
        Publications
    SET
        state_publication = 0
    WHERE
        (DATEDIFF(date_publication,NOW()) = TIMESE
        AND category_id = 1)
    ;
END $$

-- Obtener los tiempos
DROP PROCEDURE IF EXISTS sp_getConfig$$
CREATE PROCEDURE sp_getConfig()
BEGIN
    SELECT
        *
    FROM
        Configs
    ;
END$$

-- Filtrar Publicaciones
DROP PROCEDURE IF EXISTS sp_filtered$$
CREATE PROCEDURE sp_filtered(
    IN TEX VARCHAR(200),
    IN DEP VARCHAR(200),
    IN MUN VARCHAR(200),
    IN CAT VARCHAR(200),
    IN PRICEMIN DECIMAL(10,2),
    IN PRICEMAX DECIMAL(10,2),
    IN DATEUPLOAD VARCHAR(200),
    IN PRICEORD VARCHAR(200),
    IN PINF INT,
    IN PSUP INT
)
BEGIN
    IF (PRICEORD != '') THEN
    
        IF (PRICEORD = 'caro') THEN
            SELECT
                *
            FROM
                vw_publications
            WHERE
                (
                (title LIKE CONCAT('%',TEX,'%') OR 
                description LIKE CONCAT('%',TEX,'%')) AND
                category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                depto REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                munic REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (price BETWEEN PRICEMIN AND PRICEMAX)
                )
            ORDER BY
                price DESC
            LIMIT
                PINF, PSUP
            ;
        ELSEIF (PRICEORD = 'barato') THEN
            SELECT
                *
            FROM
                vw_publications
            WHERE
                (
                (title LIKE CONCAT('%',TEX,'%') OR 
                description LIKE CONCAT('%',TEX,'%')) AND
                category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                depto REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                munic REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (price BETWEEN PRICEMIN AND PRICEMAX)
                )
            ORDER BY
                price ASC
            LIMIT
                PINF, PSUP
            ;
        
        END IF;


    ELSE
        IF (DATEUPLOAD = 'reciente') THEN
            SELECT
                *
            FROM
                vw_publications
            WHERE
                (
                (title LIKE CONCAT('%',TEX,'%') OR 
                description LIKE CONCAT('%',TEX,'%')) AND
                category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                depto REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                munic REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (price BETWEEN PRICEMIN AND PRICEMAX)
                )
            ORDER BY
                date_publication DESC
            LIMIT
                PINF, PSUP
            ;
        ELSEIF (DATEUPLOAD = 'antiguo') THEN
            SELECT
                *
            FROM
                vw_publications
            WHERE
                (
                (title LIKE CONCAT('%',TEX,'%') OR 
                description LIKE CONCAT('%',TEX,'%')) AND
                category REGEXP IF(CAT='','.',CONCAT('^',CAT,'$')) AND
                depto REGEXP IF(DEP='','.',CONCAT('^',DEP,'$')) AND
                munic REGEXP IF(MUN='','.',CONCAT('^',MUN,'$')) AND
                (price BETWEEN PRICEMIN AND PRICEMAX)
                )
            ORDER BY
                date_publication ASC
            LIMIT
                PINF, PSUP
            ;
        END IF;

    END IF;
END$$

DROP PROCEDURE IF EXISTS sp_statistics$$
CREATE PROCEDURE sp_statistics()
BEGIN
    SELECT COUNT(*) INTO @users FROM Users;
    SELECT COUNT(*) INTO @publications FROM Publications;
    SELECT COUNT(*) INTO @comments_pub FROM Comments WHERE type_comment = "publications";
    SELECT COUNT(*) INTO @commenst_user FROM Comments WHERE type_comment = "user";
    SELECT COUNT(*) INTO @complaints FROM Complaints;
    SELECT COUNT(*) INTO @suscriptions FROM Suscriptions;

    SELECT 
        @users AS "users",
        @publications AS "publications",
        @comments_pub AS "comments_publications",
        @commenst_user AS "reviews",
        @complaints AS "complaints",
        @suscriptions AS "suscriptions"
    ;
END$$


DROP PROCEDURE IF EXISTS sp_publicationsXcategories$$
CREATE PROCEDURE sp_publicationsXcategories()
BEGIN

    -- Total de publicaciones por categorias
    SELECT
        Publications.category_id AS "category_id",
        count(Publications.id) AS "publications",
        Categories.name_category AS "name_category" 
    FROM 
	    Publications
    JOIN
	    Categories
    ON
	    Publications.category_id = Categories.id
    GROUP BY
	    Publications.category_id
    ;
END $$

DELIMITER ;
