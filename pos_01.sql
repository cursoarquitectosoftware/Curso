/****** Script for SelectTopNRows command from SSMS  ******/
declare @strDatabase	nvarchar(50) ,
		@strfolder		nvarchar(50) ,
		@Today			datetime	 ,
		@strbackupname	nvarchar(100),
		@strbackupFile	nvarchar(600),
		@nTotalRegistros Int,
		@nContador		Int

Set @nTotalRegistros = 0
Set @nContador = 0
Set @strfolder = N'C:\horus_tech\OneDrive\pos01_\'
set @today = getdate()


Select Name,ROW_NUMBER() OVER( Order By Name) As 'nRegistro' 
Into TmpTables
From sys.databases 
Where Name Like 'SOLUCION_ERP' Order By Name

Set @nTotalRegistros = @@ROWCOUNT

while (@nContador < @nTotalRegistros)
Begin
	set @nContador = @nContador + 1
	
	Select @strDatabase = Name 
	From TmpTables 
	Where nRegistro = @nContador 

	set @strbackupname = 'pos01'

	set @strbackupFile = @strfolder + N'\' + @strbackupname + N'.bak'

	backup database @strDatabase
	to disk = @strbackupFile
	WITH
	NOFORMAT,
	INIT,
	SKIP,
	name = @strbackupname
End

Drop Table TmpTables