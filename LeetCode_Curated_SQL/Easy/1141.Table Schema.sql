DROP TABLE ACTIVITY;
CREATE TABLE ACTIVITY (
 USER_ID INT,
 SESSION_ID INT,
 ACTIVITY_DATE DATE,
 -- MySQL
 -- ACTIVITY_TYPE ENUM('open_session', 'end_session', 'scroll_down', 'send_message')
 ACTIVITY_TYPE VARCHAR(20) CHECK( ACTIVITY_TYPE IN ('open_session', 'end_session', 'scroll_down', 'send_message') )
);

INSERT INTO ACTIVITY VALUES (1, 1, '2019-07-20', 'open_session');
INSERT INTO ACTIVITY VALUES (1, 1, '2019-07-20', 'scroll_down');
INSERT INTO ACTIVITY VALUES (1, 1, '2019-07-20', 'end_session');
INSERT INTO ACTIVITY VALUES (2, 4, '2019-07-20', 'open_session');
INSERT INTO ACTIVITY VALUES (2, 4, '2019-07-21', 'send_message');
INSERT INTO ACTIVITY VALUES (2, 4, '2019-07-21', 'end_session');
INSERT INTO ACTIVITY VALUES (3, 2, '2019-07-21', 'open_session');
INSERT INTO ACTIVITY VALUES (3, 2, '2019-07-21', 'send_message');
INSERT INTO ACTIVITY VALUES (3, 2, '2019-07-21', 'end_session');
INSERT INTO ACTIVITY VALUES (4, 3, '2019-06-25', 'open_session');
INSERT INTO ACTIVITY VALUES (4, 3, '2019-06-25', 'end_session');
COMMIT;