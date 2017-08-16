//
//  WBStatusPictureView.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/16.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    var viewModel:WBStatustViewModel? {
        didSet {
            calcViewSize()
            //设置配图 (内转发和原创)
            urls = viewModel?.picURLs
        }
    }
    
    /// 根据视图模型的配图视图大小，调整显示内容
    private func calcViewSize() {
        
        //处理宽度
        //1> 单图，根据配图视图的大小，修改 subView[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            //a) 获取第 0 个 图像视图
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height - WBStatusPictureViewOutterMargin)
        } else {
            //2> 多图(无图),恢复 subview[0] 的宽高,保证九宫格的完整
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
            
        }
        
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    private var urls:[WBStatusPicture]? {
        didSet {
            
            //1. 隐藏 所有 的 imageView
            for v in subviews {
                v.isHidden = true
            }
            
            //2. 便利 urls 数组，顺序设置图像
            var index = 0
            
            for url in urls ?? [] {
                //获得对应索引的 imageView
                let iv = subviews[index] as! UIImageView
                
                // 4 张图像处理 
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                //设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                //判断是否指 gif , 根据扩展名
                iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension != "gif")
                //显示图像
                iv.isHidden = false
                
                index += 1
                
            }
            
        }
    }
    
    
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
    
    /// MARK: - 监听方法
    @objc fileprivate func tapImageView(tap:UITapGestureRecognizer) {
        guard let iv = tap.view,
            let picURLs = viewModel?.picURLs else{
            return
        }
        
        var selectedIndex = iv.tag
        
        //针对 四张图片进行处理
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        
        let urls = (picURLs as NSArray).value(forKey: "largePic") as! [String]
        
        //处理可见的图像视图数组
        var imageViewList = [UIImageView]()
        
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        //发送通知
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification), object: self, userInfo: [WBStatusCellBrowserPhotoURLsKey:urls , WBStatusCellBrowserPhotoSelectedIndexKey:selectedIndex , WBStatusCellBrowserPhotoImageViewKey:imageViewList]) as Notification)
        
    
    }
}

extension WBStatusPictureView {
    //1. Cell 中所有的控件 都是提前准备好
    //2. 设置的时候，根据数据决定是否显示
    //3.不要动态创建控件
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        
        //clipsToBounds 超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        //循环创建 9 个 iamgeView
        for i in 0..<count * count {
            let iv = UIImageView()
            
            //设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            //行 -> Y
            let row = CGFloat(i / count)
            //列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
            
            //让 iv 能够接受用户交互
            iv.isUserInteractionEnabled = true
            
            //添加手势识别
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            iv.addGestureRecognizer(tap)
            
            //设置 imageView 的 tag
            iv.tag = i
            
            addGifView(iv: iv)
        }
    }
    
    private func addGifView(iv:UIImageView) {
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        iv.addSubview(gifImageView)
        
        //自动布局
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: iv,
            attribute: .right,
            multiplier: 1.0,
            constant: 0))
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: iv,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        
    }
}
