CREATE TABLE [dbo].[t_leaseAgreement] (
    [f_leaseAgreementId] INT           IDENTITY (1, 1) NOT NULL,
    [f_startTime]        DATE          NOT NULL,
    [f_endTime]          DATE          NOT NULL,
    [f_remind]           BIT           DEFAULT ((0)) NOT NULL,
    [f_remark]           NVARCHAR (50) DEFAULT ('') NOT NULL,
    [f_status]           TINYINT       DEFAULT ((1)) NOT NULL,
    [f_reminderLeadTime] INT           NOT NULL,
    [f_createTime]       DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]       DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL
);

