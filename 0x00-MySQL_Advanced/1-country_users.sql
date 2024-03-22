-- Creates a table users with attributes
CREATE TABLE IF NOT EXISTS users (id INT NOT NULL AUTO_INCREMENT,
	email VARCHAR(255) NOT NULL UNIQUE,
	name VARCHAR(255),
	country VARCHAR(2) DEFAULT 'US' NOT NULL, CONSTRAINT chk_Country CHECK (country in ('US', 'CO', 'TN')),
	PRIMARY KEY (id)
	);
