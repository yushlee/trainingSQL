SELECT STORE_NAME,SALES,STORE_ID FROM store_information;

SELECT * FROM store_information;

SELECT DISTINCT STORE_NAME FROM store_information;

-- 1.DISTINCT去重覆是以整列資料為去重覆的依據
-- 2.DISTINCT只能寫一次並且必須在欄位最前面
SELECT  DISTINCT STORE_ID, STORE_NAME FROM store_information;

SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information 
WHERE SALES >= 1500;

-- AND且:條件"嚴僅"
SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information 
WHERE SALES >= 300 AND SALES <= 2500;

-- OR或:條件"寬鬆"
SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_ID = 1 OR STORE_ID = 3;


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE SALES > 1000 
OR (SALES >= 275 AND SALES <= 500);


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_ID = 1 OR STORE_ID = 3 OR STORE_ID = 4 OR STORE_ID = 5;


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_ID IN (1,3,4,5);

-- 文字類型欄位參數值須使用'單引號'
SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE store_name IN ('Los Angeles', 'San Diego');

-- 300 ~ 1500
SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE SALES BETWEEN 300 AND 1500;

SELECT STORE_ID,STORE_NAME,SALES,STORE_DATE 
FROM store_information
WHERE STORE_DATE BETWEEN '2018-03-01 00:00:00' AND '2018-05-31 23:59:59';


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_NAME LIKE 'B%';

SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_NAME LIKE '%s';


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_NAME LIKE '%an%';


SELECT STORE_ID,STORE_NAME,SALES 
FROM store_information
WHERE STORE_NAME LIKE 'L%s';


SELECT * FROM store_information
-- 1.「且」找出屬於西區的商店
WHERE geography_id = 2
-- 2.「且」營業額大於300(包含300)
AND sales >= 300
-- 3.「且」商店名稱“L”開頭
AND store_name LIKE 'L%'
-- 4.「或」營業日介於2018年3月至4月
OR store_date BETWEEN '2018-03-01' AND '2018-04-30';

-- ASC由小到大(預設)
-- DESC由大到小
SELECT * 
FROM store_information
ORDER BY SALES DESC, store_date DESC;

SELECT * FROM store_information
ORDER BY STORE_NAME DESC;

-- ORDER BY 可指定欄位的順序號碼做排序
SELECT STORE_ID ,store_name, sales
FROM store_information
ORDER BY 3 DESC;

SELECT SUM(SALES), AVG(SALES), COUNT(STORE_ID), MIN(SALES), MAX(SALES)
FROM store_information;

-- IS NULL:找出空值的資料
SELECT COUNT(STORE_ID) FROM store_information
WHERE geography_id IS NULL;

-- IS NOT NULL:找出非空值的資料
SELECT COUNT(STORE_ID) FROM store_information
WHERE geography_id IS NOT NULL;

-- 計算去重覆的商店名稱的資料個數
SELECT COUNT(DISTINCT STORE_NAME)
FROM store_information;


SELECT store_name, SUM(SALES), COUNT(STORE_ID), AVG(SALES),
	MIN(SALES), MAX(SALES)
FROM store_information
GROUP BY store_name;

-- MySQL
-- GROUP_CONCAT "資料群組清單化"未合併前的資料
SELECT store_name, SUM(SALES), COUNT(STORE_ID),
	   GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/')
FROM store_information
GROUP BY store_name;

-- Oracle "資料群組清單化"
SELECT store_name, SUM(SALES), COUNT(STORE_ID),
	LISTAGG(SALES, '/') within group (order by SALES desc)
FROM store_information
GROUP BY store_name;


--  MS SQL Server
SELECT STORE_NAME, 
    STRING_AGG(SALES, '/')
FROM STORE_INFORMATION
GROUP BY STORE_NAME;


SELECT store_name, SUM(SALES), COUNT(STORE_ID)
FROM store_information
GROUP BY store_name
HAVING SUM(SALES) > 3000;

-- alias 欄位別名
-- 1. AS 可省略
-- 2. 欄位別名雙引號可省略(但不可有空白)
SELECT store_name, SUM(SALES), COUNT(STORE_ID) "COUNT STORE",
	   GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "SALES LIST"
FROM store_information;

-- -- alias 表格別名(不須加雙引號)
SELECT store.store_name
FROM store_information store;


SELECT S.store_name
FROM store_information S;

SELECT store_name, SUM(SALES) "SUM_SALES", COUNT(STORE_ID)
FROM store_information
GROUP BY store_name
ORDER BY SUM_SALES;


-- 計算和統計「個別商店」的以下三項資料：
-- 「總合營業額」、「商店資料個數」、「平均營業額」

-- 搜尋或排除條件如下：
-- 排除「平均營業額」1000(含)以下的商店資料
-- 排除「商店資料個數」1(含)個以下的商店資料
-- 依照「平均營業額」由大至小排序
-- PS:使用別名語法簡化「表格名稱」及查詢結果「欄位名稱」

