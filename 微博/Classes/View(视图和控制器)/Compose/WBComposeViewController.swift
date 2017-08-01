//
//  WBComposeViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/29.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {

    /// 文本编辑视图
    @IBOutlet weak var textView: UITextView!
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    /// 标题标签 -
    @IBOutlet var titlabel: UILabel!
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //监听键盘通知 - UIWindow.h
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc private func keyboardChanged(n:Notification) {
        print(n.userInfo)
        
        //1.目标 rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
        //2.设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y
        
        //3.更新底部约束
        toolbarBottomCons.constant = offset
        
        //4.动画更新约束
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
        
        
    }
    
    func close() -> () {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postStatus(_ sender: Any) {
        print("发布微博")
    }
}

extension WBComposeViewController {
    
    func setupUI() -> () {
        
        view.backgroundColor = UIColor.white
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        setNavigationBar()
        setupToolBar()
        
        
        
    }
    
    func setNavigationBar() -> () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "推出", target: self, action: #selector(self.close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        sendButton.isEnabled = false
        
        navigationItem.titleView = titlabel
    }
    
    func setupToolBar() -> () {
        let itemSettings = [
                            ["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        //比爱丽数组
        var items = [UIBarButtonItem]()
        
        for s in itemSettings {
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            
            //追加按钮
            items.append(UIBarButtonItem(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
}
