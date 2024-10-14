-- Portfolios Table
CREATE TABLE Portfolios (
    PortNumber VARCHAR(20) PRIMARY KEY,
    PortName VARCHAR(40),
    PortNotes VARCHAR(200)
);

-- Accounts Table
CREATE TABLE Accounts (
    AccNumber VARCHAR(40) PRIMARY KEY,
    PortNumber VARCHAR(20) NOT NULL REFERENCES Portfolios(PortNumber),
    AccName VARCHAR(100),
    AccGroup VARCHAR(40),
    AccStatus CHAR(1),
    ExpiringAccNumber VARCHAR(40),
    CedantName VARCHAR(40),  -- Assuming CedantName is defined per account
    Currency CHAR(3),
    AccUserDef1 VARCHAR(100),
    AccUserDef2 VARCHAR(100),
    AccUserDef3 VARCHAR(100),
    AccUserDef4 VARCHAR(100),
    AccUserDef5 VARCHAR(100),
    AccParticipation FLOAT DEFAULT 1.0,
    CONSTRAINT acc_participation_check CHECK (AccParticipation >= 0.0 AND AccParticipation <= 1.0)
);


-- FlexiAcc Table
CREATE TABLE FlexiAcc (
    AccNumber VARCHAR(40) NOT NULL REFERENCES Accounts(AccNumber),
    ModifierName VARCHAR(40), -- Using ModifierName to store the flexible field name (like "ZZZ")
    ModifierValue VARCHAR(40), -- Stores the flexible field's value
    PRIMARY KEY (AccNumber, ModifierName)
);


-- AccountFinancials Table
CREATE TABLE AccountFinancials (
    AccountFinancialsID SERIAL PRIMARY KEY, -- Added a surrogate key
    AccNumber VARCHAR(40) NOT NULL REFERENCES Accounts(AccNumber),
    PerilCode VARCHAR(250) NOT NULL,
    DedCode SMALLINT,  -- Using SMALLINT for codes
    DedType SMALLINT,
    DeductibleValue FLOAT,
    MinDeductibleValue FLOAT,
    MaxDeductibleValue FLOAT,
    LimitCode SMALLINT,
    LimitType SMALLINT,
    LimitValue FLOAT, 
    CONSTRAINT deductible_value_check CHECK (DeductibleValue >= 0.0),
    CONSTRAINT mindeductible_value_check CHECK (MinDeductibleValue >= 0.0),
    CONSTRAINT maxdeductible_value_check CHECK (MaxDeductibleValue >= 0.0),
    CONSTRAINT limit_value_check CHECK (LimitValue >= 0.0),
    UNIQUE (AccNumber, PerilCode, DedCode, DedType, LimitCode, LimitType) -- Added unique constraint
);


-- Producers Table
CREATE TABLE Producers (
    ProducerName VARCHAR(40) PRIMARY KEY  -- Assuming ProducerName is unique
);

-- LOB Table
CREATE TABLE LOB (
    LOB VARCHAR(20) PRIMARY KEY   -- Assuming Line of Business is unique
);



