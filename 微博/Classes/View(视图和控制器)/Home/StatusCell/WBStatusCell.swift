//
//  WBStatusCell.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
    
    var viewModel:WBStatustViewModel? {
        didSet{
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            
            //设置会员图标
            memberIconView.image = viewModel?.memberIcon
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big") , isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            
            //测试修改配图视图的高度
            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            
            //设置配图视图的 url 数据
            
            
            //测试 4 张图像
            pictureView.urls = viewModel?.status.pic_urls
//            if (viewModel?.status.pic_urls?.count)! > 4 {
//                //修改数组 -> 将末尾的数据全部删除
//                var picURLS = viewModel?.status.pic_urls
//                picURLS?.removeSubrange(((picURLS?.startIndex ?? 0) + 4)..<(picURLS?.endIndex ?? 0))
//                pictureView.urls = picURLS
//                
//            } else {
//                pictureView.urls = viewModel?.status.pic_urls
//            }
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
    @IBOutlet weak var statusLabel: UILabel!
    //底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    //配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    @IBOutlet weak var pictureTopCons: NSLayoutConstraint!
}
