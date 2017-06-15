//
//  WBUser.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 微博用户模型
class WBUser: NSObject {
    
    //基本数据类型 & private 不能使用 KVC 设置
    var id:Int64 = 0
    //用户昵称
    var screen_name:String?
    //用户头像地址（中国）50 * 50 像素
    var profile_image_url:String?
    //认证类型,-1 没有认证， 0 认证用户， 2，3，5：企业认证， 220 ：达人
    var verified_type:Int = 0
    //会员等级 0-6
    var mbrank:Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
