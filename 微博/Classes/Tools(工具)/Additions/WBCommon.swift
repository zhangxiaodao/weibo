
//
//  WBCommon.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/8.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation
/// 应用程序id
let WBAppKey = "2462615655"
/// 应用程序加密信息（开发者可以申请修改）
let WBAppSecret = "ced6d3b8f6c2f5b9c3fbf78b11aa5271"
/// 回调地址 - 登录完成跳转的 url 参数以 get 方式拼接
let WBRedirectURL = "http://baidu.com"

//MARK: - 全局通知定义
///用户需要登陆通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功通知
let WBUserLoginSuccessNottification = "WBUserLoginSuccessNottification"

//MARK: - 微博配图视图常量
//配图视图的外侧边距
let WBStatusPictureViewOutterMargin = CGFloat(12)
//配图视图的内侧边距
let WBStatusPictureViewInnerMargin = CGFloat(3)
//视图的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureViewOutterMargin
//每个 item 默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3



