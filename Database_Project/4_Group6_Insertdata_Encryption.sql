USE ProjectGroup6
Go


--CustomerLocation
INSERT Cosmetics.CustomerLocation (CustomerAddressID, Country, State, City, Street, ZIPCode)
VALUES	('0100','UnitedStates','CA','LosAngeles','Florence-Graham','90005'),
		('0101','UnitedStates','CA','LosAngeles','Rampart Village','90004'),
		('0102','UnitedStates','WA','Seattle','YaleAve','98109'),
		('0103','UnitedStates','WA','Tocoma','AlohaST','98402'),
		('0104','UnitedStates','NY','NewYork','EastbroadWay','10002'),
		('0105','UnitedStates','NY','NewYork','East5thStreet','10009'),
		('0106','UnitedStates','OR','Portland','NorthOfClatsop','97202'),
		('0107','UnitedStates','OR','Portland','ColumbiaSt','97201'),
		('0108','UnitedStates','TX','Dallas','DooleyRoad','75001'),
		('0109','UnitedStates','IL','Chicago','ElkGroveVillage','60007');
	

--Customers
/*customers phoneno column encryption*/

CREATE MASTER KEY ENCRYPTION BY 
PASSWORD = 'Projectgroup6';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE Projectgroup6_Certificate
WITH SUBJECT = 'ProjectGroup6 Test Certificate',
EXPIRY_DATE = '2026-12-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY ProjectGroup6_SymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE ProjectGroup6_Certificate;

-- Open symmetric key
OPEN SYMMETRIC KEY ProjectGroup6_SymmetricKey
DECRYPTION BY CERTIFICATE Projectgroup6_Certificate;

ALTER TABLE Cosmetics.Customers 
ALTER COLUMN PhoneNo varchar(max);


INSERT Cosmetics.Customers (CustomerID, LastName, FirstName, CustomerAddressID, Email, PhoneNo)
VALUES	(100,'Homer','Simpson','0100','hoemrsf@gmail.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2063348974'))),
		(101,'Peter','Griffin','0101','persrht@163.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2013388974'))),
		(102,'Stewie','Li','0102','serter@10.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2013283952'))),
		(103,'Brian','Wong','0103','bw1244@gmail.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2023949452'))),
		(104,'Cosmo','Kramer','0104','cosmokra@gmail.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2054678946'))),
		(105,'Philip','Fry','0105','pfrysrr@1004.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2056345745'))),
		(106,'Amy','Ko','0106','amyko@163.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2013348928'))),
		(107,'Marge','Simpson','0107','msehrwrh@126.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2014556563'))),
		(108,'Bender','Rodriguez','0108','berargwe@gmail.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2034559744'))),
		(109,'Turanga','Leela','0109','leela124@yahoo.com',EncryptByKey(Key_GUID(N'ProjectGroup6_SymmetricKey'), convert(varbinary, '2054675496')));

SELECT * FROM Cosmetics.Customers;

SELECT DecryptByKey(PhoneNo) 
FROM Cosmetics.Customers;

SELECT CONVERT(VARCHAR, DecryptByKey(PhoneNo)) 
FROM Cosmetics.Customers;		
		
-----------------------------------------------------------------------------------------------------------------

--CustomerPersonalInfo
INSERT Cosmetics.CustomerPersonalInfo (CustomerID, SkinType, Occupation, DateOfBirth, Gender)
VALUES	(100,'Dryness','TelevisionProducer','1987-02-04','Female'),
		(101,'Oilness','Accountant','1996-03-06','Female'),
		(102,'Dry+Oil','Nurse','1993-04-01','Female'),
		(103,'Dullness','ElectronicEngineer','1966-01-02','Male'),
		(104,'DarkCircle','DataAnalyst','1966-05-04','Female'),
		(105,'Puffiness','Journalist','1977-01-03','Male'),
		(106,'Crowsfeet','Economist','1972-12-09','Female'),
		(107,'Redness','Editor','1982-06-06','Male'),
		(108,'UnevenSkinTone','InsuranceBroker','1979-09-09','Female'),
		(109,'Senstive','ProjectManager','1998-06-12','Female');


--Retailers
INSERT INTO Cosmetics.Retailers
VALUES ('0001','Kenzthetics',2),
       ('0002','Ulta Beauty',3),
       ('0003','OHA Skincare',4),
       ('0004','Ulta Beauty',5),
       ('0005','SEPHORA',6),
       ('0006','Walgreens',7),
       ('0007','Target',8),
       ('0008','SEPHORA',9),
       ('0009','Rite Aid',10),
       ('00010','Bluemercury',11);
       
--RetailerLocation
INSERT Cosmetics.RetailerLocation(Country,State,City,Street,ZIPCode)
VALUES('U.S.','Washington','Edmonds','130 5th Ave S Suite 22','98020'),
      ('U.S.','New York','New York','188 East 86th St','10028'),
      ('U.S.','Connecticut','Farmington','15830 Redmond Way','06032'),
      ('U.S.','New Jersey','Edgewater','82 The Promenade','70202'),
      ('U.S.','Washington','Bellevue','148 Bellevue Square','98004'),
      ('U.S.','Oregon','Portland','413 SW Morrison St','97204'),
      ('U.S.','Ohio','Columbus','1892 N High St','43201'),
      ('U.S.','Virginia','Virginia Beach','701 Lynnhaven Pkwy','23452'),
      ('U.S.','Washington','Monroe','18906 U.S. Rte 2','98272'),
      ('U.S.','California','San Francisco','3535 California St','94118');

