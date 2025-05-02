CREATE PROCEDURE [dbo].[pro_healthope_delAdmin]
 @adminId INT
 AS
 BEGIN
		DELETE t_admin WHERE f_adminId = @adminId
 END