CREATE PROCEDURE [dbo].[pro_healthope_addMember]
 @account VARCHAR(20),
 @hash VARCHAR(100),
 @email VARCHAR(254),
 @phone INT,
 @errorCode INT OUTPUT
AS
BEGIN
	DECLARE @Success INT = 1; --成功 errorcode
	DECLARE @DuplicatePhone INT = 16; --手機重複 errorcode
	DECLARE @DuplicateAccount INT = 17; --帳號重複 errorcode
	
	IF EXISTS (SELECT 1 FROM t_member WHERE @account = f_account)
		SET @errorCode = @DuplicateAccount
	ELSE IF EXISTS(SELECT 1 FROM t_member WHERE @phone = f_phone)
		SET @errorCode = @DuplicatePhone
	ELSE
		BEGIN
			SET @errorCode = @Success
			INSERT INTO t_member(f_account, f_hash, f_email, f_phone)
			OUTPUT inserted.f_memberId
			VALUES(@account, @hash, @email, @phone) 
		END
END