CREATE PROCEDURE pro_healthope_delTerm
 @termId INT
 AS
 BEGIN
 DECLARE @statusDraft INT = 1 --草稿狀態
	IF @statusDraft = (SELECT f_status FROM t_term WITH(NOLOCK) WHERE f_termId = @termId) --是草稿狀態才能刪除
		DELETE t_term WHERE f_termId = @termId
 END