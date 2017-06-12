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
    /// - since_id: 返回ID比since_id 大的微博（即比since_id时间晚的微博），默认为0
    /// - max_id: 返回ID小于或者等于max_id的微博，默认为0
    /// - Parameter completion: 完成回调 [list: 微博字典数组 , isSuccess : 是否成功]
    func statusList(since_id:Int64 = 0 , max_id:Int64 = 0 , completion:@escaping (_ list:[[String:AnyObject]]? , _ isSuccess:Bool)->()) -> () {
        //用 网络工具 加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        // Swift 中 Int 可以转换成 AnyObject / 但是 Int64 不行
        let parames = ["since_id":"\(since_id)" , "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        
        tokenRequest(URLString: urlString, parameters: parames as [String : AnyObject]) { (json, isSuccess) in
            
           let data = json as AnyObject
            
            //从 json 中获取到 statuses 字典数据
            //如果 as? 失败， result = nil
            let result = data["statuses"] as? [[String : AnyObject]]
            completion(result, isSuccess)
        }
    }
    
    /// 返回 微博 的未读数量
    func unreadCount(completion:@escaping (_ count: Int)->()) -> () {
        
        guard let uid = userAccount.uid else { return  }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let parames = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: parames as [String : AnyObject]) { (json, isSuccess) in
            print(json ?? "未获得数据")
            let dict = json as? [String:AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
}

extension WBNetworkManager {
    
    /// 加载token
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调[是否成功]
    func loadAccesstoken(code:String , completion: @escaping (_ isSuccess:Bool)->()) -> () {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parames = ["client_id" : WBAppKey , "client_secret" : WBAppSecret , "grant_type" : "authorization_code" , "code" : code , "redirect_uri" : WBRedirectURL]
        request(method: .POST, URLString: urlString, parameters: parames as [String : AnyObject]) { (json, isSuccess) in
            print(json ?? "未获得数据")
            
            //如果请求失败，对用户账户数据不会有任何影响
            //直接用字典设置 userAAccount 的属性
            self.userAccount.yy_modelSet(with: json as? [String:AnyObject] ?? [:])
            print(self.userAccount)
            //保存模型
            self.userAccount.saveAccount()
            //完成回调
            completion(isSuccess)
        }
    }
    
    
    
    
    
    
}


