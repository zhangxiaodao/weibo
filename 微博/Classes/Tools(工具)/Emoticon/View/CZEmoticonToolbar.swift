//
//  CZEmoticonToolbar.swift
//  001-表情键盘
//
//  Created by 杭州阿尔法特 on 2017/8/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

@objc protocol CZEmoticonToolbarDelegate:NSObjectProtocol {
    /// 表情工具栏选中项索引
    ///
    /// - Parameters:
    ///   - toolBar: 工具栏
    ///   - index: 索引
    func emoticonToolbarDidSelectedItemIndex(toolBar:CZEmoticonToolbar , index:Int)
}

class CZEmoticonToolbar: UIView {

    weak var delegate:CZEmoticonToolbarDelegate?
    
    var selectedIndex:Int = 0{
        didSet {
            //1.取消所有按钮的选中状态
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            
            //2.设置 index 对应的选中状态
            (subviews[selectedIndex] as? UIButton)?.isSelected = true
        }
    }
    
    
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
    
    @objc fileprivate func clickItem(button:UIButton) {
        //通知代理执行协议方法
    delegate?.emoticonToolbarDidSelectedItemIndex(toolBar: self, index: button.tag)
    }
    
}

fileprivate extension CZEmoticonToolbar {
    func setupUI() -> () {
        
        //0.获取表情管理器单利
        let manager = CZEmoticonManager.shared
        
        //从表情包的分组名称 -> 设置按钮
        for (i , p) in manager.packages.enumerated() {
            //1>实例化按钮
            let btn = UIButton()
            btn.tag = i
            
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
            
            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)
            
        }
        
        (subviews[0] as! UIButton).isSelected = true
        
        
    }
}
