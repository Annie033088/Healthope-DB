CREATE PROCEDURE pro_healthope_getPersonalCoach
AS
BEGIN
	DECLARE @personalCoachType INT = 1
	SELECT f_coachId, f_name, f_phone FROM t_coach WHERE f_type = @personalCoachType AND f_status = 1
END