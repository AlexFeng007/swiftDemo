//
//  FKYRecommendViewModel.swift
//  FKY
//
//  Created by yyc on 2020/4/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRecommendViewModel: NSObject {
    
    var pageSize = 10 //每页条数(修改时需相应修改页码计算)
    var currentPage = 1//本期认购当前页
    var pageTotalSize = 1 //总页码
    var recommendArr = [HomeCommonProductModel]() //记录请求回来的推荐商品数组
    //请求新品登记列表
    func getShopRecommendProductList(_ isFresh:Bool, _ enterpriseId:String? ,callback: @escaping (_ hasMoreData:Bool,_ model: [HomeCommonProductModel]?,_ message: String?)->()) {
        var params = [String : Any]()
        params["pageSize"] = self.pageSize
        params["enterpriseId"] = enterpriseId ?? ""
        if isFresh == true {
            self.currentPage = 1
            self.pageTotalSize = 1
            self.recommendArr.removeAll()
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.currentPage = 1 + self.currentPage
        }
        params["pageId"] = self.currentPage
        FKYRequestService.sharedInstance()?.requestForGetShopRecommendProductListInfo(withParam: params, completionBlock: { [weak self ] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                if isFresh == false {
                    strongSelf.currentPage = strongSelf.currentPage-1
                }
                let msg = error?.localizedDescription ?? "获取失败"
                callback(strongSelf.hasNext(),nil,msg)
                return
            }
            if let desModel = model as? FKYShopRecommendInfoModel , let arr = desModel.productList {
                strongSelf.pageTotalSize = desModel.totalPageCount ?? 1
                for recomendModel in arr {
                    //不显示本月已售数量
                    recomendModel.pmDescription = ""
                }
                strongSelf.recommendArr = strongSelf.recommendArr + arr
                callback(strongSelf.hasNext(),strongSelf.recommendArr ,nil)
            }else {
                callback(strongSelf.hasNext(),nil,"网络连接失败")
            }
        })
    }
    func hasNext() -> Bool {
        return self.pageTotalSize > self.currentPage
    }
}
extension FKYRecommendViewModel {
    func getShopOpreateCellList( _ enterpriseId:String? ,callback: @escaping (_ model: [Any]?,_ hasNavList:Bool?,_ message: String?)->()) {
        var params = [String : Any]()
        params["enterpriseId"] = enterpriseId ?? ""
        FKYRequestService.sharedInstance()?.requestForGetShopOperateCellProductListInfo(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callback(nil,false,msg)
                return
            }
            if let desModel = model as? FKYShopOperateCellModel,let cellArr = desModel.cellList{
                callback(cellArr,desModel.hasNavList,nil)
            }else {
               callback(nil,false,"网络连接失败")
            }
        })
    }
}

