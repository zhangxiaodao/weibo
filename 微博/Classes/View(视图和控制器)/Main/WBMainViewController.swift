//
//  WBMainViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import SVProgressHUD


class WBMainViewController: UITabBarController {

    //定时器
    fileprivate var timr:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        setupComposeButton()
        setupTimr()
        
        setupNewFeatureView()
        
        //设置代理
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        //销毁时钟
        timr?.invalidate()
        //注销通知
        NotificationCenter.default.removeObserver(self)
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
    
    @objc fileprivate func userLogin(n:Notification) -> () {
        print("发送通知\(n)")
        
        //判断 n.object 是否有值，如果有值，提示用户重新登录
        if n.object != nil {
            //设置 指示器渐变样式
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            
            //修改延迟时间
            
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
            //展现登陆控制器 - 通常会和 UINaigationController 连用，方便返回
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //MARK: - 监听方法
    /// 撰写微博
    func composeStatus() -> () {
        print("撰写微博")
        
        // 0>判断是否登录
        
        // 1>实例化视图
        let v = WBComposeTypeView.composeTypeView()
        // 2>显示控件
        v.show()
    }
    
    //MARK: - 私有控件
    /// 撰写按钮
    lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}

// MARK: - 新特性视图
extension WBMainViewController {
    /// 设置新特性视图
    fileprivate func setupNewFeatureView() -> () {
        
        //0.判断是否登录
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //1.如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewFeature.newFeature() : WBWelcome.welcome()
        
        //2.添加视图
        view.addSubview(v)
        
    }
    
    /// extension 中可以有计算型属性，不会占用存储空间
    /// 构造函数：给属性分配空间
    /**
        版本号
        - 在AppStore 每次升级程序，版本号都需要增加，不能递减
     
        - 组成 主版本号.次版本号.修订版本号
        - 主版本号:意味着大的修改，使用者也需要做大的适应
        - 次版本号：意味着小的修改，某些函数和方法的使用或者参数有变化
        - 修订版本号：框架/程序内部 bug 的修改，不会对使用者造成任何影响
     */
    
    private var isNewVersion:Bool {
        //1.去当前的版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("当前版本\(currentVersion)")

        //2.取保存在 'document' 目录中的之前的版本号
        let path:String = ("version" as NSString).cz_appendDocumentDir()
        //从路径中取出文件
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        print("沙盒版本\(sandboxVersion)")
        //3.将当前版本号保存在沙盒
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        //4.返回两个版本是否一致
        return currentVersion != sandboxVersion
//        return currentVersion == sandboxVersion
        
    }
    
}

// MARK: - UITabBarControllerDelegate
extension WBMainViewController: UITabBarControllerDelegate {
    
    /// 将要选择 TabbarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到\(viewController)")
        
        //判断目标控制器 是否是 UIViewController 
        
        
        //1>获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        
        //2>判断当前控制器是首页，同时 idx 也是首页 ，重复点击首页按钮
        if selectedIndex == 0 && idx == selectedIndex {
            print("点击首页")
            
            //3> 让表格滚动到顶部
            //a)获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            //b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            //4>刷新数据 - 增加延迟，是保证表格线滚动到顶部再刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                vc.loadData()
            })
            //5.清楚 tabbarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        
        
        
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟相关方法
extension WBMainViewController {
    //定义时钟
    fileprivate func setupTimr() -> () {
        timr = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimr), userInfo: nil, repeats: true)
    }
    
    //时钟触发方法
    @objc private func updateTimr() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            //设置 首页 tabBarItem 的badge
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            print("检测到\(count)条新微博")
            //设置 App 的 badgeNumber , 从 ios8.0之后，需要用户授权才可以显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
        
    }
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
        
        //0 获取沙盒 json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        //加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        //判断 data 是否为空
        if data == nil {
            //从 Bunle 加载 data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        
        //从 bundle 加载配置的 json
        //反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:AnyObject]]
            else {
                return
        }
        //遍历数组 循环创建控制器数组
        var arrayM = [UIViewController]()
        
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        //设置 tabbar 的子控制器
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
            let cls = NSClassFromString(Bundle.main.namespace + "." + (clsName)) as? WBBaseController.Type,
        let visitorInfo = dict["visitorInfo"] as? [String:String]
        
        else {
            return UIViewController()
        }
        
        //2.创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        //设置控制器的访客信息字典
        vc.visitorInfoDict = visitorInfo
        
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


