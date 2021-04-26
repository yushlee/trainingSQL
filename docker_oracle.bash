
★ tnsnames.ora 路徑
more ./u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora
more ./u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
cd /u01/app/oracle/product/11.2.0/xe/network/admin

C:/home/oracle
docker run -d -p 1533:1521 -p 8088:8080 wnameless/oracle-xe-11g-r2
docker run -d -p 1533:1521 -p 8088:8080 -v C:/home/oracle:/u01/app/oracle/product/11.2.0/xe/network/admin wnameless/oracle-xe-11g-r2


http://127.0.0.1:8080/apex/f?p=4950:1:1358154753622568
http://127.0.0.1:8088/apex/f?p=4950:1:1358154753622568


狀態 : 失敗 -測試失敗: Listener refused the connection with the following error:
ORA-12505, TNS:listener does not currently know of SID given in connect descriptor

狀態 : 失敗 -測試失敗: IO 錯誤: Got minus one from a read call
 