-- Policies Table
CREATE TABLE Policies (
    PolNumber VARCHAR(20) PRIMARY KEY,
    AccNumber VARCHAR(40) NOT NULL REFERENCES Accounts(AccNumber),
    PolStatus CHAR(1),
    InceptionDate DATE,  -- Use DATE for dates
    ExpiryDate DATE,
    ProducerName VARCHAR(40) REFERENCES Producers(ProducerName),  -- FK to Producers table
    Underwriter VARCHAR(40),
    BranchName VARCHAR(20),
    LOB VARCHAR(20) REFERENCES LOB(LOB),  -- FK to LOB table
    ExpiringPolNumber VARCHAR(20),
    PerilsCovered VARCHAR(250),
    GrossPremium FLOAT,
    Tax FLOAT,
    Brokerage FLOAT,
    NetPremium FLOAT,
    LayerNumber INT DEFAULT 1,
    LayerParticipation FLOAT DEFAULT 1,
    LayerLimitValue FLOAT,  -- Renamed Limit to LimitValue
    LayerAttachmentPoint FLOAT,
    HoursClause INT,
    PolUserDef1 VARCHAR(100),
    PolUserDef2 VARCHAR(100),
    PolUserDef3 VARCHAR(100),
    PolUserDef4 VARCHAR(100),
    PolUserDef5 VARCHAR(100),
    CONSTRAINT layer_number_check CHECK (LayerNumber >= 1),
    CONSTRAINT layer_participation_check CHECK (LayerParticipation >= 0.0 AND LayerParticipation <= 1.0),
    CONSTRAINT layer_limit_check CHECK (LayerLimitValue >= 0.0),
    CONSTRAINT layer_attachment_check CHECK (LayerAttachmentPoint >= 0.0),
    CONSTRAINT gross_premium_check CHECK (GrossPremium >= 0.0),
    CONSTRAINT tax_check CHECK (Tax >= 0.0),
    CONSTRAINT brokerage_check CHECK (Brokerage >= 0.0),
    CONSTRAINT net_premium_check CHECK (NetPremium >= 0.0),
    CONSTRAINT hours_clause_check CHECK (HoursClause >= 0)
);




-- FlexiPol Table
CREATE TABLE FlexiPol (
    PolNumber VARCHAR(20) NOT NULL REFERENCES Policies(PolNumber),
    ModifierName VARCHAR(40),
    ModifierValue VARCHAR(40),
    PRIMARY KEY (PolNumber, ModifierName) 
);



-- PolicyFinancials Table
CREATE TABLE PolicyFinancials (
    PolicyFinancialsID SERIAL PRIMARY KEY,  -- Surrogate Key
    PolNumber VARCHAR(20) NOT NULL REFERENCES Policies(PolNumber),
    PerilCode VARCHAR(250) NOT NULL,
    DedCode SMALLINT,
    DedType SMALLINT,
    DeductibleValue FLOAT,
    MinDeductibleValue FLOAT,
    MaxDeductibleValue FLOAT,
    LimitCode SMALLINT,
    LimitType SMALLINT,
    LimitValue FLOAT,
    CONSTRAINT policy_deductible_value_check CHECK (DeductibleValue >= 0.0),
    CONSTRAINT policy_mindeductible_value_check CHECK (MinDeductibleValue >= 0.0),
    CONSTRAINT policy_maxdeductible_value_check CHECK (MaxDeductibleValue >= 0.0),
    CONSTRAINT policy_limit_value_check CHECK (LimitValue >= 0.0),
    UNIQUE (PolNumber, PerilCode, DedCode, DedType, LimitCode, LimitType) -- Added unique constraint

);





-- StepFunctions Table
CREATE TABLE StepFunctions (
    StepFunctionID SERIAL PRIMARY KEY,  -- Surrogate Key
    StepFunctionName VARCHAR(30),   -- Assuming StepFunctionName is unique within a PolNumber
    PolNumber VARCHAR(20) NOT NULL REFERENCES Policies(PolNumber),
    PerilCode VARCHAR(250) NOT NULL,
    StepTriggerType SMALLINT,  -- Using SMALLINT for code types
    UNIQUE (PolNumber, PerilCode, StepFunctionName, StepTriggerType)
);

