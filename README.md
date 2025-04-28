# Healthope-DB #

## 目錄 ##

1. 簡介
2. 還原專案
3. 從 Database 專案建構 SQL 資料庫
4. 從專案 Migration 至 DB 流程
5. 從 DB 還原至專案流程
6. 其他備註

## 簡介 ##

Healthope-DB 方案包含兩個 Visual Studio 專案，
分別為 DataBase.Migration (主控台應用程式) 及 Database (SQL Project)

DataBase.Migration 功能為：紀錄資料庫的遷移紀錄

Database 功能為：將資料庫內容還原

## 還原專案 ##

1. 複製 Healthope-DB Repo `git clone https://github.com/Annie033088/Healthope-DB.git`
2. 進入 Database 資料夾運行方案 (Database.sln)
3. 重建方案同時還原已安裝 Nuget 套件 (DbUp)

## 從 Database 專案建構 SQL 資料庫 ##

1. 打開 Database 專案，右鍵 Database 專案，點擊發行，按照發行流程將 SQL Server 的資料庫建立完畢
2. 資料庫這裡命名為 Healthope
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/發行到資料庫.png)

## 從專案 Migration 至 DB 流程 ##

1. 打開 SQL Server 的資料庫, 並在資料庫內執行 DataBase.Migration 底下的
 InitializeSchemaVersionsTable.sql 檔案 [說明](#將資料插入-schemaversions-的表)
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/初始化遷移紀錄.png)
2. 設定 DataBase.Migration 的 Program.cs 裡的資料庫連線字串
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/資料庫連線字串.png)
3. 將要更新的資料庫指令檔案 (.sql檔案) 存入 DataBase.Migration 的 SQLScripts 資料夾底下，
並執行 DataBase.Migration 專案
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/新增會員表.png)
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/執行成功.png)

已完成資料庫 Migration

## 從DB還原至專案流程 ##

1. 右鍵點擊 Database 專案，點擊結構描述比較，更新 Database 專案的資料庫結構
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/結構描述比較.png)
![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/比較.png)

## 其他備註 ##

### DbUp 套件說明 ###

- 簡述： DbUp 是一個開源的 .NET 工具，專門用來執行版本控制的資料庫遷移 (Database Migrations)
- 主要功能：利用 SchemaVersions 表格，記錄哪些 SQL 已執行過，避免重複執行
- 進階功能： 加入 Transaction (確保更新失敗時回滾) `.WithTransaction()`
- 補充：Migration 專案裡面的 SQLScripts資料夾包括：
  1. 過去執行過的 sql 檔
  2. 當開發者要修改資料表時，對應的 sql 檔

![Initialize Image](https://github.com/Annie033088/Healthope-DB/blob/main/img/SQLScripts.png)

### 將資料插入 SchemaVersions 的表 ###

- 目的：讓 DataBase.Migration 執行的時候， DbUp 套件可以正確判斷哪些 script (.sql檔案) 已經被執行過了
- 原理：當使用 DbUp 來做資料庫更新的時候，資料庫內會產生 SchemaVersions 這張表，這張表會紀錄專案中的 SQLScripts 資料夾內的哪
些 script 已經被執行過了，因此當需要更新資料庫結構時，必須先將 SchemaVersions 這張紀錄表還原，才能正確執行 script (.sql檔案)
