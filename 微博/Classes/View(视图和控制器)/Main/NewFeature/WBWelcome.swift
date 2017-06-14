//
//  WBWelcome.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/13.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 欢迎试图
class WBWelcome: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcome() -> WBWelcome {
        let nib = UINib(nibName: "WBWelcome", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcome
        v.frame = UIScreen.main.bounds
        return v
    }
    
}

// MARK: - 加载动画的方法
extension WBWelcome {
    //自动布局系统更新完成约束后，会自动调用此方法
    //通常是对子视图布局进行修改
//    override func layoutSubviews() {
//        
//    }

    //试图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
      super.didMoveToWindow()
        
        //视图是使用自动布局来设置的，只是设置约束
        //当视图被添加到窗口上时(调用 didMoveToWindow 刚添加到窗口上)，根据父视图的大小，计算约束，更新控件位置
        // - layoutIfNeeded 会直接按照当前约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 XIB 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        //如果控件们的 frame 还没有更新好！所有的约束会一起动画
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //更新约束
            self.layoutIfNeeded()
        }) { (_) in
            self.tipLabel.alpha = 1
        }
        
        
    }
    
    
    
    
}
