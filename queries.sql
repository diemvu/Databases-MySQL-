/*
Group 2 
Press Play Solutions
SQLScript (Phase III, Version 3.16.2020).sql
TCSS 445 A
Winter 2020
Tested on Oracle SQL DBMS
*/

/*
This script creates a relational database for all 
'Original' content provided: Hulu, Netflix, Disney+, Apple TV+,
HBO Max, DC Universe, YouTube Premium, Amazon Prime Video,
Shudder, Curiosity Stream and Crackle.
*/

/*
Create an id counter for the cast and crew entity. 
*/
CREATE SEQUENCE seq_castcrew  
MINVALUE 0 
START WITH 1  
INCREMENT BY 1  
CACHE 1000;

/*
Create an id counter for the person entity. 
*/
CREATE SEQUENCE seq_person   
MINVALUE 0   
START WITH 1   
INCREMENT BY 1   
CACHE 1000;

/*
Create an id counter for the role entity. 
*/
CREATE SEQUENCE seq_role
MINVALUE 0
START WITH 1
INCREMENT BY 1
CACHE 1000;

/*
Create an id counter for the tvseries entity. 
*/
CREATE SEQUENCE seq_tvseries
MINVALUE 0
START WITH 1
INCREMENT BY 1
CACHE 1000;

/*
Create an id counter for the movies entity. 
*/
CREATE SEQUENCE seq_movies
MINVALUE 0
START WITH 1
INCREMENT BY 1
CACHE 1000;

/*
Create an id counter for the bundle entity. 
*/
CREATE SEQUENCE seq_bundle
MINVALUE 0
START WITH 1
INCREMENT BY 1
CACHE 1000;

/*
Creates a table for a person featured 
in an original movie or tv series.

@PersonID (PK) The unique id number for a person.  
@LastName The person's last name.
@FirstName The person's first name.
*/
CREATE TABLE Person (  
	PersonID		    INT 		PRIMARY KEY,  
	LastName		    VARCHAR(20),
	FirstName		    VARCHAR(20)
                    );

/*
Creates a table for the cast and crew
members casted in a movie or tv series.

@CastCrewID (PK) The unique id number 
                          for the cast and crew.
@DateCreated The date the cast and crew was entered into the DB.
*/
CREATE TABLE CastCrew (
    CastCrewID          INT         PRIMARY KEY,
    DateCreated         DATE
                      );

/*
Creates a table for the role a person plays in 
a movie or tv series.

@RoleID (PK) The unique id number for the role.
@CastCrewID (FK) The cast and crew id number.
@PersonID (FK) The person id number.
@RoleName The name of the role.
*/
CREATE TABLE Roles (
    RoleID              INT         PRIMARY KEY,
    CastCrewID          INT         NOT NULL,
    PersonID            INT         NOT NULL,
    RoleName            VARCHAR(30),
    FOREIGN KEY (PersonID) REFERENCES Person (PersonID),
    FOREIGN KEY (CastCrewID) REFERENCES CastCrew (CastCrewID)
                      );

/*
Creates a table for the digital services
providing original content.

@ServiceID (PK) The unique service id number for the digital provider.
@ServiceName The name of the provider's service.
@NumberOfOriginals The number of exclusive content added so far.
*/
CREATE TABLE Services (  
    ServiceID		    INT			PRIMARY KEY,  
    ServiceName		    VARCHAR(20)	UNIQUE,  
    NumberOfOriginals	INT,  
    CONSTRAINT checkNumberOfOriginals CHECK (NumberOfOriginals >= 0)	  
                      );

/*
Creates a table for the bundles offered by
each service provider.

@BundleID (PK) The unique id number for the bundle.
@ServiceID (FK) The unique service id number sponsoring the bundle.
@Price The price of this bundle as a floating point value.
@MonthlyAnnual The term limit for the subscription bundle.
@Resolution The resolutions included in this bundle (UHD, SD, HD, 4K)
*/
CREATE TABLE Bundles (  
    BundleID            INT         PRIMARY KEY,
    ServiceID           INT         NOT NULL,
	Price			    DOUBLE PRECISION    NOT NULL,		  
	MonthlyAnnual	    CHAR(1),  
    Resolution		    VARCHAR(3),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT checkPrice CHECK (Price >= 0.0)  
			         );

