CREATE DATABASE FloodRiskDB;
/*===========================================================
Project: UK Flood Risk Analysis Database
Author: Tawakalt Lawal

Description:
Every year, thousands of properties across England are
flooded. The Environment Agency monitors rivers, issues
warnings and coordinates emergency responses — all
underpinned by data.

This project builds a relational database inspired by
that real-world framework. It covers six core areas:
flood risk regions, river monitoring stations, water
level readings, flood warnings, affected properties and
emergency response actions.

The goal was not just to design a database. It was to
use that database to answer real operational questions —
identifying high-risk regions, tracking rising water
levels, classifying flood impact and understanding where
emergency costs are concentrated across England.

Skills Demonstrated:
- Relational database design and modelling
- Primary keys, foreign keys and CHECK constraints
- Multi-table JOINs across six related tables
- Aggregate functions: SUM, COUNT, MAX, AVG
- Subqueries, CTEs and chained CTEs
- CASE statements for dynamic classification
- Window functions: RANK() and LAG()
- CROSS JOIN for national average comparisons
===========================================================*/

/*===========================================================
 TABLE 1: Regions
 Purpose:
 Stores flood management regions across England together with
 their region codes and flood risk classification.
===========================================================*/

CREATE TABLE Regions (
    RegionID        INT PRIMARY KEY,
    RegionName      VARCHAR(100) NOT NULL,
    RegionCode      VARCHAR(10) NOT NULL,
    HeadOffice      VARCHAR(100),
    RiskLevel       VARCHAR(20) CHECK (RiskLevel IN ('Low', 'Medium', 'High', 'Severe'))
);

INSERT INTO Regions VALUES
(1, 'North East',       'NE', 'Newcastle',    'High'),
(2, 'North West',       'NW', 'Manchester',   'High'),
(3, 'Yorkshire',        'YK', 'Leeds',        'Severe'),
(4, 'Midlands',         'ML', 'Birmingham',   'Medium'),
(5, 'East of England',  'EE', 'Cambridge',    'Medium'),
(6, 'London',           'LN', 'London',       'High'),
(7, 'South East',       'SE', 'Reading',      'Medium'),
(8, 'South West',       'SW', 'Bristol',      'High');


/*===========================================================
 TABLE 2: MonitoringStations
 Purpose:
 Stores monitoring stations used by the Environment Agency to
 measure river levels, rainfall, tidal activity and groundwater.
 Each station belongs to one region.
===========================================================*/


CREATE TABLE MonitoringStations (
    StationID       INT PRIMARY KEY,
    StationName     VARCHAR(100) NOT NULL,
    RegionID        INT FOREIGN KEY REFERENCES Regions(RegionID),
    RiverName       VARCHAR(100),
    Town            VARCHAR(100),
    StationType     VARCHAR(50) CHECK (StationType IN ('River Level', 'Rainfall', 'Tidal', 'Groundwater')),
    TypicalLowLevel DECIMAL(6,2),
    TypicalHighLevel DECIMAL(6,2),
    IsActive        BIT DEFAULT 1
);

INSERT INTO MonitoringStations VALUES
(1,  'York Skeldergate',      3, 'River Ouse',       'York',           'River Level',  0.50, 3.20, 1),
(2,  'Leeds Armley',          3, 'River Aire',        'Leeds',          'River Level',  0.80, 4.10, 1),
(3,  'Carlisle Eden Bridge',  1, 'River Eden',        'Carlisle',       'River Level',  0.60, 3.80, 1),
(4,  'Manchester Irwell',     2, 'River Irwell',      'Manchester',     'River Level',  0.40, 2.90, 1),
(5,  'Shrewsbury Welsh Br',   4, 'River Severn',      'Shrewsbury',     'River Level',  1.00, 5.20, 1),
(6,  'Tewkesbury Avon',       4, 'River Avon',        'Tewkesbury',     'River Level',  0.70, 4.60, 1),
(7,  'Oxford Osney',          7, 'River Thames',      'Oxford',         'River Level',  0.90, 3.70, 1),
(8,  'Lewes Hamsey',          7, 'River Ouse',        'Lewes',          'River Level',  0.30, 2.50, 1),
(9,  'Exeter Exe Bridge',     8, 'River Exe',         'Exeter',         'River Level',  0.50, 3.40, 1),
(10, 'Taunton Firepool',      8, 'River Tone',        'Taunton',        'River Level',  0.60, 4.20, 1),
(11, 'Cambridge River Cam',   5, 'River Cam',         'Cambridge',      'River Level',  0.20, 1.80, 1),
(12, 'London Teddington',     6, 'River Thames',      'London',         'Tidal',        1.10, 4.50, 1);


