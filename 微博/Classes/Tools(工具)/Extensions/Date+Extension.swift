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
    
    /// 将新浪格式的字符串转换成日期
    ///
    /// - Parameter string: Tue Sep 15 12:12:00 +0000 2015
    /// - Returns: 日期
    static func cz_sinaDate(string:String) -> Date? {
        //1.设置日期格式
        dateFormatter.dateFormat = "EEE MM dd HH:mm:ss zzz yyyy"
        
        //2.转换并且返回日期
        return dateFormatter.date(from:string)
        
    }
    
    
}
