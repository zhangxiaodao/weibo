//
//  WBComposeTypeView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/27.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeTypeView: UIView {
    /// 类方法
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        //XIB 加载 默认是 600*600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    /// 显示当前视图
    func show() -> () {
        //1.将当前视图添加到 根视图控制器 的 view
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        //2.添加视图
        vc.view.addSubview(self)
        
    }
}
