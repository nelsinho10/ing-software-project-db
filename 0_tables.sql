-- Creacion de las tablas de base de datos
DROP DATABASE IF EXISTS Marketplace;
CREATE DATABASE Marketplace;

USE Marketplace;

CREATE TABLE IF NOT EXISTS Departments(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_department VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS Municipality(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_municipality VARCHAR(200),
    id_department INT NOT NULL,
    FOREIGN KEY(id_department) REFERENCES Departments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Direction(
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NOT NULL,
    department_id INT NOT NULL,
    municipality_id INT NOT NULL,
    FOREIGN KEY(department_id) REFERENCES Departments(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(municipality_id) REFERENCES Municipality(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_category VARCHAR(200),
    state_category BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE TypeComplaints(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_Complaint VARCHAR(200) NOT NULL
);


CREATE TABLE IF NOT EXISTS Users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_user VARCHAR(200) NOT NULL,
    password_user BLOB NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(200) NOT NULL,
    rol ENUM("USER", "ADMIN") DEFAULT "USER" NOT NULL,
    direction_id INT ,
    date_registered TIMESTAMP DEFAULT NOW(),
    state_user BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY(direction_id) REFERENCES Direction(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Publications(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    date_publication TIMESTAMP DEFAULT NOW(),
    desc_publication TEXT NOT NULL,
    user_id INT NOT NULL,
    department_id INT NOT NULL,
    municipality_id INT NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    state_publication BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(department_id) REFERENCES Departments(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(municipality_id) REFERENCES Municipality(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(category_id) REFERENCES Categories(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Comments(
    id INT PRIMARY KEY AUTO_INCREMENT,
    commentary TEXT NOT NULL,
    type_comment ENUM("user","publications") DEFAULT "publications",
    user_id INT NOT NULL,
    user_comment INT NOT NULL,
    qualification INT,
    date_comments TIMESTAMP DEFAULT NOW(),
    publication_id INT,
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(publication_id) REFERENCES Publications(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user_comment) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Complaints(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    denounced_id INT NOT NULL,
    type_complaints_id INT NOT NULL,
    commentary TEXT NOT NULL,
    date_complaints TIMESTAMP DEFAULT NOW(),
    state_complaint BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(denounced_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(type_complaints_id) REFERENCES TypeComplaints(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Images(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_img VARCHAR(200) NOT NULL,
    date_publication TIMESTAMP DEFAULT NOW(),
    data_img LONGBLOB NOT NULL,
    type_img ENUM("publication","profile") NOT NULL,
    format_img VARCHAR(200) NOT NULL,
    publication_id INT,
    user_id INT,
    FOREIGN KEY(publication_id) REFERENCES Publications(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS WishList(
    publication_id INT,
    user_id INT,
    date_wish TIMESTAMP DEFAULT NOW(),
    state_wish BOOLEAN NOT NULL,
    PRIMARY KEY (publication_id, user_id),
    FOREIGN KEY(publication_id) REFERENCES Publications(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Suscriptions(
    user_id INT,
    category_id INT,
    date_suscriptions TIMESTAMP DEFAULT NOW(),
    state_suscriptions BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(user_id, category_id),
    FOREIGN KEY(user_id) REFERENCES Users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(category_id) REFERENCES Categories(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Configs(
    id INT PRIMARY KEY AUTO_INCREMENT,
    time_service INT NOT NULL,
    time_announcemen INT NOT NULL
);