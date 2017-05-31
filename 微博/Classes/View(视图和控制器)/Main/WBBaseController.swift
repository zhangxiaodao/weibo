//
//  WBBaseController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/5/26.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension WBBaseController {
    func setupUI() -> () {
        view.backgroundColor = UIColor.cz_random()
    }
}
