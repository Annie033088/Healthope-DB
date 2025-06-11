CREATE TABLE t_electronicInvoice(
	f_electronicInvoiceId	INT	NOT NULL IDENTITY,
	f_orderId	INT	NOT NULL,	
	f_invoiceNumber	CHAR(10) NOT NULL,	
	f_invoiceTime	DATETIME2(3) NOT NULL,
	f_randomNumber	CHAR(4)	NOT NULL,
	f_buyer	CHAR(8)	NOT NULL,
	f_totalAmount	INT	NOT NULL,
	f_type	TINYINT	NOT NULL,
	f_barcode	VARCHAR(19)	NOT NULL,	
	f_qrCodeLeft	NVARCHAR(127) NOT NULL,	
	f_qrCodeRight	NVARCHAR(61) NOT NULL,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (f_orderId) REFERENCES t_order(f_orderId)
)