/*===========================================================
 TABLE 3: FloodWarnings
 Purpose:
 Stores flood warning records issued to the public.
 Each warning is linked to a monitoring station and region.
===========================================================*/

CREATE TABLE FloodWarnings (
    WarningID       INT PRIMARY KEY,
    StationID       INT FOREIGN KEY REFERENCES MonitoringStations(StationID),
    RegionID        INT FOREIGN KEY REFERENCES Regions(RegionID),
    WarningLevel    VARCHAR(30) CHECK (WarningLevel IN ('Flood Alert', 'Flood Warning', 'Severe Flood Warning', 'Warning Removed')),
    WarningDate     DATE NOT NULL,
    WarningTime     TIME NOT NULL,
    AffectedArea    VARCHAR(200),
    PropertiesAtRisk INT,
    WarningLiftedDate DATE,
    IsActive        BIT DEFAULT 1
);

INSERT INTO FloodWarnings VALUES
(1,  1,  3, 'Severe Flood Warning', '2024-01-05', '06:00', 'York City Centre and Riverside',          2400, '2024-01-08', 0),
(2,  2,  3, 'Flood Warning',        '2024-01-05', '08:00', 'Leeds Kirkstall and Armley',              1800, '2024-01-07', 0),
(3,  3,  1, 'Severe Flood Warning', '2024-02-10', '04:00', 'Carlisle City Centre',                    3200, '2024-02-14', 0),
(4,  5,  4, 'Flood Warning',        '2024-02-15', '10:00', 'Shrewsbury Town Centre',                  1500, '2024-02-17', 0),
(5,  6,  4, 'Severe Flood Warning', '2024-02-15', '12:00', 'Tewkesbury Town Centre',                  2800, '2024-02-20', 0),
(6,  9,  8, 'Flood Alert',          '2024-03-01', '09:00', 'Exeter Flood Plain Areas',                 800, '2024-03-02', 0),
(7,  10, 8, 'Flood Warning',        '2024-03-01', '11:00', 'Taunton Somerset Levels',                 2100, '2024-03-04', 0),
(8,  7,  7, 'Flood Alert',          '2024-11-20', '14:00', 'Oxford Meadows and Low Lying Areas',       600, '2024-11-21', 0),
(9,  12, 6, 'Flood Alert',          '2024-12-01', '08:00', 'London Tidal Thames Areas',               5000, NULL,         1),
(10, 4,  2, 'Flood Warning',        '2024-12-10', '07:00', 'Manchester Irwell Valley',                1200, NULL,         1),
(11, 1,  3, 'Flood Warning',        '2025-01-15', '05:00', 'York Skeldergate and Fulford',            1900, '2025-01-17', 0),
(12, 8,  7, 'Severe Flood Warning', '2025-02-01', '03:00', 'Lewes Town Centre and Cliffe',            2600, '2025-02-05', 0);


/*===========================================================
 TABLE 4: WaterLevelReadings
 Purpose:
 Stores water level measurements collected from monitoring
 stations over time.
===========================================================*/


CREATE TABLE WaterLevelReadings (
    ReadingID       INT PRIMARY KEY,
    StationID       INT FOREIGN KEY REFERENCES MonitoringStations(StationID),
    ReadingDate     DATE NOT NULL,
    ReadingTime     TIME NOT NULL,
    WaterLevelMetres DECIMAL(6,2) NOT NULL,
    RainfallMM      DECIMAL(6,2),
    IsFloodThreshold BIT DEFAULT 0
);

