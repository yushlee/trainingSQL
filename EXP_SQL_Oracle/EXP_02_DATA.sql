-- SQL �m���D(�G)���
DELETE FROM STORE_INFORMATION;
DELETE FROM GEOGRAPHY;
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (1,'East');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (2,'West');
Insert into GEOGRAPHY (GEOGRAPHY_ID,REGION_NAME) values (3,'North');
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (1,'Boston',2200,TO_TIMESTAMP('2018-03-09 00:00:00','YYYY-MM-DD HH24:MI:SS'),1);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (2,'Los Angeles',1400,TO_TIMESTAMP('2018-04-05 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (3,'San Diego',250,TO_TIMESTAMP('2018-01-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (4,'Los Angeles',300,TO_TIMESTAMP('2018-02-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (5,'Albany, Crossgates',2500,TO_TIMESTAMP('2018-05-15 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (6,'Buffalo, Walden Galleria',3000,TO_TIMESTAMP('2018-06-10 00:00:00','YYYY-MM-DD HH24:MI:SS'),NULL);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (7,'San Diego',500,TO_TIMESTAMP('2018-02-15 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (8,'Los Angeles',1600,TO_TIMESTAMP('2018-02-07 00:00:00','YYYY-MM-DD HH24:MI:SS'),2);
INSERT INTO STORE_INFORMATION (STORE_ID,STORE_NAME,SALES,STORE_DATE,GEOGRAPHY_ID) VALUES (9,'Boston',1500,TO_TIMESTAMP('2018-03-09 00:00:00','YYYY-MM-DD HH24:MI:SS'),1);
COMMIT;