/*
欄位資料型態
1.CHAR 字元
固定長度字串資料型別
(資料長度不足補空白)
PS:因為長度固定所以對資料庫而言查詢效能較好
ORA-12899: value too large for column "LOCAL"."TABLE1"."COLUMN1" (actual: 12, maximum: 9)
一個中文字佔 3 byte、一個英文字佔 1 byte

2.VARCHAR 字元
可變長度字串資料型別

3.數值
NUMBER( P, S )
P：表示數字總共的位數
S：表示小數的位數

NUMBER( 5, 2)
表示數值共5位數(包含固定最多2位小數、故整數位最多只能為3碼數字)
小數點第3位自動進位至第2位
123.455 → 123.46

NUMBER( 5, -2)
表示數值共5位「整數」-2表示數值自動進位至百位數
12355 → 12400

-- Oracle
CREATE TABLE TABLE1 
(
  COLUMN1 CHAR(9 BYTE),
  COLUMN2 VARCHAR2(9 BYTE),
  COLUMN_NO1 NUMBER(5, 2),
  COLUMN_NO2 NUMBER(5, -2)
);

-- MS SQL、My SQL
CREATE TABLE TABLE1 
(
  COLUMN1 CHAR(9),
  COLUMN2 VARCHAR(9),
  COLUMN_NO1 NUMERIC(5, 2)
);
*/
CREATE TABLE TABLE1 
(
  COLUMN1 CHAR(9),
  COLUMN2 VARCHAR(9),
  COLUMN_NO1 NUMERIC(5, 2)
);

INSERT INTO local_db.table1 (COLUMN1, COLUMN2, COLUMN_NO1) VALUES('ABCD', 'ABCD', 123.455);
INSERT INTO local_db.table1 (COLUMN1, COLUMN2, COLUMN_NO1) VALUES('一二三四', '一二三四', 123.455);

SELECT COLUMN1, LENGTH(COLUMN1), COLUMN2, LENGTH(COLUMN2), COLUMN_NO1
FROM local_db.table1;






