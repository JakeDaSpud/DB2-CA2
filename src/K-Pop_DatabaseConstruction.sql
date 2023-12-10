-- THE LAST 100 LINES OF THIS FILE ARE NOT CREATING THE DATABASE, IT IS RUNNING COMMANDS TO SHOW WHAT WE HAVE DONE, YOU CAN COPY & PASTE THE FIRST 400~ LINES TO CREATE THE DB

/*
GD2A CA2:
   Jake O'Reilly
   Ema Eiliakas
   Michal Becmer
*/

-- Creating Database
DROP DATABASE IF EXISTS KPop_Database_CA2;
CREATE DATABASE KPop_Database_CA2;
USE kpop_database_ca2;



-- Creating Tables

-- Create Company
DROP TABLE IF EXISTS Company;
CREATE TABLE Company (
    CompanyID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(255),
    CEOName VARCHAR(255),
    WorthOrAnnualIncome DECIMAL,
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

-- Trigger to see how many members are in a band when a new BaneMember is made
DELIMITER //

CREATE TRIGGER update_band_member_count
    AFTER INSERT ON BandMember
    FOR EACH ROW
BEGIN
    /* making a local variable */
    DECLARE band_id_val INT;

    /* set bandID to new bandID */
    SET band_id_val = NEW.BandID;

    /* changing the member count*/
    UPDATE Band
    SET MemberCount = (
        /* getting how many rows are associated to the the BandMember */
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
    /* making local variable that is the memberID that is going to be deleted */
    DECLARE member_id_val INT;
    SET member_id_val = OLD.MemberID;

    /* seeing if this member has any albums related to it */
    IF EXISTS (
        SELECT 1 FROM AlbumSong AS albs
        JOIN Song AS s ON albs.SongID = s.SongID
        JOIN BandMember AS bm ON bm.MemberID = member_id_val
        WHERE bm.MemberID = member_id_val
    )

    /* this error will return back if the previous IF EXISTS is true */
    /* https://www.tutorialspoint.com/mysql/mysql_signal_statement.htm */
    /* https://www.tutorialspoint.com/How-can-we-use-SIGNAL-statement-with-MySQL-triggers */
    THEN
        SIGNAL SQLSTATE '45000'
        /* returned error message */
        SET MESSAGE_TEXT = 'Cannot delete Member. Member is associated with albums.';
    END IF;
END;
//

DELIMITER ;



-- Creating Users

-- Fan User
DROP USER IF EXISTS 'fan'@'localhost';
CREATE USER 'fan'@'localhost' IDENTIFIED BY 'fanpassword';

GRANT SELECT ON KPop_Database_CA2.band TO 'fan'@'localhost';
GRANT SELECT ON KPop_Database_CA2.album TO 'fan'@'localhost';
GRANT SELECT ON KPop_Database_CA2.member TO 'fan'@'localhost';
GRANT SELECT ON KPop_Database_CA2.song TO 'fan'@'localhost';

-- Worker User
DROP USER IF EXISTS 'company_worker'@'localhost';
CREATE USER 'company_worker'@'localhost' IDENTIFIED BY 'workerpassword';

GRANT ALL PRIVILEGES ON KPop_Database_CA2.* TO 'company_worker'@'localhost';

-- Worker User 2
DROP USER IF EXISTS 'company_worker_2'@'localhost';
CREATE USER 'company_worker_2'@'localhost' IDENTIFIED BY 'workerpassword2';

GRANT ALL PRIVILEGES ON KPop_Database_CA2.* TO 'company_worker_2'@'localhost';



-- Creating Indexes

-- Song Length Index
DROP INDEX IF EXISTS idx_SongLength ON Song;
CREATE INDEX idx_SongLength ON Song(SongLength);

-- Release Date Index
DROP INDEX IF EXISTS idx_ReleaseDate ON Album;
CREATE INDEX idx_ReleaseDate ON Album(ReleaseDate);

-- CEO Name Index
DROP INDEX IF EXISTS idx_CEO ON Company;
CREATE INDEX idx_CEO ON Company(CEOName);



-- Creating Stored Procedures

-- Display Bands depending on what Company ID you give
DELIMITER //
/* Drop procedures to ensure the correct one is being used */
DROP PROCEDURE IF EXISTS GetBandsByCompany//
CREATE PROCEDURE GetBandsByCompany(IN companyID INT)
BEGIN
    SELECT Band.* FROM Band
    INNER JOIN CompanyBand ON Band.BandID = CompanyBand.BandID
    WHERE CompanyBand.CompanyID = companyID;
END//
DELIMITER ;

-- Display Songs depending on what Album Name you give
DELIMITER //
DROP PROCEDURE IF EXISTS GetSongsByAlbum//
CREATE PROCEDURE GetSongsByAlbum(IN albumName VARCHAR(255))
BEGIN
    SELECT Song.* FROM Song
    INNER JOIN AlbumSong ON Song.SongID = AlbumSong.SongID
    INNER JOIN Album ON AlbumSong.AlbumID = Album.AlbumID
    WHERE Album.AlbumName = albumName;
END//
DELIMITER ;

-- Display Members depending on what Band Name you give
DELIMITER //
DROP PROCEDURE IF EXISTS DisplayBandMembers//
CREATE PROCEDURE DisplayBandMembers(IN bandName VARCHAR(255)) /*defines an input variable, takes in a band name for which we want to retrieve member info*/
BEGIN
    /* This then displays the members of the band */
    SELECT bandName AS Band, MemberName, Birthday, StageName
    FROM Member
    INNER JOIN BandMember ON Member.MemberID = BandMember.MemberID
    INNER JOIN Band ON BandMember.BandID = Band.BandID
    WHERE Band.BandName = bandName;
END //

DELIMITER ;



-- Creating Views

-- View for details of bands
CREATE VIEW BandDetails AS SELECT b.BandID, b.BandName, a.AlbumID, a.AlbumName, s.SongID, s.SongName, m.MemberID, m.MemberName FROM Band b
LEFT JOIN BandAlbum ba ON b.BandID = ba.BandID
LEFT JOIN Album a ON ba.AlbumID = a.AlbumID
LEFT JOIN AlbumSong albs ON a.AlbumID = albs.AlbumID
LEFT JOIN Song s ON albs.SongID = s.SongID
LEFT JOIN BandMember bm ON b.BandID = bm.BandID
LEFT JOIN Member m ON bm.MemberID = m.MemberID;

-- View for details of band AND members
CREATE VIEW BandMemberDetails AS SELECT b.BandID, b.BandName, m.MemberID, m.MemberName, m.Birthday, m.StageName FROM Band b
LEFT JOIN BandMember bm ON b.BandID = bm.BandID
LEFT JOIN Member m ON bm.MemberID = m.MemberID;



-- Populating Tables

--COMPANY 1
INSERT INTO Company (CompanyName, CEOName, WorthOrAnnualIncome, StartDate) VALUES ('JYP Entertainment', 'Jung Wook', 3.35,'1997-05-12');
SET @lastCompanyID = LAST_INSERT_ID();
--Band 1(company 1)
INSERT INTO Band (BandName) VALUES ('Stray Kids');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Felix', '2000-09-15', NULL);
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('MAXIDENT', '2022-05-27');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('Hellevator(MixTape)', 239);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);

--Band 2 (company 1)
INSERT INTO Band (BandName) VALUES ('TWICE');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Momo Hirai', '1996-11-09', 'Momo');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('FANCY YOU', '2019-04-22');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('FANCY', 213);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--COMAPNY 2
INSERT INTO Company (CompanyName, CEOName, WorthOrAnnualIncome, StartDate) VALUES ('YG Entertainment', 'Hwag Bo-Kyung', 1.11,'1996-03-06');
SET @lastCompanyID = LAST_INSERT_ID();
--Band 1(company 2)
INSERT INTO Band (BandName) VALUES ('BLACKPINK');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Jennie Kim', '1996-01-16', NULL);
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('The Album', '2020-08-02');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('How you like that', 182);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);

