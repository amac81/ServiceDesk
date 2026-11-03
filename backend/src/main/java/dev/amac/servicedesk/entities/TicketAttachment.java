package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

@Entity
@Table(name = "tb_ticket_attachment")
public class TicketAttachment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_comment_id")
    private TicketComment ticketComment;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "uploaded_by", nullable = false)
    private User uploadedBy;

    @NotBlank
    @Column(nullable = false, length = 255)
    private String fileName;

    @NotBlank
    @Column(nullable = false, length = 150)
    private String contentType;

    @Positive
    @Column(nullable = false)
    private Long fileSize;

    @NotBlank
    @Column(nullable = false, length = 500)
    private String storagePath;

    @Column(nullable = false, updatable = false)
    private Instant uploadedAt;

    protected TicketAttachment() {
    }

    public TicketAttachment(
            Ticket ticket,
            User uploadedBy,
            String fileName,
            String contentType,
            Long fileSize,
            String storagePath) {

        this.ticket = Objects.requireNonNull(ticket);
        this.uploadedBy = Objects.requireNonNull(uploadedBy);
        this.fileName = Objects.requireNonNull(fileName);
        this.contentType = Objects.requireNonNull(contentType);
        this.fileSize = Objects.requireNonNull(fileSize);
        this.storagePath = Objects.requireNonNull(storagePath);
    }

    @PrePersist
    protected void onCreate() {
        this.uploadedAt = Instant.now();
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Ticket getTicket() {
		return ticket;
	}

	public void setTicket(Ticket ticket) {
		this.ticket = ticket;
	}

	public TicketComment getTicketComment() {
		return ticketComment;
	}

	public void setTicketComment(TicketComment ticketComment) {
		this.ticketComment = ticketComment;
	}

	public User getUploadedBy() {
		return uploadedBy;
	}

	public void setUploadedBy(User uploadedBy) {
		this.uploadedBy = uploadedBy;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public Long getFileSize() {
		return fileSize;
	}

	public void setFileSize(Long fileSize) {
		this.fileSize = fileSize;
	}

	public String getStoragePath() {
		return storagePath;
	}

	public void setStoragePath(String storagePath) {
		this.storagePath = storagePath;
	}

	public Instant getUploadedAt() {
		return uploadedAt;
	}

	public void setUploadedAt(Instant uploadedAt) {
		this.uploadedAt = uploadedAt;
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
		TicketAttachment other = (TicketAttachment) obj;
		return Objects.equals(id, other.id);
	}

    
}