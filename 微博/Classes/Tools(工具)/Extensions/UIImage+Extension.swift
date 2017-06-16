//
//  UIImage+Extension.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/16.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

extension UIImage {
    /// 创建头像图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    ///   - lineColor: 边框颜色
    /// - Returns: 裁切后的图像
    func cz_avatarImage(size:CGSize? , backColor:UIColor = UIColor.white , lineColor:UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        //1.获取图像的上下文 - 内存中开辟一个地址，跟屏幕无关
        /**
         1>绘图尺寸
         2>opaque: false(透明) / true(不透明)
         3>scale:屏幕分辨率，默认是让你过程的图片使用 1.0 的分辨率,图像质量不好，可以指定 0 ，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        //0>背景填充
        backColor.setFill()
        UIRectFill(rect)
        
        //1>实例化一个圆形路径
        let path = UIBezierPath(ovalIn: rect)
        //2>进行路径裁切 - 后续的绘图都会出现在圆形路径内部，外部的全部干掉
        path.addClip()
        
        //2.绘图 drawInRect 就是在指定区域内拉伸屏幕
        draw(in: rect)
        
        
        //3.绘制内切的圆形
        let ovalPath = UIBezierPath(ovalIn: rect)
        lineColor.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()
        
        //3.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        
        //4.关闭上下文
        UIGraphicsEndImageContext()
        
        return result
    }
}
