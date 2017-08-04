//
//  CZEmoticonLayout.swift
//  001-表情键盘
//
//  Created by 杭州阿尔法特 on 2017/8/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 表情集合视图的布局
class CZEmoticonLayout: UICollectionViewFlowLayout {

    /// prepare 就是 OC 中 的 prepareLayout
    override func prepare() {
        super.prepare()
        
        //在此方法中， collectionView 的大小已经确定
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        
        //水平方向滚动
        scrollDirection = .horizontal
        
        
    }
}