INSERT INTO WaterLevelReadings VALUES
(1,  1,  '2024-01-05', '00:00', 2.80, 45.2, 0),
(2,  1,  '2024-01-05', '06:00', 3.95, 52.1, 1),
(3,  1,  '2024-01-05', '12:00', 4.20, 38.6, 1),
(4,  1,  '2024-01-05', '18:00', 4.85, 29.3, 1),
(5,  1,  '2024-01-06', '00:00', 5.10, 18.7, 1),
(6,  1,  '2024-01-06', '12:00', 4.60, 10.2, 1),
(7,  2,  '2024-01-05', '06:00', 3.20, 48.5, 0),
(8,  2,  '2024-01-05', '12:00', 4.50, 41.2, 1),
(9,  3,  '2024-02-10', '04:00', 4.10, 62.3, 1),
(10, 3,  '2024-02-10', '12:00', 5.20, 55.8, 1),
(11, 5,  '2024-02-15', '10:00', 3.80, 38.9, 0),
(12, 5,  '2024-02-15', '18:00', 4.90, 42.1, 1),
(13, 6,  '2024-02-15', '12:00', 5.10, 58.4, 1),
(14, 9,  '2024-03-01', '09:00', 2.90, 28.6, 0),
(15, 10, '2024-03-01', '11:00', 3.60, 35.2, 0),
(16, 12, '2024-12-01', '08:00', 3.20, 15.4, 0),
(17, 4,  '2024-12-10', '07:00', 2.50, 42.8, 0),
(18, 1,  '2025-01-15', '05:00', 4.10, 49.6, 1),
(19, 8,  '2025-02-01', '03:00', 3.80, 71.2, 1),
(20, 8,  '2025-02-01', '12:00', 4.95, 65.3, 1);


/*===========================================================
 TABLE 5: PropertiesAffected
 Purpose:
 Records residential, commercial, industrial and agricultural
 properties impacted by flood events.
===========================================================*/


CREATE TABLE PropertiesAffected (
    PropertyID          INT PRIMARY KEY,
    WarningID           INT FOREIGN KEY REFERENCES FloodWarnings(WarningID),
    RegionID            INT FOREIGN KEY REFERENCES Regions(RegionID),
    PropertyType        VARCHAR(50) CHECK (PropertyType IN ('Residential', 'Commercial', 'Industrial', 'Agricultural')),
    PropertiesFlooded   INT NOT NULL,
    PropertiesEvacuated INT NOT NULL,
    EstimatedDamageGBP  DECIMAL(12,2),
    InsuranceClaimsMade INT,
    RecoveryCompletedDate DATE
);

INSERT INTO PropertiesAffected VALUES
(1,  1,  3, 'Residential',   1800, 950,  12500000.00, 1650, '2024-04-15'),
(2,  1,  3, 'Commercial',     420, 420,   8200000.00,  390, '2024-05-20'),
(3,  2,  3, 'Residential',   1200, 600,   7800000.00, 1100, '2024-03-28'),
(4,  3,  1, 'Residential',   2100, 1800, 18500000.00, 1950, '2024-06-10'),
(5,  3,  1, 'Commercial',     680, 680,  11200000.00,  620, '2024-07-05'),
(6,  5,  4, 'Residential',   2200, 1400, 16800000.00, 2050, '2024-08-20'),
(7,  5,  4, 'Agricultural',      0,   0,   4500000.00,  180, '2024-09-15'),
(8,  7,  8, 'Residential',   1600, 800,   9200000.00, 1480, '2024-06-01'),
(9,  12, 7, 'Residential',   1900, 1200, 14200000.00, 1750, '2025-05-10'),
(10, 12, 7, 'Commercial',     520, 520,   9800000.00,  480, '2025-06-15');


/*===========================================================
 TABLE 6: ResponseActions
 Purpose:
 Stores emergency response actions taken during flood events,
 including evacuations, road closures and temporary barriers.
===========================================================*/


