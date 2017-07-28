//
//  WBWebViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/7/28.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

//网页控制器
class WBWebViewController: WBBaseController {

    fileprivate lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    /// URL 字符串
    var urlString:String?{
        didSet {
            guard let url = URL(string: urlString ?? "") else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
}

extension WBWebViewController {
    override func setUpTableView() {
        
        navItem.title = "网页";
        
        //设置 webView
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        
        //设置 contentInset
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}

