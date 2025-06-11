CREATE TABLE [dbo].[t_order] (
    [f_orderId]     INT           IDENTITY (1, 1) NOT NULL,
    [f_memberId]    INT           NOT NULL,
    [f_planId]      INT           NOT NULL,
    [f_planType]    TINYINT       NOT NULL,
    [f_planName]    NVARCHAR (20) NOT NULL,
    [f_orderNumber] BIGINT        NOT NULL,
    [f_state]       TINYINT       NOT NULL,
    [f_amount]      INT           NOT NULL,
    [f_method]      TINYINT       NOT NULL,
    [f_remark]      NVARCHAR (50) CONSTRAINT [DF__t_order__f_remar__14E61A24] DEFAULT ('') NOT NULL,
    [f_createTime]  DATETIME2 (3) CONSTRAINT [DF__t_order__f_creat__15DA3E5D] DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]  DATETIME2 (3) CONSTRAINT [DF__t_order__f_updat__16CE6296] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_t_order_f_orderId] PRIMARY KEY CLUSTERED ([f_orderId] ASC),
    CONSTRAINT [FK_t_order_f_memberId] FOREIGN KEY ([f_memberId]) REFERENCES [dbo].[t_member] ([f_memberId]),
    CONSTRAINT [UQ__t_order__3CDB0863545F1D4B] UNIQUE NONCLUSTERED ([f_orderNumber] ASC)
);

