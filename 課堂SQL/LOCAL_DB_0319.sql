-- 9筆
SELECT * FROM store_information;

-- 3筆
SELECT * FROM geography;

-- 27筆
SELECT S.*, G.*
FROM store_information S, geography G
WHERE S.geography_id = G.GEOGRAPHY_ID;

-- INNER JOIN...ON(內部連接)
SELECT S.*, G.*
FROM store_information S 
INNER JOIN geography G ON S.geography_id = G.GEOGRAPHY_ID
WHERE S.sales > 2000;


SELECT G.*,S.*
FROM geography G INNER JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- INNER 可省略
SELECT G.*,S.*
FROM geography G JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- OUTER JOIN ON (外部連結)
-- OUTER可省略
SELECT G.*,S.*
FROM geography G LEFT OUTER JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

SELECT G.*,S.*
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;


SELECT G.*,S.*
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;


SELECT G.*,S.*
FROM geography G RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- MySQL不支援 FULL JOIN
SELECT G.*,S.*
FROM geography G FULL JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- 由不同欄位獲得的資料串連在一起 
SELECT CONCAT(STORE_ID, '-', STORE_NAME, ' $',SALES) FROM store_information;


-- Oracle CONCAT只允許兩個參數
SELECT CONCAT(STORE_ID,STORE_NAME) FROM store_information;
-- Oracle || 符號字串相連
SELECT STORE_ID || '-' || STORE_NAME FROM store_information;


-- MS SQL + 
SELECT G.REGION_NAME + '-' + S.STORE_NAME, S.STORE_DATE 
FROM GEOGRAPHY G JOIN STORE_INFORMATION S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- substring 子字串
-- SUBSTR(str,pos): 由<str>中，選出所有從第<pos>位置
-- 開始的字元。請注意，這個語法不適用於SQL Server上
-- SUBSTR(str,pos,len): 由<str>中的第<pos>位置開始，選出
-- 接下去的<len>個字元。
SELECT STORE_NAME, SUBSTR(STORE_NAME, 3), SUBSTR(STORE_NAME, 3, 6)
FROM store_information;


SELECT SUBSTR('ABCDEFGHIJK', 3, 2);


-- TRIM([[位置] [要移除的字串] FROM ] 字串)
-- [位置] 的可能值為 LEADING (起頭), TRAILING (結尾), or BOTH (起頭及結尾)
SELECT STORE_ID, STORE_NAME,
    TRIM(LEADING 'Bos' FROM STORE_NAME),
    TRIM(TRAILING 's' FROM STORE_NAME),
    TRIM(BOTH 'L' FROM STORE_NAME)
FROM STORE_INFORMATION;


-- 查詢各區域的營業額總計
-- 資料結果依營業額總計由大到小排序
-- (不論該區域底下是否有所屬商店)
SELECT G.REGION_NAME, IFNULL(SUM(S.sales), 0) "SUM_SALES"
FROM geography G LEFT JOIN store_information S
ON G.GEOGRAPHY_ID = S.geography_id
GROUP BY G.REGION_NAME
ORDER BY SUM_SALES DESC;

-- Oracle NVL 判斷NULL
SELECT NVL(NULL, 0) FROM DUAL;

-- MS SQL NVL 判斷NULL
SELECT ISNULL(NULL, 0);

-- 查詢各區域的商店個數
-- 資料結果依區域的商店個數由大至小排序
-- (依據商店名稱,不包含重覆的商店)
-- (不論該區域底下是否有所屬商店)

















