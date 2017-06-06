//
//  WBStatus.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/6.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class WBStatus: NSObject {
    
    /// Int 类型，在 64 位的机器是 64 位，在 32 位的机器上是 32 位
    /// 如果不写 Int64 ，在ipad 2/iPhone 5/ 5c /4s /4 都无法正常运行
    var id:Int64 = 0
    /// 微博信息内容
    var text:String?
    
    
    /// 重写 description 的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
    
}
