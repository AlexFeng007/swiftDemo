//
//  NewHomeViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页viewmodel

import UIKit

class NewHomeViewModel: NSObject {
    let pageSize = 10
    var dataSource: Array<HomeBaseCellProtocol> = [] //配置楼层数据
    var nextPageId = 1
    var totalItemCount = 0
    var totalPageCount = 0
    var hasNextPage = true //首页常购清单判断数据
    var currentIndex: Int = 0
    var hasNavFunc: Bool = false                 // 判断是否有导航按钮 UI用
    var hotSearchArr : [String]? //热搜词
    //首页的为您推荐属性
    var cellRecommendProductArr = [HomeRecommendProductItemModel]() //推荐商品列表数据
    var recoomendPageSize = 10 //每页条数(修改时需相应修改页码计算)
    var recoomenCurrentPage = 1//本期认购当前页
    var recoomenPageTotalSize = 1 //总页码.
    /// 未读消息数量
    var unreadMsgCount:Int = 0
    //店铺时间戳的key
    var pageTimeStampKey: String?{
        get{
            if FKYLoginAPI.loginStatus() != .unlogin {
                if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let userId = user.userId {
                    return "\(userId)" + "Home_PageTimeStamp"
                }
            }
            return "Home_PageTimeStamp"
        }
    }
    //首页时间戳
    var pageTimeStamp: String?{
        get{
            let str = UserDefaults.standard.value(forKey: (self.pageTimeStampKey ?? "Home_PageTimeStamp"))
            if str != nil { return String(describing: str!) }
            return ""
        }
    }
}

// MARK: - Private
extension NewHomeViewModel {
    func getSiteCode() -> String {
        let siteCode = FKYLocationService().currentLoaction.substationCode
        if let site = siteCode, site.isEmpty == false {
            return site
        }
        else {
            return "000000"
        }
    }
}

// MARK: - Request
extension NewHomeViewModel {
    
    //MARK:未读消息数量
    func getUnreadCount(block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.getUnreadCount(nil, completionBlock: {[weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false,"内存溢出")
                return
            }
            weakSelf.unreadMsgCount = response as? Int ?? 0
            block(true,"")
        })
    }
        
        
    //MARK: 新版首页楼层列表接口
    func getHomenFloorList(block: @escaping (Bool, String?)->()) {
        // 传参
      //  print("\(self.pageTimeStamp?.)")
        let parameters = ["siteCode": self.getSiteCode() as Any,"pageId":self.nextPageId,"pageTimeStamp":self.pageTimeStamp as Any] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomenFloorList(withParam: parameters, completionBlock: {[weak self]  (success, error, response, model) in
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
                        selfStrong.dataSource.removeAll()
                    }
                }
                selfStrong.nextPageId += 1
                block(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // 保存name
                if selfStrong.nextPageId == 1{
                    selfStrong.dataSource.removeAll()
                    //缓存第一页数据
                    WUCache.cacheObject(data , toFile: HomeString.NEW_HOME_RECOMMEDN)
                }
                let model = data.mapToObject(HomeRecommendProductModel.self)
                if selfStrong.nextPageId == 2,let timeStamp = model.pageTimeStamp,timeStamp.isEmpty == false{
                    //保存时间戳
                    UserDefaults.standard.set(timeStamp, forKey: (selfStrong.pageTimeStampKey ?? "Home_PageTimeStamp"))
                    UserDefaults.standard.synchronize()
                }
                selfStrong.handleHomeProductModel(model)
                selfStrong.nextPageId += 1
                block(true, "获取成功")
                return
            }
            selfStrong.nextPageId += 1
            block(false, "获取失败")
        })
    }
    //MARK:首页推荐数据处理
    fileprivate func handleHomeProductModel(_ model:HomeRecommendProductModel) {
        if let list = model.list, list.count > 0 {
            // self.hasNextPage = true
            if self.nextPageId == 1{
                self.dataSource.removeAll()
                self.hasNavFunc = model.hasNavFunc
                self.hotSearchArr = model.hotSearchArr
            }
            self.dataSource.append(contentsOf: list)
        }
    }
    //MARK:获取用户站点
    func fetchUserLocation(finishedCallback: @escaping (String?) -> ()) {
        if FKYLoginAPI.loginStatus() == .loginComplete {
            let userModel = FKYLoginService.currentUser()
            if userModel?.substationName != nil {
                let m = FKYLocationModel()
                m?.substationCode = userModel?.substationCode
                m?.substationName = userModel?.substationName
                m?.isCommon = 0
                m?.showIndex = 1
                FKYLocationService().setCurrentLocation(m)
                finishedCallback(m?.substationName)
            } else {
                finishedCallback(FKYLocationService().currentLocationName())
            }
        } else {
            var stationname = "默认"
            if FKYLocationService().currentLoaction == nil {
                let model = FKYLocationModel.default()
                stationname = (model?.substationName)!
            } else {
                stationname = FKYLocationService().currentLocationName()
            }
            finishedCallback(stationname)
        }
    }
    
    //MARK:获取用户缓存数据
    //MARK:获取首页推荐楼层  缓存数据
    func fetchHomeRecommendCacheData(block: @escaping (Bool, String?)->()) {
        
        guard let data = WUCache.getCachedObject(forFile: HomeString.NEW_HOME_RECOMMEDN) as? NSDictionary else {
            block(false,"")
            return
        }
        
        let model = data.mapToObject(HomeRecommendProductModel.self)
        self.dataSource.removeAll()
        //        self.resetHomeRecommendModels()
        self.handleHomeProductModel(model)
        //        if self.sectionType.count > 0 {
        //            self.currentType = self.sectionType[0]
        //        }
        block(true,"")
        return
        
    }
}

