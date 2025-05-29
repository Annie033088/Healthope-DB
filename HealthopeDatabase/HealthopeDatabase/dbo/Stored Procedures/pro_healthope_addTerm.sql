CREATE PROCEDURE [dbo].[pro_healthope_addTerm]
@detailContent NVARCHAR(MAX),
@type TINYINT,
@applicableTarget TINYINT, 
@versionDescription NVARCHAR(200)
AS
BEGIN
	DECLARE @targetText NVARCHAR(20)
	DECLARE @typeText NVARCHAR(20)
	DECLARE @name NVARCHAR(15) ;
	
	-- 將代碼轉成文字
	SET @targetText = CASE @applicableTarget
	                    WHEN 1 THEN N'會員'
	                    WHEN 2 THEN N'教練'
	                    ELSE N'未知'
	                  END
	
	SET @typeText = CASE @type
	                  WHEN 1 THEN N'服務條款'
	                  WHEN 2 THEN N'隱私權政策'
	                  ELSE N'未知'
	                END
	
	SET @name = @targetText + N' - ' + @typeText

	INSERT INTO t_term(f_name, f_detailContent, f_type, f_applicableTarget, f_versionDescription) 
	VALUES(@name, @detailContent, @type, @applicableTarget, @versionDescription)
END