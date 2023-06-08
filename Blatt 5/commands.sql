--ERZEUGUNG PRODUKTTABELLE
CREATE TABLE WI2_WSA994_PRODUCT
(
  P_Product_ID         VARCHAR2(10 BYTE) NOT NULL,
  P_Division           VARCHAR2(10 BYTE),
  P_ProductCategory    VARCHAR2(10 BYTE),
  P_ProductDescription VARCHAR2(50 BYTE),
  P_SalesPrice         NUMBER(10, 2),
  P_ProductionCosts    NUMBER(10, 2),
  CONSTRAINT PK_P_PRODUCT PRIMARY KEY (P_Product_ID)

);

--Testinsert Product
INSERT INTO WI2_WSA994_PRODUCT (P_Product_ID, P_Division, P_ProductCategory, P_ProductDescription, P_SalesPrice,
                                P_ProductionCosts)
VALUES ('DB-001', 'Gear', 'Off-Road', 'Off-Road Dirt Bike', 4999.99, 3499.99);

INSERT INTO WI2_WSA994_PRODUCT (P_Product_ID, P_Division, P_ProductCategory, P_ProductDescription, P_SalesPrice,
                                P_ProductionCosts)
VALUES ('DB-002', 'MotorBikes', 'Road', 'High-Performance Racing Dirt Bike', 7999.99, 5999.99);

--ERZEUGUNG KUNDENTABELLE
CREATE TABLE WI2_WSA994_CUSTOMER
(
  C_Customer_ID         VARCHAR2(10 BYTE) NOT NULL,
  C_Country             VARCHAR2(50 BYTE),
  C_SalesOrg            VARCHAR2(50 BYTE),
  C_City                VARCHAR2(20 BYTE),
  C_CustomerDescription VARCHAR2(50 BYTE),
  C_ValidTo             DATE,
  C_ValidFrom           DATE              NOT NULL,
  CONSTRAINT PK_C_CUSTOMER PRIMARY KEY (C_Customer_ID, C_ValidFrom)

);

--Testinsert Customer
INSERT INTO WI2_WSA994_CUSTOMER (C_Customer_ID, C_Country, C_SalesOrg, C_City, C_CustomerDescription, C_ValidTo, C_ValidFrom)
VALUES ('CUST-001', 'Germany', 'Northern Region', 'Hamburg', 'Large Retail Chain', TO_DATE('2023-12-31', 'YYYY-MM-DD'),
        TO_DATE('2020-01-01', 'YYYY-MM-DD'));

INSERT INTO WI2_WSA994_CUSTOMER (C_Customer_ID, C_Country, C_SalesOrg, C_City, C_CustomerDescription, C_ValidTo, C_ValidFrom)
VALUES ('CUST-002', 'France', 'Southern Region', 'Marseille', 'Small Bike Shop', TO_DATE('2024-06-30', 'YYYY-MM-DD'),
        TO_DATE('2020-01-01', 'YYYY-MM-DD'));


--ERZEUGUNG FT
CREATE TABLE WI2_WSA994_FACTTABLE
(
  FT_Product_ID         VARCHAR2(10 BYTE) NOT NULL,
  FT_Customer_ID        VARCHAR2(10 BYTE) NOT NULL,
  FT_Time_ID            DATE              NOT NULL,
  FT_RevenueUSD         NUMBER(20, 2),
  FT_REVENUEEUR         NUMBER(20, 0),
  FT_DiscountUSD        NUMBER(20, 2),
  FT_CostOfGoodsSoldUSD NUMBER(20, 2),
  FT_SalesQuantity      NUMBER(20, 2),
  FT_NoOfSalesOrders    NUMBER(20, 2),
  CONSTRAINT PK_FT_FACTTABLE PRIMARY KEY (FT_Product_ID, FT_Customer_ID, FT_Time_ID)
);

--Testinsert Facttable
INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD,
                                  FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-001', 'CUST-001', TO_DATE('2023-05-08', 'YYYY-MM-DD'), 4499.99, 225, 2999.99, 1, 1);

INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD,
                                  FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-001', 'CUST-001', TO_DATE('2023-06-09', 'YYYY-MM-DD'), 4499.99, 225, 2999.99, 1, 1);

INSERT INTO WI2_WSA994_FACTTABLE (FT_Product_ID, FT_Customer_ID, FT_Time_ID, FT_RevenueUSD, FT_DiscountUSD, FT_CostOfGoodsSoldUSD,
                                  FT_SalesQuantity, FT_NoOfSalesOrders)
VALUES ('DB-002', 'CUST-002', TO_DATE('2020-12-23', 'YYYY-MM-DD'), 7199.99, 0, 4799.99, 1, 1);

