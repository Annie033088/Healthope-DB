CREATE TABLE t_refund(
	f_refundId	INT IDENTITY PRIMARY KEY,
	f_orderId	INT NOT NULL,
	f_amount	INT NOT NULL,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (f_orderId) REFERENCES t_order(f_orderId),
)

CREATE TABLE t_penalty(
	f_penaltyId	INT IDENTITY PRIMARY KEY,
	f_orderId	INT NOT NULL,
	f_amount	INT NOT NULL,
	f_createTime	DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (f_orderId) REFERENCES t_order(f_orderId),
)