//
//  WBStatusListDAL.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/8/11.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

/// DAL - Data Access Layer 数据访问层
/// 使命:负责处理数据库和网络数据，给 ListViewModel 返回微博的[字典数组]
/// 在调整系统的时候，尽量做最小化的调整!
class WBStatusListDAL {
    
    class func loadStatus(since_id:Int64 = 0 , max_id:Int64 = 0 , completion:@escaping (_ list:[[String:AnyObject]]? , _ isSuccess:Bool)->()) -> () {
        
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        //1.检查本地数据，如果有直接返回
        let array = CZSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        //判断数组的数量，没有数量返回的是没有数据的空数组 []
        if array.count > 0 {
            completion(array, true)
            
            return
        }
        
        //2.加载网络数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            //1.判断网络请求是否成功
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            //判断数据
            guard let list = list else {
                completion(nil, false)
                
                return
            }
            
            //3.加载完成之后。将网络数据[字典数组]，写入数据库
            CZSQLiteManager.shared.updateStatus(userId: userId, array: list)
            
            //4.返回网络数据
            completion(list, isSuccess)
        }
        
    }
    
    
    
}
