 -- Alias
 -- 欄位別名及表格別名
 -- 1.AS可省略不寫
 -- 2.別名使用雙引號括起來(雙引號可省略)
 -- 別名不能有空白
 SELECT STORE_NAME, 
	SUM(SALES) 營業額, 
	COUNT(STORE_ID) "COUNT_STORE",
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "LIST SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME;