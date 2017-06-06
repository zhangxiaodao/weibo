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

    //微博数据数组
    lazy var statusList = [String]()
    
    override func loadData() {
        
        //用 网络工具 加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parames:[String:AnyObject] = ["access_token":"2.00Al89qG2psegC2c9998b281RfNnNB" as AnyObject]

        WBNetworkManager.shared.request(URLString: urlString, parameters: parames) { (json, isSuccess) in
            print(json ?? "未获得数据")
        }
        
        
        print("开始加载数据")
        
        //模拟 ‘延时’ 建在数据 -> dispatch_after
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            for i in 0..<20 {
                
                if self.isPullUp {
                    //将数据追加到底部
                    self.statusList.append("上拉 \(i)")
                } else {
                    //将数据插入到数组的顶部
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            print("刷新表格")
            
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            
            //恢复上拉刷新标志
            self.isPullUp = false
            //刷新表格
            self.tableView?.reloadData()
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
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. 取 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //2. 设置 cell
        cell.textLabel?.text = statusList[indexPath.row]
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
}
