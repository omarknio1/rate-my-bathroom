-- PostgreSQL Database Schema for Rate My Bathroom

-- Create Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Bathrooms Table
CREATE TABLE bathrooms (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    location VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Reviews Table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    bathroom_id INT REFERENCES bathrooms(id),
    user_id INT REFERENCES users(id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Images Table
CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    bathroom_id INT REFERENCES bathrooms(id),
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);