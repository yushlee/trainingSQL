# Windows 系統僅需下載後安裝即可(僅此一步驟)
# mysql-installer-community-8.0.25.0.msi
https://dev.mysql.com/downloads/installer/

# Mac with Intel核心 下載並且安裝
https://desktop.docker.com/mac/stable/amd64/Docker.dmg

# Mac with Apple核心 下載並且安裝
https://desktop.docker.com/mac/stable/arm64/Docker.dmg

# 下載 docker MySQL
# 開啟終端機	Finder → 工具程式 → 終端機
docker pull mariadb

# 啟動 docker MySQL Database
docker run -p 127.0.0.1:3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mariadb:latest

# MySQL workbench (開發工具) 下載並且安裝
https://dev.mysql.com/downloads/workbench/
