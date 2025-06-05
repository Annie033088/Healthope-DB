CREATE PROCEDURE pro_healthope_addInoviceTrackNumber
@trackPrefix CHAR(2),
@startNumber INT,
@endNumber INT,
@invoicePeriod INT
AS
BEGIN
	INSERT INTO t_invoiceTrackNumber(f_trackPrefix, f_startNumber, f_endNumber, f_currentNumber, f_invoicePeriod) 
	VALUES(@trackPrefix, @startNumber, @endNumber, (@startNumber-1), @invoicePeriod)
END