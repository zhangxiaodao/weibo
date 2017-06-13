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
    static let shared:WBNetworkManager = {
        //实例化对象
        let instance = WBNetworkManager()
        
        //设置响应的反序列化支持的数据类型
    instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        //返回对象
        return instance
    }()
    
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标记 [计算型属性]
    var userLogon:Bool {
        return userAccount.access_token != nil
    }
    
    
    /// 专门负责拼接 token 的网络请求的方法
    func tokenRequest(method: WBHTTPMethod = .GET , URLString:String , parameters:[String:AnyObject]? , completion:@escaping ( _ json:Any?,_ isSuccess:Bool)->()) -> () {
        
        //处理 token 字典
        //0> 判断 token 是否为 nil ,为 nil 直接返回 , 程序在执行过程中,token 一般不会为 nil
        guard let token = userAccount.access_token else {
            
            //FIXM: 发送通知（本方法不知道被谁调用，提示用户登录）
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            
            completion(nil, false)
            return
        }
        
        //1> 判断参数字典是否存在 , 如果为 nil ，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            //实例化字典
            parameters = [String:AnyObject]()
        }
        
        //2> 设置参数字典 ，代码在此处，一定有值
        parameters!["access_token"] = token as AnyObject
        
        //调用  request 发起真正网络请求方法
        request(URLString: URLString, parameters: parameters, completion: completion)
    }
    
    
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
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                
                //FIXM:发送通知（本方法不知道被谁调用，谁收到通知，谁处理）
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object:"bad token")
            }
            
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
