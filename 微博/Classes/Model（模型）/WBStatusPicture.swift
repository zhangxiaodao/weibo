//
//  WBStatusPicture.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/19.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
///微博配图模型
class WBStatusPicture: NSObject {
    /// 缩略图
    var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
