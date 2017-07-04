//
//  CZEmoticonPackage.swift
//  002-表情包数据
//
//  Created by 杭州阿尔法特 on 2017/7/3.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 表情包类型
class CZEmoticonPackage: NSObject {
    /// 表情包的分组名
    var groupName:String?
    /// 表情包的目录，从目录下载 info.pilst 可以创建表情模型数组
    var directory:String? {
        didSet {
            //当设置目录时，从目录下加载 info.plist
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
            let array = NSArray(contentsOfFile: infoPath) as? [[String:String]],
            let models = NSArray.yy_modelArray(with: CZEmoticon.self, json: array) as? [CZEmoticon]
                else {
                    return
            }
            
            //便利 models 数组，设置每一个表情符号的目录
            for m in models {
                m.directory = directory
            }
            
            //设置表情模型数组
            emotions += models
            
        }
    }
    
    /// 懒加载表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emotions = [CZEmoticon]()
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
}
