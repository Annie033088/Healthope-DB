CREATE TABLE [dbo].[t_memberMembershipPlan] (
    [f_memberMembershipPlanId] INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]                INT           NOT NULL,
    [f_memberId]               INT           NOT NULL,
    [f_planName]               VARCHAR (20)  NOT NULL,
    [f_duration]               TINYINT       NOT NULL,
    [f_status]                 TINYINT       DEFAULT ((1)) NOT NULL,
    [f_createTime]             DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]             DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_memberMembershipPlanId] ASC),
    CONSTRAINT [FK_t_memberMembershipPlan_t_member] FOREIGN KEY ([f_memberId]) REFERENCES [dbo].[t_member] ([f_memberId]),
    CONSTRAINT [FK_t_memberMembershipPlan_t_order] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

