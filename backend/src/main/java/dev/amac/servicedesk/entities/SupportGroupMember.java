
package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "tb_support_group_member")
public class SupportGroupMember implements Serializable {

	private static final long serialVersionUID = 1L;

    @EmbeddedId
    private SupportGroupMemberId id;

    // Associations

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("userId")
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("supportGroupId")
    @JoinColumn(name = "support_group_id", nullable = false)
    private SupportGroup supportGroup;

    // Membership

    @Column(nullable = false, updatable = false)
    private Instant joinedAt;

    private Instant leftAt;

    @Column(nullable = false)
    private boolean active = true;

    @Column(nullable = false)
    private boolean isDefault = false;

    // Permissions

    @Column(nullable = false)
    private boolean canAssignTickets = false;

    @Column(nullable = false)
    private boolean canManageGroup = false;

    // Performance indicators

    @Column(nullable = false)
    private Integer ticketsAssigned = 0;

    @Column(nullable = false)
    private Integer ticketsResolved = 0;

    // Times expressed in seconds

    private Long averageResolutionTime;

    private Long averageFirstResponseTime;

    // Ratings (0.00 - 99.99)

    @Column(precision = 4, scale = 2)
    private BigDecimal responseRating;

    @Column(precision = 4, scale = 2)
    private BigDecimal resolutionRating;

    // Constructors

    protected SupportGroupMember() {
    }

    public SupportGroupMember(User user, SupportGroup supportGroup) {

        this.user = Objects.requireNonNull(user, "User cannot be null");
        this.supportGroup = Objects.requireNonNull(
            supportGroup,
            "SupportGroup cannot be null"
        );

        if (user.getId() == null || supportGroup.getId() == null) {
            throw new IllegalArgumentException(
                "User and SupportGroup must already be persisted"
            );
        }

        this.id = new SupportGroupMemberId(
            supportGroup.getId(),
            user.getId()
        );
    }

    // Lifecycle callbacks

    @PrePersist
    protected void onCreate() {
        if (joinedAt == null) {
            joinedAt = Instant.now();
        }
    }

    // Getters

    public SupportGroupMemberId getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public SupportGroup getSupportGroup() {
        return supportGroup;
    }

    public Instant getJoinedAt() {
        return joinedAt;
    }

    public Instant getLeftAt() {
        return leftAt;
    }

    public boolean isActive() {
        return active;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public boolean isCanAssignTickets() {
        return canAssignTickets;
    }

    public boolean isCanManageGroup() {
        return canManageGroup;
    }

    public Integer getTicketsAssigned() {
        return ticketsAssigned;
    }

    public Integer getTicketsResolved() {
        return ticketsResolved;
    }

    public Long getAverageResolutionTime() {
        return averageResolutionTime;
    }

    public Long getAverageFirstResponseTime() {
        return averageFirstResponseTime;
    }

    public BigDecimal getResponseRating() {
        return responseRating;
    }

    public BigDecimal getResolutionRating() {
        return resolutionRating;
    }

    // Setters

    public void setJoinedAt(Instant joinedAt) {
        this.joinedAt = joinedAt;
    }

    public void setLeftAt(Instant leftAt) {
        this.leftAt = leftAt;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public void setCanAssignTickets(boolean canAssignTickets) {
        this.canAssignTickets = canAssignTickets;
    }

    public void setCanManageGroup(boolean canManageGroup) {
        this.canManageGroup = canManageGroup;
    }

    public void setTicketsAssigned(Integer ticketsAssigned) {
        this.ticketsAssigned = ticketsAssigned;
    }

    public void setTicketsResolved(Integer ticketsResolved) {
        this.ticketsResolved = ticketsResolved;
    }

    public void setAverageResolutionTime(Long averageResolutionTime) {
        this.averageResolutionTime = averageResolutionTime;
    }

    public void setAverageFirstResponseTime(Long averageFirstResponseTime) {
        this.averageFirstResponseTime = averageFirstResponseTime;
    }

    public void setResponseRating(BigDecimal responseRating) {
        this.responseRating = responseRating;
    }

    public void setResolutionRating(BigDecimal resolutionRating) {
        this.resolutionRating = resolutionRating;
    }

    // equals and hashCode

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }

        if (!(obj instanceof SupportGroupMember other)) {
            return false;
        }

        return id != null && id.equals(other.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
