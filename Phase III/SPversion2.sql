USE atlmovie;
DROP PROCEDURE IF EXISTS user_login;
DELIMITER $$
CREATE PROCEDURE `user_login`(IN i_username VARCHAR(50), IN i_password VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS UserLogin;
    CREATE TABLE UserLogin
	SELECT user.username, user.status, IF(user.userType in ('Customer','Employee, Customer'), 1, 0) as isCustomer, IF(user.username in (Admin.username), 1, 0) as isAdmin, IF(user.username in (Manager.username), 1, 0) as isManager
    FROM user LEFT JOIN Manager on user.username=manager.username LEFT JOIN Admin on user.username=Admin.username
    WHERE 
		(user.username = i_username) AND
        (user.password = i_password);
END$$
DELIMITER ;

--
-- Screen 1:User_Login
--

DROP PROCEDURE IF EXISTS user_register;
DELIMITER $$
CREATE PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname) VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
END$$
DELIMITER ;

--
-- Screen 3: User Register (Provided)
--

DROP PROCEDURE IF EXISTS customer_only_register;
DELIMITER $$
CREATE PROCEDURE `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
	INSERT INTO customer (username) VALUES (i_username);
	INSERT INTO user (username, password, firstname, lastname, userType) VALUES (i_username, MD5(i_password), i_firstname, i_lastname, 'Customer');
END$$
DELIMITER ;

--
-- Screen 4: Customer Only Register
--

DROP PROCEDURE IF EXISTS customer_add_creditcard;
DELIMITER $$
CREATE PROCEDURE `customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
	IF (i_username, 5) IN (SELECT username, COUNT(*) as cardcount FROM customercreditcard GROUP BY username HAVING cardcount>4) THEN
		SIGNAL SQLSTATE '45000' SET Message_Text='Maximum creditcards registered';
	ELSE 
		INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
	END IF;
END$$
DELIMITER ;

--
-- Screen 4: Customer Add Credit Card
--

