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
    /// 标题标签
    @IBOutlet var titlabel: UILabel!
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        setNavigationBar()
        
        
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        
    }
    
    func setNavigationBar() -> () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "推出", target: self, action: #selector(self.close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        sendButton.isEnabled = false
        
        navigationItem.titleView = titlabel
    }
}
