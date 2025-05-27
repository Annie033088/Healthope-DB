CREATE TABLE [dbo].[t_membershipPlan] (
    [f_membershipPlanId] INT            IDENTITY (1, 1) NOT NULL,
    [f_name]             NVARCHAR (20)  NOT NULL,
    [f_price]            INT            NOT NULL,
    [f_duration]         TINYINT        NOT NULL,
    [f_introduction]     NVARCHAR (200) NOT NULL,
    [f_imageUrl]         NVARCHAR (100) NOT NULL,
    [f_display]          BIT            NOT NULL,
    [f_status]           BIT            NOT NULL,
    [f_createTime]       DATETIME2 (3)  DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]       DATETIME2 (3)  DEFAULT (sysutcdatetime()) NOT NULL
);

