//
//  WBNetworkManager.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/5.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import AFNetworking   //导入文件夹的名字

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    //单利   static  静态区/常量
    //在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared = WBNetworkManager()
    
}
