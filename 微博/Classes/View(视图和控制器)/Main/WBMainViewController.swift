//
//  WBMainViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
    }

}

//extension 了类似于 OC 中的 分类，在 Swift 中还可以用来切分代码块
//可以把相近功能的函数，放在一个 extension 中
//便于维护代码
//注意：和 OC 中的分类一样，extension 不能定义属性
extension WBMainViewController {
    
    /// 设置所有子控制器
     func setupChildControllers() {
        let array = [
            ["clsName":"WBHomeViewController" , "title":"首页" , "imageName":""],
            ["clsName":"WBMessageViewController" , "title":"消息" , "imageName":""],
            ["clsName":"WBDiscoverViewController" , "title":"发现" , "imageName":""],
            ["clsName":"WBProfileViewController" , "title":"我的" , "imageName":""],
        ]
        var arrayM = [UIViewController]()
        
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典 [clsName , title , imageName]
    /// - Returns: 子控制器
    private func controller(dict:[String:String]) -> UIViewController {
        //1.取得字典内容
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
        else {
            return UIViewController()
        }
        
        //2.创建视图控制器
        let vc = cls.init()
        vc.title = title
        let nav = WBNavigationViewController(rootViewController: vc)
        return nav
    }
}


