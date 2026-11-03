
package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "tb_user")
public class User implements Serializable {

	private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 50)
    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @NotBlank
    @Size(max = 150)
    @Column(nullable = false, length = 150)
    private String name;

    @NotBlank
    @Email
    @Size(max = 254)
    @Column(nullable = false, unique = true, length = 254)
    private String email;

    @NotBlank
    @Size(max = 255)
    @Column(nullable = false, length = 255)
    private String passwordHash;

    @Column(nullable = false)
    private boolean active = true;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private Instant updatedAt;
    
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<SupportGroupMember> supportGroupMembers = new HashSet<>();
    
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<TicketComment> ticketComments = new HashSet<>();
    
    @OneToMany(mappedBy = "uploadedBy", fetch = FetchType.LAZY)
    private Set<TicketAttachment> uploadedAttachments = new HashSet<>();
    
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<TicketHistory> ticketHistory = new HashSet<>();

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<TicketWatcher> watchedTickets = new HashSet<>();
    
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<TicketWorklog> ticketWorklogs = new HashSet<>();
            
    protected User() {
        // Construtor exigido pelo JPA
    }

    public User(String username, String name,
                String email, String passwordHash) {
        this.username = username;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.active = true;
    }

    @PrePersist
    protected void onCreate() {
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
    
    //SupportGroups in which this user is
    public List<SupportGroup> getSupportGroups() {
        return supportGroupMembers.stream()
            .map(SupportGroupMember::getSupportGroup)
            .toList();
    }
    
    // Returns the ticket comments made by this user
    public List<TicketComment> getTicketComments() {
        return new ArrayList<>(ticketComments);
    }

    public Set<TicketAttachment> getUploadedAttachments() {
        return uploadedAttachments;
    }
    
    public List<TicketHistory> getTicketHistory() {
        return new ArrayList<>(ticketHistory);
    }
    
    public List<TicketWatcher> getWatchedTickets() {
        return new ArrayList<>(watchedTickets);
    }

    public List<TicketWorklog> getTicketWorklogs() {
        return new ArrayList<>(ticketWorklogs);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }

        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        User other = (User) obj;
        return id != null && id.equals(other.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
