grant all privileges on *.* to 'dbuser' @'localhost' identified by 'password';

CREATE DATABASE IF NOT EXISTS production;

use production;

CREATE TABLE `users` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO
    `users` (`first_name`, `last_name`)
VALUES
    ('John', 'Murphy'),
    ('Fred', 'Smith');