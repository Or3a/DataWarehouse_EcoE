INSERT INTO EC_Schema.EnergySource (EnergySourceID,SourceType,IsRenewable,Capacity,Efficiency,Manufacturer,EmissionLevel)
VALUES
  (477975,'hydro',true,1914,46,'Nullam Vitae Corporation',NULL),
  (619428,'wind',true,1104,79,'In Tempus Associates',NULL),
  (770382,'hydro',true,3318,37,'Duis Sit Limited',NULL),
  (687947,'hydro',true,3744,2,'Eu Consulting',NULL),
  (581777,'solar',true,1971,97,'Neque Sed Dictum Industries',NULL),
  (724828,'hydro',true,2990,2,'Massa Quisque Corp.',NULL),
  (722808,'fossil fuels',false,742,58,'Duis Risus Corp.','moderate'),
  (487712,'hydro',true,654,41,'Laoreet Posuere Ltd',NULL),
  (535315,'hydro',true,1078,55,'Donec Corp.',NULL),
  (671912,'wind',true,2703,63,'Ut Semper Corp.',NULL),
  (830438,'wind',true,2576,67,'Nam Ac Industries',NULL),
  (564921,'wind',true,1648,9,'Sed Molestie LLC',NULL),
  (517650,'fossil fuels',false,1378,49,'Massa Quisque Porttitor Limited','moderate'),
  (647827,'solar',true,2726,92,'Tempor Foundation',NULL),
  (826182,'fossil fuels',false,1449,52,'Donec Non Incorporated','high');


WITH RandomLocations AS (
    SELECT
        e.EnergySourceID,
        em.LocationID AS random_LocationID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        EC_Schema.EnergySource AS e,
        EC_Schema.Location AS em
    WHERE
        e.EnergySourceID IS NOT NULL
)
-- Update LocationID for each EnergySource with a random LocationID value
UPDATE EC_Schema.EnergySource AS c
SET LocationID = rm.random_LocationID
FROM RandomLocations AS rm
WHERE c.EnergySourceID = rm.EnergySourceID;