CREATE TABLE ResponseActions (
    ActionID            INT PRIMARY KEY,
    WarningID           INT FOREIGN KEY REFERENCES FloodWarnings(WarningID),
    RegionID            INT FOREIGN KEY REFERENCES Regions(RegionID),
    ActionType          VARCHAR(100) CHECK (ActionType IN ('Temporary Flood Barriers', 'Evacuation', 'Pumping Operations', 'Emergency Shelter', 'Road Closure', 'River Dredging')),
    ActionDate          DATE NOT NULL,
    ResponsibleAgency   VARCHAR(100),
    StaffDeployed       INT,
    CostGBP             DECIMAL(10,2),
    ActionStatus        VARCHAR(20) CHECK (ActionStatus IN ('Planned', 'In Progress', 'Completed', 'Cancelled')),
    EffectivenessRating INT CHECK (EffectivenessRating BETWEEN 1 AND 5)
);

INSERT INTO ResponseActions VALUES
(1,  1,  3, 'Temporary Flood Barriers', '2024-01-05', 'Environment Agency',   85,  245000.00, 'Completed', 4),
(2,  1,  3, 'Evacuation',               '2024-01-05', 'North Yorkshire Fire', 120,   85000.00, 'Completed', 5),
(3,  1,  3, 'Emergency Shelter',        '2024-01-05', 'Red Cross',             45,   32000.00, 'Completed', 5),
(4,  2,  3, 'Pumping Operations',       '2024-01-05', 'Environment Agency',    60,  180000.00, 'Completed', 3),
(5,  3,  1, 'Temporary Flood Barriers', '2024-02-10', 'Environment Agency',   110,  320000.00, 'Completed', 3),
(6,  3,  1, 'Evacuation',               '2024-02-10', 'Cumbria Fire Service', 150,  120000.00, 'Completed', 4),
(7,  5,  4, 'Temporary Flood Barriers', '2024-02-15', 'Environment Agency',    75,  210000.00, 'Completed', 4),
(8,  5,  4, 'Road Closure',             '2024-02-15', 'Gloucestershire CC',    20,   15000.00, 'Completed', 5),
(9,  7,  8, 'Pumping Operations',       '2024-03-01', 'Environment Agency',    55,  165000.00, 'Completed', 4),
(10, 9,  6, 'Temporary Flood Barriers', '2024-12-01', 'Environment Agency',   200,  580000.00, 'In Progress', 3),
(11, 10, 2, 'Evacuation',               '2024-12-10', 'Greater Manchester FR', 90,   75000.00, 'In Progress', NULL),
(12, 12, 7, 'Temporary Flood Barriers', '2025-02-01', 'Environment Agency',    95,  275000.00, 'Completed', 2),
(13, 12, 7, 'Evacuation',               '2025-02-01', 'East Sussex Fire',     130,   95000.00, 'Completed', 4),
(14, 1,  3, 'River Dredging',           '2024-03-01', 'Environment Agency',    40,  420000.00, 'Completed', 3);



/*===========================================================
REPORTING QUERIES

Purpose:
These queries provide operational visibility — mapping
the monitoring network, identifying active warnings and
understanding the geographic distribution of flood risk
across England.
===========================================================*/

--  Q1/. Which monitoring stations are currently active and which flood management regions are they responsible for?

SELECT M.StationName,
       M.RiverName,
       M.Town,
       R.RegionName
FROM MonitoringStations M
INNER JOIN Regions R ON M.RegionID = R.RegionID ;

/*-----------------------------------------------------------
Q1. 
Insight:
The Environment Agency operates a national network of
monitoring stations across England. Before any flood risk
analysis can begin it is essential to understand where
each station is located, which river it monitors and which
regional team is responsible for it. This query provides
that operational map connecting every station to its
region, river and town.

Approach:
Join MonitoringStations and Regions tables on RegionID
Display station name, river name, town and region name

Technique: INNER JOIN
-----------------------------------------------------------*/

/*=========================================================
                ANALYTICAL QUERIES
-- These queries analyse flood risk patterns, identify
-- high-risk locations, and provide insights that support
-- flood management and decision-making.
=========================================================*/

-- Q2/.  Which locations have active Severe Flood Warnings and where are the most properties at risk?

SELECT  WarningID,
        RegionName,
        AffectedArea,
        PropertiesAtRisk,
        WarningDate
