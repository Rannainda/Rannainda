--Yêu cầu tìm ra những trường đại học nằm  ở thành phố có tỷ lệ tội phạm  thấp hơn 50% và có hạng star up lớn hơn hoặc bằng 75% và có ngành IT và ở khu vực là metropolian area.......--
With Crime_Percent AS (
SELECT[MSA], PERCENT_RANK() OVER (ORDER BY ISNULL([ViolentCrime],0)+ISNULL([Murder],0)+ISNULL([Rape],0)+ISNULL([Robbery],0)
+ISNULL([AggravatedAssault],0)+ISNULL([PropertyCrime],0)+ISNULL([Burglary],0)+ISNULL([Theft],0)+ISNULL([MotorVehicleTheft],0)) CrimePercent
,CASE [State]
  WHEN 'AL' THEN 'Alabama'
  WHEN 'AK' THEN 'Alaska'
  WHEN 'AZ' THEN 'Arizona'
  WHEN 'AR' THEN 'Arkansas'
  WHEN 'CA' THEN 'California'
  WHEN 'CO' THEN 'Colorado'
  WHEN 'CT' THEN 'Connecticut'
  WHEN 'DE' THEN 'Delaware'
  WHEN 'DC' THEN 'District of Columbia'
  WHEN 'FL' THEN 'Florida'
  WHEN 'GA' THEN 'Georgia'
  WHEN 'HI' THEN 'Hawaii'
  WHEN 'ID' THEN 'Idaho'
  WHEN 'IL' THEN 'Illinois'
  WHEN 'IN' THEN 'Indiana'
  WHEN 'IA' THEN 'Iowa'
  WHEN 'KS' THEN 'Kansas'
  WHEN 'KY' THEN 'Kentucky'
  WHEN 'LA' THEN 'Louisiana'
  WHEN 'ME' THEN 'Maine'
  WHEN 'MD' THEN 'Maryland'
  WHEN 'MA' THEN 'Massachusetts'
  WHEN 'MI' THEN 'Michigan'
  WHEN 'MN' THEN 'Minnesota'
  WHEN 'MS' THEN 'Mississippi'
  WHEN 'MO' THEN 'Missouri'
  WHEN 'MT' THEN 'Montana'
  WHEN 'NE' THEN 'Nebraska'
  WHEN 'NV' THEN 'Nevada'
  WHEN 'NH' THEN 'New Hampshire'
  WHEN 'NJ' THEN 'New Jersey'
  WHEN 'NM' THEN 'New Mexico'
  WHEN 'NY' THEN 'New York'
  WHEN 'NC' THEN 'North Carolina'
  WHEN 'ND' THEN 'North Dakota'
  WHEN 'OH' THEN 'Ohio'
  WHEN 'OK' THEN 'Oklahoma'
  WHEN 'OR' THEN 'Oregon'
  WHEN 'PA' THEN 'Pennsylvania'
  WHEN 'RI' THEN 'Rhode Island'
  WHEN 'SC' THEN 'South Carolina'
  WHEN 'SD' THEN 'South Dakota'
  WHEN 'TN' THEN 'Tennessee'
  WHEN 'TX' THEN 'Texas'
  WHEN 'UT' THEN 'Utah'
  WHEN 'VT' THEN 'Vermont'
  WHEN 'VA' THEN 'Virginia'
  WHEN 'WA' THEN 'Washington'
  WHEN 'WV' THEN 'West Virginia'
  WHEN 'WI' THEN 'Wisconsin'
  WHEN 'WY' THEN 'Wyoming'
END AS FullofState
,[State]
,ISNULL(City,LEFT(MSA, CHARINDEX(',', MSA) - 1)) [City]
FROM [dbo].[Crime]
WHERE MSA LIKE '%M.S.A%'  -- Chỗ này lọc có M.S.A vì MSA là metropolian area ạ
)
,Starup_Percent AS (
SELECT Metro_Area_Name,
[Metro_Area_Main_City] 
, Metro_Area_States
,PERCENT_RANK() OVER (ORDER BY [Startup_Rank] DESC) StarupPercent
FROM metro_startup_ranking
)
,PCIP11 AS (
Select  [INSTNM], PCIP11, LOCALE, CITY, [State]
from [dbo].[University_info_cleaned]
WHERE PCIP11 > 0
)
SELECT PCIP11.*
,ROUND(CrimePercent,2) CrimePercent
,ROUND(StarupPercent,2) StarupPercent
From PCIP11
LEFT JOIN Crime_Percent
ON PCIP11.CITY=Crime_Percent.City
AND PCIP11.State=Crime_Percent.[State]
INNER JOIN Starup_Percent
ON Starup_Percent.Metro_Area_Name LIKE CONCAT('%', Crime_Percent.City, '%')
AND Starup_Percent.Metro_Area_States = Crime_Percent.[FullofState]
WHERE CrimePercent < 0.5
AND StarupPercent >=0.75
AND PCIP11 > 0





