USE Marketplace;

DROP VIEW IF EXISTS vw_user;
CREATE VIEW
	vw_user
AS
	 SELECT 
	    Users.id AS "id",email,
        Users.name_user AS "name",
        Users.state_user AS "state_user",
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
;


DROP VIEW IF EXISTS vw_publications;
CREATE VIEW
	vw_publications
AS
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
    	state_publication = TRUE 
        AND Categories.state_category = TRUE 
        AND Users.state_user = TRUE
;

DROP VIEW IF EXISTS vw_complaint;
CREATE VIEW
	vw_complaint
AS
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
    WHERE
        state_complaint = TRUE
;

DROP VIEW IF EXISTS vw_wishList;
CREATE VIEW
	vw_wishList
AS
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
;


DROP VIEW IF EXISTS vw_suscriptions;
CREATE VIEW
	vw_suscriptions
AS
	SELECT
        Suscriptions.user_id AS "user_id",
        Users.name_user AS "name_user",
        Suscriptions.category_id AS "category_id",
        Categories.name_category AS "name_category",
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
;

