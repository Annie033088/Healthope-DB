
CREATE PROCEDURE pro_healthope_getCoachEditDataById
 @coachId INT
 AS
 BEGIN
	SELECT f_name, f_phone, f_status, f_email, f_contractStartTime, f_contractEndTime, f_introduction, f_specialty, f_certification, f_photoUrl, f_updateTime
    FROM t_coach WITH(NOLOCK)
	WHERE f_coachId = @coachId
 END