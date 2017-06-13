//
//  WBDiscoverViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBDiscoverViewController: WBBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("token 过期了")
        //WBNetworkManager.shared.userAccount.access_token = nil
    }
}
