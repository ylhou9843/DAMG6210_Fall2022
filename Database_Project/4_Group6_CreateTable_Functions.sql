Use master 2;
Go
CREATE Database ProjectGroup6
Go

USE ProjectGroup6
Go

DROP SCHEMA IF EXISTS Cosmetics;
CREATE Schema Cosmetics;

------------------------------------------------------
--CustomerLocation
CREATE TABLE Cosmetics.CustomerLocation
(
	CustomerAddressID varchar(225) NOT NULL PRIMARY KEY,
	Country VARCHAR(45)NOT NULL,
	State VARCHAR(45),
	City VARCHAR(45),
	Street VARCHAR(45),
	ZIPCode VARCHAR(45),
);

--Customers
CREATE TABLE Cosmetics.Customers
(
	CustomerID INT NOT NULL PRIMARY KEY,
	LastName VARCHAR(45),
	FirstName VARCHAR(45),
	CustomerAddressID varchar(225) NOT NULL
		REFERENCES Cosmetics.CustomerLocation(CustomerAddressID),
	Email VARCHAR(45),
	PhoneNo VARCHAR(45),
);

--CustomerPersonalInfo
CREATE TABLE Cosmetics.CustomerPersonalInfo
(
	CustomerID INT NOT NULL PRIMARY KEY
		REFERENCES Cosmetics.Customers(CustomerID),
	SkinType VARCHAR(45) NOT NULL,
	Occupation VARCHAR(45),
	DateOfBirth DATE,
	Gender VARCHAR(45) NOT NULL,
);

--RetailerLocation
CREATE TABLE Cosmetics.RetailerLocation
(
	RetailerAddressID INT IDENTITY NOT NULL PRIMARY KEY,
	Country VARCHAR(20),
	State VARCHAR(20),
	City VARCHAR(20),
	Street VARCHAR(50),
	ZIPCode VARCHAR(20)
);

--Retailers
CREATE TABLE Cosmetics.Retailers
(
	RetailerID VARCHAR(20) NOT NULL PRIMARY KEY,
	RetailerName VARCHAR(40),
	RetailerAddressID INT NOT NULL REFERENCES Cosmetics.RetailerLocation(RetailerAddressID)
);

--Category
CREATE TABLE Cosmetics.Category
(
    ProductCategoryID INT NOT NULL PRIMARY KEY,
    ProductCategoryName varchar(40) NOT NULL
 );
   
--Subcategory
CREATE TABLE Cosmetics.Subcategory
(
    ProductSubcategoryID INT NOT NULL PRIMARY KEY,
    ProductCategoryID int NOT NULL 
    REFERENCES Cosmetics.Category(ProductCategoryID),
    ProductSubcategoryName varchar(40) NOT NULL
 );

--Product
CREATE TABLE Cosmetics.Product
(
	ProductID int primary key,
	ProductName Varchar(100),)
	alter table Cosmetics.Product 
	add ProductSubcategoryID int constraint fk foreign key(ProductSubcategoryID)  
	references Cosmetics.Subcategory(ProductSubcategoryID
);

--ProductInfo
Create TABLE Cosmetics.ProductInfo
(
	ProductID int primary key,
	ProductPrice float not null,
	ProductSize Varchar(100) not null,
	ProductIngredient Varchar(100) not null,
	ProductBrand Varchar(100) not null
	foreign key(ProductID) references Cosmetics.Product(ProductID)
) ;

--OrderLocation
CREATE TABLE Cosmetics.OrderLocation
(
    OrderAddressID	INT		NOT NULL	PRIMARY KEY,
    Country			VARCHAR(20)	NOT NULL,
    State			VARCHAR(20)	NOT NULL,
    City			VARCHAR(20)	NOT NULL,
    Street			VARCHAR(20)	NOT NULL,
    ZIPCode			VARCHAR(10)	NOT NULL
);

--Orders
/* FUNCTION TO CALCULATE TotalAmount*/
CREATE FUNCTION Cosmetics.GetTotalAmount 
(@OrderID INT)
RETURNS DECIMAL(10, 2)
AS 
BEGIN
	DECLARE @total DECIMAL(10, 2) =
		(SELECT SUM(UnitPrice  * Quantity)
		 FROM OrderItems
		 WHERE OrderID = @OrderID);
		SET @total = ISNULL(@total, 0);
		RETURN @total;
END;

CREATE TABLE Cosmetics.Orders
(
    OrderID			INT		NOT NULL	PRIMARY KEY,
    CustomerID		INT		NOT NULL
    	REFERENCES Cosmetics.Customers,
    OrderDate		DATE	NOT NULL,
    RetailerID		VARCHAR(20) NOT NULL
       	REFERENCES Cosmetics.Retailers,
    TotalAmount		AS Cosmetics.GetTotalAmount(OrderID),
    OrderAddressID	INT		NOT NULL
       	REFERENCES Cosmetics.OrderLocation
);

--OrderItems
CREATE TABLE Cosmetics.OrderItems
(
    OrderID			INT		NOT NULL
       	REFERENCES Cosmetics.Orders,
    OrderItemID		INT		NOT NULL,
    UnitPrice		DECIMAL(10, 2) NOT NULL,
    Quantity		INT		NOT NULL,
    ProductID		INT		NOT NULL
       	REFERENCES Cosmetics.Product,
	PRIMARY KEY CLUSTERED (OrderID, OrderItemID)
);

--Reviews
/* FUNCTION TO CALCULATE ReviewAmount*/
CREATE FUNCTION [Cosmetics].GetReviewAmount ( @ProductID INT ) RETURNS INT AS BEGIN
	DECLARE
		@amount INT = ( SELECT COUNT ( * ) FROM Review WHERE ProductID = @ProductID );
	
	SET @amount = ISNULL( @amount, 0 );
	RETURN @amount;
END;

CREATE TABLE Cosmetics.Review
(
  ProductID int  NOT NULL,
  CustomerID int  NOT NULL,
  SubmitDate date  NULL,
  Rating float(53)  NULL,
  CommentText text COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  Helpfulness float(53)  NULL,
  ReviewAmount AS (Cosmetics.GetReviewAmount(ProductID)),
  PRIMARY KEY CLUSTERED (ProductID, CustomerID),
  FOREIGN KEY (ProductID) REFERENCES Cosmetics.Product (ProductID),
  FOREIGN KEY (CustomerID) REFERENCES Cosmetics.Customers (CustomerID)
) ;

--Subscribe
CREATE TABLE Cosmetics.Subscribe 
(
  CustomerID int  NOT NULL,
  ProductID int  NOT NULL,
  StartDate date  NULL,
  EndDate date  NULL,
  PRIMARY KEY CLUSTERED (CustomerID, ProductID),
  FOREIGN KEY (ProductID) REFERENCES Cosmetics.Product (ProductID),
  FOREIGN KEY (CustomerID) REFERENCES Cosmetics.Customers (CustomerID)
) ; 









