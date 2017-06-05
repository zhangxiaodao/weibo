//
//  AppDelegate.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }
}

// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    func loadAppInfo() {
        //1. 模拟异步
        DispatchQueue.global().async {
            //1>url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            //2> data
            let data = NSData(contentsOf: url!)
            //3>写入沙盒
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
            print("应用程序加载完成\(jsonPath)")
        }
    }
}