DROP PROCEDURE IF EXISTS manager_only_register;
DELIMITER $$
CREATE PROCEDURE `manager_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
	IF (i_username, 5) IN (SELECT username, COUNT(*) as cardcount FROM customercreditcard GROUP BY username HAVING cardcount>4) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Maximum creditcards registered';
	ELSE
		INSERT INTO Manager(username, comNAME, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
		Insert INTO user(username, password, firstName, lastName, userType) VALUES (i_username, md5(i_password), i_firstname, i_lastname, 'Employee');
	END IF;
END$$
DELIMITER ;

--
-- Screen 5: Manager Only Register
--

DROP PROCEDURE IF EXISTS manager_customer_register;
DELIMITER $$
CREATE PROCEDURE `manager_customer_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
	INSERT INTO user(username, password, firstName, lastName, userType) VALUES (i_username, md5(i_password), i_firstname, i_lastname, 'Employee');
	INSERT INTO Manager(username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
	INSERT INTO Customer(username) VALUES (i_username);
END$$
DELIMITER ;

--
-- Screen 6: Manager-Customer Register 
--

DROP PROCEDURE IF EXISTS manager_customer_add_creditcard;
DELIMITER $$
CREATE PROCEDURE `manager_customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
	INSERT INTO customercreditcard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
END$$
DELIMITER ;

--
-- Screen 6: Manager-Customer Add Creditcard
--
DROP PROCEDURE IF EXISTS admin_approve_user;
DELIMITER $$
CREATE PROCEDURE `admin_approve_user`(IN i_username VARCHAR(50))
BEGIN
	UPDATE user SET status='Approved' WHERE username=i_username;
END$$
DELIMITER ;
--
-- Admin Approve User
--
DROP PROCEDURE IF EXISTS admin_decline_user;
DELIMITER $$
CREATE PROCEDURE `admin_decline_user`(IN i_username VARCHAR(50))
BEGIN
	UPDATE user SET status='Declined' WHERE username=i_username;
END$$
DELIMITER ;
--
-- Admin Decline User
--
DROP PROCEDURE IF EXISTS admin_filter_user;
DELIMITER $$
CREATE PROCEDURE `admin_filter_user`(i_username VARCHAR(50), i_status ENUM('ALL','Approved', 'Pending', 'Declined'), i_sortBy ENUM('','username', 'creditCardCount', 'userType', 'status'), i_sortDirection ENUM('','DESC', 'ASC'))
BEGIN	
	DROP TABLE IF EXISTS AdFilterUser;
	CREATE TABLE AdFilterUser
	select user.username, count(*) as creditCardCount, userType, status 
	FROM user LEFT JOIN customercreditcard on user.username=customercreditcard.username
    WHERE (i_username='' OR user.username=i_username) AND (status=IF(i_status='ALL', status , i_status))
	GROUP BY user.username 
    ORDER BY (CASE WHEN (i_sortBy='' AND i_sortDirection='') THEN user.username END) DESC,
			 (CASE WHEN (i_sortBy='' AND i_sortDirection='ASC') THEN user.username END) ASC,
             (CASE WHEN (i_sortBy='' AND i_sortDirection='DESC') THEN user.username END) DESC,
             (CASE WHEN (i_sortBy='username' AND i_sortDirection='') THEN user.username END) DESC,
			 (CASE WHEN (i_sortBy='username' AND i_sortDirection='ASC') THEN user.username END) ASC,
             (CASE WHEN (i_sortBy='username' AND i_sortDirection='DESC') THEN user.username END) DESC,
             (CASE WHEN (i_sortBy='creditCardCount' AND i_sortDirection='') THEN creditCardCount END) DESC,
			 (CASE WHEN (i_sortBy='creditCardCount' AND i_sortDirection='ASC') THEN creditCardCount END) ASC,
             (CASE WHEN (i_sortBy='creditCardCount' AND i_sortDirection='DESC') THEN creditCardCount END) DESC,
             (CASE WHEN (i_sortBy='userType' AND i_sortDirection='') THEN userType END) DESC,
			 (CASE WHEN (i_sortBy='userType' AND i_sortDirection='ASC') THEN userType END) ASC,
             (CASE WHEN (i_sortBy='userType' AND i_sortDirection='DESC') THEN userType END) DESC,
             (CASE WHEN (i_sortBy='status' AND i_sortDirection='') THEN status END) DESC,
			 (CASE WHEN (i_sortBy='status' AND i_sortDirection='ASC') THEN status END) ASC,
             (CASE WHEN (i_sortBy='status' AND i_sortDirection='DESC') THEN status END) DESC;
END$$
DELIMITER ;
--
-- Admin Filter User
--
DROP PROCEDURE IF EXISTS admin_create_theater;
DELIMITER $$
CREATE PROCEDURE `admin_create_theater`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_thStreet VARCHAR(50), IN i_thCity VARCHAR(50), IN i_thState CHAR(2), IN i_thZipcode CHAR(5), IN i_capacity INT(11), IN i_managerusername VARCHAR(50))
BEGIN
	INSERT INTO theater(thName, comName, capacity, thStreet, thCity, thState, thZipCode, manUsername) VALUES (i_thName, i_comName, i_capacity, i_thStreet, i_thCity, i_thState, i_thZipcode, i_managerusername);
END$$
DELIMITER ;
--
-- Admin Create Theater
--
DROP PROCEDURE IF EXISTS admin_view_comDetail_emp;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_emp`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailEmp;
    CREATE TABLE AdComDetailEmp
	SELECT firstName, lastName FROM user JOIN manager USING (username)
    WHERE comName=i_comName;
END$$
DELIMITER ;
--
-- Admin View Company Detail (EMP)
--
DROP PROCEDURE IF EXISTS admin_view_comDetail_th;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_th`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailTh;
    CREATE TABLE AdComDetailTh
	SELECT thName, manUsername, thCity, thState, capacity FROM theater
    WHERE comName=i_comName;
END$$
DELIMITER ;
--
-- Admin View Company Detail (TH)
--
DROP PROCEDURE IF EXISTS admin_create_mov;
DELIMITER $$
CREATE PROCEDURE `admin_create_mov`(IN i_movName VARCHAR(50), IN i_movDuration INT(11), i_movReleaseDate DATE)
BEGIN
	INSERT INTO movie(movName, movReleaseDate, duration) VALUES (i_movName, i_movReleaseDate, i_movDuration);
END$$
DELIMITER ;
--
-- Admin Create Mov
--
DROP PROCEDURE IF EXISTS manager_schedule_mov;
DELIMITER $$
CREATE PROCEDURE `manager_schedule_mov`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), i_movReleaseDate DATE, i_movPlayDate DATE)
BEGIN
	 IF i_movReleaseDate<=i_movPlayDate THEN 
		INSERT INTO movieplay(thName, comName,movName, movReleaseDate, movPlayDate) SELECT thName, comName, i_movName, i_movReleaseDate, i_movPlayDate FROM theater WHERE manUsername=i_manUsername;
	ELSE 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'PlayDate Before ReleaseDate';
	END IF;
END$$
DELIMITER ;
--
-- Manager Schedule Movie
--
DROP PROCEDURE IF EXISTS customer_filter_mov;
DELIMITER $$
CREATE PROCEDURE `customer_filter_mov`(IN i_movName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(50), IN i_minMovPlayDate DATE, i_maxMovPlayDate DATE)
BEGIN
    DROP TABLE IF EXISTS CosFilterMovie;
    CREATE TABLE CosFilterMovie
	SELECT movName, thName, thStreet, thCity, thState, thZipCode, movieplay.comName, movPlayDate, movReleaseDate
    FROM movieplay JOIN theater USING (thName)
    WHERE 
		(movName=i_movName) AND 
        (i_comName='' OR theater.comName=i_comName) AND
        (thCity=i_city) AND
        (thState=i_state) AND
        (i_minMovPlayDate IS NULL OR i_minMovPlayDate<=movPlayDate) AND
        (i_maxMovPlayDate IS NULL OR i_maxMovPlayDate>=movPlayDate);
END$$
DELIMITER ;
--
-- Customer Filter Movie
--