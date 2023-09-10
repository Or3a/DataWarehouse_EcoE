-- Create a Common Table Expression (CTE) to generate random values for referencing columns
WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.ChannelID AS random_ChannelID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.CommunicationChannel AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update ChannelID for each CustomerSatisfaction with a random ChannelID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET ChannelID = rm.random_ChannelID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;

WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.LocationID AS random_LocationID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.Location AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update LocationID for each CustomerSatisfaction with a random LocationID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET LocationID = rm.random_LocationID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;

WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.CustomerSegmentID AS random_CustomerSegmentID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.CustomerSegment AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update CustomerSegmentID for each CustomerSatisfaction with a random CustomerSegmentID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET CustomerSegmentID = rm.random_CustomerSegmentID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;

WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.TimeID AS random_TimeID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.Time AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update TimeID for each CustomerSatisfaction with a random TimeID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET TimeID = rm.random_TimeID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;

WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.EngagementID AS random_EngagementID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.Engagement AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update EngagementID for each CustomerSatisfaction with a random EngagementID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET EngagementID = rm.random_EngagementID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;


WITH RandomMethods AS (
    SELECT
        e.CustomerSatisfactionID,
        em.CustomerID AS random_CustomerID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.CustomerSatisfaction AS e,
        cs_schema.Customer AS em
    WHERE
        e.CustomerSatisfactionID IS NOT NULL
)
-- Update CustomerID for each CustomerSatisfaction with a random CustomerID value
UPDATE cs_schema.CustomerSatisfaction AS c
SET CustomerID = rm.random_CustomerID
FROM RandomMethods AS rm
WHERE c.CustomerSatisfactionID = rm.CustomerSatisfactionID;



-- Calculate EngagementLevel based on various factors

-- Update EngagementLevel for Customer Satisfaction records
UPDATE CS_Schema.CustomerSatisfaction AS cs
SET EngagementLevel = (
    SELECT 
        (
            CASE
                -- Consider the CustomerSegment for different engagement levels
                WHEN cseg.Tier = 'high usage' THEN 9.0
                WHEN cseg.Tier = 'medium usage' THEN 7.5
                WHEN cseg.Tier = 'low usage' THEN 6.0
                ELSE NULL
            END
            +
            CASE
                -- Consider the MethodType for different engagement levels
                WHEN em.MethodType = 'survey' THEN 2.0
                WHEN em.MethodType = 'workshop' THEN 1.0
                ELSE NULL
            END
        ) AS EngagementLevel
    FROM CS_Schema.Engagement AS e
    JOIN CS_Schema.EngMethod AS em ON e.MethodID = em.MethodID
    JOIN CS_Schema.CustomerSegment AS cseg ON cs.CustomerSegmentID = cseg.CustomerSegmentID
    WHERE e.EngagementID = cs.EngagementID
);

-- Fill remaining NULL values with a default value
UPDATE CS_Schema.CustomerSatisfaction
SET EngagementLevel = 5.0 WHERE EngagementLevel IS NULL;
