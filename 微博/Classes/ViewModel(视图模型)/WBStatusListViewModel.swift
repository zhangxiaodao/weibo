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
        
        //since_id 取出数组中第一条微博的 id
        let since_id = statusList.first?.id ?? 0
//        let max_id = statusList.last?.id ?? 0
        
        
        WBNetworkManager.shared.statusList(since_id:since_id , max_id: 0) { (json, isSuccess) in
            //1.字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: json ?? []) as? [WBStatus] else {
                completion(isSuccess)
                return
            }
            
            print("刷新了\(array.count)条数据")
            
            //2.拼接数据
            //下拉刷新，应该把结果拼接在数组前面
            self.statusList = array + self.statusList
//            self.statusList += array
            
            //3.完成回调
            completion(isSuccess)
            
        }
    }
    
    
    
}
