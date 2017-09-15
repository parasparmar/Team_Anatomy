USE [CWFM_Umang]
GO
/****** Object:  Schema [WFMP]    Script Date: 9/16/2017 3:01:55 AM ******/
CREATE SCHEMA [WFMP]
GO
/****** Object:  StoredProcedure [WFMP].[CE]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [WFMP].[CE]
(
	@XEMP AS INT,  
	@FNAME AS VARCHAR(20) = NULL  
)
AS  
DECLARE @XSTR AS VARCHAR(1000)  
IF ISNULL(@FNAME,'') = ''  
BEGIN  
	SELECT * FROM [WFMP].[TBLMASTER] WHERE EMPCODE = @XEMP  
END  
ELSE  
BEGIN  
	SET @XSTR = 'SELECT * FROM [WFMP].[TBLMASTER] WHERE (FNAME+'' ''+MNAME+'' ''+LNAME LIKE ''' + @FNAME + '%'') OR (NTNAME LIKE ''%' + @FNAME + '%'') ORDER BY FNAME,MNAME,LNAME'  
	--PRINT @XSTR
	EXECUTE(@XSTR)  
END
GO
/****** Object:  StoredProcedure [WFMP].[getDefaultLeaveType]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [WFMP].[getDefaultLeaveType]
as
begin
	select LeaveId, LeaveText 
	from WFMP.tblLeaveType
	where Active=1
	order by 2;
end
GO
/****** Object:  StoredProcedure [WFMP].[GetDeptValues]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [WFMP].[GetDeptValues]
(
	@FunctionID int = null,
	@DepartmentID int = null,	
	@LOBID	 int = null,
	@SkillSetID	 int = null,
	@SubSkillSetID int = null
)
AS
Begin
	
	DECLARE @xSQL varchar(max) = ''
	DECLARE @xSQLStart varchar(max) = ''
	DECLARE @xSQLGrp varchar(max) = ''
	DECLARE @xSQLOrd varchar(max) = ''
	DECLARE @xSQLWhere varchar(max) = ''

	Set @xSQLStart = ' TF.TransID, TF.[Function]'
	Set @xSQLGrp = ' TF.TransID, TF.[Function]'
	Set @xSQLOrd = ' TF.[Function], TF.TransID'

	If @FunctionID is not null
	BEGIN 
		Set @xSQLStart = ' TD.TransID, TD.[Account]'
		Set @xSQLGrp = ' TD.TransID, TD.[Account]'
		Set @xSQLOrd = ' TD.[Account], TD.TransID'
		Set @xSQLWhere = ' AND TDLM.FunctionID = '''+ convert(varchar,@FunctionID) +''''
	END

	If @DepartmentID is not null
	BEGIN 
		Set @xSQLStart = ' LOB.TransID, LOB.[LOB]'
		Set @xSQLGrp = ' LOB.TransID, LOB.[LOB]'
		Set @xSQLOrd = ' LOB.[LOB],LOB.TransID'
		Set @xSQLWhere = ' AND TDLM.FunctionID = '''+ convert(varchar,@FunctionID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.DEPARTMENTID = '''+ convert(varchar,@DepartmentID) +''''
	END

	If @LOBID is not null
	BEGIN 
		Set @xSQLStart = ' SS.TransID, SS.[SkillSet]'
		Set @xSQLGrp = ' SS.TransID, SS.[SkillSet]'
		Set @xSQLOrd = ' SS.[SkillSet],SS.TransID'
		Set @xSQLWhere = ' AND TDLM.FunctionID = '''+ convert(varchar,@FunctionID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.DEPARTMENTID = '''+ convert(varchar,@DepartmentID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.LOBID = '''+ convert(varchar,@LOBID) +''''
	END

	If @SkillSetID is not null
	BEGIN 
		Set @xSQLStart = ' SSS.TransID, SSS.[SubSkillSet]'
		Set @xSQLGrp = ' SSS.TransID, SSS.[SubSkillSet]'
		Set @xSQLOrd = ' SSS.[SubSkillSet],SSS.TransID'
		Set @xSQLWhere = ' AND TDLM.FunctionID = '''+ convert(varchar,@FunctionID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.DEPARTMENTID = '''+ convert(varchar,@DepartmentID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.LOBID = '''+ convert(varchar,@LOBID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.SkillSetID = '''+ convert(varchar,@SkillSetID) +''''
	END

	If @SubSkillSetID is not null
	BEGIN 
		Set @xSQLStart = ' TDLM.TransID'
		Set @xSQLGrp = ' TDLM.TransID'
		Set @xSQLOrd = ' TDLM.TransID'
		Set @xSQLWhere = ' AND TDLM.FunctionID = '''+ convert(varchar,@FunctionID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.DEPARTMENTID = '''+ convert(varchar,@DepartmentID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.LOBID = '''+ convert(varchar,@LOBID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.SkillSetID = '''+ convert(varchar,@SkillSetID) +''''
		Set @xSQLWhere = @xSQLWhere + ' AND TDLM.SubSkillSetID = '''+ convert(varchar,@SubSkillSetID) +''''
	END

	SET @xSQL = 'Select  '+ @xSQLStart + '
	from WFMP.tbldepartmentlinkmst TDLM
	Inner join WFMP.tblFunction TF on TF.TransID = TDLM.FunctionID
	Inner Join WFMP.tblDepartment TD on TD.TransID = TDLM.DepartmentID
	INNER JOIN WFMP.tblLOB LOB on LOB.TransID = TDLM.LOBID
	INNER JOIN WFMP.tblSkillSet SS on SS.TransID = TDLM.SkillSetID
	INNER JOIN WFMP.tblSubSkillSet SSS on SSS.TransID=TDLM.SubSkillSetID
	where 1 = 1 
	and TF.Active = 1 and TDLM.Active = 1 and LOB.Active=1 and SS.Active=1 and SSS.active=1
	'+ @xSQLWhere  +'
	group by '+@xSQLGrp+'
	order by '+@xSQLOrd

	--Print @xSQL
	exec(@xSQL)
End
GO
/****** Object:  StoredProcedure [WFMP].[getEmployeeData]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		paras.parmar@sitel.com
-- Create date: 04-Aug-2017 1.59 AM
-- Description:	This stored procedure gets the specific row of the employee for the Team Anatomy profile page.
-- Modification date : 23-08-2017 12.51 AM
-- The table cwfm_umang..WFM_Employee_List was broken up into several tables at Gurdeeps request. 2
-- such are WFMP.tblMaster & WFMP.tblProfile which form the basis for this procedure.
-- =============================================
CREATE PROCEDURE [WFMP].[getEmployeeData] 
	-- Add the parameters for the stored procedure here
	@NT_ID varchar(50)  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	----Select top 1 * from cwfm_umang..WFM_Employee_List where NT_ID = @NT_ID
	--select 
	--A.Employee_ID, A.First_Name, A.Middle_Name, A.Last_Name, C.Designation as DesignationID
	--, D.Level as LevelID, A.DOJ, A.DOP, A.DOR, A.DPT, A.DOPS, E.EmpStatus, H.TrngStatus
	--, I.Type as Job_Type, J.Country as CountryID, K.Site as SiteID, L.[Function] as FunctionId, M.LOB as LOBID, F.SkillSet
	--, G.SubSkillSet, A.RepMgrCode, A.TeamID, A.ntName, A.ResType
	--, A.BusinessID, A.Employee_ID, B.Date_of_Birth, B.Gender, A.Email_Office
	--, B.Email_Personal, B.Contact_Number, B.AnniversaryDate, B.HighestQualification
	--, B.Transport, B.Address1, B.Address2, B.Landmark, B.City, B.Total_Work_Experience
	--, B.Skill1, B.Skill2, B.Skill3, B.Alternate_Contact, B.EmergencyContactPerson
	--, B.UserImage, B.Updated_by, B.Update_Date
	--from WFMP.tblMaster A inner join WFMP.tblProfile B on B.Employee_ID = A.Employee_ID
	--left join WFMP.tblDesignation C on C.TransID = A.DesignationID
	--left join WFMP.tblLevel D on D.TransID = A.LevelID
	--left join WFMP.tblEmpStatus E on E.Id = A.EmpStatus
	--left join WFMP.tblSkillSet F on F.TransID = A.SkillSet
	--left join WFMP.tblSubSkillSet G on G.TransID = A.SubSkillSet
	--left join WFMP.tblTrainingStatus H on H.TransID = A.TrngStatus
	--left join WFMP.tblJob_Type I on I.Id = A.Job_Type
	--left join WFMP.tblCountry J on J.TransID = A.CountryID
	--left join WFMP.tblSite K on K.TransID = A.SiteID
	--left join WFMP.tblFunction L on L.TransID = A.FunctionId
	--left join WFMP.tblLOB M on M.TransID = A.LOBID
	--where ntName = @NT_ID

	select
	A.Employee_ID, A.First_Name, A.Middle_Name, A.Last_Name, C.Designation as DesignationID
	, D.Level as LevelID, A.DOJ, A.DOP, A.DOR, A.DPT, A.DOPS, E.EmpStatus, H.TrngStatus
	, I.Type as Job_Type, J.Country as CountryID, K.Site as SiteID, L.[Function] as FunctionId, M.LOB as LOBID, F.SkillSet
	, G.SubSkillSet, A.RepMgrCode, A.TeamID, A.ntName, A.ResType
	, A.BusinessID, A.Employee_ID, B.Date_of_Birth, B.Gender, A.Email_Office
	, B.Email_Personal, B.Contact_Number, B.AnniversaryDate, B.HighestQualification
	, B.Transport, B.Address1, B.Address2, B.Landmark, B.City, B.Total_Work_Experience
	, B.Skill1, B.Skill2, B.Skill3, B.Alternate_Contact, B.EmergencyContactPerson
	, B.UserImage, B.Updated_by, B.Update_Date
	from WFMP.tblMaster A 
	left join WFMP.tblProfile B on B.Employee_ID = A.Employee_ID
	left join WFMP.tblDesignation C on C.TransID = A.DesignationID
	left join WFMP.tblLevel D on D.TransID = A.LevelID
	left join WFMP.tblEmpStatus E on E.Id = A.EmpStatus
	
	left join WFMP.tblDepartmentLinkMst TDLM on TDLM.[TransID] = A.[DeptLinkId] AND TDLM.Active=1
	Left Join WFMP.tblDepartment TD on TD.[TransID] = TDLM.[DepartmentID] AND TDLM.Active=1
	left join WFMP.tblFunction L on L.TransID = TDLM.[FunctionID] AND TDLM.Active=1
	left join WFMP.tblLOB M on M.TransID = TDLM.[LOBID] AND TDLM.Active=1
	left join WFMP.tblSkillSet F on F.TransID = TDLM.[SkillSetID] AND TDLM.Active=1
	left join WFMP.tblSubSkillSet G on G.TransID = TDLM.[SubSkillSetID] AND TDLM.Active=1
	
	left join WFMP.tblTrainingStatus H on H.TransID = A.TrngStatus
	left join WFMP.tblJob_Type I on I.Id = A.Job_Type
	left join WFMP.tblCountry J on J.TransID = A.CountryID
	left join WFMP.tblSite K on K.TransID = A.SiteID
	where ntName = @NT_ID
END

GO
/****** Object:  StoredProcedure [WFMP].[GetRosterInformation]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		paras.parmar@sitel.com
-- Create date: 15-Sep-2017 19.12
-- Description:	This stored procedure expects the employee id of a reporting manager 
-- and returns the roster for each reportee and sub reportee for a given week.
-- =============================================
CREATE PROCEDURE [WFMP].[GetRosterInformation] 
	-- Add the parameters for the stored procedure here
	@RepMgrCode int = null,
	@WeekNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--- For @RepMgr get each @Employee who is a reporting manager. ---923563
SELECT 
A.RepMgrCode
, REPLACE(B.First_Name +' '+B.Middle_Name+' '+B.Last_Name,'  ',' ') as RepMgr
, A.Employee_ID as MgrID
, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as MgrName
  FROM [CWFM_Umang].[WFMP].[tblMaster] A 
  INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode
  WHERE A.RepMgrCode = @RepMgrCode and A.IsReportingManager = 1
END

GO
/****** Object:  StoredProcedure [WFMP].[TeamList]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [WFMP].[TeamList]  
(
	@RepMgrCode as int
)
  
as  
  
Begin  
	select Distinct
	Employee_ID,
	dbo.ToPropercase([First_Name])+' '+
	dbo.ToPropercase([Middle_Name]) +' '+ 
	dbo.ToPropercase([Last_Name]) AS [Name], 
	Lower([Email_Office]) AS EMAIL_ID,
	C.Type as MovementType,
	B.State as MovementState
	from [WFMP].[tblMaster] A
	left join [CWFM_Umang].[WFMP].[tbltrans_Movement] B on B.EmpId = A.Employee_ID
	left join [CWFM_Umang].[WFMP].tblMovementTypes C on C.Id = B.Type
	
	where A.[RepMgrCode] = @RepMgrCode and [EmpStatus] = 1
	order by dbo.ToPropercase([First_Name])+' '+
	dbo.ToPropercase([Middle_Name]) +' '+ 
	dbo.ToPropercase([Last_Name]) ASC
End 
  
  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [WFMP].[Transfer_TeamList]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [WFMP].[Transfer_TeamList]  
(
	@RepMgrCode as int
)
  
as  
  
Begin  
	--select Distinct
	--A.Employee_ID,
	--dbo.ToPropercase(A.[First_Name])+' '+
	--dbo.ToPropercase(A.[Middle_Name]) +' '+ 
	--dbo.ToPropercase(A.[Last_Name]) AS [Name], 
	--Lower(A.[Email_Office]) AS EMAIL_ID,
	--C.Type as MovementType,
	--D.State as MovementState
	--from [WFMP].[tblMaster] A
	--left join [CWFM_Umang].[WFMP].[tbltrans_Movement] B on B.EmpId = A.Employee_ID
	--left join [CWFM_Umang].[WFMP].[tblMovementTypes] C on C.Id = B.Type
	--left join [CWFM_Umang].[WFMP].[tblMovementState] D on D.Id = B.State
	--where A.[RepMgrCode] = @RepMgrCode and A.[EmpStatus] = 1
	--order by dbo.ToPropercase(A.[First_Name])+' '+
	--dbo.ToPropercase(A.[Middle_Name]) +' '+ 
	--dbo.ToPropercase(A.[Last_Name]) ASC

	Select
	A.Employee_ID,
	dbo.ToPropercase(A.[First_Name])+' '+
	dbo.ToPropercase(A.[Middle_Name]) +' '+ 
	dbo.ToPropercase(A.[Last_Name]) AS [Name], 
	Lower(A.[Email_Office]) AS EMAIL_ID,
	case when b.State=0 tHEN 'Pending with '+ dbo.ToPropercase(C.[First_Name])+' '+	dbo.ToPropercase(C.[Middle_Name]) +' '+ dbo.ToPropercase(C.[Last_Name]) else '' END as State
	from [WFMP].[tblMaster] A
	left join [CWFM_Umang].[WFMP].[tbltrans_Movement] B on B.EmpId = A.Employee_ID AND  b.State = 0
	left outer JOIN [WFMP].[tblMaster] C on C.Employee_ID = Case When B.Type = 1 Then B.ToMgr Else B.FromMgr End
	where A.[RepMgrCode] = @RepMgrCode and A.[EmpStatus] = 1
End 
  
  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [WFMP].[updateEmployeeProfileData]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Paras Parmar
-- Create date: 05-August-2017 12.35 AM
-- Description:	Updates the entries for an employee in the Team Anatomy Profile page
-- =============================================
CREATE PROCEDURE [WFMP].[updateEmployeeProfileData] 
		@Employee_ID int,
		@Date_of_Birth datetime,
		@Gender varchar(10),		
		@Email_Personal varchar(255),
		@Contact_Number bigint,
		@AnniversaryDate datetime,
		@HighestQualification varchar(255),
		@Transport bit,
		@Address1 varchar(255),
		@Address2 varchar(255),
		@Landmark varchar(255),
		@City varchar(255),
		@Total_Work_Experience int,
		@Skill1 varchar(255),
		@Skill2 varchar(255),
		@Skill3 varchar(255),
		@Alternate_Contact bigint,
		@EmergencyContactPerson varchar(255),		
		@Updated_by nvarchar(50),
		@Update_Date datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



 Update [CWFM_Umang].[WFMP].[tblProfile]
 Set	Date_of_Birth = @Date_of_Birth, 
		Gender = @Gender, 		 
		Email_Personal = @Email_Personal, 
		Contact_Number = @Contact_Number, 
		AnniversaryDate = @AnniversaryDate, 
		HighestQualification = @HighestQualification, 
		Transport = @Transport, 
		Address1 = @Address1, 
		Address2 = @Address2, 
		Landmark = @Landmark, 
		City = @City, 
		Total_Work_Experience = @Total_Work_Experience, 
		Skill1 = @Skill1, 
		Skill2 = @Skill2, 
		Skill3 = @Skill3, 
		Alternate_Contact = @Alternate_Contact, 
		EmergencyContactPerson = @EmergencyContactPerson, 		
		Updated_by = @Updated_by, 
		Update_Date = @Update_Date
where Employee_ID = @Employee_ID

END

GO
/****** Object:  UserDefinedFunction [dbo].[FlattenedJSON]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FlattenedJSON] (@XMLResult XML)
RETURNS nvarchar(max)
WITH EXECUTE AS CALLER
AS
Begin
Declare  @JSONVersion NVarchar(max), @Rowcount int
Select @JSONVersion = '', @rowcount=count(*) from @XMLResult.nodes('/root/*') x(a)
Select @JSONVersion=@JSONVersion+
Stuff(
  (Select TheLine from 
    (Select ',
    {'+
      Stuff((Select ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":"'+
       Replace( --escape tab properly within a value
         Replace( --escape return properly
           Replace( --linefeed must be escaped
             Replace( --backslash too
               Replace(coalesce(b.c.value('text()[1]','NVARCHAR(MAX)'),''),--forwardslash
               '\', '\\'),   
              '/', '\/'),   
          CHAR(10),'\n'),   
         CHAR(13),'\r'),   
       CHAR(09),'\t')   
     +'"'   
     from x.a.nodes('*') b(c) 
     for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)'),1,1,'')+'}'
   from @XMLResult.nodes('/root/*') x(a)
   ) JSON(theLine)
  for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
,1,1,'')
if @Rowcount>1 Return '['+@JSONVersion+'
]'
return @JSONVersion
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_delimitedtotable]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_delimitedtotable](@DelimitedString varchar(max))  
returns @Values TABLE  
(  
 id int not null identity primary key clustered,   
 v VARCHAR(max)  
)  
as  
begin  
 declare @e int, @i int  
 set @i = 1  
 set @e = 1  
  
 set @DelimitedString = @DelimitedString + ','  
   
 while @e <> 0 and @i < 1000
 begin  
   set @e = charindex(',', @DelimitedString)  
   if @e <> 0  
   begin  
     insert into @Values (v)  
     select substring(@DelimitedString, 1, @e - 1)  
     set @DelimitedString = right(@DelimitedString, len(@DelimitedString) - @e)  
   end  
  set @i = @i + 1  
 end  
 return  
end  

GO
/****** Object:  UserDefinedFunction [dbo].[fnIntegerToWords]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnIntegerToWords](@Number as BIGINT) 
    RETURNS VARCHAR(1024)
AS

BEGIN
      DECLARE @Below20 TABLE (ID int identity(0,1), Word varchar(32))
      DECLARE @Below100 TABLE (ID int identity(2,1), Word varchar(32))
      INSERT @Below20 (Word) VALUES 
                        ( 'Zero'), ('One'),( 'Two' ), ( 'Three'),
                        ( 'Four' ), ( 'Five' ), ( 'Six' ), ( 'Seven' ),
                        ( 'Eight'), ( 'Nine'), ( 'Ten'), ( 'Eleven' ),
                        ( 'Twelve' ), ( 'Thirteen' ), ( 'Fourteen'),
                        ( 'Fifteen' ), ('Sixteen' ), ( 'Seventeen'),
                        ('Eighteen' ), ( 'Nineteen' ) 

       INSERT @Below100 VALUES ('Twenty'), ('Thirty'),('Forty'), ('Fifty'),
                               ('Sixty'), ('Seventy'), ('Eighty'), ('Ninety')

    declare @belowHundred as varchar(126) 

    if @Number > 99 begin
        select @belowHundred = dbo.fnIntegerToWords( @Number % 100)
    end

    DECLARE @English varchar(1024) = 

    (

      SELECT Case 
        WHEN @Number = 0 THEN  ''

        WHEN @Number BETWEEN 1 AND 19 
          THEN (SELECT Word FROM @Below20 WHERE ID=@Number)

       WHEN @Number BETWEEN 20 AND 99   
         THEN  (SELECT Word FROM @Below100 WHERE ID=@Number/10)+ '-' +
               dbo.fnIntegerToWords( @Number % 10) 

       WHEN @Number BETWEEN 100 AND 999   
         THEN  (dbo.fnIntegerToWords( @Number / 100)) +' Hundred '+
             Case WHEN @belowHundred <> '' THEN 'and ' + @belowHundred else @belowHundred end 

       WHEN @Number BETWEEN 1000 AND 999999   
         THEN  (dbo.fnIntegerToWords( @Number / 1000))+' Thousand '+
             dbo.fnIntegerToWords( @Number % 1000)  

       WHEN @Number BETWEEN 1000000 AND 999999999   
         THEN  (dbo.fnIntegerToWords( @Number / 1000000))+' Million '+
             dbo.fnIntegerToWords( @Number % 1000000) 

       WHEN @Number BETWEEN 1000000000 AND 999999999999   
         THEN  (dbo.fnIntegerToWords( @Number / 1000000000))+' Billion '+
             dbo.fnIntegerToWords( @Number % 1000000000) 

            ELSE ' INVALID INPUT' END
    )

    SELECT @English = RTRIM(@English)

    SELECT @English = RTRIM(LEFT(@English,len(@English)-1))
        WHERE RIGHT(@English,1)='-'

    RETURN (@English)

END 

GO
/****** Object:  UserDefinedFunction [dbo].[ProperCase]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ProperCase]
(
	@Text varchar(8000)
)
RETURNS varchar(8000)

AS
BEGIN
	
	-- Select [dbo].[ProperCase] ('AHT')


	 declare @Reset bit;
   declare @Ret varchar(8000);
   declare @i int;
   declare @c char(1);

   select @Reset = 1, @i=1, @Ret = '';

   while (@i <= len(@Text))
    select @c= substring(@Text,@i,1),
               @Ret = @Ret + case when @Reset=1 then UPPER(@c) else LOWER(@c) end,
               @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
               @i = @i +1
   return @Ret


END

GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]

(     

      @Input NVARCHAR(MAX),

      @Character CHAR(1)

)

RETURNS @Output TABLE (

      Item NVARCHAR(1000)

)

AS

BEGIN

      DECLARE @StartIndex INT, @EndIndex INT

 

      SET @StartIndex = 1

      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character

      BEGIN

            SET @Input = @Input + @Character

      END

 

      WHILE CHARINDEX(@Character, @Input) > 0

      BEGIN

            SET @EndIndex = CHARINDEX(@Character, @Input)

            

            INSERT INTO @Output(Item)

            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)

            

            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))

      END

 

      RETURN

END


GO
/****** Object:  UserDefinedFunction [dbo].[ToProperCase]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ToProperCase](@string VARCHAR(255)) RETURNS VARCHAR(255)
AS
BEGIN
  DECLARE @i INT           -- index
  DECLARE @l INT           -- input length
  DECLARE @c NCHAR(1)      -- current char
  DECLARE @f INT           -- first letter flag (1/0)
  DECLARE @o VARCHAR(255)  -- output string
  DECLARE @w VARCHAR(10)   -- characters considered as white space

  SET @w = '[' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(160) + ' ' + ']'
  SET @i = 1
  SET @l = LEN(@string)
  SET @f = 1
  SET @o = ''

  WHILE @i <= @l
  BEGIN
    SET @c = SUBSTRING(@string, @i, 1)
    IF @f = 1 
    BEGIN
     SET @o = @o + @c
     SET @f = 0
    END
    ELSE
    BEGIN
     SET @o = @o + LOWER(@c)
    END

    IF @c LIKE @w SET @f = 1

    SET @i = @i + 1
  END

  RETURN @o
END
GO
/****** Object:  UserDefinedFunction [dbo].[xGetdateBetween]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[xGetdateBetween]
(     
      @Increment              CHAR(1),
      @StartDate              smalldatetime,
      @EndDate                smalldatetime
)
RETURNS  
@SelectedRange    TABLE 
(xDate smalldatetime)
AS 
BEGIN
      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (xDate)
      SELECT DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[xGetDayDate]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[xGetDayDate]
(
	@endDate datetime,
	@dayname varchar(20),
	@dayPara varchar(20)
)
RETURNS date
AS
BEGIN
	
	DECLARE @date date
	
	;WITH DATERANGE AS
	 (
		SELECT DT = DATEADD(DD, 1, DATEADD(YEAR,-1,@ENDDATE))
		WHERE DATEADD(DD, 1, DATEADD(YEAR,-1,@ENDDATE)) <= @ENDDATE
		UNION ALL
		SELECT DATEADD(DD, 1, DT)
		FROM DATERANGE
		WHERE DATEADD(DD, 1, DT) < @ENDDATE
	 )

	SELECT @DATE=DT FROM (
	SELECT DT,DATENAME(DW,DT) + CONVERT(VARCHAR,ROW_NUMBER() OVER (ORDER BY DT ASC)) AS NAME FROM(
	SELECT TOP(13) *
	FROM DATERANGE
	WHERE DATENAME(DW,DT) = @dayname
	ORDER BY DT DESC) AS ST) AS FT
	WHERE NAME=@dayPara

	OPTION (MAXRECURSION 0);


	RETURN @DATE

END

GO
/****** Object:  UserDefinedFunction [dbo].[xGetWeekDates]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[xGetWeekDates]
(     
	@xDate smalldatetime,
	@xSD as bit = null,
	@Increment CHAR(1)
)
RETURNS  
@SelectedRange    TABLE 
(xDate smalldatetime)
AS 
BEGIN
	DECLARE @StartDate SMALLDATETIME
	DECLARE @EndDate SMALLDATETIME
	
	IF isnull(@xSD,0) = 0
	BEGIN
		SET @xSD = 0
	END
	ELSE
	BEGIN
		SET @xSD = 1
	END
	
	SET @StartDate = CONVERT(varchar, DATEADD(DAY, (2-@xSD) - DATEPART(WEEKDAY, @xDate), @xDate),112) 
	SET @EndDate = CONVERT(varchar,DATEADD(DAY, (8-@xSD) - DATEPART(WEEKDAY, @xDate), @xDate) ,112)
	
	;WITH cteRange (DateRange) AS (
		SELECT @StartDate
		UNION ALL
		SELECT 
			  CASE
					WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
					WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
					WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
			  END
		FROM cteRange
		WHERE DateRange <= 
			  CASE
					WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
					WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
					WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
			  END)
	  
	INSERT INTO @SelectedRange (xDate)
	SELECT DateRange
	FROM cteRange
	OPTION (MAXRECURSION 3660);
	RETURN
END
GO
/****** Object:  UserDefinedFunction [PM].[GetWorkday]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Name : GetWorkday
Parameters : 
			1. From Date - The date from which you'd like to count the number of non-weekend days 
			forward or backward.
			2. DaysToAdd - The integer representing the count of business days to 
			be added / subtracted from the above.
Output: A date that is 'n' Work Days after or before the From date.
Author / Support: paras.parmar@sitel.com; parasparmar@gmail.com; paras@parasparmar.com


*/
CREATE FUNCTION [PM].[GetWorkday]
(
    @FromDate DATE
    ,@DaysToAdd INT
)
RETURNS DATE 
AS 
BEGIN

    --If there are no days to add or subtract, return the day that was passed in
    IF @DaysToAdd = 0 RETURN @FromDate

    DECLARE @Weeks INT
    DECLARE @DMod INT
    DECLARE @FromDateIndex INT

    --number of weeks
    SET @Weeks = @DaysToAdd/5

    --remainder of days
    SET @dmod = @DaysToAdd%5

    --Get the FromDate day of the week, this logic standardizes the @@DateFirst to Sunday = 1
    SET @FromDateIndex = (DATEPART(weekday, @FromDate) + @@DATEFIRST - 1) % 7 + 1

    /*Splitting the addition vs subtraction logic for readability*/

    --Adding business days
    IF @DaysToAdd > 0 
        BEGIN 

            --If the FromDate is on a weekend, move it to the previous Friday
            IF @FromDateIndex IN(1,7) 
                BEGIN
                    SET @FromDate = DATEADD(dd,CASE @FromDateIndex WHEN 1 THEN -2 WHEN 7 THEN -1 END,@FromDate)
                    SET @FromDateIndex = 6
                END

            SET @FromDate = DATEADD(dd, 
                CASE 
                    --If the mod goes through the weekend, add 2 days to account for it
                    WHEN 
                        ((@FromDateIndex = 3 --Tuesday
                        AND @dmod > 3) --Days until Friday
                        OR
                        (@FromDateIndex = 4  --Wednesday
                        AND @dmod > 2)--Days until Friday
                        OR 
                        (@FromDateIndex = 5 --Thursday
                        AND @dmod > 1)--Days until Friday
                        OR 
                        (@FromDateIndex = 6 --Friday
                        AND @dmod > 0))--Days until Friday
                        THEN 
                            @DMod+2 
                    --Otherwise just add the mod
                    ELSE 
                        @DMod 
                END, @FromDate)

        END

    --Subtracting business days
    IF @DaysToAdd < 0 
        BEGIN 

            --If the FromDate is on a weekend, move it to the next Monday
            IF @FromDateIndex IN(1,7) 
                BEGIN
                    SET @FromDate = DATEADD(dd,CASE @FromDateIndex WHEN 1 THEN 1 WHEN 7 THEN 2 END,@FromDate)
                    SET @FromDateIndex = 2
                END

            SET @FromDate = DATEADD(dd, 
                CASE 
                    --If the mod goes through the weekend, subtract 2 days to account for it
                    WHEN 
                        ((@FromDateIndex = 5 --Thursday
                        AND @dmod < -3) --Days until Monday
                        OR
                        (@FromDateIndex = 4  --Wednesday
                        AND @dmod < -2)--Days until Monday
                        OR 
                        (@FromDateIndex = 3 --Tuesday
                        AND @dmod < -1)--Days until Monday
                        OR 
                        (@FromDateIndex = 2 --Monday
                        AND @dmod < 0))--Days until Monday
                        THEN 
                            @DMod-2 
                    --Otherwise just subtract the mod
                    ELSE 
                        @DMod 
                END, @FromDate)

        END

    --Shift the date by the number of weeks
    SET @FromDate = DATEADD(ww,@Weeks,@FromDate)

    RETURN @FromDate

