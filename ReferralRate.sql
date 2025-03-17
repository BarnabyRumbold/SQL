DROP TABLE IF EXISTS #TMP1
DROP TABLE IF EXISTS #TMP2
SELECT TOP (10) SPCDate
,Organisation_Name AS 'ProviderName'
,EMCode
,TFC
,CASE
WHEN EMCode = 'EM10a' THEN 1
WHEN EMCode = 'EM10b' THEN 1
WHEN EMCode = 'EM8' THEN 1
WHEN EMCode = 'EM9' THEN 1
ELSE 0
END AS 'CompletedActivity'
,CASE 
WHEN EMCode = 'EM10a' THEN 'Day Case Spell'
WHEN EMCode = 'EM10b' THEN 'Inpatient Ordinary Spell'
WHEN EMCode = 'EM8' THEN 'First Outpatient Appointment'
WHEN EMCode = 'EM9' THEN 'Follow Up Outpatient Appointment' 
END AS 'CompletedActivityType'
,CONCAT(SPCDate, Organisation_Name, RIGHT(TFC, LEN(TFC) - 4)) AS ID
,Activity
FROM [Table] POD

-- Join for Provider Code
JOIN [Table] PRO
ON PRO.Organisation_Code = LEFT(POD.ProviderCode, 3)

WHERE 1=1 
AND LEFT(ProviderCode, 3) IN ('RVV', 'RWF', 'RPA', 'RN7')
AND Activity = 1
AND SPCDate >= '20230601'

--- Waitlist

SELECT TOP (1000) CAST(DATEADD(month, DATEDIFF(month, 0, CensusDate), 0) AS date) AS StartOfMonth
,Provider AS 'ProviderName'
,TreatmentFunctionTitle AS 'Specialty'

,1 AS 'WaitList'
,CONCAT(CAST(DATEADD(month, DATEDIFF(month, 0, CensusDate), 0) AS date), Provider, TreatmentFunctionTitle) AS 'ID'
FROM [Table]
WHERE 1=1 
AND WaitType = 'RTT'
AND CensusDate >= '20230601'

ORDER BY StartOfMonth DESC
