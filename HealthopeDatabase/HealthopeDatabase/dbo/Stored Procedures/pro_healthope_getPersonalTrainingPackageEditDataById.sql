CREATE PROCEDURE pro_healthope_getPersonalTrainingPackageEditDataById
	@personalTrainingPackageId INT
AS
BEGIN
	SELECT f_name, f_status, f_display, f_introduction, f_imageUrl, f_updateTime
	FROM t_personalTrainingPackage WITH(NOLOCK) WHERE f_personalTrainingPackageId = @personalTrainingPackageId
END