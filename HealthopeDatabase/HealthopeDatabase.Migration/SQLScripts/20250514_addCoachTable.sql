CREATE TABLE t_coach (
    f_coachId INT NOT NULL IDENTITY PRIMARY KEY,
    f_account VARCHAR(20) NOT NULL,
    f_hash VARCHAR(100) NOT NULL,
    f_email VARCHAR(254) NOT NULL,
    f_phone INT NOT NULL,
    f_name NVARCHAR(15) NOT NULL,
    f_photoUrl NVARCHAR(100) NOT NULL,
    f_introduction NVARCHAR(50) NOT NULL,
    f_specialty NVARCHAR(200) NOT NULL,
    f_certification NVARCHAR(200) NOT NULL,
    f_status BIT NOT NULL DEFAULT 0,
    f_type TINYINT NOT NULL,
    f_contractStartTime DATE NOT NULL DEFAULT '0001-01-01',
    f_contractEndTime DATE NOT NULL DEFAULT '0001-01-01',
    f_createTime DATETIME NOT NULL DEFAULT GETDATE(),
    f_updateTime DATETIME NOT NULL DEFAULT GETDATE()
);
