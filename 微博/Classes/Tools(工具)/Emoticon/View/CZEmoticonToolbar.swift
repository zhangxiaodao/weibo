//
//  CZEmoticonToolbar.swift
//  001-表情键盘
//
//  Created by 杭州阿尔法特 on 2017/8/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class CZEmoticonToolbar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = self.subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i , btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
        
        
        
        
    }
    
}

fileprivate extension CZEmoticonToolbar {
    func setupUI() -> () {
        
        //0.获取表情管理器单利
        let manager = CZEmoticonManager.shared
        
        //从表情包的分组名称 -> 设置按钮
        for p in manager.packages {
            //1>实例化按钮
            let btn = UIButton()
            
            //2>设置按钮属性
            btn.setTitle(p.groupName, for: [])
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.setTitleColor(UIColor.white, for: [])
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            //设置按钮的图片
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            //拉伸图像
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsetsMake(
                size.height * 0.5,
                size.width * 0.5,
                size.height * 0.5,
                size.width * 0.5)
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            
            btn.setBackgroundImage(image, for: [])
            btn.setBackgroundImage(imageHL, for: .selected)
            btn.setBackgroundImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            addSubview(btn)
            
        }
        
        
        
        
    }
}
