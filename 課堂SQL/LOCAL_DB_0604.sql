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
計算和統計「個別商店」的以下三項資料：
「總合營業額」、「商店資料個數」、「平均營業額」
搜尋或排除條件如下：
排除「平均營業額」1000(含)以下的商店資料
排除「商店資料個數」1(含)個以下的商店資料
依照「平均營業額」由大至小排序
PS:使用別名語法簡化「表格名稱」及查詢結果「欄位名稱」
*/