-- Steps Table
CREATE TABLE Steps (
    StepID SERIAL PRIMARY KEY, -- Surrogate Key
    StepFunctionID INT NOT NULL REFERENCES StepFunctions(StepFunctionID),
    StepNumber SMALLINT NOT NULL,
    PayoutType SMALLINT,
    TriggerType SMALLINT,
    TriggerStart FLOAT,
    TriggerEnd FLOAT,
    DeductibleValue FLOAT,
    PayoutStart FLOAT,
    PayoutEnd FLOAT,
    PayoutLimitValue FLOAT,  -- Renamed Limit to LimitValue
    ExtraExpenseFactor FLOAT,
    ExtraExpenseLimitValue FLOAT,
    DebrisRemovalFactor FLOAT,
    MinTIV FLOAT,
    ScaleFactor FLOAT DEFAULT 1,
    IsLimitAtDamage SMALLINT,
    CONSTRAINT step_number_check CHECK (StepNumber BETWEEN 1 AND 10),
    CONSTRAINT trigger_start_check CHECK (TriggerStart >= 0.0),
    CONSTRAINT trigger_end_check CHECK (TriggerEnd >= 0.0),
    CONSTRAINT deductible_check CHECK (DeductibleValue >= 0.0),
    CONSTRAINT payout_start_check CHECK (PayoutStart >= 0.0),
    CONSTRAINT payout_end_check CHECK (PayoutEnd >= 0.0),
    CONSTRAINT payout_limit_check CHECK (PayoutLimitValue >= 0.0),
    CONSTRAINT extra_expense_factor_check CHECK (ExtraExpenseFactor >= 0.0),
    CONSTRAINT extra_expense_limit_check CHECK (ExtraExpenseLimitValue >= 0.0),
    CONSTRAINT debris_removal_factor_check CHECK (DebrisRemovalFactor >= 0.0),
    CONSTRAINT min_tiv_check CHECK (MinTIV >= 0.0),
    CONSTRAINT scale_factor_check CHECK (ScaleFactor >= 0.0),
    CONSTRAINT is_limit_at_damage_check CHECK (IsLimitAtDamage BETWEEN 0 AND 1),
    UNIQUE(StepFunctionID, StepNumber) -- Enforces uniqueness of step numbers within a step function
);


-- Conditions Table
CREATE TABLE Conditions (
    CondNumber VARCHAR(20) PRIMARY KEY,
    AccNumber VARCHAR(40) NOT NULL REFERENCES Accounts(AccNumber), -- FK to Accounts
    CondName VARCHAR(40),
    Currency CHAR(3),  -- Added currency to Conditions table
    CondClass SMALLINT,
    CONSTRAINT condition_class_check CHECK (CondClass BETWEEN 0 AND 1)

);


-- ConditionFinancials Table
CREATE TABLE ConditionFinancials (
    ConditionFinancialsID SERIAL PRIMARY KEY, -- Surrogate key
    CondNumber VARCHAR(20) NOT NULL REFERENCES Conditions(CondNumber), -- FK to Conditions
    PerilCode VARCHAR(250) NOT NULL,
    DedCode SMALLINT,
    DedType SMALLINT,
    DeductibleValue FLOAT,
    MinDeductibleValue FLOAT,
    MaxDeductibleValue FLOAT,
    LimitCode SMALLINT,
    LimitType SMALLINT,
    LimitValue FLOAT, -- Renamed to LimitValue
     CONSTRAINT cond_deductible_value_check CHECK (DeductibleValue >= 0.0),
    CONSTRAINT cond_mindeductible_value_check CHECK (MinDeductibleValue >= 0.0),
    CONSTRAINT cond_maxdeductible_value_check CHECK (MaxDeductibleValue >= 0.0),
    CONSTRAINT cond_limit_value_check CHECK (LimitValue >= 0.0),
    UNIQUE (CondNumber, PerilCode, DedCode, DedType, LimitCode, LimitType) -- Added unique constraint

);


-- LocationCondition Table (renamed from LocCond to avoid keyword conflict)
CREATE TABLE LocationCondition (
    LocationConditionID SERIAL PRIMARY KEY,  -- Surrogate key
    LocNumber VARCHAR(20) NOT NULL,  -- FK to Locations (defined below)
    CondNumber VARCHAR(20) NOT NULL REFERENCES Conditions(CondNumber),  -- FK to Conditions
    CondPriority INT,
    CONSTRAINT cond_priority_check CHECK (CondPriority >= 1)
);


