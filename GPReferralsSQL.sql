USE [Database]
DROP TABLE IF EXISTS #TMP1
SELECT

[MonthStartDate] AS 'Month'
,event_type AS 'Event Type'

,CASE WHEN provider_org_id in ( 'RN7','RPA' ,'RWF','RVV') THEN 'KM Acute' 
WHEN provider_org_id = 'RYY' THEN 'KM Community' 
WHEN provider_org_id in ('NWF','NV336','NXM01','ADP','NT2','AVQ01','NTP','NN8','NT3') THEN 'KM IS'
WHEN provider_org_id in ('RP4','RJ1','RYJ','RP6','RPC','RAN','RRV') THEN 'Tertiary'
WHEN LEFT(provider_org_id,1) = 'R' THEN 'Other NHS'  ELSE 'Other IS' END AS 'Provider Type'

,CASE WHEN event_type = 'REFERRALS' THEN 'Normal Referral'  WHEN event_type = 'AG_REQUESTS' THEN 'Advice & Guidance Referral'  WHEN event_type = 'RAS_REQUESTS' THEN 'RAS Referral'END AS 'Referral Type'
,[FinancialYearString] AS 'FinancialYear'
,[WeekEndingSunday]
,specialty_desc
,clinic_type_desc
,PRO.name AS 'Provider Organisation Name'
,AC2.[Name] AS 'Referrer Comissioning Name'
,HCP_Name,RO.PCN_Name
,POP.[ALL] AS 'Pop'
,DATEADD(month, 1,[MonthStartDate]) AS 'Next Refresh'
,count (*) as [count]

INTO #TMP1 

FROM [Table] T 

LEFT JOIN [Table]  PRO ON PRO.Code = T.provider_org_id 
-- Join for commissioning name

LEFT JOIN [Table]  AC2  ON AC2.Code=T.[REFERRER_COMMISSIONER_CODE]

-- Join for hcp 
LEFT JOIN [Table]  RO ON RO.GP_Practice_Code = referring_org_id   AND ([ACTION_DT_TM] >= RO.Start_Date)  AND ([ACTION_DT_TM] < RO.End_Date)

-- Join for population 
LEFT JOIN [Table]  POP ON T.referring_org_id=POP.GP_Practice_Code 

--join to datedim
left join [Table]  dt on dt.[DateLong] = cast(T.[ACTION_DT_TM] as date)




WHERE event_type IN ('REFERRALS','AG_REQUESTS','RAS_REQUESTS')
and [MonthStartDate] >= '2019-04-01'

group by [MonthStartDate]

,event_type

,CASE WHEN provider_org_id in ( 'RN7','RPA' ,'RWF','RVV') THEN 'KM Acute' 
WHEN provider_org_id = 'RYY' THEN 'KM Community' 
WHEN provider_org_id in ('NWF','NV336','NXM01','ADP','NT2','AVQ01','NTP','NN8','NT3') THEN 'KM IS'
WHEN provider_org_id in ('RP4','RJ1','RYJ','RP6','RPC','RAN','RRV') THEN 'Tertiary'
WHEN LEFT(provider_org_id,1) = 'R' THEN 'Other NHS'  ELSE 'Other IS' END

,CASE WHEN event_type IN ('REFERRALS') THEN 'Normal Referral'  WHEN event_type IN ('AG_REQUESTS') THEN 'Advice & Guidance Referral'  WHEN event_type IN ('RAS_REQUESTS') THEN 'RAS Referral'END
,[FinancialYearString]
,[WeekEndingSunday]
,specialty_desc
,clinic_type_desc
,PRO.name
,AC2.[Name] 
,HCP_Name,RO.PCN_Name
,POP.[ALL]
,DATEADD(month, 1,[MonthStartDate]) 
------------------------------------------------------------------------------------------
SELECT

[FinancialYear] AS 'Financial Year'
,[Event Type] AS 'event_type'
,[Referral Type],[Month] AS 'month'
,specialty_desc,clinic_type_desc
,[Provider Organisation Name]
,[Provider Type]
,[Referrer Comissioning Name]
,HCP_Name,PCN_Name,[Next Refresh]
,SUM([Pop]) AS 'Pop'
,SUM([count]) AS 'Referral Count'

FROM #TMP1

GROUP BY [FinancialYear]
,[Event Type]
,[Referral Type]
,[Month]
,specialty_desc
,clinic_type_desc
,[Provider Organisation Name]
,[Provider Type]
,[Referrer Comissioning Name]
,HCP_Name,PCN_Name
,[Next Refresh]
