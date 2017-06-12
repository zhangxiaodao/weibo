//
//  WBUserAccount.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/9.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 用户账户信息
class WBUserAccount: NSObject {
    var access_token:String? //= "2.00Al89qG2psegCf703339f019ZeHRD"
    /// 用户代号
    var uid:String?
    /// 过期日期，单位 秒  （开发者 过期时间  5年 ，正常使用着  是 3 天）
    //开发者5年，每次登录之后，都是五年
    //使用者 3 天，会从第一次登陆递减
    var expires_in:TimeInterval = 0 {
        didSet{
            expireData = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expireData:Date?
    
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    /**
     存储方式：
     1.偏好设置 (存储小的内容)
     2.存入沙盒 -> 
        2.1 使用归档存入沙盒
        2.2 使用 writeTo (writeTo 不能存储自定义类型的数据，需要先转化为 pilst 或 json 数据类型  在存储)
     3.数据库 (FMDB / CoreData)
     4.钥匙串访问 (存储小的内容 / 并且存入进去后，自动加密，OC没法使用代码直接写，只能使用框架 SSKeychain 存储)
     */
    
    /// 保存用户 token
    func saveAccount() -> () {
        //1.模型转字典
        var dict = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]
        //需要删除  expire_in 值
        dict.removeValue(forKey: "expires_in")
        
        //2.字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = ("useracount.json" as NSString).cz_appendDocumentDir()
            else { return  }
        
        //3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户保存成功\(filePath)")
        
    }
    
    
    
    
    
    
    
    
}
