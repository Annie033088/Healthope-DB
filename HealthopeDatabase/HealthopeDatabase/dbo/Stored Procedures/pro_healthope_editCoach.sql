CREATE PROCEDURE [dbo].[pro_healthope_editCoach]
	@coachId INT,
	@name NVARCHAR(15),
	@phone INT,
	@email VARCHAR(254),
	@contractStartTime DATE,
	@contractEndTime DATE,
	@introduction NVARCHAR(50),
	@specialty NVARCHAR(200),
	@certification NVARCHAR(200), 
	@photoUrl NVARCHAR(100),
	@status BIT,
	@updateTime DATETIME2,
	@errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @duplicatePhone INT = 16 --手機號碼重複
	DECLARE @success INT = 1 --成功

	IF @updateTime != (SELECT f_updateTime FROM t_coach WITH(NOLOCK) WHERE f_coachId = @coachId)
		SET @errorCode = @hasBeenModified
	ELSE IF @phone IS NOT NULL AND EXISTS(SELECT 1 FROM t_coach WITH(NOLOCK) WHERE f_phone = @phone)
		SET @errorCode = @duplicatePhone
	ELSE
	BEGIN
		UPDATE t_coach WITH(ROWLOCK)
		SET
			f_name = CASE WHEN @name IS NOT NULL THEN @name ELSE f_name END,
			f_email = CASE WHEN @email IS NOT NULL THEN @email ELSE f_email END,
			f_contractStartTime = CASE WHEN @contractStartTime IS NOT NULL THEN @contractStartTime ELSE f_contractStartTime END,
			f_contractEndTime = CASE WHEN @contractEndTime IS NOT NULL THEN @contractEndTime ELSE f_contractEndTime END,
			f_introduction = CASE WHEN @introduction IS NOT NULL THEN @introduction ELSE f_introduction END,
			f_specialty = CASE WHEN @specialty IS NOT NULL THEN @specialty ELSE f_specialty END,
			f_certification = CASE WHEN @certification IS NOT NULL THEN @certification ELSE f_certification END,
			f_photoUrl = CASE WHEN @photoUrl IS NOT NULL THEN @photoUrl ELSE f_photoUrl END,
			f_phone = CASE WHEN @phone IS NOT NULL THEN @phone ELSE f_phone END,
			f_status =  CASE WHEN @status IS NOT NULL THEN @status ELSE f_status END,
			f_updateTime = SYSUTCDATETIME()
		OUTPUT 
		    CASE 
				WHEN DELETED.f_photoUrl <> INSERTED.f_photoUrl THEN DELETED.f_photoUrl -- 照片路徑有被更動才回傳舊的路徑
				ELSE NULL
			END
		WHERE f_coachId = @coachId
		SET @errorCode = @success
	END
 END