//
//  WBComposeTypeView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/27.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeTypeView: UIView {
    
    @IBOutlet weak var scrollerView: UIScrollView!
    
    //按钮数据数组
    private let buttonsInfo = [
        ["imageName":"tabbar_compose_idea" , "title":"文字"],
        ["imageName":"tabbar_compose_photo" , "title":"照片/视频"],
        ["imageName":"tabbar_compose_lbs" , "title":"签到"],
        ["imageName":"tabbar_compose_review" , "title":"点评"],
        ["imageName":"tabbar_compose_more" , "title":"更多"],
        ["imageName":"tabbar_compose_friend" , "title":"好友圈"],
        ["imageName":"tabbar_compose_wbcamera" , "title":"微博相机"],
        ["imageName":"tabbar_compose_music" , "title":"音乐"],
        ["imageName":"tabbar_compose_shooting" , "title":"拍摄"]
        ]
    
    /// 类方法
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        //XIB 加载 默认是 600*600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    /// 显示当前视图
    func show() -> () {
        //1.将当前视图添加到 根视图控制器 的 view
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        //2.添加视图
        vc.view.addSubview(self)
        
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //关闭视图
    @IBAction func close(_ sender: Any) {
        removeFromSuperview()
    }
}

extension WBComposeTypeView {
    
    func setupUI() -> () {
        
        
    }
}
