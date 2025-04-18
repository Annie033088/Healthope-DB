CREATE TABLE [dbo].[t_member] (
    [f_memberId]         INT            IDENTITY (1, 1) NOT NULL,
    [f_account]          VARCHAR (20)   NOT NULL,
    [f_hash]             VARCHAR (100)  NOT NULL,
    [f_email]            VARCHAR (254)  NOT NULL,
    [f_phone]            INT            NOT NULL,
    [f_name]             NVARCHAR (50)  NOT NULL,
    [f_photoUrl]         NVARCHAR (100) NOT NULL,
    [f_birthday]         DATE           DEFAULT ('0001-01-01') NOT NULL,
    [f_gender]           TINYINT        DEFAULT ((0)) NOT NULL,
    [f_height]           INT            NOT NULL,
    [f_weight]           INT            NOT NULL,
    [f_status]           BIT            DEFAULT ((1)) NOT NULL,
    [f_absenceTime]      TINYINT        DEFAULT ((0)) NOT NULL,
    [f_allowGroupClass]  DATE           DEFAULT ('0001-01-01') NOT NULL,
    [f_membershipExpiry] DATE           DEFAULT ('0001-01-01') NOT NULL,
    [f_createTime]       DATETIME       DEFAULT (getdate()) NOT NULL,
    [f_updateTime]       DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_memberId] ASC),
    UNIQUE NONCLUSTERED ([f_account] ASC),
    UNIQUE NONCLUSTERED ([f_phone] ASC)
);

