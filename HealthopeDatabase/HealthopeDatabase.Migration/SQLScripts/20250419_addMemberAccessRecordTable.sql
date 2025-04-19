CREATE TABLE t_memberAccessRecord(
	f_memberAccessRecordId INT PRIMARY KEY IDENTITY,
	f_memberId INT NOT NULL,
	f_entryTime DATETIME NOT NULL,
	f_exitTime DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00'
	CONSTRAINT fk_memberAccessRecordMemberId FOREIGN KEY (f_memberId) REFERENCES t_member(f_memberId)
)