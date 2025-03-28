CREATE TABLE logins (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password  VARCHAR(100) NOT NULL,
    date_of_joint  DATETIME DEFAULT NOW(),
    PRIMARY KEY(id)

);

INSERT INTO table_name(column3) VALUES (column3_value)

