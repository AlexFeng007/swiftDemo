//
//  ShopListFuncBtnModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  功能按钮

import SwiftyJSON

final class ShopListFuncBtnModel: NSObject,JSONAbleType {
    // 接口返回字段
    var navigations: [HomeFucButtonItemModel]?   // 功能按钮
    // 本地新增业务逻辑字段
    var pageIndex: Int = 0                      // 当前页面索引
    
    init(navigations: [HomeFucButtonItemModel]?) {
        self.navigations = navigations
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListFuncBtnModel {
        
        let j = JSON(json)
        var navigations: [HomeFucButtonItemModel]?
        if let list = j["MpNavigation"].arrayObject {
            navigations = (list as NSArray).mapToObjectArray(HomeFucButtonItemModel.self)
        }
        
        return ShopListFuncBtnModel(navigations: navigations)
    }
}

extension ShopListFuncBtnModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "ShopListFuncCell"
    }
}
