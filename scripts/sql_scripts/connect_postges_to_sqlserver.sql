USE [master];
GO

-- 1. If Sever Name Exist or Half Create Before Then Drop "PG_LINKED_SERVER" and Remove.
IF EXISTS (SELECT srvname FROM sys.sysservers WHERE srvname = 'PG_LINKED_SERVER')
    EXEC master.dbo.sp_dropserver @server=N'PG_LINKED_SERVER', @droplogins='droplogins';
GO

-- 2. DSN-less Provider Create String by Linked Server
EXEC master.dbo.sp_addlinkedserver 
    @server = N'PG_LINKED_SERVER', 
    @srvproduct = N'PostgreSQL', 
    @provider = N'MSDASQL', 
    @provstr = N'Driver={PostgreSQL Unicode(x64)};Server=localhost;Port=5432;Database=bluesltd;';

-- 3. Credentials (PostgreSQL User & Password) Setup
EXEC master.dbo.sp_addlinkedsrvlogin 
    @rmtsrvname = N'PG_LINKED_SERVER', 
    @useself = N'False', 
    @locallogin = NULL, 
    @rmtuser = N'postgres', 
    @rmtpassword = N'yourPassword';

-- 4. Stored Procedure & For Dynamic Query Enable RPC
EXEC master.dbo.sp_serveroption @server=N'PG_LINKED_SERVER', @optname=N'rpc', @optvalue=N'true';
EXEC master.dbo.sp_serveroption @server=N'PG_LINKED_SERVER', @optname=N'rpc out', @optvalue=N'true';
GO
