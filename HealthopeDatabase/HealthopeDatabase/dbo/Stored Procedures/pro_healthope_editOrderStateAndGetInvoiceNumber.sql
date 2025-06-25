CREATE PROCEDURE [dbo].[pro_healthope_editOrderStateAndGetInvoiceNumber]
	@orderId INT, 
	@errorCode INT OUTPUT
AS
BEGIN
	-- errorCode 定義
	DECLARE @success INT = 1, @trackNotSet INT = 29, @getFailed INT =13
	
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @planName NVARCHAR(20), @amount INT, @invoiceStatus INT, @statusProcessing INT = 1, @statusSuccess INT = 2,
			@ordeState INT, @statePaying INT = 6, @statePaid INT = 2, @method INT, @methodCard TINYINT = 2, 
			@transactionStatus TINYINT, @transactionStatusSuccess TINYINT = 2

		SELECT
			@planName = f_planName,
			@amount = f_amount,
			@ordeState = f_state,
			@invoiceStatus =  t_electronicInvoice.f_status,
			@method = f_method
		FROM t_order
		WITH(NOLOCK)
		OUTER APPLY (
			SELECT TOP 1 *
		    FROM t_electronicInvoice
		    WHERE t_electronicInvoice.f_orderId = t_order.f_orderId
		    ORDER BY t_electronicInvoice.f_createTime DESC
		) t_electronicInvoice
		WHERE t_order.f_orderId = @orderId;

		IF @method = @methodCard
		BEGIN
			SELECT TOP 1 @transactionStatus = f_status FROM t_creditCardTransaction ORDER BY f_createTime DESC
			
			-- 如果說訂單狀態為付款處理中, 且交易狀態為成功 => 將訂單狀態改為 2:已付款
			IF @ordeState = @statePaying AND @transactionStatus = @transactionStatusSuccess
			BEGIN
				UPDATE t_order WITH(ROWLOCK)
				SET f_state = @statePaid
				WHERE f_orderId = @orderId
			END
		END

		-- 如果發票狀態為 處理中/成功 則不可重印
		IF @invoiceStatus = @statusProcessing OR @invoiceStatus = @statusSuccess
		BEGIN
			SET @errorCode = @getFailed
            ROLLBACK TRANSACTION;
			RETURN;
		END

		-- 發票資訊
		DECLARE @electronicInvoiceId INT, @invoiceTrackNumberId INT, @invoiceNumber CHAR(10), @buyerNumber CHAR(8) = '00000000', @invoiceType TINYINT = 1, -- 1:B2C ; 2:B2B
			@randomNumber char(4) =  RIGHT('0000' + CAST(CAST(RAND() * 10000 AS INT) AS VARCHAR(4)), 4)

		SELECT
			@invoiceTrackNumberId = f_invoiceTrackNumberId,
			@invoiceNumber = f_trackPrefix + RIGHT('00000000' + CAST(f_currentNumber + 1 AS VARCHAR(8)), 8)
		FROM t_invoiceTrackNumber WITH(UPDLOCK)
		WHERE f_status = 1 AND f_currentNumber< f_endNumber

		IF @invoiceTrackNumberId IS NULL
		BEGIN
			SET @errorCode = @trackNotSet
            ROLLBACK TRANSACTION;
			RETURN;
		END

		INSERT INTO t_electronicInvoice(
			f_orderId, f_invoiceNumber, f_randomNumber, f_buyer, f_totalAmount, f_type
		)VALUES(
			@orderId, @invoiceNumber, @randomNumber, @buyerNumber, @amount, @invoiceType
		)
		SET @electronicInvoiceId = (SELECT SCOPE_IDENTITY())

		UPDATE t_invoiceTrackNumber
		SET f_currentNumber = f_currentNumber +1, f_updateTime = SYSUTCDATETIME()
		WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId

		-- 回傳發票列印需要的資料
		SELECT @electronicInvoiceId AS f_electronicInvoiceId, @invoiceNumber AS f_invoiceNumber, 
			@randomNumber AS f_randomNumber, @amount AS f_totalAmount, @planName AS f_planName

		SET @errorCode = @success
		COMMIT TRANSACTION;
    -- 返回成功結果
	END TRY
	BEGIN CATCH
		SET　@errorCode = @getFailed;
		THROW;
	END CATCH
END