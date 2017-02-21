--Drop tables and cascade constraints
DROP TABLE PackSize_Product CASCADE CONSTRAINTS PURGE;

DROP TABLE NonDrugSale CASCADE CONSTRAINTS PURGE;

DROP TABLE PackSize_Drug_Product CASCADE CONSTRAINTS PURGE;

DROP TABLE PackSize CASCADE CONSTRAINTS PURGE;

DROP TABLE DrugSale CASCADE CONSTRAINTS PURGE;

DROP TABLE Prescriptions CASCADE CONSTRAINTS PURGE;

DROP TABLE DrugProduct CASCADE CONSTRAINTS PURGE;

DROP TABLE DrugType CASCADE CONSTRAINTS PURGE;

DROP TABLE NonDrugProduct CASCADE CONSTRAINTS PURGE;

DROP TABLE Supplier CASCADE CONSTRAINTS PURGE;

DROP TABLE Doctor CASCADE CONSTRAINTS PURGE;

DROP TABLE Staff CASCADE CONSTRAINTS PURGE;

DROP TABLE StaffRole CASCADE CONSTRAINTS PURGE;

DROP TABLE Brand CASCADE CONSTRAINTS PURGE;

DROP TABLE Customer CASCADE CONSTRAINTS PURGE;

--Create table for brand details
CREATE TABLE Brand
(
	brandID              NUMBER(6) NOT NULL ,
	brandName            VARCHAR2(30) NOT NULL ,
CONSTRAINT Brand_PK PRIMARY KEY (brandID) --Add PK
);

--Create table for customer details
CREATE TABLE Customer
(
	customerID           NUMBER(6) NOT NULL ,
	custName             VARCHAR2(30) NOT NULL ,
	custAddress          VARCHAR2(50) NOT NULL ,
	medicalCard          VARCHAR2(15) NULL ,
CONSTRAINT Customer_PK PRIMARY KEY (customerID) --Add PK
);

--Create table for doctor details
CREATE TABLE Doctor
(
	doctorID             NUMBER(6) NOT NULL ,
	doctorName			 VARCHAR2(30) NOT NULL,
	surgeryDetails       VARCHAR2(50) NOT NULL,
CONSTRAINT Doctor_PK PRIMARY KEY (doctorID) --Add PK
);

--Create table for details of packsizes
CREATE TABLE PackSize
(
	sizeID               NUMBER(6) NOT NULL ,
	sizeDesc             VARCHAR2(30) NOT NULL ,
CONSTRAINT PackSize_PK PRIMARY KEY (sizeID) --Add PK
);

--Create table for drug product details
CREATE TABLE DrugProduct
(
	drugID               NUMBER(6) NOT NULL ,
	prodDesc             VARCHAR2(30) NOT NULL ,
	prodCostPrice        NUMBER(7,2) NOT NULL ,
	prodRetailPrice      NUMBER(7,2) NOT NULL ,
	prescription         VARCHAR2(1) NULL ,
	drugTypeID           NUMBER(6) NOT NULL ,
	suppID               NUMERIC(6) NOT NULL ,
	brandID              NUMBER(6) NOT NULL ,
CONSTRAINT Drug_Product_PK PRIMARY KEY (drugID) --Add PK
);

--Create weak entity relation for packsize and drug
CREATE TABLE PackSize_Drug_Product
(
	sizeID               NUMBER(6) NOT NULL ,
	drugID               NUMBER(6) NOT NULL ,
CONSTRAINT PackSize_Drug_Product_PK PRIMARY KEY (sizeID,DrugID) --Add PK
);

--Create table for drug product details
CREATE TABLE DrugType
(
	drugTypeID           NUMBER(6) NOT NULL ,
	drugName             VARCHAR2(50) NOT NULL ,
	dosage               VARCHAR2(50) NOT NULL ,
	dispensingInstructions VARCHAR2(50) NOT NULL ,
	useInstructions      VARCHAR2(50) NOT NULL ,
CONSTRAINT DrugType_PK PRIMARY KEY (drugTypeID) --Add PK
);

