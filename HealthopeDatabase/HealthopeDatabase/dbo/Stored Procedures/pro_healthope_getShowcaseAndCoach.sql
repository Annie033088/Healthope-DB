CREATE PROCEDURE pro_healthope_getShowcaseAndCoach
	@category INT
AS
BEGIN
	SELECT f_name, f_category, f_icon
    FROM t_groupClassShowcase WITH(NOLOCK)
    WHERE (@category IS NULL OR f_category = @category)

	-- 取得 啟用中 的約聘教練
	SELECT f_coachId, f_name, f_updateTime
	FROM t_coach WITH(NOLOCK)
	WHERE f_status = 1 AND f_type = 2
END