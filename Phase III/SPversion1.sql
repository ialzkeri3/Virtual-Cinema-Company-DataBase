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
		INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
END$$
DELIMITER ;

--
-- Screen 4: Customer Add Credit Card
--

DROP PROCEDURE IF EXISTS manager_only_register;
DELIMITER $$
CREATE PROCEDURE `manager_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO Manager(username, comNAME, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
        Insert INTO user(username, password, firstName, lastName, userType) VALUES (i_username, md5(i_password), i_firstname, i_lastname, 'Employee');
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
		INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES (i_creditCardNum, i_username);
END$$
DELIMITER ;

--
-- Screen 6: Manager-Customer Add Creditcard
--