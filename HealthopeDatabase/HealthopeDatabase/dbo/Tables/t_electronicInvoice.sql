CREATE TABLE [dbo].[t_electronicInvoice] (
    [f_electronicInvoiceId] INT           IDENTITY (1, 1) NOT NULL,
    [f_orderId]             INT           NOT NULL,
    [f_invoiceNumber]       CHAR (10)     NOT NULL,
    [f_invoiceTime]         DATETIME2 (3) NOT NULL,
    [f_randomNumber]        CHAR (4)      NOT NULL,
    [f_buyer]               CHAR (8)      NOT NULL,
    [f_totalAmount]         INT           NOT NULL,
    [f_type]                TINYINT       NOT NULL,
    [f_createTime]          DATETIME2 (3) DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_t_electronicInvoice_f_electronicInvoiceId] PRIMARY KEY CLUSTERED ([f_electronicInvoiceId] ASC),
    CONSTRAINT [FK__t_electro__f_ord__1D7B6025] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

