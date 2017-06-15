//
//  WBStatustViewModel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

class WBStatustViewModel {
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
    
}

