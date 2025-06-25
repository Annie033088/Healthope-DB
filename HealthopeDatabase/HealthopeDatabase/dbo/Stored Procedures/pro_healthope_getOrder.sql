CREATE PROCEDURE [dbo].[pro_healthope_getOrder]
	@state TINYINT,
	@method TINYINT,
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(10),
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT t_order.f_orderId, t_order.f_memberId, t_order.f_planType, t_order.f_planName, t_order.f_orderNumber, t_order.f_state, t_order.f_amount, t_order.f_remark,
		t_order.f_method, t_order.f_updateTime, t_member.f_name AS f_memberName, t_member.f_phone AS f_memberPhone, t_electronicInvoice.f_status AS f_invoiceStatus
	INTO #tempOrderTable
    FROM t_order WITH(NOLOCK)
	LEFT JOIN t_member ON t_order.f_memberId = t_member.f_memberId
	OUTER APPLY (
	    SELECT TOP 1 *
	    FROM t_electronicInvoice
	    WHERE t_electronicInvoice.f_orderId = t_order.f_orderId
	    ORDER BY t_electronicInvoice.f_createTime DESC
	) t_electronicInvoice
    WHERE (@state IS NULL OR f_state = @state)
      AND  (@method IS NULL OR f_method = @method)
	
	SELECT @totalRecord = COUNT(*) FROM #tempOrderTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數
	
	SELECT f_orderId, f_memberId, f_planType, f_planName, f_orderNumber, f_state, f_amount, f_remark,
		f_method, f_updateTime, f_memberName, f_memberPhone, f_invoiceStatus
    FROM #tempOrderTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_orderId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_orderId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'amount' AND @sortOrder = 'ascending' THEN CAST(f_amount AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'amount' AND @sortOrder = 'descending' THEN CAST(f_amount AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'state' AND @sortOrder = 'ascending' THEN CAST(f_state AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'state' AND @sortOrder = 'descending' THEN CAST(f_state AS sql_variant) END DESC,
       CAST(f_orderId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END