/*
Creates a table for original movies streamed by
each service.

@MovieID (PK) The unique id number for the movie.
@MovieName The name of the movie.
@ServiceID (FK) The digital streaming service provider id number.
@CastCrewID (FK) The cast and crew id number.
@Genre The category of genre.
@MovieLength The length of the movie in minutes.
@Studio The film studio.
@ReleaseDate The date the movie was release.
@Resolution The resolution available.
@RottenTomatoRating The rotten tomato rating value.
@UserRating Our database user rating.
*/			         
CREATE TABLE Movies (  
    MovieID             INT         PRIMARY KEY,
	MovieName		    VARCHAR(50),  
	ServiceID		    INT			NOT NULL,  
	CastCrewID		    INT         UNIQUE,  
	Genre			    VARCHAR(20),  
	MovieLength		    INT,  
	Studio			    VARCHAR(40),   
	ReleaseDate		    DATE,  
	Resolution		    VARCHAR(3),  
	RottenTomatoRating	DOUBLE PRECISION	DEFAULT (NULL),  
	UserRating		    DOUBLE PRECISION	DEFAULT (NULL),  
	FOREIGN KEY (ServiceID) REFERENCES Services (ServiceID),	  
	FOREIGN KEY (CastCrewID) REFERENCES CastCrew(CastCrewID)  
         ON DELETE CASCADE, 	-- ON UPDATE CASCADE,  
	CONSTRAINT checkLength CHECK (MovieLength >= 0),  
	CONSTRAINT checkURating CHECK (UserRating >= 0.0 AND UserRating <= 5.0)  
    			   );

/*
Creates a table for original tv series
provided by each service.

@TVSeriesID (PK) The unique id number for tv series.
@SeriesName The title of the tv series.
@ServiceID (FK) The digital streaming service provider id number.
@CastCrewID (FK) The cast and crew id number.
@Genre The genre category.
@NumberOfSeasons The number of seasons filmed.
@NumberOfEpisodes The total number of episodes in the tv series.
@PilotAirDate The date the tv series launched its pilot.
@RecentEpisodes The recent episode.
@Resolution The resolution available.
@RottenTomatoRating The rotten tomato rating value.
@UserRating Our user rating value.
*/
CREATE TABLE TVSeries (  
    TVSeriesID          INT         PRIMARY KEY,
	SeriesName		    VARCHAR(50),  
	ServiceID		    INT			NOT NULL,  
	CastCrewID		    INT         UNIQUE,  
	Genre			    VARCHAR(20),  
	NumberOfSeasons	    INT,  
	NumberOfEpisodes	INT,  
	PilotAirDate		DATE,  
	RecentEpisode	    VARCHAR(6),  
    Resolution		    VARCHAR(3),  
    RottenTomatoRating	DOUBLE PRECISION	DEFAULT (NULL),  
    UserRating		    DOUBLE PRECISION	DEFAULT (NULL),  
    FOREIGN KEY (ServiceID) REFERENCES Services (ServiceID),  
    FOREIGN KEY (CastCrewID) REFERENCES CastCrew (CastCrewID)  
         ON DELETE CASCADE,	-- ON UPDATE CASCADE,  
    CONSTRAINT checkNumSeasons CHECK (NumberOfSeasons >= 0),  
    CONSTRAINT checkNumEpisodes CHECK (NumberOfEpisodes >= 0)  
                      );

-- Netflix, ServiceID = 1
INSERT INTO Services  
VALUES ( 1, 'Netflix', 3);

-- Disney+, ServiceID = 2
INSERT INTO Services  
VALUES ( 2, 'Disney+', 3);

-- YouTube Premium, ServiceID = 3
INSERT INTO Services  
VALUES ( 3, 'YouTube Premium', 3);

-- DC, Universe, ServiceID = 4
INSERT INTO Services  
VALUES ( 4, 'DC Universe', 3);

-- HBO Max, ServiceID = 5
INSERT INTO Services  
VALUES ( 5, 'HBO Max', 3);

-- Apple TV+, ServiceID = 6
INSERT INTO Services  
VALUES ( 6, 'Apple TV+', 3);

-- Shudder, ServiceID = 7
INSERT INTO Services   
VALUES ( 7, 'Shudder', 74);

-- Curiosity Stream, ServiceID = 8
INSERT INTO Services   
VALUES ( 8, 'Curiosity Stream', 13);

-- Crackle, ServiceID = 9
INSERT INTO Services   
VALUES ( 9, 'Crackle', 25);