CREATE TABLE Locations (
    LocNumber VARCHAR(20) PRIMARY KEY,
    AccNumber VARCHAR(40) NOT NULL REFERENCES Accounts(AccNumber), -- FK to accounts table
    LocName VARCHAR(20),
    LocGroup VARCHAR(20),
    CorrelationGroup INT,
    IsPrimary SMALLINT DEFAULT 1,
    IsTenant SMALLINT DEFAULT 0,
    BuildingID VARCHAR(20),
    InceptionDate DATE,   -- Use DATE type
    ExpiryDate DATE,
    PercentComplete DECIMAL, -- Use DECIMAL if precision is important, otherwise float8
    CompletionDate DATE,
    CountryCode CHAR(2), -- Country codes are usually char(2)
    Latitude NUMERIC,
    Longitude NUMERIC,
    StreetAddress VARCHAR(100),
    PostalCode VARCHAR(20),
    City VARCHAR(50),
    AreaCode VARCHAR(20),
    AreaName VARCHAR(50),
    AddressMatch SMALLINT,
    GeocodeQuality FLOAT,
    Geocoder VARCHAR(20),
    OrgOccupancyScheme VARCHAR(10),
    OrgOccupancyCode VARCHAR(100),
    OrgConstructionScheme VARCHAR(10),
    OrgConstructionCode VARCHAR(100),
    OccupancyCode INT DEFAULT 1000, -- Use INT, assuming these are integer codes
    ConstructionCode INT DEFAULT 5000,
    YearBuilt SMALLINT,  -- Year built can be stored as a smallint
    NumberOfStoreys SMALLINT,  -- Using SMALLINT to allow negative values
    NumberOfBuildings INT,
    FloorArea FLOAT,     -- Using FLOAT, or use DECIMAL if more precision is needed.
    FloorAreaUnit SMALLINT,
    LocUserDef1 VARCHAR(100),
    LocUserDef2 VARCHAR(100),
    LocUserDef3 VARCHAR(100),
    LocUserDef4 VARCHAR(100),
    LocUserDef5 VARCHAR(100),
    PerilsCovered VARCHAR(250),
    BuildingTIV FLOAT,
    OtherTIV FLOAT,
    ContentsTIV FLOAT,
    BITIV FLOAT,
    BIPOI FLOAT DEFAULT 365,
    Currency CHAR(3),
    GrossPremium FLOAT,
    Tax FLOAT,
    Brokerage FLOAT,
    NetPremium FLOAT,
    NonCatGroundUpLoss FLOAT,
    LocParticipation FLOAT DEFAULT 1.0,
    PayoutBasis SMALLINT DEFAULT 0,
    ReinsTag VARCHAR(20),
    IsAggregate SMALLINT DEFAULT 0,
    OccupantPeriod SMALLINT DEFAULT 0,
    SoilType SMALLINT DEFAULT 0,
    SoilValue FLOAT DEFAULT 0,
    LocPopNumber VARCHAR(20),
    NumberOfOccupants INT DEFAULT 0,
    OccupantUnderfive INT DEFAULT 0,
    OccupantOver65 INT DEFAULT 0,
    OccupantAge5to65 INT DEFAULT 0,
    OccupantFemale INT DEFAULT 0,
    OccupantMale INT DEFAULT 0,
    OccupantOther INT DEFAULT 0,
    OccupantUrban INT DEFAULT 0,
    OccupantRural INT DEFAULT 0,
    OccupantPoverty INT DEFAULT 0,
    OccupantRefugee INT DEFAULT 0,
    OccupantUnemployed INT DEFAULT 0,
    OccupantDisability INT DEFAULT 0,
    OccupantEthnicMinority INT DEFAULT 0,
    OccupantTemporary INT DEFAULT 0,
    OffshoreWaterDepth FLOAT,
    SectionLength FLOAT,
    PowerCapacity FLOAT,
    VulnerabilitySetID INT,
    BuildingFloodVulnerability SMALLINT,
    BIFloodVulnerability SMALLINT,
    Geom VARCHAR(250), -- Assuming geometry data in text/WKT format
    CodeProvision SMALLINT,
    Anchorage SMALLINT,
    DiameterOfPipeline SMALLINT,
    VoltageOfEnergy SMALLINT,
    PumpingCapacity SMALLINT,

    CONSTRAINT correlation_group_check CHECK (CorrelationGroup >= 0),
    CONSTRAINT is_primary_check CHECK (IsPrimary BETWEEN 0 AND 1),
    CONSTRAINT is_tenant_check CHECK (IsTenant BETWEEN 0 AND 1),
    CONSTRAINT percent_complete_check CHECK (PercentComplete BETWEEN 0.0 AND 1.0),
    CONSTRAINT latitude_check CHECK (Latitude BETWEEN -90.0 AND 90.0),
    CONSTRAINT longitude_check CHECK (Longitude BETWEEN -180.0 AND 180.0),
    CONSTRAINT year_built_check CHECK (YearBuilt >= 0),
    CONSTRAINT number_of_storeys_check CHECK (NumberOfStoreys >= -3),
    CONSTRAINT number_of_buildings_check CHECK (NumberOfBuildings >= 0),
    CONSTRAINT floor_area_check CHECK (FloorArea >= 0.0),
    CONSTRAINT building_tiv_check CHECK (BuildingTIV >= 0.0),
    CONSTRAINT other_tiv_check CHECK (OtherTIV >= 0.0),
    CONSTRAINT contents_tiv_check CHECK (ContentsTIV >= 0.0),
    CONSTRAINT bi_tiv_check CHECK (BITIV >= 0.0),
    CONSTRAINT bi_poi_check CHECK (BIPOI BETWEEN 0 AND 3650.0),
    CONSTRAINT gross_premium_loc_check CHECK (GrossPremium >= 0.0),
    CONSTRAINT tax_loc_check CHECK (Tax >= 0.0),
    CONSTRAINT brokerage_loc_check CHECK (Brokerage >= 0.0),
    CONSTRAINT net_premium_loc_check CHECK (NetPremium >= 0.0),
    CONSTRAINT non_cat_ground_up_loss_check CHECK (NonCatGroundUpLoss >= 0.0),
    CONSTRAINT loc_participation_check CHECK (LocParticipation BETWEEN 0.0 AND 1.0),
    CONSTRAINT is_aggregate_check CHECK (IsAggregate BETWEEN 0 AND 1),
    CONSTRAINT occupant_period_check CHECK (OccupantPeriod BETWEEN 0 and 8),
    CONSTRAINT soil_type_check CHECK (SoilType BETWEEN 0 AND 1),
    CONSTRAINT soil_value_check CHECK (SoilValue >= 0.0),
    CONSTRAINT offshore_water_depth_check CHECK (OffshoreWaterDepth IS NULL OR OffshoreWaterDepth < 0.0), -- Allow negative depths for undersea
    CONSTRAINT section_length_check CHECK (SectionLength >= 0.0),
    CONSTRAINT power_capacity_check CHECK (PowerCapacity >= 0.0),
    CONSTRAINT vulnerability_setid_check CHECK (VulnerabilitySetID >= 0)
);



