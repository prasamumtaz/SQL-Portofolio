-- Create the city table
CREATE TABLE city (
    city_ID INT PRIMARY KEY AUTO_INCREMENT,
    city_name CHAR(25) NOT NULL
);

-- Create the district table
CREATE TABLE district (
    district_ID INT PRIMARY KEY AUTO_INCREMENT,
    district_name VARCHAR(100),
    city_ID INT,
    FOREIGN KEY (city_ID) REFERENCES city(city_ID)
);

-- Create the village table
CREATE TABLE village (
    village_ID INT PRIMARY KEY AUTO_INCREMENT,
    village_name VARCHAR(100),
    district_ID INT,
    postal_code CHAR(10) UNIQUE,
    FOREIGN KEY (district_ID) REFERENCES district(district_ID)
);

-- Create the category table
CREATE TABLE category (
    category_ID INT PRIMARY KEY AUTO_INCREMENT,
    category CHAR(20),
    industry_ID INT
);

-- Create the thematic table
CREATE TABLE thematic (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    value INT,
    year INT,
    category_ID INT,
    admin_ID INT,
    FOREIGN KEY (category_ID) REFERENCES category(category_ID),
    FOREIGN KEY (admin_ID) REFERENCES village(village_ID)
);

-- Insert dummy data for cities, districts, and villages
INSERT INTO city (city_name) VALUES
('City 1'), ('City 2'), ('City 3'), ('City 4'), ('City 5'),
('City 6'), ('City 7'), ('City 8'), ('City 9'), ('City 10'),
('City 11'), ('City 12'), ('City 13'), ('City 14'), ('City 15'),
('City 16'), ('City 17'), ('City 18');

SET @city_count = 1;
SET @district_count = 1;
SET @village_count = 1;

DELIMITER //

CREATE PROCEDURE populateCitiesAndDistrictsAndVillages()
BEGIN
    DECLARE city_count INT DEFAULT 1;
    DECLARE district_count INT;
    DECLARE village_count INT;

    WHILE city_count <= 18 DO
        SET district_count = 1;
        WHILE district_count <= 3 DO
            SET village_count = 1;
            WHILE village_count <= 2 DO
                INSERT INTO district (district_name, city_ID) VALUES
                (CONCAT('District ', district_count, ', City ', city_count), city_count);
                SET @district_id = LAST_INSERT_ID();

                INSERT INTO village (village_name, district_ID, postal_code) VALUES
                (CONCAT('Village ', village_count, ', District ', district_count, ', City ', city_count),
                @district_id, CONCAT('PC', LPAD(village_count, 2, '0'), LPAD(district_count, 2, '0'), LPAD(city_count, 2, '0')));
                SET village_count = village_count + 1;
            END WHILE;
            SET district_count = district_count + 1;
        END WHILE;
        SET city_count = city_count + 1;
    END WHILE;
END//

DELIMITER ;

CALL populateCitiesAndDistrictsAndVillages();

-- Insert dummy data for categories
INSERT INTO category (category, industry_ID) VALUES
('Category 1', 1),
('Category 2', 2),
('Category 3', 3);

-- Insert dummy data for thematic
-- Assuming thematic data for each village
INSERT INTO thematic (value, year, category_ID, admin_ID) 
SELECT ROUND(RAND() * 100), 2020, category_ID, village_ID 
FROM category, village 
ORDER BY RAND() 
LIMIT 540; -- Adjust the limit as needed