-- Amazon Prime, ServiceID = 10
INSERT INTO Services  
VALUES ( 10, 'Amazon Prime', 4);

-- Hulu, ServiceID = 11
INSERT INTO Services  
VALUES ( 11, 'Hulu', 4);



-- Netflix, 1
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 1, 8.99, 'M','SD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 1, 12.99, 'M', 'HD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 1, 15.99, 'M', 'UHD');


-- Disney, 2
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 2, 6.99, 'M', 'UHD');


-- Youtube Premium, 3
INSERT INTO Bundles  
VALUES( seq_bundle.nextval, 3, 11.99, 'M', 'HD');


-- DC Universe, 4
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 4, 74.99, 'A', 'HD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 4, 7.99, 'M', 'HD');


-- HBO Max, 5
INSERT INTO Bundles   
VALUES ( seq_bundle.nextval, 5, 14.99, 'M', 'UHD');


-- Apple TV+, 6
INSERT INTO Bundles   
VALUES ( seq_bundle.nextval, 6, 4.99, 'M', 'UHD');


-- Shudder, 7
INSERT INTO Bundles   
VALUES ( seq_bundle.nextval, 7, 5.99, 'M', 'HD');

INSERT INTO Bundles   
VALUES ( seq_bundle.nextval, 7, 4.75, 'M', 'HD');


-- Crackle, 8
INSERT INTO Bundles   
VALUES ( seq_bundle.nextval, 8, 19.99, 'M', 'HD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 8, 69.99, 'A', 'UHD');


-- Curiosity Stream, 9
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 9, 0.0, 'M', 'HD');


-- Amazon Prime Video, 10
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 10, 8.99, 'M', 'HD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval,10, 59.00, 'A','HD');

INSERT INTO Bundles  
VALUES( seq_bundle.nextval, 10, 119, 'A', 'HD');


-- Hulu, 11
INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 11, 5.99, 'M', 'HD');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 11, 11.99, 'M', 'HD');

INSERT INTO Bundles  
VALUES( seq_bundle.nextval, 11, 54.99, 'M', '4K');

INSERT INTO Bundles  
VALUES ( seq_bundle.nextval, 11, 60.99, 'M', '4K');


-- CastCrewID = 1
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08'); 

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Bier', 'Susanne');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director'); 

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Bullock', 'Sandra');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor'); 

INSERT INTO Movies		-- Bird Box  
VALUES ( seq_movies.nextval, 'Bird Box', 1, seq_castcrew.currval,  'Horror', 124 ,   
	'Bluegrass Films', DATE '2018-11-12', NULL, 63, NULL);


-- CastCrewID = 2
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08'); 

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Levy', 'Shawn');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Executive Producer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Ryder', 'Wiona');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');   

INSERT INTO TVSeries 		-- Stranger Things  
VALUES ( seq_tvseries.nextval, 'Stranger Things', 1, seq_castcrew.currval, 'Sci-Fi/Fantasy', 3,  
    25, DATE '2016-07-15', 'S03E08', NULL, 93, NULL);

-- CastCrewID = 3
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Stewart', 'Nzingha');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Michelle', 'Ava');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies		-- Tall Girl  
VALUES ( seq_movies.nextval, 'Tall Girl', 1, seq_castcrew.currval, 'Comedy', 102,  
	 'Wonderland Sound and Vision', DATE '2019-09-13', NULL, 44, NULL);


-- CastCrew 4
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Favreau', 'Jon');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Showrunner');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Pascal', 'Pedro');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- Mandalorian  
VALUES ( seq_tvseries.nextval, 'Madalorian', 2, seq_castcrew.currval, 'Sci-Fi/Fantasy', 1,  
	 8, DATE '2019-11-12', 'S01E08', NULL, 95, NULL);


-- CastCrew 5
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextVal, 'Lawrence', 'Marc');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES ( seq_person.nextVal, 'Kendrick', 'Anna');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies		-- Noelle  
VALUES ( seq_movies.nextval, 'Noelle', 2, seq_castcrew.currval, 'Comedy', 100,  
	'Walt Disney Pictures', DATE '2019-11-12', NULL, 53, NULL);


-- CastCrew 6
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextVal, 'Federle', 'Tim');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Executive Producer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Rodrigo', 'Olivia');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- HSM:TM:TS  
VALUES ( seq_tvseries.nextval, 'High School Musical: The Musical: The Series', 2, seq_castcrew.currval, 'Musical', 1,   
	10, DATE '2019-11-08', 'S01E10', NULL, 76, NULL);
	

