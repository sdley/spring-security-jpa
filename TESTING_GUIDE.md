# Testing Guide - Spring Security JPA Application

## ✅ Pre-requisites Checklist

Before running the application, ensure:

- [ ] MariaDB is installed and running
- [ ] Database `springsecurity` exists
- [ ] Application compiled successfully (`./mvnw clean compile`)
- [ ] Database credentials are correct in `application.properties`

## 🚀 Step 1: Create the Database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE IF NOT EXISTS springsecurity;
SHOW DATABASES;
EXIT;
```

## 🏃 Step 2: Run the Application

```bash
./mvnw spring-boot:run
```

**Expected Console Output:**
```
Sample users created:
User - username: user, password: password
Admin - username: admin, password: admin

Started SpringSecurityJpaApplication in X.XXX seconds
```

## 🧪 Step 3: Test the Endpoints

### Test 1: Public Endpoint (No Authentication)

```bash
curl http://localhost:8080/
```

**Expected Response:**
```html
<h1>Welcome to SDLEY SPRING SECURITY JPA APPLICATION</h1>
```

**Status Code:** 200 OK

---

### Test 2: User Endpoint (Requires Authentication)

**Without credentials (should fail):**
```bash
curl http://localhost:8080/user
```

**Expected Response:**
```html
Unauthorized or Login page
```

**Status Code:** 401 Unauthorized

**With USER credentials (should succeed):**
```bash
curl -u user:password http://localhost:8080/user
```

**Expected Response:**
```html
<h1>Welcome User</h1>
```

**Status Code:** 200 OK

**With ADMIN credentials (should also succeed):**
```bash
curl -u admin:admin http://localhost:8080/admin
```

Admin has both USER and ADMIN roles, so can access user endpoint.

---

### Test 3: Admin Endpoint (Requires ADMIN Role)

**With USER credentials (should fail):**
```bash
curl -u user:password http://localhost:8080/admin
```

**Expected Response:**
```html
Access Denied / Forbidden
```

**Status Code:** 403 Forbidden

**With ADMIN credentials (should succeed):**
```bash
curl -u admin:admin http://localhost:8080/admin
```

**Expected Response:**
```html
<h1>Welcome Admin</h1>
```

**Status Code:** 200 OK

---

## 🌐 Browser Testing

### Method 1: Direct URL Access

1. Open browser and go to: `http://localhost:8080/user`
2. You'll see a login form
3. Enter username: `user` and password: `password`
4. Click "Sign In"
5. You should see: "Welcome User"

### Method 2: Login Page

1. Go to: `http://localhost:8080/login`
2. Enter credentials
3. Navigate to protected endpoints

### Test Matrix

| Endpoint | User Access | Admin Access | Public Access |
|----------|-------------|--------------|---------------|
| `/` | ✅ Yes | ✅ Yes | ✅ Yes |
| `/user` | ✅ Yes | ✅ Yes | ❌ No (401) |
| `/admin` | ❌ No (403) | ✅ Yes | ❌ No (401) |

## 🗄️ Step 4: Verify Database

Connect to MariaDB:
```bash
mysql -u root -p springsecurity
```

**Check users table:**
```sql
SELECT * FROM users;
```

**Expected Output:**
```
+----+----------+--------------------------------------------------------------+---------+
| id | username | password                                                     | enabled |
+----+----------+--------------------------------------------------------------+---------+
|  1 | user     | $2a$10$...                                                      |       1 |
|  2 | admin    | $2a$10$...                                                      |       1 |
+----+----------+--------------------------------------------------------------+---------+
```

**Check roles table:**
```sql
SELECT * FROM roles;
```

**Expected Output:**
```
+----+------------+
| id | name       |
+----+------------+
|  1 | ROLE_USER  |
|  2 | ROLE_ADMIN |
+----+------------+
```

**Check user_roles junction table:**
```sql
SELECT * FROM user_roles;
```

**Expected Output:**
```
+---------+---------+
| user_id | role_id |
+---------+---------+
|       1 |       1 |  -- user has ROLE_USER
|       2 |       1 |  -- admin has ROLE_USER
|       2 |       2 |  -- admin has ROLE_ADMIN
+---------+---------+
```

**View users with their roles:**
```sql
SELECT u.id, u.username, u.enabled, r.name as role
FROM users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.id
ORDER BY u.id;
```

