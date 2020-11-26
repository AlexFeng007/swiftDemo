//
//  FKYMessageProvider.swift
//  FKY
//
//  Created by hui on 2019/3/14.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMessageProvider: NSObject {
    
    var pageSize = 20 //每页条数(修改时需相应修改页码计算)
    //var pageTotalSize = 1 //总页码
    var currentPage = 1//当前页
    var currentListCount = 0
    
    //获取消息列表
    func getMessageList(_ isFresh:Bool,callback: @escaping (_ model: [FKYMessageModel]?, _ message: String?)->()){
        var params = ["pageSize" : "\(self.pageSize)" as AnyObject]
        if isFresh == true {
            //刷新
            currentPage = 1
            //pageTotalSize = 1
            params["pageId"] = "\(self.currentPage)" as AnyObject
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            currentPage = currentPage+1
            params["pageId"] = "\(self.currentPage)" as AnyObject
        }
        FKYRequestService.sharedInstance()?.queryHomeMessageList(withParam: params, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "请求数据失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                if isFresh == false {
                    self.currentPage = self.currentPage - 1
                }
                callback(nil,msg)
                return
            }
            // 成功
            if let data = response as? NSDictionary,let list = data["list"] as? NSArray  {
                let messageArr = list.mapToObjectArray(FKYMessageModel.self)
                self.currentListCount = messageArr?.count ?? 0
                callback(messageArr, nil)
                return
            }
            callback(nil,"暂无数据")
        })
    }
    
    func hasNext() -> Bool {
        return pageSize == currentListCount
    }
}

extension FKYMessageProvider {
    //获取消息列表
    func getNoReadMessageCountWithProvider(callback: @escaping (_ messageCount: Int?)->()){
        FKYRequestService.sharedInstance()?.queryReadNotMessageCount(withParam: nil, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                callback(0)
                return
            }
            // 成功
            if let data = response as? Int {
                callback(data)
                return
            }
            callback(0)
        })
    }
}