extension NewHomeViewModel {
    
    //MARK:请求为您推荐列表
    func getRecommendForYouWithProductList(_ isFresh:Bool,callback: @escaping (_ hasMoreData:Bool,_ message: String?)->()) {
        var params = [String:Any]()
        params["pageSize"] = self.recoomendPageSize
        if isFresh == true {
            self.recoomenCurrentPage = 1
            self.recoomenPageTotalSize = 1
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.recoomenCurrentPage = 1 + self.recoomenCurrentPage
        }
        params["pageId"] = self.recoomenCurrentPage
        FKYRequestService.sharedInstance()?.fetchHomeRecommendForYou(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                if isFresh == false {
                    strongSelf.recoomenCurrentPage = strongSelf.recoomenCurrentPage-1
                }
                let msg = error?.localizedDescription ?? "获取失败"
                callback(strongSelf.hasNext(),msg)
                return
            }
            if let data = response as? Dictionary<String,AnyObject> , let getArr = data["list"] as? NSArray ,let arr = getArr.mapToObjectArray(HomeRecommendProductItemModel.self) {
                if let num = data["totalPageCount"] as? Int {
                    strongSelf.recoomenPageTotalSize = num
                }
                if isFresh == true {
                    strongSelf.cellRecommendProductArr.removeAll()
                }
                strongSelf.cellRecommendProductArr.append(contentsOf: arr)
                callback(strongSelf.hasNext(),nil)
            }
        })
    }
    func hasNext() -> Bool {
        return self.recoomenPageTotalSize > self.recoomenCurrentPage
    }
    
}
//是否有惊喜提示view
extension NewHomeViewModel {
    func getSurpriseTipViewYesOrFlase(callback: @escaping (_ showTip:String, _ tipStr: String?)->()) {
        FKYRequestService.sharedInstance()?.fetchHomeSurpriseTipViewYesOrFalse(withParam: nil, completionBlock: {(success, error, response, model) in
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callback("0",msg)
                return
            }
            if let data = response as? Dictionary<String,AnyObject>{
                var showTip = "0"
                var tipStr = ""
                if let open = data["isOpen"] as? String {
                    showTip = open
                }
                if let str = data["showText"] as? String {
                    tipStr = str
                }
                callback(showTip,tipStr)
            }else {
                callback("0","")
            }
        })
    }
}
