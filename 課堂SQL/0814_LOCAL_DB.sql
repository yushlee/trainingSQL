
-- 針對"加總後"的各別商店營業額做"條件篩選"
-- 對函數產生的值來設定條件查尋
-- SELECT → FROUM → WHERE → GROUP BY → Function → HAVING → ORDER BY
SELECT STORE_NAME, SUM(SALES)
FROM STORE_INFORMATION
WHERE SALES > 0
GROUP BY STORE_NAME
HAVING SUM(SALES) >= 3000
ORDER BY SUM(SALES) DESC;


-- 計算和統計「個別商店」的以下三項資料：
-- 「總合營業額」、「商店資料個數」、「平均營業額」
-- 搜尋或排除條件如下：
-- 排除「平均營業額」1000(含)以下的商店資料
-- 排除「商店資料個數」1(含)個以下的商店資料
-- 依照「平均營業額」由大至小排序
SELECT STORE_NAME, SUM(SALES), COUNT(STORE_ID), AVG(SALES)
FROM STORE_INFORMATION
GROUP BY STORE_NAME
HAVING AVG(SALES) > 1000 AND COUNT(STORE_ID) > 1
ORDER BY AVG(SALES) DESC;






