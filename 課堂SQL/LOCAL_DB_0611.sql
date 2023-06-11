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
  COLUMN_NO2 NUMBER(5, -2),
  DATE_ONE DATE,
  TIMESTAMP_ONE TIMESTAMP WITH TIME ZONE, -- YYYY-MM-DD HH24:MI:SS.FF3
  TIMESTAMP_TWO TIMESTAMP WITH LOCAL TIME ZONE
);

-- MS SQL、My SQL
CREATE TABLE TABLE1 
(
  COLUMN1 CHAR(9),
  COLUMN2 VARCHAR(9),
  COLUMN_NO1 NUMERIC(5, 2)
);
*/

-- 1.NOT NULL 不允許一個欄位含有 NULL 值
-- 2.UNIQUE 限制是保證一個欄位中的所有資料都是不一樣的值(允許NULL值)
-- 3.CHECK 限制是保證一個欄位中的所有資料都是符合某些條件
-- 4.主鍵 (Primary Key) 中的每一筆資料都是表格中的唯一值。換言之，它是用來獨一無二地確認一個表格中的每一行資料
-- Primary Key = UNIQUE + NOT NULL
-- 當主鍵包含多個欄位時，稱為組合鍵 (Composite Key)
-- 5.外來鍵(Foreign Key)是一個(或數個)指向另外一個表格主鍵的欄位。外來鍵的目的是確定資料的參考完整性(referential integrity)
-- parent key not found(當在新增子項資料的時候會檢查父項資料是否存在)
-- child record found(當在刪除父項資料的時候會去檢查是否有參照的子項資料)

CREATE TABLE TABLE1 
(
  -- COLUMN0 CHAR(9) PRIMARY KEY,
  COLUMN0 CHAR(9),
  COLUMN0_1 CHAR(9),
  -- 組合鍵 (Composite Key)
  CONSTRAINT TABLE1_PK PRIMARY KEY (COLUMN0, COLUMN0_1),
  COLUMN1 CHAR(9) NOT NULL,
  COLUMN2 VARCHAR(9) UNIQUE,
  COLUMN_NO1 NUMERIC(5, 2) CHECK (COLUMN_NO1 > 0),
  DATE_ONE DATE, -- 年月日
  DATETIME_ONE DATETIME, -- 年月日時分秒
  TIMESTAMP_ONE TIMESTAMP(3) -- 年月日時分秒(毫妙)
);

INSERT INTO local_db.table1 (COLUMN0, COLUMN0_1, COLUMN1, COLUMN_NO1, DATE_ONE, DATETIME_ONE, TIMESTAMP_ONE) 
VALUES('A', 'A','ABCD', 10, '2023-06-11', '2023-06-11 12:34:56', '2023-06-11 12:34:56.789');

INSERT INTO local_db.table1 (COLUMN0, COLUMN0_1, COLUMN1, COLUMN_NO1, DATE_ONE, DATETIME_ONE, TIMESTAMP_ONE) 
VALUES('A', 'B','ABCD', 10, '2023-06-11', '2023-06-11 12:34:56', '2023-06-11 12:34:56.789');

INSERT INTO local_db.table1 (COLUMN0, COLUMN0_1, COLUMN1, COLUMN_NO1, DATE_ONE, DATETIME_ONE, TIMESTAMP_ONE) 
VALUES('B', 'A','ABCD', 10, '2023-06-11', '2023-06-11 12:34:56', '2023-06-11 12:34:56.789');

SELECT COLUMN0, COLUMN0_1, COLUMN1, COLUMN2, COLUMN_NO1, DATE_ONE, DATETIME_ONE, TIMESTAMP_ONE
FROM TABLE1;

SELECT COLUMN1, LENGTH(COLUMN1), COLUMN2, LENGTH(COLUMN2), COLUMN_NO1
FROM local_db.table1;


CREATE TABLE GEOGRAPHY (  
	GEOGRAPHY_ID NUMERIC (10,0) PRIMARY KEY,
	REGION_NAME  VARCHAR(255)
);

