-- 每個部門的平均薪資(DEPARTMENT_ID, AVG_DEP_SALARY)
SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "AVG_DEP_SALARY"
FROM employees E
GROUP BY E.DEPARTMENT_ID
ORDER BY E.DEPARTMENT_ID;


-- 查詢每個部門高於平均部門薪資的員工
-- (結果依部門平均薪資降冪排序)

SELECT  E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, E.DEPARTMENT_ID, 
	D.DEPARTMENT_NAME,
	EMP_DEP_AVG.AVG_DEP_SALARY 
FROM (
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "AVG_DEP_SALARY"
	FROM employees E
	GROUP BY E.DEPARTMENT_ID
	ORDER BY E.DEPARTMENT_ID
) EMP_DEP_AVG, EMPLOYEES E, DEPARTMENTS D
WHERE EMP_DEP_AVG.DEPARTMENT_ID = E.DEPARTMENT_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND E.SALARY > EMP_DEP_AVG.AVG_DEP_SALARY
ORDER BY EMP_DEP_AVG.AVG_DEP_SALARY DESC, E.SALARY DESC;


SELECT  E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, E.DEPARTMENT_ID, 
	D.DEPARTMENT_NAME,
	EMP_DEP_AVG.AVG_DEP_SALARY 
FROM (
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "AVG_DEP_SALARY"
	FROM employees E
	GROUP BY E.DEPARTMENT_ID
	ORDER BY E.DEPARTMENT_ID
) EMP_DEP_AVG
JOIN EMPLOYEES E ON EMP_DEP_AVG.DEPARTMENT_ID = E.DEPARTMENT_ID
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > EMP_DEP_AVG.AVG_DEP_SALARY
ORDER BY EMP_DEP_AVG.AVG_DEP_SALARY DESC, E.SALARY DESC;





