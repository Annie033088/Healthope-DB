CREATE TABLE t_memberMembershipPlan(
	f_memberMembershipPlanId	INT NOT NULL IDENTITY PRIMARY KEY,
	f_orderId	INT NOT NULL,
	f_memberId	INT NOT NULL,
	f_planName	VARCHAR(20) NOT NULL,
	f_duration	TINYINT NOT NULL,
	f_status	TINYINT NOT NULL DEFAULT 1,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	CONSTRAINT FK_t_memberMembershipPlan_t_member FOREIGN KEY (f_memberId) REFERENCES t_member(f_memberId),
	CONSTRAINT FK_t_memberMembershipPlan_t_order FOREIGN KEY (f_orderId) REFERENCES t_order(f_orderId)
)