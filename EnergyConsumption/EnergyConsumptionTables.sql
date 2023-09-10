CREATE TABLE EC_Schema.DTime (
    DTimeID serial PRIMARY KEY,
    date_time timestamp without time zone NOT NULL,
    MinuteDT integer,
    HourDT integer,
    DayDT integer,
    WeekDT integer,
    MonthDT integer,
    QuarterDT integer,
    YearDT integer
);

CREATE TABLE EC_Schema.Location (
    LocationID serial PRIMARY KEY,
    RegionL varchar(50) NULL,
    StateL varchar(50) NULL,
    CountryL varchar(50) NOT NULL
);

CREATE TABLE EC_Schema.CustomerSegment (
    CustomerSegmentID serial PRIMARY KEY,
    SegmentType varchar(16) NOT NULL
);

CREATE TABLE EC_Schema.EnergySource (
    EnergySourceID serial PRIMARY KEY,
    SourceType varchar(16) NOT NULL,
    IsRenewable boolean NOT NULL,
    Capacity numeric,
    Efficiency numeric,
    Manufacturer varchar(100),
    EmissionLevel varchar(50),
    LocationID integer REFERENCES EC_Schema.Location(LocationID)
);

CREATE TABLE EC_Schema.EnergyUsage (
    EnergyUsageID serial PRIMARY KEY,
    UsageEnergy numeric,
    UsageCategory varchar(16) NOT NULL,
    Family varchar(16)
);

CREATE TABLE EC_Schema.MeterReading (
    MeterReadingID serial PRIMARY KEY,
    Reading numeric(5) NOT NULL,
    SerialNumber varchar(11) NOT NULL
);

CREATE TABLE EC_Schema.EnergyUsageMeterReading (
    EnUsageReadingID serial PRIMARY KEY,
    EnergyUsageID integer REFERENCES EC_Schema.EnergyUsage(EnergyUsageID),
    MeterReadingID integer REFERENCES EC_Schema.MeterReading(MeterReadingID)
);

CREATE TABLE EC_Schema.EnergyConsumption (
    EnergyConsumptionID serial PRIMARY KEY,
    CustomerSegmentID integer REFERENCES EC_Schema.CustomerSegment(CustomerSegmentID),
    LocationID integer REFERENCES EC_Schema.Location(LocationID),
    EnergySourceID integer REFERENCES EC_Schema.EnergySource(EnergySourceID),
    EnergyUsageID integer REFERENCES EC_Schema.EnergyUsage(EnergyUsageID),
    DTimeID integer REFERENCES EC_Schema.DTime(DTimeID),
    EnergyConsumption numeric NOT NULL,
    PeakDemand numeric NOT NULL,
    EnergyCost numeric NOT NULL
);