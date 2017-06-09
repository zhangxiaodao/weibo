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
    
    /// 访问令牌，所有网络请求，都基于此令牌（登陆除外）
    //为了保护用户安全，token 是有事限的，默认是三天
    var accessToken:String? //= "2.00Al89qG2psegC60040b050eeBTPWD"
    ///用户的微博 id
    var uid:String? = "5365823342"
    
    /// 用户登录标记 [计算型属性]
    var userLogon:Bool {
        return accessToken != nil
    }
    
    
    /// 专门负责拼接 token 的网络请求的方法
    func tokenRequest(method: WBHTTPMethod = .GET , URLString:String , parameters:[String:AnyObject]? , completion:@escaping ( _ json:Any?,_ isSuccess:Bool)->()) -> () {
        
        //处理 token 字典
        //0> 判断 token 是否为 nil ,为 nil 直接返回
        guard let token = accessToken else {
            
            //FIXM:发送通知（本方法不知道被谁调用，提示用户登录）
            print("没有 token! 请登录")
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