CREATE TABLE AGG_WI2_WSA994_FACTCONSTELLATIONTABLE
(
  AGG_RevenueUSD      NUMBER(20, 2),
  AGG_DiscountUSD     NUMBER(20, 2),
  AGG_CostOfSoldGoods NUMBER(20, 2),
  AGG_SalesQuantity   NUMBER(20, 2),
  AGG_NoOfSalesOrders NUMBER(20, 2),

  AGG_ProductCategory VARCHAR2(10 BYTE) NOT NULL,
  AGG_Division        VARCHAR2(10 BYTE) NOT NULL,
  AGG_Time_Month      NUMBER            NOT NULL,
  AGG_Time_Year       NUMBER            NOT NULL,
  AGG_Customer_ID     VARCHAR2(10 BYTE) NOT NULL,
  AGG_Fact_Count      NUMBER            NOT NULL,
  CONSTRAINT PK_AGG_SV PRIMARY KEY (AGG_ProductCategory, AGG_Division, AGG_Time_Month, AGG_Time_Year, AGG_Customer_ID)
);

INSERT INTO AGG_WI2_WSA994_FACTCONSTELLATIONTABLE (AGG_RevenueUSD, AGG_DiscountUSD, AGG_CostOfSoldGoods, AGG_SalesQuantity,
                                                   AGG_NoOfSalesOrders, AGG_ProductCategory, AGG_Division, AGG_Time_Month,
                                                   AGG_Time_Year, AGG_Customer_ID, AGG_Fact_Count)
SELECT SUM(FT_RevenueUSD),
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
----------------------------
----------------------------
INSERT INTO AGG_WSA994_FACTTABLE (
  AGG_CUSTOMER_ID, AGG_CATEGORY_ID, AGG_DIVISION_ID, AGG_MONTH, AGG_YEAR,
  AGG_REVENUEUSD, AGG_REVENUEEUR, AGG_COGMUSD, AGG_SALESQUANTITY, AGG_NOOFSALESORDERS,
  AGG_NETSALESUSD, AGG_DISCOUNTUSD, AGG_FACT_COUNT
)
SELECT
  FT_CUSTOMER_ID AS AGG_CUSTOMER_ID,
  CATEGORY_ID AS AGG_CATEGORY_ID,
  DIVISION_ID AS AGG_DIVISION_ID,
  EXTRACT(MONTH FROM FT_TIME_ID) AS AGG_MONTH,
  EXTRACT(YEAR FROM FT_TIME_ID) AS AGG_YEAR,
  SUM(FT_REVENUEUSD) AS AGG_REVENUEUSD,
  SUM(FT_REVENUEEUR) AS AGG_REVENUEEUR,
  SUM(FT_COGMUSD) AS AGG_COGMUSD,
  SUM(FT_SALESQUANTITY) AS AGG_SALESQUANTITY,
  SUM(FT_NOOFSALESORDERS) AS AGG_NOOFSALESORDERS,
  SUM(FT_NETSALESUSD) AS AGG_NETSALESUSD,
  SUM(FT_DISCOUNTUSD) AS AGG_DISCOUNTUSD,
  COUNT(*) AS AGG_FACT_COUNT
FROM WSA994_FACTTABLE JOIN WSA994_PRODUCT ON FT_PRODUCT_ID = PRODUCT_ID
GROUP BY CATEGORY_ID, DIVISION_ID, FT_CUSTOMER_ID, EXTRACT(MONTH FROM FT_TIME_ID), EXTRACT(YEAR FROM FT_TIME_ID);

SELECT * FROM AGG_WSA994_FACTTABLE;
SELECT COUNT(*) FROM AGG_WSA994_FACTTABLE;
DELETE FROM AGG_WSA994_FACTTABLE;
commit;

select * from WSA994_CUSTOMER where CURRENT_DATE between VALID_FROM and VALID_TO;
----------------------------
----------------------------
SELECT *
FROM DB_SCH.WI2_ERP10V2_MDORDERHEAD;
SELECT *
FROM DB_SCH.WI2_ERP10V2_MDORDERPOSITION;
SELECT *
FROM DB_SCH.WI2_ERP10V2_MDCUSTOMER;
SELECT *
FROM DB_SCH.WI2_ERP10V2_MDPRODUCTS;
SELECT *
FROM DB_SCH.WI2_ERP10V2_MDPRODUCTCATEGORIES;

DELETE
FROM WSA994_FACTTABLE
WHERE FT_PRODUCT_ID IS NOT NULL;
---------------------------------------------
update WSA994_FACTTABLE
SET FT_REVENUEUSD = WSA994_FACTTABLE.FT_SALESQUANTITY *
                    (SELECT SALESPRICE FROM WSA994_PRODUCT WHERE FT_PRODUCT_ID = PRODUCT_ID);

update WSA994_FACTTABLE
SET FT_COGMUSD = WSA994_FACTTABLE.FT_SALESQUANTITY *
                 (SELECT PRODUCTION_COST FROM WSA994_PRODUCT WHERE FT_PRODUCT_ID = PRODUCT_ID);

