//
//  LiveAnchorInfoViewModel.swift
//  FKY
//
//  Created by yyc on 2020/9/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveAnchorInfoViewModel: NSObject {
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var currentPage: Int = 1   //当前页加载页 已有的
    
    var roomId = ""
    //返回数据
    var totalProductNum = 0  //直播商品总数
    var liveActivityList = [LiveInfoListModel]()//直播预告回放列表
    var roomName = "" // 直播间名称
    var roomLogo = "" // 直播间logo
    
    //MARK:短视频列表
    func getLiveActivityListWithAnchorInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["roomId"] = self.roomId
        dic["pageSize"] = self.pageSize
        dic["page"] = self.currentPage
        FKYRequestService.sharedInstance()?.getLiveActivityAnchorMainInfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.hasNextPage = false
                block(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                if selfStrong.currentPage == 1{
                    //第一个清空数据
                    selfStrong.liveActivityList.removeAll()
                }
                
                if  let rows = data.object(forKey: "totalCount") as? Int {
                    selfStrong.totalProductNum = rows
                }
                if  let str = data.object(forKey: "roomLogo") as? String {
                    selfStrong.roomLogo = str
                }
                if  let str = data.object(forKey: "roomName") as? String {
                    selfStrong.roomName = str
                }
                // 商品列表
                if  let productList = data.object(forKey: "list") as? NSArray {
                    let items = productList.mapToObjectArray(LiveInfoListModel.self)
                    selfStrong.liveActivityList.append(contentsOf: items!)
                    selfStrong.currentPage += 1
                    //是否有下一页
                    selfStrong.hasNextPage = (selfStrong.liveActivityList.count < selfStrong.totalProductNum)
                }
                block(true, "获取成功")
                return
            }
            selfStrong.hasNextPage = false
            
            block(false, "获取失败")
        })
    }

}
