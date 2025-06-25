CREATE TABLE [dbo].[t_penalty] (
    [f_penaltyId]  INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]    INT           NOT NULL,
    [f_amount]     INT           NOT NULL,
    [f_createTime] DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_penaltyId] ASC),
    FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

