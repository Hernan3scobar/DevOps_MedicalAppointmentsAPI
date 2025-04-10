-- File: create_db.sql

-- Create DB if there is none
CREATE DATABASE IF NOT EXISTS db_softserve_project;

-- Select db
USE db_softserve_project;

-- Create table in selected db
CREATE TABLE IF NOT EXISTS Schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    hour TIME NOT NULL,
    shared BOOLEAN DEFAULT FALSE,
    reserved BOOLEAN DEFAULT FALSE,
    reserved_by VARCHAR(100),
    reserved_note VARCHAR(255)
);
