-- MySQL
-- 群組資料清單
-- 1.可決定群組資料清單的資料排序
-- 2.可決定群組資料清單的分隔符號
SELECT STORE_NAME, SUM(SALES),
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/')
FROM STORE_INFORMATION
GROUP BY STORE_NAME;

-- Oracle
-- 群組資料清單
-- 單行駐解
/* 多行駐解*/
-- 多行駐解快速鍵 Ctrl + /
/*
SELECT STORE_NAME, SUM(SALES),
  LISTAGG(SALES, ',') WITHIN GROUP (ORDER BY SALES ASC)
FROM STORE_INFORMATION
GROUP BY STORE_NAME;
*/

-- Microsoft SQL
-- 群組資料清單
/*
SELECT STORE_NAME, SUM(SALES),
	STRING_AGG(SALES, ',') WITHIN GROUP (ORDER BY SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME;
*/

-- 針對函數後的結果進行條件篩選
-- SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY
SELECT STORE_NAME, SUM(SALES)
FROM STORE_INFORMATION
-- WHERE SALES > 0 AND GEOGRAPHY_ID = 2
GROUP BY STORE_NAME
HAVING SUM(SALES) >= 3000
ORDER BY SUM(SALES) ASC;

/*
計算和統計「個別商店」的以下三項資料：
「總合營業額」、「商店資料個數」、「平均營業額」
搜尋或排除條件如下：
排除「平均營業額」1000(含)以下的商店資料
排除「商店資料個數」1(含)個以下的商店資料
依照「平均營業額」由大至小排序
PS:使用別名語法簡化「表格名稱」及查詢結果「欄位名稱」
*/
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID), FLOOR(AVG(SALES))
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000
AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;

/*
1.CEIL(x)：返回大於或等於x的最大整數值(無條件進位)
2.FLOOR( x)：返回小於或等於x的最小整數值(無條件捨去)
3.ROUND(x ,[y])：
返回(四捨五入)到小數點右邊y位的x值,y預設值為0
如果y是負數，則捨入到小數點左邊相應的整數位上
*/
SELECT CEIL(123.1);
SELECT FLOOR(123.9);
SELECT ROUND(123.345, 2);
SELECT ROUND(123.343, 2);

-- Alias (別名)
-- 欄位別名及表格別名
-- 1.欄位別名須用"雙引號"
-- 2.AS可省略
-- 3.欄位別名"雙引號"可省略(別名不能有空白)
SELECT STORE_NAME "商店名稱", SUM(SALES) 營業額總計, COUNT(STORE_ID) "COUNT STORE",
	FLOOR(AVG(SALES)) AS "AVG_SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000
AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;

-- 欄位別名可使用在欄位條件上
SELECT STORE_NAME "商店名稱", SUM(SALES) 營業額總計, COUNT(STORE_ID) "COUNT_STORE",
	FLOOR(AVG(SALES)) AS "AVG_SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000
AND COUNT_STORE > 1
ORDER BY AVG_SALES DESC;


-- 表格別名
-- 1.不須要加雙引號
-- 2.透過表格別名.欄位名稱
SELECT S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM STORE_INFORMATION S;

SELECT G.GEOGRAPHY_ID, G.REGION_NAME 
FROM GEOGRAPHY G;


SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G, STORE_INFORMATION S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 內部連接 (INNER JOIN)：查詢兩張資料表交集後的結果
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G INNER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

--  INNER 可省略不寫
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G  JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- 左外部連接(LEFT OUTER JOIN):查詢兩張資料表(交集 + 左側資料表所有的資料)
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G LEFT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- OUTER可省略
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- 右外部連接(RIGHT OUTER JOIN):查詢兩張資料表(交集 + 右側資料表所有的資料)
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G RIGHT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- Oracle使用(+)來取代 LEFT、RIGHT JOIN
-- (+)不能取代FULL JOIN
/*
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G, STORE_INFORMATION S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID(+);
*/

-- MySQL不支援FULL JOIN
/*
SELECT G.GEOGRAPHY_ID, G.REGION_NAME,
  S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM GEOGRAPHY G FULL JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;
*/

-- SQL 練習題(三)
-- 查詢各區域的營業額總計
-- 資料結果依營業額總計由大到小排序
-- (不論該區域底下是否有所屬商店)
-- MySQL IFNULL()
SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) "REGION_SUM_SALES"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY REGION_SUM_SALES DESC;

-- Oracle NVL()
SELECT G.REGION_NAME, NVL(SUM(S.SALES), 0) "REGION_SUM_SALES"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY REGION_SUM_SALES DESC;

-- MSSQL ISNULL()
SELECT G.REGION_NAME, ISNULL(SUM(S.SALES), 0) "REGION_SUM_SALES"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY REGION_SUM_SALES DESC;

-- SQL 練習題(三)
-- 查詢各區域的商店個數
-- 資料結果依區域的商店個數由大至小排序
-- (依據商店名稱,不包含重覆的商店)
-- (不論該區域底下是否有所屬商店)
SELECT G.REGION_NAME, COUNT(DISTINCT STORE_NAME) "STORE_COUNT",
	GROUP_CONCAT(STORE_NAME SEPARATOR '/') "LIST_STORE_NAME",
    GROUP_CONCAT(DISTINCT STORE_NAME SEPARATOR '/') "DISTINCT_LIST_STORE_NAME"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY STORE_COUNT DESC;


-- 交叉連接(cross join)
-- 笛卡兒乘積 (Cartesian product)
SELECT G.*, S.*
FROM GEOGRAPHY G, STORE_INFORMATION S;

-- 欄位合併
SELECT STORE_ID, STORE_NAME, SALES,
	CONCAT(STORE_ID, '_', STORE_NAME, '_', SALES) "CONCAT_FIELD"
FROM STORE_INFORMATION;


-- Oracle的CONCAT()只允許兩個參數
-- '||'來一次串連
SELECT STORE_ID, STORE_NAME, SALES,
	CONCAT(STORE_ID, STORE_NAME) "CONCAT_FIELD",
  STORE_ID || '_' || STORE_NAME "CONCAT_FIELD"
FROM STORE_INFORMATION;