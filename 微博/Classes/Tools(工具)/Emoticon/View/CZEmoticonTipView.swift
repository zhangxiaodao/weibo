//
//  CZEmoticonTipView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/8/14.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import pop
class CZEmoticonTipView: UIImageView {

    /// 之前选择的表情
    private var preEmotion:CZEmoticion?
    
    /// 提示视图的表情模型
    var emoticon:CZEmoticion? {
        didSet {
            /// 判断表情是否有变化
            if emoticon == preEmotion {
                return
            }
            //记录当前表情
            preEmotion = emoticon
            
            //设置数据
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            //表情动画 - 弹力动画的结束时间是根据速度自动计算的，不需要也不能指定 duration
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = 30
            anim.toValue = 8
            
            anim.springSpeed = 10
            anim.springBounciness = 10
            
            tipButton.layer.pop_add(anim, forKey: nil)
            //print("设置表情...")
        }
    }
    
    
    /// MARK: - 私有控件
    private lazy var tipButton = UIButton()
    
    init() {
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        //[[UIImageView alloc] initWithImage:image] => 会根据图像视图大小设置视图大小!
        super.init(image: image)
        
        //设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        //添加按钮
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        tipButton.center.x = bounds.width * 0.5
        tipButton.setTitle("😆", for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
