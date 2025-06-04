CREATE PROCEDURE pro_healthope_editLeaseAgreementStatus
@leaseAgreementId INT, 
@status TINYINT, 
@remark NVARCHAR(50),
@updateTime DATETIME2(3), 
@errorCode INT OUTPUT
AS
BEGIN
	-- ErrorCode
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功
	DECLARE @invalidFormatOrEntry INT = 5 -- 錯誤的輸入格式
	DECLARE @activeLeaseAgreement INT = 24 -- 已有啟用中的租約

	-- Status
	DECLARE @inactive INT = 1
	DECLARE @active INT = 2
	DECLARE @completed INT = 3
	DECLARE @cancel INT = 4

	SELECT f_updateTime, f_status, f_endTime, f_reminderLeadTime
	INTO #tempLeaseAgreementTable
    FROM t_leaseAgreement WITH(NOLOCK)
	WHERE f_leaseAgreementId = @leaseAgreementId

	IF NOT EXISTS (SELECT 1 FROM #tempLeaseAgreementTable)
		SET @errorCode = @invalidFormatOrEntry
	ELSE IF @updateTime != (SELECT f_updateTime FROM #tempLeaseAgreementTable)
		SET @errorCode = @hasBeenModified
	-- 狀態轉換限制
	ELSE IF ((SELECT f_status FROM #tempLeaseAgreementTable) = @inactive) AND (@status != @active)
		SET @errorCode = @invalidFormatOrEntry
	ELSE IF ((@status = @completed) OR (@status = @cancel)) AND ((SELECT f_status FROM #tempLeaseAgreementTable) != @active)
		SET @errorCode = @invalidFormatOrEntry
	ELSE
	BEGIN
	-- 轉成啟用中 => 需檢查租約即將到期提醒時間 => 並回傳是否需要發送信件
		IF @status = @active
		BEGIN
			-- 只能有一個啟用中租約
			IF EXISTS(SELECT 1 FROM t_leaseAgreement WHERE f_status = @active)
				SET @errorCode = @activeLeaseAgreement
			-- 結束時間 >= 現在時間, 不得修改狀態
			ELSE IF CAST(GETUTCDATE() AS DATE) >= (SELECT f_endTime FROM #tempLeaseAgreementTable)
				SET @errorCode = @invalidFormatOrEntry
			ELSE
			BEGIN
				-- 是否進入提醒區間
				IF CAST(GETUTCDATE() AS DATE) >= DATEADD(DAY, -(SELECT f_reminderLeadTime FROM #tempLeaseAgreementTable), (SELECT f_endTime FROM #tempLeaseAgreementTable))
				BEGIN 
					UPDATE t_leaseAgreement WITH(ROWLOCK) 
					SET
						f_remark = CASE WHEN @remark IS NOT NULL THEN @remark ELSE f_remark END,
						f_status = @status,
						f_remind = 1,
						f_updateTime = GETUTCDATE() 
					OUTPUT 
						INSERTED.f_endTime AS f_leaseEndTime,
						1 AS f_sendEmailFlag
					WHERE f_leaseAgreementId = @leaseAgreementId
	
					SET @errorCode = @success
				END
				ELSE
				BEGIN
					UPDATE t_leaseAgreement WITH(ROWLOCK) 
					SET
						f_remark = CASE WHEN @remark IS NOT NULL THEN @remark ELSE f_remark END,
						f_status = @status,
						f_updateTime = GETUTCDATE() 
					WHERE f_leaseAgreementId = @leaseAgreementId
	
					SET @errorCode = @success
				END
			END
		END
		ELSE
		BEGIN
			-- 非啟用狀態的更新（例如轉為已結束或已終止）
			UPDATE t_leaseAgreement WITH(ROWLOCK) 
			SET
				f_remark = CASE WHEN @remark IS NOT NULL THEN @remark ELSE f_remark END,
				f_remind = 0,
				f_status = @status,
				f_updateTime = GETUTCDATE() 
			WHERE f_leaseAgreementId = @leaseAgreementId
	
			SET @errorCode = @success
		END
	END
END