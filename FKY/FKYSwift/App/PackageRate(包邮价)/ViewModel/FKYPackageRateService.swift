//
//  FKYPackageRateService.swift
//  FKY
//
//  Created by yyc on 2020/8/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYPackageRateService: NSObject {
    var pageSize = 10 //每页条数(修改时需相应修改页码计算)
    var currentPage = 1//本期认购当前页
    var pageTotalSize = 1 //总页码
    var imgUrl:String? //接口返回顶部图片
    var isCheck : String? //审核状态同一起购
    var packageTitle: String? //标题
    var isSelfTag: Bool? //判断是不是自营 搜索列表不传
    //请求商家特惠列表
    func getSinglePackageRateWithProductList(_ keywordStr:String?,_ isFresh:Bool,callback: @escaping (_ hasMoreData:Bool,_ model: [FKYPackageRateModel]?,_ message: String?)->()) {
        var params = [String:Any]()
        params["pageSize"] = self.pageSize
        if let str = keywordStr ,str.count > 0 {
            params["keyword"] = keywordStr
        }
        if let selfTag = isSelfTag{
            params["isMp"] = selfTag ? 0:1
        }
        params["type"] = "1"
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
        params["page"] = self.currentPage
        FKYRequestService.sharedInstance()?.requestForGetHomeSinglePackageRateShopProductList(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
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
            if let data = response as? Dictionary<String,AnyObject> {
                if isFresh == true ,let str = data["imgUrl"] as? String , str.count > 0 {
                    strongSelf.imgUrl = str
                }
                if let str = data["isCheck"] as? String {
                    strongSelf.isCheck = str
                }
                if let str = data["title"] as? String ,str.count > 0 {
                    strongSelf.packageTitle = str
                }
                if let totalNum = data["totalPage"] as? Int{
                    strongSelf.pageTotalSize = totalNum
                }
                if let getArr = data["products"] as? NSArray, let arr = getArr.mapToObjectArray(FKYPackageRateModel.self) {
                    callback(strongSelf.hasNext(),arr,nil)
                }else {
                    callback(strongSelf.hasNext(),[],nil)
                }
            }else {
                callback(strongSelf.hasNext(),[],nil)
            }
        })
    }
    func hasNext() -> Bool {
        return self.pageTotalSize > self.currentPage
    }

}
