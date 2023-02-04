CREATE TABLE ais(
    MMSI INTEGER,
    BaseDateTime DATE,
    LAT REAL,
    LON REAL,
    SOG REAL,
    COG REAL,
    Heading REAL,
    VesselName VARCHAR(255),
    IMO VARCHAR(255),
    CallSign VARCHAR(255),
    VesselType INTEGER,
    Status INTEGER,
    Length INTEGER,
    Width INTEGER,
    Draft REAL,
    Cargo INTEGER,
    TransceiverClass VARCHAR(1)
);

COPY "ais" FROM '/data/sample.csv' DELIMITER ',' CSV HEADER;