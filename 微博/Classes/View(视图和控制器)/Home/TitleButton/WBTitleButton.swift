//
//  WBTitleButton.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/13.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    
    /// 重载构造函数
    ///
    /// - Parameter title: 如果为 nil,就显示'首页'
    /// 如果不为 nil ，显示 title 和 箭头
    init(title:String?) {
        super.init(frame: CGRect())
        
        //1.判断 title 是否为 nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
            setTitle(title! + " ", for: [])
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        //2. 设置字体和颜色
        //UIFont.systemFont(ofSize: <#T##CGFloat#>) 只是设置字体的大小
        //UIFont.boldSystemFont(ofSize: 17) 设置大小的同时，可以让字体变粗一点
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        //3.设置大小
        sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图 -> 一定要 super
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel ,
            let imageView = imageView
            else {
                return
        }
        //将 label 的 x 向左移动 iamgeView 的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        //将 imageView 的 x 方向向右移动 label 的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        
        
    }
    
    

}
