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
    
    class func newFeature() -> WBNewFeature {
        let nib = UINib(nibName: "WBNewFeature", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil).first as! WBNewFeature
        
        //从 xib 加载的视图，默认是 600 * 600
        v.frame = UIScreen.main.bounds
        return v
        
    }
    
    override func awakeFromNib() {
        //如果使用自动布局设置的界面 ， 从 XIB 加载默认是 600 * 600
        //添加 4 个 图像视图
        let count = 4
        
        let rect = UIScreen.main.bounds
        for i in 0..<4 {
            let imageName = "new_feature_\(i + 1)"
            let image = UIImageView(image: UIImage(named: imageName))
            //设置大小
            image.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(image)
        }
        //指定 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        //隐藏按钮
        enterButton.isHidden = true
    }
    
}
