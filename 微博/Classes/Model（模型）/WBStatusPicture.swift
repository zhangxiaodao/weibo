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
    var thumbnail_pic: String? {
        didSet {
            
            //设置中等尺寸图片
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            //更改缩率图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    //大尺寸图片
    var largePic:String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
