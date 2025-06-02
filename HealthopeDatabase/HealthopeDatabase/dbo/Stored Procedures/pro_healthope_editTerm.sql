CREATE PROCEDURE pro_healthope_editTerm
 @termId INT, 
 @detailContent NVARCHAR(MAX), 
 @versionDescription NVARCHAR(200),
 @updateTime DATETIME2,
 @errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功
	DECLARE @modifiedFailed INT = 11 --修改失敗

	DECLARE @statusDraft INT = 1 --草稿狀態碼

	SELECT f_updateTime, f_status
	INTO #tempTermTable
    FROM t_term WITH(NOLOCK)
	WHERE f_termId = @termId

	IF @updateTime != (SELECT f_updateTime FROM #tempTermTable WITH(NOLOCK))
		SET @errorCode = @hasBeenModified
	ELSE IF (SELECT f_status FROM #tempTermTable WITH(NOLOCK)) != @statusDraft --草稿以外的條款不能修改
		SET @errorCode = @modifiedFailed
	ELSE
	BEGIN
		UPDATE t_term WITH(ROWLOCK)
		SET
			f_detailContent = CASE WHEN @detailContent IS NOT NULL THEN @detailContent ELSE f_detailContent END,
			f_versionDescription = CASE WHEN @versionDescription IS NOT NULL THEN @versionDescription ELSE f_versionDescription END,
			f_updateTime = GETUTCDATE()
		WHERE f_termId = @termId
		SET @errorCode = @success
	END
 END