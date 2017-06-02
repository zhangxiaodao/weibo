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
    
    /**
        portrait : 竖屏 , 肖像
        landscape : 横屏 , 风景画
     
        - 使用代码控制设备的方向，好处，可以再需要横屏的时候，单独处理
        - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向！
        - 如果播放视频，通常是通过 modal 展现的!
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    //MARK: - 监听方法
    /// 撰写微博
    //FIXME:没有实现
    //peivate 能保证方法私有，仅在当前对象被访问
    //@objc 允许这个函数在运行时通过 OC 的消息机制被调用
    func composeStatus() -> () {
        print("撰写微博")
    }
    
    //MARK: - 私有控件
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
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
    /// 设置所有子控制器
     func setupChildControllers() {
        let array = [
            ["clsName":"WBHomeViewController" , "title":"首页" , "imageName":"home" , "visitorInfo":["imageNmae":"" , "message":"关注一些人，回着里看看有什么惊喜"]],
            ["clsName":"WBMessageViewController" , "title":"消息" , "imageName":"message_center" , "visitorInfo":["imageNmae":"visitordiscover_image_profile" , "message":"登陆后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
            ["clsName":"ViewController"],
            ["clsName":"WBDiscoverViewController" , "title":"发现" , "imageName":"discover" , "visitorInfo":["imageNmae":"visitordiscover_image_message" , "message":"登陆后，最新鲜、最热的微博尽在掌握，不再会与事实潮流擦肩而过"]],
            ["clsName":"WBProfileViewController" , "title":"我的" , "imageName":"profile" , "visitorInfo":["imageNmae":"visitordiscover_image_profile" , "message":"登陆后，你的微博、相册、个人资料都会在这里显示，展示给别人"]],
        ]
        
        ///测试数据格式是否正确 -> 转换成plist 数据更加直观
//        (array as NSArray).write(toFile: "/Users/hangzhouaerfate/Desktop/demo.plist", atomically: true)
        
        var arrayM = [UIViewController]()
        
        for dict in array {
            arrayM.append(controller(dict: dict as [String : AnyObject]))
        }
        
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典 [clsName , title , imageName]
    /// - Returns: 子控制器
    private func controller(dict:[String:AnyObject]) -> UIViewController {
        //1.取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + (clsName)) as? UIViewController.Type
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
        
        //实例化导航控制器的时候，会调用 push 方法，将 rootVC 压栈
        let nav = WBNavigationViewController(rootViewController: vc)
        return nav
    }
}


