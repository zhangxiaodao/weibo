//
//  Date+Extension.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/8/14.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()

extension Date {
    
    /// 计算与当前系统时间偏差 delta 秒数的日期字符串
    static func cz_dateString(delte:TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow:delte)
        
        //指定字符串格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}
