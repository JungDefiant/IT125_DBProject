
DROP DATABASE IF EXISTS compshooter;
CREATE DATABASE compshooter;

USE compshooter;

CREATE TABLE account_info
(
	player_id			INT				PRIMARY KEY		AUTO_INCREMENT,
    username			VARCHAR(50)		UNIQUE 			NOT NULL,
    enc_pwd				VARCHAR(100)	NOT NULL,
    email				VARCHAR(50)		UNIQUE 			NOT NULL
);

CREATE TABLE gameplay_stats
(
	player_id			INT				PRIMARY KEY		NOT NULL,
    total_kills			INT,
    total_deaths		INT,
    total_assists		INT,
    win_rate			DECIMAL(3, 1),
    avg_accuracy		DECIMAL(3, 1),
    fave_weapon			VARCHAR(50),
    CONSTRAINT gameplaystats_fk_accountinfo
		FOREIGN KEY (player_id)
		REFERENCES account_info (player_id)
);

CREATE TABLE wallet
(
	player_id			INT				PRIMARY KEY		NOT NULL,
    play_currency 		INT,
    premium_currency	INT,
    CONSTRAINT wallet_fk_accountinfo
		FOREIGN KEY (player_id)
		REFERENCES account_info (player_id)
);

CREATE TABLE login_history
(
	player_id			INT				PRIMARY KEY		NOT NULL,
    last_logindate 		DATE,
    last_logoutdate		DATE,
    CONSTRAINT loginhistory_fk_accountinfo
		FOREIGN KEY (player_id)
		REFERENCES account_info (player_id)
);

CREATE TABLE microtransaction_record
(
	id					INT				PRIMARY KEY		AUTO_INCREMENT,		
	player_id			INT				NOT NULL,
    time_of_purchase 	DATETIME,
    amount				INT,
    currency_type		VARCHAR(50),
    item_id				VARCHAR(50),
    CONSTRAINT microtransaction_fk_accountinfo
		FOREIGN KEY (player_id)
		REFERENCES account_info (player_id)
);

CREATE TABLE match_history
(
	id					INT				PRIMARY KEY		AUTO_INCREMENT,		
	player_id			INT				NOT NULL,
    time_started	 	TIME,
    time_ended			TIME,
    match_length		DOUBLE,
    chat_log			LONGTEXT,
    CONSTRAINT matchhistory_fk_accountinfo
		FOREIGN KEY (player_id)
		REFERENCES account_info (player_id)
);

CREATE TABLE user_report
(
	id					INT				PRIMARY KEY		AUTO_INCREMENT,		
    reporting_player_id	INT				NOT NULL,
    reported_player_id	INT				NOT NULL,
    report_category		VARCHAR(50),
	report_reason		LONGTEXT,
    CONSTRAINT userreport_reporting_fk_accountinfo
		FOREIGN KEY (reporting_player_id)
		REFERENCES account_info (player_id),
	CONSTRAINT userreport_reported_fk_accountinfo
		FOREIGN KEY (reported_player_id)
		REFERENCES account_info (player_id)
);