//
//  WBNavigationViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {

    //重写 push 方法，所有的 push 动作都会调用此方法!
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //如果不是栈底控制器才需要隐藏，跟控制器不需要处理
        if childViewControllers.count>0 {
            //隐藏底部的 tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
    }
}
