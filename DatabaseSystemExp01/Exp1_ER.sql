-- MySQL Script generated by MySQL Workbench
-- Wed Oct  9 22:51:29 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`customers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`customers` (
  `name` VARCHAR(45) NOT NULL,
  `gender` ENUM("male", "female") NULL,
  `age` INT NULL,
  `providerscol` VARCHAR(45) NULL,
  `tel` CHAR(8) NULL,
  `account` VARCHAR(16) NOT NULL,
  `code` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`account`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`providers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`providers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`providers` (
  `name` VARCHAR(45) NOT NULL,
  `gender` ENUM("male", "female") NULL,
  `age` INT NULL,
  `providerscol` VARCHAR(45) NULL,
  `tel` CHAR(8) NULL,
  `account` VARCHAR(16) NOT NULL,
  `code` VARCHAR(16) NULL,
  PRIMARY KEY (`account`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`goods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`goods` ;

CREATE TABLE IF NOT EXISTS `mydb`.`goods` (
  `name` VARCHAR(45) NOT NULL,
  `produce_date` DATETIME NULL,
  `save_date` DATETIME NULL,
  `price` INT NULL,
  `discount` FLOAT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
  `ID` CHAR(8) NOT NULL,
  `customer_tel` CHAR(8) NULL,
  `customer_address` VARCHAR(45) NULL,
  `customer_comment` VARCHAR(100) NULL,
  `customer_score_earned` INT NULL,
  `price_after_discount` FLOAT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`categories` ;

CREATE TABLE IF NOT EXISTS `mydb`.`categories` (
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`providers_has_customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`providers_has_customer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`providers_has_customer` (
  `providers_account` VARCHAR(16) NOT NULL,
  `customer_account` VARCHAR(16) NOT NULL,
  `score` INT NULL DEFAULT 0,
  `VIP_level` ENUM('0', '1', '2', '3') NULL DEFAULT '0',
  PRIMARY KEY (`providers_account`, `customer_account`),
  INDEX `fk_providers_has_customer_customer1_idx` (`customer_account` ASC) VISIBLE,
  INDEX `fk_providers_has_customer_providers1_idx` (`providers_account` ASC) VISIBLE,
  CONSTRAINT `fk_providers_has_customer_providers1`
    FOREIGN KEY (`providers_account`)
    REFERENCES `mydb`.`customers` (`account`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_providers_has_customer_customer1`
    FOREIGN KEY (`customer_account`)
    REFERENCES `mydb`.`providers` (`account`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Comment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Comment` (
  `content` VARCHAR(200) NOT NULL,
  `time` DATETIME NULL,
  `score` FLOAT NULL,
  `customers_account` VARCHAR(16) NOT NULL,
  `goods_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customers_account`, `goods_name`),
  INDEX `fk_Comment_goods_1_idx` (`goods_name` ASC) VISIBLE,
  CONSTRAINT `fk_Comment_customers1`
    FOREIGN KEY (`customers_account`)
    REFERENCES `mydb`.`customers` (`account`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comment_goods_1`
    FOREIGN KEY (`goods_name`)
    REFERENCES `mydb`.`goods` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order_state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`order_state` ;

CREATE TABLE IF NOT EXISTS `mydb`.`order_state` (
  `order_statecol` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  `orders_ID` CHAR(8) NOT NULL,
  PRIMARY KEY (`orders_ID`),
  CONSTRAINT `fk_order_state_orders_1`
    FOREIGN KEY (`orders_ID`)
    REFERENCES `mydb`.`orders` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`goods_has_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`goods_has_orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`goods_has_orders` (
  `goods_name` VARCHAR(45) NOT NULL,
  `orders_ID` CHAR(8) NOT NULL,
  PRIMARY KEY (`goods_name`, `orders_ID`),
  INDEX `fk_goods__has_orders__orders_1_idx` (`orders_ID` ASC) VISIBLE,
  INDEX `fk_goods__has_orders__goods_1_idx` (`goods_name` ASC) VISIBLE,
  CONSTRAINT `fk_goods__has_orders__goods_1`
    FOREIGN KEY (`goods_name`)
    REFERENCES `mydb`.`goods` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_goods__has_orders__orders_1`
    FOREIGN KEY (`orders_ID`)
    REFERENCES `mydb`.`orders` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`goods__has_categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`goods__has_categories` ;

CREATE TABLE IF NOT EXISTS `mydb`.`goods__has_categories` (
  `goods_name` VARCHAR(45) NOT NULL,
  `categories_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`goods_name`, `categories_name`),
  INDEX `fk_goods__has_categories_categories1_idx` (`categories_name` ASC) VISIBLE,
  INDEX `fk_goods__has_categories_goods_1_idx` (`goods_name` ASC) VISIBLE,
  CONSTRAINT `fk_goods__has_categories_goods_1`
    FOREIGN KEY (`goods_name`)
    REFERENCES `mydb`.`goods` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_goods__has_categories_categories1`
    FOREIGN KEY (`categories_name`)
    REFERENCES `mydb`.`categories` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
