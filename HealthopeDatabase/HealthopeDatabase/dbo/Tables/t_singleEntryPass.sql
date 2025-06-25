CREATE TABLE [dbo].[t_singleEntryPass] (
    [f_singleEntryPassId] INT              IDENTITY (1, 1) NOT NULL,
    [f_orderId]           INT              NOT NULL,
    [f_ticketCode]        UNIQUEIDENTIFIER CONSTRAINT [DF__t_singleE__f_tic__44952D46] DEFAULT (newid()) NOT NULL,
    [f_expiry]            DATE             CONSTRAINT [DF__t_singleE__f_exp__373B3228] DEFAULT (sysutcdatetime()) NOT NULL,
    [f_status]            TINYINT          CONSTRAINT [DF__t_singleE__f_sta__382F5661] DEFAULT ((4)) NOT NULL,
    [f_updateTime]        DATETIME2 (3)    CONSTRAINT [DF__t_singleE__f_upd__3A179ED3] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK__t_single__C33C2122A574827C] PRIMARY KEY CLUSTERED ([f_singleEntryPassId] ASC),
    CONSTRAINT [FK_t_singleEntryPass_t_order] FOREIGN KEY ([f_orderId]) REFERENCES [dbo].[t_order] ([f_orderId])
);

