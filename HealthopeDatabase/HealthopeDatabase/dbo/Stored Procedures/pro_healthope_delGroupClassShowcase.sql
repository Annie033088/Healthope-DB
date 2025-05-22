CREATE PROCEDURE pro_healthope_delGroupClassShowcase
 @groupClassShowcaseId INT
 AS
 BEGIN
		DELETE t_groupClassShowcase 
		OUTPUT DELETED.f_imageUrl
		WHERE f_groupClassShowcaseId = @groupClassShowcaseId
 END