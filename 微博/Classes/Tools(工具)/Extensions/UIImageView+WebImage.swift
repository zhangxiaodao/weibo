//
//  UIImageView+WebImage.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/16.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    /// 隔离 SDWebImage 设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 展位图像
    ///   - isAvatar: 是否是头像
    func cz_setImage(urlString:String? , placeholderImage:UIImage? , isAvatar:Bool = false) -> () {
        guard let urlString = urlString ,
            let url = URL(string: urlString) else {
            //设置占位图像
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            //完成回调 - 判断是否是头像
            if isAvatar && image != nil {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
        
    }
}




