CREATE PROCEDURE [dbo].[pro_healthope_editCreditCardTransactionStatusFail]
	@creditCardTransactionId INT
 AS
 BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @statusFail INT =3, @orderId INT, @statePending INT = 1
		DECLARE @orderTable TABLE(f_orderId INT)

		UPDATE t_creditCardTransaction WITH(ROWLOCK)
		SET
			f_status = @statusFail,
			f_updateTime = SYSUTCDATETIME()
		OUTPUT INSERTED.f_orderId INTO @orderTable
		WHERE f_creditCardTransactionId = @creditCardTransactionId

		SELECT @orderId = f_orderId FROM @orderTable

		UPDATE t_order
		SET
			f_state = @statePending,
			f_updateTime = SYSUTCDATETIME()
		WHERE f_orderId = @orderId

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
 END