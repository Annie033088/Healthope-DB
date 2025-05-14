CREATE TABLE [dbo].[t_coach] (
    [f_coachId]           INT            IDENTITY (1, 1) NOT NULL,
    [f_account]           VARCHAR (20)   NOT NULL,
    [f_hash]              VARCHAR (100)  NOT NULL,
    [f_email]             VARCHAR (254)  NOT NULL,
    [f_phone]             INT            NOT NULL,
    [f_name]              NVARCHAR (15)  NOT NULL,
    [f_photoUrl]          NVARCHAR (100) NOT NULL,
    [f_introduction]      NVARCHAR (50)  NOT NULL,
    [f_specialty]         NVARCHAR (200) NOT NULL,
    [f_certification]     NVARCHAR (200) NOT NULL,
    [f_status]            BIT            DEFAULT ((0)) NOT NULL,
    [f_type]              TINYINT        NOT NULL,
    [f_contractStartTime] DATE           DEFAULT ('0001-01-01') NOT NULL,
    [f_contractEndTime]   DATE           DEFAULT ('0001-01-01') NOT NULL,
    [f_createTime]        DATETIME       DEFAULT (getdate()) NOT NULL,
    [f_updateTime]        DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_coachId] ASC)
);