-- FlexiLoc Table
CREATE TABLE FlexiLoc (
    LocNumber VARCHAR(20) NOT NULL REFERENCES Locations(LocNumber),
    ModifierName VARCHAR(40),
    ModifierValue VARCHAR(40),
    PRIMARY KEY (LocNumber, ModifierName)
);

-- LocationFinancials Table
CREATE TABLE LocationFinancials (
    LocationFinancialsID SERIAL PRIMARY KEY,  -- Surrogate Key
    LocNumber VARCHAR(20) NOT NULL REFERENCES Locations(LocNumber),  -- FK to Locations
    PerilCode VARCHAR(250) NOT NULL,  -- FK to Peril
    DedCode SMALLINT,
    DedType SMALLINT,
    DeductibleValue FLOAT,
    MinDeductibleValue FLOAT,
    MaxDeductibleValue FLOAT,
    LimitCode SMALLINT,
    LimitType SMALLINT,
    LimitValue FLOAT, -- Renamed Limit to LimitValue
    BIWaitingPeriod SMALLINT DEFAULT 0, -- Waiting period in days
    CONSTRAINT loc_fin_deductible_value_check CHECK (DeductibleValue >= 0.0),
    CONSTRAINT loc_fin_mindeductible_value_check CHECK (MinDeductibleValue >= 0.0),
    CONSTRAINT loc_fin_maxdeductible_value_check CHECK (MaxDeductibleValue >= 0.0),
    CONSTRAINT loc_fin_limit_value_check CHECK (LimitValue >= 0.0),
    CONSTRAINT bi_waiting_period_check CHECK (BIWaitingPeriod >= 0)
    ,UNIQUE (LocNumber, PerilCode, DedCode, DedType, LimitCode, LimitType)

);


