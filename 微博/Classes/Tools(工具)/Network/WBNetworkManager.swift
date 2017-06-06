//
//  WBNetworkManager.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/5.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import AFNetworking  //导入文件夹的名字

// Swift 的枚举支持任意数据类型
// switch / enum 在 OC中只支持整数类型
enum WBHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    //单利   static  静态区/常量
    //在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared = WBNetworkManager()
    
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调 [json(字典，数组) ， 是否成功]
    func request(method: WBHTTPMethod = .GET , URLString:String , parameters:[String:AnyObject]? , completion:@escaping ( _ json:Any?,_ isSuccess:Bool)->()) -> () {
        
        //成功回调
        let success:((URLSessionDataTask,Any?)-> Void) = { (task,json) in
            completion(json, true)
        }
        
        //失败回调
        let failure:((URLSessionDataTask? , Error)->Void) = { (task,error) in
            print("网络请求错误\(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success , failure: failure)
        }
        
        
        
    }
    
}
