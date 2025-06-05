CREATE TABLE [dbo].[t_invoiceTrackNumber] (
    [f_invoiceTrackNumberId] INT           IDENTITY (1, 1) NOT NULL,
    [f_trackPrefix]          CHAR (2)      NOT NULL,
    [f_startNumber]          INT           NOT NULL,
    [f_endNumber]            INT           NOT NULL,
    [f_currentNumber]        INT           NOT NULL,
    [f_invoicePeriod]        INT           NOT NULL,
    [f_createTime]           DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    [f_status]               TINYINT       DEFAULT ((1)) NOT NULL,
    [f_updateTime]           DATETIME2 (3) CONSTRAINT [DF_t_invoiceTrackNumber_f_updateTime] DEFAULT (sysutcdatetime()) NOT NULL
);

