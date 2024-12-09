-- Season table
CREATE TABLE Season (
    SeasonYear NUMBER PRIMARY KEY
);

-- Player table
CREATE TABLE Player (
    PlayerID NUMBER PRIMARY KEY,
    Position VARCHAR(50),
    Name VARCHAR(50)
);

-- Team table
CREATE TABLE Team (
    TeamID NUMBER PRIMARY KEY,
    TeamName VARCHAR(10) NOT NULL
);

CREATE TABLE TeamSeason (
    TeamSeasonID NUMBER,
    TeamSeasonName VARCHAR(50),
    TeamSeasonYear NUMBER,
    FOREIGN KEY (TeamSeasonID) REFERENCES Team(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (TeamSeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE
);


-- PlayerSeason table
CREATE TABLE PlayerSeason (
    PlayerID NUMBER,
    TeamID NUMBER,
    SeasonYear NUMBER,
    Salary NUMBER,
    WAR BINARY_DOUBLE,
    PRIMARY KEY (PlayerID, TeamID, SeasonYear),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (SeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE
);

-- Game table
CREATE TABLE Game (
    GameID NUMBER PRIMARY KEY,
    GameDate DATE,
    SeasonYear NUMBER,
    Attendance NUMBER,
    HomeTeamID NUMBER,
    AwayTeamID NUMBER,
    HomeTeamStanding NUMBER,
    AwayTeamStanding NUMBER,
    FOREIGN KEY (SeasonYear) REFERENCES Season(SeasonYear) ON DELETE CASCADE,
    FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID) ON DELETE CASCADE,
    FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID) ON DELETE CASCADE
);

-- PlayerGame table
CREATE TABLE PlayerGame (
    PlayerID NUMBER,
    GameID NUMBER,
    WAR BINARY_DOUBLE,
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
    username VARCHAR2(50) NOT NULL,
    authority VARCHAR2(50) NOT NULL,
    FOREIGN KEY (username) REFERENCES authuser(username),
    PRIMARY KEY (username, authority)
);