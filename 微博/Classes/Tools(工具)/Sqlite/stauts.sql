-- 创建微博数据表 --
CREATE TABLE IF NOT EXISTS "T_status" (
"userId" INTEGER NOT NULL,
"statusId" INTEGER NOT NULL,
"status" TEXT,
"createTime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("userId","statusId")
);