FROM FloodWarnings F
INNER JOIN Regions R ON F.RegionID = R.RegionID
WHERE WarningLevel = 'Severe Flood Warning'
ORDER BY PropertiesAtRisk DESC;

/*=========================================================
Q2. Identify Areas with Severe Flood Warnings

Insight:
Severe Flood Warnings represent the highest level of flood
danger in England. Identifying where they have been issued
and ranking them by properties at risk helps emergency
services prioritise resource deployment to the locations
where the human and financial cost is greatest.

Approach:
- Join FloodWarnings and Regions using RegionID
- Filter to Severe Flood Warnings only
- Sort by properties at risk descending

Technique: INNER JOIN, WHERE filter, ORDER BY DESC

Result:
Four Severe Flood Warnings identified.
- Carlisle City Centre (North East) — 3,200 properties
- Tewkesbury Town Centre (Midlands) — 2,800 properties
- Lewes Town Centre (South East) — 2,600 properties
- York City Centre (Yorkshire) — 2,400 properties

These locations represent the highest priority areas for
emergency response and flood mitigation investment.
=========================================================*/


-- Q3/. Which monitoring stations have triggered the most flood warnings
-- and what is the highest single event impact recorded at each station?

SELECT StationName,
COUNT(F.WarningID)           AS TotalWarnings,
MAX(PropertiesAtRisk)      AS HighestNumberOfRisk
FROM MonitoringStations M
INNER JOIN FloodWarnings F ON M.StationID = F.StationID
INNER JOIN PropertiesAffected P ON F.WarningID = P.WarningID
GROUP BY StationName
HAVING COUNT(F.WarningID) >= 1
ORDER BY TotalWarnings DESC;

/*=========================================================
Q3. Monitoring Stations by Warning Frequency and Peak Impact

Insight:
Repeated flood warnings may indicate recurring flood risk.
Four stations recorded the highest warning frequency with
2 warnings each: Carlisle Eden Bridge, Lewes Hamsey,
Tewkesbury Avon and York Skeldergate.

Carlisle Eden Bridge recorded the highest single-event
impact at 3,200 properties at risk. Comparing warning
frequency with peak impact helps identify locations that
may require greater monitoring and emergency planning.

Approach:
  Join MonitoringStations, FloodWarnings and
  PropertiesAffected tables
  COUNT total warnings issued per station
  MAX returns the highest properties at risk recorded
  in any single warning at that station
  Order by total warnings descending

Technique: Multi-table JOIN, COUNT, MAX, GROUP BY, ORDER BY

Result:
Four monitoring stations recorded the highest warning frequency with 2 warnings each: Carlisle Eden Bridge, 
Lewes Hamsey, Tewkesbury Avon and York Skeldergate.
Carlisle Eden Bridge recorded the highest single-event impact at 3,200 properties at risk.
Taunton Firepool and Leeds Armley recorded 1 warning each.
=========================================================*/


-- Q4/. Which flood warnings significantly exceeded the national average
-- for properties at risk and where were they located?

SELECT WarningID,
       RegionName,
       AffectedArea,
       PropertiesAtRisk
FROM FloodWarnings F
INNER JOIN Regions R ON F.RegionID = R.RegionID
WHERE PropertiesAtRisk > (SELECT AVG(PropertiesAtRisk) FROM FloodWarnings)
ORDER BY PropertiesAtRisk DESC;

/*=========================================================
Q4. Identify Flood Warnings Above the Average Properties at Risk

Insight:
The national average for properties at risk provides a
baseline for what a typical flood warning looks like
across England. Warnings that significantly exceed this
baseline represent outlier events that stretched emergency
capacity beyond normal operating levels. Identifying these
events supports post-incident review and helps calibrate
future resource planning for locations where standard
response protocols may be insufficient.

Approach:
- Join FloodWarnings and Regions tables using RegionID
- A subquery calculates the average PropertiesAtRisk
  across all warnings in the FloodWarnings table
- The outer query filters to return only warnings where
  PropertiesAtRisk exceeds that average
- Sort results by properties at risk descending

Technique: Subquery in WHERE clause, AVG, INNER JOIN

Result:
- Five flood warnings exceeded the national average
- London Tidal Thames Areas recorded the highest impact
  at 5,000 properties at risk
- Carlisle City Centre (3,200), Tewkesbury Town Centre
  (2,800), Lewes Town Centre (2,600) and York City Centre
  (2,400) followed
- These five locations represent the highest priority
  areas for additional monitoring and emergency resources
=========================================================*/

