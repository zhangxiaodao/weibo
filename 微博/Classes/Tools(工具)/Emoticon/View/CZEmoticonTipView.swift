//
//  CZEmoticonTipView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/8/14.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class CZEmoticonTipView: UIImageView {

    init() {
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        //[[UIImageView alloc] initWithImage:image] => 会根据图像视图大小设置视图大小!
        super.init(image: image)
        
        //设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
