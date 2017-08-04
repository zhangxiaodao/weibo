//
//  CZEmoticion.swift
//  002-表情包数据
//
//  Created by 杭州阿尔法特 on 2017/7/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class CZEmoticion: NSObject {
    /// 表情类型 false - 图片类型 / true - emoji
    var type = false
    /// 表情字符串，发送给新浪微博的服务器(节省流量)
    var chs:String?
    /// 表情图片名称，用于本地图文混排
    var png:String?
    /// emoji的 十六进制编码
    var code:String? {
        didSet {
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            var result:UInt32 = 0
            
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    /// emoji 的字符串
    var emoji:String?
    
    
    /// 表情模型所在目录
    var directory:String?
    
    var image:UIImage? {
        //判断表情类型
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
        else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    func imageText(font:UIFont) -> NSAttributedString? {
        //1.判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        let attachment = CZEmoticonAttachment()
        
        attachment.chs = chs
        attachment.image = image
        
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        //设置字体属性
        attrStrM.addAttributes([NSFontAttributeName:font], range: NSRange(location: 0, length: 1))
        
        //返回属性文本
        return attrStrM
    }
    
    
    override var description: String{
        return yy_modelDescription()
    }
}
