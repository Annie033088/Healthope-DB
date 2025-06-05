CREATE TABLE t_invoiceTrackNumber(
f_invoiceTrackNumberId	INT IDENTITY,
f_trackPrefix CHAR(2) NOT NULL,
f_startNumber	INT NOT NULL,
f_endNumber	INT NOT NULL,
f_currentNumber	INT NOT NULL,
f_invoicePeriod	INT NOT NULL,
f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
)