//
//  WBComposeTextView.swift
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
    
    @objc fileprivate func textChange(n:Notification) {
        //如果有文本，不显示占位标签，否则显示
        placeholderLabel.isHidden = hasText
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