--Create table for non drug product details
CREATE TABLE NonDrugProduct
(
	nonDrugID            NUMBER(6) NOT NULL ,
	prodDesc             VARCHAR2(30) NOT NULL ,
	prodCostPrice        NUMBER(7,2) NOT NULL ,
	prodRetailPrice      NUMBER(7,2) NOT NULL ,
	suppID               NUMBER(6) NOT NULL ,
	brandID              NUMBER(6) NOT NULL ,
	prescription         VARCHAR2(1) NULL ,
CONSTRAINT Non_Drug_Product_PK PRIMARY KEY (nonDrugID) --Add PK
);

--Weak entity for pack size and non drug products
CREATE TABLE PackSize_Product
(
	sizeID               NUMBER(6) NOT NULL ,
	nonDrugID            NUMBER(6) NOT NULL ,
CONSTRAINT PackSize_Product_PK PRIMARY KEY (sizeID,nonDrugID) --Add PK
);

--Create table for prescriptions
CREATE TABLE Prescriptions
(
	prescriptionID       NUMBER(6) NOT NULL , --Must be filled 
	customerID           NUMBER(6) NOT NULL , --Must be filled
	doctorID             NUMBER(6) NOT NULL , --Must be filled
	drugID               NUMBER(6) NULL ,	  --Will be filled through UPDATE
	staffID              NUMBER(6) NOT NULL , --Must be filled
	brandID              NUMBER(6) NULL ,     --Will be filled through UPDATE
	dispensingStaff      NUMBER(6) NULL ,  --Will be filled through UPDATE
	drugInstructions     VARCHAR2(50) NULL ,  --Will be filled through UPDATE
	nonDrugID            NUMBER(6) NULL ,     --Will be filled through UPDATE
CONSTRAINT Prescriptions_PK PRIMARY KEY (prescriptionID) --Add PK
);

--Create table for staff details
CREATE TABLE Staff
(
	staffID              NUMBER(6) NOT NULL ,
	name                 VARCHAR2(30) NOT NULL ,
	address              VARCHAR2(30) NOT NULL ,
	phoneNo              VARCHAR2(20) NOT NULL ,
	email                VARCHAR2(30) NOT NULL ,
	PPSNo                VARCHAR2(10) NOT NULL ,
	roleID               NUMBER(6) NOT NULL ,
CONSTRAINT Staff_PK PRIMARY KEY (staffID) --Add PK
);

--Create table for non drug sales
CREATE TABLE NonDrugSale
(
	nonDrugID            NUMBER(6) NOT NULL ,
	dateTimeSale         TIMESTAMP NOT NULL ,
	qtySold              NUMBER(3) NOT NULL ,
	staffID              NUMBER(6) NOT NULL ,
CONSTRAINT NonDrugSale_PK PRIMARY KEY (nonDrugID,dateTimeSale,staffID) --Add PK
);

--Create table for drug sales
CREATE TABLE DrugSale
(
	staffID              NUMBER(6) NOT NULL ,
	dateTimeSale         TIMESTAMP NOT NULL ,
	drugID               NUMBER(6) NULL ,
	nonDrugID            NUMBER(6) NULL ,
	prescriptionID       NUMBER(6) NULL ,
	customerID           NUMBER(6) NULL ,
	qtySold              NUMBER(3) NOT NULL ,
CONSTRAINT DrugSale_PK PRIMARY KEY (staffID,dateTimeSale) --Add PK
);

--Create table for staff roles
CREATE TABLE StaffRole
(
	roleID               NUMBER(6) NOT NULL ,
	roleDesc             VARCHAR2(30) NOT NULL ,
CONSTRAINT StaffRole_PK PRIMARY KEY (roleID) --Add PK
);

--Create table for supplier details
CREATE TABLE Supplier
(
	suppID               NUMBER(6) NOT NULL ,
	suppName             VARCHAR2(30) NOT NULL ,
	suppAddress          VARCHAR2(50) NOT NULL ,
	suppPhone            VARCHAR2(20) NOT NULL ,
CONSTRAINT Supplier_PK PRIMARY KEY (suppID) --Add PK
);

COMMIT;