**Expected Output:**
```
+----+----------+---------+------------+
| id | username | enabled | role       |
+----+----------+---------+------------+
|  1 | user     |       1 | ROLE_USER  |
|  2 | admin    |       1 | ROLE_USER  |
|  2 | admin    |       1 | ROLE_ADMIN |
+----+----------+---------+------------+
```

## 🔧 Advanced Testing with Postman

### Setup Collection

1. **Public Endpoint Test**
   - Method: GET
   - URL: `http://localhost:8080/`
   - Auth: None
   - Expected: 200 OK

2. **User Endpoint Test**
   - Method: GET
   - URL: `http://localhost:8080/user`
   - Auth: Basic Auth
     - Username: `user`
     - Password: `password`
   - Expected: 200 OK

3. **Admin Endpoint with User Credentials**
   - Method: GET
   - URL: `http://localhost:8080/admin`
   - Auth: Basic Auth
     - Username: `user`
     - Password: `password`
   - Expected: 403 Forbidden

4. **Admin Endpoint with Admin Credentials**
   - Method: GET
   - URL: `http://localhost:8080/admin`
   - Auth: Basic Auth
     - Username: `admin`
     - Password: `admin`
   - Expected: 200 OK

## 🐛 Troubleshooting

### Problem: Database Connection Refused

**Error Message:**
```
Communications link failure
```

**Solution:**
```bash
# Check if MariaDB is running (macOS)
brew services list

# Start MariaDB if not running
brew services start mariadb

# Or on Linux
sudo systemctl status mariadb
sudo systemctl start mariadb
```

### Problem: Users Not Created

**Error Message:**
```
User not found: user
```

**Solution:**
1. Check console logs for "Sample users created"
2. Verify DataInitializer is enabled (`@Component` is not commented out)
3. Check database: `SELECT * FROM users;`
4. If users don't exist, run the application again or insert manually

### Problem: Access Denied for All Users

**Error Message:**
```
403 Forbidden for all endpoints
```

**Solution:**
1. Verify role names have "ROLE_" prefix: `SELECT * FROM roles;`
2. Check user-role associations: `SELECT * FROM user_roles;`
3. Ensure BCrypt passwords are used, not plain text

### Problem: Password Not Matching

**Error Message:**
```
Bad credentials
```

**Solution:**
1. Passwords must be BCrypt encoded in database
2. DataInitializer handles encoding automatically
3. Don't manually insert plain text passwords
4. Test with default credentials first: `user/password` or `admin/admin`

## 📊 Load Testing (Optional)

### Using Apache Bench

**Test public endpoint:**
```bash
ab -n 1000 -c 10 http://localhost:8080/
```

**Test authenticated endpoint:**
```bash
ab -n 1000 -c 10 -A user:password http://localhost:8080/user
```

### Expected Performance

- Public endpoint: < 50ms average
- Authenticated endpoint: < 100ms average

## ✅ Success Criteria

Your implementation is successful if:

1. ✅ Application starts without errors
2. ✅ Database tables are created automatically
3. ✅ Sample users are inserted on first run
4. ✅ Public endpoint accessible without authentication
5. ✅ User endpoint requires authentication
6. ✅ Admin endpoint requires ADMIN role
7. ✅ User with USER role cannot access admin endpoint
8. ✅ Admin with ADMIN role can access all endpoints
9. ✅ Passwords are BCrypt encoded in database
10. ✅ Login page appears for protected endpoints

## 📝 Next Steps

After successful testing:

1. **Comment out DataInitializer** to prevent duplicate users:
   ```java
   // @Component  // Comment this line
   public class DataInitializer implements CommandLineRunner {
   ```

2. **Change default passwords** in production

3. **Add more users** via REST API or database

4. **Implement user registration** endpoint

5. **Add password change** functionality

6. **Configure HTTPS** for production

7. **Add JWT authentication** for stateless API

## 🎯 Test Summary Template

Copy and fill this after testing:

```
✅ Database Setup: [PASS/FAIL]
✅ Application Start: [PASS/FAIL]
✅ User Creation: [PASS/FAIL]
✅ Public Endpoint: [PASS/FAIL]
✅ User Authentication: [PASS/FAIL]
✅ Admin Authorization: [PASS/FAIL]
✅ Access Control: [PASS/FAIL]

Notes:
__________________________________
__________________________________
```

---

**Happy Testing! 🚀**

