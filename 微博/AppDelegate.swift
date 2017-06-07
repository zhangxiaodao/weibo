//
//  AppDelegate.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //取得用户授权显示通知[上方的提示条/声音/badgeNumber]
        //  #available 是检测版本， 如果是 10.0 以上 取得用户授权
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .carPlay , .sound]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            
            let notifySettings = UIUserNotificationSettings(types: [.alert , .badge , .sound], categories: nil)
            application.registerUserNotificationSettings(notifySettings)

        }
        
        
        
        
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
            //3>写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            //直接保存到沙盒，等待下一次程序启动使用!
            data?.write(toFile: jsonPath, atomically: true)
            print("应用程序加载完成\(jsonPath)")
        }
    }
}


