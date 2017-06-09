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
    var access_token:String?
    /// 用户代号
    var uid:String?
    /// 过期日期，单位 秒  （开发者 过期时间  5年 ，正常使用着  是 3 天）
    var expires_in:TimeInterval = 0
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
    
    
    
    
    
    
    
}
