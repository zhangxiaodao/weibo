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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
