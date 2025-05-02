CREATE PROCEDURE pro_healthope_editAdmin
 @adminId INT, 
 @status BIT, 
 @identity TINYINT,
 @updateTime DATETIME
 AS
 BEGIN
	IF @updateTime = (SELECT f_updateTime FROM t_admin WITH(NOLOCK) WHERE f_adminId = @adminId)
	BEGIN
		UPDATE t_admin WITH(ROWLOCK)
		SET
			f_identity = CASE WHEN @identity IS NOT NULL THEN @identity ELSE f_identity END,
			f_status = CASE WHEN @status IS NOT NULL THEN @status ELSE f_status END,
			f_updateTime = GETDATE()
		WHERE f_adminId = @adminId
	END
 END