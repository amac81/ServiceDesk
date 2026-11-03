package dev.amac.servicedesk.entities;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class SupportGroupMemberId implements Serializable {

    private static final long serialVersionUID = 1L;

    @Column(name = "support_group_id")
    private Long supportGroupId;

    @Column(name = "user_id")
    private Long userId;

    protected SupportGroupMemberId() {
    }

    public SupportGroupMemberId(Long supportGroupId, Long userId) {
        this.supportGroupId = supportGroupId;
        this.userId = userId;
    }

	public Long getSupportGroupId() {
		return supportGroupId;
	}

	public void setSupportGroupId(Long supportGroupId) {
		this.supportGroupId = supportGroupId;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	@Override
	public int hashCode() {
		return Objects.hash(supportGroupId, userId);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SupportGroupMemberId other = (SupportGroupMemberId) obj;
		return Objects.equals(supportGroupId, other.supportGroupId) && Objects.equals(userId, other.userId);
	}	

	
}
