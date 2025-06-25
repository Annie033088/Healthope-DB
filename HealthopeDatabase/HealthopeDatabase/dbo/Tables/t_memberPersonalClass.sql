CREATE TABLE [dbo].[t_memberPersonalClass] (
    [f_memberPersonalClassId]           INT           IDENTITY (1, 1) NOT NULL,
    [f_memberId]                        INT           NOT NULL,
    [f_coachId]                         INT           NOT NULL,
    [f_memberPersonalTrainingPackageId] INT           NOT NULL,
    [f_time]                            DATETIME2 (3) NOT NULL,
    [f_category]                        BIT           NOT NULL,
    [f_remind]                          BIT           DEFAULT ((1)) NOT NULL,
    [f_status]                          TINYINT       DEFAULT ((1)) NOT NULL,
    [f_remark]                          NVARCHAR (20) DEFAULT ('') NOT NULL,
    [f_updateTime]                      DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_memberPersonalClassId] ASC),
    FOREIGN KEY ([f_coachId]) REFERENCES [dbo].[t_coach] ([f_coachId]),
    FOREIGN KEY ([f_memberId]) REFERENCES [dbo].[t_member] ([f_memberId])
);

