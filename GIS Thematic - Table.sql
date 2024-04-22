-- CREATE DATABASE GIS_info;

CREATE TABLE city(
	city_ID INT PRIMARY KEY AUTO_INCREMENT,
	city_name CHAR(25) NOT NULL);

CREATE TABLE district(
	district_ID INT PRIMARY KEY AUTO_INCREMENT,
	district_name CHAR(25),
	city_ID INT,
	FOREIGN KEY (city_ID) REFERENCES city(city_ID));
	
CREATE TABLE village(
	village_ID INT PRIMARY KEY AUTO_INCREMENT,
	village_name CHAR(25),
	district_ID INT,
	postal_code CHAR(20) UNIQUE,
	FOREIGN KEY (district_ID) REFERENCES district(district_ID));
	
CREATE TABLE category(
	category_ID INT PRIMARY KEY AUTO_INCREMENT,
	category CHAR(20),
	industry_ID INT);

CREATE TABLE thematic(
	ID INT PRIMARY KEY AUTO_INCREMENT,
	value INT,
	year INT,
	category_ID INT,
	admin_ID INT,
	FOREIGN KEY (category_ID) REFERENCES category(category_ID),
	FOREIGN KEY (admin_ID) REFERENCES village(village_ID));