CREATE TABLE STORE_INFORMATION(
	STORE_ID   NUMERIC (10,0) PRIMARY KEY,
	STORE_NAME VARCHAR(255),
	SALES      NUMERIC (10,0) CHECK (SALES > 0),
	STORE_DATE datetime,
 	GEOGRAPHY_ID NUMERIC (10,0),
 	CONSTRAINT CONSTRAINT_GEOGRAPHY_ID FOREIGN KEY (GEOGRAPHY_ID) REFERENCES GEOGRAPHY (GEOGRAPHY_ID)
);

-- 一對一關係(One to One)
-- A資料表中的單筆資料記錄同時只能對應到B資料表的一筆記錄
-- 例如一個洲只能有一位洲長

-- 政府官員州長
CREATE TABLE Gov(
    GID NUMERIC(3) PRIMARY KEY,
    Name VARCHAR(25),
    Address VARCHAR(30),
    TermBegin date,
    TermEnd date
);

-- 州
-- REFERENCES(參照)、CONSTRAINT(限制)、UNIQUE(唯一)
CREATE TABLE State(
    SID NUMERIC(3) PRIMARY KEY,
    StateName VARCHAR(15),
    Population NUMERIC(10),
    SGID NUMERIC(4),
    -- UNIQUE + Foreign Key = UF
    CONSTRAINT CONSTRAINT_SGID_UNIQUE UNIQUE (SGID),
	CONSTRAINT CONSTRAINT_FK_GOV_GID FOREIGN KEY (SGID) REFERENCES Gov(GID)
);

INSERT INTO Gov (GID, Name, Address, TermBegin, TERMEND) VALUES (110, 'Bob', '123 Any St', '2009-01-01', '2011-12-31');

INSERT INTO State (SID, StateName, Population, SGID) VALUES (111, 'Virginia', 2000000, 110);
-- INSERT INTO State (SID, StateName, Population, SGID) VALUES (112, 'Boston', 3000000, 110);

SELECT * FROM GOV;
SELECT * FROM State;


-- One to Many 一對多關係(單向一對多)
-- A資料表中的單筆資料記錄同時可以對應到B資料表的多筆記錄
-- 例如一間供用商可同時有多個商品，但一個商品只能屬於一間供應商

-- 供應商(父項資料表)
CREATE TABLE Vendor(
    VendorNUMERIC NUMERIC(4) PRIMARY KEY,
    Name VARCHAR(20),
    Address VARCHAR(200),
    City VARCHAR(15),
    Street VARCHAR(200),
    ZipCode VARCHAR(10),
    PhoneNUMERIC VARCHAR(12),
    Status VARCHAR(50)
);

-- 商品清單(子項資料表)
CREATE TABLE Inventory(
    Item VARCHAR(50) PRIMARY KEY,
    Description VARCHAR(300),
    CurrentQuantity NUMERIC(4) NOT NULL,
    VendorNUMERIC NUMERIC(4),
	CONSTRAINT CONSTRAINT_VENDOR_FK FOREIGN KEY (VendorNUMERIC) REFERENCES Vendor(VendorNUMERIC)
);

INSERT INTO Vendor (VENDORNUMERIC, NAME, ADDRESS, CITY, STREET, ZIPCODE, PHONENUMERIC, STATUS) VALUES ('1', 'Apple Inc', '大同區承德路一段1號1樓', '台北市', '承德路', '10351', '02 7743 8068', '營運中');
INSERT INTO Inventory (ITEM, DESCRIPTION, CURRENTQUANTITY, VENDORNUMERIC) VALUES ('iPhone 7 Plus', 'iPhone 7 Plus 5.5吋手機 32GB(原廠包裝盒+原廠配件)', '10', '1');
INSERT INTO Inventory (ITEM, DESCRIPTION, CURRENTQUANTITY, VENDORNUMERIC) VALUES ('iPhone 12 Pro', 'iPhone 12 Pro 6.5吋手機 256GB(原廠包裝盒+原廠配件)', '20', '1');

