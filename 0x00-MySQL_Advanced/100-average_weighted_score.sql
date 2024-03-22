-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

-- Change the delimiter to allow the creation of the stored procedure
DELIMITER $$

-- Create the stored procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUser (user_id INT)
BEGIN
    DECLARE total_weighted_score FLOAT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;

    -- Calculate the total weighted score for the user
    SELECT SUM(corr.score * proj.weight)
    INTO total_weighted_score
    FROM corrections corr
    INNER JOIN projects proj ON corr.project_id = proj.id
    WHERE corr.user_id = user_id;

    -- Calculate the total weight of projects for the user
    SELECT SUM(proj.weight)
    INTO total_weight
    FROM corrections corr
    INNER JOIN projects proj ON corr.project_id = proj.id
    WHERE corr.user_id = user_id;

    -- Update the average score for the user
    IF total_weight = 0 THEN
        UPDATE users
        SET average_score = 0
        WHERE id = user_id;
    ELSE
        UPDATE users
        SET average_score = total_weighted_score / total_weight
        WHERE id = user_id;
    END IF;
END$$

-- Reset the delimiter
DELIMITER ;
