-- HR DB 資料查詢
-- 查詢所有部門資訊如下：
-- 1.所在地(國家、洲省、城市)
-- 2.部門(部門編號、部門名稱)
-- 3.部門管理者(員工編號、員工姓名、員工職稱)

/*
Step1:找出資料表、資料欄
LOCATIONS(COUNTRY_ID, CITY, STATE_PROVINCE)
DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME)
EMPLOYEES(EMPLOYEE_ID, FIRST_NAME)
JOBS(JOB_TITLE)

Step2:找出資料表與資料表的關聯欄位
DEPARTMENTS(LOCATION_ID)LOCATIONS
DEPARTMENTS(MANAGER_ID,EMPLOYEE_ID)EMPLOYEES
EMPLOYEES(JOB_ID)JOBS

Step3:寫SQL
*/

SELECT L.COUNTRY_ID, L.CITY, L.STATE_PROVINCE,
	D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM DEPARTMENTS D 
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN EMPLOYEES E ON ....;

