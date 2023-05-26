--ERZEUGUNG PRODUKTTABELLE
CREATE TABLE WI2_WSA994_PRODUCT (
                                  P_Product_ID VARCHAR2 (10BYTE) NOT NULL ,
                                  P_Division VARCHAR2 (10BYTE),
                                  P_ProductCategory VARCHAR2(10BYTE),
                                  P_ProductDescription VARCHAR2(50BYTE),
                                  P_SalesPrice NUMBER(10,2),
                                  P_ProductionCosts NUMBER(10,2),
                                  CONSTRAINT PK_P_PRODUCT PRIMARY KEY (P_Product_ID)

);
SELECT * FROM WI2_WSA994_PRODUCT;
DROP TABLE WI2_WSA994_PRODUCT;
--Testinsert Product
INSERT INTO WI2_WSA994_PRODUCT (P_Product_ID, P_Division, P_ProductCategory, P_ProductDescription, P_SalesPrice, P_ProductionCosts)
VALUES ('DB-001', 'Gear', 'Off-Road', 'Off-Road Dirt Bike', 4999.99, 3499.99);

INSERT INTO WI2_WSA994_PRODUCT (P_Product_ID, P_Division, P_ProductCategory, P_ProductDescription, P_SalesPrice, P_ProductionCosts)
VALUES ('DB-002', 'MotorBikes', 'Road', 'High-Performance Racing Dirt Bike', 7999.99, 5999.99);




--ERZEUGUNG KUNDENTABELLE
CREATE TABLE WI2_WSA994_CUSTOMER (
                                   C_Customer_ID VARCHAR2 (10BYTE) NOT NULL ,
                                   C_Country VARCHAR2 (50BYTE),
                                   C_SalesOrg VARCHAR2(50BYTE),
                                   C_City VARCHAR2(20BYTE),
                                   C_CustomerDescription VARCHAR2(50BYTE),
                                   C_ValidTo DATE,
                                   C_ValidFrom DATE NOT NULL,
                                   CONSTRAINT PK_C_CUSTOMER PRIMARY KEY (C_Customer_ID, C_ValidFrom)

);

