--  查詢條件如下：
--  1.顧客：查詢結果排除黑名單顧客
--  2.顧客：同時有在「星巴客」、「阿馬龍」購買
--  3.消費金額：購買平均金額在「星巴客」大於或等於 500、「阿馬龍」大於或等於 1000
--  4.日期區間：2017-10 ~ 2017-12
--  搜尋結果欄位：顧客身份證字號、姓名、手機號碼

SELECT CUS.CUS_IDENTIFIER_ID, CUS.CUS_NAME, CUS.CUS_PHONE_ENUMBER 
FROM CUSTOMER CUS, 
(
      (
            -- 搜尋「星巴客」符合顧客
            SELECT CO.CUS_IDENTIFIER_ID
                FROM COFFEE_CUSTOMER_ORDER CO
                -- 日期區間：2017-10 ~ 2017-12
                WHERE CO.ORDER_DATE  BETWEEN '2017-10-01' AND '2017-12-31'
                -- 購買平均金額在「星巴客」大於或等於 500
                HAVING AVG(CO.ORDER_AMOUNT) >= 500
                GROUP BY CO.CUS_IDENTIFIER_ID
        )
      INTERSECT  -- 顧客：同時有在「星巴客」、「阿馬龍」購買
      (
            -- 搜尋「阿馬龍」符合顧客
            SELECT BO.CUS_IDENTIFIER_ID
                  FROM BOOK_CUSTOMER_ORDER BO
                  -- 日期區間：2017-10 ~ 2017-12
                  WHERE BO.ORDER_DATE  BETWEEN '2017-10-01' AND '2017-12-31'
                  -- 購買平均金額在「阿馬龍」大於或等於 1000
                  HAVING AVG(BO.ORDER_AMOUNT) >= 1000
                  GROUP BY BO.CUS_IDENTIFIER_ID
      )
      MINUS -- 顧客：查詢結果排除黑名單顧客
      (
            SELECT CUS.CUS_IDENTIFIER_ID FROM CUSTOMER CUS
            WHERE CUS.IS_DIFFICULT_CUS = '1'
      )
) MATCH_CUS
WHERE CUS.CUS_IDENTIFIER_ID = MATCH_CUS.CUS_IDENTIFIER_ID;




