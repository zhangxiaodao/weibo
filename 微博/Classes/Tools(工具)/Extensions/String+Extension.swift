//
//  String+Extension.swift
//  001-正则体验
//
//  Created by 杭州阿尔法特 on 2017/6/29.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation

/**
 2.创建 正则表达式
 0> pattern - 匹配方案 , 常说的正则表达式，就是 pattern 的写法(匹配方案)
  0 : 和匹配方案完全一致的字符串
  1 : 第一个 () 中的内容
  2 : 第二个 () 中的内容
  ... 索引从左到右顺序递增
 
  对于模糊匹配，如果是关心的内容，就是用 (.*?),然后通过索引可以获取结果
  如果不关心的内容，就是 '.*?' ，可以匹配任意的内容
 */

extension String {
    //从当前字符串中，提取链接和文本
    //Swift 中提供了'元组'，同时返回多个值
    func cz_href() -> (link:String , text:String)? {
        //0.匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        //1.创建正则表达式，并且匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSMakeRange(0, characters.count))
            else {
            return nil
        }
        //2.获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link , text)
        
        
    }
}
