CREATE TABLE t_tickctPlan(
	f_ticketPlanId	INT IDENTITY,
	f_price	INT NOT NULL,
	f_status	BIT NOT NULL,
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
)

CREATE TABLE t_membershipPlan(
	f_membershipPlanId	INT IDENTITY,
	f_name	NVARCHAR(20) NOT NULL,
	f_price	INT NOT NULL,
	f_duration	TINYINT NOT NULL,
	f_introduction	NVARCHAR(200) NOT NULL,
	f_imageUrl	NVARCHAR(100) NOT NULL,
	f_display	BIT NOT NULL,
	f_status	BIT NOT NULL,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
)

CREATE TABLE t_personalTrainingPackage(
	f_personalTrainingPackageId	INT IDENTITY,
	f_name	NVARCHAR(20) NOT NULL,
	f_price	INT NOT NULL,
	f_sessionCount	INT NOT NULL,
	f_introduction	NVARCHAR(200) NOT NULL,
	f_imageUrl	NVARCHAR(100) NOT NULL,
	f_display	BIT NOT NULL,
	f_status	BIT NOT NULL,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
	f_updateTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
)