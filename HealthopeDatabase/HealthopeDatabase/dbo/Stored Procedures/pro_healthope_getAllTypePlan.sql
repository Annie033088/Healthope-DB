CREATE PROCEDURE pro_healthope_getAllTypePlan
AS
BEGIN
	SELECT f_membershipPlanId, f_name, f_price, f_updateTime FROM t_membershipPlan WHERE f_status = 1
	SELECT f_personalTrainingPackageId, f_name, f_price, f_updateTime FROM t_personalTrainingPackage WHERE f_status = 1
	SELECT f_ticketPlanId, f_price, f_updateTime FROM t_tickctPlan WHERE f_status = 1
END