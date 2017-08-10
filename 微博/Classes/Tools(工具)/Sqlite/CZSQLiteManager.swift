//
//  CZSQLiteManager.swift
//  001-数据库
//
//  Created by 杭州阿尔法特 on 2017/8/4.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation
import FMDB

/**
 1.数据库的本质是保存在沙河中的一个文件,首先需要创建并且打开数据库
    FMDB - 队列
 2.创建数据表
 3.增删改查
 
 提示:数据库开发，程序代码几乎都一样，区别在于 SQL
 开发数据库功能的时候，首先一定要在 navicat 中测试 SQL 的正确性!
 */

/// 数据库的管理类
class CZSQLiteManager {
    
    //单利，全局数据库工具访问点
    static var shared = CZSQLiteManager()
    
    //数据库队列
    let queue:FMDatabaseQueue
    
    //构造函数
    private init() {
        
        //数据库的全路径 - path
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径" + path)
        
        //创建数据库队列，同时'创建或者打开'数据库
        queue = FMDatabaseQueue(path: path)
        
        //打开数据库
        createTable()
    }
    
}

// MARK: - 微博数据操作
extension CZSQLiteManager {
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的账户
    ///   - since_id: 返回ID比 since_id 大的微博
    ///   - max_id: 范湖ID 比 max_id 小的微博
    /// - Returns: 微博的字典的数组，将数据库中 status 字段对应的二进制数据反序列化，生成字典
    func loadStatus(userId:String , since_id:Int64 = 0 , max_id:Int64 = 0) -> [[String:AnyObject]] {
        //1.准备 SQL 
        /**
         SELECT userId , statusId , status FROM T_status
         WHERE userId = 1
         AND statusId < 115 	-- 上拉 / 下拉，都是针对同一个 id 进行判断的
         ORDER BY statusId DESC
         LIMIT 10
         */
        var sql = "SELECT userId , statusId , status FROM T_status \n"
        sql += "WHERE userId = \(userId) \n"
        // 上拉 / 下拉,都是针对同一个 id 进行判断
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        //拼接 sql 结束后，一定要测试
        //2.执行 SQL
        let array = execRecordSet(sql: sql)
        
        //3.遍历数组，将数组中的 status 反序列化 -> 字典的数组
        var result = [[String:AnyObject]]()
        
        for dict in array {
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject]
                else {
                continue
            }
            
            //追加到数组
            result.append(json ?? [:])
            
            
        }
        
        return result
    }
    
    /**
        思考:从网络加载结束后，返回的是微博的‘字典数组’，每一个字典对应一个完整的微博记录。
        - 完整的微博记录中，包含有’微博的代号‘
        - 微博记录中，没有‘当前登陆的用户代号’
     */
    /// 新增或者修改微博数据，微博数据再刷新的时候，可能会出现重叠
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的 Id
    ///   - array: 从网络获取的‘字典的数组’
    func updateStatus(userId:String , array:[[String:AnyObject]]) -> () {
        //1.准备 sql
        let sql = "INSERT OR REPLACE INTO T_status (statusId , userId , status) VALUES (? , ? , ?);"
        
        //2.执行 sql
        queue.inTransaction { (db, rolback) in
            //遍历数组,逐条插入微博数据
            
            for dict in array {
                //从字典获取微博代号 , 将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                // 执行 sql 
                if db?.executeUpdate(sql, withArgumentsIn: [statusId , userId , jsonData]) == false {

                    //OC 回滚 *rollback = YES
                    // Swift 1.0 & 2.0 ==> rollback.memory = true
                    // Swift 3.0 的写法
                    rolback?.pointee = true
                    
                    break
                }
            }
        }
    }
    
    /// 执行一个 sql ,返回字典数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典的数组
    func execRecordSet(sql:String) -> [[String:AnyObject]] {
        //执行 sql - 查询数据，不会修改数据，所以不用开启事物!
        //事物的目的，是为了保证数据的有效性，一旦失败，回滚到初始化状态!
        
        //结果数组
        var result = [[String:AnyObject]]()
        queue.inDatabase { (db) in
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            //逐行 - 便利结果集合
            while rs.next() {
                //1.列数
                let colCount = rs.columnCount()
                
                //2.便利所有列 
                for col in 0..<colCount {
                    //3.列名 -> KEY 值 -> Value
                    guard let name = rs.columnName(for: col) ,
                        let value = rs.object(forColumnIndex: col) else {
                            return
                    }
                    result.append([name:value as AnyObject])
                }
            }
        }
        return result
    }
    
}

// MARK: - 创建数据表，以及其他私有数据方法
private extension CZSQLiteManager {
    
    /// 创建数据表
    func createTable() -> () {
        
        //1. SQL

        guard let path = Bundle.main.path(forResource: "stauts.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path)
            else {
                return
        }
        
        print(sql)
        
        
        //2.执行 SQL - FMDB 的内部队列是串行队列，同步执行
        //数据库的本质就是 二进制文件 ，如果同时有多个任务对数据库进行读写操作，会造成混乱! 
        //所以 FMDB 的内部是串行队列，同步执行的
        //可以保证 同一时间，只有一个任务操作数据库，从而保证数据库的读写操作安全!
        queue.inDatabase { (db) in
            //只有在创表的时候，使用执行多条语句，可以一次创建多个数据表
            //在执行增删改的时候，一定不要使用 executeStatements 方法,否则有可能会被注入!
            if db?.executeStatements(sql) == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
        
        print("over")
    }
    
    
    
    
    
}

