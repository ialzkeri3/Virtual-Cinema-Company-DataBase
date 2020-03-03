DROP DATABASE IF EXISTS atlmovie;
CREATE DATABASE atlmovie;
USE atlmovie;

-- All users, including employees (admins and managers), customers, and regular users
CREATE TABLE user (
  username VARCHAR(20) PRIMARY KEY NOT NULL,
  STATUS enum ('Pending','Approved','Declined') NOT NULL DEFAULT 'Pending',
  password VARCHAR(20) NOT NULL,
  firstname VARCHAR(16) NOT NULL,
  lastname VARCHAR(16) NOT NULL
);

-- Customers have one to five credit cards
CREATE TABLE creditcard (
  creditcardnum CHAR(16) PRIMARY KEY NOT NULL,
  customer VARCHAR(20) NOT NULL,

  FOREIGN KEY (customer) REFERENCES user(username)
  ON UPDATE CASCADE ON DELETE CASCADE
);

-- Movie: name/releasedate combination is unique/primary key
CREATE TABLE movie (
  moviename VARCHAR(40) NOT NULL,
  releasedate DATE NOT NULL,
  duration INT NOT NULL,

  PRIMARY KEY (moviename,releasedate)
);

-- Company: just a list of unique company names, pre-populated
CREATE TABLE company(
  compname VARCHAR(20) PRIMARY KEY NOT NULL
);

-- Managers are a type of user with an address, must work for a company, permitted to manage a theater
CREATE TABLE manager(
  username VARCHAR(20) PRIMARY KEY NOT NULL,
  compname VARCHAR(20) NOT NULL,
  street VARCHAR(30) NOT NULL,
  city VARCHAR(20) NOT NULL,
  state enum ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA',
    'HI','ID','IL','IN','IA','KS','KY','LA','ME','MD',
    'MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
    'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC',
    'SD','TN','TX','UT','VT','VA','WA','WV','WI','WY') NOT NULL,
  zipcode CHAR(5) NOT NULL,

  unique (street, city, state, zipcode),
  FOREIGN KEY (compname) REFERENCES company(compname)
  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Theaters are run by a manager and belong to that manager's company
CREATE TABLE theater(
  theatername VARCHAR(20) NOT NULL,
  compname VARCHAR(20) NOT NULL,
  manager VARCHAR(20) NOT NULL,
  street VARCHAR(30) NOT NULL,
  city VARCHAR(20) NOT NULL,
  state enum ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA',
    'HI','ID','IL','IN','IA','KS','KY','LA','ME','MD',
    'MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
    'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC',
    'SD','TN','TX','UT','VT','VA','WA','WV','WI','WY') NOT NULL,
  zipcode CHAR(5) NOT NULL,
  capacity INT NOT NULL,

  PRIMARY KEY (theatername,compname),
  FOREIGN KEY (compname) REFERENCES manager(compname),
  ON UPDATE CASCADE ON DELETE RESTRICT
  FOREIGN KEY (manager) REFERENCES manager(username)
  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Movie play is one showing of one movie at one theater on one date
CREATE TABLE movieplay(
  moviename VARCHAR(40) NOT NULL,
  releasedate DATE NOT NULL,
  theatername VARCHAR(20) NOT NULL,
  compname VARCHAR(20) NOT NULL,
  playdate DATE NOT NULL,

  PRIMARY KEY (moviename, releasedate, theatername, compname, playdate),
  FOREIGN KEY (moviename,releasedate) REFERENCES movie(moviename,releasedate),
  ON UPDATE CASCADE ON DELETE RESTRICT
  FOREIGN KEY (theatername,compname) REFERENCES theater(theatername,compname)
  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Movie view is a customer's paying for a particular movie play
CREATE TABLE movieview(
  moviename VARCHAR(40) NOT NULL,
  releasedate DATE NOT NULL,
  theatername VARCHAR(20) NOT NULL,
  compname VARCHAR(20) NOT NULL,
  playdate DATE NOT NULL,
  creditcardnum CHAR(16) NOT NULL,

  PRIMARY KEY (moviename, releasedate, theatername, compname, playdate, creditcardnum),
  FOREIGN KEY (moviename, releasedate, theatername, compname, playdate) REFERENCES movieplay(moviename, releasedate, theatername, compname, playdate),
  ON UPDATE CASCADE ON DELETE RESTRICT
  FOREIGN KEY (creditcardnum) REFERENCES creditcard(creditcardnum)
  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Theater visit is a user's visit to a theater on a particular date
CREATE TABLE theatervisit(
  visitid INT PRIMARY KEY auto_increment,
  theatername VARCHAR(20) NOT NULL,
  compname VARCHAR(20) NOT NULL,
  username VARCHAR(20) NOT NULL,
  visitdate DATE NOT NULL,

  FOREIGN KEY (theatername,compname) REFERENCES theater(theatername,compname),
  ON UPDATE CASCADE ON DELETE RESTRICT
  FOREIGN KEY (username) REFERENCES user(username)
  ON UPDATE CASCADE ON DELETE RESTRICT
);