--Alter tables to create foreign keys
ALTER TABLE DrugProduct
	ADD (CONSTRAINT DrugProduct1_FK FOREIGN KEY (suppID) REFERENCES Supplier (suppID));

ALTER TABLE DrugProduct
	ADD (CONSTRAINT DrugProduct2_FK FOREIGN KEY (brandID) REFERENCES Brand (brandID));

ALTER TABLE DrugProduct
	ADD (CONSTRAINT DrugProduct3_FK FOREIGN KEY (drugTypeID) REFERENCES DrugType (drugTypeID));

ALTER TABLE PackSize_Drug_Product
	ADD (CONSTRAINT NonDrugPackSize1_FK FOREIGN KEY (sizeID) REFERENCES PackSize (sizeID));

ALTER TABLE PackSize_Drug_Product
	ADD (CONSTRAINT NonDrugPackSize2_FK FOREIGN KEY (drugID) REFERENCES DrugProduct (drugID));

ALTER TABLE NonDrugProduct
	ADD (CONSTRAINT NonDrug1_FK FOREIGN KEY (suppID) REFERENCES Supplier (suppID));

ALTER TABLE NonDrugProduct
	ADD (CONSTRAINT NonDrug2_FK FOREIGN KEY (brandID) REFERENCES Brand (brandID));

ALTER TABLE PackSize_Product
	ADD (CONSTRAINT PackSizeDrug1_FK FOREIGN KEY (sizeID) REFERENCES PackSize (sizeID));