-- CastCrew 7
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Gallagher', 'Michael');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Paul', 'Logan');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies		-- The Thinning  
VALUES ( seq_movies.nextval, 'The Thinning', 3, seq_castcrew.currval, 'Sci-Fi/Fantasy', 83,  
'Legendary Digital Media', DATE '2016-10-12', NULL, NULL, NULL);


-- CastCrew 8
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Halpern', 'Justin');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Developer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Cuoco', 'Kaley');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Voice Actor');

INSERT INTO TVSeries		-- Harley Quinn  
VALUES ( seq_tvseries.nextval, 'Harley Quinn', 4, seq_castcrew.currval, 'Animated', 1,  
	13, DATE '2019-11-28', 'S01E10', NULL, 89, NULL);


-- CastCrew 9
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Draft', 'Travis');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Kjellberg', 'Felix');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- Scare Pewdiepie  
VALUES ( seq_tvseries.nextval, 'Scare PewDiePie', 3, seq_castcrew.currval, 'Comedy', 2,  
	10, DATE '2016-02-10', 'S01E10', NULL, NULL, NULL);


-- CastCrew 10
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Sorenson', 'Holly');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Cinematographer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Jones', 'Petrice');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		--  Step up: High Water  
VALUES ( seq_tvseries.nextval, 'Step up: High Water', 3, seq_castcrew.currval, 'Drama', 2,   
20, DATE '2018-01-30', 'S02E10', NULL, NULL, NULL);


-- CastCrew 11
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Goldsman', 'Akiva');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Developer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Thwaites', 'Brenton');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- Titans  
VALUES ( seq_tvseries.nextval, 'Titans', 4, seq_castcrew.currval, 'Action Adventure', 2,   
	24, DATE '2018-10-12', 'S02E12', NULL, 82, NULL);


-- CastCrew 12
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Weisman', 'Greg');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Developer');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'McCartney', 'Jesse');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Voice Actor');

INSERT INTO TVSeries		-- Young Justice  
VALUES ( seq_tvseries.nextval, 'Young Justice', 4, seq_castcrew.currval, 'Animated', 3,   
	72, DATE '2010-11-26', 'S03E26', NULL, 95, NULL);


-- CastCrew 13
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Heald', 'Josh');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Creator');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Macchio', 'Ralph');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- Cobra Kai  
VALUES ( seq_tvseries.nextval, 'Cobra Kai', 3, seq_castcrew.currval, 'Comedy', 2,   
	20, DATE '2018-05-02', 'S02E10', NULL, 94, NULL);


-- CastCrew 14
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Stone', 'Victoria');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Co-Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Deeble', 'Mark');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Co-Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Ejiofor', 'Chiwetel');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Narrator');

INSERT INTO Movies		-- Elephant Queen  
VALUES ( seq_movies.nextval, 'Elephant Queen', 6, seq_castcrew.currval, 'Documentary', 136,   
	'A24', DATE '2019-01-27', 'UHD', 90, NULL);


-- CastCrew 15
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Baig', 'Minhal');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Viswanathan', 'Geraldine');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Lead Actor');

INSERT INTO Movies		-- Hala  
VALUES ( seq_movies.nextval, 'Hala', 6, seq_castcrew.currval, 'Drama', 133,   
'Overbrook Entertainment', DATE '2019-11-22', 'UHD', NULL, NULL);


-- CastCrew 16
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Moore', 'Ronald D.');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Kinnaman', 'Joel');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Lead Actor');

INSERT INTO TVSeries 		-- For All Mankind  
VALUES ( seq_tvseries.nextval, 'For All Mankind', 6, seq_castcrew.currval, 'Drama', 1,  
	10, DATE '2019-11-01', 'S01E10', 'UHD', 73, NULL);


-- CastCrew 17
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Weiss', 'D.B.');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Showrunner');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Clarke', 'Emilia');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Harington', 'Kit');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Dinklage', 'Peter');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- Game of Thrones  
VALUES ( seq_tvseries.nextval, 'Game of Thrones', 5, seq_castcrew.currval, 'Sci-Fi/Fantasy', 8,  
	73, DATE '2011-04-17', 'S08E06', 'UHD', NULL, NULL);



-- CastCrew 18
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Lindelof', 'Damon');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Showrunner');

