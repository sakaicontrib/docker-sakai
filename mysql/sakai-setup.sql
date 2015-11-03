-- This just creates a DB and a user and grants permissions for that user.
-- Sakai needs UTF-8
CREATE DATABASE `sakai` DEFAULT CHARACTER SET = `utf8`;

-- Create user
CREATE USER 'sakai'@'localhost' IDENTIFIED BY 'sakai';

-- Grant permissions
GRANT ALL PRIVILEGES ON `sakai`.* TO 'sakai'@'%';

