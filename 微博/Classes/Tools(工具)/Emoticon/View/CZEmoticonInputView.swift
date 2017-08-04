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
    
    @IBOutlet weak var toolbar: UIView!
    
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
//        let nib = UINib(nibName: "CZEmoticonCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: celled)
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: celled)
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
    func emoticionCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticion?) {
        
        //执行闭包回调 选中的表情
        selectedEmoticonCallBck?(em)
        
    }
}

