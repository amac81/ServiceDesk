package dev.amac.servicedesk.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import dev.amac.servicedesk.entities.User;

public interface UserRepository extends JpaRepository<User, Long> {

}