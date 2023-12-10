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