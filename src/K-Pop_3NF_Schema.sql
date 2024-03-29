-- DB Schema is defining the format of the tables and what data types each value is

-- Creating Database
DROP DATABASE IF EXISTS KPop_Database_CA2;
CREATE DATABASE KPop_Database_CA2;

-- Creating Tables

-- Create Company
DROP TABLE IF EXISTS Company;
CREATE TABLE Company (
    CompanyID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(255),
    CEOName VARCHAR(255),
    WorthOrAnnualIncome DECIMAL(10, 2),
    StartDate DATE
);

-- Create Band
DROP TABLE IF EXISTS Band;
CREATE TABLE Band (
    BandID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BandName VARCHAR(255),
    MemberCount INT DEFAULT 0
);

-- Create Album
DROP TABLE IF EXISTS Album;
CREATE TABLE Album (
    AlbumID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    AlbumName VARCHAR(255),
    ReleaseDate DATE
);

-- Create Song
DROP TABLE IF EXISTS Song;
CREATE TABLE Song (
    SongID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SongName VARCHAR(255),
    SongLength INT
);

-- Create Member
DROP TABLE IF EXISTS Member;
CREATE TABLE Member (
    MemberID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    MemberName VARCHAR(255),
    Birthday DATE,
    StageName VARCHAR(255)
);

-- Create AlbumSong
DROP TABLE IF EXISTS AlbumSong;
CREATE TABLE AlbumSong (
    AlbumID INT REFERENCES Album(AlbumID),
    SongID INT REFERENCES Song(SongID),
    PRIMARY KEY (AlbumID, SongID)
);

-- Create CompanyBand
DROP TABLE IF EXISTS CompanyBand;
CREATE TABLE CompanyBand (
    CompanyID INT REFERENCES Company(CompanyID),
    BandID INT REFERENCES Band(BandID),
    PRIMARY KEY (CompanyID, BandID)
);

-- Create BandAlbum
DROP TABLE IF EXISTS BandAlbum;
CREATE TABLE BandAlbum (
    BandID INT REFERENCES Band(BandID),
    AlbumID INT REFERENCES Album(AlbumID),
    PRIMARY KEY (BandID, AlbumID)
);

-- Create BandMember
DROP TABLE IF EXISTS BandMember;
CREATE TABLE BandMember (
    BandID INT REFERENCES Band(BandID),
    MemberID INT REFERENCES Member(MemberID),
    PRIMARY KEY (BandID, MemberID)
);

-- Creating Triggers

-- Trigger
DELIMITER //

CREATE TRIGGER update_band_member_count
    AFTER INSERT ON BandMember
    FOR EACH ROW
BEGIN
    DECLARE band_id_val INT;

    SET band_id_val = NEW.BandID;

    UPDATE Band
    SET MemberCount = (
        SELECT COUNT(*)
        FROM BandMember
        WHERE BandID = band_id_val
    )
    WHERE BandID = band_id_val;
END;
//

DELIMITER ;

-- Trigger to stop Members associated with Albums from being deleted
DELIMITER //

CREATE TRIGGER prevent_member_deletion
    BEFORE DELETE ON Member
    FOR EACH ROW
BEGIN
    DECLARE member_id_val INT;
    SET member_id_val = OLD.MemberID;

    IF EXISTS (
        SELECT 1
        FROM AlbumSong AS ASng
        JOIN Song AS Sng ON ASng.SongID = Sng.SongID
        JOIN BandMember AS BM ON BM.MemberID = member_id_val
        WHERE BM.MemberID = member_id_val
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete. Member associated with albums.';
END IF;
END;
//

DELIMITER ;
