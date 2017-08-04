//
//  WBComposeViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/29.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {

    /// 文本编辑视图
    @IBOutlet weak var textView: WBComposeTextView!
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    /// 标题标签 -
    @IBOutlet var titlabel: UILabel!
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    //表情输入视图
    lazy var emoticonView:CZEmoticonInputView = CZEmoticonInputView.inputView {[weak self] (em) in
        
        self?.textView.insertEmoticon(em: em)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() 
        
        //监听键盘通知 - UIWindow.h
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //关闭键盘
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardChanged(n:Notification) {
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
        
        //1.获取微博文字
        let text = textView.emoticonText
        //2.发布微博
        WBNetworkManager.shared.postStatus(text: text, image: nil) { (json, isSuccess) in
            print(json ?? "")
            
            //修改指示器样式
            SVProgressHUD.setDefaultStyle(.dark)
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            
            SVProgressHUD.showInfo(withStatus: message)
            
            //如果成功，延迟一段时间关闭当前窗口
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                    //回复样式
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }
        }
        
    }
    
    //切换表情键盘
    @objc fileprivate func emoticonKeyboard() -> () {
        
        //textView.inputView 就是文本框的输入视图
        //如果使用系统默认的键盘，输入视图为 nil
        
        //2> 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        //3> 刷新键盘视图
        textView.reloadInputViews()
        
        
        
    }
}

extension WBComposeViewController :UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
         sendButton.isEnabled = textView.hasText
    }
}

extension WBComposeViewController {
    
    func setupUI() -> () {
        
        view.backgroundColor = UIColor.white
        //textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
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
            
            //判断 actionName
            if let actionName = s["actionName"] {
                //给按钮添加事件
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside )
            }
            
            //追加按钮
            items.append(UIBarButtonItem(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
}
