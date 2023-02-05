SELECT STORE_NAME FROM store_information;

SELECT STORE_ID, STORE_NAME FROM store_information;

SELECT STORE_ID, SALES, STORE_NAME FROM store_information;

SELECT * FROM store_information;

--  MySQL允許以下查詢(不建議)
SELECT *, STORE_NAME FROM store_information;

-- 商店名稱去重覆
SELECT DISTINCT STORE_NAME FROM STORE_INFORMATION;

-- 1.DISTINCT 位置必須下在欄位的最前面
-- 2.DISTINCT 只能下一次
-- 3.DISTINCT 是以整列資料為去重覆依據
SELECT DISTINCT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

-- 有條件的查詢資料
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION 
WHERE SALES > 1000;


SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION 
WHERE SALES >= 1500;

-- AND且(嚴謹)同時成立
-- OR或(寬鬆)單邊成立
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION 
WHERE SALES > 250 
AND STORE_DATE > '2018-04-01';


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE SALES < 300
OR SALES > 2800;


-- 同一個欄位但不同的值做查詢
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_ID = 1
OR STORE_ID = 2
OR STORE_ID = 3;


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_ID IN(1,2,3,5);

-- 字串型別的值須用'單引號'
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME = 'Boston';


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME IN ('Boston', 'Los Angeles');


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE SALES >= 300 AND SALES <= 2500;

-- BETWEEN AND
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE SALES BETWEEN 300 AND 2500;


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_DATE BETWEEN '2018-02-01' AND '2018-05-30';

-- MySQL 字串轉日期 (STR_TO_DATE)
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_DATE BETWEEN STR_TO_DATE('2018/02/01', '%Y/%m/%d') AND STR_TO_DATE('2018/05/30', '%Y/%m/%d');


-- MySQL 日期轉字串(date_format)
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE, date_format(STORE_DATE, '%Y/%m')
FROM STORE_INFORMATION
WHERE date_format(STORE_DATE, '%Y/%m')
BETWEEN '2018/02' AND '2018/05';


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'B%';


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%s';

SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%os%';


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'L%s';

-- • 1.「且」找出屬於西區的商店
-- • 2.「且」營業額大於300(包含300)
-- • 3.「且」商店名稱“L”開頭
-- • 4.「或」營業日介於2018年3月至4月
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID = 2;