-- LocationDetails Table (for SecMod data)
CREATE TABLE LocationDetails (
    LocationDetailsID SERIAL PRIMARY KEY,  -- Surrogate Key
    LocNumber VARCHAR(20) NOT NULL REFERENCES Locations(LocNumber),  -- FK to Locations
    YearUpgraded SMALLINT,     -- Year upgraded (can be SMALLINT)
    SurgeLeakage FLOAT DEFAULT -999 CONSTRAINT surge_leakage_check CHECK (SurgeLeakage BETWEEN 0.0 AND 1.0 OR SurgeLeakage = -999),
    SprinklerType SMALLINT,   -- Use consistent type for codes
    PercentSprinklered FLOAT DEFAULT -999 CONSTRAINT percent_sprinklered_check CHECK (PercentSprinklered BETWEEN 0.0 AND 1.0 OR PercentSprinklered = -999),
    RoofCover SMALLINT,
    RoofYearBuilt SMALLINT,  -- Year built (SMALLINT)
    RoofGeometry SMALLINT,
    RoofEquipment SMALLINT,
    RoofFrame SMALLINT,
    RoofMaintenance SMALLINT,
    BuildingCondition SMALLINT,
    RoofAttachedStructures SMALLINT,
    RoofDeck SMALLINT,
    RoofPitch SMALLINT,
    RoofAnchorage SMALLINT,
    RoofDeckAttachment SMALLINT,
    RoofCoverAttachment SMALLINT,
    GlassType SMALLINT,
    LatticeType SMALLINT,
    FloodZone VARCHAR(20),  -- Free text field
    SoftStory SMALLINT,
    Basement SMALLINT,
    BasementLevelCount SMALLINT CONSTRAINT basement_level_count_check CHECK (BasementLevelCount BETWEEN 0 AND 5),  -- Number of basement levels
    WindowProtection SMALLINT,
    FoundationType SMALLINT,
    WallAttachedStructure SMALLINT,
    AppurtenantStructure SMALLINT,
    ConstructionQuality SMALLINT,
    GroundEquipment SMALLINT,
    EquipmentBracing SMALLINT,
    Flashing SMALLINT,
    BuildingShape SMALLINT,
    ShapeIrregularity SMALLINT,
    Pounding SMALLINT,
    Ornamentation SMALLINT,
    SpecialEQConstruction SMALLINT,
    Retrofit SMALLINT,
    CrippleWall SMALLINT,
    FoundationConnection SMALLINT,
    ShortColumn SMALLINT,
    Fatigue SMALLINT,
    Cladding SMALLINT,
    BIPreparedness SMALLINT,
    BIRedundancy SMALLINT,
    FirstFloorHeight FLOAT DEFAULT -999, -- Height, but allow for 'unknown'
    FirstFloorHeightUnit SMALLINT,
    Datum VARCHAR(20), -- Datum reference (free text)
    GroundElevation FLOAT DEFAULT -999, -- Elevation (allowing -999 for unknown)
    GroundElevationUnit SMALLINT,
    Tank SMALLINT DEFAULT 0,
    Redundancy SMALLINT DEFAULT 0,
    InternalPartition SMALLINT DEFAULT 0,
    ExternalDoors SMALLINT DEFAULT 0,
    Torsion SMALLINT DEFAULT 0,
    MechanicalEquipmentSide SMALLINT DEFAULT 0,
    ContentsWindVulnerability SMALLINT DEFAULT 0,
    ContentsFloodVulnerability SMALLINT DEFAULT 0,
    ContentsQuakeVulnerability SMALLINT DEFAULT 0,
    SmallDebris SMALLINT DEFAULT 0,
    FloorsOccupied VARCHAR(255),   -- Free text field for occupied floors
    FloodDefenseHeight FLOAT DEFAULT -999, -- Allow for 'unknown' or 'not applicable' (-999)
    FloodDefenseHeightUnit SMALLINT,
    FloodDebrisResilience SMALLINT DEFAULT 0,  -- Assuming 0 for not resilient or no data
    BaseFloodElevation FLOAT DEFAULT -999 CONSTRAINT base_flood_elevation_check CHECK (BaseFloodElevation BETWEEN 0.0 AND 1.0 OR BaseFloodElevation = -999),
    BaseFloodElevationUnit SMALLINT,
    BuildingHeight FLOAT DEFAULT -999, -- Overall building height
    BuildingHeightUnit SMALLINT, -- Unit of measure for BuildingHeight
    BuildingValuation VARCHAR(20), -- Third-party valuation data
    TreeExposure SMALLINT DEFAULT 0,
    Chimney SMALLINT DEFAULT 0,
    BuildingType SMALLINT DEFAULT 0,
    Packaging SMALLINT DEFAULT 0,
    Protection SMALLINT DEFAULT 0,
    SalvageProtection SMALLINT DEFAULT 0,
    ValuablesStorage SMALLINT DEFAULT 0,
    DaysHeld SMALLINT DEFAULT 365 CONSTRAINT days_held_check CHECK (DaysHeld BETWEEN 0 AND 1825),  -- Days cargo is held, etc.
    BrickVeneer SMALLINT DEFAULT 0,
    FEMACompliance SMALLINT DEFAULT 0,
    CustomFloodSOP SMALLINT DEFAULT 0 CONSTRAINT custom_flood_sop_check CHECK (CustomFloodSOP BETWEEN 0 AND 10000),
    CustomFloodZone VARCHAR(20), -- User-defined flood zone
    MultiStoryHall SMALLINT DEFAULT 0,
    BuildingExteriorOpening SMALLINT DEFAULT 0,
    ServiceEquipmentProtection SMALLINT DEFAULT 0,
    TallOneStory SMALLINT DEFAULT 0,
    TerrainRoughness SMALLINT DEFAULT 0,
    StaticMotorVehicle SMALLINT DEFAULT 0
);

