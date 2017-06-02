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

    //MARK: - 设置访客试图信息
    /// 使用字典设置方可视图的信息 [imageName / message]
    /// 提示：如果是首页 imageName = ""
    var visitorInfo:[String:String]? {
        didSet{
            //1>去字典信息
            guard let imageName = visitorInfo?["imageName"] ,
                let message = visitorInfo?["message"]
                else {
                    return
            }
            
            //2>设置信息
            tipLabel.text = message
            //3> 设置图像，首页不需要设置
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 旋转动画
    func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        //动画执行完不移除，如果 iconView 被释放，动画会一起销毁
        // isRemovedOnCompletion  在设置连续播放动画的时候，非常有用
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
        
    }
    
    //MARK: -私有控件
    //懒加载属性值有调用 UIKit 控件的指定构造函数，在不需要加类型，其他的都需要加(每次定义懒加载的时候，都加了就可以了)
    //图像视图
    lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //遮罩图像
    lazy var maskIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
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
        backgroundColor = UIColor.cz_color(withHex: 0xededed)
        
        //1.添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //文本剧中
        tipLabel.textAlignment = .center
        
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
        
        //6>遮罩图像
        let viewDict = ["maskIconView":maskIconView,
                        "registerButton":registerButton] as [String : Any]
        let metrics = ["spacing":-20]
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict
        ))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
        
    }
}
