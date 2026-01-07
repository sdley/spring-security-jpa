# 🔐 Spring Security JPA Application

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0.1-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-25-orange.svg)](https://www.oracle.com/java/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A modern Spring Boot application demonstrating authentication and authorization using Spring Security with JPA/Hibernate for database-backed user management.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Security Configuration](#security-configuration)
- [Database Setup](#database-setup)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project showcases a secure REST API built with Spring Boot, implementing role-based access control (RBAC) using Spring Security. User credentials and roles are persisted in a MariaDB database via JPA/Hibernate, providing a production-ready authentication and authorization solution.

## ✨ Features

- 🔒 **Spring Security Integration** - Robust authentication and authorization
- 💾 **JPA/Hibernate** - Database-backed user management
- 🎭 **Role-Based Access Control** - User and Admin roles with different access levels
- 🗄️ **MariaDB Support** - Production-ready relational database
- 🚀 **RESTful API** - Clean and simple endpoint structure
- 🧪 **Test Coverage** - Security and web layer testing included
- 📦 **Maven Build** - Easy dependency management and building

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Java | 25 | Programming Language |
| Spring Boot | 4.0.1 | Application Framework |
| Spring Security | 6.x | Authentication & Authorization |
| Spring Data JPA | 3.x | Data Persistence |
| MariaDB | Latest | Database |
| Maven | 3.x | Build Tool |

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Java Development Kit (JDK) 25** or higher
  ```bash
  java -version
  ```

- **Maven 3.6+** (or use the included Maven wrapper)
  ```bash
  mvn -version
  ```

- **MariaDB Server** or **MySQL 8.0+**
  ```bash
  mysql --version
  ```

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sdley/spring-security-jpa.git
   cd spring-security-jpa
   ```

2. **Set up the database**
   ```sql
   CREATE DATABASE spring_security_db;
   CREATE USER 'spring_user'@'localhost' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON spring_security_db.* TO 'spring_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Configure application properties**
   
   Update `src/main/resources/application.properties` with your database credentials:
   ```properties
   spring.application.name=spring-security-jpa
   
   # Database Configuration
   spring.datasource.url=jdbc:mariadb://localhost:3306/spring_security_db
   spring.datasource.username=spring_user
   spring.datasource.password=your_password
   spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
   
   # JPA Configuration
   spring.jpa.hibernate.ddl-auto=update
   spring.jpa.show-sql=true
   spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MariaDBDialect
   spring.jpa.properties.hibernate.format_sql=true
   ```

4. **Build the project**
   ```bash
   ./mvnw clean install
   ```
   
   Or if you have Maven installed globally:
   ```bash
   mvn clean install
   ```

## ⚙️ Configuration

### Database Configuration

The application uses MariaDB by default. To switch to another database:

**For PostgreSQL:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/spring_security_db
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

**For MySQL:**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spring_security_db
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

### Security Configuration

The application implements role-based security with the following access levels:
- **Public**: `/` - Accessible to everyone
- **User Role**: `/user` - Requires USER role
- **Admin Role**: `/admin` - Requires ADMIN role

## 🏃 Running the Application

### Using Maven Wrapper (Recommended)
```bash
./mvnw spring-boot:run
```

### Using Maven
```bash
mvn spring-boot:run
```

### Using Java
```bash
./mvnw clean package
java -jar target/spring-security-jpa-0.0.1-SNAPSHOT.jar
```

The application will start on **http://localhost:8080**

## 🌐 API Endpoints

| Endpoint | Method | Access Level | Description |
|----------|--------|--------------|-------------|
| `/` | GET | Public | Welcome page - accessible to all |
| `/user` | GET | USER | User dashboard - requires authentication |
| `/admin` | GET | ADMIN | Admin dashboard - requires admin role |

### Example Requests

**Public Endpoint:**
```bash
curl http://localhost:8080/
```

**User Endpoint (with authentication):**
```bash
curl -u username:password http://localhost:8080/user
```

**Admin Endpoint (with admin credentials):**
```bash
curl -u admin:admin_password http://localhost:8080/admin
```

## 🔐 Security Configuration

The application uses Spring Security with JPA-based authentication. Users and their roles are stored in the database, allowing for dynamic user management.

### Default Users

You'll need to create users in the database or implement a user registration endpoint. Example SQL:

```sql
-- Create User entity tables (auto-generated by JPA)
-- Insert sample users (password should be BCrypt encoded)
INSERT INTO users (username, password, enabled) VALUES ('user', '$2a$10$...', true);
INSERT INTO users (username, password, enabled) VALUES ('admin', '$2a$10$...', true);

INSERT INTO authorities (username, authority) VALUES ('user', 'ROLE_USER');
INSERT INTO authorities (username, authority) VALUES ('admin', 'ROLE_ADMIN');
```

### Password Encoding

All passwords should be encrypted using BCrypt. You can generate BCrypt passwords using:

```java
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encodedPassword = encoder.encode("yourPassword");
```

## 🗄️ Database Setup

### Schema Creation

The application uses Hibernate to auto-generate database tables. Set the following property for initial setup:

```properties
spring.jpa.hibernate.ddl-auto=create
```

After the first run, change it to:

```properties
spring.jpa.hibernate.ddl-auto=update
```

### Entity Relationships

- **User** entity stores user credentials
- **Role/Authority** entity manages user permissions
- Many-to-many relationship between Users and Roles

## 🧪 Testing

### Run All Tests
```bash
./mvnw test
```

### Run Specific Test Class
```bash
./mvnw test -Dtest=SpringSecurityJpaApplicationTests
```

### Test Coverage

The project includes:
- **Unit Tests** - Business logic validation
- **Security Tests** - Authentication and authorization testing
- **Integration Tests** - End-to-end API testing

## 📁 Project Structure

```
spring-security-jpa/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── sn/sdley/spring_security_jpa/
│   │   │       ├── SpringSecurityJpaApplication.java    # Main application class
│   │   │       ├── HomeResources.java                   # REST controllers
│   │   │       ├── model/                               # JPA entities
│   │   │       ├── repository/                          # Data access layer
│   │   │       ├── service/                             # Business logic
│   │   │       └── security/                            # Security configuration
│   │   └── resources/
│   │       ├── application.properties                   # Configuration
│   │       ├── static/                                  # Static resources
│   │       └── templates/                               # View templates
│   └── test/
│       └── java/
│           └── sn/sdley/spring_security_jpa/
│               └── SpringSecurityJpaApplicationTests.java
├── pom.xml                                              # Maven dependencies
├── mvnw                                                 # Maven wrapper (Unix)
├── mvnw.cmd                                             # Maven wrapper (Windows)
└── README.md                                            # This file
```

## 🔧 Troubleshooting

### Common Issues

**Database Connection Failed**
```
Error: Could not connect to database
Solution: Verify database is running and credentials are correct
```

**Port Already in Use**
```
Error: Port 8080 is already in use
Solution: Change the port in application.properties:
server.port=8081
```

**Authentication Fails**
```
Error: 401 Unauthorized
Solution: Ensure users exist in database with proper roles and BCrypt-encoded passwords
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Java naming conventions
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**SDLEY**
- GitHub: [@sdley](https://github.com/sdley)
- Project Link: [https://github.com/sdley/spring-security-jpa](https://github.com/sdley/spring-security-jpa)

## 🙏 Acknowledgments

- [Spring Framework](https://spring.io/) - Amazing framework
- [Spring Security](https://spring.io/projects/spring-security) - Security implementation
- [Hibernate](https://hibernate.org/) - ORM solution
- [MariaDB](https://mariadb.org/) - Database system

## 📚 Additional Resources

- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Security Reference](https://docs.spring.io/spring-security/reference/)
- [Spring Data JPA Documentation](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)

---

⭐ If you find this project helpful, please give it a star!

**Happy Coding! 🚀**

