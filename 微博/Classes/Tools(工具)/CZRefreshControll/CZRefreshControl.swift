//
//  CZRefreshControl.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/22.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import UIKit

/// 刷新状态切换的临界点
fileprivate let CZRefreshOffset:CGFloat = 60

/// 刷新状态
///
/// - Normal: 什么都不做，普通状态
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且开始刷新
enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/**
    面试的时候询问道下拉刷新的问题的回答:
    自己写的或是使用第三方框架实现。本质原理是：使用 KVO 做的，监听 scrollerView 的 contentOffset ，在willMove 的时候添加 KVO,在 removeFromSuperView 的时候移除监听
 */

/// 刷新控件 - 负责刷新的相关的 ‘逻辑处理’
class CZRefreshControl: UIControl {

    //使用 weak 是为了避免循环引用的问题
    private weak var scrollView:UIScrollView?

    /// 刷新视图
    fileprivate lazy var refreshView:CZRefreshView = CZRefreshView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    
    /**
     willMove 会在 addSubview 方法是调用
     - 当添加到父视图的时候，newSuperview 是父视图
     - 当父视图移除，newSuperview 为 nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //判断父视图对象
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        //记录父视图
        scrollView = sv
        
        //KVO 监听父视图 的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    //本视图从俯视图上移除
    //提示：所有框架的的下拉刷新，都是监听父视图的 contentOfset
    //所有框架的 KVO 监听实现思路都是这个!
    override func removeFromSuperview() {
        // superView 还存在 
        //移除监听(scrollView 此时已经不存在，但是父视图还在，scrollView 中保存的就是父视图。所以在父视图上移除监听)
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        // superView 不存在
    }
    
    //所有 KVO 方法统一调用此方法
    //在程序中，通常只监听某一个对象的某几个属性，如果属性太多，方法会很乱!
    //观察者模式，在不需要的时候，都需要释放
    // - 通知中心：如果不释放，什么都不会发生，但是会有内存泄漏的问题，会有多次注册的问题。
    // - KVO：如果不释放，会崩溃。
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //contentOffset 的 y 值跟 contentInset 的 top 有关
        //print(scrollView?.contentOffset ?? "0")
        
        guard let sv = scrollView else {
            return
        }
        
        //初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        //可以根据高度设置刷新控件的 frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        //判断临界点
        if sv.isDragging {
            if height > CZRefreshOffset && (refreshView.refreshState == .Normal){
                print("放手刷新")
                refreshView.refreshState = .Pulling
            } else if height <= CZRefreshOffset && (refreshView.refreshState == .Pulling) {
                print("再使劲...")
                refreshView.refreshState = .Normal
            }
        } else {
            //放手
            if refreshView.refreshState == .Pulling {
                print("准备开始刷新")
                
                beginRefreshing()
                
                //发送刷新数据事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    /// 开始刷新
    func beginRefreshing() -> () {
        print("开始刷新")
        
        //判断父视图
        guard let sv = scrollView else {
            return
        }
        
        //判断是否正在刷新，如果是在刷新，直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        //刷新结束之后，将 状态修改为 .Normal 才能继续响应刷新
        refreshView.refreshState = .WillRefresh
        
        //让整个刷新视图能够显示出来
        //解决方法 - 修改表格的 contentInset
        var inset = sv.contentInset
        inset.top += CZRefreshOffset
        sv.contentInset = inset
        
    }

    /// 结束刷新
    func endRefreshing() -> () {
        print("结束刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        //判断刷新状态，是否在刷新，如果不是没直接返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        //回复刷新视图的状态
        refreshView.refreshState = .Normal
        //回复表格视图的 contentInset
        var inset = sv.contentInset
        inset.top -= CZRefreshOffset
        sv.contentInset = inset
        
    }
    
}


extension CZRefreshControl {
    
    fileprivate func setUI() -> () {
        backgroundColor = super.backgroundColor
        
        //设置超出边界不显示
        // clipsToBounds = true
        
        //添加刷新视图
        addSubview(refreshView)
        
        //自动布局 - 设置 xib 控件自动布局，需要制定宽高约束
        //提示：iOS程序猿，一定要会使用原声的写法，因为：如果自己开发框架，不能使用任何的自动布局框架
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
        
        
    }
}
