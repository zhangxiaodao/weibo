//
//  WBVisitorView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 访客视图
class WBVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -私有控件
    //懒加载属性值有调用 UIKit 控件的指定构造函数，在不需要加类型，其他的都需要加(每次定义懒加载的时候，都加了就可以了)
    //图像视图
    lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //小房子
    lazy var houseIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示标签
    lazy var tipLabel:UILabel = UILabel.cz_label(
        withText: "关注一些人，回这里看看有什么标签关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
    //注册按钮
    lazy var registerButton:UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black ,
        backgroundImageName: "common_button_white_disable")
    //登陆按钮
    lazy var loginButton:UIButton = UIButton.cz_textButton(
        "登陆",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
}

extension WBVisitorView {
    func setupUI() -> () {
        backgroundColor = UIColor.white
        
        //1.添加控件
        addSubview(iconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //2. 原生的自动布局需要 取消 autoresizing , autoresizing 和 autoLayout 不能共存 ， 使用纯代码自动布局使用的是 autoresizing ,使用 xib 自动布局使用的是 autoLayout
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //3.自动布局
        
        let margin:CGFloat = 20.0
        
        
        //1> 图像视图
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self, 
            attribute: .centerX,
            multiplier: 1,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: -60))
        //2> 图像视图
        addConstraint(NSLayoutConstraint(
            item: houseIconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: houseIconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0))
        
        //3>提示标签
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .bottom,
            multiplier: 1,
            constant: margin))
        //tipLabel 的宽度
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .width, 
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 236))
        
        //4>注册按钮
        addConstraint(NSLayoutConstraint(
            item: registerButton,
            attribute: .left,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .left,
            multiplier: 1.0,
            constant: -margin))
        addConstraint(NSLayoutConstraint(
            item: registerButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin))
        addConstraint(NSLayoutConstraint(
            item: registerButton, 
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        
        //5>登陆按钮
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .right,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .right,
            multiplier: 1.0,
            constant: margin))
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin))
        addConstraint(NSLayoutConstraint(
            item: loginButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        
    }
}
