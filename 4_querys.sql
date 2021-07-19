-- Selects
SELECT 
    name_department, name_municipality 
FROM Marketplace.Municipality 
    JOIN Marketplace.Departments 
    ON Municipality.id_department = Departments.id
;
SELECT * FROM Direction;
SELECT * FROM Users;
SELECT * FROM Departments;
SELECT * FROM Municipality;
call sp_getUsers();
SELECT id FROM Direction WHERE description = "Col centeno" ORDER BY id DESC LIMIT 1;
SELECT id, name_user, CAST(AES_DECRYPT(password_user, @key) AS CHAR(1000)) AS 'password', email,phone, Direction.description FROM Users JOIN Direction ON Users.direction_id = Direction.id;
SELECT id INTO @USERm FROM Users WHERE email = "nelsinho1031@gmail.com" LIMIT 1;
SELECT * FROM Users WHERE email = "nelsinho1031@gmil.com" LIMIT 1;
SELECT * FROM Direction;
SELECT * FROM Publications;
SELECT * FROM Images;
-- SP
call sp_createUser("Nelson Jafet Sambula","fa123","nelsinho1031@gmail.com","96109748",1,8,"Col centeno");
call sp_createUser("Melissa Rodriguez","123","melisa@gmail.com","90902122",3,29,"col villadela");
call sp_createUser("Carlos Eduardo Arriola","123","carlos@gmail.com","96349743",4,55,"Col centeno");
call sp_createUser("Hola Mundo","12123","asd@gmail.com","9610-9748",6,87,"Col espiruto santo"); 
call sp_getUserEmail("nelsinho1031@gmail.com","fa123");
call sp_getUsers();
call sp_getUserID(2);
call sp_getPublicationUserID(2);
call sp_getPublicationID(5);
call sp_getCategories();
call sp_getDep();
call sp_getMun();

call sp_getPublicationsAll();
call sp_searchPublication('');

call sp_createPublication(4,"Laptop",8,"Excelente estado, sin golpes",34000);
call sp_createPublication(2,"Honda Civic",6,"Semi nuevo, sin golpes",64000.87);
call sp_createPublication(1,"Teclado Mecanico",3,"Excelente estado, sin golpes",1000.20);
call sp_createPublication(1,"Mouser",10,"Excelente estado, sin golpes",120.20);

call sp_savedImageProfile("imagen1",010101010,3,"JPG");
call sp_savedImagePublication("imagen1",010101010,2,"PNG");
call sp_getPublicationsAll();
call sp_getImageProduct(2);

SELECT * FROM Publications WHERE title LIKE '%civic%' OR desc_publication LIKE '%civic 2021%';
use Marketplace;



