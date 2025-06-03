CREATE PROCEDURE pro_healthope_addLeaseAgreement
@startTime DATE,
@endTime DATE,
@reminderLeadTime INT
AS
BEGIN
	INSERT INTO t_leaseAgreement(f_startTime, f_endTime, f_reminderLeadTime) 
	VALUES(@startTime, @endTime, @reminderLeadTime)
END