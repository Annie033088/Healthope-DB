CREATE PROCEDURE pro_healthope_getGroupClassShowcaseDetail
@groupClassShowcaseId INT
AS
BEGIN
	SELECT f_name, f_icon, f_category, f_sort, f_summary, f_detailContent, f_imageUrl
	FROM t_groupClassShowcase WITH(NOLOCK) WHERE f_groupClassShowcaseId = @groupClassShowcaseId
END