-- Q5/. Which regions have spent more than £500,000 on flood response
-- and where is emergency expenditure most concentrated?
WITH RegionResponseCost AS (
    SELECT R.RegionName,
           SUM(RA.CostGBP) AS TotalResponseCost
    FROM ResponseActions RA
    INNER JOIN Regions R ON RA.RegionID = R.RegionID
    GROUP BY R.RegionName
)
SELECT RegionName,
       TotalResponseCost
FROM RegionResponseCost
WHERE TotalResponseCost > 500000
ORDER BY TotalResponseCost DESC;

/*=========================================================
Q5. Calculate the total response cost by region
Insight:
Emergency flood response is expensive. Barriers,
evacuations, pumping operations and temporary shelters
all carry significant costs. Regions that consistently
spend above £500,000 on response are making the strongest
financial argument for preventative infrastructure
investment. Repeatedly spending on emergency response
without addressing the underlying flood risk is not
sustainable. This query identifies where that pattern
is most pronounced.

Approach:
- A CTE named RegionResponseCost joins ResponseActions
  to Regions and uses SUM to calculate total response
  costs per region
- The final SELECT filters the CTE result to return only
  regions where total cost exceeds £500,000
- Sort by total response cost descending

Technique: CTE, SUM, GROUP BY, WHERE filter on CTE result

Result:
- Two regions exceeded the £500,000 threshold
- Yorkshire recorded the highest response cost at £962,000
- London followed at £580,000
- Together they account for the majority of total emergency
  expenditure across England.
=========================================================*/

-- Q6/. How does the severity of each flood warning compare and which events qualify as High, Medium or Low Impact?
SELECT F.WarningID,
       R.RegionName,
       F.PropertiesAtRisk,
       CASE
           WHEN F.PropertiesAtRisk >= 3000 THEN 'High Impact'
           WHEN F.PropertiesAtRisk >= 1500 THEN 'Medium Impact'
           ELSE 'Low Impact'
       END AS ImpactCategory
FROM FloodWarnings F
INNER JOIN Regions R ON F.RegionID = R.RegionID
ORDER BY F.PropertiesAtRisk DESC;

/*=========================================================
Q6. Categorise Flood Warnings by Impact Level

Insight:
Official warning levels tell you the category of a flood
event but they do not always capture the full scale of
the impact. Two Severe Flood Warnings can be very
different in terms of the number of people affected.
Classifying each warning by properties at risk creates
a practical impact framework that emergency planners can
use to triage events, allocate resources proportionately
and ensure the most severe situations receive the most
intensive response.

Approach:
- Join FloodWarnings and Regions tables using RegionID
- A CASE statement evaluates PropertiesAtRisk for each
  warning and assigns an impact category:
  High Impact = 3,000 or more properties
  Medium Impact = 1,500 or more properties
  Low Impact = below 1,500 properties
- Sort results by properties at risk descending

Technique: CASE statement, INNER JOIN, ORDER BY

Result:
- 2 warnings classified as High Impact
- 7 warnings classified as Medium Impact
- 3 warnings classified as Low Impact
- London Tidal Thames Areas (5,000) and Carlisle City
  Centre (3,200) were the only High Impact locations
- This classification gives emergency planners an instant
  triage framework without needing to read individual
  warning records
  =========================================================*/

-- Q7/. Which monitoring stations have issued the most warnings nationally and how do they rank against each other?
SELECT M.StationName,
       R.RegionName,
       COUNT(F.WarningID) AS TotalWarnings,
       RANK() OVER (ORDER BY COUNT(F.WarningID) DESC) AS WarningRank
FROM MonitoringStations M
LEFT JOIN FloodWarnings F ON M.StationID = F.StationID
INNER JOIN Regions R ON M.RegionID = R.RegionID
GROUP BY M.StationName,
         R.RegionName;

