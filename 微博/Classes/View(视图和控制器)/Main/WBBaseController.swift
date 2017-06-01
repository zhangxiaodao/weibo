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
    var tableView:UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadData()
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
        
    }

}

extension WBBaseController {
    func setupUI() -> () {
        view.backgroundColor = UIColor.cz_random()
        
        //当出现 tableView 和 nav 的UI 时，需要考虑缩进的问题
        //取消缩进 -> 如果取消了缩进，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setUpNav()
        setUpTableView()
    }
    
    /// 设置表歌视图
    private func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源 & 代理 -> 子类直接实行数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, (tabBarController?.tabBar.bounds.height)!, 0)
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
}
