CREATE TABLE t_memberPersonalTrainingPackage(
	f_memberPersonalTrainingPackageId	INT NOT NULL IDENTITY PRIMARY KEY,
	f_orderId	INT NOT NULL,
	f_coachId	INT NOT NULL,
	f_memberId	INT NOT NULL,
	f_planName	VARCHAR(20) NOT NULL,
	f_sessionCount	INT NOT NULL,
	f_status	TINYINT NOT NULL DEFAULT 1,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	CONSTRAINT FK_t_memberPersonalTrainingPackage_t_member FOREIGN KEY (f_memberId) REFERENCES t_member(f_memberId),
	CONSTRAINT FK_t_memberPersonalTrainingPackage_t_coach FOREIGN KEY (f_coachId) REFERENCES t_coach(f_coachId),
	CONSTRAINT FK_t_memberPersonalTrainingPackage_t_order FOREIGN KEY (f_orderId) REFERENCES t_order(f_orderId)
)