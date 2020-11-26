//
//  HomeMesageViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/2/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeMesageViewModel: NSObject {
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentIndex: Int = 1 //下一个请求页
    var type = 8 //消息类型的type
    var dataSource = [ExpiredTipsInfoModel]()
    //获取全部商品
    func getExpiredTipsInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["page"] = self.currentIndex
        dic["pageSize"] = self.pageSize
        dic["type"] =  type
        
        FKYRequestService.sharedInstance()?.queryExpiredMessage(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
               
                if selfStrong.currentIndex == 1{
                    //第一个清空数据
                    selfStrong.dataSource.removeAll()
                }
                // 商品列表
                if  let prodArray = (data as AnyObject).value(forKeyPath: "list") as? NSArray {
                    if prodArray.count == 0 ||  prodArray.count < selfStrong.pageSize{
                       selfStrong.hasNextPage = false
                   }else{
                       selfStrong.hasNextPage = true
                       selfStrong.currentIndex =  selfStrong.currentIndex + 1
                   }
                    selfStrong.dataSource.append(contentsOf: prodArray.mapToObjectArray(ExpiredTipsInfoModel.self)!)
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
