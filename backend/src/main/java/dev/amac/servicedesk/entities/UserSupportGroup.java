
package dev.amac.servicedesk.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

import java.time.Instant;

@Entity
@Table(
    name = "tb_user_support_group",
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uk_user_support_group",
            columnNames = {"user_id", "support_group_id"}
        )
    }
)
public class UserSupportGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "support_group_id", nullable = false)
    private SupportGroup supportGroup;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    protected UserSupportGroup() {
    }

    public UserSupportGroup(User user, SupportGroup supportGroup) {
        this.user = user;
        this.supportGroup = supportGroup;
    }

    @jakarta.persistence.PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public SupportGroup getSupportGroup() {
        return supportGroup;
    }

    public void setSupportGroup(SupportGroup supportGroup) {
        this.supportGroup = supportGroup;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
