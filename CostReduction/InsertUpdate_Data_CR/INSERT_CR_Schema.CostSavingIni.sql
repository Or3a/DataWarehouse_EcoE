INSERT INTO CR_Schema.CostSavingInitiative (CostSavingInitiativeID,InitiativeType,ImpactScaling,ImpactKind,ImpactDescription,EfficiencyIndicator,EfficiencyStrategy,EfficiencyMetric)
VALUES
  (100000,'process optimization','local','positive','sodales elit','cost savings','et risus. Quisque','13'),
  (100100,'process optimization','local','positive','Donec consectetuer','carbon footprint','leo.','55'),
  (100200,'process optimization','local','neutral','lacus. Cras interdum.','operational efficiency','tristique senectus',NULL),
  (100300,'energy efficiency','local','positive','amet luctus','cost savings','Ut','72'),
  (100400,'energy efficiency','local','neutral','Vivamus','carbon footprint','in, hendrerit',NULL),
  (100500,'energy efficiency','local','positive','dui lectus','operational efficiency','nec ante.','5'),
  (100600,'process optimization','regional','positive','aliquet. Phasellus','operational efficiency','dolor dapibus gravida.','55'),
  (100700,'process optimization','regional','positive','accumsan sed, facilisis vitae,','cost savings','tempor','32'),
  (100800,'process optimization','regional','neutral','varius ultrices, mauris','carbon footprint','quis, pede. Suspendisse',NULL),
  (100900,'energy efficiency','regional','positive','feugiat placerat','cost savings','nonummy. Fusce fermentum','51'),
  (101000,'energy efficiency','regional','positive','risus. Donec','operational efficiency','ac','32'),
  (101100,'energy efficiency','regional','neutral','lorem lorem,','cost savings','lobortis quam',NULL),
  (101200,'process optimization','global','neutral','eu','operational efficiency','orci, adipiscing', NULL),
  (101300,'process optimization','global','positive','nunc id','carbon footprint','molestie. Sed id','2'),
  (101400,'process optimization','global','neutral','urna justo faucibus lectus,','cost savings','accumsan',NULL),
  (101500,'energy efficiency','global','neutral','amet ultricies','carbon footprint','Curae Donec',NULL),
  (101600,'energy efficiency','global','neutral','at pede. Cras','operational efficiency','pede',NULL),
  (101700,'energy efficiency','global','negative','eget metus. In nec','cost savings','egestas hendrerit','23');



WITH RandomDates AS (
    SELECT
        CostSavingInitiativeID,
        timeid AS random_timeid,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        CR_Schema.CostSavingInitiative ,
        CR_Schema.time
    WHERE
        CostSavingInitiativeID IS NOT NULL
)
-- Update startdateid for each customer with a random timeid value
UPDATE CR_Schema.CostSavingInitiative  AS c
SET startdateid = rd.random_timeid
FROM RandomDates AS rd
WHERE c.CostSavingInitiativeID = rd.CostSavingInitiativeID;


UPDATE CR_Schema.CostSavingInitiative  AS c
SET enddateid = CASE
    WHEN random() < 0.5 THEN NULL -- Set approximately half of the enddateids to NULL
    ELSE (
        SELECT timeid
        FROM CR_Schema.time AS t
        WHERE t.date > (SELECT date FROM CR_Schema.time WHERE timeid = c.startdateid)
        ORDER BY random()
        LIMIT 1
    )
END
WHERE c.startdateid IS NOT NULL;


