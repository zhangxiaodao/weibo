//
//  WBNavigationViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
    
    //重写 push 方法，所有的 push 动作都会调用此方法!
    //viewController 是被 push 的控制器，设置它的左侧为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //如果不是栈底控制器才需要隐藏，跟控制器不需要处理
        if childViewControllers.count>0 {
            //隐藏底部的 tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型
            if let vc = viewController as? WBBaseController {
                
                var title = "返回"
                
                //判断控制器的级数，只有一个自控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    //title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                //取出自定义的 navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent) , isback:true)
            }
        }
        
        
        
        super.pushViewController(viewController, animated: true)
    }
    
    func popToParent() -> () {
        popViewController(animated: true)
    }
}
