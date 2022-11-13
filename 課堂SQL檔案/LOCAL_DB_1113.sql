DROP TABLE TABLE_A;

-- 主鍵可以包含一或多個欄位。當主鍵包含多個欄位時，稱為組合鍵 (Composite Key)
CREATE TABLE TABLE_A
(
  PK_1 NUMERIC(5),
  PK_2 NUMERIC(5),
  CONSTRAINT TABLE_A_PK PRIMARY KEY (PK_1, PK_2)
);


-- One to One
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
    CONSTRAINT CONSTRAINT_SGID_UNIQUE UNIQUE (SGID),
	CONSTRAINT CONSTRAINT_FK_GOV_GID FOREIGN KEY (SGID) REFERENCES Gov(GID)
);

INSERT INTO Gov (GID, Name, Address, TermBegin, TERMEND) VALUES (110, 'Bob', '123 Any St', '2009-01-01', '2011-12-31');

INSERT INTO State (SID, StateName, Population, SGID) VALUES (111, 'Virginia', 2000000, 110);

SELECT * FROM Gov;

SELECT * FROM STATE;


-- One to Many

-- 供應商
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

-- 商品清單
-- 透過設置FOREIGN KEY來確保資料參照的完整性限制
CREATE TABLE Inventory(
    Item VARCHAR(50) PRIMARY KEY,
    Description VARCHAR(300),
    CurrentQuantity NUMERIC(4) NOT NULL,
    VendorNUMERIC NUMERIC(4),
	CONSTRAINT CONSTRAINT_VENDOR_FK FOREIGN KEY (VendorNUMERIC) REFERENCES Vendor(VendorNUMERIC)
);

INSERT INTO Vendor (VENDORNUMERIC, NAME, ADDRESS, CITY, STREET, ZIPCODE, PHONENUMERIC, STATUS) VALUES ('1', 'Apple Inc', '大同區承德路一段1號1樓', '台北市', '承德路', '10351', '02 7743 8068', '營運中');
INSERT INTO Inventory (ITEM, DESCRIPTION, CURRENTQUANTITY, VENDORNUMERIC) VALUES ('iPhone 7 Plus', 'iPhone 7 Plus 5.5吋手機 32GB(原廠包裝盒+原廠配件)', '10', '1');

SELECT * FROM Vendor;
SELECT * FROM Inventory;


-- Many to Many 多對多關係(雙向一對多)
-- Many to Many

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

SELECT * FROM Student;
SELECT * FROM Class;
SELECT * FROM ClassStudent_Relation;


SELECT S.NAME, CR.StudentID, CR.ClassID, C.ClassNAME
FROM ClassStudent_Relation CR
JOIN Student S ON CR.StudentID = S.StudentID
JOIN Class C ON CR.ClassID = C.ClassID;

-- 本身並不實際儲存資料
CREATE VIEW REGION_VIEW AS (
	SELECT G.REGION_NAME, IFNULL(SUM(S.SALES), 0) "REGION_SUM_SALES"
	FROM GEOGRAPHY G
	LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
	GROUP BY G.REGION_NAME
);

-- 視圖
SELECT * FROM region_view 
WHERE REGION_SUM_SALES > 0;


-- 加一個欄位: ADD "欄位 1" "欄位 1 資料種類"
-- Oracle
ALTER TABLE STORE_INFORMATION ADD NUM_CUSTOMER NUMBER;

-- MySQL
ALTER TABLE STORE_INFORMATION ADD NUM_CUSTOMER NUMERIC;

-- 改變欄位名稱: RENAME "原本欄位名" "新欄位名" "新欄位名資料種類"
--  Oracle、MySQL
ALTER TABLE STORE_INFORMATION RENAME COLUMN NUM_CUSTOMER TO NUM_OF_CUSTOMER;


-- 改變欄位的資料種類: MODIFY "欄位 1" "新資料種類"
--  Oracle
ALTER TABLE STORE_INFORMATION MODIFY NUM_OF_CUSTOMER VARCHAR2(20);

--  MySQL
ALTER TABLE STORE_INFORMATION MODIFY NUM_OF_CUSTOMER VARCHAR(20);


-- 刪去一個欄位: DROP "欄位 1"
--  Oracle、MySQL
ALTER TABLE STORE_INFORMATION DROP COLUMN NUM_OF_CUSTOMER;


SELECT * FROM STORE_INFORMATION;






