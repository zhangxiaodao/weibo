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
    
    
    
    
    
    
    
    
    
    
}
