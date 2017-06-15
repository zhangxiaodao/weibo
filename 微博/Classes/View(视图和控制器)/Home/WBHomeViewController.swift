//
//  WBHomeViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

//定义全局常量，尽量使用 private 修饰，否则到处都可以使用
private let cellId = "cellId"

class WBHomeViewController: WBBaseController {

    /// 列表视图模型
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func loadData() {
        
        print("加载数据结束 \(String(describing: listViewModel.statusList.last?.text))")
        listViewModel.loadStatus(pullup: self.isPullUp) { (isSuccess , shouldRefresh) in
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉刷新标志
            self.isPullUp = false
            
            if shouldRefresh {
                //刷新表格
                self.tableView?.reloadData()

            }
        }
    }
     
    //现实好友
    func showFriends() -> () {
        print(#function)
        
        let vc = WBDemoViewController()
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
//MARK: - 表格数据源方法
extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. 取 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        
        //2. 设置 cell
        cell.statusLabel?.text = listViewModel.statusList[indexPath.row].text
        //3. 返回 cell
        return cell
    }
}

extension WBHomeViewController {
    //重写父类的方法
    
    override func setUpTableView() {
        super.setUpTableView()
        //测试导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        //注册原型 cell
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: cellId)
        //设置行高
        tableView?.rowHeight = UITableViewAutomaticDimension
        //预估行高
        tableView?.estimatedRowHeight = 300
        //取消分割线
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    fileprivate func setupNavTitle() -> () {
        
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc fileprivate func clickBtn(btn:UIButton) -> () {
        //设置选中状态
        btn.isSelected = !btn.isSelected
    }
    
}
