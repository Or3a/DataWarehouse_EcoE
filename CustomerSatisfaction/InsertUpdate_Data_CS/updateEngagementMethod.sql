WITH RandomMethods AS (
    SELECT
        e.EngagementID,
        em.MethodID AS random_MethodID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.Engagement AS e,
        cs_schema.EngMethod AS em
    WHERE
        e.EngagementID IS NOT NULL
)
-- Update MethodID for each Engagement with a random MethodID value
UPDATE cs_schema.Engagement AS c
SET MethodID = rm.random_MethodID
FROM RandomMethods AS rm
WHERE c.EngagementID = rm.EngagementID;