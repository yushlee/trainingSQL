-- HR DB 資料查詢
-- 查詢每個部門高於平均部門薪資的員工
-- 1.平均部門薪資
-- 2.查詢"每個部門"大於「平均部門薪資」的員工
-- (結果依部門平均薪資降冪排序)

-- 部門平均薪資
SELECT DEPARTMENT_ID, FLOOR(AVG(SALARY)) DEP_AVG_SALARY
FROM employees
GROUP BY DEPARTMENT_ID;

-- 80:Sales 17位高於平均部門薪資
SELECT * FROM employees
ORDER BY DEPARTMENT_ID, SALARY DESC;


