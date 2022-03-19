-- 每個部門的平均薪資(DEPARTMENT_ID, AVG_DEP_SALARY)
SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "AVG_DEP_SALARY"
FROM employees E
GROUP BY E.DEPARTMENT_ID;

-- SELECT → FROM  → JOIN → WHERE → GROUP BY → HAVING → ORDER BY
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, 
	MIN(E.SALARY), MAX(E.SALARY), COUNT(E.EMPLOYEE_ID),
	FLOOR(AVG(E.SALARY)) "AVG_DEP_SALARY"
FROM departments D 
JOIN employees E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
-- WHERE E.SALARY > 300
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING FLOOR(AVG(E.SALARY)) > 9000
ORDER BY AVG_DEP_SALARY;

SELECT * FROM departments;


-- HR DB 資料查詢
-- 查詢所有部門資訊如下：
-- 1.所在地(國家、洲省、城市)
-- 2.部門(部門編號、部門名稱)
-- 3.部門管理者(員工編號、員工姓名、員工職稱)

-- Step1:找出要查詢的「資料欄」與「資料表」
-- COUNTRY_ID,STATE_PROVINCE,CITY (LOCATIONS)
-- DEPARTMENT_ID,DEPARTMENT_NAME(DEPARTMENTS)
-- EMPLOYEE_ID,FIRST_NAME(EMPLOYEES)
-- JOB_TITLE(JOBS)

-- Step2:透過第一步所找到的資料表,找出資料表與資料表之間的關聯欄位
-- LOCATIONS(LOCATION_ID)DEPARTMENTS
-- DEPARTMENTS(MANAGER_ID,EMPLOYEE_ID)EMPLOYEES
-- EMPLOYEES(JOB_ID)JOBS

-- Step3:經由Step1、Step2所找尋出的(資料欄、資料表、資料表關聯欄位)撰寫SQL
SELECT C.COUNTRY_ID, C.COUNTRY_NAME, 
	L.STATE_PROVINCE, L.CITY,
	D.DEPARTMENT_ID, D.DEPARTMENT_NAME,
    E.EMPLOYEE_ID, E.FIRST_NAME, J.JOB_TITLE
FROM DEPARTMENTS D 
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C ON L.COUNTRY_ID =  C.COUNTRY_ID
LEFT JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID;

-- MySQL轉換函數：
-- 1.DATE_FORMAT(date,format):日期轉字串
SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d %T'),
-- 2.STR_TO_DATE(str,format):字串轉日期
STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T");

SELECT store_id, store_name, store_date,
	DATE_FORMAT(store_date, '%m/%d/%Y %T')
FROM store_information
WHERE store_date > STR_TO_DATE('01-01-2018', "%m-%d-%Y");


-- MS SQL
-- 1.日期轉字串
SELECT convert(varchar, getdate(), 100) 'mon dd yyyy hh:mmAM (or PM)'
SELECT convert(varchar, getdate(), 101) 'mm/dd/yyyy'
SELECT convert(varchar, getdate(), 102) 'yyyy.mm.dd'
SELECT convert(varchar, getdate(), 103) 'dd/mm/yyyy'
SELECT convert(varchar, getdate(), 104) 'dd.mm.yyyy'
SELECT convert(varchar, getdate(), 105) 'dd-mm-yyyy'
SELECT convert(varchar, getdate(), 106) 'dd mon yyyy'
SELECT convert(varchar, getdate(), 107) 'mon dd, yyyy'
SELECT convert(varchar, getdate(), 108) 'hh:mm:ss'
SELECT convert(varchar, getdate(), 109) 'mon dd yyyy hh:mm:ss:mmmAM (or PM)'
SELECT convert(varchar, getdate(), 110) 'mm-dd-yyyy'
SELECT convert(varchar, getdate(), 111) 'yyyy/mm/dd'
SELECT convert(varchar, getdate(), 112) 'yyyymmdd'
SELECT convert(varchar, getdate(), 113) 'dd mon yyyy hh:mm:ss:mmm'
SELECT convert(varchar, getdate(), 114) 'hh:mm:ss:mmm(24h)'
SELECT convert(varchar, getdate(), 120) 'yyyy-mm-dd hh:mm:ss(24h)'
SELECT convert(varchar, getdate(), 121) 'yyyy-mm-dd hh:mm:ss.mmm'
SELECT convert(varchar, getdate(), 126) 'yyyy-mm-ddThh:mm:ss.mmm'

-- 2.字串轉日期
SELECT convert(datetime, '2021-08-16 21:52:22', 120)　'yyyy-mm-dd hh:mm:ss(24h)'








