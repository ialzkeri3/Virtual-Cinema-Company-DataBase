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
	INSERT INTO user (username, password, firstname, lastname, userType) VALUES (i_username, MD5(i_password), i_firstname, i_lastname, 'Customer');
	INSERT INTO customer (username) VALUES (i_username);
	
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
	ELSE IF NOT length(i_creditCardNum)=16 THEN
		SIGNAL SQLSTATE '45000' SET message_text='Invalid creditCard';
    ELSE 
		INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
	END IF;
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
	Insert INTO user(username, password, firstName, lastName, userType) VALUES (i_username, md5(i_password), i_firstname, i_lastname, 'Employee');
	Insert INTO employee(username) VALUES (i_username);
	INSERT INTO Manager(username, comNAME, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);

END$$
DELIMITER ;

--
-- Screen 5: Manager Only Register
--

DROP PROCEDURE IF EXISTS manager_customer_register;
DELIMITER $$
CREATE PROCEDURE `manager_customer_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
	INSERT INTO user(username, password, firstName, lastName, userType) VALUES (i_username, md5(i_password), i_firstname, i_lastname, 'Employee, Customer');
    INSERT INTO employee(username) VALUES (i_username);
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
	IF (i_username, 5) IN (SELECT username, COUNT(*) as cardcount FROM customercreditcard GROUP BY username HAVING cardcount>4) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Maximum creditcards registered';
	ELSE
		INSERT INTO customercreditcard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
	END IF;
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
	IF 'Approved' = (SELECT status FROM user WHERE username=i_username) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This User Has Already Been Approved';
	ELSE
		UPDATE user SET status='Declined' WHERE username=i_username;
	END IF;
END$$
DELIMITER ;
--
-- Admin Decline User
--
DROP PROCEDURE IF EXISTS admin_filter_user;
DELIMITER $$
CREATE PROCEDURE `admin_filter_user`(i_username VARCHAR(50), i_status ENUM('ALL','Approved', 'Pending', 'Declined'), i_sortBy ENUM('','username', 'creditCardCount', 'userType', 'status'), i_sortDirection ENUM('','DESC', 'ASC'))
BEGIN
	IF NOT i_sortBy='creditCardCount' THEN
		DROP TABLE IF EXISTS AdFilterUser;
		CREATE TABLE AdFilterUser
		SELECT user.username, count(creditCardNum) as creditCardCount,CONCAT(IF(customer.username IS NOT NULL AND employee.username IS NOT NULL, 'CustomerManager',''),IF(customer.username IS NOT NULL AND employee.username IS NULL AND admin.username IS NULL, 'Customer',''),IF(customer.username IS NOT NULL AND admin.username IS NOT NULL, 'CustomerAdmin',''),IF(user.userType='User', 'User',''),IF(customer.username IS NULL AND employee.username IS NOT NULL, 'Manager',''),IF(customer.username IS NULL AND admin.username IS NOT NULL, 'Admin','')) AS userType, status 
		FROM user LEFT JOIN customercreditcard on user.username=customercreditcard.username LEFT JOIN employee ON user.username=employee.username LEFT JOIN admin ON user.username=admin.username LEFT JOIN customer ON user.username=customer.username		
        WHERE (i_username='' OR user.username=i_username) AND (i_status='ALL' OR status=i_status)
		GROUP BY user.username 
		ORDER BY (CASE WHEN (i_sortBy='' AND i_sortDirection='') THEN user.username END) DESC,
				 (CASE WHEN (i_sortBy='' AND i_sortDirection='ASC') THEN user.username END) ASC,
				 (CASE WHEN (i_sortBy='' AND i_sortDirection='DESC') THEN user.username END) DESC,
				 (CASE WHEN (i_sortBy='username' AND i_sortDirection='') THEN user.username END) DESC,
				 (CASE WHEN (i_sortBy='username' AND i_sortDirection='ASC') THEN user.username END) ASC,
				 (CASE WHEN (i_sortBy='username' AND i_sortDirection='DESC') THEN user.username END) DESC,
				 (CASE WHEN (i_sortBy='userType' AND i_sortDirection='') THEN userType END) DESC,
				 (CASE WHEN (i_sortBy='userType' AND i_sortDirection='ASC') THEN userType END) ASC,
				 (CASE WHEN (i_sortBy='userType' AND i_sortDirection='DESC') THEN userType END) DESC,
				 (CASE WHEN (i_sortBy='status' AND i_sortDirection='') THEN status END) DESC,
				 (CASE WHEN (i_sortBy='status' AND i_sortDirection='ASC') THEN status END) ASC,
				 (CASE WHEN (i_sortBy='status' AND i_sortDirection='DESC') THEN status END) DESC;
	ELSE IF i_sortBy='creditCardCount' AND (i_sortDirection='' OR i_sortDirection='DESC') THEN
		DROP TABLE IF EXISTS AdFilterUser;
		CREATE TABLE AdFilterUser
		SELECT user.username, count(creditCardNum) as creditCardCount,CONCAT(IF(customer.username IS NOT NULL AND employee.username IS NOT NULL, 'CustomerManager',''),IF(customer.username IS NOT NULL AND employee.username IS NULL AND admin.username IS NULL, 'Customer',''),IF(customer.username IS NOT NULL AND admin.username IS NOT NULL, 'CustomerAdmin',''),IF(user.userType='User', 'User',''),IF(customer.username IS NULL AND employee.username IS NOT NULL, 'Manager',''),IF(customer.username IS NULL AND admin.username IS NOT NULL, 'Admin','')) AS userType, status 
		FROM user LEFT JOIN customercreditcard on user.username=customercreditcard.username LEFT JOIN employee ON user.username=employee.username LEFT JOIN admin ON user.username=admin.username LEFT JOIN customer ON user.username=customer.username		
		WHERE (i_username='' OR user.username=i_username) AND (status=IF(i_status='ALL', status , i_status))
		GROUP BY user.username 
        ORDER BY creditCardCount DESC;
	ELSE 
		DROP TABLE IF EXISTS AdFilterUser;
		CREATE TABLE AdFilterUser
		SELECT user.username, count(creditCardNum) as creditCardCount,CONCAT(IF(customer.username IS NOT NULL AND employee.username IS NOT NULL, 'CustomerManager',''),IF(customer.username IS NOT NULL AND employee.username IS NULL AND admin.username IS NULL, 'Customer',''),IF(customer.username IS NOT NULL AND admin.username IS NOT NULL, 'CustomerAdmin',''),IF(user.userType='User', 'User',''),IF(customer.username IS NULL AND employee.username IS NOT NULL, 'Manager',''),IF(customer.username IS NULL AND admin.username IS NOT NULL, 'Admin','')) AS userType, status 
		FROM user LEFT JOIN customercreditcard on user.username=customercreditcard.username LEFT JOIN employee ON user.username=employee.username LEFT JOIN admin ON user.username=admin.username LEFT JOIN customer ON user.username=customer.username		
		WHERE (i_username='' OR user.username=i_username) AND (status=IF(i_status='ALL', status , i_status))
		GROUP BY user.username 
        ORDER BY creditCardCount ASC;
	END IF;
    END IF;
END$$
DELIMITER ;
--
-- Admin Filter User
--
DROP PROCEDURE IF EXISTS admin_filter_company;
DELIMITER $$
CREATE PROCEDURE `admin_filter_company`(i_comName VARCHAR(50), i_minCity INT(11), i_maxCity INT(11), i_minTheater INT(11), i_maxTheater INT(11), i_minEmployee INT(11), i_maxEmployee INT(11), i_sortBy ENUM('','comName', 'numCityCover', 'numTheater', 'numEmployee'),  i_sortDirection ENUM('','DESC', 'ASC'))
BEGIN	
	DROP TABLE IF EXISTS AdFilterCom;
	IF NOT (i_sortBy='NumCityCover' OR i_sortBy='NumTheater' OR i_sortBy='NumEmployee') THEN    
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY (CASE WHEN (i_sortBy='' AND i_sortDirection='') THEN comName END) DESC,
				 (CASE WHEN (i_sortBy='' AND i_sortDirection='ASC') THEN comName END) ASC,
				 (CASE WHEN (i_sortBy='' AND i_sortDirection='DESC') THEN comName END) DESC,
				 (CASE WHEN (i_sortBy='comName' AND i_sortDirection='') THEN comName END) DESC,
				 (CASE WHEN (i_sortBy='comName' AND i_sortDirection='ASC') THEN comName END) ASC,
				 (CASE WHEN (i_sortBy='comName' AND i_sortDirection='DESC') THEN comName END) DESC;
	ELSE IF i_sortBy='NumCityCover' AND (i_sortDirection='' or i_sortDirection='DESC') THEN
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumCityCover DESC;
	ELSE IF i_sortBy='NumCityCover' AND (i_sortDirection='ASC') THEN
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumCityCover ASC;
	ELSE IF i_sortBy='NumTheater' AND (i_sortDirection='' or i_sortDirection='DESC') THEN
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumTheater DESC;
	ELSE IF i_sortBy='NumTheater' AND (i_sortDirection='ASC') THEN
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumTheater ASC;
	ELSE IF i_sortBy='NumEmployee' AND (i_sortDirection='' or i_sortDirection='DESC') THEN
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumEmployee DESC;
	ELSE
		CREATE TABLE AdFilterCom
		SELECT comName, COUNT(DISTINCT(thCity)) as NumCityCover, COUNT(DISTINCT(thStreet)) as NumTheater, COUNT(DISTINCT(username)) as NumEmployee
		FROM manager NATURAL JOIN theater
		GROUP BY comName
		HAVING 
			(i_comName='ALL' OR i_comName='' OR comName=i_comName) AND
			(i_minCity IS NULL OR i_minCity<=NumCityCover) AND
			(i_maxCity IS NULL OR i_maxCity>=NumCityCover) AND
			(i_minTheater IS NULL OR i_minTheater<=NumTheater) AND
			(i_maxTheater IS NULL OR i_maxTheater>=NumTheater) AND
			(i_minEmployee IS NULL OR i_minEmployee<=NumEmployee) AND
			(i_maxEmployee IS NULL OR i_maxEmployee>=NumEmployee)
		ORDER BY NumEmployee ASC;
	END IF; 
    END IF; 
    END IF;
    END IF;
    END IF;
    END IF;
END$$
DELIMITER ;   
--
-- Manger Filter Company
-- 
DROP PROCEDURE IF EXISTS admin_create_theater;
DELIMITER $$
CREATE PROCEDURE `admin_create_theater`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_thStreet VARCHAR(50), IN i_thCity VARCHAR(50), IN i_thState CHAR(2), IN i_thZipcode CHAR(5), IN i_capacity INT(11), IN i_managerusername VARCHAR(50))
BEGIN
	IF i_thName IN (SELECT thName FROM theater WHERE comName=i_comName) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This Company Already Has A Theater With This Name';
	ELSE IF i_managerusername NOT IN (SELECT username FROM employee) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This Manager Is Not Registered';
	ELSE IF (i_managerusername, 1) IN (SELECT manUsername, COUNT(manUsername) from theater GROUP BY manUsername) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This Manager Already Manages a Theater';
	ELSE
		INSERT INTO theater(thName, comName, capacity, thStreet, thCity, thState, thZipCode, manUsername) VALUES (i_thName, i_comName, i_capacity, i_thStreet, i_thCity, i_thState, i_thZipcode, i_managerusername);
    END IF;
    END IF;
    END IF;
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
	SELECT firstName AS empFirstname, lastName AS empLastname FROM user JOIN manager USING (username)
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
	SELECT thName, manUsername as thManagerUsername, thCity, thState, capacity AS thCapacity FROM theater
    WHERE comName=i_comName;
END$$
DELIMITER ;
--
-- Admin View Company Detail (TH)
--
DROP PROCEDURE IF EXISTS manager_filter_th;
DELIMITER $$
CREATE PROCEDURE `manager_filter_th`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_minMovDuration INT(11), IN i_maxMovDuration INT(11), IN i_minMovReleaseDate DATE, IN i_maxMovReleaseDate DATE, IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE, IN i_includeNotPlayed BOOLEAN)
BEGIN
	DROP TABLE IF EXISTS ManFilterTh;
    IF i_includeNotPlayed IS TRUE THEN
		CREATE TABLE ManFilterTh
		SELECT movName, duration as movDuration, movReleaseDate, movPlayDate
		FROM movie JOIN theater LEFT JOIN movieplay USING (thName, movName, comName, movReleaseDate)		
        WHERE 
			(manUsername=i_manUsername) AND
			(i_movName='' OR movName=i_movName) AND
			(i_minMovDuration IS NULL OR i_minMovDuration<=duration) AND
			(i_maxMovDuration IS NULL OR i_maxMovDuration>=duration) AND
			(i_minMovReleaseDate IS NULL OR i_minMovReleaseDate<=movReleaseDate) AND
			(i_maxMovReleaseDate IS NULL OR i_maxMovReleaseDate>=movReleaseDate) AND
			(i_minMovPlayDate IS NULL OR i_minMovPlayDate<=movPlayDate) AND
			(i_maxMovPlayDate IS NULL OR i_maxMovPlayDate>=movPlayDate) AND
            (movPlayDate IS NULL);
    ELSE
		CREATE TABLE ManFilterTh
		SELECT movName, duration as movDuration, movReleaseDate, movPlayDate
		FROM movie JOIN theater LEFT JOIN movieplay USING (thName, movName, comName, movReleaseDate)		
		WHERE 
			(manUsername=i_manUsername) AND 
			(i_movName='' OR movName=i_movName) AND
			(i_minMovDuration IS NULL OR i_minMovDuration<=duration) AND
			(i_maxMovDuration IS NULL OR i_maxMovDuration>=duration) AND
			(i_minMovReleaseDate IS NULL OR i_minMovReleaseDate<=movReleaseDate) AND
			(i_maxMovReleaseDate IS NULL OR i_maxMovReleaseDate>=movReleaseDate) AND
			(i_minMovPlayDate IS NULL OR i_minMovPlayDate<=movPlayDate) AND
			(i_maxMovPlayDate IS NULL OR i_maxMovPlayDate>=movPlayDate);
	END IF;
END$$
DELIMITER ;
--
-- Manager Filter Theater
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
    FROM movieplay JOIN theater USING (thName, comName)
    WHERE 
		(i_movName='ALL' OR movName=i_movName) AND 
        (i_comName='ALL' OR theater.comName=i_comName) AND
        (i_city='' OR thCity=i_city) AND
        (i_state='' OR i_state='ALL' OR thState=i_state) AND
        (i_minMovPlayDate IS NULL OR i_minMovPlayDate<=movPlayDate) AND
        (i_maxMovPlayDate IS NULL OR i_maxMovPlayDate>=movPlayDate);
END$$
DELIMITER ;
--
-- Customer Filter Movie
--
DROP PROCEDURE IF EXISTS customer_view_mov;
DELIMITER $$
CREATE PROCEDURE `customer_view_mov`(IN i_creditCardNum CHAR(16), IN i_movName VARCHAR(50), i_movReleaseDate DATE,i_thName VARCHAR(50), i_comName VARCHAR(50), i_movPlayDate DATE)
BEGIN
	IF (i_movPlayDate, 3) IN (select movPlayDate, count(username) AS daycount From customerviewmovie JOIN customercreditcard USING (creditCardNum) WHERE username=(select username from customercreditcard WHERE creditCardNum=i_creditCardNum) GROUP BY movPlayDate HAVING daycount>2) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'Already Viewed Three Movies This Day';
    ELSE IF i_movReleaseDate>=i_movPlayDate THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'PlayDate Before ReleaseDate';
	ELSE
		INSERT INTO customerviewmovie(creditCardNum, thName, comName,movName, movRealeaseDate, movPlayDate) VALUES(i_creditCardNum, i_thName, i_comName, i_movName, i_movReleaseDate, i_movPlayDate);
	END IF;
    END IF;
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS customer_view_history;
DELIMITER $$
CREATE PROCEDURE `customer_view_history`(IN i_cusUsername VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS CosViewHistory;
    CREATE TABLE CosViewHistory
	SELECT movName, thName, comName, creditCardNum, movPlayDate FROM customercreditcard JOIN customerviewmovie USING (creditCardNum)
    WHERE username=i_cusUsername;
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS user_filter_th;
DELIMITER $$
CREATE PROCEDURE `user_filter_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3))
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
	SELECT thName, thStreet, thCity, thState, thZipcode, comName 
    FROM Theater
    WHERE 
		(thName = i_thName OR i_thName = "ALL") AND
        (comName = i_comName OR i_comName = "ALL") AND
        (thCity = i_city OR i_city = "") AND
        (thState = i_state OR i_state='ALL' OR i_state = "");
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_visit_th;
DELIMITER $$
CREATE PROCEDURE `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
BEGIN
    INSERT INTO uservisittheater (thName, comName, visitDate, username, visitID)
    SELECT i_thName, i_comName, i_visitDate, i_username, COUNT(*)+1 FROM uservisittheater;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_filter_visitHistory;
DELIMITER $$
CREATE PROCEDURE `user_filter_visitHistory`(IN i_username VARCHAR(50), IN i_minVisitDate DATE, IN i_maxVisitDate DATE)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
	SELECT thName, thStreet, thCity, thState, thZipCode, comName, visitDate
    FROM uservisittheater
		NATURAL JOIN
        theater
	WHERE
		(username = i_username) AND
        (i_minVisitDate IS NULL OR visitDate >= i_minVisitDate) AND
        (i_maxVisitDate IS NULL OR visitDate <= i_maxVisitDate);
END$$
DELIMITER ;