ALTER TABLE PackSize_Product
	ADD (CONSTRAINT PackSizeDrug2_FK FOREIGN KEY (nonDrugID) REFERENCES NonDrugProduct (nonDrugID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription1_FK FOREIGN KEY (brandID) REFERENCES Brand (brandID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription2_FK FOREIGN KEY (staffID) REFERENCES Staff (staffID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription3_FK FOREIGN KEY (customerID) REFERENCES Customer (customerID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription4_FK FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription5_FK FOREIGN KEY (nonDrugID) REFERENCES NonDrugProduct (nonDrugID));

ALTER TABLE Prescriptions
	ADD (CONSTRAINT Prescription6_FK FOREIGN KEY (drugID) REFERENCES DrugProduct (drugID));

ALTER TABLE Staff
	ADD (CONSTRAINT Staff1_FK FOREIGN KEY (roleID) REFERENCES StaffRole (roleID));

ALTER TABLE NonDrugSale
	ADD (CONSTRAINT NonDrugSale1_FK FOREIGN KEY (nonDrugID) REFERENCES NonDrugProduct (nonDrugID));

ALTER TABLE NonDrugSale
	ADD (CONSTRAINT NonDrugSale2_FK FOREIGN KEY (staffID) REFERENCES Staff (staffID));

ALTER TABLE DrugSale
	ADD (CONSTRAINT DrugSale1_FK FOREIGN KEY (customerID) REFERENCES Customer (customerID));

ALTER TABLE DrugSale
	ADD (CONSTRAINT DrugSale2_FK FOREIGN KEY (prescriptionID) REFERENCES Prescriptions (prescriptionID));

ALTER TABLE DrugSale
	ADD (CONSTRAINT DrugSale3_FK FOREIGN KEY (nonDrugID) REFERENCES NonDrugProduct (nonDrugID));

ALTER TABLE DrugSale
	ADD (CONSTRAINT DrugSale4_FK FOREIGN KEY (drugID) REFERENCES DrugProduct (drugID));

ALTER TABLE DrugSale
	ADD (CONSTRAINT DrugSale5_FK FOREIGN KEY (staffID) REFERENCES Staff (staffID));

-- Commit changes
COMMIT;

--Insert into Brand table
INSERT INTO Brand(brandID, brandName) VALUES (101, 'Panadol');
INSERT INTO Brand(brandID, brandName) VALUES  (102, 'Disprin');
INSERT INTO Brand(brandID, brandName) VALUES  (103, 'Nurofen');
INSERT INTO Brand(brandID, brandName) VALUES  (104, 'Dulcolax');
INSERT INTO Brand(brandID, brandName) VALUES  (105, 'Easofen');
INSERT INTO Brand(brandID, brandName) VALUES  (106, 'Anadin');
INSERT INTO Brand(brandID, brandName) VALUES  (107, 'Band-Aid');
INSERT INTO Brand(brandID, brandName) VALUES  (108, 'Optrex');
INSERT INTO Brand(brandID, brandName) VALUES (109, 'Durex');
INSERT INTO Brand(brandID, brandName) VALUES (110, 'Colgate');
INSERT INTO Brand(brandID, brandName) VALUES (111, 'Seven Seas');
INSERT INTO Brand(brandID, brandName) VALUES (112, 'Zirtek');

--Insert into Customer table
INSERT INTO Customer(customerID, custName, custAddress) VALUES (700, 'Josh Wyler', '18 Aungier st');
INSERT INTO Customer(customerID, custName, custAddress, medicalCard) VALUES (701, 'Mairead Mahon', '7 Little Meadow', 'E32HTYSA');
INSERT INTO Customer(customerID, custName, custAddress, medicalCard) VALUES (702, 'Nicola Flynn', '2 Hillview Lawn', 'E98MNHAB');
INSERT INTO Customer(customerID, custName, custAddress) VALUES (703, 'Marcus Byrne', '24 Pottery Rd');
INSERT INTO Customer(customerID, custName, custAddress) VALUES (704, 'Jason Trim', '17 Trek Path');
INSERT INTO Customer(customerID, custName, custAddress, medicalCard) VALUES (705, 'Vimal Jain', '40 Holmwood Pass', 'E11HGTSB');

--Insert into StaffRole table
INSERT INTO StaffRole(roleID, roleDesc) VALUES (901, 'Counter Staff');
INSERT INTO StaffRole(roleID, roleDesc) VALUES (902, 'Pharmacist');
INSERT INTO StaffRole(roleID, roleDesc) VALUES (903, 'Floor Staff');

--Insert into Staff table
INSERT INTO Staff(staffID, name, address, phoneNo, email, PPSNo, roleID) VALUES (900203, 'Kevin', '12 Donnybrook Castle', '8327659', 'kevin@gmail.com', '7625648B', 901);
INSERT INTO Staff(staffID, name, address, phoneNo, email, PPSNo, roleID) VALUES (900312, 'George', '54 Glenageary Cresent', '2866512', 'georgieboy@gmail.com', '90121334A', 902);
INSERT INTO Staff(staffID, name, address, phoneNo, email, PPSNo, roleID) VALUES (900122, 'Susan', '11 Long Meadow', '2127765', 'susan@gmail.com', '4558178C', 903);
INSERT INTO Staff(staffID, name, address, phoneNo, email, PPSNo, roleID) VALUES (900333, 'Elfie', '32 Meadow Vale', '2117956', 'elfie@gmail.com', '9882331B', 901);

--Insert into Doctor table
INSERT INTO Doctor(doctorID, doctorName, surgeryDetails) VALUES (5003, 'Dr Cullinane', 'Johnstown Medical');
INSERT INTO Doctor(doctorID, doctorName, surgeryDetails) VALUES (5002, 'Dr Mulvuney', 'Johnstown Medical');
INSERT INTO Doctor(doctorID, doctorName, surgeryDetails) VALUES (5001, 'Dr Lacey', 'DunLaoghaire Surgery');
INSERT INTO Doctor(doctorID, doctorName, surgeryDetails) VALUES (5004, 'Dr McSwiney', 'Harolds Cross Medical');

--Insert into Supplier table
INSERT INTO Supplier(suppID, suppName, suppAddress, suppPhone) VALUES (111, 'Phizer', 'Phizer, Pottery Rd, Dun Laoghaire, Dublin', '01-2876884');
INSERT INTO Supplier(suppID, suppName, suppAddress, suppPhone) VALUES (112, 'Murrays Medical Supplies', 'Murrays, Talbot St, Dublin', '01-8862445');

--Insert into NonDrugProduct table
INSERT INTO NonDrugProduct(nonDrugID, prodDesc, prodCostPrice, prodRetailPrice, suppID, brandID) VALUES (201, 'Bandages', 1.85, 3, 112, 107);
INSERT INTO NonDrugProduct(nonDrugID, prodDesc, prodCostPrice, prodRetailPrice, suppID, brandID) VALUES (202, 'Eye Wash', 3.50, 5.99, 112, 108);
INSERT INTO NonDrugProduct(nonDrugID, prodDesc, prodCostPrice, prodRetailPrice, suppID, brandID, prescription) VALUES (203, 'Condoms', 2.50, 6.50, 112, 109, 'P'); --Lets pretend its the 70's
INSERT INTO NonDrugProduct(nonDrugID, prodDesc, prodCostPrice, prodRetailPrice, suppID, brandID) VALUES (204, 'Toothpaste', 1.75, 2.99, 112, 110);
INSERT INTO NonDrugProduct(nonDrugID, prodDesc, prodCostPrice, prodRetailPrice, suppID, brandID) VALUES (205, 'Fish Oils', 5.50, 11.99, 112, 111);

--Insert into DrugType table]
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (021, 'Paracetamol', '2 for Adult, 1 for Children', 'Only one paracetamol item per sale', '2 every 4 hrs, max 8 per 24hrs');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (022, 'iBuprofen', '1-2 for Adult, not for kids', 'Max 1 item per sale', '1-2 every 4hrs, max 12 per 24hrs');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (023, 'Aspirin', '2 for Adult, 1 for Children', 'Max 1 item per sale', '2 every 3-4hrs, max 12 per 24hrs');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (024, 'Bisacodyl', '10mg', 'May be sold with other items', '10mg as needed');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (025, 'Codeine', '2-4 pills', 'Must have prescription', '2-4 as required, max 12 in 24hrs');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (026, 'Vitamins', '1', 'Must have prescription', '1 per day');
INSERT INTO DrugType(drugTypeID, drugName, dosage, dispensingInstructions, useInstructions) VALUES (027, 'Cetrizine', '1 for Adult, 1/2 for child', 'Must have prescription', '1 per day');

--Insert into DrugProduct table
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, drugTypeID, suppID, brandID) VALUES (301, 'Pain Killer', 1.75, 2.95, 021, 111, 101);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, prescription, drugTypeID, suppID, brandID) VALUES (302, 'Extra Strength Pain Killer', 3.20, 8.95, 'P', 025, 111, 103);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, drugTypeID, suppID, brandID) VALUES (303, 'Gastro Relief', 2.15, 4.50, 024, 111, 104);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, drugTypeID, suppID, brandID) VALUES (304, 'Pain Killer', 2, 3.50, 022, 111, 105);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, prescription, drugTypeID, suppID, brandID) VALUES (305, 'Pain Killer', 2.75, 4.90, 'P', 023, 111, 102);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice,drugTypeID, suppID, brandID) VALUES (306, 'Pain Killer', 1.90, 3.75, 023, 111, 106);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, prescription, drugTypeID, suppID, brandID) VALUES (307, 'Extra Strength Multi-Vitamin', 3.60, 8.95, 'P', 026, 111, 111);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, prescription, drugTypeID, suppID, brandID) VALUES (308, 'Rectal Supository', 4.90, 10.95, 'P', 024, 111, 104);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, prescription, drugTypeID, suppID, brandID) VALUES (309, 'Antihistamine Extra Strength', 3.75, 6.50, 'P', 027, 111, 112);
INSERT INTO DrugProduct(drugID, prodDesc, prodCostPrice, prodRetailPrice, drugTypeID, suppID, brandID) VALUES (310, 'Antihistamine', 1.75, 2.95, 027, 111, 105);