--WorkersComp
CREATE TABLE WorkersComp (
    LocNumber VARCHAR(20) NOT NULL REFERENCES Locations(LocNumber),
    PayRoll INT, -- Assuming Payroll is measured as a monetary amount
    CONSTRAINT payroll_check CHECK (PayRoll >= 1)
);

-- ReinsuranceInfo Table
CREATE TABLE ReinsuranceInfo (
    ReinsNumber INT PRIMARY KEY,
    ReinsName VARCHAR(30),
    ReinsLayerNumber INT,
    PerilCode VARCHAR(250),
    InceptionDate DATE,  -- Reinsurance inception date
    ExpiryDate DATE,    -- Reinsurance expiry date
    CededPercent FLOAT DEFAULT 1.0 CONSTRAINT ceded_percent_check CHECK (CededPercent BETWEEN 0.0 AND 1.0),
    RiskLimitValue FLOAT, -- Renamed to RiskLimitValue
    RiskAttachmentPoint FLOAT,
    OccLimitValue FLOAT,  -- Renamed to OccLimitValue
    OccAttachmentPoint FLOAT,
    OccFranchiseDeductibleValue FLOAT,
    OccReverseFranchise FLOAT DEFAULT 0,
    AggLimitValue FLOAT,  -- Renamed to AggLimitValue
    AggAttachmentPoint FLOAT,
    AggPeriod FLOAT DEFAULT 365 CONSTRAINT agg_period_check CHECK (AggPeriod BETWEEN 0.0 AND 3650.0),
    PlacedPercent FLOAT NOT NULL CONSTRAINT placed_percent_check CHECK (PlacedPercent BETWEEN 0.0 AND 1.0),
    Currency CHAR(3),
    InuringPriority SMALLINT NOT NULL CONSTRAINT inuring_priority_check CHECK (InuringPriority >= 1), -- Renamed Priority to InuringPriority
    ReinsType VARCHAR(3),
    AttachmentBasis CHAR(2) DEFAULT 'LO',
    Reinstatement SMALLINT, -- Number of reinstatements
    ReinstatementCharge VARCHAR(50), -- Reinstatement charges as percentages
    ReinsPremium FLOAT, -- Reinsurance premium
    DeemedPercentPlaced FLOAT DEFAULT 0 CONSTRAINT deemed_percent_placed_check CHECK (DeemedPercentPlaced BETWEEN 0.0 AND 1.0),
    ReinsFXrate FLOAT DEFAULT 1 CONSTRAINT reins_fxrate_check CHECK (ReinsFXrate > 0.0),
    TreatyShare FLOAT DEFAULT 1 CONSTRAINT treaty_share_check CHECK (TreatyShare BETWEEN 0.0 AND 1.0),
    UseReinsDates CHAR(1) DEFAULT 'N', 
    RiskLevel CHAR(3),
    CONSTRAINT reins_layer_number_check CHECK (ReinsLayerNumber >= 1),
    CONSTRAINT risk_limit_value_check CHECK (RiskLimitValue >= 0.0),
    CONSTRAINT risk_attachment_point_check CHECK (RiskAttachmentPoint >= 0.0),
    CONSTRAINT occ_limit_value_check CHECK (OccLimitValue >= 0.0),
    CONSTRAINT occ_attachment_point_check CHECK (OccAttachmentPoint >= 0.0),
    CONSTRAINT occ_franchise_deductible_value_check CHECK (OccFranchiseDeductibleValue >= 0.0),
    CONSTRAINT occ_reverse_franchise_check CHECK (OccReverseFranchise >= 0.0),
    CONSTRAINT agg_limit_value_check CHECK (AggLimitValue >= 0.0),
    CONSTRAINT agg_attachment_point_check CHECK (AggAttachmentPoint >= 0.0),
    CONSTRAINT reinsurance_premium_check CHECK (ReinsPremium >= 0.0),
    CONSTRAINT reinstatement_check CHECK (Reinstatement >= 0)
);

