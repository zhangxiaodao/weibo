//
//  WBStatusListViewModel.swift
//  微博
//
//  Created by 杭州阿尔法特 on 2017/6/6.
//  Copyright © 2017年 张海昌. All rights reserved.
//

import Foundation
import SDWebImage
/// 封装微博数据列表视图模型

/**
    父类的选择
    - 如果类需要使用 ‘KVC‘ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
    - 如果类知识包装一些代码逻辑（写一些函数），就可以不用任何父类，好处：更加轻量级
    - 提示：如果用 OC 写，一律继承自 NSObject即可
 
 使命：负责微博的数据处理
 1.字典转模型
 2.下拉、上拉刷新数据处理
 */

/// 上拉刷新最大尝试次数
private let maxPullupTryTime = 3

class WBStatusListViewModel {
    /// 微博视图模型懒加载
    lazy var statusList = [WBStatustViewModel]()
    /// 上拉刷新错误次数
    private var pullupErrorTime = 0
    
    /// 加载微博列表
    /// - Parameter pullup: 是否是上拉刷新标记
    /// - Parameter completion: 完成回调（网络请求是否成功 , 是否有更多的上拉刷新）
    func loadStatus(pullup:Bool , completion:@escaping (_ isSuccess:Bool ,_ shouldRefresh:Bool)->()) -> () {
        
        //判断是否是上拉刷新，同时检查 刷新错误
        if pullup && pullupErrorTime > maxPullupTryTime {
            completion(false , false)
            return
        }
        
        //since_id 取出数组中第一条微博的 id
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        //发起网络请求，加载微博数据 [字典的数组]
        WBNetworkManager.shared.statusList(since_id:since_id , max_id: max_id) { (json, isSuccess) in
            
            //0.如果网络请求失败，直接执行完成回调
            if !isSuccess {
                completion(false, false)
                return
            }
            
            //1. 遍历字典数组，字典转 模型 => 视图模型，将视图模型添加到数组
            var array = [WBStatustViewModel]()
            
            for dict in json ?? [] {
                //1>创建微博模型
                let status = WBStatus()
                
                //2>使用字典设置模型数值
                status.yy_modelSet(with: dict)
                
                //3>使用 ‘微博’ 模型创建 ‘微博视图’ 模型
                let viewModel = WBStatustViewModel(model: status)
                array.append(viewModel)
            }
            
            //视图模型创建完成
            print("刷新了\(array.count)条数据\(array)")
            
            //2.拼接数据
            if pullup {
                //上拉刷新，
                self.statusList = self.statusList + array
            } else {
                //下拉刷新，应该把结果拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            //3.判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTime += 1
                completion(false , false)
            } else {
                
                self.cacheSingleImage(list: array , finish: completion)
                
                //3.完成回调
                completion(isSuccess , true)

            }
        }
    }
    
    /// 缓存本次下载微博数据数组中的单张图片
    ///
    /// - Parameter list: 本次下载的视图模型数组
    fileprivate func cacheSingleImage(list:[WBStatustViewModel] , finish:@escaping (_ isSuccess:Bool ,_ shouldRefresh:Bool)->()) {
        
        //调度组
        let group = DispatchGroup()
        
        //记录数据长度
        var length = 0
        
        //遍历数组，查找微博数据中有单张图像的，进行缓存
        for vm in list {
            
            //1> 判断图像数量
            if vm.picURLs?.count != 1{
                continue
            }
            
            //2. 代码执行到此，数组中有且只有一张图片 -> 获取 图像模型
            guard let pic = vm.picURLs?[0].thumbnail_pic ,
                let url = URL(string: pic)
                else {
                    continue
            }

            
            //3> 下载图像
            //1) downloadImage 是 SDWebImage 的核心方法
            //2) 图像下载完成之后，会自动保存在沙盒中，文件路径是 URL 的 md5 
            //3) 如果沙河中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒地图像
            //4) 不会发起网络请求，同时，回调方法，同样会调用。
            //5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再发起网络请求!
            //*** 注意要缓存的图像过大 -> 找后台要  小图像的借口
            
            //A> 入组
            group.enter()
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                //将图像转换成二进制
                if let image = image,
                    let data = UIImagePNGRepresentation(image)  {
                    //OC NSData 的长度是 .length , Swift Data 的长度是 .count
                    length += data.count
                    
                    vm.updateSingleImage(image: image)
                }
                
                print("缓存的图像是 \(String(describing: image)) 大小\(length)")
                
                //B> 出组
                group.leave()
            })
            
        }
        
        //C> 监听调度组情况
        group.notify(queue: DispatchQueue.main) { 
            print("图像缓存完成 \(length / 1024) K")
            
            finish(true, true)
        }
    }
    
    
    
    
}