--Partial insert into Prescriptions table, rest to be filled by dispensing staff with an Update
INSERT INTO Prescriptions(prescriptionID, customerID, doctorID, staffID) VALUES (100311, 701, 5003, 900203);
INSERT INTO Prescriptions(prescriptionID, customerID, doctorID, staffID) VALUES (100312, 702, 5002, 900203);
INSERT INTO Prescriptions(prescriptionID, customerID, doctorID, staffID) VALUES (100313, 704, 5001, 900333);
INSERT INTO Prescriptions(prescriptionID, customerID, doctorID, staffID) VALUES (100324, 705, 5004, 900333);

INSERT INTO DrugSale(staffID, dateTimeSale, drugID, customerID, prescriptionID, qtySold) VALUES (900203, to_timestamp('2016-12-06 11:30:15', 'YYYY-MM-DD HH24:MI:SS'), 302, 701, 100311, 1);
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, customerID, prescriptionID, qtySold) VALUES (900203, to_timestamp('2016-12-06 13:25:18', 'YYYY-MM-DD HH24:MI:SS'), 307, 702, 100312, 1);
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, customerID, prescriptionID, qtySold) VALUES (900333, to_timestamp('2016-12-06 09:45:22', 'YYYY-MM-DD HH24:MI:SS'), 308, 704, 100313, 1);
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, customerID, prescriptionID, qtySold) VALUES (900333, to_timestamp('2016-12-06 15:52:32', 'YYYY-MM-DD HH24:MI:SS'), 309, 705, 100324, 1);

