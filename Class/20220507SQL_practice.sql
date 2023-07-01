SELECT SALES,STORE_NAME,STORE_DATE FROM STORE_INFORMATION;

SELECT DISTINCT STORE_NAME FROM STORE_INFORMATION; 

SELECT * FROM STORE_INFORMATION # select the column we want
# select the unique column
# only in the beginning

WHERE SALES >= 700
and STORE_DATE >= "2018-03-09";
# and 用越多資料越查越少（嚴謹查詢）
# or 用越多資料查詢出來越多（寬鬆查詢）

SELECT *
From STORE_INFORMATION
where STORE_ID = 1 
or STORE_ID = 4;

SELECT *
From STORE_INFORMATION
where STORE_ID in (1,2,3,4);
# 用 in 來一次搜尋多個

SELECT *
From STORE_INFORMATION
where SALES >= 700 and SALES <= 2500;

SELECT *
From STORE_INFORMATION
where SALES between 700 and 2500;
# 用 between 來取代 > = < 某一區間,範圍

SELECT *
From STORE_INFORMATION
where STORE_NAME like "%S";
# S 在後
SELECT *
From STORE_INFORMATION
where STORE_NAME like "B%";
# B 開頭

# SQL Like
# 'A_Z': 所有以 ‘A’ 起頭，另一個任何值的字原(中間底線表示 任何字串)，且以 ‘Z’ 為結尾的字串。 ‘ABZ’ 和 ‘A2Z’ 都符合 這一個模式，而 ‘AKKZ’ 並不符合 (因為在 A 和 Z 之間有兩個 字元，而不是一個字元)。
# 'ABC%': 所有以 'ABC' 起頭的字串。舉例來說，'ABCD' 和 'ABCABC' 都符合這個模式。
# '%XYZ': 所有以 'XYZ' 結尾的字串。舉例來說，'WXYZ' 和 'ZZXYZ' 都符合這個模式。
# '%AN%': 所有含有 'AN'這個模式的字串。舉例來說， 'LOS ANGELES' 和 'SAN FRANCISCO' 都符合這個模式。

### EXERCISE 
# 1.「且」找出屬於西區的商店
# 2.「且」營業額大於300(包含300)
# 3.「且」商店名稱“L”開頭
# 4.「或」營業日介於2018年3月至4月

SELECT * From STORE_INFORMATION
where GEOGRAPHY_ID = 2
and SALES >= 300 
and STORE_NAME like "L%"
# 分上下兩群 
or STORE_DATE between "2018-03-01" and "2018-04-30";

# order asc 升冪(defult), desc降冪
SELECT * From STORE_INFORMATION
order by SALES desc, STORE_ID asc;
# 要排多個用,分開

select avg(SALES), sum(SALES),count(STORE_ID),
max(SALES), min(SALES), mod(max(SALES),min(SALES))
from STORE_INFORMATION;
# mod(分子,分母) 取餘數

# 1.ABS(x):返回x的絕對值 
# 2.CEIL(x):返回大於或等於x的最大整數值(無條件進位) 
# 3.FLOOR(x):返回小於或等於x的最小整數值(無條件捨去) 
# 4.MOD(x,y):返回x除以y的餘數,如果y為0則返回x 
# 5.ROUND(x ,[y]): 返回(四捨五入)到小數點右邊y位的x值,y預設值為0 如果y是負數，則捨入到小數點左邊相應的整數位上
select round(SALES, -1)
FROM STORE_INFORMATION;

select count(SALES) from STORE_INFORMATION
where GEOGRAPHY_ID is not Null;

select count(DISTINCT STORE_NAME) from STORE_INFORMATION;

-- group by 以一整列資料相同為分群依據
-- 要有分類及合併否則會出現 not a group by expression
select STORE_NAME, sum(SALES), count(STORE_ID), max(SALES), min(SALES), avg(SALES)
from STORE_INFORMATION
Group by STORE_NAME;

-- 查詢資料為群組合併前的資料清單
select STORE_NAME, group_concat(SALES order by SALES ASC separator "/" )
from STORE_INFORMATION
Group by STORE_NAME;

-- where 只能針對原存在資料庫進行查詢

-- step: select -> from -> where -> Group by -> having -> order by 

-- exercise
# 計算和統計「個别商店」的以下三項資料：
#「總合營業額」、「商店資料個數」、「平均營業額」
# 搜尋或排除條件如下：
# 1.排除「平均營業額」1000（含)以下的商店資料
# 2.排除「商店資料個數」1(含)個以下的商店資料
# 3.依照「平均營業額」由大至小排序
select STORE_NAME, sum(SALES), COUNT(STORE_ID), round(avg(SALES))
from STORE_INFORMATION
group by STORE_NAME
having avg(SALES) > 1000 and COUNT(STORE_ID) > 1
order by avg(SALES) DESC