INSERT INTO Person  
VALUES (seq_person.nextval, 'King', 'Regina');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Lead Actor');

INSERT INTO TVSeries		-- Watchmen  
VALUES ( seq_tvseries.nextval, 'Watchmen', 5, seq_castcrew.currval, 'Sci-Fi/Fantasy', 1,  
	9, DATE '2019-10-20', 'S01E09', 'UHD', 96, NULL);



-- CastCrew 19
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Fargeat', 'Coralie');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Janssens', 'Kevin');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies      --Revenge
VALUES ( seq_movies.nextval, 'Revenge', 7, seq_castcrew.currval, 'Horror', 108,   
'M.E.S. Productions', DATE '2018-05-13', 'HD', 81.0, NULL);



-- CastCrew 20
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Cohen', 'Douglas');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Hadfield', 'Chris');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies      --Miniverse
VALUES ( seq_movies.nextval, 'Miniverse', 8, seq_castcrew.currval, 'Documentary', 50,   
'Flight 33',  DATE '2017-04-17', '4K', 66.0, NULL);


-- CastCrew 21
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES ( seq_person.nextval, 'Wolf', 'Fred');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES ( seq_person.nextval, 'Sheen', 'Charlie');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies      --Mad Families
VALUES ( seq_tvseries.nextval, 'Mad Families', 9, seq_castcrew.currval, 'Comedy', 90,   
'Sony', DATE '2017-01-12', 'HD', 41.0, NULL);


-- CastCrew 22
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Andrade', 'Ricardo');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Andrade', 'Ricardo');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries        -- A Curious World
VALUES ( seq_tvseries.nextval, 'A Curious World', 8, seq_castcrew.currval, 'Documentary', 2,   
20, DATE '2015-09-28', 'S01E05', NULL,  41, NULL);



-- CastCrew 23
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Korsarko', 'Andrew');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Stango', 'Kel');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO TVSeries        -- Digits
VALUES ( seq_tvseries.nextval, 'Digits', 8, seq_castcrew.currval, 'Documentary', 1,   
3, DATE '2016-10-19', 'S01E03',  'HD', 79, NULL);



-- CastCrew 24
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES ( seq_person.nextval, 'Kaku', 'Michio');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Himself');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Markley', 'Jonathan');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Narrator');

INSERT INTO TVSeries        -- Deep Time History
VALUES ( seq_tvseries.nextval, 'Deep Time History', 8, seq_castcrew.currval, 'Documentary', 1,   
3, DATE '2016-07-22', 'S01E03', 'HD', 86, NULL);



-- CastCrew 25
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Felux', 'Shane');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Chau', 'Hong');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries        -- Trenches
VALUES ( seq_tvseries.nextval, 'Trenches', 9, seq_castcrew.currval, 'Horror', 1,   
10, DATE '2009-02-16', 'S01E10', 'HD', 0, NULL);


-- CastCrew 26
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Etheredge', 'Paul');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Producer');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Bell', 'Zoe');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries        -- Angel of Death
VALUES ( seq_tvseries.nextval, 'Angel of Death', 9, seq_castcrew.currval, 'Horror', 1,   
10, DATE '2009-03-02', 'S01E10', 'HD', 0, NULL);



-- CastCrew 27
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Ketai', 'Ben');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Creator');

INSERT INTO Person 
VALUES (seq_person.nextval, 'Carmichael', 'Caitlin');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries        -- CHOSEN
VALUES ( seq_tvseries.nextval, 'CH:OS:EN', 9, seq_castcrew.currval, 'Horror', 3,   
18, DATE '2013-01-17', 'S03E06', 'HD', 0, NULL);

-- CastCrew 28
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Garland', 'Alex');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES (seq_person.nextval, 'Natalie', 'Portman');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies		--Annihilation  
VALUES ( seq_movies.nextval, 'Annihilation', 11, seq_castcrew.currval, 'Sci-Fi/Fantasy', 120,  
	'Skydance Media', Date '2018-02-03','UHD', 88, NULL);


-- CastCrew 29
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Lonergan', 'Kenneth');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Affleck', 'Casey');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO Movies		-- Manchester by the Sea  
VALUES ( seq_movies.nextval, 'Manchester by the Sea', 10, seq_castcrew.currval,  'Drama', 137,   
	'Amazon Studios', DATE '2016-11-18','UHD', 96, NULL);



