
--   SQL UNION 聯集(不包含重覆值)
-- UNION可下多次
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;


