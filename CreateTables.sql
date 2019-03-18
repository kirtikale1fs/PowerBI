
/****************  CREATE TABLE SCRIPT **************/

	CREATE Table dbo.DimPatient
	(
	  ID int Identity(1,1) Not Null,
	  [Patient Number] [varchar](50) NULL,
	  [Patient Name] [varchar](50) NULL	
	)
	
	CREATE Table dbo.DimAgency
	(
	  ID int Identity(1,1) Not Null,	 
	  [AgencyName] [varchar](50) NULL	
	)
	
	CREATE Table dbo.Dim999status
	(
	  ID int Identity(1,1) Not Null,	 
	[999status] [varchar](50) NULL,
	[999RejectionReason] [varchar](5000) NULL	
	)
	
	CREATE Table dbo.Dim277Status
	(
	  ID int Identity(1,1) Not Null,	 
	[277Status] [varchar](50) NULL,
	[277RejectReason] [varchar](5000) NULL
	)
	

	CREATE TABLE dbo.FactClaim
	(
	 ID int Identity(1,1) Not Null,
	[AgencyId] int NULL,
	[TaxId] int NULL,
	[PatientId] int NULL,
	[VisitID] int NULL,
	[VisitDate] Date NULL,	
	[Schedule] [varchar](50) NULL,
	[InvoiceNumber] [varchar](50) NULL,	
	[ExternalInvoiceNumber] [varchar](50) NULL,
	[BilledDate] Date NULL,
	[BilledAmount] Decimal(6,2) NULL,
	[ClaimAmount][varchar](50) NULL,
	[EbillingBatchNumber] [varchar](50) NULL,
	[SubmissionDate] Date NULL,
	[999statusID] Int NULL,	
	[277StatusId] Int NULL,	
	[277SubmissionDate] Date NULL,
	[277ResponseDate] Date NULL,
	LoadDate Date Null 
	 )


/****************  INSERT INTO TABLE SCRIPT **************/


	 INSERT INTO dbo.DimPatient
	([Patient Number], [Patient Name] )
	SELECT distinct [Patient Number], [Patient Name] 
	FROM [dbo].[Stage_RawData]

	SELECT * FROM dbo.DimPatient


	INSERT INTO dbo.DimAgency
	([AgencyName] )
	SELECT distinct [Agency Name] 
	FROM [dbo].[Stage_RawData] Order by 1

	SELECT * FROM dbo.DimAgency

	INSERT INTO dbo.Dim999status
	([999status],[999RejectionReason] )
	SELECT distinct [999 status] , [999 Rejection Reason] 
	FROM [dbo].[Stage_RawData] WHERE [999 status] IS NOT NULL OR LEN (RTrim(Ltrim([999 status]))) >0

	SELECT * FROM dbo.Dim999status

	INSERT INTO dbo.Dim277Status
	([277Status],[277RejectReason] )
	SELECT distinct [277 Status] , [277 Reject Reason] 
	FROM [dbo].[Stage_RawData] WHERE [277 Status] IS NOT NULL OR LEN (RTrim(Ltrim([277 Status]))) >0



INSERT INTO dbo.FactClaim
(	
[AgencyId] 
,[TaxId] 
,[PatientId] 
,[VisitID]
,[VisitDate] 
,[Schedule]
,[InvoiceNumber] 
,[ExternalInvoiceNumber] 
,[BilledDate] 
,[BilledAmount] 
,[ClaimAmount] 
,[EbillingBatchNumber] 
,[SubmissionDate] 
,[999statusID] 
,[277StatusId] 
,[277SubmissionDate] 
,[277ResponseDate] 
,LoadDate 
)
	 
SELECT distinct
Agency.Id AS  [AgencyId] 
,Cast(stg.[Tax Id] AS int) As [TaxId]
,Patient.Id AS [PatientId] 
,stg.[VisitID] AS [VisitID]
,Cast(stg.[Visit Date] AS Date) AS [VisitDate]
,stg.[Schedule] 
,stg.[Invoice Number]  AS [InvoiceNumber]
,stg.[External Invoice Number]  AS [ExternalInvoiceNumber]
,Cast(stg.[Billed Date] as Date) AS [BilledDate]
,CAST(REPLACE (stg.[Billed Amount],'$','') as Decimal(6,2)) AS [BilledAmount]
,(REPLACE (stg.[Claim Amount],'$','')) AS [ClaimAmount]
,(stg.[Ebilling Batch Number] ) AS [EbillingBatchNumber]
,stg.[Submission Date] AS [SubmissionDate]
,D999status.Id AS [999statusID] 
,D277Status.Id AS [277StatusId] 
,stg.[277 Submission Date] AS [277SubmissionDate]
,stg.[277 Response Date] AS [277ResponseDate]
,Getdate() AS LoadDate 

FROM 
[dbo].[Stage_RawData] as stg
LEFT JOIN DimAgency as Agency
ON stg.[Agency Name] = Agency.[AgencyName]
LEFT JOIN DimPatient as Patient
ON stg.[Patient Number] = Patient.[Patient Number]
LEFT JOIN Dim999status as D999status
ON stg.[999 status] = D999status.[999status]		
LEFT JOIN Dim277Status as D277Status
ON stg.[277 Status] = D277Status.[277Status]

		