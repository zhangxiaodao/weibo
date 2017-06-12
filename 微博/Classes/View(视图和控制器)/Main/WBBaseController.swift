//
//  WBBaseController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 面试题： OC 中支持多继承么？ 如果不支持，如何替代？ 答案：使用协议设置替代
/// Swift 的 协议写法 ，类似于多继承！
//class WBBaseController: UIViewController , UITableViewDelegate ,UITableViewDataSource {
// Swift 中，可以使用 extension 把 ‘函数’ 按照功能分类管理，便于阅读和维护
//1. extension 不能写属性
//2. extension 不能重写父类方法!重写弗雷的方法，是子类的职责，扩展是对类的扩展

class WBBaseController: UIViewController {
    
    //访客试图信息字典
    var visitorInfoDict:[String:String]?
    
    
    //表格视图 - 如果用户没有登录，就不创建
    var tableView:UITableView?
    //刷新控件
    var refreshControl:UIRefreshControl?
    //上拉刷新标记
    var isPullUp = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()

        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNottification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    /// 自定义导航条的Item - 以后设置导航栏，同意使用 navItem
    lazy var navItem = UINavigationItem()
    
    /// 重写 title 的 didSet
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体实现，由子类负责
    func loadData() -> () {
        //如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }

}

// MARK: - 访客视图监听事件
extension WBBaseController {
    
    /// 登陆成功处理
    @objc fileprivate func loginSuccess(n:Notification) -> () {
        print("登陆成功\(n)")
        
        //更新 UI -> 将访客视图 更改为 表格视图
        //在访问 view 的 getter 方法时，如果 view == nil ，会调用 loadView ，然后调用 viewDidLoad (代码中没有重写 loadView ，重写了 viewDidLoad,所以 设置 view = nil,会重新加载 viewDidLoad)
        view = nil
        
        //注销通知 -> 重新执行 viewDidLoad 会再次注册! 避免通知重复注册
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func login() {        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc func register() {
        print("用户注册")
    }
}

extension WBBaseController {
    fileprivate func setupUI() -> () {
        view.backgroundColor = UIColor.white
        
        //当出现 tableView 和 nav 的UI 时，需要考虑缩进的问题
        //取消缩进 -> 如果取消了缩进，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setUpNav()
        setUpTableView()
        
        WBNetworkManager.shared.userLogon ? setUpTableView() : setupVisitorView()
    }
    
    /// 设置表歌视图
    func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源 & 代理 -> 子类直接实行数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: (tabBarController?.tabBar.bounds.height)!, right: 0)
        
        //设置刷新控件
        refreshControl = UIRefreshControl()
        
        //添加到视图
        tableView?.addSubview(refreshControl!)
        
        //添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    func setupVisitorView() -> () {
        let visitorView = WBVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        //设置访客视图的信息
        visitorView.visitorInfo = visitorInfoDict
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        //3.设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    private func setUpNav() {
        //添加导航条
        view.addSubview(navigationBar)
        //将 item 设置给 bar
        navigationBar.items = [navItem]
        //设置 navBar 的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xf6f6f6)
        //设置 navBar 的字体颜色
        //        navigationBar.tintColor = UIColor.darkGray
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
}

//MARK: - UITableViewDelegate , UITableViewDataSource
extension WBBaseController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类只是准备方法，子类负责具体的实现
    //子类的数据源方法，不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 基类的返回只是保证 没有语法的错误
        return UITableViewCell()
    }
    
    ///在最后一行的时候做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1.判断 indexPath 是否是最后一行 (indexPath.section / indexPath.row)
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        //行数
        let count = tableView.numberOfRows(inSection: section)
        
        //如果是最后一行，同时没有上拉刷新 -> 开始上拉刷新
        if row == (count - 1) && !isPullUp{
            print("上拉刷新")
            isPullUp = true
            //开始刷新
            loadData()
        }
        
        
    }
}
