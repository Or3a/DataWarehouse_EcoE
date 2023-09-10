CREATE TABLE CR_Schema.Time (
    TimeID serial PRIMARY KEY,
    Date date NOT NULL,
    Month integer,
    Quarter integer,
    Year integer
);

CREATE TABLE CR_Schema.CostSavingInitiative (
    CostSavingInitiativeID serial PRIMARY KEY,
    InitiativeType varchar,
    ImpactScaling varchar,
    ImpactKind varchar,
    ImpactDescription text,
    EfficiencyIndicator varchar,
    EfficiencyStrategy text,
    EfficiencyMetric int,
    StartDateID integer REFERENCES CR_Schema.Time(TimeID),
    EndDateID integer REFERENCES CR_Schema.Time(TimeID)
);


CREATE TABLE CR_Schema.Location (
    LocationID serial PRIMARY KEY,
    City varchar,
    State varchar,
    Country varchar NULL
);

CREATE TABLE CR_Schema.Department (
    DepartmentID serial PRIMARY KEY,
    DepartmentName varchar,
    DepartmentManager varchar,
    DepartmentLocationID integer REFERENCES CR_Schema.Location(LocationID) NULL	
);

CREATE TABLE CR_Schema.Tier (
    TierID serial PRIMARY KEY,
    TierUsage text NOT NULL 
);

CREATE TABLE CR_Schema.CostReduction (
    CostReductionID serial PRIMARY KEY,
    InitiativeID integer REFERENCES CR_Schema.CostSavingInitiative(CostSavingInitiativeID),
    TimeID integer REFERENCES CR_Schema.Time(TimeID),
    TierID integer REFERENCES CR_Schema.Tier(TierID),
    LocationID integer REFERENCES CR_Schema.Location(LocationID),
    DepartmentID integer REFERENCES CR_Schema.Department(DepartmentID),
    CostReductionAmt numeric,
    ROIPercentage numeric,
    EnergyConsumptionReduct numeric
);