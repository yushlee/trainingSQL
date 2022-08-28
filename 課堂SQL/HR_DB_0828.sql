-- HR DB 資料查詢
-- 查詢所有部門資訊如下：
-- 1.所在地(國家、洲省、城市)
-- 2.部門(部門編號、部門名稱)
-- 3.部門管理者(員工編號、員工姓名、員工職稱)

-- Step1:找出"資料欄"及所屬的"資料表"
-- (locations)COUNTRY_ID, STATE_PROVINCE, CITY
-- (departments)DEPARTMENT_ID, DEPARTMENT_NAME
-- (employees)EMPLOYEE_ID, FIRST_NAME
-- (jobs)JOB_TITLE

-- Step2:找出資料表之間關聯欄位
-- (locations) LOCATION_ID (departments)
-- (departments) MANAGER_ID,EMPLOYEE_ID(employees)
-- (employees) JOB_ID (jobs)

-- Step3:
SELECT L.COUNTRY_ID, L.STATE_PROVINCE, L.CITY,
	D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM LOCATIONS L
JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
JOIN XXXX ON XXX;







SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM employees;