--Band 2 (company 2)
INSERT INTO Band (BandName) VALUES ('iKON');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Kim Jinhwan', '1996-08-22', 'B.I');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('Return', '2018-01-25');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('LOVE SCENARIO', 209);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--COMAPNY 3
INSERT INTO Company (CompanyName, CEOName, WorthOrAnnualIncome, StartDate) VALUES ('Hybe Labels','Park Jiwon', 7.51,'2005-02-01');
SET @lastCompanyID = LAST_INSERT_ID();
--Band 1(company 3)
INSERT INTO Band (BandName) VALUES ('BTS');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Jung Ho-seok', '1996-01-16', 'J-Hope');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('Hotter,Sweeter,Cooler', '2021-06-04');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('Butter', 164);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);

--Band 2 (company 3)
INSERT INTO Band (BandName) VALUES ('Seventeen');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Jeon Won Woo', '1996-07-16', 'Wonwoo');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('Face the sun', '2022-05-27');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('HOT', 197);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--COMAPNY 4
INSERT INTO Company (CompanyName, CEOName, WorthOrAnnualIncome, StartDate) VALUES ('SM Entertainment', 'Tak Young-Jun', 1.56, '1995-02-14');
SET @lastCompanyID = LAST_INSERT_ID();
--Band 1(company 4)
INSERT INTO Band (BandName) VALUES ('NCT');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Kim Jae-Young', '1996-01-16', 'Jaeyoung');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('Regulate', '2018-11-23');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('Simon says', 199);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);

