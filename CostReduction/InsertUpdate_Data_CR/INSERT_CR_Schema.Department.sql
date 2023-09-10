INSERT INTO CR_Schema.Department (DepartmentID,DepartmentName,DepartmentManager)
VALUES
  ('666703','Interdum Libero LLC','Tana Schinacher'),
  ('415965','Aliquam Ultrices Iaculis LLC','Lucas Schmitt'),
  ('612926','Fermentum Risus Incorporated','Andrew Nowak'),
  ('972697','Luctus Foundation','Meredith Schwarz'),
  ('536384','Integer Id Industries','Deanna Boger'),
  ('790934','Faucibus Id PC','Diana Meier'),
  ('962834','Nisl Quisque Incorporated','Gil Pfarrer'),
  ('607573','Tempus Eu Ltd','Aurora Weber'),
  ('758738','Magnis Dis LLC','Adena Vogt'),
  ('655922','Velit Aliquam Limited','Sylvester Simon'),
  ('111208','Lorem Ipsum Incorporated','Zenia Wolf'),
  ('114576','Lorem Fringilla LLP','Germane Graf'),
  ('463240','Et Magnis Corporation','Zia Bachmann'),
  ('278151','Imperdiet Erat Limited','Wang Maler'),
  ('281562','Gravida Nunc Sed LLP','Bruce Fiedler'),
  ('505369','Ut Tincidunt LLP','Carlos Jansen'),
  ('516093','Cum Sociis Limited','Cairo Ruf'),
  ('654711','Tristique Senectus Foundation','Iola Becker'),
  ('249977','Lectus Nullam Incorporated','Yvonne Dreher'),
  ('247820','Quis Pede Suspendisse Associates','Emerald RoÃŸmann'),
  ('254814','Ullamcorper Eu Ltd','Boris JÃ¤ger'),
  ('164048','Euismod Ac Fermentum Corporation','Melvin Winter'),
  ('682635','Vel Mauris PC','Jackson SchÃ¤fer'),
  ('477141','Lorem Vitae Foundation','Dylan Fink'),
  ('446402','Cursus Vestibulum Inc.','Oscar Fischer'),
  ('516894','Amet Risus LLP','Summer Zimmermann'),
  ('569194','Egestas Rhoncus Foundation','Moana Meier'),
  ('133144','Pede Blandit Industries','Cheyenne Arnold'),
  ('544166','Nec Urna PC','Mariam Schulz'),
  ('718527','Cras Vulputate Limited','Nichole Seidel'),
  ('873935','Sem Limited','Michael Pfarrer'),
  ('577022','Quisque Ac Foundation','Caldwell Hausmann');

WITH RandomLocations AS (
    SELECT
        e.DepartmentID,
        l.LocationID AS random_LocationID,
        ROW_NUMBER() OVER (ORDER BY random()) AS rn
    FROM
        CR_Schema.Department AS e,
        CR_Schema.Location AS l
    WHERE
        e.DepartmentID IS NOT NULL
)
-- Update DepartmentLocationID for each Department with a random LocationID value
UPDATE CR_Schema.Department AS c
SET DepartmentLocationID = rm.random_LocationID
FROM RandomLocations AS rm
WHERE c.DepartmentID = rm.DepartmentID;