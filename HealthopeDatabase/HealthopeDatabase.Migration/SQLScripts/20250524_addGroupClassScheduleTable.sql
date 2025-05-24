CREATE TABLE t_groupClassSchedule(
	f_groupClassScheduleId INT PRIMARY KEY IDENTITY,
	f_coachId INT NOT NULL,
	f_className VARCHAR(20) NOT NULL,
	f_category INT NOT NULL,
	f_icon INT NOT NULL,
	f_coachName NVARCHAR(15) NOT NULL,
	f_time DATETIME2(0) NOT NULL,
	f_place NVARCHAR(10) NOT NULL,
	f_maximumParticipant TINYINT NOT NULL,
	f_reserveParticipant TINYINT NOT NULL DEFAULT 0,
	f_checkInParticipant TINYINT NOT NULL DEFAULT 0,
	f_tag TINYINT NOT NULL DEFAULT 1,
	f_status TINYINT NOT NULL,
	f_createTime DATETIME NOT NULL DEFAULT GETDATE(),
	f_updateTime DATETIME NOT NULL DEFAULT GETDATE()
    CONSTRAINT FK_GroupClassSchedule_CoachId FOREIGN KEY (f_coachId) REFERENCES t_coach(f_coachId)
)