--Band 2 (company 4)
INSERT INTO Band (BandName) VALUES ('EXO');
SET @lastBandID = LAST_INSERT_ID();
INSERT INTO CompanyBand (CompanyID, BandID) VALUES (@lastCompanyID, @lastBandID);

INSERT INTO Member (MemberName, Birthday, StageName) VALUES ('Kim Jong-in', '1994-01-14', 'KAI');
SET @lastMemberID = LAST_INSERT_ID();
INSERT INTO BandMember (BandID, MemberID) VALUES (@lastBandID, @lastMemberID);

INSERT INTO Album (AlbumName, ReleaseDate) VALUES ('EXACT', '2016-06-09');
SET @lastAlbumID = LAST_INSERT_ID();
INSERT INTO BandAlbum(BandID, AlbumID) VALUES (@lastBandID, @lastAlbumID);

INSERT INTO Song (SongName, SongLength) VALUES ('MONSTER', 221);
SET @lastSongID = LAST_INSERT_ID();
INSERT INTO AlbumSong(AlbumID, SongID) VALUES (@lastAlbumID, @lastSongID);

-- End of creating KPop_Database_CA2



/* ================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================== */



-- Using Users

-- Logging in with Fan User
/* mysql -u fan -p
password: fanpassword */

-- Logging in with Worker User
/* mysql -u company_worker -p
password: workerpassword */



-- Using Views

SELECT * FROM BandDetails;

SELECT * FROM BandMemberDetails;



-- Using Stored Procedures

CALL GetBandsByCompany(1);

CALL GetSongsByAlbum('Butter');

CALL DisplayBandMembers('Stray Kids');



-- Using Deletions

DELETE FROM Company WHERE CompanyID = 1;

DELETE FROM Song WHERE SongLength > 235;

DELETE FROM Member
WHERE MemberID IN (
    SELECT MemberID
    FROM Member
    WHERE Birthday < '1996-01-01'
);

DELETE FROM Band
WHERE BandID NOT IN (
    SELECT BandID
    FROM BandMember
);



-- Using Updates

UPDATE Member
-- new stage name
SET StageName = 'Jim Cook'
WHERE MemberID = 1;

UPDATE Band
-- New Band Name
SET BandName = 'Jim Cooks Crooks'
WHERE BandID = 1;

UPDATE Company
-- sets new CEO name
SET CEOName = 'Jakey Bakey'
WHERE CompanyID = 1
  AND WorthOrAnnualIncome = 3.35;



-- Using Indexes

-- Query to retreive songs with length greater than 200 seconds
SELECT SongID, SongName, SongLength
FROM Song
WHERE SongLength > 200;

-- Query to retrieve albums released after May 27, 2022
EXPLAIN SELECT * FROM Album WHERE ReleaseDate = '2022-05-27';

-- Second query to retrieve albums released after June 9, 2016
SELECT AlbumID, AlbumName, ReleaseDate
FROM Album
WHERE ReleaseDate > '2016-06-09';

-- Query to retrieve company information based on CEO's name
SELECT CompanyID, CompanyName, CEOName FROM Company WHERE CEOName = 'Jung Wook';



-- Using Transactions

-- Committed Transaction
START TRANSACTION;

-- All null Stage Names are changed to "No Known Stage Name"
UPDATE Member SET StageName = 'No Known Stage Name' WHERE StageName IS NULL;

COMMIT;

-- Rolled back Transaction
START TRANSACTION;

-- All band names changed to "BIG MISTAKE", and then rolled back as this simulates an error
UPDATE Band SET BandName = 'BIG MISTAKE';

ROLLBACK;