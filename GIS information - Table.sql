-- CREATE DATABASE gis_information;

CREATE TABLE category(
	category_id INT PRIMARY KEY,
	category CHAR(20));

CREATE TABLE point(
	point_id SERIAL PRIMARY KEY,
    point_name VARCHAR(100),
    address VARCHAR(100),
    category_id INT,
    geom GEOMETRY,
    FOREIGN KEY (category_id) REFERENCES category(category_id));
    
INSERT INTO category
VALUES (30, 'Garis');
    