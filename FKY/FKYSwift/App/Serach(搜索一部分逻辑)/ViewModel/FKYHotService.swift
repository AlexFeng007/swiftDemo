//
//  FKYHotService.swift
//  FKY
//
//  Created by yyc on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHotService: NSObject {
    
    var pageSize = 10 //每页条数(修改时需相应修改页码计算)
    var currentPage = 1//本期认购当前页
    var pageTotalSize = 1 //总页码
    //请求新品登记列表
    func getCityHotRegionProductList(_ isFresh:Bool,_ spuCode:String,callback: @escaping (_ hasMoreData:Bool,_ model: [ShopProductCellModel]?,_ message: String?)->()) {
        var params = [String:Any]()
        params["size"] = self.pageSize
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
        params["spuCode"] = spuCode
        FKYRequestService.sharedInstance()?.requestForGetCityHotRegionProductList(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
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
            if let desModel = model as? FKYHotSaleModel {
                strongSelf.pageTotalSize = desModel.allPages ?? 1
                callback(strongSelf.hasNext(),desModel.newProductArr,nil)
            }else {
                callback(strongSelf.hasNext(),nil,"网络连接失败")
            }
        })
    }
    func hasNext() -> Bool {
        return self.pageTotalSize > self.currentPage
    }
}

//MARK: - 数据处理
extension FKYHotService {
    
    
}

//MARK: - CELLmodel
class FKYHotSaleRegionCellModel:NSObject {
    enum HotSaleRegionCellType {
        case noType
        case productCell
        case discountEntryCell
    }
    
    /// cell类型
    var cellType:HotSaleRegionCellType = .noType
    
    /// 当前cell的商品信息
    var productInfo:ShopProductCellModel = ShopProductCellModel()
    
    /// 优惠套餐的入口图片
    var discountImgUrl:String = ""
}
