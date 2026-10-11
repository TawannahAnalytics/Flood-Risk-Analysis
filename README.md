# Flood-Risk-Analysis
A flood risk analysis database exploring regional flood impact, emergency response costs and water level trends across England
# 🌊 UK Flood Risk Analysis Database

**A SQL Server project analysing flood warnings, affected properties, water levels and emergency response costs across England.**

## 📌 Project Overview

Flooding can cause significant damage to homes, businesses and infrastructure. Understanding where flood events occur, how many properties are affected and how emergency resources are distributed can support better planning and decision-making.

This project uses Microsoft SQL Server to build a relational database and investigate flood risk across England. It explores regional flood impact, warning frequency, water-level changes and emergency response expenditure.

The project demonstrates how SQL can be used to transform structured data into meaningful findings and recommendations.


## 🎯 Project Objectives

- Identify locations with the highest number of properties at risk.
- Analyse flood warning frequency across monitoring stations.
- Classify flood warnings according to properties at risk.
- Compare regional property damage and estimated financial losses.
- Analyse emergency response expenditure across regions.
- Compare regional flood impact against the average.
- Track rising and falling water levels between consecutive readings.

## 🛠️ Tools and Technologies

- **Microsoft SQL Server** — database creation and querying.
- **SQL** — data analysis and reporting.
- **SQL Server Management Studio (SSMS)** — writing and executing queries.

## 🗄️ Database Structure

The database contains six related tables:
<img width="854" height="473" alt="image" src="https://github.com/user-attachments/assets/b57723f5-d194-498d-b847-63e9ad561207" />

| Table | Description |
|---|---|
| `Regions` | Stores flood management regions and their details. |
| `MonitoringStations` | Stores monitoring station locations and river information. |
| `FloodWarnings` | Records flood warnings, affected areas and properties at risk. |
| `WaterLevelReadings` | Stores water-level measurements over time. |
| `PropertiesAffected` | Records properties flooded, evacuations and estimated damage. |
| `ResponseActions` | Records emergency response activities, staffing and costs. |

Primary keys and foreign keys connect the tables and support analysis across related datasets.

## 💻 SQL Skills Demonstrated

| SQL Technique | Application |
|---|---|
| `INNER JOIN` and `LEFT JOIN` | Combining related tables and retaining unmatched records where required. |
| Aggregate functions | Calculating totals, counts, maximums and averages. |
| `GROUP BY` and `HAVING` | Summarising records and filtering grouped results. |
| `CASE` statements | Classifying flood warnings and regional risk. |
| Subqueries | Identifying warnings above the average number of properties at risk. |
| Common Table Expressions (CTEs) | Organising multi-step analytical queries. |
| `RANK()` | Ranking monitoring stations by warning frequency. |
| `LAG()` | Comparing consecutive water-level readings. |
| `CROSS JOIN` | Comparing regional results against a calculated average. |

## 🔎 Analytical Questions

The project uses SQL to investigate ten questions.

1. Which monitoring stations are active, and which regions do they belong to?
2. Which locations have severe flood warnings and the most properties at risk?
3. Which monitoring stations have the highest flood warning frequency?
4. Which flood warnings exceed the average number of properties at risk?
5. Which regions have spent more than £500,000 on emergency flood response?
6. How can flood warnings be classified by potential impact?
7. How do monitoring stations rank by warning frequency?
8. Which regions have the greatest number of properties flooded and the highest estimated damage?
9. How does regional flood impact compare against the average?
10. Are water levels rising or falling between consecutive readings?

## 📊 Key Findings

### 1. Yorkshire recorded the highest number of properties flooded

Yorkshire recorded **3,420 properties flooded**, the highest total among the five regions represented in the affected-properties data. It was the only region classified as High Risk under the project's classification rules.

### 2. The North East recorded the highest estimated damage

The North East recorded estimated damage of **£29.7 million**, compared with £28.5 million in Yorkshire. This shows that the region with the highest number of properties flooded does not necessarily have the highest estimated financial damage.

### 3. London recorded the highest single-warning impact

London Tidal Thames Areas recorded **5,000 properties at risk**, the highest figure among the flood warnings analysed.

### 4. Yorkshire recorded the highest emergency response costs

Yorkshire recorded **£962,000** in emergency response costs, followed by London at **£580,000**. Both regions exceeded the £500,000 threshold used in the analysis.

### 5. Regional flood impact varied

The average number of properties flooded across the five regions represented in the affected-properties data was **2,484**.

Yorkshire and the North East were above this average, while the South East, Midlands and South West were below it.
<img width="871" height="466" alt="image" src="https://github.com/user-attachments/assets/77f1b9b0-b9da-4635-b64f-940866e2c9c8" />


### 6. Water levels increased at several monitoring stations

York Skeldergate reached a recorded water level of **5.10 metres** before subsequent readings fell to 4.60 metres and 4.10 metres. Carlisle Eden Bridge increased from 4.10 metres to 5.20 metres between consecutive readings.
<img width="868" height="485" alt="image" src="https://github.com/user-attachments/assets/6192c7c5-e655-4003-b0a0-1165613f0105" />


These results demonstrate how SQL window functions can be used to track changes in water levels.

## 💡 Recommendations

Based on the analysis, the following actions could support further flood risk investigation and planning:

- **Prioritise flood resilience planning:** Investigate flood prevention needs in Yorkshire and the North East, where the number of properties flooded exceeded the five-region average.
- **Review emergency expenditure:** Examine the factors contributing to high response costs in Yorkshire and London.
- **Strengthen monitoring:** Review stations showing repeated warnings or significant increases in water levels.
- **Support future planning:** Use historical records to investigate flood patterns and inform resilience planning.
- **Review data coverage:** Regularly assess monitoring station activity and identify gaps in available information.

These recommendations are based on the illustrative dataset and should not be interpreted as official flood management advice.

## 🎓 What I Learned

- **SQL Server:** Designed a relational database using six connected tables, primary keys and foreign keys.
- **SQL Analysis:** Used JOINs, CTEs, subqueries and window functions to analyse flood warnings, property damage and water-level trends.
- **Data Accuracy:** Discovered how table joins can duplicate records and inflate counts, reinforcing the importance of validating query results.
- **Flood Risk:** Found that the region with the most properties flooded does not necessarily have the highest estimated financial damage.
- **Data Interpretation:** Learned to correct unsupported conclusions and turn SQL results into clear, evidence-based recommendations.

## 📁 Project Structure

```text
UK-Flood-Risk-Analysis/
│
├── README.md
├── FloodRiskAnalysis.sql
└── Images/
    ├── database_structure.png
    ├── regional_flood_impact.png
    └── water_level_analysis.png
```


## 🚀 How to Run the Project

1. Install Microsoft SQL Server and SQL Server Management Studio.
2. Clone or download this repository.
3. Open `FloodRiskAnalysis.sql` in SSMS.
4. Execute the script to create the database, tables and sample records.
5. Run the analytical queries to explore the results.

**Note:** Note: Before running the script, review the database creation statement and ensure the SQL statements are executed in the correct order.

## 👤 Author

**Tawakalt Lawal**
