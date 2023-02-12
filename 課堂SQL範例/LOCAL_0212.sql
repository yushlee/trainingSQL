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

