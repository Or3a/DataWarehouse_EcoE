CREATE TABLE CS_Schema.Time (
    TimeID serial PRIMARY KEY,
    Date date NOT NULL,
    Week integer NULL,
    Month integer,
    Year integer
);

CREATE TABLE CS_Schema.Customer (
    CustomerID serial PRIMARY KEY,
    CustomerType varchar,
    FullName varchar,
    Address text,
    RegistrationDate integer REFERENCES CS_Schema.Time(TimeID),
    CancellationDate integer REFERENCES CS_Schema.Time(TimeID)
);

CREATE TABLE CS_Schema.Location (
    LocationID serial PRIMARY KEY,
    City varchar,
    State varchar,
    Country varchar,
    PostalCode varchar NULL
);

CREATE TABLE CS_Schema.CommunicationChannel (
    ChannelID serial PRIMARY KEY,
    ChannelType varchar,
    OtherDescription text
);

CREATE TABLE CS_Schema.CustomerSegment (
    CustomerSegmentID serial PRIMARY KEY,
    Tier varchar,
    SubscriptionLevel varchar NULL
);

CREATE TABLE CS_Schema.EngMethod (
    MethodID serial PRIMARY KEY,
    MethodType varchar,
    SurveyContact varchar,
    SurveyExpResult varchar
);

CREATE TABLE CS_Schema.Engagement (
    EngagementID serial PRIMARY KEY,
    Organizer varchar,
    MethodID integer REFERENCES CS_Schema.EngMethod(MethodID)
);

CREATE TABLE CS_Schema.CustomerSatisfaction (
    CustomerSatisfactionID serial PRIMARY KEY,
    CustomerID integer REFERENCES CS_Schema.Customer(CustomerID),
    EngagementID integer REFERENCES CS_Schema.Engagement(EngagementID),
    TimeID integer REFERENCES CS_Schema.Time(TimeID),
    ChannelID integer REFERENCES CS_Schema.CommunicationChannel(ChannelID),
    CustomerSegmentID integer REFERENCES CS_Schema.CustomerSegment(CustomerSegmentID),
    LocationID integer REFERENCES CS_Schema.Location(LocationID),
    CustomerSatisfaction numeric,
    EngagementLevel numeric,
    EnergyConsumptionImpact numeric,
    CustomerRetention numeric
);