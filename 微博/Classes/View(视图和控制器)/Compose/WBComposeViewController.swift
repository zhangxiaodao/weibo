//
//  WBComposeViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/29.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    
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
    
//    lazy var sendBtn:UIButton = {
//        
//        let btn = UIButton()
//        
//        btn.setTitle("发布", for: [])
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        
//        //设置标题颜色
//        btn.setTitleColor(UIColor.white, for: [])
//        btn.setTitleColor(UIColor.gray, for: .disabled)
//        
//        //设置背景图片
//        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: [])
//        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
//        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
//        
//        //设置大小
//        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
//        
//        return btn
//    }()

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
    }
}
