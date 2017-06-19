//
//  WBStatusPictureView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/16.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
}

extension WBStatusPictureView {
    //1. Cell 中所有的控件 都是提前准备好
    //2. 设置的时候，根据数据决定是否显示
    //3.不要动态创建控件
    fileprivate func setupUI() {
        //clipsToBounds 超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        //循环创建 9 个 iamgeView
        for i in 0..<count * count {
            let iv = UIImageView()
            iv.backgroundColor = UIColor.orange
            
            //行 -> Y
            let row = CGFloat(i / count)
            //列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewOutterMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
            
            print(row)
        }
        
    }
}
