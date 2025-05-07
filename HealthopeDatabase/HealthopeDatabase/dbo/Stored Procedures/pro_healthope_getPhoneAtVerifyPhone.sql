CREATE PROCEDURE [dbo].pro_healthope_getPhoneAtVerifyPhone
@memberId INT,
@errorCode INT OUTPUT
AS
BEGIN
	DECLARE @Success INT = 1; --成功 errorcode
	DECLARE @AlreadyVerify INT = 18; --(手機)已驗證 errorcode
	
	DECLARE @phone INT ; --使用者手機
	DECLARE @phoneVerified BIT ; --使用者手機是否已驗證

	SELECT @phone = f_phone, @phoneVerified = f_phoneVerified  FROM t_member WHERE f_memberId = @memberId
	SELECT @phone --回傳 phone
	IF @phoneVerified = 1
		SET @errorCode = @AlreadyVerify
	ELSE
		SET @errorCode = @Success
END