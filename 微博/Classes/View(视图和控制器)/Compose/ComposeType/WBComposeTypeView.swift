//
//  WBComposeTypeView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/27.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit
import pop

class WBComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 返回前一页按钮约束
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    /// 关闭按钮约束
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    
    @IBOutlet weak var returnButton: UIButton!
    
    
    //按钮数据数组
    fileprivate let buttonsInfo = [
        ["imageName":"tabbar_compose_idea" , "title":"文字"],
        ["imageName":"tabbar_compose_photo" , "title":"照片/视频"],
        ["imageName":"tabbar_compose_lbs" , "title":"签到"],
        ["imageName":"tabbar_compose_review" , "title":"点评"],
        ["imageName":"tabbar_compose_review" , "title":"长微博"],
        ["imageName":"tabbar_compose_more" , "title":"更多" , "clickName":"clickMore"],
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
        
        v.setupUI()
        
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
        showCurrentView()
    }
    
    
    @objc func clickMore() {
        print("点击更多")
        //将 scrollView 滚动到第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //处理底部按钮,让两个按钮分开
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        returnButtonCenterXCons.constant -= margin
        closeButtonCenterXCons.constant += margin
        
        UIView.animate(withDuration: 0.25) { 
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func clickReturn(_ sender: Any) {
        //1.将滚动视图，滚动到第一页
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //2.让两个按钮合并
        let margin = scrollView.bounds.width / 6
        returnButtonCenterXCons.constant += margin
        closeButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
        
    }
    //关闭视图
    @IBAction func close(_ sender: Any) {
        removeFromSuperview()
    }
}

// MARK: - 动画扩展方法
fileprivate extension WBComposeTypeView {
    fileprivate func showCurrentView() {
        //1>创建动画
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        
        //2>添加到视图
        pop_add(anim, forKey: nil)
        
        //3.添加按钮的动画
        showBtns()
    }
    
    /// 弹力显示所有的按钮
    fileprivate func showBtns(){
        //1.获取 scrllView 的第 0 个视图
        let v = scrollView.subviews[0]
        
        //2.便利 v 中所有的按钮
        for (i , btn) in v.subviews.enumerated() {
            //1>创建动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            //2>设置动画属性
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            
            //弹力系数 0~20 数值越大，弹性越大默认是4
            anim.springBounciness = 8
            // 弹力速度，取值范围 0~20，数值越大，速度越快，默认值是 12
            anim.springSpeed = 8
            
            //设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            //3>添加动画
            btn.pop_add(anim, forKey: nil)
            
        }
        
    }
}

fileprivate extension WBComposeTypeView {
    
    func setupUI() {
        
        //0.强行更新布局
        layoutIfNeeded()
        
        //1.向 scrollView 添加视图
        let rect = scrollView.bounds
        let width = scrollView.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame:rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            
            //2.向视图添加按钮
            addButton(v: v, idx: 6 * i)
            
            //3.将试图添加到 scrollView
            scrollView.addSubview(v)
        }
        
        //4.设置 scrollView 
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
    }
    
    //向 v 中添加按钮，按钮的数组索引从 idx 开始
    func addButton(v:UIView , idx:Int)  {
        let count = 6
        
        //从 idx 开始添加 6 个按钮
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            
            //0.从数组字典中获取图像名称 和 title
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"],
                let title = dict["title"]
                else {
                    continue
            }
            
            //1>创建按钮
            let btn = WBComposeTypeButton.composeTypeBtn(imageName: imageName, title: title)
            v.addSubview(btn)
            
            if let actionName = dict["clickName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
        }
        
        //便利视图的子视图，布局按钮
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i , btn) in v.subviews.enumerated() {
            let y:CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
        }
        
        
    }
    
    
    
    
    
}
