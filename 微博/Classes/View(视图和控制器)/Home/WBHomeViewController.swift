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
        for i in 0..<15 {
            //将数据插入到数组的顶部
            statusList.insert(i.description, at: 0)
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
    override func setupUI() {
        super.setupUI()
        
        //测试导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        //注册原型 cell 
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