update WSA994_FACTTABLE
SET FT_NETSALESUSD = FT_REVENUEUSD - FT_DISCOUNTUSD;
---------------------------------------------
CREATE TABLE WI2_WSA994_EXCHANGERATES
(
  ratedate     date,
  exchangerate number(10, 10)
);

SELECT *
FROM WI2_WSA994_EXCHANGERATES;
SELECT count(*)
FROM WI2_WSA994_EXCHANGERATES;
DROP TABLE WI2_WSA994_EXCHANGERATES;
DELETE
FROM WI2_WSA994_EXCHANGERATES
WHERE RATEDATE IS NOT NULL;

SELECT * FROM WSA994_CUSTOMER;
SELECT COUNT(*) FROM WSA994_CUSTOMER;
DELETE FROM WSA994_CUSTOMER;
CREATE SEQUENCE CUSTOMER_SEQ;

CREATE OR REPLACE TRIGGER CUSTOMER_INSERT
  BEFORE INSERT ON WSA994_CUSTOMER
  FOR EACH ROW
BEGIN
SELECT CUSTOMER_SEQ.nextval
INTO :new.sk
FROM dual;
END;


SELECT *
FROM WSA994_PRODUCT;

INSERT INTO WSA994_FACTTABLE (FT_REVENUEEUR)
SELECT FT_REVENUEUSD * EXCHANGERATE
FROM DB_2631075.WI2_WSA994_EXCHANGERATES
       JOIN DB_2631075.WSA994_FACTTABLE ON RATEDATE = FT_TIME_ID
WHERE FT_TIME_ID = RATEDATE;


--Berechtigung für Soheil
GRANT SELECT ON WI2_WSA994_PRODUCT TO DB_2639493;
GRANT SELECT ON WI2_WSA994_CUSTOMER TO DB_2639493;
GRANT SELECT ON WI2_WSA994_FACTTABLE TO DB_2639493;
GRANT SELECT ON AGG_WI2_WSA994_FACTCONSTELLATIONTABLE TO DB_2639493;

insert into WSA994_FACTTABLE (FT_CUSTOMER_ID, FT_TIME_ID, FT_PRODUCT_ID, FT_SALESQUANTITY, FT_DISCOUNTUSD)
SELECT MDH_CUSTOMERNO, MDH_ORDERDATE, MDP_PRODUCTID, MDP_SALESQUANTITY, MDP_DISCOUNTUSD
FROM DB_SCH.WI2_ERP10V2_MDORDERPOSITION
       JOIN DB_SCH.WI2_ERP10V2_MDORDERHEAD
            ON MDP_ORDERID = MDH_ORDERNO;

SELECT * FROM WSA994_FACTTABLE;
SELECT count(*) FROM WSA994_FACTTABLE;
DELETE FROM WSA994_FACTTABLE;

INSERT INTO WSA994_FACTTABLE (FT_CUSTOMER_ID, FT_TIME_ID, FT_PRODUCT_ID, FT_SALESQUANTITY, FT_DISCOUNTUSD, FT_REVENUEUSD, FT_NETSALESUSD, FT_COGMUSD, FT_NOOFSALESORDERS, FT_REVENUEEUR)
SELECT
  MDH_CUSTOMERNO
     , MDH_ORDERDATE
     ,MDP_PRODUCTID
     , SUM(MDP_SALESQUANTITY) AS MDP_SALESQUANTITY
     , SUM(MDP_DISCOUNTUSD) AS MDP_DISCOUNTUSD
     , SUM(MDP_SALESQUANTITY * SALESPRICE) AS FT_REVENUEUSD
     , SUM((MDP_SALESQUANTITY * SALESPRICE) - MDP_DISCOUNTUSD) AS FT_NETSALESUSD
     , SUM(MDP_SALESQUANTITY*PRODUCTION_COST) AS FT_COGMUSD
     , COUNT(*) AS FT_NOOFSALESORDERS
     , SUM(EXCHANGERATE * MDP_SALESQUANTITY * SALESPRICE) AS FT_REVENUEEUR
FROM DB_SCH.WI2_ERP10V2_MDORDERPOSITION JOIN DB_SCH.WI2_ERP10V2_MDORDERHEAD
                                             ON MDP_ORDERID = MDH_ORDERNO
                                        JOIN WSA994_PRODUCT
                                             ON PRODUCT_ID = MDP_PRODUCTID
                                        JOIN WI2_WSA994_EXCHANGERATES
                                             ON ratedate = MDH_ORDERDATE
GROUP BY MDP_PRODUCTID, MDH_ORDERDATE, MDH_CUSTOMERNO;

--Berechtigung DB_SCH
GRANT SELECT ON WSA994_PRODUCT TO DB_SCH;
GRANT SELECT ON WSA994_CUSTOMER TO DB_SCH;
GRANT SELECT ON WSA994_FACTTABLE TO DB_SCH;
GRANT SELECT ON WI2_WSA994_EXCHANGERATES TO DB_SCH;

GRANT SELECT ON AGG_WI2_WSA994_FACTCONSTELLATIONTABLE TO DB_SCH;