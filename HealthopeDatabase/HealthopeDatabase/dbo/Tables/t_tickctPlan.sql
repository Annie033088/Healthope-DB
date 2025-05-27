CREATE TABLE [dbo].[t_tickctPlan] (
    [f_ticketPlanId] INT           IDENTITY (1, 1) NOT NULL,
    [f_price]        INT           NOT NULL,
    [f_status]       BIT           NOT NULL,
    [f_updateTime]   DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL
);

