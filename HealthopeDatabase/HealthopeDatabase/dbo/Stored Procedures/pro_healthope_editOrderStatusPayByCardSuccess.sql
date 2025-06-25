CREATE PROCEDURE [dbo].[pro_healthope_editOrderStatusPayByCardSuccess]
	@orderId INT,
	@coachId INT,
	@errorCode INT OUTPUT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		-- errorCode 定義
		DECLARE @success INT = 1, @modifiedFailed INT =11, @trackNotSet INT = 29

		DECLARE @memberId INT, @planId INT, @planType TINYINT, @planName NVARCHAR(20), @amount INT
		-- 此期間不讓其他請求修改此訂單
		SELECT
			@planId = f_planId,
			@planType = f_planType,
			@amount = f_amount,
			@memberId = f_memberId,
			@planName = f_planName
		FROM t_order
		WITH(UPDLOCK)
		WHERE f_orderId = @orderId;

		-- 方案資料
		DECLARE @membershipPlanType TINYINT = 1, @personalPlanType TINYINT = 2, @ticketPlanType TINYINT = 3
		DECLARE @duration TINYINT, @sessionCount INT

		IF @planType = @membershipPlanType
		BEGIN
			SELECT
				@duration = f_duration
			FROM t_membershipPlan
			WITH(NOLOCK)
			WHERE f_membershipPlanId = @planId
		END
		ELSE IF @planType = @personalPlanType
		BEGIN
			SELECT
				@sessionCount = f_sessionCount
			FROM t_personalTrainingPackage
			WITH(NOLOCK)
			WHERE f_personalTrainingPackageId = @planId
		END

		-- 2.發票資訊
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

		-- 訂單狀態
		DECLARE @statusPaid TINYINT = 2

		-- 3.更新訂單狀態為已付款
		UPDATE t_order
		SET f_state = @statusPaid, f_updateTime = SYSUTCDATETIME()
		WHERE f_orderId = @orderId
		
		-- 4.新增訂單狀態
		INSERT INTO t_orderState(f_orderId, f_state)
		VALUES(@orderId, @statusPaid)

		-- 5.開立發票並更新字軌
		-- 5.1
		INSERT INTO t_electronicInvoice(
			f_orderId, f_invoiceNumber, f_randomNumber, f_buyer, f_totalAmount, f_type
		)VALUES(
			@orderId, @invoiceNumber, @randomNumber, @buyerNumber, @amount, @invoiceType
		)
		SET @electronicInvoiceId = (SELECT SCOPE_IDENTITY())

		-- 5.2
		UPDATE t_invoiceTrackNumber
		SET f_currentNumber = f_currentNumber +1, f_updateTime = SYSUTCDATETIME()
		WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId

		-- 回傳發票列印需要的資料
		SELECT @electronicInvoiceId AS f_electronicInvoiceId, @invoiceNumber AS f_invoiceNumber, @randomNumber AS f_randomNumber, @amount AS f_totalAmount, @planName AS f_planName

		-- 6.新增會員已購買的方案資料
		IF @planType = @membershipPlanType
		BEGIN
			INSERT INTO t_memberMembershipPlan(f_orderId, f_memberId, f_planName, f_duration)
			VALUES(@orderId, @memberId, @planName, @duration)
		END
		ELSE IF @planType = @personalPlanType
		BEGIN
			INSERT INTO t_memberPersonalTrainingPackage(f_orderId, f_coachId, f_memberId, f_planName, f_sessionCount)
			VALUES (@orderId, @coachId, @memberId, @planName, @sessionCount)
		END
		ELSE IF @planType = @ticketPlanType
		BEGIN
			INSERT INTO t_singleEntryPass(f_orderId)
			OUTPUT INSERTED.f_singleEntryPassId, INSERTED.f_ticketCode
			VALUES (@orderId)
		END
		ELSE
		BEGIN
			SET @errorCode = @modifiedFailed
		    ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @errorCode = @success
		COMMIT TRANSACTION;
    -- 返回成功結果
	END TRY
	BEGIN CATCH
		SET @errorCode = @modifiedFailed;
		THROW;
	END CATCH
END