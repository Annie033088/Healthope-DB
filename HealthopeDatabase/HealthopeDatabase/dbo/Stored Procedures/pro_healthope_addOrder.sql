CREATE PROCEDURE [dbo].[pro_healthope_addOrder]
	@memberId INT, 
	@planType TINYINT, 
	@planId INT, 
	@method TINYINT,
	@orderNumber BIGINT,
	@errorCode INT OUTPUT
AS
BEGIN
	-- errorCode 定義
	DECLARE @success INT =1, @memberBaned INT = 26, @phoneNotVerify INT = 27, @planNotAvailable INT = 28

	-- 1.前置條件檢查
	-- 會員資料
	DECLARE @memberStatus INT, @phoneVerified BIT;

	SELECT 
	    @memberStatus = f_status,
	    @phoneVerified = f_phoneVerified
	FROM t_member
	WITH(NOLOCK)
	WHERE f_memberId = @memberId;

	-- 會員未啟用
	IF @memberStatus = 0
	BEGIN
		SET @errorCode = @memberBaned
		RETURN
	END
	-- 會員手機未驗證
	ELSE IF @phoneVerified = 0
	BEGIN
		SET @errorCode = @phoneNotVerify
		RETURN
	END

	-- 方案資料
	DECLARE @membershipPlanType TINYINT = 1, @personalPlanType TINYINT = 2, @ticketPlanType TINYINT = 3
	DECLARE @planName NVARCHAR(20), @price INT, @planStatus BIT

	IF @planType = @membershipPlanType
	BEGIN
		SELECT
			@planName = f_name,
			@price = f_price,
			@planStatus = f_status
		FROM t_membershipPlan
		WITH(NOLOCK)
		WHERE f_membershipPlanId = @planId
	END
	ELSE IF @planType = @personalPlanType
	BEGIN
		SELECT
			@planName = f_name,
			@price = f_price,
			@planStatus = f_status
		FROM t_personalTrainingPackage
		WITH(NOLOCK)
		WHERE f_personalTrainingPackageId = @planId
	END
	-- 票劵方案 沒有 Name, 現在需要寫死名稱
	ELSE IF @planType = @ticketPlanType
	BEGIN
		SELECT
			@price = f_price,
			@planStatus = f_status
		FROM t_tickctPlan
		WITH(NOLOCK)
		WHERE f_ticketPlanId = @planId
		SET @planName = '一次性票卷'
	END
	ELSE
		RETURN

	--方案未啟用
	IF @planStatus = 0
	BEGIN
		SET @errorCode = @planNotAvailable
		RETURN
	END

	BEGIN TRY
		BEGIN TRANSACTION;
		-- 付款方式
		DECLARE @payByCash TINYINT = 1, @payByCard TINYINT = 2

		-- 訂單狀態
		DECLARE @statusPending TINYINT = 1
		DECLARE @orderTables TABLE (f_orderId INT, f_updateTime DATETIME2(3))
		DECLARE @newOrderId INT

		-- 新增訂單
		INSERT INTO t_order(
			f_memberId, f_planId, f_planType, f_planName, f_orderNumber, f_state, f_amount, f_method
		) 
		OUTPUT INSERTED.f_orderId, INSERTED.f_updateTime INTO @orderTables
		VALUES (
		    @memberId, @planId, @planType, @planName, @orderNumber, @statusPending, @price, @method
		);

		SET @newOrderId = (SELECT f_orderId FROM @orderTables)

		-- 新增訂單狀態
		INSERT INTO t_orderState(f_orderId, f_state)
		VALUES(@newOrderId, @statusPending)

		SET @errorCode = @success
		SELECT f_orderId, f_updateTime FROM @orderTables

		COMMIT TRANSACTION;
    
    -- 返回成功結果
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END