//
//  WBNetworkManager+Extension.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/6.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

// MARK: - 封装微博网络请求方法
extension WBNetworkManager{
    
    /// 加载微博数据字典数组
    ///
    /// - Parameter completion: 完成回调 [list: 微博字典数组 , isSuccess : 是否成功]
    func statusList(completion:@escaping (_ list:[[String:AnyObject]]? , _ isSuccess:Bool)->()) -> () {
        //用 网络工具 加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parames:[String:AnyObject] = ["access_token":"2.00Al89qG2psegC2c9998b281RfNnNB" as AnyObject]
        
        request(URLString: urlString, parameters: parames) { (json, isSuccess) in
            
           let data = json as AnyObject
            
            //从 json 中获取到 statuses 字典数据
            //如果 as? 失败， result = nil
            let result = data["statuses"]
            
            completion(result as? [[String : AnyObject]], isSuccess)
        }
    }
    
}
