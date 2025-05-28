CREATE PROCEDURE [dbo].[pro_healthope_editGroupClassShowcase]
	@groupClassShowcaseId INT,
	@name NVARCHAR(20),
	@summary NVARCHAR(80),
	@detailContent NVARCHAR(500),
	@imageUrl NVARCHAR(100),
	@category INT,
	@icon INT,
	@sort INT,
	@updateTime DATETIME2,
	@errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @duplicateName INT = 21 --(課程)名稱重複
	DECLARE @success INT = 1 --成功

	IF @updateTime != (SELECT f_updateTime FROM t_groupClassShowcase WITH(NOLOCK) WHERE f_groupClassShowcaseId = @groupClassShowcaseId)
		SET @errorCode = @hasBeenModified
	ELSE IF @name IS NOT NULL AND EXISTS(SELECT 1 FROM t_groupClassShowcase WITH(NOLOCK) WHERE f_name = @name)
		SET @errorCode = @duplicateName
	ELSE
	BEGIN
		UPDATE t_groupClassShowcase WITH(ROWLOCK)
		SET
			f_name = CASE WHEN @name IS NOT NULL THEN @name ELSE f_name END,
			f_summary = CASE WHEN @summary IS NOT NULL THEN @summary ELSE f_summary END,
			f_detailContent = CASE WHEN @detailContent IS NOT NULL THEN @detailContent ELSE f_detailContent END,
			f_imageUrl = CASE WHEN @imageUrl IS NOT NULL THEN @imageUrl ELSE f_imageUrl END,
			f_category = CASE WHEN @category IS NOT NULL THEN @category ELSE f_category END,
			f_icon = CASE WHEN @icon IS NOT NULL THEN @icon ELSE f_icon END,
			f_sort = CASE WHEN @sort IS NOT NULL THEN @sort ELSE f_sort END,
			f_updateTime = GETUTCDATE()
		OUTPUT 
		    CASE 
				WHEN DELETED.f_imageUrl <> INSERTED.f_imageUrl THEN DELETED.f_imageUrl -- 照片路徑有被更動才回傳舊的路徑
				ELSE NULL
			END
		WHERE f_groupClassShowcaseId = @groupClassShowcaseId
		SET @errorCode = @success
	END
 END