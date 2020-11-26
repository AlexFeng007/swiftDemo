//
//  LiveForecastViewModel.swift
//  FKY
//
//  Created by yyc on 2020/8/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

@objc class LiveForecastViewModel: NSObject {
    //MARK:入参数
    var activityId = "" //活动id
    
    //MARK:请求回来的数据
    var liveBaseInfo:LiveRoomBaseInfo?//直播间基本信息
    var allCouponsList = [CommonCouponNewModel]()//直播间优惠券列表
    //MARK:获取直播预告详情
    func getNoticeDetailInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveActivityNoticeInfoDetail(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                // 优惠券列表
                if  let prodArray = data.object(forKey: "coupons") as? NSArray {
                    if  let items = prodArray.mapToObjectArray(CommonCouponNewModel.self) {
                        selfStrong.allCouponsList.append(contentsOf: items)
                    }
                }
                //直播间详情
                if  let infoData = data.object(forKey: "activityDetail") as? NSDictionary {
                    selfStrong.liveBaseInfo = infoData.mapToObject(LiveRoomBaseInfo.self)
                    if  let noticeType = data.object(forKey: "hasSetNotice") as? Int {
                        selfStrong.liveBaseInfo?.hasSetNotice = noticeType
                    }
                }
                
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
