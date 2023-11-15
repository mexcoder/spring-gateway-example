package com.example.gateway.gateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
public class SecurityConfig {
    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http){

        return http
                .authorizeExchange(request ->
                        request
                                .pathMatchers("/api/v1/hello/**", "/api/v1/bye/**")
                                .permitAll()
                                .anyExchange()
                                .authenticated()

                )
                .oauth2Login(Customizer.withDefaults())
                .build();

    }
}