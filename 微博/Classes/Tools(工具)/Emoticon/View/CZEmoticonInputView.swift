//
//  CZEmoticonInputView.swift
//  001-表情键盘
//
//  Created by 杭州阿尔法特 on 2017/8/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

fileprivate let celled = "cellID"

//表情输入视图
class CZEmoticonInputView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolbar: CZEmoticonToolbar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    /// 选中表情回调闭包属性
    fileprivate var selectedEmoticonCallBck:((_ emoticon:CZEmoticion?)->())?
    
    /// 加载并且返回 输入视图
    ///
    /// - Returns: 输入视图
    class func inputView(selectedEmoticon:@escaping (_ emoticon:CZEmoticion?)->()) -> CZEmoticonInputView {
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! CZEmoticonInputView
        
        //记录闭包
        v.selectedEmoticonCallBck = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {

        //注册可重用 cell
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: celled)
        
        //设置工具栏代理
        toolbar.delegate = self
    }
    
}

extension CZEmoticonInputView:CZEmoticonToolbarDelegate {
    func emoticonToolbarDidSelectedItemIndex(toolBar: CZEmoticonToolbar, index: Int) {
        
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        toolbar.selectedIndex = index
        
    }
}

extension CZEmoticonInputView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CZEmoticonManager.shared.packages[section].numbarOfPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1.取 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celled, for: indexPath) as! CZEmoticonCell
        //2.设置 cell - 传递对应页面的表情数据
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        cell.delegate = self
        return cell
        
    }
}

extension CZEmoticonInputView :CZEmoticionCellDelegate {
    /// 选中表情的回调
    ///
    /// - Parameters:
    ///   - cell: 分页 Cell
    ///   - em: 选中的表情，删除键为 nil
    func emoticionCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticion?) {
        
        //执行闭包回调 选中的表情
        selectedEmoticonCallBck?(em)
        
        //添加最近使用的表情
        guard let em = em else {
            return
        }
        
        //如果当前 collectionView 就是最近的分组，不提那家最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        CZEmoticonManager.shared.recentEmotion(em: em)
        
        // 刷新数据 - 第 0 组
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}

