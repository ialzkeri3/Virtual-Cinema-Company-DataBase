use atlmovie;


insert into user values
    ('aandrews3',
    'Approved',
    'mypassword',
    'Aaron',
    'Andrews',
    'Customer_Only'),

    ('bbrown3',
    'Approved',
    'mypassword',
    'Beth',
    'Brown',
    'Manager_Customer');

insert into company values ('A Company');

insert into movie values ('A Movie',20191214,91);

insert into manager values
    ('bbrown3',
    'A Company',
    '23 Main St',
    'Birmingham',
    'AL',
    00000);

insert into creditcard values
    (1234123412341234,
    'aandrews3');

insert into theater values
    ('A Theater',
    'A Company',
    'bbrown3',
    '24 Main St',
    'Birmingham',
    'AL',
    00000,
    40);

insert into movieplay values
    ('A Movie',
    20191214,
    'A Theater',
    'A Company',
    20191214);

insert into movieview values
    ('A Movie',
    20191214,
    'A Theater',
    'A Company',
    20191214,
    1234123412341234);

insert into theatervisit values
    (4,
    'A Theater',
    'A Company',
    'aandrews3',
    20191213);

