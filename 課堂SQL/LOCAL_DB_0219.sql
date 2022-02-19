
-- GROUP_CONCAT 群組欄位資料清單化查詢
SELECT STORE_NAME, SUM(SALES), GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/')
FROM store_information
GROUP BY STORE_NAME;

-- 針對個別商店總和營業額做條件查詢
-- HAVING:對函數產生的值來設定條件查尋
SELECT STORE_NAME, SUM(SALES)
FROM store_information
GROUP BY STORE_NAME
HAVING SUM(SALES) > 2000;

-- 欄位別名
-- 1.別名名稱"雙引號"
-- 2."雙引號"可省略不寫
-- 3.別名名稱若有空白則必須使用"雙引號"
-- 4.AS可省略不寫
SELECT STORE_NAME, SUM(SALES), 
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "SUM SALES_LIST"
FROM store_information
GROUP BY STORE_NAME;


-- 別名可後續搭配 ORDER BY
SELECT STORE_NAME, SUM(SALES) "SUM_SALES"
FROM store_information
GROUP BY STORE_NAME
HAVING SUM(SALES) > 2000
ORDER BY "SUM_SALES" DESC;

-- 表格別名
SELECT STORE.STORE_ID, STORE.STORE_NAME
FROM STORE_INFORMATION STORE;

-- 9
SELECT * FROM store_information;

-- 3
SELECT * FROM geography;

-- 表格與表格之間的"關聯查詢"、"表格連結JOIN"
SELECT G.*, S.* 
FROM geography G, store_information S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- INNER JOIN(內部連結)
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G INNER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- LEFT OUTER JOIN(外部連結左側資料表)
-- 依照區域資料為主(不論是否有從屬商店)
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G LEFT OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- RIGHT OUTER JOIN(外部連結右側資料表)
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G RIGHT OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- MySQL不支援FULL OUTER JOIN
/*
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G FULL OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;
*/

/*
計算和統計「個別商店」的以下三項資料：
「總合營業額」、「商店資料個數」、「平均營業額」
搜尋或排除條件如下：
排除「平均營業額」1000(含)以下的商店資料
排除「商店資料個數」1(含)個以下的商店資料
依照「平均營業額」由大至小排序
PS:使用別名語法簡化「表格名稱」及查詢結果「欄位名稱」
*/
SELECT STORE_NAME, SUM(SALES) "SUM_SALES", 
	COUNT(STORE_ID) "COUNT_STORE", FLOOR(AVG(SALES)) "AVG_SALES"
FROM store_information
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000 AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;

/*
查詢各區域的營業額總計
資料結果依營業額總計由大到小排序
(不論該區域底下是否有所屬商店)
*/
SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) "SUM_SALES"
FROM geography G LEFT JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY SUM(S.SALES) DESC;

/*
查詢各區域的商店個數
資料結果依區域的商店個數由大至小排序
(依據商店名稱,不包含重覆的商店)
(不論該區域底下是否有所屬商店)
*/
SELECT G.REGION_NAME, COUNT(DISTINCT S.STORE_NAME) "COUNT_SOTRE"
FROM geography G LEFT OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY COUNT(DISTINCT  S.STORE_NAME) DESC;


SELECT concat(STORE_ID, '-', STORE_NAME, ' $', SALES) "STORE_INFO"
FROM store_information;

-- 子字串
-- SUBSTR(str,pos,len): 由<str>中的第<pos>位置開始，選出接下去的<len>個字元。
SELECT STORE_NAME, SUBSTR(STORE_NAME, 3), SUBSTR(STORE_NAME, 3, 2)
FROM store_information;


SELECT STORE_NAME, trim(STORE_NAME), LTRIM(STORE_NAME), RTRIM(STORE_NAME)
FROM store_information;


-- TRIM([[位置] [要移除的字串] FROM ] 字串)
-- [位置] 的可能值為 LEADING (起頭), TRAILING (結尾), or BOTH (起頭及結尾)
SELECT STORE_ID, STORE_NAME,
    TRIM(LEADING 'Bos' FROM STORE_NAME),
    TRIM(TRAILING 's' FROM STORE_NAME),
    TRIM(BOTH 'L' FROM STORE_NAME)
FROM STORE_INFORMATION;

-- 主鍵可以包含一或多個欄位。當主鍵包含多個欄位時，稱為組合鍵 (Composite Key)
CREATE TABLE TABLE_A
(
  PK_1 NUMERIC NOT NULL,
  PK_2 NUMERIC NOT NULL,
  CONSTRAINT TABLE_A_PK PRIMARY KEY (PK_1, PK_2)
);


SELECT * FROM store_information;


INSERT INTO store_information (STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID)
VALUE(10, 'Apple Inc', 777, '2022-02-19', 3);

-- DML:資料新增
-- 若VALUE已經是全欄位的資料則欄位名稱可省略不寫
INSERT INTO store_information VALUE(10, 'Apple Inc', 777, '2022-02-19', 3);
INSERT INTO store_information VALUE(10, 'Apple Inc', 777, '2022-02-19', 3);
INSERT INTO store_information VALUE(10, 'Apple Inc', 777, STR_TO_DATE('2022-02-19', "%Y-%m-%d"), 3);

-- MySQL轉換函數：
-- 1.DATE_FORMAT(date,format):日期轉字串
SELECT DATE_FORMAT(SYSDATE(), '%m-%d-%Y %T'),
-- 2.STR_TO_DATE(str,format):字串轉日期
STR_TO_DATE('08-15-2021 00:00:00', "%m-%d-%Y %T");

SELECT * FROM store_information
WHERE STORE_DATE = STR_TO_DATE('2018-03-09', "%Y-%m-%d");

-- DML:資料更新
UPDATE store_information
SET SALES = 888, STORE_NAME = 'APPLE INC'
WHERE STORE_ID = 10;

-- DML:資料刪除
DELETE FROM store_information WHERE STORE_ID = 10;


/*
COMMIT 完成交易作業
如進行資料異動操作後最後須執行交易提交commit的動作資料方可異動成功
交易隔離性：資料庫交易與交易之間彼此獨立，一個交易是看不到另一個交易所異動中的資料
*/
COMMIT;

/*
ROLLBACK 資料回滾(倒回)
可對交易異動中的資料在資料未提交commit前，進行rollback取消這次交易所有的資料異動指令
*/
ROLLBACK;

/*
查詢所有部門資訊如下：
1.所在地(國家、洲省、城市)
2.部門(部門編號、部門名稱)
3.部門管理者(員工編號、員工姓名、員工職稱)
*/

/*
 Step1:找出"資料欄"所屬"資料表"
 LOCATIONS(COUNTRY_ID, STATE_PROVINCE, CITY)
 departments(DEPARTMENT_ID, DEPARTMENT_NAME)
 employees(EMPLOYEE_ID, FIRST_NAME)
 jobs(JOB_TITLE)
 
 Step2:找出"資料表"與"資料表"之間的關聯欄位
 LOCATIONS(LOCATION_ID)DEPARTMENTS
 departments(MANAGER_ID,EMPLOYEE_ID)employees
 employees(JOB_ID)jobs
 
 Setp3:寫SQL
 
*/
SELECT L.*, D.*
FROM DEPARTMENTS D 
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID;












