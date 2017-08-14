//
//  CZEmoticonCell.swift
//  001-表情键盘
//
//  Created by 杭州阿尔法特 on 2017/8/2.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 表情 cell 的协议
@objc protocol CZEmoticionCellDelegate:NSObjectProtocol {
    /// 表情 cell 选中表情模型
    /// - Parameter em: 表情模型 / nil 表示删除
    func emoticionCellDidSelectedEmoticon(cell:CZEmoticonCell ,em:CZEmoticion?)
}


/// 表情的页面 Cell
/// 每一个 Cell 就是和 collectionView 一样的大小
/// 每一个 Cell 中使用，九宫格 的算法，自行添加 20 个表情
/// 最后一个位置放置删除按钮
class CZEmoticonCell: UICollectionViewCell {
    
    weak var delegate:CZEmoticionCellDelegate?
    
    var emoticons:[CZEmoticion]? {
        didSet{
            //1.隐藏所有按钮
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            //显示删除按钮
            contentView.subviews.last?.isHidden = false
            
            //2.便利表情模型数组，设置按钮图像
            for (i , em) in (emoticons ?? []).enumerated() {
                //1.取出按钮
                if let btn = contentView.subviews[i] as? UIButton {
                    /// 设置图像 - 如果 图像为 nil 会清空图像，避免复用
                    btn.setImage(em.image, for: [])
                    /// 设置 emoji 的字符串 - 如果 emoji 为 nil,会清空 title ，避免复用
                    btn.setTitle(em.emoji, for: [])
                    btn.isHidden = false
                }
            }
        }
    }
    
    private lazy var tipView = CZEmoticonTipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 当视图从界面是删除，同样会调用此方法 newWindow == nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let w = newWindow else {
            return
        }
        
        //将提示视图添加到窗口上
        w.addSubview(tipView)
    }
    
    /// 监听方法
    ///
    /// - Parameter button: 选中表情按钮
    @objc fileprivate func selectedEmoticonButton(button:UIButton) {
        
        //1.取 tag ,tag 对应的值  0~20 , 其中 20 是删除按钮
        let tag = button.tag
        
        //2.根据 tag 判断是否是删除按钮，如果不是删除按钮，取的表情
        var em:CZEmoticion?

        if tag < (emoticons?.count)! {
            em = emoticons?[tag]
        }
        
        //3. em 要么是选中的模型，如果为 nil 对应的删除按钮
        delegate?.emoticionCellDidSelectedEmoticon(cell: self, em: em)
    }
    
    /// 长按识别
    @objc fileprivate func longGesture(gesture:UILongPressGestureRecognizer) -> () {
        
        //1>获取触摸位置
        let location = gesture.location(in: self)
        
        //2>获取触摸位置对应对的按钮
        guard let button = buttonWithLocation(location: location) else {
            return
        }
        
        //3.处理手势状态
        switch gesture.state {
        case .began , .changed:
            tipView.isHidden = false
            
            //坐标系转换 -> 将按钮参照 cell 的坐标系,转换到 window 的坐标系
            let center = self.convert(button.center, to: window)
            //设置提示视图的位置
            tipView.center = center
        default:
            break
        }
        
        
        
    }
    
    fileprivate func buttonWithLocation(location:CGPoint) -> UIButton? {
        // 便利 contentView 所有的子视图，如果可见，同时在 location 确认按钮
        for btn in contentView.subviews as! [UIButton] {
            //删除按钮同样需要处理
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        return nil
    }
    
}

fileprivate extension CZEmoticonCell {
    
    /// 从 XIB 加载，bounds 是 XIB 中定义的大小，不是 size 的大小
    /// 从纯代码创建，bounds 就是布局属性设置  itemSize
    func setupUI() -> () {
        let rowCount = 3
        let colCount = 7
        
        //左右间距
        let leftMargin:CGFloat = 8
        //底部间距，为分页控件预留空间
        let bottomMargin:CGFloat = 16

        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        //连续创建 21 个按钮
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            
            
            contentView.addSubview(btn)
            
            //设置按钮的字体大小 -> 按钮的图像大小是 64 x 64 所以设置字体为32
            //lineHeight 基本上和 图片的大小差不多!
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            //设置按钮的 tag
            btn.tag = i
            //添加监听方法
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
        }
        
        //取出末尾的删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        
        //设置图像
        let image = UIImage(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: [])
        
        //添加长安手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        
        longPress.minimumPressDuration = 0.2
        addGestureRecognizer(longPress)
    }
}

extension CZEmoticion {
    
}
