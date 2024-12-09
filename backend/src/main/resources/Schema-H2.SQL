-- Drop tables if they exist
DROP TABLE IF EXISTS authorities;
DROP TABLE IF EXISTS authuser;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS PlayerSeason;
DROP TABLE IF EXISTS TeamSeason;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Season;

-- Season table
CREATE TABLE Season (
                        SeasonYear INT PRIMARY KEY
);

-- Player table
CREATE TABLE Player (
                        PlayerID INT PRIMARY KEY,
                        Position VARCHAR(50),
                        Name VARCHAR(50)
);

-- Team table
CREATE TABLE Team (
                      TeamID INT PRIMARY KEY,
                      TeamName VARCHAR(10) NOT NULL
);

-- TeamSeason table
CREATE TABLE TeamSeason (
                            TeamSeasonID INT,
                            TeamSeasonName VARCHAR(50),
                            TeamSeasonYear INT,
                            FOREIGN KEY (TeamSeasonID) REFERENCES Team(TeamID) ON DELETE CASCADE,
                            FOREIGN KEY (TeamSeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE
);

-- PlayerSeason table
CREATE TABLE PlayerSeason (
                              PlayerID INT,
                              TeamID INT,
                              SeasonYear INT,
                              Salary DOUBLE,
                              WAR DOUBLE,
                              PRIMARY KEY (PlayerID, TeamID, SeasonYear),
                              FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE,
                              FOREIGN KEY (TeamID) REFERENCES Team(TeamID) ON DELETE CASCADE,
                              FOREIGN KEY (SeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE
);

-- Game table
CREATE TABLE Game (
                      GameID INT PRIMARY KEY,
                      GameDate DATE,
                      SeasonYear INT,
                      Attendance INT,
                      HomeTeamID INT,
                      AwayTeamID INT,
                      HomeTeamStanding INT,
                      AwayTeamStanding INT,
                      FOREIGN KEY (SeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE,
                      FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID) ON DELETE CASCADE,
                      FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID) ON DELETE CASCADE
);

-- PlayerGame table
CREATE TABLE PlayerGame (
                            PlayerID INT,
                            GameID INT,
                            WAR DOUBLE,
                            PRIMARY KEY (PlayerID, GameID),
                            FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE,
                            FOREIGN KEY (GameID) REFERENCES Game(GameID) ON DELETE CASCADE
);

-- Users table (Auth)
CREATE TABLE authuser (
                          username VARCHAR(50) PRIMARY KEY,
                          password VARCHAR(100) NOT NULL,
                          enabled CHAR(1) NOT NULL
);

-- Authorities table (roles Auth)
CREATE TABLE authorities (
                             username VARCHAR(50) NOT NULL,
                             authority VARCHAR(50) NOT NULL,
                             FOREIGN KEY (username) REFERENCES authuser(username),
                             PRIMARY KEY (username, authority)
);