-- This query gets user_tenure in second and gender for each user in the user table
-- For the purpose of this repository, it is supposed to run at cswiki's database
SELECT
	user_name,
	UNIX_TIMESTAMP() - UNIX_TIMESTAMP(user_registration) AS user_tenure,
	user_editcount
FROM user;
