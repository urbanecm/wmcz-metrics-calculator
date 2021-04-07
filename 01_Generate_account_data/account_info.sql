-- This query gets user_tenure in second and gender for each user in the user table
-- For the purpose of this repository, it is supposed to run at cswiki's database
SELECT
	user_name,
	UNIX_TIMESTAMP() - UNIX_TIMESTAMP(user_registration) AS user_tenure,
	user_editcount,
	up_value AS gender
FROM user
-- This join might sound scary from privacy perspective: this field is available on the public replicas
-- and is therefore in public knowledge.
LEFT JOIN (SELECT *
FROM user_properties
WHERE up_property="gender") AS genders
ON user_id=up_user;
