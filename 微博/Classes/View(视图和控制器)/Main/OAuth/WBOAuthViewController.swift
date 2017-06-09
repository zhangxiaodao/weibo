//
//  WBOAuthViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/8.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 通过 webVIew 加载新浪微博 授权页面控制器
class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        //设置导航栏
        title = "登录新浪微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 16, target: self, action: #selector(close), isback: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURL)"
        
        
        //1> URL确定要访问的资源
        guard let url = URL(string: urlString) else { return  }
        //2> 建立请求
        let request = URLRequest(url: url)
        //3> 加载请求
        webView.loadRequest(request)
        
                
    }
    
    @objc fileprivate func close() -> () {
        dismiss(animated: true, completion: nil)
    }

}