--Insert into DrugSale table full drug sales
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, qtySold) VALUES (900333, to_timestamp('2016-12-06 12:47:15', 'YYYY-MM-DD HH24:MI:SS'), 301, 1);
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, qtySold) VALUES (900203, to_timestamp('2016-12-06 09:39:10', 'YYYY-MM-DD HH24:MI:SS'), 310,  2);
INSERT INTO DrugSale(staffID, dateTimeSale, drugID, qtySold) VALUES (900203, to_timestamp('2016-12-07 10:52:20', 'YYYY-MM-DD HH24:MI:SS'), 303, 1); 
INSERT INTO DrugSale(staffID, dateTimeSale, nonDrugID, qtySold) VALUES (900333, to_timestamp('2016-12-07 17:30:10', 'YYYY-MM-DD HH24:MI:SS'), 203, 3);

--Insert into PackSize table
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (401, '12 Pack');
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (402, '24 Pack');
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (403, '8 Pack');
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (404, '50 Pack');
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (405, '150ml');
INSERT INTO PackSize(sizeID, sizeDesc) VALUES (406, '1');

--Insert into packsize weak entity 
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (401, 301);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 301);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (401, 302);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 302);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (405, 303);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (401, 304);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 305);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (401, 306);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 306);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (404, 307);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (403, 308);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 309);
INSERT INTO PackSize_Drug_Product(sizeID, drugID) VALUES (402, 310);

--Insert into NonDrugSale table
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (204, to_timestamp('2016-12-05 14:20:10', 'YYYY-MM-DD HH24:MI:SS'), 2, 900203);
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (201, to_timestamp('2016-12-05 09:46:20', 'YYYY-MM-DD HH24:MI:SS'), 3, 900203);
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (205, to_timestamp('2016-12-05 11:46:17', 'YYYY-MM-DD HH24:MI:SS'), 1, 900203);
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (202, to_timestamp('2016-12-07 13:15:08', 'YYYY-MM-DD HH24:MI:SS'), 2, 900122);
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (204, to_timestamp('2016-12-07 16:32:47', 'YYYY-MM-DD HH24:MI:SS'), 4, 900122);
INSERT INTO NonDrugSale(nonDrugID, dateTimeSale, qtySold, staffID) VALUES (205, to_timestamp('2016-12-07 12:46:10', 'YYYY-MM-DD HH24:MI:SS'), 3, 900203);

--Insert into packsize weak entity
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (401, 201);
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (402, 201);
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (405, 202);
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (401, 203);
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (406, 204);
INSERT INTO PackSize_Product(sizeID, nonDrugID) VALUES (404, 205);

--Commit changes
COMMIT;

