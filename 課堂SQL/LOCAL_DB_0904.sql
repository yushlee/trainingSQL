-- NOT NULL 不允許一個欄位含有 NULL 值
CREATE TABLE GEOGRAPHY (
    GEOGRAPHY_ID NUMERIC(10 , 0 ) PRIMARY KEY,
    REGION_NAME VARCHAR(255) NOT NULL
);

-- PRIMARY KEY 不允欄位唯重複,且不允許NULL
-- UNIQUE 欄位中的所有資料都是不一樣的值,允許NULL
CREATE TABLE GEOGRAPHY (
    GEOGRAPHY_ID NUMERIC(10 , 0 ) PRIMARY KEY,
    REGION_NAME VARCHAR(255) UNIQUE
);

-- CHECK 限制是保證一個欄位中的所有資料都是符合某些條件
CREATE TABLE STORE_INFORMATION(
	STORE_ID   NUMERIC (10,0) PRIMARY KEY,
	STORE_NAME VARCHAR(255),
	SALES      NUMERIC (10,0) CHECK (SALES > 0),
	STORE_DATE datetime,
 	GEOGRAPHY_ID NUMERIC (10,0)
);

-- 外來鍵(Foreign Key)是一個(或數個)指向另外一個表格主鍵的欄位。
-- 外來鍵的目的是確定資料的參考完整性(referential integrity)
CREATE TABLE STORE_INFORMATION(
	STORE_ID   NUMERIC (10,0) PRIMARY KEY,
	STORE_NAME VARCHAR(255),
	SALES      NUMERIC (10,0) CHECK (SALES > 0),
	STORE_DATE datetime,
 	GEOGRAPHY_ID NUMERIC (10,0),
 	CONSTRAINT CONSTRAINT_GEOGRAPHY_ID FOREIGN KEY (GEOGRAPHY_ID) REFERENCES GEOGRAPHY (GEOGRAPHY_ID)
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
-- UF:唯一外來鍵 UNIQUE Foreign Key
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



-- Many to Many
-- 課程科目

DROP TABLE ClassStudent_Relation;
DROP TABLE Class;
DROP TABLE Student;

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

-- 視圖(VIEWS)
CREATE VIEW REGION_SUM_VIEW AS (
	SELECT G.REGION_NAME, IFNULL(SUM(SALES), 0) "SUM_SALES"
	FROM geography G LEFT JOIN store_information S
	ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
	GROUP BY G.REGION_NAME
	ORDER BY SUM_SALES DESC
);

SELECT * FROM REGION_SUM_VIEW;

SELECT * FROM store_information;

-- 新增一筆資料到商店資料表
INSERT INTO store_information (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) 
VALUE(10, 'Apple Inc', 6000, STR_TO_DATE('2022-09-04', '%Y-%m-%d'), 3);

-- 若新增欄位值已經是全欄位,則欄位名稱可省略不寫
INSERT INTO store_information VALUE(11, 'Apple Inc', 6000, STR_TO_DATE('2022-09-04', '%Y-%m-%d'), 3);

SELECT * FROM region_sum ORDER BY SUM_SALES DESC;

INSERT INTO region_sum (REGION_NAME, SUM_SALES) (
	SELECT G.REGION_NAME, IFNULL(SUM(SALES), 0) "SUM_SALES"
	FROM geography G LEFT JOIN store_information S
	ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
	GROUP BY G.REGION_NAME
);
