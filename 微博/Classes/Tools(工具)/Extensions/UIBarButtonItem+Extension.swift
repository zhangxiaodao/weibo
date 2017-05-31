//
//  UIBarButtonItem+Extension.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/31.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize 默认16号
    ///   - target: target
    ///   - action: action
    convenience init(title:String , fontSize:CGFloat = 16 , target:AnyObject? , action:Selector){
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        //实例化  UIBarButtonItem
        self.init(customView: btn)
    }
}
