//
//  WBOAuthViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/8.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import SVProgressHUD


/// 通过 webVIew 加载新浪微博 授权页面控制器
class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        //设置导航栏
        title = "登录新浪微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 16, target: self, action: #selector(close), isback: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
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
    
    /// MARK: - 监听方法
    /// 关闭定时器
    @objc fileprivate func close() -> () {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充 - WebView的注入，直接通过 js 修改 ‘本地浏览器中’ 缓存的页面内容
    //点击 登陆按钮 ，执行 submit() 将 本地数据提交给服务器
    @objc fileprivate func autoFill() -> () {
        //准备 js
        let js = "document.getElementById('userId').value = '18767112313';" + "document.getElementById('passwd').value = 'azhc1212';"
        //让 webView 执行 js 
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension WBOAuthViewController:UIWebViewDelegate {
    
    /// webView 将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要加载的请求
    ///   - navigationType: 导航栏类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //确认思路：
        //1. 如果请求地址包含 http://baidu.com 不加载页面 /否则加载页面
        // -(BOOL) hasPrefix:(NSString *) //astring;检查字符串是否以astring开头；
        // -(BOOL) hasSuffix:(NSString *) //astring;检查字符串是否以astring结尾；
        if request.url?.absoluteString.hasPrefix(WBRedirectURL) == false {
            return true
        }
        
        //2. 从 http://baidu.com 回调地址中查询字符串的查找 'code='
        //如果有，授权成功，否则，授权失败
        
        //print("加载请求---\(String(describing: request.url))")
        // query 就是 URL 中 '?' 后面的所有部分
        //print("加载请求--\(String(describing: request.url?.query))")
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        //3. 从 query 字符串中获取授权码
        // 代码走到吃醋， url 中一定有 查询字符串，并且包含了 'code='
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("获取授权码\(code)")
        
        //4.使用获取的授权码 获取 Accesstoken
        WBNetworkManager.shared.loadAccesstoken(code: code) { (isSuccess) in
            print(isSuccess)
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                
                //跳转界面
                //1.发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNottification), object: nil)
                
                //2.关闭窗口
                self.close()
            }
            
        }
        
        
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
         SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}

