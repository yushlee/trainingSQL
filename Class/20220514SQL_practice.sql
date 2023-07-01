-- exercise
# 計算和統計「個别商店」的以下三項資料：
#「總合營業額」、「商店資料個數」、「平均營業額」
# 搜尋或排除條件如下：
# 1.排除「平均營業額」1000（含)以下的商店資料
# 2.排除「商店資料個數」1(含)個以下的商店資料
# 3.依照「平均營業額」由大至小排序
select STORE_NAME, sum(SALES), 
		COUNT(STORE_ID), round(avg(SALES))
from STORE_INFORMATION
group by STORE_NAME
having avg(SALES) > 1000 and COUNT(STORE_ID) > 1
order by avg(SALES) DESC;

-- 欄位別名 as
 -- 1. as 可省略不寫
 -- 2. 雙引號可省略但不可含空白 
select STORE_NAME,
		COUNT(STORE_ID) as "store", 
        group_concat(SALES order by SALES DESC SEPARATOR "/") as "separate $"
from STORE_INFORMATION
group by store_name;

-- 表格別名
select s.store_id, s.store_name, s.store_date
from STORE_INFORMATION as S;

-- 3筆
select * from geography;

-- 9筆 
select * from store_information;

-- (defult = inner) join(表格名稱) ... on (連結欄位名稱)
select s.*, g.*
from geography as g, STORE_INFORMATION as s
where s.GEOGRAPHY_ID = g.GEOGRAPHY_ID;

-- 用這個有防呆功能
select s.*, g.region_name
from geography g join STORE_INFORMATION s
on s.GEOGRAPHY_ID = g.GEOGRAPHY_ID;

-- (right, left) outer join
select s.*, g.*
from geography g left outer join STORE_INFORMATION s
on s.GEOGRAPHY_ID = g.GEOGRAPHY_ID;

-- 全連結(full outer join MySQL不支援
select s.*, g.*
from geography g full outer join STORE_INFORMATION s
on s.GEOGRAPHY_ID = g.GEOGRAPHY_ID;

-- 差集 
-- 左差
select s.*, g.*
from geography g left outer join STORE_INFORMATION s
on g.GEOGRAPHY_ID = s.GEOGRAPHY_ID
where s.GEOGRAPHY_ID is null;

-- 右差
select s.*, g.*
from geography g right outer join STORE_INFORMATION s
on g.GEOGRAPHY_ID = s.GEOGRAPHY_ID
where g.GEOGRAPHY_ID is null;

-- 補集 
select s.*, g.*
from geography g full outer join STORE_INFORMATION s
on g.GEOGRAPHY_ID = s.GEOGRAPHY_ID
where g.GEOGRAPHY_ID is null and s.GEOGRAPHY_ID is null;

-- Exercise
-- 查詢各區域的營業額總計 資料結果依營業額總計由大到小排序 (不論該區域底下是否有所屬商店)
select g.region_name, ifnull(sum(sales),0)
from geography as g left outer join store_information as s
on g.geography_id = s.geography_id
group by region_name;

select g.*, s.*
from geography as g left outer join store_information as s
on g.geography_id = s.geography_id;

-- 查詢各區域的商店個數 資料結果依區域的商店個數由大至小排序 (依據商店名稱,不包含重覆的商店) (不論該區域底下是否有所屬商店)
select g.region_name , count(s.store_name)as "sum"
from geography as g left outer join store_information as s
on g.geography_id = s.geography_id
group by g.region_name
order by sum DESC;

select g.region_name, count(distinct s.store_name)
from geography g left outer join STORE_INFORMATION s
on g.GEOGRAPHY_ID = s.GEOGRAPHY_ID
group by g.region_name
order by count(s.store_name) DESC;


-- 由不同欄位獲得的資料串連在一起
select concat(store_ID, "-", store_name, " $", sales)
from STORE_INFORMATION;

-- substring 
select STORE_NAME, substring(store_name,3),substring(store_name,3,4)
from STORE_INFORMATION;

-- trim 去左側右側空白
select trim(" sample "), Ltrim(" sample "), Rtrim(" sample ");

-- TRIM([[位置] [要移除的字串] FROM ] 字串)
-- [位置] 的可能值為 LEADING (起頭), TRAILING (結尾), or BOTH (起頭及結尾)。
SELECT STORE_ID, STORE_NAME,
    TRIM(LEADING 'Bos' FROM STORE_NAME) as "head",
    TRIM(TRAILING 's' FROM STORE_NAME),
    TRIM(BOTH 'L' FROM STORE_NAME)
FROM STORE_INFORMATION;

-- PRIMARY KEY 主建(不允許NULL)
-- UNIQUE 唯一鍵(允許NULL)
CREATE TABLE GEOGRAPHY (  
	GEOGRAPHY_ID NUMERIC (10,0) PRIMARY KEY,
	REGION_NAME  VARCHAR(255)
);

-- 組合鍵 (Composite Key)
CREATE TABLE TABLE_A
(
  PK_1 NUMERIC(10) NOT NULL,
  PK_2 NUMERIC(10) NOT NULL,
  CONSTRAINT TABLE_A_PK PRIMARY KEY (PK_1, PK_2)
);

SELECT * FROM TABLE_A;
-- FOREIGN KEY 外來鍵
-- 確定資料的"參考完整性"(referential integrity)

CREATE TABLE STORE_INFORMATION (
	STORE_ID   NUMERIC (10,0) PRIMARY KEY,
	STORE_NAME VARCHAR(255),
	SALES      NUMERIC (10,0) CHECK (SALES > 0),
	STORE_DATE datetime,
 	GEOGRAPHY_ID NUMERIC (10,0),
 	CONSTRAINT CONSTRAINT_GEOGRAPHY_ID FOREIGN KEY (GEOGRAPHY_ID) REFERENCES GEOGRAPHY (GEOGRAPHY_ID)
);


-- 父項資料表(主檔)
SELECT * FROM GEOGRAPHY;

-- 子項資料表(細項檔)
SELECT * FROM STORE_INFORMATION;


-- One to One

DROP TABLE State;
DROP TABLE Gov;

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


-- One to Many
DROP TABLE Inventory;
DROP TABLE Vendor;
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


-- Many to Many
DROP TABLE ClassStudent_Relation;
DROP TABLE Class;
DROP TABLE Student;
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

SELECT * FROM STORE_INFORMATION;

INSERT INTO STORE_INFORMATION (STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID) 
	VALUE (10, 'Apple', 8000, '2022-05-14 16:36:30', 3);

-- 當VALUE已經是資料的全欄位時則資料欄位可省略    
INSERT INTO STORE_INFORMATION VALUE (11, 'Apple', 8000, '2022-05-14 16:36:30', 3);

UPDATE STORE_INFORMATION SET SALES = '8800', STORE_NAME = 'APPLE'
	WHERE STORE_ID IN (10,11);


DELETE FROM STORE_INFORMATION WHERE STORE_ID IN (10,11);