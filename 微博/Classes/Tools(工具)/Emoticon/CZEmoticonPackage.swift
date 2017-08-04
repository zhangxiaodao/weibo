//
//  CZEmoticonPackage.swift
//  002-表情包数据
//
//  Created by 杭州阿尔法特 on 2017/7/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 表情包模型
class CZEmoticonPackage: NSObject {
    /// 表情包的分组名
    var groupName:String?
    /// 背景图片名称
    var bgImageName:String?
    
    /// 表情目录，从目录下加载 info.plist 可以创建表情模型数组
    var directory:String? {
        didSet {
            //当设置目录时，从目录下加载 Info.plist
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String:String]],
                let models = NSArray.yy_modelArray(with: CZEmoticion.self, json: array) as? [CZEmoticion]
            else {
                return
            }
            
            for m in models {
                m.directory = directory
            }
            
            emoticons += models
            
            
            
        }
    }
    
    /// 懒加载的表情模型的空数组
    //使用懒加载可以避免后允许的解包
    lazy var emoticons = [CZEmoticion]()
    
    /// 表情页面数量
    var numbarOfPage:Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    func emoticon(page:Int) -> [CZEmoticion] {
        
        //每页的数量
        let count = 20
        let location = page * count
        var length = count
        
        //判断数组是否越界
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange(location: location, length: length)
        
        //截取数组的子数组
        let subArray = (emoticons as NSArray).subarray(with: range)
        return subArray as! [CZEmoticion]
        
        
    }
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
}
