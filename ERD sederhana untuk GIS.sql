CREATE DATABASE GIS_ENGINEER;

CREATE TABLE Industry(
	industry_ID INT PRIMARY KEY,
    industry CHAR(20));

CREATE TABLE Category(
	category_id INT PRIMARY KEY,
    category CHAR(20),
    industry_ID INT,
    FOREIGN KEY (industry_ID) REFERENCES Industry(industry_ID));

CREATE TABLE administration(
	admin_ID INT PRIMARY KEY,
    village_name CHAR(25) NOT NULL,
    district_name CHAR(25) NOT NULL,
    city_name CHAR(25) NOT NULL,
    postal_code CHAR(10) UNIQUE);

CREATE TABLE point(
	point_ID SERIAL PRIMARY KEY,
    point_name VARCHAR(100),
    address VARCHAR(100),
    category_ID INT,
    admin_ID INT,
    geom GEOMETRY,
    FOREIGN KEY (category_ID) REFERENCES Category(category_ID),
    FOREIGN KEY (admin_ID) REFERENCES administration(admin_ID));