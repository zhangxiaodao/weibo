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
        setupComposeButton()
    }
    //MARK - 私有控件
    /// 撰写按钮
    lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}

//extension 了类似于 OC 中的 分类，在 Swift 中还可以用来切分代码块
//可以把相近功能的函数，放在一个 extension 中
//便于维护代码
//注意：和 OC 中的分类一样，extension 不能定义属性
extension WBMainViewController {
    
    func setupComposeButton() -> () {
        tabBar.addSubview(composeButton)
        
        //计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count - 1
        //CGRectInset 正数向内缩进 负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        
    }
    
    /// 设置所有子控制器
     func setupChildControllers() {
        let array = [
            ["clsName":"WBHomeViewController" , "title":"首页" , "imageName":"home"],
            ["clsName":"WBMessageViewController" , "title":"消息" , "imageName":"message_center"],
            ["clsName":"ViewController"],
            ["clsName":"WBDiscoverViewController" , "title":"发现" , "imageName":"discover"],
            ["clsName":"WBProfileViewController" , "title":"我的" , "imageName":"profile"],
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
        
        //3.设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        //4.设置 tabbar 的标题颜色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .highlighted)
        //设置字体大小
        //系统默认的是 12 号字体，修改字体大小，要设置 Normal 的字体大小（设置为 .highlighted 无效）
//        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 24)], for: UIControlState(rawValue:0))
        
        let nav = WBNavigationViewController(rootViewController: vc)
        return nav
    }
}


