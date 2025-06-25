CREATE PROCEDURE pro_healthope_editElectronicInvoiceStatus
	@success BIT, 
	@electronicInvoiceId INT, 
	@invocieTime DATETIME2(3)
AS
BEGIN
	-- 電子發票狀態碼
	DECLARE @statusSuccess INT = 2, @statusFail INT = 3

	IF @success = 1
	UPDATE t_electronicInvoice WITH(ROWLOCK)
	SET f_invoiceTime = @invocieTime, f_status = @statusSuccess
	WHERE f_electronicInvoiceId = @electronicInvoiceId
	ELSE
	UPDATE t_electronicInvoice WITH(ROWLOCK)
	SET f_status = @statusFail
	WHERE f_electronicInvoiceId = @electronicInvoiceId
END