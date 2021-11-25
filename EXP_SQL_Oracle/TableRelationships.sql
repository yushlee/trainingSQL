-- ★ One to One
DROP TABLE State;
DROP TABLE Gov;
-- 政府官員州長
CREATE TABLE Gov(
    GID number(6) PRIMARY KEY,
    Name varchar2(25),
    Address varchar2(30),
    TermBegin date,
    TermEnd date
);

-- 州
-- REFERENCES(參照)、CONSTRAINT(限制)、UNIQUE(唯一)
CREATE TABLE State(
    SID number(3) PRIMARY KEY,
    StateName varchar2(15),
    Population number(10),
    SGID Number(4) REFERENCES Gov(GID),
    CONSTRAINT GOV_SDID UNIQUE (SGID)
);

INSERT INTO gov(GID, Name, Address, TermBegin, TERMEND) values(110, 'Bob', '123 Any St', '2009-01-01', '2011-12-31');

INSERT INTO STATE values(111, 'Virginia', 2000000, 110);


-- ★ One to Many
DROP TABLE Inventory;
DROP TABLE Vendor;
-- 供應商
CREATE TABLE Vendor(
    VendorNumber number(4) PRIMARY KEY,
    Name varchar2(20),
    Address varchar2(200),
    City varchar2(15),
    Street varchar2(200),
    ZipCode varchar2(10),
    PhoneNumber varchar2(12),
    Status varchar2(50)
);

-- 商品清單
CREATE TABLE Inventory(
    Item varchar2(50) PRIMARY KEY,
    Description varchar2(300),
    CurrentQuantity number(4) NOT NULL,
    VendorNumber number(2) REFERENCES Vendor(VendorNumber)
);

INSERT INTO "VENDOR" (VENDORNUMBER, NAME, ADDRESS, CITY, STREET, ZIPCODE, PHONENUMBER, STATUS) VALUES ('1', 'Apple Inc', '大同區承德路一段1號1樓', '台北市', '承德路', '10351', '02 7743 8068', '營運中');
INSERT INTO "INVENTORY" (ITEM, DESCRIPTION, CURRENTQUANTITY, VENDORNUMBER) VALUES ('iPhone 7 Plus', 'iPhone 7 Plus 5.5吋手機 32GB(原廠包裝盒+原廠配件)', '10', '1');


-- ★ Many to Many
DROP TABLE CLASS_STUDENT_RELATION;
DROP TABLE Class;
DROP TABLE Student;
-- 課程科目
CREATE TABLE Class(
    ClassID varchar2(20) PRIMARY KEY,
    ClassName varchar2(300),
    Instructor varchar2(100)
);

-- 學生
CREATE TABLE Student(
    StudentID varchar2(20) PRIMARY KEY,
    Name varchar2(100),
    Major varchar2(100),
    ClassYear varchar2(50)
);

--
-- UNIQUE (StudentID, ClassID)
-- 表示一位學生只能選擇同樣的課程一次不得重覆
CREATE TABLE CLASS_STUDENT_RELATION(
    StudentID varchar2(20) NOT NULL,
    ClassID varchar2(20) NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    UNIQUE (StudentID, ClassID)
);

INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('1', '國文', '朱媽');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('2', '數學', '凡清');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('3', '英文', '高國華');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('4', '理化', '阿飛');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('5', '物理', '簡杰');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('6', '歷史', '呂杰');
INSERT INTO "CLASS" (CLASSID, CLASSNAME, INSTRUCTOR) VALUES ('7', '地理', '王剛');

INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('1', '馬小九', '資訊管理', '大二');
INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('2', '輸真慘', '資訊工程', '大一');
INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('3', '菜英蚊', '企業管理', '大三');
INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('4', '豬利輪', '財務金融', '大二');
INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('5', '韓國魚', '應用外語', '碩二');
INSERT INTO "STUDENT" (STUDENTID, NAME, MAJOR, CLASSYEAR) VALUES ('6', '賣臺銘', '國際貿易', '大一');

INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('1', '1');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('1', '3');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('2', '1');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('3', '1');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('3', '2');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('3', '5');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('5', '6');
INSERT INTO "CLASS_STUDENT_RELATION" (STUDENTID, CLASSID) VALUES ('6', '6');

COMMIT;
