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
    public void run(String... args) {
        // Ensure roles exist (idempotent)
        Role userRole = roleRepository.findByName("ROLE_USER").orElseGet(() -> roleRepository.save(new Role("ROLE_USER")));
        Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElseGet(() -> roleRepository.save(new Role("ROLE_ADMIN")));

        // Ensure 'user' exists with ROLE_USER
        User user = userRepository.findByUsername("user").orElseGet(() -> {
            User newUser = new User("user", passwordEncoder.encode("password"), true);
            return userRepository.save(newUser);
        });
        // Ensure ROLE_USER is assigned to 'user'
        if (user.getRoles().stream().noneMatch(r -> "ROLE_USER".equals(r.getName()))) {
            user.addRole(userRole);
            userRepository.save(user);
        }

        // Ensure 'admin' exists
        User admin = userRepository.findByUsername("admin").orElseGet(() -> {
            User newAdmin = new User("admin", passwordEncoder.encode("admin"), true);
            return userRepository.save(newAdmin);
        });
        // Ensure ROLE_ADMIN and ROLE_USER are assigned to 'admin'
        boolean adminHasUserRole = admin.getRoles().stream().anyMatch(r -> "ROLE_USER".equals(r.getName()));
        boolean adminHasAdminRole = admin.getRoles().stream().anyMatch(r -> "ROLE_ADMIN".equals(r.getName()));
        if (!adminHasUserRole) {
            admin.addRole(userRole);
        }
        if (!adminHasAdminRole) {
            admin.addRole(adminRole);
        }
        if (!adminHasUserRole || !adminHasAdminRole) {
            userRepository.save(admin);
        }

        System.out.println("Data initialization complete:");
        System.out.printf("User present: %s, roles: %s\n", user.getUsername(), user.getRoles());
        System.out.printf("Admin present: %s, roles: %s\n", admin.getUsername(), admin.getRoles());
    }
}
