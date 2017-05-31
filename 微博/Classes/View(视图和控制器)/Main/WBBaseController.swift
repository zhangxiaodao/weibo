//
//  WBBaseController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBBaseController: UIViewController {

    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    /// 自定义导航条的Item
    lazy var navItem = UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    /// 重写 title 的 didSet
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }

}

extension WBBaseController {
    func setupUI() -> () {
        view.backgroundColor = UIColor.cz_random()
        
        //添加导航条
        view.addSubview(navigationBar)
        //将 item 设置给 bar
        navigationBar.items = [navItem]
    }
}