END
GO
/****** Object:  Table [WFMP].[RosterMst]    Script Date: 9/16/2017 3:01:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[RosterMst](
	[RosterID] [int] IDENTITY(1,1) NOT NULL,
	[EmpCode] [int] NOT NULL,
	[DeptLinkId] [int] NOT NULL,
	[rDate] [smalldatetime] NOT NULL,
	[ShiftID] [int] NULL,
	[RepMgrCode] [int] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[updatedOn] [datetime] NOT NULL,
	[WOCount] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tbl_leave_request]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tbl_leave_request](
	[id] [int] NOT NULL,
	[ecn] [int] NOT NULL,
	[from_date] [date] NOT NULL,
	[to_date] [date] NOT NULL,
	[leave_reason] [nvarchar](max) NOT NULL,
	[applied_on] [datetime] NOT NULL,
	[status] [bit] NULL,
	[actioned_by] [int] NULL,
	[comments] [nvarchar](max) NULL,
	[actioned_on] [datetime] NULL,
	[IsCancelled] [bit] NULL,
	[cancel_reason] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbl_leave_request] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblCountry]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblCountry](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[Capital] [varchar](50) NOT NULL,
	[Currency] [varchar](50) NOT NULL,
	[Primary_Language] [varchar](50) NOT NULL,
	[Market] [varchar](50) NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblDepartment]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblDepartment](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Account] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblDepartment_Del]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblDepartment_Del](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Department] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblDepartment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblDepartmentLinkMst]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblDepartmentLinkMst](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[LOBID] [int] NOT NULL,
	[SkillSetID] [int] NOT NULL,
	[SubSkillSetID] [int] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblDesignation]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblDesignation](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Designation] [varchar](50) NOT NULL,
	[LevelID] [int] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblEmpStatus]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblEmpStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpStatus] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblFunction]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblFunction](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Function] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblJob_Type]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblJob_Type](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblLeaveType]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblLeaveType](
	[LeaveID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveText] [varchar](10) NOT NULL,
	[Active] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblLevel]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblLevel](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Level] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblLOB]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblLOB](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[LOB] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblMappingMst]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblMappingMst](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NOT NULL,
	[MarketID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblMaster]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblMaster](
	[Employee_ID] [int] NOT NULL,
	[First_Name] [varchar](255) NULL,
	[Middle_Name] [varchar](255) NULL,
	[Last_Name] [varchar](255) NULL,
	[DesignationID] [int] NULL,
	[LevelID] [int] NULL,
	[DOJ] [datetime] NULL,
	[DOP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[DPT] [varchar](10) NULL,
	[DOPS] [smalldatetime] NULL,
	[EmpStatus] [tinyint] NOT NULL,
	[TrngStatus] [tinyint] NOT NULL,
	[Job_Type] [tinyint] NULL,
	[CountryID] [int] NULL,
	[SiteID] [int] NULL,
	[DeptLinkId] [int] NULL,
	[RepMgrCode] [int] NULL,
	[TeamID] [varchar](25) NULL,
	[ntName] [varchar](50) NULL,
	[ResType] [tinyint] NULL,
	[BusinessID] [int] NULL,
	[Email_Office] [varchar](255) NULL,
	[IsReportingManager] [bit] NULL,
 CONSTRAINT [PK_tblMaster] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblMovementState]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblMovementState](
	[Id] [int] IDENTITY(0,1) NOT NULL,
	[State] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblMovementState] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblMovementTypes]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblMovementTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblProfile]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblProfile](
	[Employee_ID] [int] NOT NULL,
	[Date_of_Birth] [datetime] NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[Email_Personal] [varchar](255) NOT NULL,
	[Contact_Number] [bigint] NOT NULL,
	[AnniversaryDate] [datetime] NULL,
	[HighestQualification] [varchar](255) NOT NULL,
	[Transport] [bit] NOT NULL,
	[Address1] [varchar](255) NOT NULL,
	[Address2] [varchar](255) NULL,
	[Landmark] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[Total_Work_Experience] [int] NULL,
	[Skill1] [varchar](255) NULL,
	[Skill2] [varchar](255) NULL,
	[Skill3] [varchar](255) NULL,
	[Alternate_Contact] [bigint] NULL,
	[EmergencyContactPerson] [varchar](255) NULL,
	[UserImage] [nvarchar](255) NULL,
	[Updated_by] [nvarchar](50) NULL,
	[Update_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblQry]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblQry](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Qry] [varchar](2000) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblQualification]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblQualification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Qualification] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblRstWeeks]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblRstWeeks](
	[WeekId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[rYear] [int] NOT NULL,
	[rWeek] [int] NOT NULL,
	[FrDate] [smalldatetime] NOT NULL,
	[ToDate] [smalldatetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblShiftCode]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblShiftCode](
	[ShiftID] [int] IDENTITY(1,1) NOT NULL,
	[ShiftCode] [varchar](12) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[ShiftType] [tinyint] NOT NULL,
	[Exception] [bit] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_tblShiftCode] PRIMARY KEY CLUSTERED 
(
	[ShiftCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSite]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSite](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Site] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSkills]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblSkills](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Skill] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblSkillSet]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSkillSet](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[SkillSet] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSubSkillSet]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSubSkillSet](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[SubSkillSet] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblTrainingStatus]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblTrainingStatus](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[TrngStatus] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tbltrans_Movement]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tbltrans_Movement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FromDptLinkMstId] [int] NULL,
	[ToDptLinkMstId] [int] NULL,
	[FromMgr] [int] NULL,
	[ToMgr] [int] NULL,
	[EmpId] [int] NULL,
	[Type] [int] NULL,
	[State] [tinyint] NOT NULL,
	[InitBy] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[UpdaterID] [int] NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[xGetMonthsGlidePath]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[xGetMonthsGlidePath]  
(	
	@startDate smalldatetime
)
RETURNS TABLE 
AS
RETURN 
(
	Select Left(CONVERT(varchar,Dateadd(m,-2,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,-1,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,0,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,1,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,2,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,3,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,4,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,5,@startDate),112),6) + '01' xMonths 
	Union
	Select Left(CONVERT(varchar,Dateadd(m,6,@startDate),112),6) + '01' xMonths 

)



GO
/****** Object:  UserDefinedFunction [dbo].[xWeekStart]    Script Date: 9/16/2017 3:01:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[xWeekStart] 
(	
	-- Add the parameters for the function here
	@startDate smalldatetime, 
	@endDate smalldatetime
)
RETURNS TABLE 
AS
RETURN 
(
	WITH t1(N) AS (SELECT N FROM (VALUES(1),(1))a(N)), -- 2 Rows
t2(N) AS (SELECT 1 FROM t1 x, t1 y), -- 4 Rows (2*2)
t3(N) AS (SELECT 1 FROM t2 x, t2 y), -- 16 Rows (4*4)
t4(N) AS (SELECT 1 FROM t3 x, t3 y), -- 256 Rows (16*16)
t5(N) AS (SELECT 1 FROM t4 x, t4 y), -- 65,536 Rows (256*256)
tally(N) AS (SELECT 0 UNION ALL
             SELECT TOP (DATEDIFF(WEEK, @startDate, @endDate)) -- Limit the result-set straight up front
             ROW_NUMBER() OVER(ORDER BY (SELECT NULL))
             FROM t5 x, t5 y) -- 4,294,967,296 Rows (65,536*65,536)
SELECT N AS WeekNo,
CASE WHEN DATEADD(WEEK, DATEDIFF(WEEK, '2012-01-02', DATEADD(WEEK,N-1,@startDate)), '2012-01-02') < @startDate 
     THEN @startDate
     ELSE DATEADD(WEEK, DATEDIFF(WEEK, '2012-01-02', DATEADD(WEEK,N-1,@startDate)), '2012-01-02') END AS weekStart,
CASE WHEN DATEADD(WEEK, DATEDIFF(WEEK, '2012-01-08', DATEADD(WEEK,N,@startDate)), '2012-01-08') > @endDate 
     THEN @endDate
     ELSE DATEADD(WEEK, DATEDIFF(WEEK, '2012-01-08', DATEADD(WEEK,N,@startDate)), '2012-01-08') END AS weekEnd
FROM tally
)


GO
SET IDENTITY_INSERT [WFMP].[tblCountry] ON 

INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (1, N'Afghanistan', N'Kabul', N'Afghani', N'Dari Persian; Pashto', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (2, N'Albania', N'Tirane', N'Lek', N'Albanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (3, N'Algeria', N'Algiers', N'Algerian Dinar', N'Arabic; Tamazight; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (4, N'Andorra', N'Andorra la Vella', N'Euro', N'Catalan', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (5, N'Angola', N'Luanda', N'Kwanza', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (6, N'Antigua and Barbuda', N'Saint John''s', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (7, N'Argentina', N'Buenos Aires', N'Argentine Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (8, N'Armenia', N'Yerevan', N'Dram', N'Armenian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (9, N'Australia', N'Canberra', N'Australian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (10, N'Austria', N'Vienna', N'Euro', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (11, N'Azerbaijan', N'Baku', N'Manat', N'Azerbaijani', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (12, N'The Bahamas', N'Nassau', N'Bahamian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (13, N'Bahrain', N'Manama', N'Bahraini Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (14, N'Bangladesh', N'Dhaka', N'Taka', N'Bangla', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (15, N'Barbados', N'Bridgetown', N'Barbadian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (16, N'Belarus', N'Minsk', N'Belarusian Ruble', N'Belarusian; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (17, N'Belgium', N'Brussels', N'Euro', N'Dutch; French; German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (18, N'Belize', N'Belmopan', N'Belize Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (19, N'Benin', N'Porto-Novo', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (20, N'Bhutan', N'Thimphu', N'Ngultrum', N'Dzongkha', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (21, N'Bolivia', N'La Paz; Sucre', N'Boliviano', N'Spanish; Quechua; Aymara', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (22, N'Bosnia and Herzegovina', N'Sarajevo', N'Convertible Mark', N'Bosnian; Croatian; Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (23, N'Botswana', N'Gaborone', N'Pula', N'English; Tswana', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (24, N'Brazil', N'Brasilia', N'Real', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (25, N'Brunei', N'Bandar Seri Begawan', N'Brunei Dollar', N'Malay', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (26, N'Bulgaria', N'Sofia', N'Lev', N'Bulgarian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (27, N'Burkina Faso', N'Ouagadougou', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (28, N'Burundi', N'Bujumbura', N'Burundi Franc', N'Kirundi; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (29, N'Cambodia', N'Phnom Penh', N'Riel', N'Khmer', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (30, N'Cameroon', N'Yaounde', N'Central African CFA Franc', N'French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (31, N'Canada', N'Ottawa', N'Canadian Dollar', N'English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (32, N'Cape Verde', N'Praia', N'Cape Verdean Escudo', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (33, N'Central African Republic', N'Bangui', N'Central African CFA Franc', N'Sango; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (34, N'Chad', N'N''Djamena', N'Central African CFA Franc', N'French; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (35, N'Chile', N'Santiago', N'Chilean Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (36, N'China', N'Beijing', N'Chinese Yuan', N'Mandarin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (37, N'Colombia', N'Bogota', N'Colombian Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (38, N'Comoros', N'Moroni', N'Comorian Franc', N'Comorian; Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (39, N'Democratic Republic Of the Congo', N'Kinshasa', N'Congolese Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (40, N'Republic of the Congo', N'Brazzaville', N'Central African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (41, N'Costa Rica', N'San Jose', N'Colon', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (42, N'Cote d''Ivoire (Ivory Coast)', N'Yamoussoukro; Abidjan', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (43, N'Croatia', N'Zagreb', N'Croatian', N'Kuna', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (44, N'Cuba', N'Havana', N'Cuban Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (45, N'Cyprus', N'Nicosia', N'Euro', N'Greek; Turkish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (46, N'Czech Republic', N'Prague', N'Czech Koruna', N'Czech; Slovak', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (47, N'Denmark', N'Copenhagen', N'Danish Krone', N'Danish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (48, N'Djibouti', N'Djibouti', N'Djiboutian Franc', N'Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (49, N'Dominica', N'Rosesau', N'East Caribbean Dollar', N'English; French;Antillean Creole', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (50, N'Dominican Republic', N'Santo Domingo', N'Dominican Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (51, N'East Timor (Timor-Leste)', N'Dilli', N'United States Dollar', N'Tetum; Portuguese;Iindonesian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (52, N'Ecuador', N'Quito', N'United States Dollar', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (53, N'Egypt', N'Cairo', N'Egyptian Pound', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (54, N'El Salvador', N'San Salvador', N'United States Dollar', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (55, N'Equitorial Guinea', N'Malabo', N'Central African CFA Franc', N'Spanish; French; Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (56, N'Eritrea', N'Asmara', N'Nakfa', N'Arabic; Tigrinya; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (57, N'Estonia', N'Tallinn', N'Estonian Kroon; Euro', N'Estonian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (58, N'Ethiopia', N'Addis Ababa', N'Birr', N'Amharic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (59, N'Fiji', N'Suva', N'Fijian Dollar', N'English; Bau Fijian; Hindi', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (60, N'Finland', N'Helsinki', N'Euro', N'Finnish; Swedish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (61, N'France', N'Paris', N'Euro; CFP Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (62, N'Gabon', N'Libreville', N'Central African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (63, N'The Gambia', N'Banjul', N'Dalasi', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (64, N'Georgia', N'Tbilisi', N'Lari', N'Georgian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (65, N'Germany', N'Berlin', N'Euro', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (66, N'Ghana', N'Accra', N'Ghanaian Cedi', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (67, N'Greece', N'Athens', N'Euro', N'Greek', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (68, N'Grenada', N'St. George''s', N'East Caribbean Dollar', N'English; Patois', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (69, N'Guatemala', N'Guatemala City', N'Quetzal', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (70, N'Guinea', N'Conakry', N'Guinean Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (71, N'Guinea-Bissau', N'Bissau', N'West African CFA Franc', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (72, N'Guyana', N'Georgetown', N'Guyanese Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (73, N'Haiti', N'Port-au-Prince', N'Gourde', N'Haitian Creole; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (74, N'Honduras', N'Tegucigalpa', N'Lempira', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (75, N'Hungary', N'Budapest', N'Forint', N'Hungarian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (76, N'Iceland', N'Reykjavik', N'Icelandic Krona', N'Icelandic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (77, N'India', N'New Delhi', N'Indian Rupee', N'Hindi; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (78, N'Indonesia', N'Jakarta', N'Rupiah', N'Indonesian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (79, N'Iran', N'Tehran', N'Rial', N'Persian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (80, N'Iraq', N'Baghdad', N'Iraqi Dinar', N'Arabic; Kurdish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (81, N'Republic of Ireland', N'Dublin', N'Euro', N'English; Irish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (82, N'Israel', N'Jerusalem', N'Shekel', N'Hebrew; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (83, N'Italy', N'Rome', N'Euro', N'Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (84, N'Jamaica', N'Kingston', N'Jamaican Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (85, N'Japan', N'Tokyo', N'Yen', N'Japanese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (86, N'Jordan', N'Amman', N'Jordanian Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (87, N'Kazakhstan', N'Astana', N'Tenge', N'Kazakh; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (88, N'Kenya', N'Nairobi', N'Kenyan Shilling', N'Swahili; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (89, N'Kiribati', N'Tarawa Atoll', N'Kiribati Dollar', N'English; Gilbertese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (90, N'North Korea', N'Pyongyang', N'North Korean Won', N'Korean', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (91, N'South Korea', N'Seoul', N'South Korean Won', N'Korean', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (92, N'Kosovo', N'Pristina', N'Euro', N'Albanian; Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (93, N'Kuwait', N'Kuwait City', N'Kuwaiti Dollar', N'Arabic; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (94, N'Kyrgyzstan', N'Bishkek', N'Som', N'Kyrgyz; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (95, N'Laos', N'Vientiane', N'Kip', N'Lao (Laotian)', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (96, N'Latvia', N'Riga', N'Lats', N'Latvian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (97, N'Lebanon', N'Beirut', N'Lebanese Pound', N'Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (98, N'Lesotho', N'Maseru', N'Loti', N'Sesotho; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (99, N'Liberia', N'Monrovia', N'Liberian Dollar', N'English', NULL, 1)
GO
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (100, N'Libya', N'Tripoli', N'Libyan Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (101, N'Liechtenstein', N'Vaduz', N'Swiss Franc', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (102, N'Lithuania', N'Vilnius', N'Lithuanian Litas', N'Lithuanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (103, N'Luxembourg', N'Luxembourg', N'Euro', N'German; French;Luxembourgish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (104, N'Macedonia', N'Skopje', N'Macedonian Denar', N'Macedonian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (105, N'Madagascar', N'Antananarivo', N'Malagasy Ariary', N'Malagasy; French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (106, N'Malawi', N'Lilongwe', N'Malawi Kwacha', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (107, N'Malaysia', N'Kuala Lumpur', N'Ringgit', N'Malay', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (108, N'Maldives', N'Male', N'Maldivian Rufiyaa', N'Dhivehi', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (109, N'Mali', N'Bamako', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (110, N'Malta', N'Valletta', N'Euro', N'Maltese; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (111, N'Marshall Islands', N'Majuro', N'United States Dollar', N'Marshallese; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (112, N'Mauritania', N'Nouakchott', N'Ouguiya', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (113, N'Mauritius', N'Port Louis', N'Mauritian Rupee', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (114, N'Mexico', N'Mexico City', N'Mexican Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (115, N'Federal States of Micronesia', N'Palikir', N'United States Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (116, N'Moldova', N'Chisinau', N'Moldovan Leu', N'Moldovan (Romanian)', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (117, N'Monaco', N'Monaco', N'Euro', N'French; Italian; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (118, N'Mongolia', N'Ulaanbaatar', N'Togrog', N'Mongolian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (119, N'Montenegro', N'Podgorica', N'Euro', N'Montenegrin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (120, N'Morocco', N'Rabat', N'Moroccan Dirham', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (121, N'Mozambique', N'Maputo', N'Mozambican Metical', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (122, N'Myanmar (Burma)', N'Nypyidaw', N'Kyat', N'Burmese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (123, N'Namibia', N'Windhoek', N'Namibian Dollar', N'English; Afrikaans; German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (124, N'Nauru', N'Yaren', N'Australian Dollar', N'English; Nauran', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (125, N'Nepal', N'Kathmandu', N'Nepalese Rupee', N'Nepali', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (126, N'Netherlands', N'Amsterdam; The Hague', N'Euro', N'Dutch', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (127, N'New Zealand', N'Wellington', N'New Zealand Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (128, N'Nicaragua', N'Managua', N'Cordoba', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (129, N'Niger', N'Niamey', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (130, N'Nigeria', N'Abuja', N'Naira', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (131, N'Norway', N'Oslo', N'Norwegian Krone', N'Norwegian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (132, N'Oman', N'Muscat', N'Omani Rial', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (133, N'Pakistan', N'Islamabad', N'Pakistani Rupee', N'Urdu; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (134, N'Palau', N'Melekeok', N'United States Dollar', N'English; Palauan', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (135, N'Panama', N'Panama City', N'Balboa', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (136, N'Papa New Guinea', N'Port Moresby', N'Papa New Guinean Kina', N'English; Tok Pisin;Hiri Motu', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (137, N'Paraguay', N'Asuncion', N'Guarani', N'Spanish; Guarani', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (138, N'Peru', N'Lima', N'Nuevo Sol', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (139, N'Phillipines', N'Manila', N'Phillipine Peso', N'Filipino; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (140, N'Poland', N'Warsaw', N'Zloty', N'Polish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (141, N'Portugal', N'Lisbon', N'Euro', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (142, N'Qatar', N'Doha', N'Qatari Riyal', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (143, N'Romania', N'Bucharest', N'Romanian Rupee', N'Romanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (144, N'Russia', N'Moscow', N'Ruble', N'Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (145, N'Rwanda', N'Kigali', N'Rwandan Franc', N'Kinyarwanda; French;English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (146, N'Saint Kitts and Nevis', N'Basseterre', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (147, N'Saint Lucia', N'Castries', N'East Caribbean Dollar', N'English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (148, N'Saint Vincent and The Grenadines', N'Kingstown', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (149, N'Samoa', N'Apia', N'Tala', N'Samoan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (150, N'San Marino', N'San Marino', N'Euro', N'Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (151, N'Sao Tome and Principe', N'Sao Tome', N'Dobra', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (152, N'Saudi Arabia', N'Riyadh', N'Saudi Riyal', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (153, N'Senegal', N'Dakar', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (154, N'Serbia', N'Belgrade', N'Serbian Dinar', N'Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (155, N'Seychelles', N'Victoria', N'Seychoellois Rupee', N'Seychellois Creole;French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (156, N'Sierra Leone', N'Freetown', N'Leone', N'Krio; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (157, N'Singapore', N'Singapore', N'Singapore Dollar', N'English; Malay;Mandarin Chinese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (158, N'Slovakia', N'Bratislava', N'Euro', N'Slovak', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (159, N'Slovenia', N'Ljubljana', N'Euro', N'Slovene', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (160, N'Solomon Islands', N'Honiara', N'Solomon Islands Dollar', N'Solomons Pijin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (161, N'Somalia', N'Mogadishu', N'Somali Shilling', N'Somali; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (162, N'South Africa', N'Pretoria; Cape Town;Bloemfontein', N'Rand', N'Zulu; Xhosa; Afrikaans', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (163, N'Spain', N'Madrid', N'Euro', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (164, N'Sri Lanka', N'Colombo', N'Sri Lankan Rupee', N'Sinhala; Tamil', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (165, N'Sudan', N'Khartoum', N'Sudanese Pound', N'Arabic; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (166, N'Suriname', N'Paramaribo', N'Surinamese Dollar', N'Dutch', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (167, N'Swaziland', N'Mbabane', N'Lilangeni', N'English; SiSwati', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (168, N'Sweden', N'Stockholm', N'Swedish Krona', N'Swedish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (169, N'Switzerland', N'Berne', N'Swiss Franc', N'German; French; Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (170, N'Syria', N'Damascus', N'Syrian Pound', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (171, N'Taiwan', N'Taipei', N'New Taiwan Dollar', N'Mandarin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (172, N'Tajikistan', N'Dushanbe', N'Somoni', N'Tajik; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (173, N'Tanzania', N'Dar es Salaam; Dodoma', N'Tanzanian Schilling', N'Swahili', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (174, N'Thailand', N'Bangkok', N'Thai Baht', N'Thai', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (175, N'Togo', N'Lome', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (176, N'Tonga', N'Nuku''alofa', N'Pa''anga', N'Tongan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (177, N'Trinidad and Tobago', N'Port-of-Spain', N'Trinidad and Tobago Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (178, N'Tunisia', N'Tunis', N'Tunisian Dinar', N'Tunisian; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (179, N'Turkey', N'Ankara', N'Turkish Lira', N'Turkish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (180, N'Turkmenistan', N'Ashgabat', N'Turkmen New Manat', N'Turkmen; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (181, N'Tuvalu', N'Vaiaku', N'Tuvaluan Dollar', N'Tuvaluan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (182, N'Uganda', N'Kampala', N'Ugandan Shilling', N'Swahili; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (183, N'Ukraine', N'Kiev', N'Hryvnia', N'Ukranian; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (184, N'United Arab Emirates', N'Abu Dhabi', N'Dirham', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (185, N'United Kingdom', N'London', N'Pound Sterling', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (186, N'United States of America', N'Washington D.C.', N'United States Dollar', N'English; Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (187, N'Uruguay', N'Montevideo', N'Uruguayan Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (188, N'Uzbekistan', N'Tashkent', N'Uzbekistan Som', N'Uzbek; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (189, N'Vanuatu', N'Port-Vila', N'Vanuatu Vatu', N'Bislama; English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (190, N'Vatican City', N'Vatican City', N'Euro', N'Latin; Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (191, N'Venezuela', N'Caracas', N'Bolivar Fuerte', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (192, N'Vietnam', N'Hanoi', N'Dong', N'Vietnamese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (193, N'Yemen', N'Sanaa', N'Yemeni Rial', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (194, N'Zambia', N'Lusaka', N'Zambian Kwacha', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (195, N'Zimbabwe', N'Harare', N'United States Dollar', N'English', NULL, 1)
SET IDENTITY_INSERT [WFMP].[tblCountry] OFF
SET IDENTITY_INSERT [WFMP].[tblDepartment] ON 

INSERT [WFMP].[tblDepartment] ([TransID], [Account], [Active]) VALUES (1, N'WFM', 1)
INSERT [WFMP].[tblDepartment] ([TransID], [Account], [Active]) VALUES (2, N'USAA', 1)
INSERT [WFMP].[tblDepartment] ([TransID], [Account], [Active]) VALUES (3, N'HR', 1)
SET IDENTITY_INSERT [WFMP].[tblDepartment] OFF
SET IDENTITY_INSERT [WFMP].[tblDepartment_Del] ON 

INSERT [WFMP].[tblDepartment_Del] ([Id], [Department]) VALUES (1, N'Administration')
INSERT [WFMP].[tblDepartment_Del] ([Id], [Department]) VALUES (2, N'Centralized')
INSERT [WFMP].[tblDepartment_Del] ([Id], [Department]) VALUES (3, N'CWFM')
SET IDENTITY_INSERT [WFMP].[tblDepartment_Del] OFF
SET IDENTITY_INSERT [WFMP].[tblDepartmentLinkMst] ON 

INSERT [WFMP].[tblDepartmentLinkMst] ([TransID], [FunctionID], [DepartmentID], [LOBID], [SkillSetID], [SubSkillSetID], [Active]) VALUES (1, 1, 2, 4, 4, 4, 1)
INSERT [WFMP].[tblDepartmentLinkMst] ([TransID], [FunctionID], [DepartmentID], [LOBID], [SkillSetID], [SubSkillSetID], [Active]) VALUES (2, 2, 1, 1, 1, 1, 1)
INSERT [WFMP].[tblDepartmentLinkMst] ([TransID], [FunctionID], [DepartmentID], [LOBID], [SkillSetID], [SubSkillSetID], [Active]) VALUES (3, 2, 1, 2, 2, 2, 1)
INSERT [WFMP].[tblDepartmentLinkMst] ([TransID], [FunctionID], [DepartmentID], [LOBID], [SkillSetID], [SubSkillSetID], [Active]) VALUES (4, 2, 3, 5, 5, 7, 1)
SET IDENTITY_INSERT [WFMP].[tblDepartmentLinkMst] OFF
SET IDENTITY_INSERT [WFMP].[tblDesignation] ON 

INSERT [WFMP].[tblDesignation] ([TransID], [Designation], [LevelID], [Active]) VALUES (1, N'Sr. Software Developer', 1, 1)
SET IDENTITY_INSERT [WFMP].[tblDesignation] OFF
SET IDENTITY_INSERT [WFMP].[tblEmpStatus] ON 

INSERT [WFMP].[tblEmpStatus] ([Id], [EmpStatus]) VALUES (1, N'Active')
SET IDENTITY_INSERT [WFMP].[tblEmpStatus] OFF
SET IDENTITY_INSERT [WFMP].[tblFunction] ON 

INSERT [WFMP].[tblFunction] ([TransID], [Function], [Active]) VALUES (1, N'Operations', 1)
INSERT [WFMP].[tblFunction] ([TransID], [Function], [Active]) VALUES (2, N'Support', 1)
SET IDENTITY_INSERT [WFMP].[tblFunction] OFF
SET IDENTITY_INSERT [WFMP].[tblJob_Type] ON 

INSERT [WFMP].[tblJob_Type] ([Id], [Type]) VALUES (1, N'Software Development')
SET IDENTITY_INSERT [WFMP].[tblJob_Type] OFF
SET IDENTITY_INSERT [WFMP].[tblLeaveType] ON 

INSERT [WFMP].[tblLeaveType] ([LeaveID], [LeaveText], [Active]) VALUES (1, N'Leave', 1)
INSERT [WFMP].[tblLeaveType] ([LeaveID], [LeaveText], [Active]) VALUES (2, N'Lave2', 1)
SET IDENTITY_INSERT [WFMP].[tblLeaveType] OFF
SET IDENTITY_INSERT [WFMP].[tblLevel] ON 

INSERT [WFMP].[tblLevel] ([TransID], [Level], [Active]) VALUES (1, N'Senior', 1)
SET IDENTITY_INSERT [WFMP].[tblLevel] OFF
SET IDENTITY_INSERT [WFMP].[tblLOB] ON 

INSERT [WFMP].[tblLOB] ([TransID], [LOB], [Active]) VALUES (1, N'Analytics', 1)
INSERT [WFMP].[tblLOB] ([TransID], [LOB], [Active]) VALUES (2, N'Planning', 1)
INSERT [WFMP].[tblLOB] ([TransID], [LOB], [Active]) VALUES (4, N'LOB1', 1)
INSERT [WFMP].[tblLOB] ([TransID], [LOB], [Active]) VALUES (5, N'BHR', 1)
SET IDENTITY_INSERT [WFMP].[tblLOB] OFF
SET IDENTITY_INSERT [WFMP].[tblMappingMst] ON 

INSERT [WFMP].[tblMappingMst] ([TransID], [CountryID], [MarketID], [SiteID], [Active]) VALUES (1, 77, 1, 1, 1)
SET IDENTITY_INSERT [WFMP].[tblMappingMst] OFF
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (24642, N'Soumen', N'Gomes', N'', 1, NULL, CAST(0x00009E4800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 837214, N'', NULL, NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (24801, N'Dhanesh', N'Kumar', N'', 1, NULL, CAST(0x00009E4B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', N'ddhan001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (24873, N'Suresh', N'Sundar', N'', 1, NULL, CAST(0x00009EA800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', N'ssund007', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (26262, N'Krishna', N'Kumar', N'', 1, NULL, CAST(0x0000A08200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', N'kkuma003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (745771, N'Hina', N'Bangdiwalla', N'', 1, NULL, CAST(0x0000A57100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'hbang002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (748882, N'Neil', N'Dharve', N'', 1, NULL, CAST(0x0000986300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'ndhar001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (774874, N'Ashok', N'Vishwakarma', N'', 1, NULL, CAST(0x0000A09800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 825967, N'', N'avish001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (789278, N'Swapnal', N'Patil', N'', 1, NULL, CAST(0x0000A11C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 825967, N'', N'spati010', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (793792, N'Joseph', N'Furtado', N'', 1, NULL, CAST(0x0000A14D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'Jfurt002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (797269, N'Pravin', N'Aloz', N'', 1, NULL, CAST(0x0000A17000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'paloz001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (797595, N'Shilpa', N'Hiroji', N'', 1, NULL, CAST(0x0000A17700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'shiro001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (798871, N'Babita', N'Garde', N'', 1, NULL, CAST(0x0000A18500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', N'gbabi001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (799532, N'Balu', N'M', N'kale', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'bkale001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (799533, N'Chandrakant', N'Sarkale', N'', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'csark001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (799534, N'Avinash', N'Khot', N'', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 926861, N'', N'akhot001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (801071, N'Amit', N'Bhosle', N'', 1, NULL, CAST(0x0000A19500000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'Avasa001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (801083, N'Venkatesh', N'Naik', N'', 1, NULL, CAST(0x0000A19A00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 937297, N'', N'vnaik002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (803470, N'Vinita', N'Pereira', N'', 1, NULL, CAST(0x0000A1AF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 926861, N'', N'vpere018', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (803471, N'Vinod', N'Prithviraj', N'Chauhan', 1, NULL, CAST(0x0000A1AF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'Vchoh001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (808659, N'Pradeep', N'Yadav', N'', 1, NULL, CAST(0x0000A1E000000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'Pyada005', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (811476, N'Prashant', N'Goradia', N'', 1, NULL, CAST(0x0000A1FC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'pgora001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (812585, N'Nivritti', N'Bajpai', N'', 1, NULL, CAST(0x0000A20A00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'nbajp001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (813064, N'Pritesh', N'Jitendra', N'Vora', 1, NULL, CAST(0x0000A21100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 811476, N'', N'pjite001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (813067, N'Clifford', N'Bernard', N'Pereira', 1, NULL, CAST(0x0000A21100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 811476, N'', N'Cpere059', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (816186, N'Vishal', N'Mujumdar', N'', 1, NULL, CAST(0x0000A22D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'vsudh001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (816774, N'Lava', N'Agnihotri', N'', 1, NULL, CAST(0x0000A23500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 808659, N'', N'Lagni001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (817172, N'Govind', N'Bansal', N'', 1, NULL, CAST(0x0000A23500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'gbans001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (825967, N'Vishal', N'Shirsat', N'', 1, NULL, CAST(0x0000A28300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 923563, N'', N'vshir001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (827810, N'Imran', N'Pathan', N'', 1, NULL, CAST(0x0000A29600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'pimra002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (828394, N'Jayesh', N'Rawal', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 868903, N'', N'jkuma011', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (828401, N'Yogendra', N'Singh', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'yramd001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (828422, N'Kunal', N'Patel', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'kpate011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (828909, N'Chirag', N'Baban', N'Nawale', 1, NULL, CAST(0x0000A2AC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'cbaba002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (829267, N'Dhanraj', N'Ranganathan', N'', 1, NULL, CAST(0x0000A2B400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', N'drang003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (830381, N'Athang', N'Tikekar', N'', 1, NULL, CAST(0x0000A2C300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'atike001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (831966, N'Pramod', N'Rajguru', N'', 1, NULL, CAST(0x0000A2D500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'prajg001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (833379, N'Francis', N'Chettiar', N'', 1, NULL, CAST(0x0000A2E300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'fjaya001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (835064, N'Harsh', N'Mehta', N'', 1, NULL, CAST(0x0000A2F800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'hmeht003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (836618, N'Amit', N'Gourav', N'', 1, NULL, CAST(0x0000A30600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'agour004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (836620, N'Bhaskar', N'Ranje', N'', 1, NULL, CAST(0x0000A30600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'branj001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (837214, N'Vivek', N'Vishwakarma', N'', 1, NULL, CAST(0x0000A30D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'vvish002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (838408, N'Puja', N'Bhatia', N'', 1, NULL, CAST(0x0000A31B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'pbhat004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (840454, N'Sarwan', N'Singh', N'', 1, NULL, CAST(0x0000A32900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'ssing054', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (843858, N'ManvendraPratap', N'Singh', N'', 1, NULL, CAST(0x0000A34500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'msing026', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (844580, N'Sudhir', N'Sutar', N'', 1, NULL, CAST(0x0000A34C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 825967, N'', N'ssuta004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (844898, N'Mohammed', N'Osman', N'Kaleem', 1, NULL, CAST(0x0000A34C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'mkale003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (845134, N'Santanu', N'Das', N'', 1, NULL, CAST(0x0000A34F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'Sdas014', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (848105, N'Durgesh', N'Rajbahak', N'', 1, NULL, CAST(0x0000A36800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 868903, N'', N'drajb001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (848106, N'Melwyn', N'Noronha', N'', 1, NULL, CAST(0x0000A36800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'mnoro002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (848628, N'Viswanath', N'', N'', 1, NULL, CAST(0x0000A36B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'va001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (848992, N'Paritosh', N'Kumar', N'Mishra', 1, NULL, CAST(0x0000A36F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'pmish004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (851309, N'Rajesh', N'Potdar', N'', 1, NULL, CAST(0x0000A38400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'rpotd001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (852774, N'Cornelius', N'Nelson', N'Raj', 1, NULL, CAST(0x0000A39200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', N'cnels011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (853184, N'Solomon', N'Raj', N'', 1, NULL, CAST(0x0000A39500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'ssm001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (853522, N'Rogaciano', N'Fernandes', N'', 1, NULL, CAST(0x0000A39A00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'rb002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (856283, N'Ritesh', N'D', N'Nair', 1, NULL, CAST(0x0000A3AB00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 801071, N'', N'Rnair008', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (856409, N'Ghansham', N'Dande', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'gdand003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (856410, N'Chakradhari', N'A', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'cakel001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (857545, N'Mahesh', N'Kedia', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'mkedi001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (857723, N'ManeshKumar', N'Mekkonath', N'', 1, NULL, CAST(0x0000A3B700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', N'mmekk001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (861880, N'Sanjay', N'Panjiyar', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'spanj002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (861881, N'Ajay', N'Yadav', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 811476, N'', N'Ayada013', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (861882, N'Balaji', N'Ranganathan', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 811476, N'', N'brang002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (862586, N'Mubeen', N'Shaikh', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'mshai066', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (862589, N'Sachin', N'Singh', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'ssing066', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (862590, N'Rakesh', N'Patil', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', N'rpati003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (864669, N'Durgesh', N'Rai', N'', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 926861, N'', N'drai003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (864671, N'Kabir', N'Singh', N'Sagoo', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'ksago001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (864672, N'Abhishek', N'Pawar', N'', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'apawa004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (865630, N'Henna', N'Shaikh', N'', 1, NULL, CAST(0x0000A3E200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', N'Hshai013', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (865631, N'Kamran', N'Shaikh', N'', 1, NULL, CAST(0x0000A3E200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', N'kshai011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (868084, N'Taranjit', N'Singh', N'', 1, NULL, CAST(0x0000A3FB00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'tmokh001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (868903, N'Joy', N'Kunda', N'', 1, NULL, CAST(0x0000A40400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'Jkund002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (869214, N'Majid', N'Shaikh', N'', 1, NULL, CAST(0x0000A40A00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'mshai070', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (869805, N'Ashish', N'Safaya', N'', 1, NULL, CAST(0x0000A41700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'Asafa001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (871095, N'Hiten', N'Shah', N'', 1, NULL, CAST(0x0000A42500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', N'hshah011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (874845, N'Mukteshwar', N'Sharma', N'', 1, NULL, CAST(0x0000A44800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'mshar034', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (874846, N'Abdul', N'Latif', N'Ansari', 1, NULL, CAST(0x0000A44800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'aansa008', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (876085, N'Mukesh', N'Rathod', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'mrath004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (876086, N'Uttam', N'Agarwal', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813064, N'', N'uagar001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (876087, N'Neha', N'Chandna', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', N'nchan016', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (876851, N'Jitesh', N'Solanki', N'', 1, NULL, CAST(0x0000A45D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 801071, N'', N'Jsola011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (877428, N'Abhijeet', N'Chavan', N'', 1, NULL, CAST(0x0000A46400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', N'achav055', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (877429, N'Yogesh', N'Kandoi', N'', 1, NULL, CAST(0x0000A46400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'ykand001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878219, N'Sagar', N'Katkar', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', N'skatk004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878220, N'Ranjan', N'Dakua', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', N'rdaku001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878221, N'Vishal', N'Bobhate', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'vbobh001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878222, N'Illyas', N'Mulla', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'imull002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878516, N'Santosh', N'Bidari', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'sbida001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878517, N'Jeethan', N'Saldanha', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', N'jsald019', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878518, N'Joseph', N'Miranda', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'Jmira036', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (878819, N'Yogendra', N'Umrankar', N'', 1, NULL, CAST(0x0000A47500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'yumra001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (879597, N'Amit', N'Das', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'adas005', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (879598, N'Vidyalata', N'Shetty', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'vshet002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (879599, N'Varun', N'Sikka', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 808659, N'', N'Vsikk001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (879600, N'Krishna', N'Vallakati', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'Kvall014', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (880343, N'George', N'Fernandes', N'', 1, NULL, CAST(0x0000A48300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', N'gfern020', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (882790, N'Anil', N'Kamble', N'', 1, NULL, CAST(0x0000A49500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934763, N'', N'akamb002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (882791, N'Manoj', N'Chauhan', N'', 1, NULL, CAST(0x0000A49500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 868903, N'', N'mchau006', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (883061, N'Reginold', N'Roche', N'', 1, NULL, CAST(0x0000A49800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'rroch014', NULL, 1, NULL, 0)
GO
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (885555, N'Rajesh', N'Shelar', N'', 1, NULL, CAST(0x0000A4AD00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'rshel009 ', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (885559, N'Imran', N'Khan', N'', 1, NULL, CAST(0x0000A4AD00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'ikhan025', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (886896, N'Rahul', N'Manoj', N'Singh', 1, NULL, CAST(0x0000A4B800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'rsing056 ', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (887163, N'Rohit', N'Kusurkar', N'', 1, NULL, CAST(0x0000A4BB00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'rkusu001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (887309, N'Ankur', N'Dubey', N'', 1, NULL, CAST(0x0000A4BF00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 24642, N'', N'adube010', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (889189, N'Ramchandra', N'Sahu', N'', 1, NULL, CAST(0x0000A4CD00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'rsahu001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (892153, N'Siddarth', N'Sharma', N'', 1, NULL, CAST(0x0000A4E500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'sshar049', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (892154, N'Abdul', N'Gaffar', N'Shaikh', 1, NULL, CAST(0x0000A4E500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'ashai069', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (892804, N'Raman', N'Sharma', N'', 1, NULL, CAST(0x0000A4EA00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'rshar030', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (893919, N'Nitin', N'Kotian', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 798904, N'', N'nkoti003', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (894060, N'Ali', N'Asghar', N'Razvi', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'arazv001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (894061, N'Praveen', N'Kumar', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'pkuma026', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (894062, N'Mayuresh', N'Chavan', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'mchav047', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (894063, N'Pooja', N'Kapoor', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'pkapo003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (894558, N'Anchali', N'Thakur', N'', 1, NULL, CAST(0x0000A4F700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', N'athak010', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (897386, N'Paramita', N'Mandal', N'', 1, NULL, CAST(0x0000A50C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', N'pmand006', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (897387, N'Taruvar', N'Oberoi', N'', 1, NULL, CAST(0x0000A50C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813064, N'', N'tober001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (898564, N'Shariq', N'Shamim', N'Chaudhari', 1, NULL, CAST(0x0000A51300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'schau020', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (898831, N'Finto', N'Francis', N'Koreth', 1, NULL, CAST(0x0000A51400000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'fkore001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (903424, N'Sridarshi', N'Kundu', N'', 1, NULL, CAST(0x0000A52F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'skund005', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (905328, N'Akhilesh', N'Kumar', N'', 1, NULL, CAST(0x0000A53600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'akuma035', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (908101, N'John', N'Fernandes', N'', 1, NULL, CAST(0x0000A55200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'jfern138', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (908308, N'Aazib', N'Ansari', N'', 1, NULL, CAST(0x0000A55200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'aansa012', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (911686, N'Vinayak', N'Gundaram', N'', 1, NULL, CAST(0x0000A57C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'vgund003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (911687, N'Paramvir', N'Singh', N'', 1, NULL, CAST(0x0000A57C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'psing031', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (911799, N'Robinder', N'Singh', N'Oberoi', 1, NULL, CAST(0x0000A57F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'rober001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (914958, N'Swapnil', N'Chandrakant', N'Karvande', 1, NULL, CAST(0x0000A59F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'skarv001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (918031, N'Komal', N'Trivedi', N'', 1, 1, CAST(0x0000A5B400000000 AS DateTime), CAST(0x0000A5B400000000 AS DateTime), NULL, N'3', CAST(0xA5B40000 AS SmallDateTime), 1, 1, 1, 77, 1, 1, 923563, N'1', N'ktriv003', 0, 1, N'komal.trivedi@sitel.com', 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (923563, N'Gurdeep', N'', N'Singh', 1, NULL, CAST(0x0000A5E500000000 AS DateTime), CAST(0x0000A5E500000000 AS DateTime), NULL, N'3', CAST(0xA5E50000 AS SmallDateTime), 1, 1, 1, NULL, NULL, 1, 745771, NULL, N'gsing017', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (923564, N'Sashikaran', N'', N'', 1, NULL, CAST(0x0000A5E700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N's.006', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (924101, N'Sandip', N'Chawda', N'', 1, NULL, CAST(0x0000A5E800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'schaw004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (924516, N'Jyoti', N'Madhubhai', N'Dabhi', 1, NULL, CAST(0x0000A5EC00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'jdabh001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (926860, N'Sohil', N'Feroz', N'Jesani', 1, NULL, CAST(0x0000A60100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'sjesa002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (926861, N'Vicky', N'Fernandes', N'', 1, NULL, CAST(0x0000A60100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 928948, N'', N'vfern016', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (927270, N'Gautham', N'Rangarajan', N'', 1, NULL, CAST(0x0000A60400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'grang001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (927271, N'Jasbir', N'Singh', N'', 1, NULL, CAST(0x0000A60400000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'jsing045', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (928948, N'Sandeep', N'Lalla', N'', 1, NULL, CAST(0x0000A60F00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 893919, N'', N'slall002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (929334, N'Priya', N'Dsouza', N'', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'Pdsou014', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (929335, N'Gyanendra', N'Singh', N'Bais', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'gbais002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (929336, N'Noel', N'Rodrigues', N'', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 825967, N'', N'nrodr058', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (929843, N'Shantanu', N'Das', N'', 1, NULL, CAST(0x0000A61800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 937297, N'', N'sdas020', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (930516, N'Shyam', N'Verma', N'', 1, NULL, CAST(0x0000A61D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'sverm013', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (930517, N'Faisal', N'Modan', N'', 1, NULL, CAST(0x0000A61D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'mmoda001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (931040, N'Paras', N'Chandrakant', N'Parmar', 1, 1, CAST(0x0000A62000000000 AS DateTime), CAST(0x0000A62000000000 AS DateTime), NULL, N'3', CAST(0xA6200000 AS SmallDateTime), 1, 1, 1, 77, 1, 1, 923563, N'1', N'pparm001', 0, 1, N'paras.parmar@sitel.com', 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (931042, N'Ashish', N'Sharma', N'', 1, NULL, CAST(0x0000A62000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'ashar055', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (932458, N'Rushikesh', N'Patil', N'', 1, NULL, CAST(0x0000A62B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'rpati005', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (932459, N'Rajeshwar', N'Gautam', N'', 1, NULL, CAST(0x0000A62B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'rgaut008', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (932878, N'Gursharan', N'Lail', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'glail001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (932879, N'Welina', N'Parmar', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 801071, N'', N'wparm001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (932880, N'Amit', N'Kamble', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 808659, N'', N'akamb004', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (933438, N'Abhishek', N'Wasnik', N'', 1, NULL, CAST(0x0000A63200000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'awasn001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934284, N'Jagdeep', N'Singh', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'jsing050', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934285, N'Pooja', N'Singh', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'psing037', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934286, N'Aaditya', N'Iyer', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'aiyer003', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934287, N'Deepesh', N'kapoor', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'dkapo001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934288, N'Lokenath', N'Guha', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'lguha001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934290, N'Uma', N'Kant', N'Tiwari', 1, NULL, CAST(0x0000A63500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 868903, N'', N'utiwa002', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934291, N'Aniket', N'Kalbade', N'', 1, NULL, CAST(0x0000A63500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', N'akalb001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934761, N'Srabani', N'Basak', N'', 1, NULL, CAST(0x0000A64000000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 926861, N'', N'sbasa006', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934763, N'Gaurang', N'Suri', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 827810, N'', N'g.001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934764, N'Sameer', N'Merchant', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'smerc021', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (934765, N'Gaurav', N'Batra', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'gbatr001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (935208, N'Bhakti', N'Bhanushali', N'', 1, NULL, CAST(0x0000A64300000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'bbhan002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (935209, N'Pratik', N'Mendon', N'', 1, NULL, CAST(0x0000A64300000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 937297, N'', N'pmend030', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (935485, N'Mujammil', N'Khan', N'', 1, NULL, CAST(0x0000A64700000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', N'mkhan109', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (935887, N'Martin', N'Belly', N'', 1, NULL, CAST(0x0000A64A00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', N'mbell047', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (936511, N'Saurabh', N'Parab', N'', 1, NULL, CAST(0x0000A65100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'spara021', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (936512, N'Prem', N'Mishra', N'', 1, NULL, CAST(0x0000A65100000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', N'pmish008', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937072, N'B.', N'Muthukumar', N'Pillai', 1, NULL, CAST(0x0000A65500000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', N'BPILL001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937073, N'Nandini', N'Kriplani', N'', 1, NULL, CAST(0x0000A65500000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', N'nkrip001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937296, N'Rahul', N'Walvekar', N'', 1, NULL, CAST(0x0000A65C00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'rwalv001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937297, N'Sandeep', N'Bodhe', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 923563, N'', N'sbodh001', NULL, 1, NULL, 1)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937298, N'Vinay', N'Kumar', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', N'vkuma021', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (937300, N'Vinay', N'Kate', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 813064, N'', N'vkate001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (939481, N'Rakesh', N'Pawar', N'', 1, NULL, CAST(0x0000A66600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'rpawa005', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (940575, N'Melvin', N'Varghese', N'', 1, NULL, CAST(0x0000A67100000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', N'mvar042', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (942228, N'Savio', N'Mogoveer', N'', 1, NULL, CAST(0x0000A67900000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'smogo001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (942407, N'Krunal', N'Kapadia', N'', 1, NULL, CAST(0x0000A67B00000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', N'kkapa002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (981583, N'Hitesh', N'Thakur', N'', 1, NULL, CAST(0x0000A67B00000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 937297, N'', N'hthak005', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (983444, N'Amit ', N'Kumar', N'Das', 1, NULL, CAST(0x0000A68600000000 AS DateTime), NULL, NULL, N'3', NULL, 1, 1, 1, NULL, NULL, 1, 812585, N'', N'akuma044', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (988555, N'Dhara', N'Doshi', N'', 1, NULL, CAST(0x0000A6A200000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', N'ddosh002', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (988963, N'Rajeev', N'V', N'Menon', 1, NULL, CAST(0x0000A6A200000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', N'rmeno011', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (989828, N'Shabarinath', N'Donthu', N'', 1, NULL, CAST(0x0000A69400000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 808659, N'', N'sdont001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (992104, N'Vani', N'Prasad', N'Muthyala', 1, NULL, CAST(0x0000A6A900000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', N'vmuth006', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (993959, N'Krupendra', N'Gholap', N'', 1, NULL, CAST(0x0000A6BA00000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'kghol001', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (995060, N'Sapna', N'Roy', N'', 1, NULL, CAST(0x0000A6BE00000000 AS DateTime), NULL, NULL, N'2', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', N'sroy020', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (998819, N'Sandeep', N'Mishra', N'', 1, NULL, CAST(0x0000A6D300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (998838, N'Sanjay', N'Sharma', N'', 1, NULL, CAST(0x0000A6D300000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 801071, N'', N'sshar067', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1000903, N'Vivek', N'Kumar', N'', 1, NULL, CAST(0x0000A6EB00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 861881, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1003036, N'Mahesh', N'Nathan', N'', 1, NULL, CAST(0x0000A6FE00000000 AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 1, 931040, N'', N'mnath007', NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1005511, N'Roja', N'Pillai', N'', 1, NULL, CAST(0x0000A70B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1005521, N'Ajit', N'Tambe', N'', 1, NULL, CAST(0x0000A70E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1006545, N'Aristo', N'Fernandes', N'', 1, NULL, CAST(0x0000A71500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 797269, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1007015, N'Chandrani', N'Dutta', N'', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1007019, N'Surabhi', N'Pavan', N'Kumar', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1007034, N'Pankaj', N'Basnal', N'', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 828401, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1008617, N'Anupam', N'Shyamnarayan', N'Maurya', 1, NULL, CAST(0x0000A72A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1008902, N'Anagha', N'Keni', N'', 1, NULL, CAST(0x0000A72E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1009480, N'Henry', N'Pereira', N'', 1, NULL, CAST(0x0000A73100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 848105, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1010643, N'Sunil', N'Maravi', N'', 1, NULL, CAST(0x0000A73C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', NULL, NULL, 1, NULL, 0)
GO
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1014153, N'Rachita', N'Chowdhury', N'', 1, NULL, CAST(0x0000A75800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 828394, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1014327, N'Lionel', N'D''souza', N'', 1, NULL, CAST(0x0000A75800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1015448, N'RajKumar', N'Adhude', N'', 1, NULL, CAST(0x0000A75F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1015652, N'Lleyton', N'Roy', N'', 1, NULL, CAST(0x0000A76200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1015689, N'Raghavendra', N'Segunala', N'', 1, NULL, CAST(0x0000A76000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 934290, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1016979, N'Dhruva', N'Chowdhary', N'', 1, NULL, CAST(0x0000A76D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 813067, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1017601, N'Charlynn', N'Taylor', N'', 1, NULL, CAST(0x0000A77400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 926861, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1018423, N'Farhan', N'Ansari', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 861882, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1018425, N'Tasoof', N'Noor', N'Mohd Shaikh', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1018427, N'Shivani', N'Deepak', N'Misal', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1018432, N'Deepak', N'Mor', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1018438, N'Vishvanath', N'Patil', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1019889, N'Manoj', N'Kataria', N'', 1, NULL, CAST(0x0000A78900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 793792, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1019892, N'Vishal', N'Deshmukh', N'', 1, NULL, CAST(0x0000A78900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 908308, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1019895, N'Swapnil', N'Navle', N'', 1, NULL, CAST(0x0000A78500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1019898, N'Suryavanshi,', N'Juhi', N'', 1, NULL, CAST(0x0000A78500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 830381, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1020424, N'Andrea', N'Noronha', N'', 1, NULL, CAST(0x0000A78C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 817172, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1020569, N'Sanket', N'Solanki', N'', 1, NULL, CAST(0x0000A79000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 882791, N'', NULL, NULL, 1, NULL, 0)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [DeptLinkId], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office], [IsReportingManager]) VALUES (1020576, N'Malla,', N'Asish', N'', 1, NULL, CAST(0x0000A79000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, 803471, N'', NULL, NULL, 1, NULL, 0)
SET IDENTITY_INSERT [WFMP].[tblMovementState] ON 

INSERT [WFMP].[tblMovementState] ([Id], [State]) VALUES (0, NULL)
INSERT [WFMP].[tblMovementState] ([Id], [State]) VALUES (1, N'Initiated')
INSERT [WFMP].[tblMovementState] ([Id], [State]) VALUES (2, N'Pending')
INSERT [WFMP].[tblMovementState] ([Id], [State]) VALUES (3, N'Declined')
INSERT [WFMP].[tblMovementState] ([Id], [State]) VALUES (4, N'Approved')
SET IDENTITY_INSERT [WFMP].[tblMovementState] OFF
SET IDENTITY_INSERT [WFMP].[tblMovementTypes] ON 

INSERT [WFMP].[tblMovementTypes] ([Id], [Type]) VALUES (1, N'Manager - Transfer Out')
INSERT [WFMP].[tblMovementTypes] ([Id], [Type]) VALUES (2, N'Manager - Transfer In')
INSERT [WFMP].[tblMovementTypes] ([Id], [Type]) VALUES (3, N'Department - Transfer Out')
INSERT [WFMP].[tblMovementTypes] ([Id], [Type]) VALUES (4, N'Department - Transfer In')
SET IDENTITY_INSERT [WFMP].[tblMovementTypes] OFF
INSERT [WFMP].[tblProfile] ([Employee_ID], [Date_of_Birth], [Gender], [Email_Personal], [Contact_Number], [AnniversaryDate], [HighestQualification], [Transport], [Address1], [Address2], [Landmark], [City], [Total_Work_Experience], [Skill1], [Skill2], [Skill3], [Alternate_Contact], [EmergencyContactPerson], [UserImage], [Updated_by], [Update_Date]) VALUES (931040, CAST(0x0000713600000000 AS DateTime), N'Male', N'parasparmar@gmail.com', 7738533134, CAST(0x0000948800000000 AS DateTime), N'', 1, N'B/407-8 Yogi Paradise CHS, Bldg 63-64 Yogi Eksar, New Link Rd, Yoginagar,', N'Borivli(W)', N'Opp Dutta Mandir', N'Mumbai', 16, N'C,DotNet,Programming Languages', N'JAVASCRIPT,JQUERY', N'Capacity Planning,Communication,Computer', 9967514545, N'Khyati Parmar', N'pparm001_0.jpg', N'pparm001', CAST(0x0000A7D90136A406 AS DateTime))
SET IDENTITY_INSERT [WFMP].[tblQry] ON 

INSERT [WFMP].[tblQry] ([TransID], [Qry], [Active]) VALUES (1, N'[WFMP].[CE]', 1)
SET IDENTITY_INSERT [WFMP].[tblQry] OFF
SET IDENTITY_INSERT [WFMP].[tblQualification] ON 

INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (1, N'BA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (2, N'BA   (Political Science)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (3, N'BCom')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (4, N'BCOM + GNIIT')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (5, N'BE')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (6, N'BE (Production)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (7, N'BE Computer Science')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (8, N'BSc')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (9, N'BSc (Chemistry)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (10, N'BSc (Physics)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (11, N'BTech')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (12, N'BTech in CSE')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (13, N'BTech in EEE')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (14, N'BA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (15, N'Bachelor in Computer Applications')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (16, N'Bachelor of Business Administration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (17, N'Bachelor of Commerce')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (18, N'Bachelor of Commerce(Pursuing)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (19, N'Bachelor of Engineering ( EEE )')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (20, N'Bachelor of Science')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (21, N'Bachelors in Computer Applications')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (22, N'bachelors In IT')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (23, N'Bachelors of Biotechnology')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (24, N'Bachelors Of Computer Applications')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (25, N'BAJM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (26, N'BBA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (27, N'BBA, Pursuing PGDIP in OM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (28, N'BBM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (29, N'BCA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (30, N'BCOM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (31, N'BE ELTL')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (32, N'BE Mechanical Production')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (33, N'BSC')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (34, N'BSc (CS)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (35, N'BSC Computer Science')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (36, N'Bsc in Maths')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (37, N'BSc Physics')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (38, N'BSC Statistics')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (39, N'B-Tec IT')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (40, N'Business Administration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (41, N'Bussines Administration (Ongoing)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (42, N'Bussiness Administration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (43, N'Capacity Planning')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (44, N'Communication and Periodism')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (45, N'Communication and Periodism( Student)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (46, N'Computer Science (Ongoing)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (47, N'Degree in Law School')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (48, N'Diploma Computer Engineering')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (49, N'Diploma in Computer Science')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (50, N'Diploma in computers')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (51, N'Diploma in Electronics & Telecomm')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (52, N'Diploma in HM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (53, N'Electronics & Communication Engineering')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (54, N'ENGINEERING')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (55, N'English Embassament')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (56, N'Graduate')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (57, N'Graduation')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (58, N'Graduation (B A)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (59, N'Graduation (B Com)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (60, N'Graduation (Bsc)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (61, N'Graduation B A English Literature')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (62, N'Graducation')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (63, N'Grauduate')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (64, N'H S C')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (65, N'Hardware Networking')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (66, N'High School')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (67, N'HSC')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (68, N'HSC passed, Ty appeared')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (69, N'Infomation Engineering (Ongoing)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (70, N'Intermediate')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (71, N'LLB Honors')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (72, N'Logistic')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (73, N'M A')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (74, N'M A in Philosophy')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (75, N'M Com')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (76, N'M SC')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (77, N'MA, MBA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (78, N'Master in Forecast & BTP')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (79, N'Master of Business Administration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (80, N'Master Of Business Adminstration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (81, N'Master of Computer Application')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (82, N'Master Of Computer Applications')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (83, N'Masters in System Administration')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (84, N'MBA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (85, N'MBA - Operations Management')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (86, N'MCA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (87, N'Mcom')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (88, N'Mech Engineer')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (89, N'MSC IT')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (90, N'Msc(IT)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (91, N'P G D M Finance')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (92, N'PG')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (93, N'PGDBA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (94, N'PGDBM (CRM)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (95, N'PGDBM (HR)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (96, N'PGDHRM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (97, N'PGDM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (98, N'PHD in Theatre & Arts')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (99, N'Post Graduate')
GO
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (100, N'Post Graduate Diploma in Business Management')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (101, N'Pursuing BCOM')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (102, N'Quality Analyst')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (103, N'S Y B Com')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (104, N'S Y BMS')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (105, N'Scheduling and Forecast Expert')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (106, N'System Development')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (107, N'System Engineer (Student)')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (108, N'T Y B Com')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (109, N'Tech-System Databases and Telecomunications')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (110, N'TY BSC')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (111, N'Ty bsc IT')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (112, N'TYBA')
INSERT [WFMP].[tblQualification] ([Id], [Qualification]) VALUES (113, N'Under Graduate')
SET IDENTITY_INSERT [WFMP].[tblQualification] OFF
SET IDENTITY_INSERT [WFMP].[tblRstWeeks] ON 

INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (1, 2016, 53, CAST(0xA6E90000 AS SmallDateTime), CAST(0xA6EF0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (2, 2017, 1, CAST(0xA6F00000 AS SmallDateTime), CAST(0xA6F60000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (3, 2017, 2, CAST(0xA6F70000 AS SmallDateTime), CAST(0xA6FD0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (4, 2017, 3, CAST(0xA6FE0000 AS SmallDateTime), CAST(0xA7040000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (5, 2017, 4, CAST(0xA7050000 AS SmallDateTime), CAST(0xA70B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (6, 2017, 5, CAST(0xA70C0000 AS SmallDateTime), CAST(0xA7120000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (7, 2017, 6, CAST(0xA7130000 AS SmallDateTime), CAST(0xA7190000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (8, 2017, 7, CAST(0xA71A0000 AS SmallDateTime), CAST(0xA7200000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (9, 2017, 8, CAST(0xA7210000 AS SmallDateTime), CAST(0xA7270000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (10, 2017, 9, CAST(0xA7280000 AS SmallDateTime), CAST(0xA72E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (11, 2017, 10, CAST(0xA72F0000 AS SmallDateTime), CAST(0xA7350000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (12, 2017, 11, CAST(0xA7360000 AS SmallDateTime), CAST(0xA73C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (13, 2017, 12, CAST(0xA73D0000 AS SmallDateTime), CAST(0xA7430000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (14, 2017, 13, CAST(0xA7440000 AS SmallDateTime), CAST(0xA74A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (15, 2017, 14, CAST(0xA74B0000 AS SmallDateTime), CAST(0xA7510000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (16, 2017, 15, CAST(0xA7520000 AS SmallDateTime), CAST(0xA7580000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (17, 2017, 16, CAST(0xA7590000 AS SmallDateTime), CAST(0xA75F0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (18, 2017, 17, CAST(0xA7600000 AS SmallDateTime), CAST(0xA7660000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (19, 2017, 18, CAST(0xA7670000 AS SmallDateTime), CAST(0xA76D0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (20, 2017, 19, CAST(0xA76E0000 AS SmallDateTime), CAST(0xA7740000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (21, 2017, 20, CAST(0xA7750000 AS SmallDateTime), CAST(0xA77B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (22, 2017, 21, CAST(0xA77C0000 AS SmallDateTime), CAST(0xA7820000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (23, 2017, 22, CAST(0xA7830000 AS SmallDateTime), CAST(0xA7890000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (24, 2017, 23, CAST(0xA78A0000 AS SmallDateTime), CAST(0xA7900000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (25, 2017, 24, CAST(0xA7910000 AS SmallDateTime), CAST(0xA7970000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (26, 2017, 25, CAST(0xA7980000 AS SmallDateTime), CAST(0xA79E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (27, 2017, 26, CAST(0xA79F0000 AS SmallDateTime), CAST(0xA7A50000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (28, 2017, 27, CAST(0xA7A60000 AS SmallDateTime), CAST(0xA7AC0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (29, 2017, 28, CAST(0xA7AD0000 AS SmallDateTime), CAST(0xA7B30000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (30, 2017, 29, CAST(0xA7B40000 AS SmallDateTime), CAST(0xA7BA0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (31, 2017, 30, CAST(0xA7BB0000 AS SmallDateTime), CAST(0xA7C10000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (32, 2017, 31, CAST(0xA7C20000 AS SmallDateTime), CAST(0xA7C80000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (33, 2017, 32, CAST(0xA7C90000 AS SmallDateTime), CAST(0xA7CF0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (34, 2017, 33, CAST(0xA7D00000 AS SmallDateTime), CAST(0xA7D60000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (35, 2017, 34, CAST(0xA7D70000 AS SmallDateTime), CAST(0xA7DD0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (36, 2017, 35, CAST(0xA7DE0000 AS SmallDateTime), CAST(0xA7E40000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (37, 2017, 36, CAST(0xA7E50000 AS SmallDateTime), CAST(0xA7EB0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (38, 2017, 37, CAST(0xA7EC0000 AS SmallDateTime), CAST(0xA7F20000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (39, 2017, 38, CAST(0xA7F30000 AS SmallDateTime), CAST(0xA7F90000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (40, 2017, 39, CAST(0xA7FA0000 AS SmallDateTime), CAST(0xA8000000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (41, 2017, 40, CAST(0xA8010000 AS SmallDateTime), CAST(0xA8070000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (42, 2017, 41, CAST(0xA8080000 AS SmallDateTime), CAST(0xA80E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (43, 2017, 42, CAST(0xA80F0000 AS SmallDateTime), CAST(0xA8150000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (44, 2017, 43, CAST(0xA8160000 AS SmallDateTime), CAST(0xA81C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (45, 2017, 44, CAST(0xA81D0000 AS SmallDateTime), CAST(0xA8230000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (46, 2017, 45, CAST(0xA8240000 AS SmallDateTime), CAST(0xA82A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (47, 2017, 46, CAST(0xA82B0000 AS SmallDateTime), CAST(0xA8310000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (48, 2017, 47, CAST(0xA8320000 AS SmallDateTime), CAST(0xA8380000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (49, 2017, 48, CAST(0xA8390000 AS SmallDateTime), CAST(0xA83F0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (50, 2017, 49, CAST(0xA8400000 AS SmallDateTime), CAST(0xA8460000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (51, 2017, 50, CAST(0xA8470000 AS SmallDateTime), CAST(0xA84D0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (52, 2017, 51, CAST(0xA84E0000 AS SmallDateTime), CAST(0xA8540000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (53, 2017, 52, CAST(0xA8550000 AS SmallDateTime), CAST(0xA85B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (54, 2018, 1, CAST(0xA85C0000 AS SmallDateTime), CAST(0xA8620000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (55, 2018, 2, CAST(0xA8630000 AS SmallDateTime), CAST(0xA8690000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (56, 2018, 3, CAST(0xA86A0000 AS SmallDateTime), CAST(0xA8700000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (57, 2018, 4, CAST(0xA8710000 AS SmallDateTime), CAST(0xA8770000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (58, 2018, 5, CAST(0xA8780000 AS SmallDateTime), CAST(0xA87E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (59, 2018, 6, CAST(0xA87F0000 AS SmallDateTime), CAST(0xA8850000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (60, 2018, 7, CAST(0xA8860000 AS SmallDateTime), CAST(0xA88C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (61, 2018, 8, CAST(0xA88D0000 AS SmallDateTime), CAST(0xA8930000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (62, 2018, 9, CAST(0xA8940000 AS SmallDateTime), CAST(0xA89A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (63, 2018, 10, CAST(0xA89B0000 AS SmallDateTime), CAST(0xA8A10000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (64, 2018, 11, CAST(0xA8A20000 AS SmallDateTime), CAST(0xA8A80000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (65, 2018, 12, CAST(0xA8A90000 AS SmallDateTime), CAST(0xA8AF0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (66, 2018, 13, CAST(0xA8B00000 AS SmallDateTime), CAST(0xA8B60000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (67, 2018, 14, CAST(0xA8B70000 AS SmallDateTime), CAST(0xA8BD0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (68, 2018, 15, CAST(0xA8BE0000 AS SmallDateTime), CAST(0xA8C40000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (69, 2018, 16, CAST(0xA8C50000 AS SmallDateTime), CAST(0xA8CB0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (70, 2018, 17, CAST(0xA8CC0000 AS SmallDateTime), CAST(0xA8D20000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (71, 2018, 18, CAST(0xA8D30000 AS SmallDateTime), CAST(0xA8D90000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (72, 2018, 19, CAST(0xA8DA0000 AS SmallDateTime), CAST(0xA8E00000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (73, 2018, 20, CAST(0xA8E10000 AS SmallDateTime), CAST(0xA8E70000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (74, 2018, 21, CAST(0xA8E80000 AS SmallDateTime), CAST(0xA8EE0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (75, 2018, 22, CAST(0xA8EF0000 AS SmallDateTime), CAST(0xA8F50000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (76, 2018, 23, CAST(0xA8F60000 AS SmallDateTime), CAST(0xA8FC0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (77, 2018, 24, CAST(0xA8FD0000 AS SmallDateTime), CAST(0xA9030000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (78, 2018, 25, CAST(0xA9040000 AS SmallDateTime), CAST(0xA90A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (79, 2018, 26, CAST(0xA90B0000 AS SmallDateTime), CAST(0xA9110000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (80, 2018, 27, CAST(0xA9120000 AS SmallDateTime), CAST(0xA9180000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (81, 2018, 28, CAST(0xA9190000 AS SmallDateTime), CAST(0xA91F0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (82, 2018, 29, CAST(0xA9200000 AS SmallDateTime), CAST(0xA9260000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (83, 2018, 30, CAST(0xA9270000 AS SmallDateTime), CAST(0xA92D0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (84, 2018, 31, CAST(0xA92E0000 AS SmallDateTime), CAST(0xA9340000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (85, 2018, 32, CAST(0xA9350000 AS SmallDateTime), CAST(0xA93B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (86, 2018, 33, CAST(0xA93C0000 AS SmallDateTime), CAST(0xA9420000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (87, 2018, 34, CAST(0xA9430000 AS SmallDateTime), CAST(0xA9490000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (88, 2018, 35, CAST(0xA94A0000 AS SmallDateTime), CAST(0xA9500000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (89, 2018, 36, CAST(0xA9510000 AS SmallDateTime), CAST(0xA9570000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (90, 2018, 37, CAST(0xA9580000 AS SmallDateTime), CAST(0xA95E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (91, 2018, 38, CAST(0xA95F0000 AS SmallDateTime), CAST(0xA9650000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (92, 2018, 39, CAST(0xA9660000 AS SmallDateTime), CAST(0xA96C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (93, 2018, 40, CAST(0xA96D0000 AS SmallDateTime), CAST(0xA9730000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (94, 2018, 41, CAST(0xA9740000 AS SmallDateTime), CAST(0xA97A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (95, 2018, 42, CAST(0xA97B0000 AS SmallDateTime), CAST(0xA9810000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (96, 2018, 43, CAST(0xA9820000 AS SmallDateTime), CAST(0xA9880000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (97, 2018, 44, CAST(0xA9890000 AS SmallDateTime), CAST(0xA98F0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (98, 2018, 45, CAST(0xA9900000 AS SmallDateTime), CAST(0xA9960000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (99, 2018, 46, CAST(0xA9970000 AS SmallDateTime), CAST(0xA99D0000 AS SmallDateTime))
GO
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (100, 2018, 47, CAST(0xA99E0000 AS SmallDateTime), CAST(0xA9A40000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (101, 2018, 48, CAST(0xA9A50000 AS SmallDateTime), CAST(0xA9AB0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (102, 2018, 49, CAST(0xA9AC0000 AS SmallDateTime), CAST(0xA9B20000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (103, 2018, 50, CAST(0xA9B30000 AS SmallDateTime), CAST(0xA9B90000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (104, 2018, 51, CAST(0xA9BA0000 AS SmallDateTime), CAST(0xA9C00000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (105, 2018, 52, CAST(0xA9C10000 AS SmallDateTime), CAST(0xA9C70000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (106, 2019, 1, CAST(0xA9C80000 AS SmallDateTime), CAST(0xA9CE0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (107, 2019, 2, CAST(0xA9CF0000 AS SmallDateTime), CAST(0xA9D50000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (108, 2019, 3, CAST(0xA9D60000 AS SmallDateTime), CAST(0xA9DC0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (109, 2019, 4, CAST(0xA9DD0000 AS SmallDateTime), CAST(0xA9E30000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (110, 2019, 5, CAST(0xA9E40000 AS SmallDateTime), CAST(0xA9EA0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (111, 2019, 6, CAST(0xA9EB0000 AS SmallDateTime), CAST(0xA9F10000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (112, 2019, 7, CAST(0xA9F20000 AS SmallDateTime), CAST(0xA9F80000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (113, 2019, 8, CAST(0xA9F90000 AS SmallDateTime), CAST(0xA9FF0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (114, 2019, 9, CAST(0xAA000000 AS SmallDateTime), CAST(0xAA060000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (115, 2019, 10, CAST(0xAA070000 AS SmallDateTime), CAST(0xAA0D0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (116, 2019, 11, CAST(0xAA0E0000 AS SmallDateTime), CAST(0xAA140000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (117, 2019, 12, CAST(0xAA150000 AS SmallDateTime), CAST(0xAA1B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (118, 2019, 13, CAST(0xAA1C0000 AS SmallDateTime), CAST(0xAA220000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (119, 2019, 14, CAST(0xAA230000 AS SmallDateTime), CAST(0xAA290000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (120, 2019, 15, CAST(0xAA2A0000 AS SmallDateTime), CAST(0xAA300000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (121, 2019, 16, CAST(0xAA310000 AS SmallDateTime), CAST(0xAA370000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (122, 2019, 17, CAST(0xAA380000 AS SmallDateTime), CAST(0xAA3E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (123, 2019, 18, CAST(0xAA3F0000 AS SmallDateTime), CAST(0xAA450000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (124, 2019, 19, CAST(0xAA460000 AS SmallDateTime), CAST(0xAA4C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (125, 2019, 20, CAST(0xAA4D0000 AS SmallDateTime), CAST(0xAA530000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (126, 2019, 21, CAST(0xAA540000 AS SmallDateTime), CAST(0xAA5A0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (127, 2019, 22, CAST(0xAA5B0000 AS SmallDateTime), CAST(0xAA610000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (128, 2019, 23, CAST(0xAA620000 AS SmallDateTime), CAST(0xAA680000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (129, 2019, 24, CAST(0xAA690000 AS SmallDateTime), CAST(0xAA6F0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (130, 2019, 25, CAST(0xAA700000 AS SmallDateTime), CAST(0xAA760000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (131, 2019, 26, CAST(0xAA770000 AS SmallDateTime), CAST(0xAA7D0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (132, 2019, 27, CAST(0xAA7E0000 AS SmallDateTime), CAST(0xAA840000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (133, 2019, 28, CAST(0xAA850000 AS SmallDateTime), CAST(0xAA8B0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (134, 2019, 29, CAST(0xAA8C0000 AS SmallDateTime), CAST(0xAA920000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (135, 2019, 30, CAST(0xAA930000 AS SmallDateTime), CAST(0xAA990000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (136, 2019, 31, CAST(0xAA9A0000 AS SmallDateTime), CAST(0xAAA00000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (137, 2019, 32, CAST(0xAAA10000 AS SmallDateTime), CAST(0xAAA70000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (138, 2019, 33, CAST(0xAAA80000 AS SmallDateTime), CAST(0xAAAE0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (139, 2019, 34, CAST(0xAAAF0000 AS SmallDateTime), CAST(0xAAB50000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (140, 2019, 35, CAST(0xAAB60000 AS SmallDateTime), CAST(0xAABC0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (141, 2019, 36, CAST(0xAABD0000 AS SmallDateTime), CAST(0xAAC30000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (142, 2019, 37, CAST(0xAAC40000 AS SmallDateTime), CAST(0xAACA0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (143, 2019, 38, CAST(0xAACB0000 AS SmallDateTime), CAST(0xAAD10000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (144, 2019, 39, CAST(0xAAD20000 AS SmallDateTime), CAST(0xAAD80000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (145, 2019, 40, CAST(0xAAD90000 AS SmallDateTime), CAST(0xAADF0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (146, 2019, 41, CAST(0xAAE00000 AS SmallDateTime), CAST(0xAAE60000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (147, 2019, 42, CAST(0xAAE70000 AS SmallDateTime), CAST(0xAAED0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (148, 2019, 43, CAST(0xAAEE0000 AS SmallDateTime), CAST(0xAAF40000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (149, 2019, 44, CAST(0xAAF50000 AS SmallDateTime), CAST(0xAAFB0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (150, 2019, 45, CAST(0xAAFC0000 AS SmallDateTime), CAST(0xAB020000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (151, 2019, 46, CAST(0xAB030000 AS SmallDateTime), CAST(0xAB090000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (152, 2019, 47, CAST(0xAB0A0000 AS SmallDateTime), CAST(0xAB100000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (153, 2019, 48, CAST(0xAB110000 AS SmallDateTime), CAST(0xAB170000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (154, 2019, 49, CAST(0xAB180000 AS SmallDateTime), CAST(0xAB1E0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (155, 2019, 50, CAST(0xAB1F0000 AS SmallDateTime), CAST(0xAB250000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (156, 2019, 51, CAST(0xAB260000 AS SmallDateTime), CAST(0xAB2C0000 AS SmallDateTime))
INSERT [WFMP].[tblRstWeeks] ([WeekId], [rYear], [rWeek], [FrDate], [ToDate]) VALUES (157, 2019, 52, CAST(0xAB2D0000 AS SmallDateTime), CAST(0xAB330000 AS SmallDateTime))
SET IDENTITY_INSERT [WFMP].[tblRstWeeks] OFF
SET IDENTITY_INSERT [WFMP].[tblShiftCode] ON 

INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (1, N'00:00-09:00', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (2, N'00:30-09:30', CAST(0x070034E230040000 AS Time), CAST(0x0700DCC9A04F0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (3, N'01:00-10:00', CAST(0x070068C461080000 AS Time), CAST(0x070010ACD1530000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (4, N'01:30-10:30', CAST(0x07009CA6920C0000 AS Time), CAST(0x0700448E02580000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (5, N'02:00-11:00', CAST(0x0700D088C3100000 AS Time), CAST(0x07007870335C0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (6, N'02:30-11:30', CAST(0x0700046BF4140000 AS Time), CAST(0x0700AC5264600000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (7, N'03:00-12:00', CAST(0x0700384D25190000 AS Time), CAST(0x0700E03495640000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (8, N'03:30-12:30', CAST(0x07006C2F561D0000 AS Time), CAST(0x07001417C6680000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (9, N'04:00-13:00', CAST(0x0700A01187210000 AS Time), CAST(0x070048F9F66C0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (10, N'04:30-13:30', CAST(0x0700D4F3B7250000 AS Time), CAST(0x07007CDB27710000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (11, N'05:00-14:00', CAST(0x070008D6E8290000 AS Time), CAST(0x0700B0BD58750000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (12, N'05:30-14:30', CAST(0x07003CB8192E0000 AS Time), CAST(0x0700E49F89790000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (13, N'06:00-15:00', CAST(0x0700709A4A320000 AS Time), CAST(0x07001882BA7D0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (14, N'06:30-15:30', CAST(0x0700A47C7B360000 AS Time), CAST(0x07004C64EB810000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (15, N'07:00-16:00', CAST(0x0700D85EAC3A0000 AS Time), CAST(0x070080461C860000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (16, N'07:30-16:30', CAST(0x07000C41DD3E0000 AS Time), CAST(0x0700B4284D8A0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (17, N'08:00-17:00', CAST(0x070040230E430000 AS Time), CAST(0x0700E80A7E8E0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (18, N'08:30-17:30', CAST(0x070074053F470000 AS Time), CAST(0x07001CEDAE920000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (19, N'09:00-18:00', CAST(0x0700A8E76F4B0000 AS Time), CAST(0x070050CFDF960000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (20, N'09:30-18:30', CAST(0x0700DCC9A04F0000 AS Time), CAST(0x070084B1109B0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (21, N'10:00-19:00', CAST(0x070010ACD1530000 AS Time), CAST(0x0700B893419F0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (22, N'10:30-19:30', CAST(0x0700448E02580000 AS Time), CAST(0x0700EC7572A30000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (23, N'11:00-20:00', CAST(0x07007870335C0000 AS Time), CAST(0x07002058A3A70000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (24, N'11:30-20:30', CAST(0x0700AC5264600000 AS Time), CAST(0x0700543AD4AB0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (25, N'12:00-21:00', CAST(0x0700E03495640000 AS Time), CAST(0x0700881C05B00000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (26, N'12:30-21:30', CAST(0x07001417C6680000 AS Time), CAST(0x0700BCFE35B40000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (27, N'13:00-22:00', CAST(0x070048F9F66C0000 AS Time), CAST(0x0700F0E066B80000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (28, N'13:30-22:30', CAST(0x07007CDB27710000 AS Time), CAST(0x070024C397BC0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (29, N'14:00-23:00', CAST(0x0700B0BD58750000 AS Time), CAST(0x070058A5C8C00000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (30, N'14:30-23:30', CAST(0x0700E49F89790000 AS Time), CAST(0x07008C87F9C40000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (31, N'15:00-00:00', CAST(0x07001882BA7D0000 AS Time), CAST(0x0700000000000000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (32, N'15:30-00:30', CAST(0x07004C64EB810000 AS Time), CAST(0x070034E230040000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (33, N'16:00-01:00', CAST(0x070080461C860000 AS Time), CAST(0x070068C461080000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (34, N'16:30-01:30', CAST(0x0700B4284D8A0000 AS Time), CAST(0x07009CA6920C0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (35, N'17:00-02:00', CAST(0x0700E80A7E8E0000 AS Time), CAST(0x0700D088C3100000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (36, N'17:30-02:30', CAST(0x07001CEDAE920000 AS Time), CAST(0x0700046BF4140000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (37, N'18:00-03:00', CAST(0x070050CFDF960000 AS Time), CAST(0x0700384D25190000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (38, N'18:30-03:30', CAST(0x070084B1109B0000 AS Time), CAST(0x07006C2F561D0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (39, N'19:00-04:00', CAST(0x0700B893419F0000 AS Time), CAST(0x0700A01187210000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (40, N'19:30-04:30', CAST(0x0700EC7572A30000 AS Time), CAST(0x0700D4F3B7250000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (41, N'20:00-05:00', CAST(0x07002058A3A70000 AS Time), CAST(0x070008D6E8290000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (42, N'20:30-05:30', CAST(0x0700543AD4AB0000 AS Time), CAST(0x07003CB8192E0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (43, N'21:00-06:00', CAST(0x0700881C05B00000 AS Time), CAST(0x0700709A4A320000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (44, N'21:30-06:30', CAST(0x0700BCFE35B40000 AS Time), CAST(0x0700A47C7B360000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (45, N'22:00-07:00', CAST(0x0700F0E066B80000 AS Time), CAST(0x0700D85EAC3A0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (46, N'22:30-07:30', CAST(0x070024C397BC0000 AS Time), CAST(0x07000C41DD3E0000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (47, N'23:00-08:00', CAST(0x070058A5C8C00000 AS Time), CAST(0x070040230E430000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (48, N'23:30-08:30', CAST(0x07008C87F9C40000 AS Time), CAST(0x070074053F470000 AS Time), 1, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (50, N'LEAVE', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 3, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (53, N'OOO', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 6, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (51, N'RES', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 4, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (52, N'RHR', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 5, 0, 1)
INSERT [WFMP].[tblShiftCode] ([ShiftID], [ShiftCode], [StartTime], [EndTime], [ShiftType], [Exception], [Active]) VALUES (49, N'WO', CAST(0x0700000000000000 AS Time), CAST(0x0700A8E76F4B0000 AS Time), 2, 0, 1)
SET IDENTITY_INSERT [WFMP].[tblShiftCode] OFF
SET IDENTITY_INSERT [WFMP].[tblSite] ON 

INSERT [WFMP].[tblSite] ([TransID], [Site], [Active]) VALUES (1, N'CWFM - UMANG', 1)
SET IDENTITY_INSERT [WFMP].[tblSite] OFF
SET IDENTITY_INSERT [WFMP].[tblSkills] ON 

INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (1, N'Access')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (2, N'Accounting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (3, N'Administration')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (4, N'Analysis')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (5, N'Analytics')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (6, N'ASP')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (7, N'Aspect')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (8, N'Automation')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (9, N'Avaya CMS')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (10, N'Back Office')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (11, N'Basic German Language')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (12, N'Blue Pumkin')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (13, N'BO')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (14, N'BP')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (15, N'BTP')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (16, N'Budget')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (17, N'Business Analytics')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (18, N'C')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (19, N'C++')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (20, N'Call Centre')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (21, N'Capacity Planning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (22, N'Capman')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (23, N'Client management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (24, N'CMS')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (25, N'Communication')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (26, N'Computer')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (27, N'Cooking')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (28, N'Coordination')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (29, N'CRA')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (30, N'Customer Service')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (31, N'Development')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (32, N'Dialler')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (33, N'DotNet')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (34, N'End to End Forecast')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (35, N'Excel')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (36, N'EXCEL Advanced')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (37, N'EXCEL Basic')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (38, N'EXCEL VBA')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (39, N'External Clients Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (40, N'Extra Innovation Activities for User Friendly Data Efficiency')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (41, N'Finance')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (42, N'Finance(Essbase)')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (43, N'Financial')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (44, N'Financial Reporting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (45, N'Forecast')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (46, N'Forecasting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (47, N'Forecasting & Planning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (48, N'Formation')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (49, N'GCC')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (50, N'GCC & Analytics')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (51, N'Genesys Platform')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (52, N'German Language')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (53, N'Hands On Expertise In Analytics')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (54, N'Hardware')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (55, N'IEX')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (56, N'Internal and external clients management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (57, N'Invoices')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (58, N'JAVASCRIPT')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (59, N'JQUERY')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (60, N'Kronos')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (61, N'Language')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (62, N'Languages')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (63, N'Layout')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (64, N'Leadership')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (65, N'LINUX')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (66, N'Logical Reasoning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (67, N'Macros & Formula')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (68, N'Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (69, N'Manpower Planning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (70, N'MCSC')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (71, N'MIS')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (72, N'MIS - Analyst')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (73, N'MIS - Operations')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (74, N'MIS - Reporting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (75, N'MIS & Reporting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (76, N'MIS Excel')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (77, N'MIS Reporting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (78, N'MS Access')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (79, N'MS Excel')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (80, N'MS Office')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (81, N'MS SQL')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (82, N'MSCS')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (83, N'NA')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (84, N'networking')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (85, N'Office')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (86, N'Operations')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (87, N'Ops Team Lead')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (88, N'Oracle')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (89, N'People Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (90, N'Planning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (91, N'Programming Languages')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (92, N'Project Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (93, N'Projects Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (94, N'Real Time')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (95, N'Real Time Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (96, N'Real time Reports')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (97, N'Recording Macro')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (98, N'Reporting')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (99, N'Reports')
GO
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (100, N'Resource Planning')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (101, N'Rostering')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (102, N'RTA')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (103, N'RTA Analyst')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (104, N'RTA)')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (105, N'Sales')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (106, N'SAP Knowlegde for Analysys')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (107, N'Scheduling')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (108, N'Scheduling & Rostering')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (109, N'Scheduling in Excel')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (110, N'Scheduling WFM Support')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (111, N'Seat Utilization')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (112, N'Sizing')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (113, N'Skill Development')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (114, N'Spanish')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (115, N'Spanish Language Expert')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (116, N'SQL')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (117, N'Staffing')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (118, N'Stakeholder Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (119, N'Strategy')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (120, N'Team Management')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (121, N'Technical Support')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (122, N'VB')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (123, N'VBA')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (124, N'VBA Automation')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (125, N'Visual Basic')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (126, N'WFC')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (127, N'WFM')
INSERT [WFMP].[tblSkills] ([Id], [Skill]) VALUES (128, N'Writing')
SET IDENTITY_INSERT [WFMP].[tblSkills] OFF
SET IDENTITY_INSERT [WFMP].[tblSkillSet] ON 

INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (1, N'Analytics', 1)
INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (3, N'Planning', 1)
INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (4, N'SkillSet1', 1)
INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (5, N'BHR1', 1)
INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (6, N'ED', 1)
SET IDENTITY_INSERT [WFMP].[tblSkillSet] OFF
SET IDENTITY_INSERT [WFMP].[tblSubSkillSet] ON 

INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (1, N'Analytics', 1)
INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (3, N'Planning', 1)
INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (4, N'SubSkillSet1', 1)
INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (7, N'BHR2', 1)
INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (8, N'ED', 1)
SET IDENTITY_INSERT [WFMP].[tblSubSkillSet] OFF
SET IDENTITY_INSERT [WFMP].[tblTrainingStatus] ON 

INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (1, N'New Hire Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (2, N'Cross Skill Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (3, N'On Job Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (4, N'On Floor', 1)
SET IDENTITY_INSERT [WFMP].[tblTrainingStatus] OFF
SET IDENTITY_INSERT [WFMP].[tbltrans_Movement] ON 

INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (1, NULL, NULL, 931040, 862590, 869805, 1, 1, 923563, CAST(0x0000A7EA00000000 AS DateTime), NULL, CAST(0x0000A7E500000000 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (10, NULL, NULL, 801071, 931040, 998838, 2, 0, 931040, CAST(0x0000A7ED00000000 AS DateTime), 931040, CAST(0x0000A7E90027A1A9 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (3, NULL, NULL, 931040, 862590, 845134, 1, 1, 931040, CAST(0x0000A7EA00000000 AS DateTime), 931040, CAST(0x0000A7E500000000 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (4, NULL, NULL, 931040, 862590, 868084, 1, 1, 931040, CAST(0x0000A7EA00000000 AS DateTime), 931040, CAST(0x0000A7E500000000 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (5, NULL, NULL, 931040, 801071, 993959, 2, 2, 931040, CAST(0x0000A7EC00000000 AS DateTime), 931040, CAST(0x0000A7E700000000 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (6, NULL, NULL, 931040, 801071, 993959, 2, 0, 931040, CAST(0x0000A7EC00000000 AS DateTime), 931040, CAST(0x0000A7E700000000 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (8, NULL, NULL, 931040, 801071, 844898, 1, 0, 931040, CAST(0x0000A7E600000000 AS DateTime), 931040, CAST(0x0000A7E90019C2E2 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (9, NULL, NULL, 801071, 931040, 932879, 2, 0, 931040, CAST(0x0000A7E600000000 AS DateTime), 931040, CAST(0x0000A7E9001BDFCD AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (11, NULL, NULL, 931040, 801071, 848992, 1, 0, 931040, CAST(0x0000A7E600000000 AS DateTime), 931040, CAST(0x0000A7EB018AEE8B AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (12, NULL, NULL, 931040, 801071, 845134, 1, 0, 931040, CAST(0x0000A7E600000000 AS DateTime), 931040, CAST(0x0000A7EB018B1E40 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (13, NULL, NULL, 923563, 0, 931040, 3, 0, 931040, CAST(0x0000A7E600000000 AS DateTime), 931040, CAST(0x0000A7EC014C26F3 AS DateTime))
INSERT [WFMP].[tbltrans_Movement] ([Id], [FromDptLinkMstId], [ToDptLinkMstId], [FromMgr], [ToMgr], [EmpId], [Type], [State], [InitBy], [EffectiveDate], [UpdaterID], [UpdatedOn]) VALUES (14, 0, 0, 825967, 0, 861880, 3, 0, 931040, CAST(0x0000A7ED00000000 AS DateTime), 931040, CAST(0x0000A7EC016F1174 AS DateTime))
SET IDENTITY_INSERT [WFMP].[tbltrans_Movement] OFF
ALTER TABLE [WFMP].[tblLeaveType] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [WFMP].[tblMaster] ADD  CONSTRAINT [DF_tblMaster_IsReportingManager]  DEFAULT ((0)) FOR [IsReportingManager]
GO
