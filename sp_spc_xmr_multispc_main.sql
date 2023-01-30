
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Author:			Oliver Hand
-- Created:			30/01/2023 (compiled from code creasted during Covid pandemic)
-- Purpose:			To produce large volumes of SPC data for analysis
-- Usage:			Should work with any mariad / mysql SQL server, will need conversion for MSSQL.
-- Known issues:	None
	
/* 
Basic Usage
Write data into the tb_multispc_input table and run the main stored proedure.  SPC data are generated for all data in the 'field_x' columns, the extra_x columns are 
for data to be ignored IN the SPC process.
*/
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tables required - remember create adatabase to hold the objects and change the database name across the script.

DROP TABLE IF EXISTS 48_multispc.tb_multispc_config;
CREATE TABLE 48_multispc.tb_multispc_config (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`filename` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`orange_is` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`period_to_warn` SMALLINT(6) NULL DEFAULT NULL,
	`period_to_reset_mean` SMALLINT(6) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2;


DROP TABLE IF EXISTS 48_multispc.tb_multispc_input;
CREATE TABLE 48_multispc.tb_multispc_input (
	`ind` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`field_1` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_2` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_3` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_4` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_5` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`period` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`target` FLOAT NULL DEFAULT NULL,
	`value` FLOAT NULL DEFAULT NULL,
	`denominator` FLOAT NULL DEFAULT NULL,
	`extra_1` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_2` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_3` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_4` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_5` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`orange_is` VARCHAR(4) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`reset_ci` VARCHAR(4) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`grp_ref` BIGINT(20) NULL DEFAULT NULL,
	PRIMARY KEY (`ind`) USING BTREE,
	INDEX `Index 2` (`grp_ref`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1024;


DROP TABLE IF EXISTS 48_multispc.tb_multispc_input_unique;
CREATE TABLE 48_multispc.tb_multispc_input_unique (
	`field_1` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_2` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_3` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_4` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`field_5` VARCHAR(80) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`f_ref` INT(11) NULL DEFAULT NULL,
	INDEX `Index 2` (`field_1`, `field_2`, `field_3`, `field_4`, `field_5`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;


DROP TABLE IF EXISTS 48_multispc.tb_multispc_output;
CREATE TABLE 48_multispc.tb_multispc_output (
	`ind` BIGINT(20) NOT NULL,
	`grp_ref` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`field_1` VARCHAR(80) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`field_2` VARCHAR(80) NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`field_3` VARCHAR(80) NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`field_4` VARCHAR(80) NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`field_5` VARCHAR(80) NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`month` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`target` FLOAT NULL DEFAULT NULL,
	`value` FLOAT NOT NULL,
	`denominator` FLOAT NULL DEFAULT NULL,
	`extra_1` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_2` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_3` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_4` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_5` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`mean` FLOAT NULL DEFAULT NULL,
	`mr` FLOAT NULL DEFAULT NULL,
	`avg_mr` FLOAT NULL DEFAULT NULL,
	`ucl` FLOAT NULL DEFAULT NULL,
	`lcl` FLOAT NULL DEFAULT NULL,
	`f_astro` INT(11) NULL DEFAULT '0',
	`f_trend` INT(11) NULL DEFAULT '0',
	`f_shift` INT(11) NULL DEFAULT '0',
	`f_2of3` INT(11) NULL DEFAULT '0',
	`f_mrcl` INT(11) NULL DEFAULT '0',
	`flag` INT(11) NULL DEFAULT '0',
	`orange_is` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`flag_assurance` VARCHAR(4) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`flag_performance` VARCHAR(4) NULL DEFAULT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;


DROP TABLE IF EXISTS 48_multispc.tb_multispc_working_dataset;
CREATE TABLE 48_multispc.tb_multispc_working_dataset (
	`ind` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`grp_ref` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`month` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`target` FLOAT NULL DEFAULT NULL,
	`value` FLOAT NULL DEFAULT NULL,
	`mean` FLOAT NULL DEFAULT NULL,
	`denominator` FLOAT NULL DEFAULT NULL,
	`extra_1` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_2` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_3` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_4` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra_5` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`mr` FLOAT NULL DEFAULT NULL,
	`avg_mr` FLOAT NULL DEFAULT NULL,
	`ucl` FLOAT NULL DEFAULT NULL,
	`lcl` FLOAT NULL DEFAULT NULL,
	`f_astro` INT(11) NULL DEFAULT '0',
	`f_trend` INT(11) NULL DEFAULT '0',
	`f_shift` INT(11) NULL DEFAULT '0',
	`f_2of3` INT(11) NULL DEFAULT '0',
	`f_mrcl` INT(11) NULL DEFAULT '0',
	`flag` INT(11) NULL DEFAULT '0',
	`orange_is` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`ind`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=128;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_special_cause;

DELIMITER //
create procedure 48_multispc.sp_multispc_special_cause(in Instart int,Inend int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- THis procedure calls the trend checker to look for a run of 6 values +/- the mean; a run of 6 increasing / decrasing values; 2/3 values above or below the mean.  There is a flag for each option.

-- If there is no reset marker run the sp_multispc_is_special_cause_loop procedure across the whole dataset.
if (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) IS NULL then call 48_multispc.sp_multispc_is_special_cause_loop(1,(SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff));
-- if there is a marker run in 2 parts one from start to 1 before the marker, then and one from marker to end
ELSE 
	CALL 48_multispc.sp_multispc_is_special_cause_loop(1,(SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) -1);
	CALL 48_multispc.sp_multispc_is_special_cause_loop((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) -1,(SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff));
END if;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_is_special_cause_loop;

DELIMITER //
create PROCEDURE 48_multispc.sp_multispc_is_special_cause_loop(in Instart int,Inend int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE w_counter INT DEFAULT 1;
DECLARE var_1 FLOAT DEFAULT NULL;
DECLARE var_2 FLOAT DEFAULT NULL;
DECLARE var_3 FLOAT DEFAULT NULL;
DECLARE var_4 FLOAT DEFAULT NULL;
DECLARE var_5 FLOAT DEFAULT NULL;
DECLARE var_6 FLOAT DEFAULT NULL;
DECLARE mean FLOAT DEFAULT NULL;
DECLARE v_ucl FLOAT DEFAULT NULL;
DECLARE v_lcl FLOAT DEFAULT NULL;
DECLARE v_23 FLOAT DEFAULT 0;

SET w_counter = instart;
while w_counter <= inend DO  -- loop from the start posiiton to the end position
	if w_counter > 5 then 
		--  allocate variables for the past 6 values to examine.  1 is the oldest entry in the trend and 6 is the newest.
		SET var_1 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 5); 
		SET var_2 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 4); 
		SET var_3 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 3); 
		SET var_4 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 2); 
		SET var_5 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 1); 
		SET var_6 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 0); 
		SET mean = (SELECT a1.mean from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = 1); 
		
		-- trend flagging, if all variabes are INCREASING then flag ALL rows
		if var_6 > var_5 AND var_5 > var_4 AND var_4 > var_3 AND var_3 > var_2 AND var_2 > var_1 
			then update 48_multispc.tb_multispc_working_dataset SET f_trend = 1 WHERE ind BETWEEN w_counter - 5 and w_counter;
			END IF;
		-- trend flagging, if all variabes are DECREASING then flag ALL rows
		if var_6 < var_5 AND var_5 < var_4 AND var_4 < var_3 AND var_3 < var_2 AND var_2 < var_1 
			then update 48_multispc.tb_multispc_working_dataset SET f_trend = -1 WHERE ind BETWEEN w_counter - 5 and w_counter;
			END IF;
			
		-- shift flagging, if all 6 values are ABOVE the mean then flag ALL rows
		if var_6 > mean AND var_5 > mean AND var_4 > mean AND var_3 > mean AND var_2 > mean AND var_1 > mean 
			then update 48_multispc.tb_multispc_working_dataset SET f_shift = 1 WHERE ind BETWEEN w_counter - 5 and w_counter;
			END IF;
		-- shift flagging, if all 6 values are BELOW the mean then flag ALL rows
		if var_6 < mean AND var_5 < mean AND var_4 < mean AND var_3 < mean AND var_2 < mean AND var_1 < mean 
			then update 48_multispc.tb_multispc_working_dataset SET f_shift = -1 WHERE ind BETWEEN w_counter - 5 and w_counter;
			END IF;
		END IF;
		
	if w_counter > 2 then 
		-- allocate variables for the past 6 values to examine.  1 is the oldest entry in the trend and 3 is the newest.
		SET var_1 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 2); 
		SET var_2 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 1); 
		SET var_3 = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 0);
		SET v_ucl = (SELECT a1.ucl from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = 1);
		SET v_lcl = (SELECT a1.lcl from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = 1);
		SET mean = (SELECT a1.mean from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = 1); 
		
		-- Look for 2/3 values ABOVE the mean, flag ALL 3 values if triggered.
		SET v_23 = 0;
		if var_1 > (mean + (v_ucl - mean) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if var_2 > (mean + (v_ucl - mean) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if var_3 > (mean + (v_ucl - mean) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if v_23 > 2 then update 48_multispc.tb_multispc_working_dataset SET f_2of3 = 1 WHERE ind BETWEEN w_counter - 2 and w_counter; END IF;
		-- Look for 2/3 values BELOW the mean, flag ALL 3 values if triggered.
		SET v_23 = 0;
		if var_1 < (mean - (mean - v_lcl) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if var_2 < (mean - (mean - v_lcl) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if var_3 < (mean - (mean - v_lcl) * (2/3)) then SET v_23 = v_23 +1; END IF;
		if v_23 > 2 then update 48_multispc.tb_multispc_working_dataset SET f_2of3 = -1 WHERE ind BETWEEN w_counter - 2 and w_counter; END IF;
		END IF;
		 	
	SET w_counter = w_counter + 1;
END while;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_write_mr;

DELIMITER //
create procedure 48_multispc.sp_multispc_write_mr(in InValue float,InPosition int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Write the mr calculated in the loop procedure into the dataset at the correct row number (ind)
update 48_multispc.tb_multispc_working_dataset 
SET mr = InValue
WHERE ind = InPosition
;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_write_mr_loop;

DELIMITER //
create procedure 48_multispc.sp_multispc_write_mr_loop(in InValue float,InPosition int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE w_counter INT DEFAULT 1;
DECLARE curr_val float DEFAULT NULL;
DECLARE last_val float DEFAULT NULL;
DECLARE mr float DEFAULT NULL;

-- Loop the chack upto the end of the file
while w_counter <= (SELECT MAX(aa.ind) from 48_multispc.tb_multispc_working_dataset aa) DO
	SET curr_val = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter);  -- return the value from the current row number
	if w_counter > 1 then SET last_val = (SELECT a1.value from 48_multispc.tb_multispc_working_dataset a1 WHERE a1.ind = w_counter - 1); ELSE SET last_val = NULL; END IF;  -- set the last value to the previous value based on the row number.
	if (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) is not NULL and w_counter = ((SELECT MAX(aa.ind) from 48_multispc.tb_multispc_working_dataset aa) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config))+1 then SET last_val = NULL; END IF;  -- reset the last value if there is a reset marker.
	IF last_val is not NULL THEN SET mr = ABS(curr_val - last_val); ELSE SET mr = NULL; END IF; -- set mr to the difference between the current and last value
	CALL sp_multispc_write_mr(mr,w_counter);
	
	SET w_counter = w_counter + 1;
END while;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

drop procedure if exists 48_multispc.sp_multispc_id_spc;

DELIMITER //
create procedure 48_multispc.sp_multispc_id_spc(in InValue float,InPosition int)
begin

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CALCULATE FIELDS
-- calculate the MR (difference between currrent and previous value) for each row and write it into the data table.
CALL 48_multispc.sp_multispc_write_mr_loop(0, 0);

-- calculate mean and average MR fields
UPDATE 48_multispc.tb_multispc_working_dataset
SET mean = case
	when (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) IS NULL then (select avg(a.value) FROM 48_multispc.tb_multispc_working_dataset a)  -- when there is no reset point in place usse the second rows value.
	when ind <= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)) 
		then (select avg(a.value) FROM 48_multispc.tb_multispc_working_dataset a WHERE a.ind < ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config))) -- when there is a reset point average all rows before the reset point
	ELSE (select avg(a.value) FROM 48_multispc.tb_multispc_working_dataset a WHERE a.ind >= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config))) -- Where rown number is post reset point use a mean based on the reest point ad onward.
END
-- SET mean = (select avg(a.value) FROM 48_multispc.tb_multispc_working_dataset a)
-- Create an average MR in the same manner as the mean above using the mr value instead of the mean
,avg_mr = case
	when (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) IS NULL then (select avg(a.mr) FROM 48_multispc.tb_multispc_working_dataset a)  -- when there is no reset point in place use the second rows value.
	when ind <= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)) 
		then (select avg(a.mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE a.ind < ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)))
	ELSE (select avg(a.mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE a.ind >= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)))
END
-- ,avg_mr = (select avg(a.mr) FROM 48_multispc.tb_multispc_working_dataset a)
WHERE 1=1;


-- calculate UCL and LCL
UPDATE 48_multispc.tb_multispc_working_dataset
SET ucl = case
	when (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) IS NULL then (select mean + (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = 2)   -- when there is no reset point in place use the second rows value.
	when ind <= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)) 
		then (select mean + (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = 2)  -- set values less than the reset value to the mean of the second value
	ELSE (select mean + (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = (SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff)) -- set the control limit using the last meanvalue in the dataset.
END
,lcl = case
	when (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config) IS NULL then (select mean - (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = 2)   -- when there is no reset point in place use the second rows value.
	when ind <= ((SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff) - (SELECT period_to_reset_mean FROM 48_multispc.tb_multispc_config)) 
		then (select mean - (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = 2)  -- set values less than the reset value to the mean of the second value
	ELSE (select mean - (2.66 * avg_mr) FROM 48_multispc.tb_multispc_working_dataset a WHERE ind = (SELECT MAX(ff.ind) FROM 48_multispc.tb_multispc_working_dataset ff)) -- set the control limit using the last meanvalue in the dataset.
END
WHERE 1=1;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DETECT SPECIAL CAUSE VARIATION
-- identify and flag astronomical values
UPDATE 48_multispc.tb_multispc_working_dataset a
SET f_astro = case 
	when a.value > a.ucl then 1 
	when a.value < a.lcl then -1
	ELSE 0 end 
WHERE 1=1;

-- run of 6 values +/- mean & 6 descending / ascending in  row (shift) & 2/3 points outside +/- 2/3 of the UCL / LCL 
call 48_multispc.sp_multispc_special_cause(0,0);

-- test the moving range control limit and flag into the dataset field.
UPDATE 48_multispc.tb_multispc_working_dataset a
SET f_mrcl = case 
	when a.mr > (a.avg_mr * 2.267) AND a.value > a.mean then 1 
	when a.mr > (a.avg_mr * 2.267) AND a.value < a.mean then -1 
	ELSE 0 end 
WHERE 1=1; 

-- set master SC marker flag to identify rw as of interest if ANY of the flags are triggered.
UPDATE 48_multispc.tb_multispc_working_dataset a
SET flag = case 
	-- when (a.f_astro > 0 OR a.f_trend > 0 OR a.f_shift > 0 OR a.f_2of3 > 0 OR a.f_mrcl > 0) then 1 
	-- when (a.f_astro < 0 OR a.f_trend < 0 OR a.f_shift < 0 OR a.f_2of3 < 0 OR a.f_mrcl < 0) then -1 
	when a.f_astro <> 0 then a.f_astro
	when a.f_shift <> 0 then a.f_shift
	when a.f_trend <> 0 then a.f_trend
	when a.f_2of3 <> 0 then a.f_2of3
	when a.f_mrcl <> 0 then a.f_mrcl 
	ELSE 0 end 
WHERE 1=1; 

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_increment_job;

DELIMITER //
create procedure 48_multispc.sp_multispc_increment_job(in InValue float,InPosition int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE w_counter INT DEFAULT 1;
TRUNCATE TABLE 48_multispc.tb_multispc_output;

-- Loop the write process
while w_counter <= (SELECT MAX(aa.f_ref) from 48_multispc.tb_multispc_input_unique aa) DO
	-- write the first data group into the working table.
	TRUNCATE TABLE 48_multispc.tb_multispc_working_dataset;
	INSERT INTO 48_multispc.tb_multispc_working_dataset (
		SELECT 
		NULL
		,a.grp_ref
		,a.period
		,a.target
		,a.value
		,a.denominator
		,a.extra_1
		,a.extra_2
		,a.extra_3
		,a.extra_4
		,a.extra_5
		,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,a.orange_is
		FROM 48_multispc.tb_multispc_input a
		WHERE 1=1
		AND a.grp_ref = w_counter
	);
	
	
	TRUNCATE TABLE 48_multispc.tb_multispc_config;
	INSERT INTO 48_multispc.tb_multispc_config (
		SELECT 
			NULL, NULL, a.orange_is, NULL, a.reset_ci
		FROM 48_multispc.tb_multispc_input a
		WHERE 1=1
		AND a.grp_ref = w_counter
		GROUP by
		a.orange_is, a.reset_ci
	);
	
	CALL 48_multispc.sp_multispc_id_spc(0,0);
	
	
	-- write data into output table
	INSERT INTO 48_multispc.tb_multispc_output (
		SELECT 
		a.ind
		,a.grp_ref
		,b.field_1
		,b.field_2
		,b.field_3
		,b.field_4
		,b.field_5
		,a.month
		,a.target
		,a.value
		,a.denominator
		,a.extra_1
		,a.extra_2
		,a.extra_3
		,a.extra_4
		,a.extra_5
		,a.mean
		,a.mr
		,a.avg_mr
		,a.ucl
		,a.lcl
		,a.f_astro
		,a.f_trend
		,a.f_shift
		,a.f_2of3
		,a.f_mrcl 
		,a.flag AS 'point_colour'
		,a.orange_is
		,NULL
		,NULL
		FROM 48_multispc.tb_multispc_working_dataset a
			LEFT JOIN 48_multispc.tb_multispc_input_unique b ON a.grp_ref = b.f_ref
		WHERE 1=1
	);
	
	
	UPDATE 48_multispc.tb_multispc_output c
	SET c.flag_assurance = 
		(SELECT
		case 
			when o.target IS NULL THEN '0'
			when o.orange_is = 'up' and o.value > o.target then '1'
			when o.orange_is = 'up' and o.value = o.target then '0'
			when o.orange_is = 'up' and o.value < o.target then '-1'
			when o.orange_is = 'down' and o.value > o.target then '-1'
			when o.orange_is = 'down' and o.value = o.target then '0'
			when o.orange_is = 'down' and o.value < o.target then '1'
			END AS 'assurance'
		from 48_multispc.tb_multispc_output o
		WHERE 1=1 
		and o.grp_ref = w_counter
		AND o.ind = (SELECT MAX(o3.ind) from 48_multispc.tb_multispc_output o3 WHERE o3.grp_ref = w_counter) 
		);


	UPDATE 48_multispc.tb_multispc_output d
	SET d.flag_performance = 
		(SELECT 
		case 
			when o2.flag = '0' THEN '0'
			when o2.orange_is = 'up' and o2.flag = 1 then 'u1'
			when o2.orange_is = 'up' and o2.flag = -1 then 'u-1'
			when o2.orange_is = 'down' and o2.flag = 1 then 'd1'
			when o2.orange_is = 'down' and o2.flag = -1 then 'd-1'
			END AS 'performance'
		from 48_multispc.tb_multispc_output o2
		WHERE 1=1 
		and o2.grp_ref = w_counter
		AND o2.ind = (SELECT MAX(o3.ind) from 48_multispc.tb_multispc_output o3 WHERE o3.grp_ref = w_counter)
		)
	WHERE 1=1 
	and d.grp_ref = w_counter
	;
		
	
	SET w_counter = w_counter + 1;
END while;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop procedure if exists 48_multispc.sp_multispc_main;

DELIMITER //
create procedure 48_multispc.sp_multispc_main(in InValue float,InPosition int)
begin
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- This script removes duplicates from the input dataset
DELETE a.*
FROM 48_multispc.tb_multispc_input a
JOIN (
	SELECT 
	aa.field_1
	,aa.field_2
	,aa.field_3
	,aa.field_4
	,aa.field_5
	,COUNT(*)
	FROM 48_multispc.tb_multispc_input aa
	GROUP by
	aa.field_1
	,aa.field_2
	,aa.field_3
	,aa.field_4
	,aa.field_5
	HAVING COUNT(*) <12
) aa on a.field_1 = aa.field_1 AND a.field_2 <=> aa.field_2 AND a.field_3 <=> aa.field_3 AND a.field_4 <=> aa.field_4 AND a.field_5 <=> aa.field_5;


-- organise the data to number each unique grouping
TRUNCATE TABLE 48_multispc.tb_multispc_input_unique;
INSERT INTO 48_multispc.tb_multispc_input_unique (
SELECT 
a.field_1
,a.field_2
,a.field_3
,a.field_4
,a.field_5
-- ,ROW_NUMBER() OVER (PARTITION BY a.field_1, a.field_2, a.field_3, a.field_4, a.field_5 ORDER BY a.field_1, a.field_2, a.field_3, a.field_4, a.field_5 ASC) 
,DENSE_RANK() OVER (ORDER BY a.field_1, a.field_2, a.field_3, a.field_4, a.field_5) AS 'myrank'
FROM 48_multispc.tb_multispc_input a
WHERE 1=1
AND a.field_1 IS NOT null
GROUP BY
a.field_1
,a.field_2
,a.field_3
,a.field_4
,a.field_5
);


-- join the grouped data back to get in the index, use a null safe join <=>
UPDATE 48_multispc.tb_multispc_input a
JOIN 48_multispc.tb_multispc_input_unique b ON b.field_1 <=> a.field_1 AND b.field_2 <=> a.field_2 AND b.field_3 <=> a.field_3 AND b.field_4 <=> a.field_4 AND b.field_5 <=> a.field_5 
SET grp_ref = b.f_ref
WHERE 1=1;


CALL 48_multispc.sp_multispc_increment_job(0,0);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
