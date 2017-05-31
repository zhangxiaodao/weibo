//
//  WBDemoViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/31.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    //MARK: - 监听方法
    //继续 push 一个新的控制器
    func showNex() -> () {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension WBDemoViewController {
    
    /// 重写父类方法
    override func setupUI() {
        super.setupUI()
        //设置右侧的控制器
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNex))
    }
}
