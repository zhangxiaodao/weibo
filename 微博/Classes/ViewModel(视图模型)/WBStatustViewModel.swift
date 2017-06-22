//
//  WBStatustViewModel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/15.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation
/**
 如果没有任何父类，如果希望开发时调试，输出调试信息，需要
 1. 遵循 CustomStringConvertible协议
 2. 实现 description 计算型属性
 
 关于表格的性能优化
 - 尽量少计算，所需要的素材提前计算好
 - 空间上不要设置圆角半径，所有图像渲染的属性，都要注意
 - 不要动态创建控件，所有需要的空间，都要提前创建好，在显示的时候，根据数据隐藏或者显示
 - Cell 中控件的层次越少越好，数量数少越好
 */
class WBStatustViewModel:CustomStringConvertible {
    /// 微博模型
    var status:WBStatus
    
    //会员图标 - 存储型属性 (用内存 换 CPU)
    var memberIcon:UIImage?
    //认证类型,-1 没有认证， 0 认证用户， 2，3，5：企业认证， 220 ：达人
    var vipIcon:UIImage?
    //转发文字
    var retweetedStr:String?
    //评论文字
    var commentStr:String?
    //点赞文字
    var likeStr:String?
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博，原创微博一定没有图
    var picURLs:[WBStatusPicture]? {
        //如果是被转的发微博，返回被转发微博的配图
        //如果没有被转发的微博，返回原创微博的配图
        //如果都没有，返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博的文字
    var retweetedText:String?
    
    /// 行高
    var rowHeight:CGFloat = 0
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    ///
    /// - returns: 微博的视图模型
    init(model:WBStatus) {
        self.status = model
        
        //会员等级
        let mbrank = model.user?.mbrank ?? 0
        
        if (mbrank > 0) && (mbrank < 7) {
            let imageName = "common_icon_membership_level\(mbrank)"
            memberIcon = UIImage(named: imageName)
        }
        
        //认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //设置底部计数字符串
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        //计算配图视图大小 (有原创的 就计算 原创的  有转发的 就计算转发的)
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        //设置被转发微博的文字
        retweetedText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
        
        //计算行高
        updateRowHeight()
    }
    
    var description: String {
        return status.description
    }
    
    /// 根据当前试图内容计算行高
    func updateRowHeight() -> () {
        //原创微博 : 顶部分割视图(12) + 间距(12) + 图像高度(34) + 间距(12) + 正文高度(需要计算) + 配图视图高度(计算) + 间距(12) + 底部视图高度(35)
        //被转发微博 : 顶部分割视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文的高度(需要计算) + 间距(12) + 间距(12) + 转发的文本高度(需要计算) + 配图视图的高度(计算) + 间距(12) + 底部视图高度(35)
        
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolbarHeight:CGFloat = 35
        
        var height:CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //1. 计算顶部视图的位置
        height = 2 * margin + iconHeight + margin
        
        //2.正文的高度
        if let text = status.text {
            /**
             boundingRect(with: <#T##CGSize#>, options: <#T##NSStringDrawingOptions#>, attributes: <#T##[String : Any]?#>, context: <#T##NSStringDrawingContext?#>)
                1> CGSize 预期的大小 , 宽度确定，高度尽可能的大
                2> options 固定的值 .usesLineFragmentOrigin
                3> 计算label 的高度  一定要知道  字体的大小
                4> 传为 nil
             */
            height += (text as NSString).boundingRect(with: viewSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:originalFont], context: nil).height
        }
        
        //3. 判断是否转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            
            //转发文本的高度 - 一定用 retweetedText ，拼接了 @用户名:微博文字
            if let text = retweetedText {
                height += (text as NSString).boundingRect(with: viewSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:retweetedFont], context: nil).height
            }
        }
        
        //4.配图视图
        height += pictureViewSize.height
        height += margin
        
        //5.底部工具栏
        height += toolbarHeight
        
        //6.使用属性记录
        rowHeight = height
    }
    
    /// 使用单张图像更新配图视图的大小
    ///
    /// - Parameter image: 网络缓存的单张图像
    func updateSingleImage(image:UIImage) -> () {
        var size = image.size
        
        size.height += WBStatusPictureViewOutterMargin
        
        pictureViewSize = size
        
    }
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - Parameter count: 配图的数量
    /// - Returns: 配图使徒的大小
    fileprivate func calcPictureViewSize(count:Int?) -> CGSize {

        if count == 0 || count == nil{
            return CGSize()
        }
        
        //1. 计算配图视图的宽度
        //常数准备
        //2. 计算高度
        //1> 根据 count 知道行数 1 ~ 9
        let row = (count! - 1) / 3 + 1
        
        //2> 根据行数计算高度
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        
        return CGSize(width: 100, height: height)
    }
    
    /// 给定一个数字，返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - deault: 默认的字符串，转发/评论/赞
    /// - Returns: 描述结果
    /**
        如果数字 == 0，显示默认标题
     如果数量超过 10000 ，显示x.xx 万
     如果数量 < 1000 ，现实实际数字
     */
    fileprivate func countString(count:Int , defaultStr:String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    
    
    
    
    
}

