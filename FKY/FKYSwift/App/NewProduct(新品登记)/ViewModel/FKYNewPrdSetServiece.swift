//
//  FKYNewPrdSetServiece.swift
//  FKY
//
//  Created by yyc on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewPrdSetServiece: NSObject {
    var pageSize = 10 //每页条数(修改时需相应修改页码计算)
    var currentPage = 1//本期认购当前页
    var pageTotalSize = 1 //总页码
    //请求新品登记列表
    func getNewProductList(_ isFresh:Bool,callback: @escaping (_ hasMoreData:Bool,_ model: [FKYNewPrdSetItemModel]?,_ message: String?)->()) {
        var params = ["pageSize" : self.pageSize]
        if isFresh == true {
            self.currentPage = 1
            self.pageTotalSize = 1
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.currentPage = 1 + self.currentPage
        }
        params["pageNo"] = self.currentPage
        FKYRequestService.sharedInstance()?.requestForGetNewProductSetList(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
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
            if let desModel = model as? FKYNewPrdSetModel {
                strongSelf.pageTotalSize = desModel.allPages ?? 1
                callback(strongSelf.hasNext(),desModel.newPrdArr,nil)
            }else {
                callback(strongSelf.hasNext(),nil,"网络连接失败")
            }
        })
    }
    func hasNext() -> Bool {
        return self.pageTotalSize > self.currentPage
    }
    //请求新品登记详情
    func getNewProductDetail(_ newPrdId:String,callback: @escaping (_ model: FKYNewPrdSetItemModel?,_ message: String?)->()) {
        let params = ["id" : newPrdId]
        FKYRequestService.sharedInstance()?.requestForGetNewProductSetDetail(withParam: params, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callback(nil,msg)
                return
            }
            if let desModel = model as? FKYNewPrdSetItemModel {
                callback(desModel,nil)
            }else {
                callback(nil,"网络连接失败")
            }
        })
    }
}
