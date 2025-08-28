-- QUERY: Microtransactions worth >= 200000 Premium Currency
SELECT id, item_id, amount
FROM microtransaction_record
WHERE currency_type = 'Premium' AND amount >= 200000;

-- QUERY: Total reports on each player
SELECT ac.username, COUNT(*) AS total_reports
FROM account_info ac
JOIN user_report ur
	ON ac.player_id = ur.reported_player_id
GROUP BY ac.username
ORDER BY ac.username;

-- QUERY: Total playtime and avg kda by player
SELECT ac.username, 
	SUM(mh.match_length) AS total_playtime, 
    ROUND((SUM(total_kills) + (SUM(total_assists) * 0.5)) / SUM(total_deaths), 2) AS avg_kda
FROM account_info ac
JOIN match_history mh
	USING(player_id)
JOIN gameplay_stats gs
	USING(player_id)
GROUP BY ac.username
ORDER BY ac.username;

-- QUERY: Players with more than 50% average accuracy over 2+ games by username
SELECT ac.username, gs.avg_accuracy, COUNT(*) AS total_games
FROM account_info ac
JOIN gameplay_stats gs
	USING(player_id)
JOIN match_history mh
	USING(player_id)
WHERE avg_accuracy > 50
GROUP BY ac.username
HAVING total_games >= 2
ORDER BY ac.username;

-- VIEW: Total Premium currency spent and current premium currency by player
CREATE VIEW player_totalpremiumspent AS
SELECT ac.username, wl.premium_currency, SUM(mc.amount) AS total_spent
FROM account_info ac
JOIN microtransaction_record mc
    USING(player_id)
JOIN wallet wl
    USING(player_id)
WHERE mc.currency_type = 'Premium'
GROUP BY ac.username
ORDER BY ac.username;

-- VIEW: Total KDA by player
CREATE VIEW player_kda AS
SELECT ac.username, ROUND((SUM(gs.total_kills) + (SUM(gs.total_assists) * 0.5)) / SUM(gs.total_deaths), 2) AS avg_kda
FROM account_info ac
JOIN gameplay_stats gs
    USING(player_id)
GROUP BY ac.username
ORDER BY ac.username;
