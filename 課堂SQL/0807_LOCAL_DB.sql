-- SELECT(選出、抓取)欄位
-- FROM(指定來源)資料表
SELECT STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION;

-- *星號代表全部欄位
SELECT * FROM STORE_INFORMATION;

-- 理解(優先記得功能效果)，而非死背SQL語法
-- 資料"去除重覆"
SELECT DISTINCT STORE_NAME FROM STORE_INFORMATION;

-- 總共有六筆資料
-- DISTINCT只能放在SQL欄位"最前面"，"只能下一次"
SELECT DISTINCT STORE_ID, STORE_NAME FROM STORE_INFORMATION;

-- 'WHERE'有選擇性(條件性)地抓資料
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES > 1500;

SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES >= 1500;

-- AND (和、而且) 資料'愈少'，"嚴謹"
-- OR (或、或者)  資料'愈多',"寬鬆"

-- Sales 高於 $1,000 "或是" Sales 在 $275 "以及" $500 之間
-- 2,4,5,6
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES > 1000  
OR SALES > 275 AND SALES < 500;

-- 查詢字串欄位的資料時，須加'單引號'
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE STORE_NAME = 'Los Angeles';


SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE STORE_ID = 1 OR STORE_ID = 3 OR STORE_ID = 5;

-- IN 參數值數量限制為1,000筆 (建議50個以內)
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE STORE_ID IN (1,3,5);

-- BETWEEN 運用一個範圍 (range) 內 抓出資料庫中的值
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES >= 300 AND SALES <= 1500;

-- BETWEEN...AND 是"包含"
SELECT STORE_ID, STORE_NAME, SALES 
FROM STORE_INFORMATION
WHERE SALES BETWEEN 300 AND 1500;


SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
WHERE STORE_DATE BETWEEN '2018-02-01' AND '2018-04-30';

-- LIKE (像)
-- 查詢商品名稱是字母'B'開頭的商店
-- 精準、"模糊"
SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'B%';

SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%s';

SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE '%o%';

SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'L%s';

SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
WHERE STORE_NAME LIKE 'L_s';

-- 想找STORE_NAME中有 'y' 或有 't' 的請問如何寫，因為預計要能找到 'Boston' 和 'Albany, Crossgates' 二個
SELECT STORE_ID, STORE_NAME, SALES
FROM store_information
WHERE STORE_NAME LIKE '%y%'
OR STORE_NAME LIKE '%t%';

-- 多行註解：Ctrl + / 
-- 2:West(西區)
SELECT *
FROM STORE_INFORMATION
-- 1.「且」找出屬於西區的商店
WHERE GEOGRAPHY_ID = 2
-- 2.「且」營業額大於300(包含300)
AND SALES >= 300
-- 3.「且」商店名稱 "L" 開頭
AND STORE_NAME LIKE 'L%'
-- 4.「或」營業日介於2018年3月至4月
OR STORE_DATE BETWEEN '2018-03-01' AND '2018-04-30';

-- 按照"營業額排序"
-- 由小到大 (ascending)
-- 由大到小 (descending) 
SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
ORDER BY SALES ASC;

SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
ORDER BY SALES DESC;

-- 預設:由小到大 (ascending)
SELECT STORE_ID, STORE_NAME, SALES
FROM STORE_INFORMATION
ORDER BY SALES;


-- 主排序欄位:SALES(營業額) desc
-- 次排序欄位:STORE_DATE(營業日) desc
SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
ORDER BY SALES DESC, STORE_DATE DESC;

SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE
FROM STORE_INFORMATION
ORDER BY 3 DESC;

-- Aggregate Functions 聚合函數
-- AVG (平均)  /  ･COUNT (計數)
-- MAX (最大值)  /  ･MIN (最小值)  /  ･SUM (總合)
SELECT SUM(SALES), AVG(SALES), COUNT(STORE_ID),
	MAX(SALES), MIN(SALES)
FROM STORE_INFORMATION;

-- NULL空值"什麼都沒有"
-- IS NULL:找出"空值"的資料
SELECT * FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NULL;

-- IS NOT NULL:找出"非空值"的資料
SELECT * FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NOT NULL;

-- IS NOT NULL常與 COUNT函數做搭配，已計算非空值的資料筆數
SELECT COUNT(STORE_ID)
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NOT NULL;

SELECT COUNT(STORE_ID)
FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IS NULL;

-- "非重複"的「商店名稱」的"資料筆數"
SELECT COUNT(DISTINCT STORE_NAME)
FROM STORE_INFORMATION;

-- SQL:Structured Query Language 
-- "結構化"查詢語言
-- insert:資料新增、update:資料更新、delete:資料刪除
SELECT * FROM STORE_INFORMATION;



