//
//  FKYSearchSellerViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYSearchSellerViewModel: NSObject ,HandyJSON{
    required override init() {}
    /// 搜索发现的cellList
    var foundCellList:[FKYSearchProductCellModel] = [FKYSearchProductCellModel]()
    
    /// 搜索发现的原始列表数据
    var list:[FKYSearchSellerFoundModel] = [FKYSearchSellerFoundModel]()
    
}

//MARK: - 数据处理
extension FKYSearchSellerViewModel{
    func installData(){
        self.foundCellList.removeAll()
        for model in self.list {
            let cellModel = FKYSearchProductCellModel()
            cellModel.cellType = .buyRecCell
            cellModel.sellerFoundModel = model
            self.foundCellList.append(cellModel)
        }
    }
}

//MARK: - 网络请求
extension FKYSearchSellerViewModel {
    
    func getSearchFoundList (callBack: @escaping (_ isSuccess:Bool,_ msg:String)->()){
        let dic = ["custId":FKYLoginService.currentUser()?.ycenterpriseId,// 买家企业ID 必传
                     "pageNo":"1",//查询当前页 非必传，默认为1
                     "pageSize":"6",// 每页数据条数    非必传，默认为5
                     //"beginTime":"",//起始时间    String（格式：2020-09-01 09:00:00）非必传，默认为当前时间往前三个月
                     //"endTime":""//结束时间 非必传
        ]
        let param = ["jsonParams":dic]
        FKYRequestService.sharedInstance()?.requestSearchFoundList(withParam: param, completionBlock: {  [weak self] (success, error, response, model) in
            guard let weakSelf = self else {
                callBack(false, "内存溢出")
                return
            }
            guard let resDic = response as? NSDictionary else{
                callBack(false, "解析错误")
                return
            }
            
            weakSelf.list.removeAll()
            
            weakSelf.list = (FKYSearchSellerViewModel.deserialize(from: resDic) ?? FKYSearchSellerViewModel()).list
            weakSelf.installData()
            callBack(true,"")
        })
    }
}
