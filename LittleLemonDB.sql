-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menu` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `price` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`customers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `contact_number` VARCHAR(20) NOT NULL,
  `member_since` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`bookings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `booking_date_time` DATETIME NOT NULL,
  `table_number` INT NOT NULL,
  `customers_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_bookings_customers1_idx` (`customers_id` ASC) VISIBLE,
  CONSTRAINT `fk_bookings_customers1`
    FOREIGN KEY (`customers_id`)
    REFERENCES `littlelemondb`.`customers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `littlelemondb`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`staff` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `contact_number` VARCHAR(20) NOT NULL,
  `role` ENUM('Cashier', 'Chef', 'Dishwasher', 'Host', 'Manager', 'Waiter') NOT NULL,
  `salary` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_datetime` DATETIME NOT NULL DEFAULT NOW(),
  `total_cost` DECIMAL(10,2) NOT NULL,
  `status` ENUM('Place', 'Delivered', 'Canceled') NOT NULL,
  `bookings_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_bookings1_idx` (`bookings_id` ASC) VISIBLE,
  INDEX `fk_orders_staff1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_bookings1`
    FOREIGN KEY (`bookings_id`)
    REFERENCES `littlelemondb`.`bookings` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_staff1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `littlelemondb`.`staff` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `littlelemondb`.`orders_has_menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`orders_has_menu` (
  `orders_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`orders_id`, `menu_id`),
  INDEX `fk_orders_has_menu_menu1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_orders_has_menu_orders1_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_has_menu_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `littlelemondb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_has_menu_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `littlelemondb`.`menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
