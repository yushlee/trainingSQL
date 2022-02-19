
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












