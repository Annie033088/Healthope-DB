CREATE PROCEDURE [dbo].[pro_healthope_addCreditCardTransaction]
	@orderId INT,
	@updateTime DATETIME2(3),
	@coachId INT,
	@errorCode INT OUTPUT
AS
BEGIN
	--錯誤碼
	DECLARE @success INT = 1, @hasBeenModified INT = 14, @coachBaned INT = 30, @payFailed INT = 31
	DECLARE @orderNewUpdateTime DATETIME2(3), @amount INT, @coachStatusBaned BIT =0, @orderState INT, @orderPayingState INT = 6

	SELECT @orderNewUpdateTime = f_updateTime, @amount = f_amount, @orderState = f_state FROM t_order WITH(NOLOCK) WHERE f_orderId = @orderId

	IF @orderNewUpdateTime != @updateTime 
	BEGIN
		SET @errorCode = @hasBeenModified
		RETURN;
	END

	IF @coachStatusBaned = (SELECT f_status FROM t_coach WITH(NOLOCK) WHERE f_coachId = @coachId)
	BEGIN
		SET @errorCode = @coachBaned
		RETURN;
	END

	IF @orderState = @orderPayingState
	BEGIN
		SET @errorCode = @payFailed
		RETURN;
	END

	DECLARE @transactionStatusPending INT = 1
	IF EXISTS (SELECT 1 FROM t_creditCardTransaction WITH(NOLOCK) WHERE f_orderId = @orderId AND f_status = @transactionStatusPending)
	BEGIN
		SET @errorCode = @payFailed
		RETURN
	END

	BEGIN TRY
		BEGIN TRANSACTION;

		UPDATE t_order
		SET f_state = @orderPayingState, f_updateTime = SYSUTCDATETIME()
		WHERE f_orderId = @orderId

		INSERT INTO t_creditCardTransaction(f_orderId, f_amount) 
		OUTPUT INSERTED.f_amount, INSERTED.f_creditCardTransactionId
		VALUES(@orderId, @amount)
		SET @errorCode = @success

		COMMIT TRANSACTION;
    -- 返回成功結果
	END TRY
	BEGIN CATCH
		SET @errorCode = @payFailed;
		THROW;
	END CATCH
END