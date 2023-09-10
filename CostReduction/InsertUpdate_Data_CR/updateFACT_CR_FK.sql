-- Create a Common Table Expression (CTE) to generate random values for referencing columns
WITH RandomMethods AS (
    SELECT
        e.CostReductionID,
        em.TierID AS random_TierID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cr_schema.CostReduction AS e,
        cr_schema.Tier AS em
    WHERE
        e.CostReductionID IS NOT NULL
)
-- Update TierID for each CostReduction with a random TierID value
UPDATE cr_schema.CostReduction AS c
SET TierID = rm.random_TierID
FROM RandomMethods AS rm
WHERE c.CostReductionID = rm.CostReductionID;

----------------------------------------------------------------

WITH RandomMethods AS (
    SELECT
        e.CostReductionID,
        em.LocationID AS random_LocationID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cr_schema.CostReduction AS e,
        cr_schema.Location AS em
    WHERE
        e.CostReductionID IS NOT NULL
)
-- Update LocationID for each CostReduction with a random LocationID value
UPDATE cr_schema.CostReduction AS c
SET LocationID = rm.random_LocationID
FROM RandomMethods AS rm
WHERE c.CostReductionID = rm.CostReductionID;

----------------------------------------------------------------

WITH RandomMethods AS (
    SELECT
        e.CostReductionID,
        em.CostSavingInitiativeID AS random_CostSavingInitiativeID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cr_schema.CostReduction AS e,
        cr_schema.CostSavingInitiative AS em
    WHERE
        e.CostReductionID IS NOT NULL
)
-- Update InitiativeID for each CostReduction with a random CostSavingInitiativeID value
UPDATE cr_schema.CostReduction AS c
SET InitiativeID = rm.random_CostSavingInitiativeID
FROM RandomMethods AS rm
WHERE c.CostReductionID = rm.CostReductionID;

----------------------------------------------------------------

WITH RandomMethods AS (
    SELECT
        e.CostReductionID,
        em.TimeID AS random_TimeID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cr_schema.CostReduction AS e,
        cr_schema.Time AS em
    WHERE
        e.CostReductionID IS NOT NULL
)
-- Update TimeID for each CostReduction with a random TimeID value
UPDATE cr_schema.CostReduction AS c
SET TimeID = rm.random_TimeID
FROM RandomMethods AS rm
WHERE c.CostReductionID = rm.CostReductionID;

----------------------------------------------------------------

-- This query joins the "CostReduction" table with the "Department" and "Time" tables to update the DepartmentID for each unique combination of Location and Year.
-- In favor of using period-to-period comparison later.

WITH RandomMethods AS (
    SELECT DISTINCT ON (c.LocationID, t.Year)
        c.LocationID,
        t.Year,
        em.DepartmentID AS random_DepartmentID
    FROM
        cr_schema.CostReduction AS c
    JOIN
        cr_schema.Department AS em ON em.DepartmentID IS NOT NULL
    JOIN
        cr_schema.Time AS t ON t.TimeID = c.TimeID
    ORDER BY
        c.LocationID, t.Year, random()
)
-- Update DepartmentID for each CostReduction with a random DepartmentID value for each Location and Year combination
UPDATE cr_schema.CostReduction AS c
SET DepartmentID = rm.random_DepartmentID
FROM RandomMethods AS rm
WHERE c.LocationID = rm.LocationID AND c.TimeID IN (SELECT TimeID FROM cr_schema.Time WHERE Year = rm.Year);
