CREATE PROCEDURE pro_healthope_editCreditCardTransactionStatusSuccess
	@creditCardTransactionId INT,
	@authCode CHAR(6),
	@cardLastFour CHAR(4),
	@cardType VARCHAR(30),
	@transactionId CHAR(36)
 AS
 BEGIN
	DECLARE @statusSuccess INT = 2

	UPDATE t_creditCardTransaction WITH(ROWLOCK)
	SET
		f_status = @statusSuccess,
		f_authCode = @authCode,
		f_cardLastFour = @cardLastFour,
		f_cardType = @cardType,
		f_transactionId = @transactionId,
		f_updateTime = SYSUTCDATETIME()
	WHERE f_creditCardTransactionId = @creditCardTransactionId
 END