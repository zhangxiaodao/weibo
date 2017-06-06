//
//  WBStatusListViewModel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/6.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

/// 封装微博数据列表视图模型

/**
    父类的选择
    - 如果类需要使用 ‘KVC‘ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
    - 如果类知识包装一些代码逻辑（写一些函数），就可以不用任何父类，好处：更加轻量级
    - 提示：如果用 OC 写，一律继承自 NSObject即可
 
 使命：负责微博的数据处理
 1.字典转模型
 2.下拉、上拉刷新数据处理
 */
class WBStatusListViewModel {
    /// 微博模型懒加载
    lazy var statusList = [WBStatus]()
    
    /// 加载微博列表
    ///
    /// - Parameter completion: 完成回调（网络请求是否成功）
    func loadStatus(completion:@escaping (_ isSuccess:Bool)->()) -> () {
        WBNetworkManager.shared.statusList { (json, isSuccess) in
            //1.字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: json ?? []) as? [WBStatus] else {
                completion(isSuccess)
                return
            }
            //2.拼接数据
            self.statusList += array
            
            //3.完成回调
            completion(isSuccess)
            
        }
    }
    
    
    
}
