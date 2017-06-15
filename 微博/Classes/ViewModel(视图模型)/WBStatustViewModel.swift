//
//  WBStatustViewModel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation
/**
 如果没有任何父类，如果希望开发时调试，输出调试信息，需要
 1. 遵循 CustomStringConvertible协议
 2. 实现 description 计算型属性
 */
class WBStatustViewModel:CustomStringConvertible {
    /// 微博模型
    var status:WBStatus
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    ///
    /// - returns: 微博的视图模型
    init(model:WBStatus) {
        self.status = model
    }
    
    var description: String {
        return status.description
    }
    
}

