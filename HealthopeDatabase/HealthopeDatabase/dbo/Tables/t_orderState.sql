CREATE TABLE [dbo].[t_orderState] (
    [f_orderStateId] INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]      INT           NOT NULL,
    [f_state]        TINYINT       CONSTRAINT [DF_t_orderState_f_state] DEFAULT ('') NOT NULL,
    [f_remark]       NVARCHAR (50) CONSTRAINT [DF_t_orderState_f_remark] DEFAULT ('') NOT NULL,
    [f_createTime]   DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]   DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_t_orderState_f_orderStateId] PRIMARY KEY CLUSTERED ([f_orderStateId] ASC),
    CONSTRAINT [FK__t_orderSt__f_ord__214BF109] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

