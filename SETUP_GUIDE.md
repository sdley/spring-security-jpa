# Spring Security JPA with MariaDB - Setup Guide

## 🚀 Quick Start

### 1. Database Setup

Make sure MariaDB is running and create the database:

```bash
mysql -u root -p
```

```sql
CREATE DATABASE IF NOT EXISTS springsecurity;
```

### 2. Configure Database Connection

Update `src/main/resources/application.properties` with your MariaDB credentials:

```properties
spring.datasource.url=jdbc:mariadb://localhost:3306/springsecurity
spring.datasource.username=root
spring.datasource.password=your_password_here
```

### 3. Run the Application

The application will automatically:
- Create the necessary tables (`users`, `roles`, `user_roles`)
- Initialize sample users (via DataInitializer)

```bash
./mvnw spring-boot:run
```

### 4. Test the Endpoints

**Public endpoint (no authentication needed):**
```bash
curl http://localhost:8080/
```

**User endpoint (requires USER or ADMIN role):**
```bash
curl -u user:password http://localhost:8080/user
```

**Admin endpoint (requires ADMIN role):**
```bash
curl -u admin:admin http://localhost:8080/admin
```

## 📊 Default Users

The application creates two users on first run:

| Username | Password | Roles |
|----------|----------|-------|
| user | password | ROLE_USER |
| admin | admin | ROLE_USER, ROLE_ADMIN |

## 🔧 Database Schema

### Tables Created

1. **users** - Stores user credentials
   - id (BIGINT, Primary Key)
   - username (VARCHAR, Unique)
   - password (VARCHAR, BCrypt encoded)
   - enabled (BOOLEAN)

2. **roles** - Stores role definitions
   - id (BIGINT, Primary Key)
   - name (VARCHAR, Unique)

3. **user_roles** - Many-to-many relationship
   - user_id (BIGINT, Foreign Key)
   - role_id (BIGINT, Foreign Key)

## 🛠️ How It Works

### Authentication Flow

1. User sends credentials (username/password)
2. `MyUserDetailsService` loads user from database via `UserRepository`
3. `MyUserDetails` wraps the User entity as Spring Security UserDetails
4. `SecurityConfig` configures authentication using `DaoAuthenticationProvider`
5. Passwords are verified using BCrypt
6. User gets access based on their roles

### Security Configuration

- `/` - Public access (permitAll)
- `/user` - Requires ROLE_USER or ROLE_ADMIN
- `/admin` - Requires ROLE_ADMIN only
- All other endpoints require authentication

## 📝 Adding New Users

### Option 1: Using DataInitializer (Programmatic)

Edit `DataInitializer.java` and add more users:

```java
User newUser = new User("john", passwordEncoder.encode("john123"), true);
newUser.addRole(userRole);
userRepository.save(newUser);
```

### Option 2: Direct Database Insert

```sql
-- Generate BCrypt password first (use online tool or Java code)
INSERT INTO users (username, password, enabled) 
VALUES ('john', '$2a$10$encoded_password_here', TRUE);

-- Get the user_id and role_id, then link them
INSERT INTO user_roles (user_id, role_id) VALUES (3, 1);
```

### Option 3: Create a Registration Endpoint

Add a REST endpoint to register new users (recommended for production).

## 🔐 Password Encoding

All passwords are stored using BCrypt. To generate a BCrypt password:

```java
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encodedPassword = encoder.encode("your_password");
System.out.println(encodedPassword);
```

Or use online BCrypt generators (search "bcrypt generator online").

## 🐛 Troubleshooting

### Database Connection Issues

```
Error: Could not create connection to database server
```

**Solutions:**
- Verify MariaDB is running: `systemctl status mariadb` or `brew services list`
- Check database exists: `SHOW DATABASES;`
- Verify credentials in `application.properties`
- Check if port 3306 is accessible

### User Not Found

```
Error: 401 Unauthorized / User not found
```

**Solutions:**
- Check if DataInitializer ran (look for console output)
- Verify users exist: `SELECT * FROM users;`
- Ensure roles are properly linked: `SELECT * FROM user_roles;`

### Role Access Denied

```
Error: 403 Forbidden
```

**Solutions:**
- User needs correct role (ROLE_USER or ROLE_ADMIN)
- Role names MUST start with "ROLE_" prefix
- Check user roles: `SELECT * FROM user_roles WHERE user_id = ?;`

## 📦 Project Structure

```
src/main/java/sn/sdley/spring_security_jpa/
├── config/
│   └── DataInitializer.java          # Initialize sample data
├── model/
│   ├── User.java                     # User entity (JPA)
│   └── Role.java                     # Role entity (JPA)
├── repository/
│   └── UserRepository.java           # Data access layer
├── security/
│   ├── MyUserDetails.java            # UserDetails implementation
│   ├── MyUserDetailsService.java     # Load users from DB
│   └── SecurityConfig.java           # Security configuration
├── HomeResources.java                # REST controllers
└── SpringSecurityJpaApplication.java # Main application
```

## 🎯 Next Steps

1. **Disable DataInitializer** after first run by commenting out `@Component`
2. **Change default passwords** in production
3. **Add registration endpoint** for new users
4. **Implement JWT** for stateless authentication
5. **Add password reset** functionality
6. **Configure HTTPS** for production deployment

## 📚 Additional Resources

- [Spring Security Documentation](https://docs.spring.io/spring-security/reference/)
- [Spring Data JPA Documentation](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [BCrypt Password Encoding](https://docs.spring.io/spring-security/reference/features/authentication/password-storage.html)

---

**Happy Coding! 🚀**

