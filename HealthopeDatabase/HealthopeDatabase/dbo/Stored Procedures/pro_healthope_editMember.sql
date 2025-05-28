CREATE PROCEDURE [dbo].[pro_healthope_editMember]
 @memberId INT, 
 @status BIT, 
 @phone INT,
 @updateTime DATETIME2,
 @errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @duplicatePhone INT = 16 --手機號碼重複
	DECLARE @success INT = 1 --成功

	IF @updateTime != (SELECT f_updateTime FROM t_member WITH(NOLOCK) WHERE f_memberId = @memberId)
		SET @errorCode = @hasBeenModified
	ELSE IF @phone IS NOT NULL AND EXISTS(SELECT 1 FROM t_member WITH(NOLOCK) WHERE f_phone = @phone)
		SET @errorCode = @duplicatePhone
	ELSE
	BEGIN
		UPDATE t_member WITH(ROWLOCK)
		SET
			f_phone = CASE WHEN @phone IS NOT NULL THEN @phone ELSE f_phone END,
			f_status = CASE WHEN @status IS NOT NULL THEN @status ELSE f_status END,
			f_updateTime = GETUTCDATE()
		WHERE f_memberId = @memberId
		SET @errorCode = @success
	END
 END