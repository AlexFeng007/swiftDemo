//
//  VideoPlayerDetailProvider.swift
//  FKY
//
//  Created by 寒山 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class VideoPlayerDetailProvider: NSObject {
    var activityId:String?  //直播活动ID
    var currectVideoProduct:HomeCommonProductModel?//当前显示的商品
    var videoBaseInfo:HomeSecondKillModel?//基本信息
    var allVideoProductList = [HomeCommonProductModel]()//全部商品
    func getRecommendVideoInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["id"] =  self.activityId
        FKYRequestService.sharedInstance()?.requestRecommendVideo((dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.videoBaseInfo = data.mapToObject(HomeSecondKillModel.self)
                // 商品列表
                selfStrong.allVideoProductList.removeAll()
                if  let prodArray = data.object(forKey: "floorProductDtos") as? NSArray {
                    prodArray.forEach({ (dic) in
                        if let jsonDic =  dic as? [String : AnyObject] {
                            selfStrong.allVideoProductList.append(HomeCommonProductModel.transformVideoDetailModelToHomeCommonProductModel(jsonDic))
                        }
                    })
                    if selfStrong.allVideoProductList.isEmpty == false{
                        selfStrong.currectVideoProduct = selfStrong.allVideoProductList[0]
                    }
                }

                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}
