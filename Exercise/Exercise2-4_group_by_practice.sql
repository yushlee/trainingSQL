-- Exercise 2
# 計算和統計「個别商店」的以下三項資料：
#「總合營業額」、「商店資料個數」、「平均營業額」
# 搜尋或排除條件如下：
# 1.排除「平均營業額」1000（含)以下的商店資料
# 2.排除「商店資料個數」1(含)個以下的商店資料
# 3.依照「平均營業額」由大至小排序
select STORE_NAME, sum(SALES), 
		COUNT(STORE_ID), round(avg(SALES))
from STORE_INFORMATION
group by STORE_NAME
having avg(SALES) > 1000 and COUNT(STORE_ID) > 1
order by avg(SALES) DESC;

-- Exercise 3
-- 查詢各區域的營業額總計 資料結果依營業額總計由大到小排序 (不論該區域底下是否有所屬商店)
select g.region_name, ifnull(sum(sales),0)
from geography as g left outer join store_information as s
on g.geography_id = s.geography_id
group by region_name;

-- Exercise 4
-- 查詢各區域的商店個數 資料結果依區域的商店個數由大至小排序
-- (依據商店名稱,不包含重覆的商店) 
-- (不論該區域底下是否有所屬商店)
select g.region_name, count(distinct s.store_name)
from geography g left outer join STORE_INFORMATION s
on g.GEOGRAPHY_ID = s.GEOGRAPHY_ID
group by g.region_name
order by count(s.store_name) DESC;


/*
DROP TABLE STORE_INFORMATION;
DROP TABLE GEOGRAPHY;


CREATE TABLE GEOGRAPHY (  
	GEOGRAPHY_ID NUMERIC (10,0) PRIMARY KEY,
	REGION_NAME  VARCHAR(255)
);

CREATE TABLE STORE_INFORMATION(
	STORE_ID   NUMERIC (10,0) PRIMARY KEY,
	STORE_NAME VARCHAR(255),
	SALES      NUMERIC (10,0) CHECK (SALES > 0),
	STORE_DATE datetime,
	-- GEOGRAPHY_ID NUMBER(10,0) REFERENCES GEOGRAPHY(GEOGRAPHY_ID)
	GEOGRAPHY_ID NUMERIC (10,0),
	CONSTRAINT CONSTRAINT_GEOGRAPHY_ID FOREIGN KEY (GEOGRAPHY_ID) REFERENCES GEOGRAPHY (GEOGRAPHY_ID)
);

DELETE FROM STORE_INFORMATION;
DELETE FROM GEOGRAPHY;
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (1,'East');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (2,'West');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (3,'North');
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (1,'Boston',2200,TO_TIMESTAMP('2018-03-09 00:00:00','YYYY-MM-DD HH24:MI:SS'),1);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (2,'Los Angeles',1400,TO_TIMESTAMP('2018-04-05 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (3,'San Diego',250,TO_TIMESTAMP('2018-01-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (4,'Los Angeles',300,TO_TIMESTAMP('2018-02-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (5,'Albany, Crossgates',2500,TO_TIMESTAMP('2018-05-15 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (6,'Buffalo, Walden Galleria',3000,TO_TIMESTAMP('2018-06-10 00:00:00','YYYY-MM-DD HH24:MI:SS'),NULL);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (7,'San Diego',500,TO_TIMESTAMP('2018-02-15 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (8,'Los Angeles',1600,TO_TIMESTAMP('2018-02-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (9,'Boston',1500,TO_TIMESTAMP('2018-03-09 00:00:00','YYYY-MM-DD HH24:MI:SS'),1);
COMMIT;

DELETE FROM STORE_INFORMATION;
DELETE FROM GEOGRAPHY;
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (1,'East');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (2,'West');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (3,'North');
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (1,'Boston',700,TO_TIMESTAMP('2018-03-09 00:00:00','YYYY-MM-DD HH24:MI:SS'),1);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (2,'Los Angeles',1500,TO_TIMESTAMP('2018-04-05 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (3,'San Diego',250,TO_TIMESTAMP('2018-01-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (4,'Los Angeles',300,TO_TIMESTAMP('2018-02-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (5,'Albany, Crossgates',2500,TO_TIMESTAMP('2018-05-15 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (6,'Buffalo, Walden Galleria',3000,TO_TIMESTAMP('2018-06-10 00:00:00','YYYY-MM-DD HH24:MI:SS'),NULL);
COMMIT;
*/