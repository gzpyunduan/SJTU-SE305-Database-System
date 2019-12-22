-- MySQL Script generated by MySQL Workbench
-- Tue Dec 10 23:15:32 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`customer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`customer` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(30) NULL,
  `code` VARCHAR(30) NULL,
  `gender` TINYINT NULL,
  `address` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`goods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`goods` ;

CREATE TABLE IF NOT EXISTS `mydb`.`goods` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(30) NULL,
  `price` DOUBLE UNSIGNED NULL,
  `remain` INT UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cart` ;

CREATE TABLE IF NOT EXISTS `mydb`.`cart` (
  `id` INT UNSIGNED NOT NULL,
  `total_price` DOUBLE UNSIGNED NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `customer_id`),
  INDEX `fk_cart_customer_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_cart_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
  `id` INT UNSIGNED NOT NULL,
  `number` CHAR(16) NULL,
  `price` DOUBLE UNSIGNED NULL,
  `time` DATETIME NULL,
  `cart_id` INT UNSIGNED NOT NULL,
  `cart_customer_id` INT UNSIGNED NOT NULL,
  `comment` VARCHAR(500) NULL,
  PRIMARY KEY (`id`, `cart_id`, `cart_customer_id`),
  INDEX `fk_orders_cart1_idx` (`cart_id` ASC, `cart_customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_cart1`
    FOREIGN KEY (`cart_id` , `cart_customer_id`)
    REFERENCES `mydb`.`cart` (`id` , `customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`order_details` ;

CREATE TABLE IF NOT EXISTS `mydb`.`order_details` (
  `number` INT UNSIGNED NULL,
  `price` DOUBLE UNSIGNED NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `order_cart_id` INT UNSIGNED NOT NULL,
  `order_cart_customer_id` INT UNSIGNED NOT NULL,
  `goods_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`order_id`, `order_cart_id`, `order_cart_customer_id`, `goods_id`),
  INDEX `fk_order_details_goods1_idx` (`goods_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_details_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_details_goods1`
    FOREIGN KEY (`goods_id`)
    REFERENCES `mydb`.`goods` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cart_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cart_details` ;

CREATE TABLE IF NOT EXISTS `mydb`.`cart_details` (
  `number` INT UNSIGNED NULL,
  `price` DOUBLE UNSIGNED NULL,
  `time` DATETIME NULL,
  `cart_id` INT UNSIGNED NOT NULL,
  `cart_customer_id` INT UNSIGNED NOT NULL,
  `goods_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cart_id`, `cart_customer_id`, `goods_id`),
  INDEX `fk_cart_details_goods1_idx` (`goods_id` ASC) VISIBLE,
  CONSTRAINT `fk_cart_details_cart1`
    FOREIGN KEY (`cart_id` , `cart_customer_id`)
    REFERENCES `mydb`.`cart` (`id` , `customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_details_goods1`
    FOREIGN KEY (`goods_id`)
    REFERENCES `mydb`.`goods` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`discount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`discount` ;

CREATE TABLE IF NOT EXISTS `mydb`.`discount` (
  `customer_id` INT UNSIGNED NOT NULL,
  `goods_id` INT UNSIGNED NOT NULL,
  `discount_rate` DOUBLE NULL,
  PRIMARY KEY (`customer_id`, `goods_id`),
  INDEX `fk_customer_has_goods_goods1_idx` (`goods_id` ASC) VISIBLE,
  INDEX `fk_customer_has_goods_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_customer_has_goods_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customer_has_goods_goods1`
    FOREIGN KEY (`goods_id`)
    REFERENCES `mydb`.`goods` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb`;

DELIMITER $$

USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`customer_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`customer_BEFORE_INSERT` BEFORE INSERT ON `customer` FOR EACH ROW
BEGIN

END
$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`customer_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`customer_AFTER_INSERT` AFTER INSERT ON `customer` FOR EACH ROW
BEGIN
-- insert into cart(customer_id, total_price) values(new.id, 0);
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`order_details_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`order_details_BEFORE_INSERT` BEFORE INSERT ON `order_details` FOR EACH ROW
BEGIN
if new.`number`> (select remain from goods where id = new.goods_id) then
set new.goods_id = null;
end if;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`order_details_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`order_details_AFTER_INSERT` AFTER INSERT ON `order_details` FOR EACH ROW
BEGIN
-- if new.`number`< (select remain from goods where id = new.goods_id) then
-- set new.goods_id = null;
-- else 
update cart set total_price = total_price - new.price * new.`number` where (id, customer_id) = (new.order_cart_id, new.order_cart_customer_id);
update cart_details set `number` = `number` - new.`number` where (cart_id, cart_customer_id, goods_id) = (new.order_cart_id, new.order_cart_customer_id, new.goods_id);

if 0 = (select `number` from cart_details where (cart_id, cart_customer_id, goods_id) = (new.order_cart_id, new.order_cart_customer_id, new.goods_id))
then 
delete from cart_details where(cart_id, cart_customer_id, goods_id) = (new.order_cart_id, new.order_cart_customer_id, new.goods_id);
end if;

update orders set price = price + new.price * new.`number` where (id, cart_id, cart_customer_id) = (new.order_id, new.order_cart_id, new.order_cart_customer_id);
update goods set remain = remain - new.`number` where id = new.goods_id;
-- end if;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`cart_details_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`cart_details_AFTER_INSERT` AFTER INSERT ON `cart_details` FOR EACH ROW
BEGIN
update cart set total_price = total_price + new.price*new.`number` where (id, customer_id) = (new.cart_id, new.cart_customer_id);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
