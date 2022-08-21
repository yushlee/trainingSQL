SELECT STORE_NAME FROM STORE_INFORMATION;

select store_id from STORE_INFORMATION;

SELECT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_NAME, SALES,STORE_ID FROM STORE_INFORMATION;

SELECT * FROM STORE_INFORMATION;

-- DISTINCT(資料去重覆)
SELECT DISTINCT STORE_NAME FROM STORE_INFORMATION;

-- 1.以整列資料為去重覆的依據
-- 2.DISTINCT只能一次
-- 3.DISTINCT只能下在欄位最前面
SELECT DISTINCT STORE_ID, STORE_NAME FROM STORE_INFORMATION;
-- SELECT DISTINCT STORE_ID, DISTINCT STORE_NAME FROM STORE_INFORMATION;


SELECT * FROM STORE_INFORMATION WHERE SALES >= 1500;
SELECT * FROM STORE_INFORMATION WHERE SALES <= 1500;
SELECT * FROM STORE_INFORMATION WHERE SALES = 1500;

SELECT * FROM STORE_INFORMATION WHERE STORE_NAME = 'Los Angeles';

SELECT * FROM STORE_INFORMATION 
WHERE SALES = 1500;

-- AND(且)嚴謹,兩條件全部符合
-- OR(或)寬鬆,兩條件符合其一即可
SELECT * FROM STORE_INFORMATION 
WHERE STORE_ID = 1
OR STORE_ID = 2
OR STORE_ID = 3;

SELECT * FROM STORE_INFORMATION
WHERE STORE_ID > 1
AND SALES > 300
OR GEOGRAPHY_ID = 1;


SELECT * FROM STORE_INFORMATION
WHERE STORE_ID IN (1,2,3);

SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME IN ('Boston', 'Los Angeles', 'San Diego');


SELECT * FROM STORE_INFORMATION
WHERE SALES >= 700 AND SALES <= 2500;

-- BETWEEN...AND
SELECT * FROM STORE_INFORMATION
WHERE SALES BETWEEN 700 AND 2500;

SELECT * FROM STORE_INFORMATION
WHERE STORE_DATE BETWEEN '2018-02-01' AND '2018-05-31';

SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'B%';

SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%s';

SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'L%s';

SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%le%';

SELECT * FROM STORE_INFORMATION
WHERE BINARY STORE_NAME LIKE 'S%';


-- 1.「且」找出屬於西區的商店
-- 2.「且」營業額大於300(包含300)
-- 3.「且」商店名稱“L”開頭
-- 4.「或」營業日介於2018年3月至4月
SELECT * FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID = 2
AND SALES >= 300
AND STORE_NAME LIKE 'L%'
OR STORE_DATE BETWEEN '2018-03-01' AND '2018-04-30';

-- ASC:由小到大(預設)
-- DESC:由大到小
SELECT *
FROM STORE_INFORMATION
ORDER BY SALES ASC;

SELECT *
FROM STORE_INFORMATION
ORDER BY SALES DESC;


SELECT * FROM STORE_INFORMATION 
ORDER BY SALES DESC, STORE_DATE ASC;

-- ORDER BY 可指定的欄位號碼排序(不建議使用)
SELECT STORE_ID, SALES, STORE_NAME
FROM STORE_INFORMATION
ORDER BY 2 ASC;


SELECT SUM(SALES), COUNT(STORE_ID), AVG(SALES),
	MAX(SALES), MIN(SALES)
FROM STORE_INFORMATION;


SELECT COUNT(STORE_ID) 
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NULL;


SELECT COUNT(GEOGRAPHY_ID) 
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NOT NULL;

-- 查詢商店個數(以商店名稱不重覆計算)
SELECT COUNT(DISTINCT STORE_NAME) FROM STORE_INFORMATION;








