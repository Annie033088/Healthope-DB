CREATE PROCEDURE pro_healthope_delLeaseAgreement
 @leaseAgreementId INT
 AS
 BEGIN
	DECLARE @inactiveStatus INT =1;
	IF @inactiveStatus = (SELECT f_status FROM t_leaseAgreement WHERE f_leaseAgreementId = @leaseAgreementId)
		DELETE t_leaseAgreement WHERE f_leaseAgreementId = @leaseAgreementId
 END