-- ReinsuranceScope Table
CREATE TABLE ReinsuranceScope (
    ReinsuranceScopeID SERIAL PRIMARY KEY, -- Surrogate Key
    ReinsNumber INT NOT NULL REFERENCES ReinsuranceInfo(ReinsNumber),
    PortNumber VARCHAR(20)  REFERENCES Portfolios(PortNumber),  -- FK to Portfolios
    AccNumber VARCHAR(40)  REFERENCES Accounts(AccNumber),  -- FK to Accounts
    PolNumber VARCHAR(20)  REFERENCES Policies(PolNumber),  -- FK to Policies
    LocGroup VARCHAR(20),     -- No FK, as this could be a subset or superset of actual LocGroup
    LocNumber VARCHAR(20)  REFERENCES Locations(LocNumber), -- FK to Locations
    CedantName VARCHAR(40), 
    ProducerName VARCHAR(40) REFERENCES Producers(ProducerName),  -- FK to Producers
    LOB VARCHAR(20)  REFERENCES LOB(LOB), -- FK to LOB
    CountryCode CHAR(2),
    ReinsTag VARCHAR(20), 
    CededPercent FLOAT DEFAULT 1 CONSTRAINT reins_scope_ceded_percent_check CHECK (CededPercent BETWEEN 0.0 AND 1.0),
    RiskLevel CHAR(3),  -- Should match level in ReinsInfo

    UNIQUE(ReinsNumber, PortNumber, AccNumber, PolNumber, LocNumber, ReinsTag)

);