//
//  WBComposeTypeButton.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/28.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var clsName:String?
    
    
    class func composeTypeBtn(imageName:String , title:String) -> WBComposeTypeButton {
        let nib = UINib.init(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLable.text = title
        
        return btn
    }

}
