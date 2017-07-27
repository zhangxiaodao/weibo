//
//  WBComposeViewController.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/29.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cz_random()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "推出", target: self, action: #selector(self.close))
    }
    
    func close() -> () {
        self.dismiss(animated: true, completion: nil)
    }

}
