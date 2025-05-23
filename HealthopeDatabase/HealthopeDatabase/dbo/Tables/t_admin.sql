CREATE TABLE [dbo].[t_admin] (
    [f_adminId]    INT           IDENTITY (1, 1) NOT NULL,
    [f_account]    VARCHAR (20)  NOT NULL,
    [f_hash]       VARCHAR (100) NOT NULL,
    [f_status]     BIT           DEFAULT ((1)) NOT NULL,
    [f_identity]   TINYINT       NOT NULL,
    [f_updateTime] DATETIME2 (3) CONSTRAINT [DF_t_admin_f_updateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_adminId] ASC),
    UNIQUE NONCLUSTERED ([f_account] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_admin_adminId]
    ON [dbo].[t_admin]([f_adminId] ASC);

