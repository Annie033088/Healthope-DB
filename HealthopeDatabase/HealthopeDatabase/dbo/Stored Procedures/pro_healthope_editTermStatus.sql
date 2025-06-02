CREATE PROCEDURE pro_healthope_editTermStatus
 @termId INT,
 @status TINYINT,
 @updateTime DATETIME2(3),
 @errorCode INT OUTPUT
 AS
 BEGIN
	-- ErrorCode
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功
	DECLARE @invalidFormatOrEntry INT = 5 -- 錯誤的輸入格式

	DECLARE @statusDraft INT = 1 --草稿狀態碼
	DECLARE @statusPublished INT = 2 --發布版本狀態碼
	DECLARE @statusArchived INT = 3 --過去版本狀態碼

	SELECT f_updateTime, f_status, f_type, f_applicableTarget
	INTO #tempTermTable
    FROM t_term WITH(NOLOCK)
	WHERE f_termId = @termId

	IF NOT EXISTS (SELECT 1 FROM #tempTermTable) RETURN

	IF @updateTime != (SELECT f_updateTime FROM #tempTermTable)
		SET @errorCode = @hasBeenModified
	ELSE IF (SELECT f_status FROM #tempTermTable) != @statusDraft --草稿以外的條款不能修改
		SET @errorCode = @invalidFormatOrEntry
	ELSE
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @now DATETIME2(3) = GETUTCDATE()
		DECLARE @nowVersion TABLE(
			f_version INT
		);

		-- 第一個 UPDATE 更新要下架的條款狀態
		UPDATE t_term WITH(ROWLOCK)
		SET
			f_status = @statusArchived, f_updateTime = @now
		OUTPUT INSERTED.f_version 
		INTO @nowVersion(f_version)
		WHERE f_type = (SELECT f_type FROM #tempTermTable) 
		  AND f_applicableTarget = (SELECT f_applicableTarget FROM #tempTermTable)
		  AND f_status = @statusPublished

		DECLARE @newVersion INT

		IF NOT EXISTS (SELECT 1 FROM @nowVersion)
			SET @newVersion = 1
		ELSE
			SET @newVersion = ((SELECT f_version FROM @nowVersion)+1)

		-- 第二個 UPDATE 更新發布的條款狀態
		UPDATE t_term WITH(ROWLOCK)
		SET
			f_status = CASE WHEN @status IS NOT NULL THEN @status ELSE f_status END,
			f_version = @newVersion,
			f_effectiveTime = @now,
			f_updateTime = @now
		WHERE f_termId = @termId

		SET @errorCode = @success
		
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
 END