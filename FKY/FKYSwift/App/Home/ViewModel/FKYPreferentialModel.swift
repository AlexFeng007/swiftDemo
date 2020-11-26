//
//  FKYPreferentialModel.swift
//  FKY
//
//  Created by yyc on 2020/4/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYPreferentialModel: NSObject {
    var pageSize = 10 //每页条数(修改时需相应修改页码计算)
    var currentPage = 1//本期认购当前页
    var pageTotalSize = 1 //总页码
    //请求商家特惠列表
    func getPreferentialShopWithProductList(_ sellCode:String?,_ spuCode:String? ,_ isFresh:Bool,callback: @escaping (_ hasMoreData:Bool,_ model: [FKYPreferetailModel]?,_ message: String?)->()) {
        var params = [String:Any]()
        params["pageSize"] = self.pageSize
        if isFresh == true {
            self.currentPage = 1
            self.pageTotalSize = 1
            params["spuCode"] = spuCode ?? ""
            params["sellerCode"] = sellCode ?? ""
        }else {
            //加载更多
            if self.hasNext() == false {
                return
            }
            self.currentPage = 1 + self.currentPage
        }
        params["page"] = self.currentPage
        FKYRequestService.sharedInstance()?.requestForGetHomePreferetialShopProductList(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
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
            if let data = response as? Dictionary<String,AnyObject> , let getArr = data["data"] as? NSArray ,let arr = getArr.mapToObjectArray(FKYPreferetailModel.self) {
                if let paginatorDic = data["paginator"] as? NSDictionary , let totalNum = paginatorDic["totalPages"] as? Int{
                    strongSelf.pageTotalSize = totalNum
                }
                callback(strongSelf.hasNext(),arr,nil)
            }else {
                callback(strongSelf.hasNext(),[],nil)
            }
        })
    }
    func hasNext() -> Bool {
        return self.pageTotalSize > self.currentPage
    }
}

