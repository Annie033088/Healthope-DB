CREATE PROCEDURE pro_healthope_editInvoiceTrackNumberStatus
@invoiceTrackNumberId INT, 
@status TINYINT, 
@updateTime DATETIME2(3), 
@errorCode INT OUTPUT
AS
BEGIN
	-- ErrorCode
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功
	DECLARE @invalidFormatOrEntry INT = 5 -- 錯誤的輸入格式
	DECLARE @activeInvoiceTrackNumber INT = 25 -- 已有啟用中的字軌

	-- Status
	DECLARE @inactive INT = 1
	DECLARE @active INT = 2
	DECLARE @disabled INT = 3
	DECLARE @closed INT = 4

	SELECT f_updateTime, f_status, f_invoicePeriod
	INTO #tempInvoiceTrackNumberTable
    FROM t_invoiceTrackNumber WITH(NOLOCK)
	WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId
	
	-- InvoicePeriod
	DECLARE @invoicePeriod INT = (SELECT f_invoicePeriod FROM #tempInvoiceTrackNumberTable)

	IF NOT EXISTS (SELECT 1 FROM #tempInvoiceTrackNumberTable)
		SET @errorCode = @invalidFormatOrEntry
	ELSE IF @updateTime != (SELECT f_updateTime FROM #tempInvoiceTrackNumberTable)
		SET @errorCode = @hasBeenModified
	-- 狀態轉換限制
	ELSE IF (@status = @active) AND ((SELECT f_status FROM #tempInvoiceTrackNumberTable) != @inactive)  
		SET @errorCode = @invalidFormatOrEntry
	ELSE IF ((@status = @disabled) AND ((SELECT f_status FROM #tempInvoiceTrackNumberTable) != @active))
		SET @errorCode = @invalidFormatOrEntry
	ELSE
	BEGIN
		IF @status = @active
		BEGIN
			-- 只能有一個啟用中字軌
			IF EXISTS(SELECT 1 FROM t_invoiceTrackNumber WHERE f_status = @active)
				SET @errorCode = @activeInvoiceTrackNumber
			-- 若是過期的期數, 不得修改成啟用狀態
			ELSE IF GETDATE() > EOMONTH(DATEFROMPARTS((@invoicePeriod / 10) + 1911, ((@invoicePeriod % 10) * 2), 1))
				SET @errorCode = @invalidFormatOrEntry
			ELSE
			BEGIN
				-- 是否進入提醒區間
				UPDATE t_invoiceTrackNumber WITH(ROWLOCK) 
				SET
					f_status = @status,
					f_updateTime = GETUTCDATE() 
				WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId
	
				SET @errorCode = @success
			END
		END
		ELSE
		BEGIN
			-- 是否進入提醒區間
			UPDATE t_invoiceTrackNumber WITH(ROWLOCK) 
			SET
				f_status = @status,
				f_updateTime = GETUTCDATE() 
			WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId
	
			SET @errorCode = @success
		END
	END
END