-- CastCrew 30
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Miller', 'Bruce');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Director');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Moss', 'Elizabeth');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries		-- The Handmaid's Tale  
VALUES ( seq_tvseries.nextval, 'The Handmaids Tale', 11, seq_castcrew.currval, 'Sci-Fi/Fantasy', 3,   
	36, DATE '2017-04-26','S03E12', 'UHD', 88, NULL);


-- CastCrew 31
INSERT INTO CastCrew  
VALUES ( seq_castcrew.nextval, DATE '2020-03-08');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Sherman-Palladino', 'Amy');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Showrunner');

INSERT INTO Person  
VALUES ( seq_person.nextval, 'Brosnahan', 'Rachel');

INSERT INTO Roles
VALUES ( seq_role.nextval, seq_castcrew.currval, seq_person.currval, 'Actor');

INSERT INTO TVSeries 		-- The Marvelous Mrs. Maisel  
VALUES ( seq_tvseries.nextval, 'The Marvelous Mrs. Maisel', 10, seq_castcrew.currval, 'Drama', 2,  
	25, DATE '2017-03-17', 'S02E08','UHD', 89, NULL);


-- Part C 10 Non-trivial SQL Queries

/*
Q1.
    Purpose: Select all info on original movies, cast and crew 
             and services based on their respective matching keys.  
    Summary: Q1 returns a table of n-tuple rows from movies, castcrew, 
             services entities and their respective attributes. 

*/
SELECT * 
FROM  Movies 
JOIN CastCrew 
ON Movies.CastCrewID = CastCrew.CastCrewID 
JOIN Services 
ON Movies.ServiceID = Services.ServiceID;

/*
Q2.
    Purpose: Select the names of any tv show with more than
             two seasons in a series
    Summary: Q2 returns a single column table of shows 
             having greater than two seasons
    Expected Result: 
                 Stranger Things, CH:OS:EN
                 Game of Thrones, Young Justice, 
                 The Handmaids Tale

*/
SELECT TVSeries.SeriesName 
FROM TVSeries 
WHERE TVSeries.NumberOfSeasons > ANY (SELECT TVSeries.NumberOfSeasons 
            			 			  FROM TVSeries 
            						  WHERE NumberOfSeasons = 2)  
GROUP BY SeriesName;


/*
Q3.
    Purpose: Select the names of movies whose RottenTomato ratings
             are higher than the average of all the movie ratings
             in the database.
    Summary: Q3 returns a single column table with the movie names
             whose RottenTomato ratings are higher the average.
    Expected Value: Revenge, Annihilation, Elephant Queen, 
                    Manchester by the Sea
*/
SELECT Movies.MovieName
FROM Movies 
WHERE RottenTomatoRating > ( SELECT AVG(RottenTomatoRating) 
				             FROM Movies) 
ORDER BY RottenTomatoRating ASC;


/*
Q4.
    Purpose: Select all movie, tv series and service ids provided by each 
             digital streaming service.
    Summary: Returns n-tuples of each movie and tv show paired with 
             their respective providers' service id. Note: Some services
             only have tv shows, the movie name column is left blank '-'.
*/
SELECT TVSeries.SeriesName, TVSeries.ServiceID, Movies.MovieName,Movies.ServiceID 
FROM Movies 
FULL JOIN TVSeries  
ON Movies.ServiceID = TVSeries.ServiceID  
ORDER BY Movies.ServiceID;

/*
Q5.
    Purpose: Select all the movies and tv shows whose movie rating
             is greater than the movie 'Bird Box' OR whose tv rating
             is greater than the tvseries 'Stranger Things'.
    Summary: Returns a single column list of attributes 'TopMoviesAndTV' 
             containing all movies and tv shows greater than 'Bird Box' 
             or 'Stranger Things'.
    Expected Values: 
    TOPMOVIESANDTV
    Bird Box
    Elephant Queen
    Revenge
    Miniverse
    Annihilation
    Manchester by the Sea
    Stranger Things
    Madalorian
    Young Justice
    Cobra Kai
    Watchmen
*/
SELECT MovieName as TopMoviesAndTV 
FROM Movies 
WHERE RottenTomatoRating >= (SELECT RottenTomatoRating 
                      	     FROM Movies 
                          	 WHERE MovieName = 'Bird Box') 
