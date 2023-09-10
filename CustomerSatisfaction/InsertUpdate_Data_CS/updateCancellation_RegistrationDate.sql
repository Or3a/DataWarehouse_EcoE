WITH RandomDates AS (
    SELECT
        customerid,
        timeid AS random_timeid,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        cs_schema.customer,
        cs_schema.time
    WHERE
        customerid IS NOT NULL
)
-- Update registrationdate for each customer with a random timeid value
UPDATE cs_schema.customer AS c
SET registrationdate = rd.random_timeid
FROM RandomDates AS rd
WHERE c.customerid = rd.customerid;


UPDATE cs_schema.customer AS c
SET cancellationdate = CASE
    WHEN random() < 0.5 THEN NULL -- Set approximately half of the cancellationdates to NULL
    ELSE (
        SELECT timeid
        FROM cs_schema.time AS t
        WHERE t.date > (SELECT date FROM cs_schema.time WHERE timeid = c.registrationdate)
        ORDER BY random()
        LIMIT 1
    )
END
WHERE c.registrationdate IS NOT NULL;

SELECT customertype, fullname, registrationdate, cancellationdate
	FROM cs_schema.customer
