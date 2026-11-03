package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Objects;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "tb_ticket_worklog")
public class TicketWorklog implements Serializable {

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

    @NotBlank
    @Size(max = 1000)
    @Column(nullable = false, length = 1000)
    private String description;

    @Positive
    @Column(nullable = false)
    private Integer timeSpent;

    @Column(nullable = false)
    private LocalDate workDate;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    protected TicketWorklog() {
    }

    public TicketWorklog(
            Ticket ticket,
            User user,
            String description,
            Integer timeSpent,
            LocalDate workDate) {

        this.ticket = Objects.requireNonNull(ticket, "Ticket não pode ser nulo");
        this.user = Objects.requireNonNull(user, "Utilizador não pode ser nulo");
        this.description = Objects.requireNonNull(description, "Descrição não pode ser nula");
        this.timeSpent = Objects.requireNonNull(timeSpent, "Tempo despendido não pode ser nulo");
        this.workDate = Objects.requireNonNull(workDate, "Data de trabalho não pode ser nula");

        if (timeSpent <= 0) {
            throw new IllegalArgumentException("O tempo despendido deve ser superior a zero.");
        }
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

    public String getDescription() {
        return description;
    }

    public Integer getTimeSpent() {
        return timeSpent;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    // Setters

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setTimeSpent(Integer timeSpent) {
        if (timeSpent == null || timeSpent <= 0) {
            throw new IllegalArgumentException("O tempo despendido deve ser superior a zero.");
        }
        this.timeSpent = timeSpent;
    }

    public void setWorkDate(LocalDate workDate) {
        this.workDate = Objects.requireNonNull(workDate);
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
		TicketWorklog other = (TicketWorklog) obj;
		return Objects.equals(id, other.id);
	}
    
    
    
}