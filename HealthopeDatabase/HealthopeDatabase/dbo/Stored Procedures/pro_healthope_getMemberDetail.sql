CREATE PROCEDURE pro_healthope_getMemberDetail
@memberId INT
AS
BEGIN
	SELECT f_name, f_phone, f_email, f_phoneVerified, f_photoUrl, f_gender, f_height, f_weight, f_status,
	f_emergencyContactName, f_emergencyContactPhone, f_emergencyContactRelation, f_birthday, f_allowGroupClass, f_membershipExpiry, f_createTime
	FROM t_member WITH(NOLOCK) WHERE f_memberId = @memberId
END