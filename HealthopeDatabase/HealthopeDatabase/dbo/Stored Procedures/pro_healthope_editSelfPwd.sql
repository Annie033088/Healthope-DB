CREATE PROCEDURE pro_healthope_editSelfPwd(
@adminId INT,
@oldPwd VARCHAR(20),
@newPwd VARCHAR(20)
)
AS
BEGIN
	DECLARE @originalHash VARCHAR(100);
	SELECT @originalHash = f_hash FROM t_admin WHERE f_adminId = @adminId;
	-- 拆出 salt
	DECLARE @originalSalt NVARCHAR(36) = LEFT(@originalHash, 36);

	DECLARE @hashPwd VARCHAR(100);
	SET @hashPwd = dbo.fun_pwdHash(@originalSalt, @oldPwd);

	--舊密碼正確
	IF @hashPwd = @originalHash
	BEGIN
		DECLARE @newSalt VARCHAR(36) = LOWER(CONVERT(VARCHAR(36), NEWID()));
		DECLARE @newHash VARCHAR(100) = dbo.fun_pwdHash(@newSalt, @newPwd);
		UPDATE t_admin WITH(ROWLOCK)
		SET
			f_hash = @newHash
		WHERE f_adminId = @adminId
	END
END