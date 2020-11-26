//
//  LiveViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveViewModel: NSObject {
    var source: String = "1"//1：正常进来 2：口令进来
    let pageSize = 10
    var hasNextPage = true  //判断是否有下一页
    var totalProductNum = 0  //直播商品总数
    var currentPage: Int = 1   //当前页加载页 已有的
    var activityId:String?  //直播活动ID
    var currectLiveProduct:HomeCommonProductModel?//当前正在直播的商品
    var liveBaseInfo:LiveRoomBaseInfo?//直播间基本信息
    var siteProductList = [HomeCommonProductModel]()//直播间坑位商品列表
    var allLiveProductList = [HomeCommonProductModel]()//直接全部商品
    var allCouponsList = [CommonCouponNewModel]()//直播间优惠券列表
    var liveActivityList = [LiveInfoListModel]()//直播预告回放列表
    var liveAllNum = "0"  //    总人数    number    @mock=44
    var liveAllTimes = "0"  //    总人次    number    @mock=300
    var liveOnlineNum = "0" //    在线人数    number    @mock=2
    var liveRedPacketModel :LiveRoomRedPacketInfo? //直播间口令红包模型
    var liveRedPacketGetInfoModel : LiveRedPacketResultModel? //直播间口令红包获取结果模型
    var getCouponModel:CommonCouponNewModel? //领取优惠券后返回的模型，用于重置优惠券列表返回数据（优惠券列表返回的数据未领取和领取不同）
    //MARK:获取直播间信息（包含获取直播分享信息）
    func getLiveRoomBaseInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        dic["source"] =  self.source
        FKYRequestService.sharedInstance()?.getLiveActivityDetailfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.liveBaseInfo = data.mapToObject(LiveRoomBaseInfo.self)
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:获取当前直播坑位商品
    func getLiveSiteProductList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveRecomendProduct(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
            if let productList = response as? NSArray {
                selfStrong.siteProductList.removeAll()
                let items = productList.mapToObjectArray(HomeCommonProductModel.self)!
                selfStrong.siteProductList.append(contentsOf: items)
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:获取全部商品
    func getAllLiveProductInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        dic["pageSize"] = self.pageSize
        dic["page"] = self.currentPage
        FKYRequestService.sharedInstance()?.getLiveAllProduct(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                    selfStrong.allLiveProductList.removeAll()
                }
                //总个数
                if  let rows = data.object(forKey: "rows") as? Int {
                    selfStrong.totalProductNum = rows
                }
                //是否有下一页
                if  let hasPage = data.object(forKey: "hasNextPage") as? Bool {
                    selfStrong.hasNextPage = hasPage
                }
                // 商品列表
                if  let prodArray = data.object(forKey: "result") as? NSArray {
                    let items = prodArray.mapToObjectArray(HomeCommonProductModel.self)!
                    selfStrong.allLiveProductList.append(contentsOf: items)
                    selfStrong.currentPage += 1
                }
                block(true, "获取成功")
                return
            }
            selfStrong.hasNextPage = false
            block(false, "获取失败")
        })
    }
    //MARK:获取当前讲解商品
    func getLiveCurrectProductInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveCurrecrProduct(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.currectLiveProduct = data.mapToObject(HomeCommonProductModel.self)
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:获取优惠券
    func getLiveCouponsListInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveActivityCouponsList(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
            if let arr = response as? NSArray {
                selfStrong.allCouponsList.removeAll()
                if let getArr = arr.mapToObjectArray(CommonCouponNewModel.self) {
                    selfStrong.allCouponsList = getArr
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:直播口令分享解密
    func getLiveCommendDecrypt(_ commend:String?,block: @escaping (Bool, String?, LiveCommandInfoModel?)->()) {
        let dic = NSMutableDictionary()
        dic["commend"] =  commend
        FKYRequestService.sharedInstance()?.getLiveCommendDecrypt(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败",nil)
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
                block(false, msg,nil)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                let commandInfo:LiveCommandInfoModel = dic.mapToObject(LiveCommandInfoModel.self)
                block(true, "获取成功",commandInfo)
                return
            }
            block(false, "获取失败",nil)
        })
    }
    //MARK:直播间人数
    func getLiveRoomPersonNum(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveActivityPerson(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
            if let dic = response as? NSDictionary {
                if let allNum = dic["allNum"]{
                    selfStrong.liveAllNum = ("\(allNum)")
                }
                if let allTimes = dic["allTimes"]{
                    selfStrong.liveAllTimes = ("\(allTimes)")
                }
                if let onlineNum  = dic["onlineNum"]{
                    selfStrong.liveOnlineNum = ("\(onlineNum)")
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    
    //MARK:直播口令红包
    func getLiveRedPacketActivityInfo(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  self.activityId
        FKYRequestService.sharedInstance()?.getLiveActivityRedPacketInfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
            selfStrong.liveRedPacketModel = nil
            if let dic = model as? LiveRoomRedPacketInfo,let str = dic.redPacketPwd, str.count > 0 {
                selfStrong.liveRedPacketModel = dic
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:红包口令获取情况
    func getRedPacketGetInfoDetail(block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["drawId"] = self.liveRedPacketModel?.redPacketId
        FKYRequestService.sharedInstance()?.getLiveActivityRedPacketGetInfoDetail(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
            selfStrong.liveRedPacketGetInfoModel = nil
            if let dic = model as? LiveRedPacketResultModel {
                selfStrong.liveRedPacketGetInfoModel = dic
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
    //MARK:直播活动状态
    func getLiveStatus(_ liveActivityId:String?,block: @escaping (Bool, String?, Int)->()) {
        let dic = NSMutableDictionary()
        dic["activityId"] =  liveActivityId ?? ""
        FKYRequestService.sharedInstance()?.getLiveStatus(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "请求失败",-1)
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
                block(false, msg,-1)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                //0：直播中，1：已结束，2：预告
                if let status = dic["status"] as? Int{
                    block(true, "获取成功",status)
                    return
                }
                block(false, "获取失败",-1)
                return
            }
            block(false, "获取失败",-1)
        })
    }
    //MARK:领取优惠券
    func getLiveRecieveCouponInfo(_ templateCode:String?,block: @escaping (Bool, String?)->()) {
        let dic = NSMutableDictionary()
        dic["template_code"] =  templateCode ?? ""
        FKYRequestService.sharedInstance()?.getLiveActivityReceiveCouponInfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "领取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let couponModel =  model as? CommonCouponNewModel {
                selfStrong.getCouponModel = couponModel
                block(true, "领取成功")
                return
            }
            block(false, "领取失败")
        })
    }
    //MARK:直播列表
    //MARK:预告列表
    //MARK:短视频列表
    func getLiveActivityList(_ tab:String?,block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["tab"] =  tab ?? "" //1：直播列表页，2：预告列表页
        dic["pageSize"] = self.pageSize
        dic["page"] = self.currentPage
        dic["from"] =  "1" //1：药城,2：药网,3：医院
        FKYRequestService.sharedInstance()?.getLiveActivityList(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                //总个数
                if  let rows = data.object(forKey: "totalCount") as? Int {
                    selfStrong.totalProductNum = rows
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
    //MARK:开播提醒/取消提醒
    func setLiveActivityNotice(_ type:Int,_ liveActivityId:String,block: @escaping (Bool, String?, Int)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["type"] =  type //1：设置 2：取消
        dic["activityId"] = liveActivityId
        FKYRequestService.sharedInstance()?.setLiveActivityNoticeWithParam((dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "设置失败",-1)
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "设置失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg,-1)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                //0：成功 1失败
                if let status = dic["status"] as? Int{
                    block(true, "设置成功",status)
                    return
                }
                block(false, "设置失败",-1)
                return
            }
            block(false, "设置失败",-1)
        })
    }
    //MARK:直播结束视频回放列表     ---》录播列表
    //MARK:主播详情
    //MARK:直播预告详情
    //MARK:直播列表切换
    func setLiveType(block: @escaping (Bool, String?, Int)->()) {
        // 传参
        FKYRequestService.sharedInstance()?.getLiveTypeInfo(withParam: nil, completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "获取失败",-1)
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
                block(false, msg,-1)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                //0：成功 1失败
                if let status = dic["liveListType"] as? Int{
                    block(true, "获取成功",status)
                    return
                }
                block(false, "获取失败",-1)
                return
            }
            block(false, "获取失败",-1)
        })
    }
    
}