--Category
INSERT Cosmetics.Category
VALUES (1100, 'Lotion'), (1101, 'Foundation'), (1102, 'Mask'), (1103, 'Concealer'),
(1104, 'Cleanser'), (1105, 'Essence'), (1106, 'Contour'), (1107, 'Primer'),
(1108, 'Sun Screen'), (1109, 'Eye Cream');

--Subcategory
INSERT Cosmetics.Subcategory
VALUES (11000, 1100, 'Dryness'), (11001, 1100, 'Oilness'), (11002, 1100, 'Normal'), 
(11003, 1100, 'Sensitive'), (11004, 1100, 'Dry+Oil'), 
(11010, 1101, 'Dryness'), (11011, 1101, 'Oilness'), (11012, 1101, 'Normal'), 
(11013, 1101, 'Sensitive'), (11014, 1101, 'Uneven Skin Tone'), 
(11015, 1101, 'Redness'), (11016, 1101, 'Dry+Oil'), (11017, 1101, 'Dullness'),
(11020, 1102, 'Dryness'), (11021, 1102, 'Oilness'), (11022, 1102, 'Normal'), 
(11023, 1102, 'Sensitive'), (11024, 1102, 'Dry+Oil'), 
(11030, 1103, 'Dryness'), (11031, 1103, 'Oilness'), (11032, 1103, 'Normal'), 
(11033, 1103, 'Dry+Oil'), (11034, 1103, 'Redness'), (11035, 1103, 'Uneven Skin Tone'), 
(11036, 1103, 'Dark Circle'), 
(11040, 1104, 'Dryness'), (11041, 1104, 'Oilness'), (11042, 1104, 'Normal'), 
(11043, 1104, 'Sensitive'), (11044, 1104, 'Dry+Oil'), 
(11050, 1105, 'Dryness'), (11051, 1105, 'Oilness'), (11052, 1105, 'Normal'), 
(11053, 1105, 'Sensitive'), (11054, 1105, 'Dry+Oil'), (11055, 1105, 'Crows Feet'), 
(11056, 1105, 'Puffiness'), (11057, 1105, 'Redness'), (11058, 1105, 'Dullness'), 
(11060, 1106, 'Dryness'), (11061, 1106, 'Oilness'), (11062, 1106, 'Normal'),
(11070, 1107, 'Dryness'), (11071, 1107, 'Oilness'), (11072, 1107, 'Normal'), 
(11073, 1107, 'Sensitive'), (11074, 1107, 'Dry+Oil'), (11075, 1107, 'Uneven Skin Tone'), 
(11076, 1107, 'Redness'), (11077, 1107, 'Dark Circle'), (11078, 1107, 'Dullness'),
(11080, 1108, 'Dryness'), (11081, 1108, 'Oilness'), (11082, 1108, 'Normal'), 
(11083, 1108, 'Sensitive'), (11084, 1108, 'Dry+Oil'), 
(11090, 1109, 'Dryness'), (11091, 1109, 'Oilness'), (11092, 1109, 'Normal'), 
(11093, 1109, 'Sensitive'), (11094, 1109, 'Dry+Oil'), (11095, 1109, 'Puffiness'), 
(11096, 1109, 'Crows Feet');

--Product
Insert into cosmetics.Product(ProductID,ProductName)
Values ('1', 'lipstick'),
('2', 'facial cream'),
('3', 'cleanser'),
('4', 'eye cream'),
('5', 'sunscreen'),
('6', 'concentrate serum'),
('7', 'foundation'),
('8', 'lotion'),
('9', 'body cream'),
('10', 'essence');

update cosmetics.Product
set ProductSubcategoryID= case ProductID 
when '1' then '11000'
when '2' then '11002'
when '3' then '11032'
when '4' then '11043'
when '5' then '11023'
when '6' then '11004'
when '7' then '11094'
when '8' then '11013'
when '9' then '11021'
when '10' then '11016' END ;

--ProductInfo
Insert into cosmetics.ProductInfo(ProductID, ProductPrice,ProductSize,ProductIngredient,ProductBrand)
Values ('1', '100', 'S', 'RUBUS IDAEUS (RASPBERRY) JUICE, VITIS VINIFERA (GRAPE) JUICE', 'BobbiBrown'),
('2', '200', 'M', 'Papaya Enzymes: Naturally exfoliate pores.', 'SKII'),
('3', '300', 'L', 'Cetyl Ethylhexanoate, Caprylic/Capric Triglyceride', 'Chanel'),
('4', '400', 'S', 'Moringa Oleifera Seed Oil', 'Dior'),
('5', '500', 'M', 'Oxybenzone, Parabens, Petrolatum and Paraffin (USP grade only)', 'Lamer'),
('6', '600', 'L', 'Acetone, Acetonitrile, Benzalkonium chloride', 'Lancome'),
('7', '700', 'S', ' Glycerin, Melia Azadirachta Leaf Extract,', 'Benefit'),
('8', '800', 'M', 'PFAS compounds, Nitromusks and Polycyclic Musks', 'UrbanDecay'),
('9', '900', 'S', 'EDTA and derivatives (allowed if no technical substitute under 0.2%)', 'Givenchy'),
('10', '1000', 'M', 'Retinyl Palmitate, Styrene', 'TomFord');

