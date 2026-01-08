# 🚀 Quick Reference Card

## One-Page Guide to Your Spring Security JPA Application

### 📦 Installation (3 Steps)

```bash
# 1. Create database
mysql -u root -p -e "CREATE DATABASE springsecurity;"

# 2. Update application.properties with your DB password

# 3. Run application
./mvnw spring-boot:run
```

---

### 🔑 Default Credentials

| Username | Password | Access |
|----------|----------|--------|
| `user` | `password` | `/`, `/user` |
| `admin` | `admin` | `/`, `/user`, `/admin` |

---

### 🌐 API Endpoints

```bash
# Public - No auth needed
curl http://localhost:8080/

# User - Needs USER role
curl -u user:password http://localhost:8080/user

# Admin - Needs ADMIN role
curl -u admin:admin http://localhost:8080/admin
```

---

### 📊 Database Tables

**users** → id, username, password (BCrypt), enabled
**roles** → id, name (must have "ROLE_" prefix)
**user_roles** → user_id, role_id (junction table)

---

### 🔍 Verify Database

```sql
-- Connect
mysql -u root -p springsecurity

-- View all users with roles
SELECT u.username, r.name as role
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id;
```

---

### 📁 Project Structure

```
src/main/java/sn/sdley/spring_security_jpa/
├── config/DataInitializer.java       # Creates sample users
├── model/User.java                   # User entity
├── model/Role.java                   # Role entity
├── repository/UserRepository.java    # Database access
├── security/MyUserDetails.java       # UserDetails wrapper
├── security/MyUserDetailsService.java# Auth service
├── security/SecurityConfig.java      # Security config
├── HomeResources.java                # Controllers
└── SpringSecurityJpaApplication.java # Main
```

---

### ⚙️ Configuration Files

**application.properties** - Database connection
```properties
spring.datasource.url=jdbc:mariadb://localhost:3306/springsecurity
spring.datasource.username=root
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
```

---

### 🔐 Security Rules

- `/` → permitAll() - Everyone
- `/user` → hasAnyRole("USER", "ADMIN") - Authenticated
- `/admin` → hasRole("ADMIN") - Admin only
- Everything else → authenticated()

---

### 🛠️ Common Commands

```bash
# Clean build
./mvnw clean install

# Run application
./mvnw spring-boot:run

# Run tests
./mvnw test

# Package JAR
./mvnw clean package
java -jar target/spring-security-jpa-0.0.1-SNAPSHOT.jar
```

---

### 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Connection refused | Start MariaDB: `brew services start mariadb` |
| User not found | Check DataInitializer ran, verify with `SELECT * FROM users;` |
| 401 Unauthorized | Use correct credentials: user/password or admin/admin |
| 403 Forbidden | User doesn't have required role |
| 500 Error | Check application logs and database connection |

---

### 📝 Add New User (SQL)

```sql
-- Insert user (password must be BCrypt encoded)
INSERT INTO users (username, password, enabled)
VALUES ('john', '$2a$10$encoded_password_here', true);

-- Get user ID
SELECT id FROM users WHERE username = 'john';

-- Get role ID
SELECT id FROM roles WHERE name = 'ROLE_USER';

-- Link user to role
INSERT INTO user_roles (user_id, role_id) VALUES (3, 1);
```

---

### 🔒 Generate BCrypt Password

```java
// Add to DataInitializer or create utility class
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encoded = encoder.encode("myPassword");
System.out.println(encoded);
```

Or use online: https://bcrypt-generator.com/

---

### 📚 Documentation Files

- **README.md** - Full project documentation
- **SETUP_GUIDE.md** - Detailed setup instructions
- **TESTING_GUIDE.md** - Complete testing guide
- **IMPLEMENTATION_SUMMARY.md** - What was built
- **database-setup.sql** - SQL script
- **THIS FILE** - Quick reference

---

### ⚡ Testing Checklist

- [ ] Database created
- [ ] Application starts without errors
- [ ] Can access `/` without login
- [ ] Login required for `/user`
- [ ] `user:password` works for `/user`
- [ ] `user:password` blocked from `/admin`
- [ ] `admin:admin` works for `/admin`
- [ ] Users exist in database
- [ ] Passwords are BCrypt encoded

---

### 🎯 After First Run

1. **Comment out DataInitializer** to prevent duplicate users:
   ```java
   // @Component  // <-- Add // here
   public class DataInitializer implements CommandLineRunner {
   ```

2. **Change default passwords** in production

3. **Review security settings** before deployment

---

### 🚀 Production Checklist

- [ ] Use environment variables for DB credentials
- [ ] Change default user passwords
- [ ] Disable DataInitializer
- [ ] Enable HTTPS
- [ ] Set `spring.jpa.hibernate.ddl-auto=validate`
- [ ] Configure proper logging
- [ ] Set up monitoring
- [ ] Add rate limiting
- [ ] Configure CORS properly
- [ ] Use production database (not localhost)

---

### 📞 Quick Links

- Spring Security: https://spring.io/projects/spring-security
- Spring Boot: https://spring.io/projects/spring-boot
- MariaDB: https://mariadb.org/
- BCrypt: https://en.wikipedia.org/wiki/Bcrypt

---

### 💡 Pro Tips

✅ Use `@Transactional` for multi-step database operations
✅ Add indexes on username for better query performance
✅ Implement password validation rules
✅ Add account lockout after N failed attempts
✅ Log authentication events for security auditing
✅ Use connection pooling (HikariCP) in production
✅ Implement "Remember Me" functionality
✅ Add email verification for new users

---

## 🎉 You're All Set!

**Start:** `./mvnw spring-boot:run`
**Test:** `curl -u user:password http://localhost:8080/user`
**Verify:** Check database and endpoints

Need help? Check the documentation files! 📚

