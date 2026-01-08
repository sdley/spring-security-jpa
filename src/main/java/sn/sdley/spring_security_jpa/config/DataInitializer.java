package sn.sdley.spring_security_jpa.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import sn.sdley.spring_security_jpa.model.Role;
import sn.sdley.spring_security_jpa.model.User;
import sn.sdley.spring_security_jpa.repository.RoleRepository;
import sn.sdley.spring_security_jpa.repository.UserRepository;

/**
 * This class initializes the database with sample users and roles.
 * Comment out @Component annotation after first run to avoid duplicate entries.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Check if users already exist
        if (userRepository.count() == 0) {
            // Create and save roles first
            Role userRole = roleRepository.save(new Role("ROLE_USER"));
            Role adminRole = roleRepository.save(new Role("ROLE_ADMIN"));

            // Create user with USER role
            User user = new User("user", passwordEncoder.encode("password"), true);
            user.addRole(userRole);

            // Create admin with ADMIN and USER roles
            User admin = new User("admin", passwordEncoder.encode("admin"), true);
            admin.addRole(adminRole);
            admin.addRole(userRole);

            // Save users to database
            userRepository.save(user);
            userRepository.save(admin);

            System.out.println("Sample users created:");
            System.out.println("User - username: user, password: password");
            System.out.println("Admin - username: admin, password: admin");
        } else {
            System.out.println("Users already exist in database. Skipping initialization.");
        }
    }
}

