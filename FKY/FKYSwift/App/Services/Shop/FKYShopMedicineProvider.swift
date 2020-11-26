//
//  FKYShopMedicineProvider.swift
//  FKY
//
//  Created by hui on 2018/11/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopMedicineProvider: NSObject {
    fileprivate var pageId = 1 //当前页码
    fileprivate var pageSize = 1 //总页码
    var totalProductsCount :Int = 0 //记录请求回来了多少个商品
    
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    // 请求中药材
    func getChineseMedicineList(_ type:Int?,callback: @escaping (_ model: [Any]?, _ message: String?)->()) {
        var parameters : [String:Any] = [:]
        if type == 1 {
            //刷新
            self.pageId = 1
            self.totalProductsCount = 0
            parameters["pageId"] = "\(self.pageId)"
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.pageId = self.pageId + 1
            parameters["pageId"] = "\(self.pageId)"
        }
        parameters["userid"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        parameters["siteCode"] = (FKYLocationService().currentLoaction.substationCode ?? "000000")
        parameters["enterpriseId"] = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()

        self.publicService?.getChineseMedicineListInfoBlock(withParam: parameters, completionBlock: { (responseObj, error) in
            guard let data = responseObj as? Dictionary<String,AnyObject> else {
                if type == 2 {
                    //加载更多
                    self.pageId = self.pageId - 1
                }
                callback(nil,error?.localizedDescription ?? "网络连接失败")
                return
            }
            if let pageNum = data["pageSize"] as? Int {
                self.pageSize = pageNum
            }
            var dataArr : [Any] = []
            if let productArr = data["templates"] as? NSArray {
                for dic in productArr {
                    if let desDic = dic as? Dictionary<String,AnyObject> {
                        if let templateType = desDic["templateType"] as? Int {
                            if templateType == 1 {
                                //轮播图
                                if let bannerDic = desDic["contents"] as? NSDictionary , let bannerArray = bannerDic["banners"] as? NSArray,let bannersTemp = bannerArray.mapToObjectArray(HomeCircleBannerItemModel.self), bannersTemp.count > 0  {
                                    dataArr.append(bannersTemp)
                                }
                            }else if templateType == 9 {
                                //产品
                                if let prdDic = desDic["contents"] as? NSDictionary , let floorDic = prdDic["productFloor"] as? NSDictionary{
                                    let prdModel = floorDic.mapToObject(FKYMedicineModel.self)
                                    //记录商品总数
                                    if let arr = prdModel.mpHomeProductDtos{
                                        self.totalProductsCount = self.totalProductsCount + arr.count
                                    }
                                    dataArr.append(prdModel)
                                }
                            }
                        }
                    }
                }
            }
            callback(dataArr,nil)
            
        })
    }
    func hasNext() -> Bool {
        return self.pageSize > self.pageId
    }
}
