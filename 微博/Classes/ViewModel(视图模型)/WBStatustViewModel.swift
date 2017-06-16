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
        
        
    }
    
    var description: String {
        return status.description
    }
    
}

