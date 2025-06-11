CREATE TABLE [dbo].[t_memberPersonalTrainingPackage] (
    [f_memberPersonalTrainingPackageId] INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]                         INT           NOT NULL,
    [f_coachId]                         INT           NOT NULL,
    [f_memberId]                        INT           NOT NULL,
    [f_planName]                        VARCHAR (20)  NOT NULL,
    [f_sessionCount]                    INT           NOT NULL,
    [f_status]                          TINYINT       DEFAULT ((1)) NOT NULL,
    [f_createTime]                      DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]                      DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_memberPersonalTrainingPackageId] ASC),
    CONSTRAINT [FK_t_memberPersonalTrainingPackage_t_coach] FOREIGN KEY ([f_coachId]) REFERENCES [dbo].[t_coach] ([f_coachId]),
    CONSTRAINT [FK_t_memberPersonalTrainingPackage_t_member] FOREIGN KEY ([f_memberId]) REFERENCES [dbo].[t_member] ([f_memberId]),
    CONSTRAINT [FK_t_memberPersonalTrainingPackage_t_order] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

