# **Competitive Shooter Database**

This is a MySQL Database project simulating the database of a user profile system in a competitive shooter.

## Purpose

The purpose of this database is to store information related to user accounts and track information related to user information, including player reports, store transactions, and statistics related to gameplay.

## Technologies Used
MySQL, OpenOffice Calc, Mockaroo

## How To Run SQL Scripts
1. Open sql folder
2. Open MySQL Workbench and open server instance.
3. Navigate to File > Run SQL Script...
4. Select create_db_compshooter.sql in the sql folder.
5. Click Open, then click Run.
6. Repeat steps 3-5 for sample_data_compshooter.sql THEN query_db_compshooter.sql (the order of execution matters).

## Design Summary

When designing my database, I focused on the most important data table first, in this case AccountInfo, and built out the connections between other tables from there. Wallet, LoginHistory, and GameplayStats are each designed with a 1-to-1 relationship with AccountInfo, since there does not need to be multiple records kept for each of those instances. MicrotransactionRecord has a 1-to-many relationship with AccountInfo because the database needs to store multiple purchases being done by the same player. UserReport has a 1-to-many relationship with AccountInfo because the same player can make multiple reports against other players. 

I found it challenging to get 1-to-1 relationships to display correctly in MySQL. I couldn't find any guidance online on how to set up the relationship correctly; MySQL seems to display a 1-to-many relationship, even though the PK of different tables is a foreign key of AccountInfo with a unique constraint.

## EER Diagram
![EER Diagram of Competitive Shooter Database](./eer/EER_Diagram.png "EER Diagram")

## Key Queries
This section explains key queries and views.

> SELECT id, item_id, amount
> FROM microtransaction_record
> WHERE currency_type = 'Premium' AND amount >= 200000;

This query will find all microtransactions worth 200,000 or more of the Premium currency. The purpose of this query is to find store items in a microtransaction shop that sell well.

> SELECT ac.username, COUNT(*) AS total_reports
> FROM account_info ac
> JOIN user_report ur
> 	ON ac.player_id = ur.reported_player_id
> GROUP BY ac.username
> ORDER BY ac.username;

This query will find how many reports have been submitted for each player. The purpose of this query is to track players that receive a lot of reports and may need to be temporarily suspended.

> SELECT ac.username, 
> 	SUM(mh.match_length) AS total_playtime, 
>     ROUND((SUM(total_kills) + (SUM(total_assists) * 0.5)) / SUM(total_deaths), 2) AS avg_kda
> FROM account_info ac
> JOIN match_history mh
> 	USING(player_id)
> JOIN gameplay_stats gs
> 	USING(player_id)
> GROUP BY ac.username
> ORDER BY ac.username;

This query will find the total playtime and average KDA ratios for each player. The purpose of this query is to provide data that players may view in their stats accessed through the game or a game data aggregator website.

> SELECT ac.username, gs.avg_accuracy, COUNT(*) AS total_games
> FROM account_info ac
> JOIN gameplay_stats gs
> 	USING(player_id)
> JOIN match_history mh
> 	USING(player_id)
> WHERE avg_accuracy > 50
> GROUP BY ac.username
> HAVING total_games >= 2
> ORDER BY ac.username;

This query will find players with more than 50% average accuracy with a total of 2 or more games. The purpose of this query is to track strange patterns in player data, such as to track down accounts using cheats, or to find data on high performing players.

> CREATE VIEW player_totalpremiumspent AS
> SELECT ac.username, wl.premium_currency, SUM(mc.amount) AS total_spent
> FROM account_info ac
> JOIN microtransaction_record mc
>     USING(player_id)
> JOIN wallet wl
>     USING(player_id)
> WHERE mc.currency_type = 'Premium'
> GROUP BY ac.username
> ORDER BY ac.username;

This query will find the total Premium currency spent and current Premium currency for each player. The purpose of this query is to help players track spending habits, so that they can make better decisions how much they want to spend.

-- VIEW: Total KDA by player
> CREATE VIEW player_kda AS
> SELECT ac.username, ROUND((SUM(gs.total_kills) + (SUM(gs.total_assists) * 0.5)) / SUM(gs.total_deaths), 2) AS avg_kda
> FROM account_info ac
> JOIN gameplay_stats gs
>     USING(player_id)
> GROUP BY ac.username
> ORDER BY ac.username;

This query will find the total KDA for each player. The purpose of this query is a quick way to access the KDA ratios of every player, which is a common metric in competitive online games.