UNION ALL 
SELECT SeriesName 
FROM TVSeries 
WHERE RottenTomatoRating >= (SELECT RottenTomatoRating 
                  	         FROM TVSeries 
                             WHERE SeriesName = 'Stranger Things');


/*
Q6.
    Purpose: Select the service name, price, subscription plan 
             and resolution based on monthly 'M' plans only.
    
    Summary: Returns the n-tuple rows from the Bundles table
             having monthly 'M' plans only.
    Expected Values:
        SERVICENAME	PRICE	MONTHLYANNUAL	RESOLUTION
        Crackle	    0   	M	            HD
        Shudder 	4.75	M	            HD
        Apple TV+	4.99	M	            UHD
        Shudder 	5.99	M	            HD
        Hulu	    5.99	M           	HD
        Disney+	    6.99	M           	UHD
        DC Universe	7.99	M	            HD
        Netflix	    8.99	M           	SD
        Amazon Prime	8.99	M	        HD
        YouTube Premium	11.99	M	        HD
        Hulu	    11.99	M	            HD
        Netflix	    12.99	M	            HD
        HBO Max	    14.99	M           	UHD
        Netflix	    15.99	M           	UHD
        Curiosity Stream	19.99	M   	HD
        Hulu    	54.99	M           	4K
        Hulu    	60.99	M           	4K

*/
SELECT Services.ServiceName, Bundles.Price, Bundles.MonthlyAnnual , Bundles.Resolution
FROM Services, Bundles 
WHERE Bundles.MonthlyAnnual = 'M' 
AND Bundles.ServiceID = Services.ServiceID 
ORDER BY Bundles.Price;


/*
Q7.
    Purpose: Select the service provider's name and movie name
             that corresponds to the genre 'Horror'
    Summary: Returns two tuples containing the service name and
             movie name categorized under 'Horror'
    Expected Value: Netflix	Bird=Box, Shudder=Revenge
*/
SELECT Services.ServiceName, Movies.MovieName 
FROM Services, Movies 
WHERE Movies.ServiceID = Services.ServiceID 
AND Movies.Genre LIKE '%Horror%';


/*
Q8.
    Purpose: Select the person, role, cast and crew and movie
             belonging to the cast crew id '1'
    Summary: Returns the n-tuple row of person, roles, castcrew and movie
             that are featured with the cast crew id value '1'.
    Expected Value: Susanne	Bier	Director	    1	Bird Box
                     Sandra	    Bullock	Actor	    1	Bird Box
*/

Select person.firstName, person.lastName, roles.rolename, castcrew.castcrewID, movies.movieName
from person 
join roles 
on person.personID = roles.personID 
join castcrew 
on castcrew.castcrewID = roles.castcrewID 
join movies 
on movies.castcrewID = castcrew.castcrewID 
where castcrew.castcrewID = (select movies.castcrewID 
                            from movies 
                            where movies.movieID =1) ;

/*
Q9.
    Purpose: Select any tv show having more episodes than
             the tv show 'Stranger Things'
    Summary: Returns a single column of tv series names
             who has more episodes than 'Stranger Things'
    Expected Value: Young Justice
                    Game of Thrones
                    The Handmaids Tale

*/
SELECT TVSeries.SeriesName 
FROM TVSeries 
WHERE NumberOfEpisodes > ANY (SELECT NumberOfEpisodes 
                              FROM TVSeries 
                              WHERE SeriesName = 'Stranger Things');

/*
Updates the number of seasons and episodes for TVSeries 'Young Justice'  
*/
UPDATE TVSeries 
SET NumberOfSeasons = 4, NumberOfEpisodes = 98 
WHERE SeriesName = 'Young Justice';

/*
Q10.
    Purpose: Select the following movie attributes that are
             featured in 'Netflix' (ServiceID = 1)
    Summary: Returns n-tuples of original movies that are found in
             'Netflix'
    Expected Value: 
    MOVIENAME	GENRE	MOVIELENGTH	STUDIO	    RELEASEDATE	RESOLUTION	ROTTENTOMATORATING	USERRATING
    Bird Box	Horror	124	Bluegrass Films	    12-NOV-18	 - 	        63	                   - 
    Tall Girl	Comedy	102	Wonderland Sound...	13-SEP-19	 - 	        44	                   - 


*/
SELECT MovieName, Genre, MovieLength, Studio, ReleaseDate, Resolution, RottenTomatorating, UserRating 
FROM Movies 
WHERE ServiceID =1;