CREATE TABLE [dbo].[t_creditCardTransaction] (
    [f_creditCardTransactionId] INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]                 INT           NOT NULL,
    [f_authCode]                VARCHAR (7)   CONSTRAINT [DF__t_creditC__f_aut__69C6B1F5] DEFAULT ('') NOT NULL,
    [f_cardLastFour]            CHAR (4)      CONSTRAINT [DF__t_creditC__f_car__6ABAD62E] DEFAULT ('') NOT NULL,
    [f_cardType]                VARCHAR (30)  CONSTRAINT [DF__t_creditC__f_car__6BAEFA67] DEFAULT ('') NOT NULL,
    [f_transactionId]           CHAR (36)     CONSTRAINT [DF__t_creditC__f_tra__6CA31EA0] DEFAULT ('') NOT NULL,
    [f_amount]                  INT           NOT NULL,
    [f_status]                  TINYINT       CONSTRAINT [DF__t_creditC__f_sta__6D9742D9] DEFAULT ((1)) NOT NULL,
    [f_createTime]              DATETIME2 (3) CONSTRAINT [DF__t_creditC__f_cre__6E8B6712] DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]              DATETIME2 (3) CONSTRAINT [DF__t_creditC__f_upd__6F7F8B4B] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_t_creditCardTransaction] PRIMARY KEY CLUSTERED ([f_creditCardTransactionId] ASC),
    CONSTRAINT [FK_t_creditCardTransaction_orderId] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

