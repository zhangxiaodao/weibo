//
//  FFLabel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/7/28.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

@objc
protocol FFLabelDelegate:NSObjectProtocol {
    /// 选中链接文本
    ///
    /// - Parameters:
    ///   - label: label
    ///   - text: 选中的文本
    @objc optional func labelDidSelectedLinkText(label:FFLabel , text:String)
}

/**
 1.使用 TextKit 接管 Label 的底层实现 - 绘制 textStorage 的文本内容
 2.使用正则表达式过滤 URL ，设置 URL 的特殊显示
 3.交互
 */

class FFLabel: UILabel {
    
    fileprivate lazy var textStorage = NSTextStorage()
    fileprivate lazy var layoutManager = NSLayoutManager()
    fileprivate lazy var textContainer = NSTextContainer()
    weak var delegate:FFLabelDelegate?
    var selectedRange:NSRange?
    
    public var linkTextColor = UIColor.blue
    public var selectedBackgroudColor = UIColor.lightGray
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //指定文本绘制的区域
        textContainer.size = bounds.size
    }
    
}

// MARK: - 绘制文本
extension FFLabel {
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        
        //绘制字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
}

// MARK: - 重写属性
extension FFLabel {
    //一旦变化，需要让 textStorage 响应变化
    override var text: String? {
        didSet {
            //重写文本内容
            prepareTextContent()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            prepareTextContent()
        }
    }
    
    override var font: UIFont! {
        didSet {
            prepareTextContent()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            prepareTextContent()
        }
    }
    
    
}

// MARK: - 设置 TextKit 核心对象
fileprivate extension FFLabel {
    //准备文本系统
    func prepareTextSystem() -> () {
        //0.打开 label 的交互
        isUserInteractionEnabled = true
        
        //1.设置文本内容
        prepareTextContent()
        
        //2.设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
    }
    
    /// 准备文本内容 - 使用 textStorage 接管 label 的内容
    func prepareTextContent() -> () {
        if let attributeText = attributedText {
            textStorage.setAttributedString(attributeText)
        } else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        } else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        //便利范围数组，设置 URL 文字的属性
        for r in urlRanges ?? [] {
            textStorage.addAttributes([
                NSForegroundColorAttributeName:textColor ,NSBackgroundColorAttributeName:UIColor.clear ,
                NSFontAttributeName:font], range: r)
        }
    }
}

// MARK: - 返回 textStorage 中的 URL range 数组
fileprivate extension FFLabel {
    var urlRanges:[NSRange]? {
        
        var ranges = [NSRange]()
        
        //1.正则表达式
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        
        for pattern in patterns {
            guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
                return nil
            }
            
            //2.多重匹配
            let matches = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
            
            //3.遍历数组，生成 range 的数组
            for m in matches {
                ranges.append(m.rangeAt(0))
            }
        }
        return ranges
    }
    
}


// MARK: - 点击事件
extension FFLabel {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //1.获取用户点击位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        selectedRange = linkRangeAtLocation(location: location)
        
        modifySelectedAttribute(isSet: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        
        guard let range = linkRangeAtLocation(location: location!) else {
            return modifySelectedAttribute(isSet: false)
        }
        
        if range.location == selectedRange?.location && range.length == selectedRange?.length {
            modifySelectedAttribute(isSet: false)
            selectedRange = range
            modifySelectedAttribute(isSet: true)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange != nil {
            let text = (textStorage.string as NSString).substring(with: selectedRange!)
            delegate?.labelDidSelectedLinkText!(label: self, text: text)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.modifySelectedAttribute(isSet: false)
            })
            
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(isSet: false)
    }
    
    func linkRangeAtLocation(location:CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        //2.获取当前点击的字符的索引
        let idx = layoutManager.glyphIndex(for: location, in: textContainer)
        //3.判断 idx 是否在 urls 的 range 范围内，如果在，就高亮
        for r in urlRanges ?? [] {
            if NSLocationInRange(idx, r) {
                return r
            }
        }
        
        return nil
    }
    
    func modifySelectedAttribute(isSet:Bool) -> () {
        if selectedRange == nil {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
//
        
        let range = selectedRange
        
        if isSet {
            attributes[NSBackgroundColorAttributeName] = selectedBackgroudColor
            attributes[NSForegroundColorAttributeName] = UIColor.blue
        } else {
            attributes[NSBackgroundColorAttributeName] = UIColor.clear
            attributes[NSForegroundColorAttributeName] = UIColor.gray
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range!)
        
        setNeedsDisplay()
    }
    
    
}


 