/*
查詢條件如下：
1.計算條件：顧客於「星巴客」、「阿馬龍」皆有消費總合百分比(小數第一位)
2.篩選條件：搜尋的商店範圍,需存在捷運轉運人數達1100人次以上
搜尋結果欄位：顧客身份證字號、姓名、手機號碼、消費總合、消費總合百分比、發放商店編號、發放商店名稱、發放商店消費次數
備註：
(1)發放商店為顧客於「星巴客」購買次數最高的商店
SQL資源參考 https://www.w3resource.com/sql/aggregate-functions/max-count.php
(2) 結果依消費總合百分比排序(降幕)
*/
SELECT CUS.CUS_IDENTIFIER_ID, CUS.CUS_NAME, CUS.CUS_PHONE_ENUMBER,
CUS_ORDER_AMT.CUS_TOTAL_AMT,
ROUND(
   CUS_ORDER_AMT.CUS_TOTAL_AMT / SUM_ORDER_AMT.SUM_TOTAL_AMT * 100 , 1
) AMOUNT_PROPORTION,
MAX_CONSUME_STORE.STORE_ID, MAX_CONSUME_STORE.STORE_NAME, MAX_CONSUME_STORE.STORE_COUNT
FROM (
        -- 各別顧客於「星巴客」、「阿馬龍」消費加總
        SELECT  AI_AMT.CUS_IDENTIFIER_ID, 
        (AI_AMT.BOOK_ORDER_AMT + SI_AMT.COFFEE_ORDER_AMT) CUS_TOTAL_AMT
        FROM (
                  -- 「阿馬龍」
                  SELECT BO.CUS_IDENTIFIER_ID, SUM(BO.ORDER_AMOUNT) BOOK_ORDER_AMT
                    FROM  AMAZON_INC AI,  BOOK_CUSTOMER_ORDER BO
                    WHERE  AI.STORE_ID = BO.FK_BOOK_STORE_ID
                    -- 篩選條件：搜尋的商店範圍,需存在捷運轉運人數達1100人次以上
                    AND EXISTS (
                        SELECT MRT.STATION_ID FROM MRT_TRANSIT_TRAFFIC MRT 
                        HAVING SUM(MRT.TRAFFIC_PEOPLE_QUANTITY) > 1100
                        AND MRT.STATION_ID = AI.STORE_MRT
                        GROUP BY MRT.STATION_ID)
                    GROUP BY BO.CUS_IDENTIFIER_ID
        ) AI_AMT,
        (
                  -- 「星巴客」
                  SELECT CO.CUS_IDENTIFIER_ID, SUM(CO.ORDER_AMOUNT) COFFEE_ORDER_AMT
                    FROM  STARBUCKS_INC SI,  COFFEE_CUSTOMER_ORDER CO
                    WHERE  SI.STORE_ID = CO.FK_COFFEE_STORE_ID
                    -- 篩選條件：搜尋的商店範圍,需存在捷運轉運人數達1100人次以上
                    AND EXISTS (
                        SELECT MRT.STATION_ID FROM MRT_TRANSIT_TRAFFIC MRT 
                        HAVING SUM(MRT.TRAFFIC_PEOPLE_QUANTITY) > 1100
                        AND MRT.STATION_ID = SI.STORE_MRT
                        GROUP BY MRT.STATION_ID)
                    GROUP BY CO.CUS_IDENTIFIER_ID
        ) SI_AMT
        WHERE AI_AMT.CUS_IDENTIFIER_ID = SI_AMT.CUS_IDENTIFIER_ID
) CUS_ORDER_AMT,
(
        -- 顧客於「星巴客」、「阿馬龍」全部消費加總
        SELECT  SUM(AI_AMT.BOOK_ORDER_AMT + SI_AMT.COFFEE_ORDER_AMT)  SUM_TOTAL_AMT
        FROM (
                  -- 「阿馬龍」
                  SELECT BO.CUS_IDENTIFIER_ID, SUM(BO.ORDER_AMOUNT) BOOK_ORDER_AMT
                    FROM  AMAZON_INC AI,  BOOK_CUSTOMER_ORDER BO
                    WHERE  AI.STORE_ID = BO.FK_BOOK_STORE_ID
                    -- 篩選條件：搜尋的商店範圍,需存在捷運轉運人數達1100人次以上
                    AND EXISTS (
                        SELECT MRT.STATION_ID FROM MRT_TRANSIT_TRAFFIC MRT 
                        HAVING SUM(MRT.TRAFFIC_PEOPLE_QUANTITY) > 1100
                        AND MRT.STATION_ID = AI.STORE_MRT
                        GROUP BY MRT.STATION_ID)
                    GROUP BY BO.CUS_IDENTIFIER_ID
        ) AI_AMT,
        (
                  -- 「星巴客」
                  SELECT CO.CUS_IDENTIFIER_ID, SUM(CO.ORDER_AMOUNT) COFFEE_ORDER_AMT
                    FROM  STARBUCKS_INC SI,  COFFEE_CUSTOMER_ORDER CO
                    WHERE  SI.STORE_ID = CO.FK_COFFEE_STORE_ID
                    -- 篩選條件：搜尋的商店範圍,需存在捷運轉運人數達1100人次以上
                    AND EXISTS (
                        SELECT MRT.STATION_ID FROM MRT_TRANSIT_TRAFFIC MRT 
                        HAVING SUM(MRT.TRAFFIC_PEOPLE_QUANTITY) > 1100
                        AND MRT.STATION_ID = SI.STORE_MRT
                        GROUP BY MRT.STATION_ID)
                    GROUP BY CO.CUS_IDENTIFIER_ID
        ) SI_AMT
        WHERE AI_AMT.CUS_IDENTIFIER_ID = SI_AMT.CUS_IDENTIFIER_ID
) SUM_ORDER_AMT, 
(
        -- 發放商店為顧客購買次數最高的商店
        SELECT MAX_STORE_BUY_COUNT.CUS_IDENTIFIER_ID, SI.STORE_ID, SI.STORE_NAME,
        MAX_STORE_BUY_COUNT.STORE_COUNT
        FROM (        
              SELECT  CO1.CUS_IDENTIFIER_ID, CO1.FK_COFFEE_STORE_ID,
                    COUNT (CO1.FK_COFFEE_STORE_ID) STORE_COUNT
                    FROM COFFEE_CUSTOMER_ORDER CO1
                    GROUP BY CO1.CUS_IDENTIFIER_ID, CO1.FK_COFFEE_STORE_ID
                    HAVING COUNT (CO1.FK_COFFEE_STORE_ID)= (
                          SELECT  MAX(  COUNT(CO2.FK_COFFEE_STORE_ID)  ) COUNT_STORE
                            FROM COFFEE_CUSTOMER_ORDER CO2 
                            WHERE CO2.CUS_IDENTIFIER_ID = CO1.CUS_IDENTIFIER_ID
                            GROUP BY CO2.CUS_IDENTIFIER_ID, CO2.FK_COFFEE_STORE_ID
                    )
        ) MAX_STORE_BUY_COUNT, STARBUCKS_INC SI
        WHERE MAX_STORE_BUY_COUNT.FK_COFFEE_STORE_ID = SI.STORE_ID
) MAX_CONSUME_STORE, CUSTOMER CUS
WHERE CUS_ORDER_AMT.CUS_IDENTIFIER_ID = CUS.CUS_IDENTIFIER_ID
AND CUS_ORDER_AMT.CUS_IDENTIFIER_ID = MAX_CONSUME_STORE.CUS_IDENTIFIER_ID
ORDER BY AMOUNT_PROPORTION DESC;
