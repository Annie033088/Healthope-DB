CREATE PROCEDURE [dbo].[pro_healthope_editTicketPlanStatus]
 @ticketPlanId INT, 
 @status BIT, 
 @updateTime DATETIME2
 AS
 BEGIN
	IF @updateTime = (SELECT f_updateTime FROM t_tickctPlan WITH(NOLOCK) WHERE f_ticketPlanId = @ticketPlanId)
	BEGIN
		UPDATE t_tickctPlan WITH(ROWLOCK)
		SET
			f_status = @status,
			f_updateTime = GETUTCDATE()
		WHERE f_ticketPlanId = @ticketPlanId
	END
 END