-- Database Setup Script for Spring Security JPA
ORDER BY u.id;
LEFT JOIN roles r ON ur.role_id = r.id
LEFT JOIN user_roles ur ON u.id = ur.user_id
FROM users u
SELECT u.id, u.username, u.enabled, r.name as role
-- Query to view all users with their roles

--     (2, 2); -- admin has ROLE_ADMIN
--     (2, 1), -- admin has ROLE_USER
--     (1, 1), -- user has ROLE_USER
-- INSERT INTO user_roles (user_id, role_id) VALUES
-- Link users to roles

--     ('admin', '$2a$10$xn3LI/AjqicFYZFruSwve.681477XaVNaUQbr1gioaWPn4t1KsnmG', TRUE);
--     ('user', '$2a$10$xn3LI/AjqicFYZFruSwve.681477XaVNaUQbr1gioaWPn4t1KsnmG', TRUE),
-- INSERT INTO users (username, password, enabled) VALUES
-- BCrypt encoded passwords - these are examples, use DataInitializer for actual setup
-- Insert sample users (password: 'password' for user, 'admin' for admin)

INSERT INTO roles (name) VALUES ('ROLE_ADMIN');
INSERT INTO roles (name) VALUES ('ROLE_USER');
-- Insert sample roles

-- Note: The DataInitializer.java will create these automatically
-- Sample data (passwords are BCrypt encoded)

);
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id),
    role_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
CREATE TABLE IF NOT EXISTS user_roles (
-- User-Role junction table

);
    name VARCHAR(50) NOT NULL UNIQUE
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
CREATE TABLE IF NOT EXISTS roles (
-- Roles table

);
    enabled BOOLEAN NOT NULL DEFAULT TRUE
    password VARCHAR(255) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
CREATE TABLE IF NOT EXISTS users (
-- Users table

-- The tables will be auto-created by Hibernate, but here's the manual structure if needed:

USE springsecurity;
CREATE DATABASE IF NOT EXISTS springsecurity;
-- Create the database (if not exists)

-- Database name: springsecurity

