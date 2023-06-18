-- HR DB 資料查詢
-- 查詢每個部門高於平均部門薪資的員工
-- (結果依部門平均薪資降冪排序)

-- 1.每個部門的部門平均薪資(部門平均薪資表)
-- 2.每位員工與部門平均薪資表比較(與同部門相比)

SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, E.DEPARTMENT_ID,
	T_DEP_INFO.DEPARTMENT_ID, T_DEP_INFO.DEP_AVG_SALARY
FROM EMPLOYEES E, (
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) DEP_AVG_SALARY
	FROM EMPLOYEES E
	GROUP BY E.DEPARTMENT_ID
) T_DEP_INFO
WHERE E.DEPARTMENT_ID = T_DEP_INFO.DEPARTMENT_ID
AND E.SALARY > T_DEP_INFO.DEP_AVG_SALARY
ORDER BY E.DEPARTMENT_ID, E.SALARY DESC;