--Now lets assume a customer has given their prescription to the counter staff,
--It was partially completed, now it has been sent to the pharmacist, who has
--updated the records, filling in what drug and brand was given and recording himself as dispensing it
UPDATE Prescriptions SET drugID = 302, brandID = 103, dispensingStaff = 900312 WHERE prescriptionID = 100311;
UPDATE Prescriptions SET drugID = 307, brandID = 111, dispensingStaff = 900312 WHERE prescriptionID = 100312;
UPDATE Prescriptions SET drugID = 308, brandID = 104, dispensingStaff = 900312 WHERE prescriptionID = 100313;
UPDATE Prescriptions SET drugID = 309, brandID = 112, dispensingStaff = 900312 WHERE prescriptionID = 100324;

COMMIT;

--Display drug effects and the type of drug as well as general use instructions
SELECT D.prodDesc AS "Drug Effect", LOWER(N.drugName), N.useInstructions
FROM DrugProduct D
JOIN DrugType N ON N.drugTypeID = D.drugTypeID;

--Display all non-drug sales, double join and to_char, UPPER functions
SELECT UPPER(brandName) AS "Item",  to_char(prodRetailPrice * qtySold, 'U9999.999') AS "Total sale", qtySold AS "Qty Sold", to_char(dateTimeSale,'HH24:MI:SS DD-MM-YYYY ') AS "Date"
FROM NonDrugSale N
JOIN NonDrugProduct D ON N.nonDrugID = D.nonDrugID 
JOIN Brand I ON D.brandID = I.brandID;

--Display Staff names and Job description using left outer join
SELECT UPPER(N.name) AS "Staff name", R.roleDesc AS "Job Description" 
FROM Staff N
LEFT OUTER JOIN StaffRole R ON N.roleID = R.roleID;

--From the spec, the sticky labels to be printed for drug for all labels
SELECT 'Customer name: ' || C.custName || ' ' || 'Usage Instructions: ' || N.useInstructions || ' ' || 'Dosage: ' || N.dosage
FROM Prescriptions P
LEFT OUTER JOIN Customer C ON P.customerID = C.customerID
RIGHT OUTER JOIN DrugProduct T ON P.drugID = T.drugID
JOIN DrugType N on T.drugTypeID = N.drugTypeID
WHERE P.prescriptionID IS NOT NULL;

--From the spec, the sticky labels to be printed for drug for specific customer
SELECT 'Customer name: ' || C.custName || ' ' || 'Usage Instructions: ' || N.useInstructions || ' ' || 'Dosage: ' || N.dosage
FROM Prescriptions P
LEFT OUTER JOIN Customer C ON P.customerID = C.customerID
RIGHT OUTER JOIN DrugProduct T ON P.drugID = T.drugID
JOIN DrugType N on T.drugTypeID = N.drugTypeID
WHERE C.customerID = 704;

--From the spec, the sticky labels to be printed for drug for specific customer
SELECT 'Customer name: ' || C.custName || ' ' || 'Prescription Number: ' || P.prescriptionID
FROM Prescriptions P
LEFT OUTER JOIN Customer C ON P.customerID = C.customerID
ORDER BY C.custName ASC;


--Aggregate functions, add up DRUG sales
--This query kept giving "missing parenthesis" error and I couldn't figure out why, left it in commented
--SELECT 'Average sales: ' || AVG((N.prodRetailPrice * P.qtySold) || ' ' || 'Highest sale: ' || MAX(N.prodRetailPrice * P.qtySold) || ' ' || 'Net profit (retail - cost price): ' || SUM((N.prodCostPrice - N.prodRetailPrice) * P.qtySold))
--FROM DrugSale P
--JOIN DrugProduct N ON P.drugID = N.drugID;

--Alterations

--Add a column to a tbale
ALTER TABLE Customer ADD custEmail VARCHAR2(30);

--Modify a column
ALTER TABLE Customer MODIFY custEmail VARCHAR2(50) DEFAULT 'unknown@unknown.ie';
describe table Customer; --Show changes to Customer table

--Drop column custEmail we just created and describe to show it has taken affect
ALTER TABLE Customer DROP COLUMN custEmail;
describe table Customer;

--Alter Staff table, add constraint check email contains an @ symbol
ALTER TABLE Staff ADD CONSTRAINT email_ck CHECK(email LIKE '%@%');
--Drop email constraint
ALTER TABLE Staff DROP CONSTRAINT email_ck;

COMMIT;