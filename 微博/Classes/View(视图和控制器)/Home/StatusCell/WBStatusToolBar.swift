//
//  WBStatusToolBar.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/16.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    var viewModel:WBStatustViewModel? {
        didSet {
            retweetedButton.setTitle("\(String(describing: viewModel?.status.reposts_count))", for: .normal)
            commentButton.setTitle("\(String(describing: viewModel?.status.comments_count))", for: .normal)
            retweetedButton.setTitle("\(String(describing: viewModel?.status.reposts_count))", for: .normal)
        }
    }
    
    
    
    //转发
    @IBOutlet weak var retweetedButton : UIButton!
    //评论
    @IBOutlet weak var commentButton: UIButton!
    //点赞
    @IBOutlet weak var likeButton: UIButton!
}
