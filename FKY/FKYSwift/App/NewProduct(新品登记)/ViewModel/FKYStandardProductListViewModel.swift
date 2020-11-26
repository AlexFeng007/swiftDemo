//
//  FKYStandardProductListViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class FKYStandardProductListViewModel: NSObject,JSONAbleType {
    /// 标品列表
    var productList:[FKYStandardProductModel] = []
    /// 标品搜索结果 0 无数据，1有数据 默认0
    var searchResult = 0
    /// cellModel列表
    var cellModelList:[FKYStandardProductCellModel] = []
    /// 当前页
    var currentPage = 1
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYStandardProductListViewModel {
        let json = JSON(json)
        let model = FKYStandardProductListViewModel()
        let productList = json["products"].arrayValue as NSArray
        model.productList = productList.mapToObjectArray(FKYStandardProductModel.self) ?? [FKYStandardProductModel]()
        model.searchResult = json["searchResult"].intValue
        return model
    }
}

/// 网络请求
extension FKYStandardProductListViewModel {
    /// 获取标品列表
    func requestStandardProductList(param:[String:AnyObject],callBack:@escaping (_ isSuccess:Bool,_ Msg:String)->()) {
//        requestForGetStandardProductSetListWithParam
        FKYRequestService.sharedInstance()?.requestForGetStandardProductSetList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callBack(false,msg)
                return
            }
            
            // 请求成功 整理数据
            if let data = response as? NSDictionary {
                if let productArray = data["products"] as? NSArray{
                    strongSelf.productList.removeAll()
                    strongSelf.productList = productArray.mapToObjectArray(FKYStandardProductModel.self) ?? [FKYStandardProductModel]()
                }
                strongSelf.searchResult = data["searchResult"] as! Int
                strongSelf.disposeData()
            }
            callBack(true,"")
        })
    }
}

/// 数据处理相关
extension FKYStandardProductListViewModel {
    
    ///整理数据
    func disposeData(){
        self.cellModelList.removeAll()
        for product in self.productList {
            let cellModel = FKYStandardProductCellModel()
            cellModel.product = product
            self.cellModelList.append(cellModel)
        }
    }
}

//MARK: - cellmodel
class FKYStandardProductCellModel:NSObject{
    
    /// 标品
    var product = FKYStandardProductModel()
    /// 是否选中
    var isSelected = false
}