SELECT * FROM WI2_WSA994_CUSTOMER;
DROP TABLE WI2_WSA994_CUSTOMER;
--Testinsert Customer
INSERT INTO WI2_WSA994_CUSTOMER (C_Customer_ID, C_Country, C_SalesOrg, C_City, C_CustomerDescription, C_ValidTo, C_ValidFrom)
VALUES ('CUST-001', 'Germany', 'Northern Region', 'Hamburg', 'Large Retail Chain', TO_DATE('2023-12-31', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'));

INSERT INTO WI2_WSA994_CUSTOMER (C_Customer_ID, C_Country, C_SalesOrg, C_City, C_CustomerDescription, C_ValidTo, C_ValidFrom)
VALUES ('CUST-002', 'France', 'Southern Region', 'Marseille', 'Small Bike Shop', TO_DATE('2024-06-30', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'));


--ERZEUGUNG FT
CREATE TABLE WI2_WSA994_FACTTABLE (
                                    FT_Product_ID VARCHAR2 (10BYTE) NOT NULL ,
                                    FT_Customer_ID VARCHAR2 (10BYTE) NOT NULL,
                                    FT_Time_ID DATE NOT NULL,
                                    FT_RevenueUSD NUMBER(20,2),
                                    FT_DiscountUSD NUMBER(20,2),
                                    FT_CostOfGoodsSoldUSD NUMBER(20,2),
                                    FT_SalesQuantity NUMBER(20,2),
                                    FT_NoOfSalesOrders NUMBER(20,2),
                                    CONSTRAINT PK_FT_FACTTABLE PRIMARY KEY (FT_Product_ID,FT_Customer_ID,FT_Time_ID)



);

ALTER TABLE WI2_WSA994_FACTTABLE ADD CONSTRAINT FK_FT_PRODUCT FOREIGN KEY (FT_Product_ID) REFERENCES WI2_WSA994_PRODUCT(P_Product_ID);

ALTER TABLE WI2_WSA994_FACTTABLE
  ADD CONSTRAINT FK_FT_CUSTOMER
    FOREIGN KEY (FT_Customer_ID, FT_Time_ID)
      REFERENCES WI2_WSA994_CUSTOMER (C_Customer_ID, C_ValidFrom)
  DISABLE NOVALIDATE;

SELECT * FROM WI2_WSA994_FACTTABLE;
DROP TABLE WI2_WSA994_FACTTABLE;

--Testinsert Facttable
INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD, FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-001', 'CUST-001', TO_DATE('2023-05-08', 'YYYY-MM-DD'), 4499.99, 225, 2999.99, 1, 1);

INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD, FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-001', 'CUST-001', TO_DATE('2023-06-09', 'YYYY-MM-DD'), 4499.99, 225, 2999.99, 1, 1);

INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD, FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-002', 'CUST-002', TO_DATE('2020-12-23', 'YYYY-MM-DD'), 7199.99, 0, 4799.99, 1, 1);



--Erzeugung FCT
CREATE TABLE AGG_WI2_WSA994_FACTCONSTELLATIONTABLE(
                                                    AGG_RevenueUSD NUMBER (20,2),
                                                    AGG_DiscountUSD NUMBER (20,2),
                                                    AGG_CostOfSoldGoods NUMBER (20,2),
                                                    AGG_SalesQuantity NUMBER (20,2),
                                                    AGG_NoOfSalesOrders NUMBER (20,2),

                                                    AGG_ProductCategory VARCHAR2(10 BYTE) NOT NULL,
                                                    AGG_Division VARCHAR2(10 BYTE) NOT NULL,
                                                    AGG_Time_Month NUMBER NOT NULL,
                                                    AGG_Time_Year NUMBER NOT NULL,
                                                    AGG_Customer_ID VARCHAR2(10 BYTE) NOT NULL,
                                                    AGG_Fact_Count NUMBER NOT NULL,
                                                    CONSTRAINT PK_AGG_SV PRIMARY KEY (AGG_ProductCategory, AGG_Division, AGG_Time_Month, AGG_Time_Year, AGG_Customer_ID)
);

SELECT * FROM AGG_WI2_WSA994_FACTCONSTELLATIONTABLE;
DROP TABLE AGG_WI2_WSA994_FACTCONSTELLATIONTABLE;

--Testinsert FCT
INSERT INTO AGG_WI2_WSA994_FACTCONSTELLATIONTABLE (AGG_RevenueUSD, AGG_DiscountUSD, AGG_CostOfSoldGoods, AGG_SalesQuantity, AGG_NoOfSalesOrders, AGG_ProductCategory, AGG_Division, AGG_Time_Month, AGG_Time_Year, AGG_Customer_ID, AGG_Fact_Count)
SELECT
  SUM(FT_RevenueUSD),
  SUM(FT_DiscountUSD),
  SUM(FT_CostOfGoodsSoldUSD),
  SUM(FT_SalesQuantity),
  SUM(FT_NoOfSalesOrders),
  P_ProductCategory,
  P_Division,
  EXTRACT(MONTH FROM FT_Time_ID),
  EXTRACT(YEAR FROM FT_Time_ID),
  FT_Customer_ID,
  COUNT(*)
FROM WI2_WSA994_FACTTABLE
       JOIN WI2_WSA994_PRODUCT ON FT_Product_ID = P_Product_ID
GROUP BY P_ProductCategory, P_Division, EXTRACT(MONTH FROM FT_Time_ID), EXTRACT(YEAR FROM FT_Time_ID), FT_Customer_ID;



--Berechtigung für Soheil
GRANT SELECT ON WI2_WSA994_PRODUCT TO DB_2639493;
GRANT SELECT ON WI2_WSA994_CUSTOMER TO DB_2639493;
GRANT SELECT ON WI2_WSA994_FACTTABLE TO DB_2639493;
GRANT SELECT ON AGG_WI2_WSA994_FACTCONSTELLATIONTABLE TO DB_2639493;


--Berechtigung DB_SCH
GRANT SELECT ON WI2_WSA994_PRODUCT TO DB_SCH;
GRANT SELECT ON WI2_WSA994_CUSTOMER TO DB_SCH;
GRANT SELECT ON WI2_WSA994_FACTTABLE TO DB_SCH;
GRANT SELECT ON AGG_WI2_WSA994_FACTCONSTELLATIONTABLE TO DB_SCH;