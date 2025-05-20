CREATE PROCEDURE pro_healthope_addGroupClassShowcase
	@name NVARCHAR(20), 
	@summary NVARCHAR(80),
	@detailContent NVARCHAR(500),
	@certification NVARCHAR(200), 
	@imageUrl NVARCHAR(100),
	@category INT,
	@icon INT,
	@sort INT,
	@errorCode INT OUTPUT
AS
BEGIN
	DECLARE @duplicateName INT = 21 --(課程)名稱重複
	DECLARE @success INT = 1

	IF  EXISTS (SELECT 1 FROM t_groupClassShowcase WHERE f_name = @name)
	BEGIN
		SET @errorCode = @duplicateName
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO t_groupClassShowcase(f_name, f_summary, f_detailContent, f_imageUrl, f_category, f_icon, f_sort) 
		VALUES(@name, @summary, @detailContent, @imageUrl, @category, @icon, @sort)
		SET @errorCode = @success
	END
END