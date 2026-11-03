package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

import jakarta.persistence.*;

@Entity
@Table(
    name = "tb_ticket_watcher",
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uk_ticket_watcher",
            columnNames = {"ticket_id", "user_id"}
        )
    }
)
public class TicketWatcher implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private boolean active = true;

    protected TicketWatcher() {
    }

    public TicketWatcher(Ticket ticket, User user) {
        this.ticket = Objects.requireNonNull(ticket, "Ticket não pode ser nulo");
        this.user = Objects.requireNonNull(user, "Utilizador não pode ser nulo");
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = Instant.now();
    }

    // Getters

    public Long getId() {
        return id;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public User getUser() {
        return user;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public boolean isActive() {
        return active;
    }

    // Setters

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

	public void setId(Long id) {
		this.id = id;
	}

	public void setCreatedAt(Instant createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		TicketWatcher other = (TicketWatcher) obj;
		return Objects.equals(id, other.id);
	}
    
}