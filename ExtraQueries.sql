Informative queries

------ Energy Consuption Table ------

-- The total energy consumption, peak demand, and energy cost across different time granularities (hour, day, month) and customer segments

SELECT D.HourDT, D.DayDT, D.MonthDT, CS.SegmentType,
    SUM(EC.EnergyConsumption) AS TotalEnergyConsumption,
    SUM(EC.PeakDemand) AS TotalPeakDemand,
    SUM(EC.EnergyCost) AS TotalEnergyCost
FROM EC_Schema.EnergyConsumption EC
JOIN EC_Schema.DTime D ON EC.DTimeID = D.DTimeID
JOIN EC_Schema.CustomerSegment CS ON EC.CustomerSegmentID = CS.CustomerSegmentID
GROUP BY 
    CUBE (D.HourDT, D.DayDT, D.MonthDT, CS.SegmentType);

-- The average energy consumption and peak demand for renewable and non-renewable energy sources in different regions, broken down by heating and lighting usage categories

SELECT S.IsRenewable, L.RegionL, U.UsageCategory,
    AVG(EC.EnergyConsumption) AS AvgEnergyConsumption,
    AVG(EC.PeakDemand) AS AvgPeakDemand
FROM EC_Schema.EnergyConsumption EC
JOIN EC_Schema.EnergySource S ON EC.EnergySourceID = S.EnergySourceID
JOIN EC_Schema.Location L ON EC.LocationID = L.LocationID
JOIN EC_Schema.EnergyUsage U ON EC.EnergyUsageID = U.EnergyUsageID
WHERE U.UsageCategory IN ('heating', 'lighting')
GROUP BY 
    GROUPING SETS ((S.IsRenewable, L.RegionL, U.UsageCategory), (S.IsRenewable), (L.RegionL), (U.UsageCategory));

------ Cost Reduction Table ------

-- How can we analyze the cost reduction achievements by Initiative Type, City, and Department, while also calculating the total and subtotals for each level?

SELECT csi.InitiativeType, l.City, d.DepartmentName,
    SUM(cr.CostReductionAmt) AS TotalCostReduction
FROM CR_Schema.CostReduction cr
JOIN CR_Schema.CostSavingInitiative csi ON cr.InitiativeID = csi.CostSavingInitiativeID
JOIN CR_Schema.Location l ON cr.LocationID = l.LocationID
JOIN CR_Schema.Department d ON cr.DepartmentID = d.DepartmentID
GROUP BY
    GROUPING SETS ((csi.InitiativeType, l.City, d.DepartmentName), (csi.InitiativeType, l.City), (csi.InitiativeType), ())
ORDER BY
    csi.InitiativeType, l.City, d.DepartmentName;


--  Analyze the overall cost reduction achievements by Initiative Type and Region

SELECT csi.InitiativeType, l.City,
    SUM(cr.CostReductionAmt) AS TotalCostReduction
FROM CR_Schema.CostReduction cr
JOIN CR_Schema.CostSavingInitiative csi ON cr.InitiativeID = csi.CostSavingInitiativeID
JOIN CR_Schema.Location l ON cr.LocationID = l.LocationID
GROUP BY ROLLUP (csi.InitiativeType, l.City)
ORDER BY csi.InitiativeType, l.City;

------Customer Satisfaction Table ------

-- The trend in customer satisfaction levels over time, considering different customer segments and engagement channels

SELECT T.Year, T.Month, CS.CustomerSegmentID, CC.ChannelType,
    ROUND(AVG(CS.CustomerSatisfaction), 1) AS AvgSatisfaction
FROM CS_Schema.CustomerSatisfaction AS CS
JOIN CS_Schema.Time AS T ON CS.TimeID = T.TimeID
JOIN CS_Schema.CommunicationChannel AS CC ON CS.ChannelID = CC.ChannelID
GROUP BY ROLLUP (T.Year, T.Month, CS.CustomerSegmentID, CC.ChannelType)
ORDER BY T.Year, T.Month, CS.CustomerSegmentID, CC.ChannelType;