SELECT * FROM Vendor;
SELECT * FROM Inventory;

SELECT V.*, I.* 
FROM Vendor V JOIN Inventory I
ON V.VENDORNUMERIC = I.VENDORNUMERIC;


-- 多對多關係(Many to Many)(雙向一對多)
-- A資料表中的多筆資料記錄同時可以對應到B資料表的多筆記錄
-- 例如一位學生可以選擇多門課，一門課也可以同時被多位學生選擇

-- 課程科目
CREATE TABLE Class(
    ClassID VARCHAR(20) PRIMARY KEY,
    ClassName VARCHAR(300),
    Instructor VARCHAR(100)
);

-- 學生
CREATE TABLE Student(
    StudentID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    Major VARCHAR(100),
    ClassYear VARCHAR(50)
);

--
-- UNIQUE (StudentID, ClassID)
-- 表示一位學生只能選擇同樣的課程一次不得重覆
CREATE TABLE ClassStudent_Relation(
    StudentID VARCHAR(20) NOT NULL,
    ClassID VARCHAR(20) NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    UNIQUE (StudentID, ClassID)
);

INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('1', '國文', '朱媽');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('2', '數學', '凡清');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('3', '英文', '高國華');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('4', '理化', '阿飛');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('5', '物理', '簡杰');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('6', '歷史', '呂杰');
INSERT INTO Class (ClassID, ClassNAME, INSTRUCTOR) VALUES ('7', '地理', '王剛');

INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('1', '馬小九', '資訊管理', '大二');
INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('2', '輸真慘', '資訊工程', '大一');
INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('3', '菜英蚊', '企業管理', '大三');
INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('4', '豬利輪', '財務金融', '大二');
INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('5', '韓國魚', '應用外語', '碩二');
INSERT INTO Student (StudentID, NAME, MAJOR, ClassYEAR) VALUES ('6', '賣臺銘', '國際貿易', '大一');

INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('1', '1');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('1', '3');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('2', '1');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('3', '1');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('3', '2');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('3', '5');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('5', '6');
INSERT INTO ClassStudent_Relation (StudentID, ClassID) VALUES ('6', '6');

SELECT * FROM Class;
SELECT * FROM Student;
SELECT * FROM ClassStudent_Relation;

SELECT C.*, CS.*, S.*
FROM Class C 
JOIN ClassStudent_Relation CS ON C.ClassID = CS.ClassID
JOIN Student S ON S.StudentID = CS.StudentID
ORDER BY C.ClassID, S.StudentID;

-- 視觀表 (Views) 可以被當作是虛擬表格。它跟表格的不同是，表格中有實際儲存資料
-- 而視觀表是建立在表格之上的一個架構，它本身並不實際儲存資料
-- 建立一個視觀表的語法如下：
-- CREATE VIEW "VIEW_NAME" AS

CREATE VIEW V_REGION_SUM_SALES AS (
	SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) AS "SUM_SALES"
	FROM GEOGRAPHY G LEFT JOIN STORE_INFORMATION S
	ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
	GROUP BY G.REGION_NAME
	ORDER BY SUM_SALES DESC
);

SELECT * FROM v_region_sum_sales;

-- ☆加一個欄位
ALTER TABLE STORE_INFORMATION ADD NUM_CUSTOMER NUMERIC;

-- 改變欄位名稱
ALTER TABLE STORE_INFORMATION RENAME COLUMN NUM_CUSTOMER TO NUM_OF_CUSTOMER;

-- 改變欄位的資料種類
ALTER TABLE STORE_INFORMATION MODIFY NUM_OF_CUSTOMER VARCHAR(20);

-- 刪去一個欄位
ALTER TABLE STORE_INFORMATION DROP COLUMN NUM_OF_CUSTOMER;

-- DROP會將資料表刪除
DROP TABLE table1;

-- TRUNCATE會將資料表的資料清空(資料表不會消失)
TRUNCATE TABLE store_information;









