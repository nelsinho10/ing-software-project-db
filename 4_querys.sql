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
SELECT id FROM Direction WHERE description = "Col centeno" ORDER BY id DESC LIMIT 1;
SELECT id, name_user, CAST(AES_DECRYPT(password_user, @key) AS CHAR(1000)) AS 'password', email,phone, Direction.description FROM Users JOIN Direction ON Users.direction_id = Direction.id;
SELECT id INTO @USERm FROM Users WHERE email = "nelsinho1031@gmail.com" LIMIT 1;
SELECT * FROM Users WHERE email = "nelsinho1031@gmil.com" LIMIT 1;

-- SP
call sp_createUser("Nelson Jafet Sambula","fa123","nelsinho1031@gmail.com","9610-9748",1,8,"Col centeno");
call sp_createUser("Hola Mundo","12123","asd@gmail.com","9610-9748",1,4,"Col espiruto santo"); 
call sp_getUserEmail("nelsonL");
call sp_getUsers();



