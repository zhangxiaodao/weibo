//
//  CZRefreshView.swift
//  刷新控件
//
//  Created by 杭州阿尔法特 on 2017/6/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 刷新视图 - 负责刷新相关的 UI 显示和动画
class CZRefreshView: UIView {
    /// 刷新状态
    /**
     iOS 系统中 UIView 凤凰脏的旋转动画
     - 默认顺时针旋转
     - 就近原则
     - 要想实现同方向旋转，需要调整一个非常小的数字，比如：(.pi - 0.001)
     - 如果需要实现 360 旋转，需要核心动画 CABaseAnimation
     */
    var refreshState:CZRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                
                tipIcon.isHidden = false
                indicator.stopAnimating()
                
                tiplabel.text = "继续使劲拉..."
                // .identity 恢复到默认状态
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tiplabel.text = "放手就刷新..."
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: .pi - 0.001)
                })
            case .WillRefresh:
                tiplabel.text = "正在刷新中..."
                //隐藏提示图标
                tipIcon.isHidden = true
                //显示菊花
                indicator.startAnimating()
            }
        }
    }
    
    
    /// 提示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    /// 提示图标
    @IBOutlet weak var tiplabel: UILabel!
    /// 提示标签
    @IBOutlet weak var tipIcon: UIImageView!

    class func refreshView() -> CZRefreshView {
        let nib = UINib(nibName: "CZRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).last as! CZRefreshView
        
    }
}
