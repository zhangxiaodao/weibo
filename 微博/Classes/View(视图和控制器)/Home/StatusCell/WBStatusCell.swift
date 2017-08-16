//
//  WBStatusCell.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

//微博 Cell 的协议
// 如果需要设置可选协议方法
// - 需要遵守 NSObjectProtocol 协议
// - 协议需要时 @objc
// - 方法需要 @objc optional
@objc protocol WBStatusCellDelegate:NSObjectProtocol {
    @objc optional func statusCellDidSelectedURLString(cell:WBStatusCell , urlString:String) -> ()
}

/**
    表格的性能优化:
    1.行高一定要优化(缓存行高是解决性能最佳的途径)
    2.尽量少计算，所有需要的素材提前计算好
    3.空间上不要设置圆角半径，所有图像渲染的属性
    4.不要动态创建控件，所有需要的控件都要提前创建好，在显示的时候，根据数据隐藏 / 显示
    5.cell 中控件的层次越少越好，数量数少越好
    6.高级优化:
        离屏渲染和栅格化一起使用，离屏渲染(异步绘制->在 cell 显示之前，提前绘制好，进入屏幕的时候只需要显示),离屏渲染需要在 GPU / CPU 之间来回切换，比较好费硬件资源，比较耗电
        栅格化:异步绘制之后，会生成一张独立的图像，cell在滚动的是这张图片
        6.1.离屏渲染  self.layer.drawsAsynchronously = true
        6.2.栅格化    self.layer.shouldRasterize = true 
            使用栅格化一定要指定分辨率  self.layer.rasterizationScale = UIScreen.main.scale
 */

class WBStatusCell: UITableViewCell {
    
    weak var delegate:WBStatusCellDelegate?
    
    var viewModel:WBStatustViewModel? {
        didSet{
            statusLabel.attributedText = viewModel?.statusAttrText
            //设置被转发微博的文字
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            nameLabel.text = viewModel?.status.user?.screen_name
            
            //设置会员图标
            memberIconView.image = viewModel?.memberIcon
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big") , isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            
            //配图视图模型
            pictureView.viewModel = viewModel
            
            //设置来源
            sourceLabel.text = viewModel?.status.source
            
            //设置时间
            
            timeLabel.text = viewModel?.status.createDate?.cz_dateDescription
        }
    }
    
    
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //姓名
    @IBOutlet weak var nameLabel: UILabel!
    //会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    //正文
    @IBOutlet weak var statusLabel: FFLabel!
    //底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    //配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    //被转发微博的标签 - 原创微博没有此控件 一定要用 ?
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //表格性能优化
        
        //1. 离屏渲染 - 异步绘制 (离屏渲染需要在 GPU / CPU 之间快速切换，耗电比较厉害)
        self.layer.drawsAsynchronously = true
        //2.栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        //cell 优化，要尽量减少图层的数量，相当于只有一层
        //停止滚动之后，可以接受监听
        self.layer.shouldRasterize = true
        
        //使用’栅格化‘，必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        //设置微博文本代理
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }
    
}

extension WBStatusCell:FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        //判断 是否是 url
        if !text.hasPrefix("http://") {
            return
        }
        
        // 插入 ? 表示如果代理没有实现协议方法，就什么都不做
        // 如果使用 ! ,代理没有实现协议方法，仍然强行执行，会崩溃!
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
        
    }
}
