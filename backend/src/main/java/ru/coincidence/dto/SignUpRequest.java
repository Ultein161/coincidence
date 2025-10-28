package ru.coincidence.dto;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * @author kay 06.10.2025
 */
public record SignUpRequest(
        @NotBlank(message = "Username is required")
        @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
        @JsonProperty("username") String username,
        
        @NotBlank(message = "Password is required")
        @Size(min = 6, message = "Password must be at least 6 characters")
        @JsonProperty("password") String password,
        
        @NotBlank(message = "Surname is required")
        @Size(max = 100, message = "Surname must not exceed 100 characters")
        @JsonProperty("surname") String surname,
        
        @NotBlank(message = "First name is required")
        @Size(max = 100, message = "First name must not exceed 100 characters")
        @JsonProperty("firstname") String firstname,
        
        @Email(message = "Email must be valid")
        @JsonProperty("email") String email
) {
}
