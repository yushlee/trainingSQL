-- 針對群組函式處理後的欄位做條件查詢
SELECT STORE_NAME, SUM(SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING SUM(SALES) >= 3000;

-- SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY
SELECT STORE_NAME, SUM(SALES)
FROM STORE_INFORMATION
WHERE SALES >= 0
GROUP BY STORE_NAME
HAVING SUM(SALES) >= 3000
ORDER BY SUM(SALES);

-- 欄位別名: alias(別名)
-- 1.AS "雙引號"
-- 2.AS可省略不寫
-- 3."雙引號"可省略不寫(別名不可以有空白)
SELECT STORE_NAME,
	SUM(SALES) SUM_SALES,
    COUNT(STORE_ID) "STORE COUNT", 
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "營業額群組清單"
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY SUM_SALES;


-- 表格別名
-- 不須雙引號
-- 表格別名.欄位名稱
SELECT S.STORE_ID, S.STORE_NAME, S.STORE_DATE
FROM STORE_INFORMATION S;

/*
SQL 練習題(二)
計算和統計「個別商店」的以下三項資料：
「總合營業額」、「商店資料個數」、「平均營業額」
搜尋或排除條件如下：
排除「平均營業額」1000(含)以下的商店資料
排除「商店資料個數」1(含)個以下的商店資料
依照「平均營業額」由大至小排序
PS:使用別名語法簡化「表格名稱」及查詢結果「欄位名稱」
*/
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID), AVG(SALES) "AVG_SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000 AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;

SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID
FROM STORE_INFORMATION;

SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY;

-- 區域:3筆
-- 商店:9筆
-- CROSS JOIN
SELECT S.*, G.*
FROM STORE_INFORMATION S, GEOGRAPHY G;

-- join 利用where字句
SELECT S.*, G.*
FROM STORE_INFORMATION S, GEOGRAPHY G
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID;

-- INNER JOIN ... ON 內部連結(交集)
-- GEOGRAPHY:區域、STORE_INFORMATION:商店
-- INNER可省略不寫
-- 一個區域對應多筆商店
SELECT G.*, S.* 
FROM GEOGRAPHY G INNER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 左外部連接(LEFT JOIN or LEFT OUTER JOIN)
SELECT G.*, S.* 
FROM GEOGRAPHY G LEFT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- 右外部連接 (RIGHT JOIN or RIGHT OUTER JOIN)
SELECT G.*, S.*
FROM GEOGRAPHY G RIGHT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 全外部連接 (FULL JOIN or FULL OUTER JOIN)
-- FULL JOIN = LEFT JOIN + RIGHT JOIN
-- MySQL不支援FULL JOIN
/*
SELECT G.*, S.* 
FROM GEOGRAPHY G FULL JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;
*/

/*
SQL 練習題(3-1)
查詢各區域的營業額總計
資料結果依營業額總計由大到小排序
(不論該區域底下是否有所屬商店)
*/
-- MySQL:IFNULL
-- Oracle:NVL
-- MS SQL:ISNULL
SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) AS "SUM_SALES"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY SUM_SALES DESC;

/*
SQL 練習題(3-1)
查詢各區域的商店個數
資料結果依區域的商店個數由大至小排序
(依據商店名稱,不包含重覆的商店)
(不論該區域底下是否有所屬商店)
*/



