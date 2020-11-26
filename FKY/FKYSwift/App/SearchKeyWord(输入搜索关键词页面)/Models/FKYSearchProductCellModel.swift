//
//  FKYSearchProductCellModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchProductCellModel: NSObject {
    @objc enum FKYSearchProductCellType:Int {
        case notSet
        /// 历史搜索词cell
        case historyCell
        /// 搜商品的时候 发现cell
        case foundCell
        /// 折叠cell
        case foldCell
        /// 搜店铺的时候搜索发现cell
        case buyRecCell
    }
    
    @objc var cellType:FKYSearchProductCellType = .notSet
    @objc var historyModel:FKYSearchHistoryModel = FKYSearchHistoryModel();
    @objc var foundModel:FKYSearchActivityModel = FKYSearchActivityModel();
    @objc var sellerFoundModel:FKYSearchSellerFoundModel = FKYSearchSellerFoundModel()
    /// 专给埋点用的
    var cellRow = 0;
}
