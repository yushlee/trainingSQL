-- MySQL
-- 群組資料清單函數(查尋未群組合併前的資料清單)
-- 欄位別名
-- 1. AS可省略不寫
-- 2. 別名使用雙引號""包起來
-- 3. 雙引號可省略(但別名中間不可以有空白)
SELECT STORE_NAME, SUM(SALES) 總合營業額, COUNT(STORE_ID) "商店個數",
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "LIST SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME;

-- 表格別名
SELECT STORE.STORE_ID, STORE.STORE_NAME
FROM STORE_INFORMATION STORE;

SELECT * FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID;

SELECT * FROM GEOGRAPHY;

SELECT S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID, G.REGION_NAME
FROM STORE_INFORMATION S, GEOGRAPHY G
-- 跨資料表JOIN關聯(連接)查詢
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
ORDER BY GEOGRAPHY_ID;

-- 商店:9筆、區域:3筆 
-- 27筆
-- INNER JOIN:內部連接 
SELECT G.*, S.*
FROM GEOGRAPHY G INNER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

--  LEFT OUTER JOIN:左外部連接
SELECT G.*, S.*
FROM GEOGRAPHY G LEFT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- RIGHT OUTER JOIN:右外部連接
SELECT G.*, S.*
FROM GEOGRAPHY G RIGHT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- MySQL 不支援 FULL JOIN
-- FULL JOIN = LEFT JOIN + RIGHT JOIN
SELECT G.*, S.*
FROM GEOGRAPHY G FULL JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 交叉連接(cross join)
SELECT G.*, S.*
FROM GEOGRAPHY G JOIN STORE_INFORMATION S;


-- 查詢各區域的營業額總計
-- 資料結果依營業額總計由大到小排序
-- (不論該區域底下是否有所屬商店)
SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) "SUM_SALES"
FROM GEOGRAPHY G LEFT OUTER JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY SUM_SALES DESC;


-- 查詢各區域的商店個數
-- 資料結果依區域的商店個數由大至小排序
-- (依據商店名稱,不包含重覆的商店)
-- (不論該區域底下是否有所屬商店)
SELECT G.REGION_NAME, COUNT(DISTINCT S.STORE_NAME) "COUNT_STORE"
FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY COUNT_STORE DESC;

-- 由不同欄位獲得的資料串連在一起
SELECT CONCAT(STORE_ID, '_', STORE_NAME, '_', SALES) "STORE_INFO"
FROM STORE_INFORMATION;


-- substring函數是用來抓出一個欄位資料中的其中一部分
SELECT STORE_NAME, SUBSTR(STORE_NAME, 2), SUBSTR(STORE_NAME, 2, 4)
FROM STORE_INFORMATION;


SELECT STORE_NAME, TRIM(STORE_NAME), LTRIM(STORE_NAME), RTRIM(STORE_NAME)
FROM STORE_INFORMATION;


-- TRIM([[位置] [要移除的字串] FROM ] 字串)
-- [位置] 的可能值為 LEADING (起頭), TRAILING (結尾), or BOTH (起頭及結尾)
SELECT STORE_ID, STORE_NAME,
    TRIM(LEADING 'Bos' FROM STORE_NAME),
    TRIM(TRAILING 's' FROM STORE_NAME),
    TRIM(BOTH 'L' FROM STORE_NAME)
FROM STORE_INFORMATION;

SELECT STORE_ID, STORE_NAME,
    TRIM(LEADING 'Bos' FROM STORE_NAME),
    REPLACE(STORE_NAME, 'Bos', '')
FROM STORE_INFORMATION;

SELECT * FROM STORE_INFORMATION;

-- 資料操作語言 DML (Data Manipulation Language)
-- 1.INSERT 新增資料到資料表中
INSERT INTO STORE_INFORMATION(STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID) VALUES(10, 'Apple Inc', 6600, '2018-07-09', 3);
INSERT INTO STORE_INFORMATION VALUES(11, 'Apple Inc', 6600, '2018-07-09', 3);

-- 2.UPDATE 更改資料表中的資料
UPDATE STORE_INFORMATION 
SET STORE_NAME = 'Apple Inc new',
	SALES = 7700
WHERE STORE_ID = 10;

-- 3.DELETE 刪除資料表中的資料
DELETE FROM STORE_INFORMATION  WHERE STORE_ID = 11;

SELECT * FROM geography;

SELECT * FROM STORE_INFORMATION;

DELETE FROM geography WHERE GEOGRAPHY_ID = 3;

DELETE FROM STORE_INFORMATION WHERE STORE_ID = 10;


INSERT INTO STORE_INFORMATION(STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID) VALUES(10, 'Apple Inc', 6600, '2018-07-09', 4);


-- 多對多關係 = 雙向一對多
SELECT * FROM student;

SELECT * FROM class;

SELECT * FROM classstudent_relation;