/*=========================================================
Q7. Rank Monitoring Stations by Total Flood Warnings Issued

Insight:
Ranking all monitoring stations by warning frequency provides
a national comparison of flood activity. York Skeldergate ranked
1st with 2 warnings, while 10 stations recorded 1 warning each.
Cambridge River Cam recorded no warnings during the period analysed.

Approach:
- Join MonitoringStations, FloodWarnings and Regions tables
- COUNT calculates total warnings issued per station
- RANK() window function assigns a national rank to each
  station based on warning count, highest first
- Stations with equal warning counts receive the same rank
- Group by station name and region name

Technique: RANK() window function, COUNT, GROUP BY,
           INNER JOIN

Result:
- York Skeldergate ranked 1st with 2 warnings.
- 10 stations ranked 2nd with 1 warning each.
- Cambridge River Cam ranked 12th with 0 warnings.
  =========================================================*/


-- Q8/.Which regions carry the greatest cumulative flood burden and how do they classify by overall risk level?

SELECT R.RegionName,
       SUM(P.PropertiesFlooded) AS TotalPropertiesFlooded,
       SUM(P.EstimatedDamageGBP) AS TotalDamageCost,
       CASE
           WHEN SUM(P.PropertiesFlooded) >= 3000 THEN 'High Risk'
           WHEN SUM(P.PropertiesFlooded) >= 1000 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS RiskClassification
FROM PropertiesAffected P
INNER JOIN FloodWarnings F ON P.WarningID = F.WarningID
INNER JOIN Regions R ON F.RegionID = R.RegionID
GROUP BY R.RegionName
ORDER BY TotalPropertiesFlooded DESC;

/*=========================================================
Q8.Cumulative Flood Burden and Risk Classification by Region

Yorkshire recorded the highest number of properties flooded
at 3,420 and was the only region classified as High Risk.
However, the North East recorded the highest estimated
damage at £29.7 million, despite having fewer properties
flooded than Yorkshire.
This shows that the number of properties affected does not
always correspond to the highest financial impact.

Approach:
- Join PropertiesAffected, FloodWarnings and Regions tables
- SUM calculates total properties flooded and total
  estimated damage cost per region
- A CASE statement classifies each region:
  High Risk = 3,000 or more properties flooded
  Medium Risk = 1,000 or more properties flooded
  Low Risk = below 1,000 properties flooded
- Order by total properties flooded descending

Technique: CASE statement, SUM, GROUP BY,
           Multi-table JOIN, ORDER BY

Result:
 Yorkshire recorded the highest number of properties flooded
  at 3,420 and was the only High Risk region.
- North East recorded the highest estimated damage at £29.7m.
- South East and Midlands also recorded significant impacts.
- South West recorded the lowest number of properties flooded
  and the lowest estimated damage among the regions shown.
  =========================================================*/

-- Q9/.  How does each region's total flood impact compare against the national average and which regions are above or below it?

WITH RegionFlooded AS (
    SELECT R.RegionName,
           SUM(P.PropertiesFlooded) AS TotalFlooded
    FROM PropertiesAffected P
    INNER JOIN FloodWarnings F ON P.WarningID = F.WarningID
    INNER JOIN Regions R ON F.RegionID = R.RegionID
    GROUP BY R.RegionName
),
NationalAverage AS (
    SELECT AVG(TotalFlooded) AS AvgFlooded
    FROM RegionFlooded
)
SELECT RF.RegionName,
       RF.TotalFlooded,
       NA.AvgFlooded,
       CASE
           WHEN RF.TotalFlooded > NA.AvgFlooded THEN 'Above Average'
           ELSE 'Below Average'
       END AS FloodedStatus
FROM RegionFlooded RF
CROSS JOIN NationalAverage NA
ORDER BY RF.TotalFlooded DESC;


