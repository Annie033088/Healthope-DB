CREATE PROCEDURE pro_healthope_getMembershipPlanEditDataById
	@memebershipPlanId INT
AS
BEGIN
	SELECT f_name, f_status, f_display, f_introduction, f_imageUrl, f_updateTime
	FROM t_membershipPlan WITH(NOLOCK) WHERE f_membershipPlanId = @memebershipPlanId
END