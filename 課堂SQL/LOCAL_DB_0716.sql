-- SELECT(選取、抓取)、FROM(來源表格)
SELECT STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_NAME, STORE_ID, SALES FROM STORE_INFORMATION;

SELECT DISTINCT STORE_NAME FROM STORE_INFORMATION;

-- DISTINCT 只能一次
-- DISTINCT 只能放在欄位的最前面
-- DISTINCT 依多個資料欄一整列判斷是否資料重覆
SELECT DISTINCT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_NAME, STORE_ID, SALES 
FROM STORE_INFORMATION 
WHERE SALES >= 1500;

-- <>、!= 不等於
SELECT STORE_NAME, STORE_ID, SALES 
FROM STORE_INFORMATION
WHERE SALES != 1500;

-- AND且(嚴謹)、OR或(寬鬆)
-- 高於 $1,000 或是 Sales 在 $275 及 $500 之間
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES > 1000
OR SALES > 275 AND SALES < 500;


SELECT * FROM STORE_INFORMATION
WHERE STORE_ID = 2
OR STORE_ID = 3
OR STORE_ID = 4;


SELECT * FROM STORE_INFORMATION
WHERE STORE_ID IN (2,3,4);


SELECT * FROM STORE_INFORMATION
WHERE STORE_NAME IN ('Boston', 'Los Angeles');

SELECT * 
FROM STORE_INFORMATION
WHERE SALES >= 250 AND SALES <= 700;

SELECT * 
FROM STORE_INFORMATION
WHERE SALES BETWEEN 250 AND 700;

SELECT * 
FROM STORE_INFORMATION
WHERE STORE_DATE BETWEEN '2018-03-01 00:00:00' AND '2018-05-31';

SELECT * 
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'B%';

SELECT * 
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'L%s';

-- 1.「且」找出屬於西區的商店
-- 2.「且」營業額大於300(包含300)
-- 3.「且」商店名稱"L"開頭
-- 4.「或」營業日介於2018年3月至4月
SELECT * FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID = 2
AND SALES >= 300
AND STORE_NAME LIKE 'L%'
OR STORE_DATE BETWEEN '2018-03-01' AND '2018-04-30';

-- 小往大 (ascending) 預設值
-- 由大往小(descending)
SELECT * 
FROM STORE_INFORMATION
ORDER BY SALES ASC;

SELECT * 
FROM STORE_INFORMATION
ORDER BY SALES DESC, STORE_DATE DESC;

-- ･AVG (平均)  /  ･COUNT (計數)
-- ･MAX (最大值)  /  ･MIN (最小值)  /  ･SUM (總合)
SELECT SUM(SALES), AVG(SALES), COUNT(STORE_ID),
	MAX(STORE_DATE), MIN(STORE_DATE)
FROM STORE_INFORMATION;


SELECT COUNT(STORE_ID)
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NULL;

SELECT COUNT(STORE_ID)
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NOT NULL;

-- 多少筆不同的資料 
SELECT COUNT(DISTINCT STORE_NAME)
FROM STORE_INFORMATION;

-- 各別商店的加總營業額
-- GROUP BY:資料分群、合併(搭用使用函數)
-- 非GROUP BY的其它欄位都須套入函數
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID), AVG(SALES),
	MIN(SALES), MAX(SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY STORE_NAME;


SELECT STORE_NAME, SALES
FROM STORE_INFORMATION
GROUP BY STORE_NAME, SALES
ORDER BY STORE_NAME;

-- MySQL (群組清單語法)
-- 查詢資料為群組前的資料清單
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID),
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/')
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY STORE_NAME;


-- Oracle (群組清單語法)
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID),
	 LISTAGG(SALES, '/') WITHIN GROUP (ORDER BY SALES DESC)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY STORE_NAME;


-- MS SQL Server (群組清單語法)
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID),
	STRING_AGG(SALES, '/')
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY STORE_NAME;

-- HAVING:函數產生的值來設定條件查尋
-- 各別商店加總營業額大於3000
SELECT STORE_NAME, SUM(SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING SUM(SALES) > 3000;


-- 計算和統計「個別商店」的以下三項資料：
-- 「總合營業額」、「商店資料個數」、「平均營業額」
-- 搜尋或排除條件如下：
-- 排除「平均營業額」1000(含)以下的商店資料
-- 排除「商店資料個數」1(含)個以下的商店資料
-- 依照「平均營業額」由大至小排序
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID), AVG(SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000
AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;


