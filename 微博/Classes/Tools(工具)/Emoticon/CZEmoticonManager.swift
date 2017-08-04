//
//  CZEmoticonManager.swift
//  002-表情包数据
//
//  Created by 杭州阿尔法特 on 2017/7/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import YYModel

/// 表情管理器
class CZEmoticonManager: NSObject {
    //为了便于表情的复用，建立一个单利，只加载一次表情数据
    //表情管理器的单利 CZEmoticonManager() 是一个单利，在第一次执行的之后，保存在 等号前面的 shared 中
    static let shared = CZEmoticonManager()
    
    /// 表情包的懒加载数组
    lazy var packages = [CZEmoticonPackage]()
    
    //表情素材的懒加载数组
    lazy var bundle:Bundle = {
       let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        
        return Bundle(path: path!)!
    }()
    
    //构造函数 , 如果在 init 之前增加 private 修饰符，可以要求调用者，必须通过  shared 访问对象
    //OC 需要重写 allocWithZone 方法，在里面再次 dispatch_once
    private override init() {
        
        super.init()
        loadPackages()
    }
    
    
}

// MARK: - 表情包数据处理
fileprivate extension CZEmoticonManager {
    
    func loadPackages() -> () {
        //读取 emoticons.plist , 根据 path 创建 bundle
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let models = NSArray.yy_modelArray(with: CZEmoticonPackage.self, json: array) as? [CZEmoticonPackage]
            else {
            return
        }
        
        //设置表情包数据
        packages += models
                
        
    }
    
    
    
}


extension CZEmoticonManager {
    
    
    /// 将给定字符串转换成属性文本
    /// 关键点：要按照匹配结果倒序替换属性文本!
    /// - Parameter string: 完整的字符串
    /// - Returns: 属性文本
    func emoticonsString(string:String,font:UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        
        //1.建立正则表达式，过滤所有文字表情文字
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        //2.匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        //3.便利所有匹配结果
        for m in matches.reversed() {
            let r = m.rangeAt(0)
            let subStr = (attrString.string as NSString).substring(with: r)
            
            
            //1.使用 subStr 查找对应的表情符号
            if let em = CZEmoticonManager.shared.findEmoticon(string: subStr) {
                //2.使用表情符号中的属性文本，替换原有的属性文本中的内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: font)!)
            }
            
        }
        
        //4.*****统一设置一遍字符串的属性
        attrString.addAttributes([NSFontAttributeName:font], range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }

    
    /// 根据 string 在所有的表情符号中查找对应的表情模型对象
    /// - 如果找到，返回表情模型
    /// - 否则返回 nil
    func findEmoticon(string:String) -> CZEmoticion? {
        //1.便利表情包
        //OC 中过滤数组使用 [谓词]
        //Swift 中更简单
        for p in packages {
            //2.在表情数组中 过滤 string
            //方法1
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            //方法2 - 闭包作为最后一个参数，()可以提前结束(可以改为尾随闭包)
//            let result = p.emoticons.filter() { (em) -> Bool in
//                return em.chs == string
//            }
            
            //方法3 - 如果闭包中只有一句话，并且是返回
            //1>闭包格式定义可以省略
            //2>参数省略之后，可以使用$0 , $1...一次替代原有的参数
//            let result = p.emoticons.filter({
//                return $0.chs == string
//            })
            
            //方法4 - 如果闭包中只有一句话，并且是返回
            //1>闭包格式定义可以省略
            //2>参数省略之后，可以使用$0 , $1...一次替代原有的参数
            //3>return 也可以省略
            let result = p.emoticons.filter() { $0.chs == string }
            
            
            
            //3.判断结果数组中的数量
            if result.count == 1 {
                return result[0]
            }
            
        }
        
        return nil
    }
}


