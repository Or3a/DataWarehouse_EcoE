-- one ranking query using NTILE,
RANK or DENSE RANK functions; 

-- 1. Ranking Query using NTILE:

-- Query: Retrieve the top 10% of energy consumption segments ranked by peak demand.


WITH EnergyConsumptionRank AS (
    SELECT E.EnergyConsumptionID, E.EnergyConsumption, E.PeakDemand,
        NTILE(10) OVER (ORDER BY E.PeakDemand DESC) AS PeakDemandRank
    FROM EC_Schema.EnergyConsumption E
)
SELECT ER.EnergyConsumptionID, ER.EnergyConsumption, ER.PeakDemand
FROM EnergyConsumptionRank ER
WHERE ER.PeakDemandRank = 1;


-- one windowing query using the windowing clause; 


WITH EnergyConsumptionByYear AS (
    SELECT L.RegionL AS Location,
        EXTRACT(YEAR FROM D.date_time) AS Year,
        SUM(E.EnergyConsumption) AS TotalConsumption,
        LAG(SUM(E.EnergyConsumption), 1) OVER (PARTITION BY L.RegionL ORDER BY EXTRACT(YEAR FROM D.date_time)) AS PreviousYearConsumption
    FROM EC_Schema.EnergyConsumption E
    JOIN EC_Schema.Location L ON E.LocationID = L.LocationID
    JOIN EC_Schema.DTime D ON E.DTimeID = D.DTimeID
    GROUP BY L.RegionL, EXTRACT(YEAR FROM D.date_time)
)
SELECT Location, Year, TotalConsumption, TotalConsumption - PreviousYearConsumption AS ConsumptionChange
FROM EnergyConsumptionByYear
ORDER BY Location, Year;


-- one period-to-period comparison query

WITH CurrentYearEnergy AS (
    SELECT l.City AS Location, d.DepartmentName,
        SUM(cr_current.EnergyConsumptionReduct::numeric) AS CurrentYearEnergyReduction
    FROM CR_Schema.CostReduction cr_current
    JOIN CR_Schema.Location l ON cr_current.LocationID = l.LocationID
    JOIN CR_Schema.Department d ON cr_current.DepartmentID = d.DepartmentID
    JOIN CR_Schema.Time t_current ON cr_current.TimeID = t_current.TimeID
    WHERE t_current.Year = 20 -- Change the year as needed
    GROUP BY l.City, d.DepartmentName
),
PreviousYearEnergy AS (
    SELECT l.City AS Location, d.DepartmentName,
        SUM(cr_previous.EnergyConsumptionReduct::numeric) AS PreviousYearEnergyReduction
    FROM CR_Schema.CostReduction cr_previous
    JOIN CR_Schema.Location l ON cr_previous.LocationID = l.LocationID
    JOIN CR_Schema.Department d ON cr_previous.DepartmentID = d.DepartmentID
    JOIN CR_Schema.Time t_previous ON cr_previous.TimeID = t_previous.TimeID
    WHERE t_previous.Year = 19 -- Change the year as needed
    GROUP BY l.City, d.DepartmentName
),
LocationDepartment AS (
    SELECT DISTINCT Location, DepartmentName
    FROM CurrentYearEnergy
)
SELECT ld.Location, ld.DepartmentName, cy.CurrentYearEnergyReduction, py.PreviousYearEnergyReduction
FROM LocationDepartment ld
LEFT JOIN
    CurrentYearEnergy cy ON ld.Location = cy.Location AND ld.DepartmentName = cy.DepartmentName
LEFT JOIN
    PreviousYearEnergy py ON ld.Location = py.Location AND ld.DepartmentName = py.DepartmentName;