/*=========================================================
Q9. Calculate the total properties flooded per region and
identify which regions exceeded the national average.

Insight:
The average across the five regions with recorded affected properties was 2,484.
a baseline for comparing regional flood impact.
Yorkshire and the North East were above the national average,
while the South East, Midlands and South West were below it.
Yorkshire recorded the highest regional impact at 3,420
properties affected, exceeding the national average by 936.

Approach:
- First CTE, RegionFlooded, calculates total properties
  flooded per region by joining PropertiesAffected,
  FloodWarnings and Regions
- Second CTE, NationalAverage, calculates the average
  of those regional totals
- CROSS JOIN attaches the national average to every row
  so each region can be compared against it
- CASE statement classifies each region as Above Average
  or Below Average
- Order by total flooded properties descending

Technique: Two chained CTEs, CROSS JOIN, CASE statement,
           AVG, SUM, GROUP BY

Result:
- National average: 2,484 properties affected.
- Yorkshire and North East were above average.
- South East, Midlands and South West were below average.
- Yorkshire recorded the highest impact at 3,420 properties.
=========================================================*/


-- Q10/.Are water levels rising or falling at each monitoring station and by how much between consecutive readings?

SELECT M.StationName,
       W.ReadingDate,
       W.WaterLevelMetres AS CurrentLevel,
       LAG(W.WaterLevelMetres) OVER (PARTITION BY W.StationID
                                      ORDER BY W.ReadingDate, W.ReadingTime) AS PreviousLevel,
       W.WaterLevelMetres - LAG(W.WaterLevelMetres) OVER (PARTITION BY W.StationID
                                                           ORDER BY W.ReadingDate, W.ReadingTime) AS LevelChange
FROM WaterLevelReadings W
INNER JOIN MonitoringStations M ON W.StationID = M.StationID
ORDER BY M.StationName,
         W.ReadingDate,
         W.ReadingTime;

/*=========================================================
Q10. Compare water level readings over time at each station
to identify rising or falling water level trends.

Insight:
Water level readings show clear increases at several
monitoring stations.
York Skeldergate recorded the most detailed trend, rising
from 2.80 to a peak of 5.10 before falling to 4.10.
Carlisle Eden Bridge increased from 4.10 to 5.20,
the largest recorded increase of 1.10.
These rising water levels highlight stations where
continued monitoring may support early flood response.

Approach:
- Join WaterLevelReadings and MonitoringStations tables
- LAG() retrieves the previous water level reading for
  each station by looking back one row within each
  station's ordered sequence of readings
- PARTITION BY StationID ensures the comparison stays
  within the same station
- The difference between current and previous reading
  shows whether levels are rising, falling or stable
- Order by station name, reading date and reading time

Technique: LAG() window function, PARTITION BY,
           INNER JOIN, ORDER BY

Result:
- York Skeldergate reached a peak of 5.10m before falling
  to 4.60m and later recording 4.10m.
- Carlisle Eden Bridge rose from 4.10m to 5.20m,
  an increase of 1.10m.
- Leeds Armley, Lewes Hamsey and Shrewsbury Welsh Br
  also recorded rising water levels.
- NULL previous readings indicate that no earlier reading
  was available for comparison.
=========================================================*/

/*=========================================================
OVERALL ANALYSIS SUMMARY

Key Findings:
1. Yorkshire recorded the highest overall flood impact.
   It had the most properties affected (3,420), the highest
   response cost (£962,000) and was the only High Risk region.
   The North East recorded the highest estimated damage (£29.7m).

2. Several locations experienced repeated flood activity.
   York, Carlisle, Tewkesbury and Lewes recorded repeated
   warnings, while London recorded the highest single impact
   with 5,000 properties at risk.

3. Emergency response costs were concentrated.
   Yorkshire (£962,000) and London (£580,000) recorded the
   highest response costs and exceeded the £500,000 threshold.

4. Water levels increased at several monitoring stations.
   York Skeldergate reached 5.10 before falling to 4.10,
   while Carlisle Eden Bridge increased from 4.10 to 5.20.

5. Yorkshire and the North East exceeded the national average.
   The average was 2,484 properties affected. Yorkshire recorded
   3,420 and the North East recorded 2,780.

Recommendations:

- Prioritise flood resilience investment in Yorkshire and
  the North East.
- Review high regional emergency response costs.
- Expand monitoring at stations with repeated flood activity.
- Use historical data to support future flood-risk planning.
- Regularly review monitoring station performance.
=========================================================*/