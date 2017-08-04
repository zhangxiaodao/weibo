//
//  WBComposeswift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/8/1.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    //站位标签
    lazy fileprivate var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textChange() {
        //如果有文本，不显示占位标签，否则显示
        placeholderLabel.isHidden = hasText
    }
}

// MARK: - 表情键盘专属方法
extension WBComposeTextView {
    /// 向文本视图插入表情符号
    ///
    /// - Parameter em: 选中的表情符号,nil表示删除
    func insertEmoticon(em:CZEmoticion?) {
        
        //1. em == nil 是删除按钮
        guard let em = em else {
            //删除文本
            deleteBackward()
            return
        }
        
        //2.emoji 字符串
        if let emoji = em.emoji ,
            let textRange = selectedTextRange{
            //UITextRange 仅用在此处
            replace(textRange, withText: emoji)
            return
        }
        
        //3.代码执行到此，都是图片表情
        //0>获取表情中的图像属性文本
        //在所有的排版系统中，几乎都有一个共同的特点，插入的字符的显示跟随前一个字符的'属性'，但是本身没有'属性'
        let imageText = em.imageText(font: font!)
        
        //1>获取当前 textView 属性文本 => 可变
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        
        //2>将图像的属性文本插入到的当前的光标位置
        attrStrM.replaceCharacters(in: selectedRange, with: imageText!)
        
        //3>重新设置属性文本
        //记录光标位置
        let range = selectedRange
        
        //设置文本
        attributedText = attrStrM
        
        //回复光标位置,length 是选中字符的长度，插入文本后应该为 0
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        //4.让代理处发文本变化
        delegate?.textViewDidChange?(self)
        
        //5.执行当前对象的 文本变化
        textChange()
        
    }
}

extension WBComposeTextView {
    func setupUI() -> () {
        
        //0.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        
        //1.设置站位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        self.addSubview(placeholderLabel)
        
    }
}
