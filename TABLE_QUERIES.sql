-------------CREATE SCRIPT FOR STAGING TABLE---------------------
IF OBJECT_ID('dbo.TEMP_VACCINATION_DATA_STAGING', 'U') IS NOT NULL
DROP TABLE dbo.TEMP_VACCINATION_DATA_STAGING;

CREATE TABLE dbo.TEMP_VACCINATION_DATA_STAGING
(
	NAME VARCHAR(255),
	Cust_I VARCHAR(50) NOT NULL PRIMARY KEY,
	Open_Dt VARCHAR(8),
	Consul_Dt VARCHAR(8),
	VAC_ID VARCHAR(50),
	DR_Name VARCHAR(255),
	State VARCHAR(50),
	Country VARCHAR(50),
	DOB VARCHAR(8),
	FLAG  VARCHAR(1),
	load_dt datetime
);


--------------CREATE SCRIPT FOR ERROR TABLE------------------
IF OBJECT_ID('dbo.TEMP_VACCINATION_ERROR_DATA', 'U') IS NOT NULL
DROP TABLE dbo.TEMP_VACCINATION_ERROR_DATA;

CREATE TABLE dbo.TEMP_VACCINATION_ERROR_DATA
(
    Error_Output_Column varchar(max),
    ErrorCode int,
    ErrorColumn int
);


---------------CREATE SCRIPT FOR ERROR LOGS TABLE-------------

IF EXISTS(SELECT 1 FROM SYSOBJECTS WHERE ID=OBJECT_ID(N'Error_Logs') AND TYPE=(N'U'))
DROP TABLE Error_Logs
 go
 CREATE TABLE Error_Logs(ID INT IDENTITY,MACHINENAME VARCHAR(200),PACKAGENAME VARCHAR(200), TASKNAME VARCHAR(200),ERRORCODE INT,
 ERRORDESCRIPTION VARCHAR(MAX),DATE DATETIME);


---------------CREATE SCRIPT FOR COUNTRY TABLE IF IT DOESNOT EXIST---------

IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME='AU')

 CREATE TABLE  DBO.AU
(
	NAME VARCHAR(255),
	Cust_I VARCHAR(50) NOT NULL PRIMARY KEY,
	Open_Dt DATETIME,
	Consul_Dt DATETIME,
	VAC_ID VARCHAR(50),
	DR_Name VARCHAR(255),
	State VARCHAR(50),
	Country VARCHAR(50),
	DOB DATETIME,
	FLAG  VARCHAR(1),
	load_dt datetime
) ;

----------------INSERT DATA FROM STAGING TABLE TO THE COUNTRY TABLE-------------

INSERT INTO DBO.AU 
(
	NAME,Cust_I,Open_Dt,Consul_Dt,VAC_ID,DR_Name,State,Country,DOB,FLAG,load_dt
) 
 SELECT  NAME ,Cust_I ,CAST(Open_Dt AS DATETIME) Open_Dt  , CAST(Consul_Dt AS DATETIME) Consul_Dt ,
 VAC_ID ,DR_Name ,State,Country ,convert(date,SUBSTRING(DOB,1,2) + '-' + SUBSTRING(DOB,3,2) + '-' + SUBSTRING(DOB,5,4),105) DOB ,FLAG  ,load_dt 
 FROM DBO.TEMP_VACCINATION_DATA_STAGING WHERE COUNTRY= 'AU';



------------------------------**************************************************--------------------------