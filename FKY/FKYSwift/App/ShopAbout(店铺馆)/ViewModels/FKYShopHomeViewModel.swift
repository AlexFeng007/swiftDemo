//
//  FKYShopHomeViewModel.swift
//  FKY
//
//  Created by yyc on 2020/10/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 请求店铺馆三个标题

import UIKit

class FKYShopHomeViewModel: NSObject {
    
    //店铺馆首页
    var hasNavigationBtn = false //是否有导航按钮楼层
    var shopActivityArr = [Any]() //首页楼层数组
    var hasNextPage = true  //判断是否有下一页
    var currentPage: Int = 1   //当前页加载页 已有的
    
    //店铺馆标题请求
    var tabTitleArr = [String]() //标题数组
    
    func getShopHomeTabTitleList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        var siteCodeStr = "000000"
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let code = user.substationCode {
                if code.toNSNumber().intValue != 0 {
                    siteCodeStr = code
                }
            }
        }
        dic["siteCode"] = siteCodeStr
        
        FKYRequestService.sharedInstance()?.requestForTabTitleListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                selfStrong.tabTitleArr.removeAll()
                if let tab = data["tabName1"] as? String {
                    selfStrong.tabTitleArr.append(tab)
                }
                if let tab = data["tabName2"] as? String {
                    selfStrong.tabTitleArr.append(tab)
                }
                if let tab = data["tabName3"] as? String {
                    selfStrong.tabTitleArr.append(tab)
                }
                block(true, "获取成功")
                return
            }
            block(false, "获取失败")
        })
    }
}

//MARK:请求店铺馆首页
extension FKYShopHomeViewModel{
    func getShopHomeActivityList(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        var siteCodeStr = "000000"
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let code = user.substationCode {
                if code.toNSNumber().intValue != 0 {
                    siteCodeStr = code
                }
            }
        }
        dic["siteCode"] = siteCodeStr
        
        FKYRequestService.sharedInstance()?.requestForMPHomeShopActivityListInShopCollection(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
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
                    selfStrong.shopActivityArr.removeAll()
                }
                //是否有下一页
                if  let hasNextPage = data.object(forKey: "hasNextPage") as? Bool {
                    selfStrong.hasNextPage = hasNextPage
                }
                //店铺馆首页返回活动楼层
                selfStrong.hanldActivityData(data)
                block(true, "获取成功")
                return
            }
            selfStrong.hasNextPage = false
            block(false, "获取失败")
        })
    }
    //MARK:处理请求回来的数据
    /*
     templateType == 2 导航按钮
     templateType == 10 公告
     templateType == 11 中通广告
     templateType == 12 药城精选
     templateType == 13 优质商家
     */
    fileprivate func hanldActivityData(_ data : NSDictionary) {
        if  let activityArr = data.object(forKey: "list") as? NSArray, activityArr.count > 0{
            for activityDic in activityArr {
                if let dic =  activityDic as? NSDictionary ,let templateType = dic.object(forKey: "templateType") as? Int , let contentDic = dic.object(forKey: "contents") as? NSDictionary{
                    if templateType == 2 {
                        //MARK:导航按钮
                        if let navArr = contentDic.object(forKey: "MpNavigation") as? NSArray {
                            if let list = navArr.mapToObjectArray(HomeFucButtonItemModel.self),list.count > 0{
                                var navigations = [HomeFucButtonItemModel]()
                                //大于10的时候，必须是2的倍数
                                var arr = list
                                if arr.count > 10 {
                                    if arr.count%2 != 0 {
                                        arr.removeLast()
                                    }
                                }
                                //大于两行数组重新组合数组()
                                if arr.count >= 10 {
                                    let halfNum = arr.count/2
                                    for i in 0...arr.count {
                                        if i < halfNum {
                                            let model1 = arr[i]
                                            model1.indexNum = i
                                            navigations.insert(model1, at: 2*i)
                                            let model2 = arr[i+halfNum]
                                            model2.indexNum = i+halfNum
                                            navigations.insert(model2, at: 2*i+1)
                                        }
                                    }
                                }else {
                                    navigations.append(contentsOf: arr)
                                }
                                if navigations.count > 0 {
                                    self.shopActivityArr.append(navigations)
                                    self.hasNavigationBtn = true
                                }else {
                                    self.hasNavigationBtn = false
                                }
                                
                            }
                        }
                    }else if templateType == 10 {
                        //MARK:公告
                        if let noticeArr = contentDic.object(forKey: "notice") as? NSArray {
                            if let list = noticeArr.mapToObjectArray(HomePublicNoticeItemModel.self){
                                self.shopActivityArr.append(list)
                            }
                        }
                    }else if templateType == 11 {
                        //MARK:中通广告
                        if let selectedDic = contentDic.object(forKey: "zhongtong") as? NSDictionary {
                            let secModel = selectedDic.mapToObject(HomeADInfoModel.self)
                            self.shopActivityArr.append(secModel)
                        }
                        
                    }else if templateType == 12 {
                        //MARK:药城精选
                        if let selectedDic = contentDic.object(forKey: "selectedProducts") as? NSDictionary {
                            let secModel = selectedDic.mapToObject(HomeSecdKillProductModel.self)
                            self.shopActivityArr.append(secModel)
                        }
                    }else if templateType == 13 {
                        //MARK:优质商家
                        if let highShopDic = contentDic.object(forKey: "HighQualityShops") as? NSDictionary,let iconArr = highShopDic.object(forKey: "iconImgDTOList") as? NSArray  {
                            if let list = iconArr.mapToObjectArray(HighQualityShopsItemModel.self),list.count > 0{
                                self.shopActivityArr.append(list)
                            }
                        }
                    }
                }
            }
            self.currentPage += 1
        }
    }
}
