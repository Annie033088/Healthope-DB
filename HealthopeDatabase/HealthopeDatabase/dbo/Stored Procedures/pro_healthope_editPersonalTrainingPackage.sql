CREATE PROCEDURE [dbo].[pro_healthope_editPersonalTrainingPackage]
	@personalTrainingPackageId INT,
	@introduction NVARCHAR(200),
	@imageUrl NVARCHAR(100),
	@status BIT,
	@display BIT,
	@updateTime DATETIME2,
	@errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功

	IF @updateTime != (SELECT f_updateTime FROM t_personalTrainingPackage WITH(NOLOCK) WHERE f_personalTrainingPackageId = @personalTrainingPackageId)
		SET @errorCode = @hasBeenModified
	ELSE
	BEGIN
		UPDATE t_personalTrainingPackage WITH(ROWLOCK)
		SET
			f_introduction = CASE WHEN @introduction IS NOT NULL THEN @introduction ELSE f_introduction END,
			f_imageUrl = CASE WHEN @imageUrl IS NOT NULL THEN @imageUrl ELSE f_imageUrl END,
			f_status = CASE WHEN @status IS NOT NULL THEN @status ELSE f_status END,
			f_display = CASE WHEN @display IS NOT NULL THEN @display ELSE f_display END,
			f_updateTime = GETUTCDATE()
		OUTPUT 
		    CASE 
				WHEN DELETED.f_imageUrl <> INSERTED.f_imageUrl THEN DELETED.f_imageUrl -- 照片路徑有被更動才回傳舊的路徑
				ELSE NULL
			END
		WHERE f_personalTrainingPackageId = @personalTrainingPackageId
		SET @errorCode = @success
	END
 END