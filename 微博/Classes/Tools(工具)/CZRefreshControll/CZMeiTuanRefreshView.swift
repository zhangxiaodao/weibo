//
//  CZMeiTuanRefreshView.swift
//  刷新控件
//
//  Created by 杭州阿尔法特 on 2017/6/27.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

class CZMeiTuanRefreshView: CZRefreshView {
    @IBOutlet weak var buildingIconView: UIImageView!
    @IBOutlet weak var earthIconView: UIImageView!
    @IBOutlet weak var kangarooIconView: UIImageView!
    
    override var parentViewHeight:CGFloat {
        didSet{
            print("父视图高度\(parentViewHeight)")
            
            if parentViewHeight < 23 {
                return
            }
            
            var scale:CGFloat
            
            if parentViewHeight > 126 {
                scale = 1
            } else {
                scale = 1 - (126 - parentViewHeight) / (126 - 23)
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    
    override func awakeFromNib() {
        //1.房子
        let bimage1 = UIImage(named: "icon_building_loading_1")
        let bimage2 = UIImage(named: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bimage1! , bimage2!], duration: 0.5)
        
        //2.地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthIconView.layer.add(anim, forKey: nil)
        
        //3.袋鼠
        let kImage1 = UIImage(named: "icon_small_kangaroo_loading_1")
        let kImage2 = UIImage(named: "icon_small_kangaroo_loading_2")
        kangarooIconView.image = UIImage.animatedImage(with: [kImage1! , kImage2!], duration: 0.5)
        
        //设置锚点
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置 center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        
        kangarooIconView.center = CGPoint(x: x, y: y)
        //设置袋鼠变小
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
    
}