--OrderLocation
INSERT Cosmetics.OrderLocation (OrderAddressID, Country, State, City, Street, ZIPCode)
VALUES
('1', 'U.S.', 'Washington', 'Bellevue', '14742 SE Eastgate Dr', '98006'),
('2', 'U.S.', 'Oregon', 'Lakeview', '207 N L St', '97630'),
('3', 'U.S.', 'New Mexico', 'Albuquerque', '3828 Piermont Dr NE', '87111'),
('4', 'U.S.', 'Florida', 'Miami Beach', '1155 103rd St', '33154'),
('5', 'U.S.', 'Pennsylvania', 'Philadelphia', '3412 Trevi Ct', '19145'),
('6', 'U.S.', 'Kansas', 'Newton', '212 E 8th St','67114'),
('7', 'U.S.', 'Arizona', 'Tempe', '2046 S College Ave', '85282'),
('8', 'U.S.', 'California', 'San Pedro', '613 Leavenworth Dr', '90731'),
('9', 'U.S.', 'Illinois', 'Cicero', '3435 S 57th Ct', '60804'),
('10', 'U.S.', 'Texas', '1535 Whitaker Ave', 'Dallas', '75216');

--Orders
INSERT Cosmetics.Orders (OrderID, CustomerID, OrderDate, RetailerID, OrderAddressID)
VALUES
('2000', '100', '2022-11-01', '0007', '1'),
('2001', '100', '2022-10-03', '0001', '1'),
('2002', '103', '2022-11-24', '0004', '3'),
('2003', '105', '2022-05-11', '0009', '5'),
('2004', '105', '2022-05-11', '0008', '5'),
('2005', '105', '2022-07-07', '0003', '5'),
('2006', '104', '2022-08-31', '0003', '4'),
('2007', '109', '2022-03-03', '0003', '9'),
('2008', '101', '2022-09-07', '0004', '7'), 
('2009', '103', '2022-11-11', '0002', '2');

--OrderItems
INSERT Cosmetics.OrderItems (OrderID, OrderItemID, UnitPrice, Quantity, ProductID)
VALUES
('2000', '1', '100', '4', '1'),
('2000', '2', '300', '2', '3'),
('2001', '3', '300', '1', '3'),
('2002', '4', '700', '10', '7'),
('2003', '5', '700', '20', '7'),
('2004', '6', '400', '3', '4'),
('2004', '7', '100', '1', '1'),
('2005', '8', '400', '7', '4'),
('2006', '9', '1000', '4', '10'),
('2007', '10', '500', '1', '5'),
('2007', '11', '600', '1', '4'),
('2007', '12', '200', '7', '2'),
('2008', '13', '1000', '2', '10'),
('2009', '14', '200', '1', '2');

--Reviews
INSERT INTO Cosmetics.Review (ProductID, CustomerID, SubmitDate, Rating, CommentText, Helpfulness)
VALUES (N'1', N'100', N'2022-11-01', N'10', N'Wonderful', N'10'),
(N'1', N'101', N'2022-11-02', N'9', N'Amazing', N'9'),
(N'1', N'102', N'2022-11-02', N'9', N'Amazing', N'9'),
(N'2', N'102', N'2022-11-02', N'9', N'Amazing', N'9'),
(N'2', N'103', N'2022-11-12', N'8', N'Amazing', N'7'),
(N'2', N'108', N'2022-11-02', N'9', N'Amazing', N'9'),
(N'3', N'102', N'2022-10-02', N'5', N'Average', N'7.5'),
(N'3', N'104', N'2022-11-16', N'7', N'So so', N'8'),
(N'5', N'106', N'2022-09-26', N'3', N'terrible', N'2'),
(N'6', N'109', N'2022-09-30', N'1', N'piece of shit', N'0');

--Subscribe
INSERT INTO Cosmetics.Subscribe 
VALUES (100, 1, '2022-11-01', '2023-02-01'),
(100, 2, '2022-10-01', '2023-01-01'),
(102, 2, '2022-11-11', '2023-11-11'),
(103, 8, '2021-09-07', '2022-12-31'),
(104, 6, '2022-10-24', '2023-10-24'),
(104, 9, '2022-02-15', '2023-02-15'),
(105, 9, '2022-11-25', '2023-12-25'),
(106, 8, '2022-06-01', '2023-02-01'),
(109, 4, '2022-07-21', '2023-03-21'),
(108, 7, '2021-12-01', '2022-12-01');







