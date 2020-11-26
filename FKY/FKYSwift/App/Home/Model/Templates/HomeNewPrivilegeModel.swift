//
//  HomeNewPrivilegeModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  新人专享

import UIKit
import SwiftyJSON

/*
 jumpInfo：跳转链接
 name：楼层名称
 title：楼层标题
 */
final class HomeNewPrivilegeModel: NSObject, JSONAbleType {
    // MARK: - properties
    var title: String?
    var indexMobileProductVos: [HomeNewPrivilegeItemModel]?
    var jumpInfo:String?
    var jumpType:Int!
    var name:String?
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> HomeNewPrivilegeModel {
        let json = JSON(json)
        
        let title = json["title"].stringValue
        let name = json["name"].stringValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].intValue
//        let indexMobileProductVos = (json["indexMobileProductVos"].arrayObject! as NSArray).mapToObjectArray(HomeNewPrivilegeItemModel.self) as [HomeNewPrivilegeItemModel]?
        
        var indexMobileProductVos: [HomeNewPrivilegeItemModel]?
        if let list = json["indexMobileProductVos"].arrayObject {
            indexMobileProductVos = (list as NSArray).mapToObjectArray(HomeNewPrivilegeItemModel.self)
        }
        
        return HomeNewPrivilegeModel(title: title,name: name,jumpInfo: jumpInfo,jumpType: jumpType, indexMobileProductVos:indexMobileProductVos)
    }
    
    init(title: String?, name: String?, jumpInfo: String?, jumpType: Int?, indexMobileProductVos: [HomeNewPrivilegeItemModel]?) {
        super.init()
        self.title = title
        self.name = name
        self.jumpInfo = jumpInfo
        self.jumpType = jumpType
        self.indexMobileProductVos = indexMobileProductVos
    }
}

//extension HomeNewPrivilegeModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeNewPrivilegeCell"
//    }
//}


/*
 imgPath：商品图片
 productName：商品名
 showPrice：展示价格
 status：商品状态 0.资质认证后可见 1.价钱不展示 (下架) 2.加入渠道后可见 3.限时特价 4.正常采购价 5.登录后可见 6.资质审核后可见 7.渠道待审核 8.不在销售区域内 9.缺货 -1.无任何状态 10.卖家缺货 11.采购权限待审核 12.采购权限审核通过 13.采购权限审核未通过 14.采购权限变更待审核 15.采购权限已禁用 16.申请采购权限可见
 */
final class HomeNewPrivilegeItemModel: NSObject, JSONAbleType {
    // MARK: - properties
    var imgPath: String?
    var productName:String?
    var showPrice:String?
    var status:Int?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeNewPrivilegeItemModel {
        let json = JSON(json)
        
        let imgPath = json["imgPath"].stringValue
        let productName = json["productName"].stringValue
        let showPrice = json["showPrice"].stringValue
        let status = json["status"].intValue
        return HomeNewPrivilegeItemModel(imgPath: imgPath,productName: productName,showPrice: showPrice,status: status)
    }
    
    init(imgPath: String?, productName: String?, showPrice: String?, status: Int?) {
        super.init()
        self.imgPath = imgPath
        self.productName = productName
        self.showPrice = showPrice
        self.status = status
    }
}

