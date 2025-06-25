CREATE TABLE t_memberPersonalClass(
	f_memberPersonalClassId	INT IDENTITY PRIMARY KEY,
	f_memberId	INT NOT NULL,
	f_coachId	INT NOT NULL,
	f_memberPersonalTrainingPackageId	INT NOT NULL,
	f_time	DATETIME2(3) NOT NULL,
	f_category	BIT NOT NULL,
	f_remind	BIT NOT NULL DEFAULT 1,
	f_status	TINYINT NOT NULL DEFAULT 1,
	f_remark	NVARCHAR(20) NOT NULL DEFAULT '',
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (f_memberId) REFERENCES t_member(f_memberId),
    FOREIGN KEY (f_coachId) REFERENCES t_coach(f_coachId)
)