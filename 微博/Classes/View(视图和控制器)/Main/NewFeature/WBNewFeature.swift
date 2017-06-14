//
//  WBNewFeature.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/13.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 新特性视图
class WBNewFeature: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //进入微博
    @IBAction func enterStatus() {
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
