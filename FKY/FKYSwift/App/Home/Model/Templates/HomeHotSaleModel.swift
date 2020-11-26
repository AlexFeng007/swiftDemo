//
//  HomeHotSaleModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  首页类目热销（商品列表）之数据model

import SwiftyJSON

final class HomeHotSaleModel: NSObject, JSONAbleType {
    // 接口返回字段
    var chartCatagoryList: [HomeHotSaleTypeItemModel]?  // 热销类目对象数组
    // 本地新增业务逻辑字段
    var categoryNameList = [String]()                   // 热销类目对象标题数组...<不为空>
    var categoryIndex: Int = 0                          // 当前商品类型(类目)索引
    var isRefreshData: Bool = true                      // 是否为新的刷新数据...<每次从接口获取当前楼层的数据时，当前字段均默认为true；显示完一次后自动置为false>
    
    init(chartCatagoryList: [HomeHotSaleTypeItemModel]?) {
        self.chartCatagoryList = chartCatagoryList
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeHotSaleModel {
        let json = JSON(json)
        
        var chartCatagoryList: [HomeHotSaleTypeItemModel]?
        if let list = json["chartCatagoryList"].arrayObject {
            chartCatagoryList = (list as NSArray).mapToObjectArray(HomeHotSaleTypeItemModel.self)
        }
        
        // 直接在数据解析阶段将每个item对象的标题取出来，避免每次cell展示时均做一次此操作
        var arrName = [String]()
        if let list = chartCatagoryList, list.count > 0 {
            for index in 0..<list.count {
                let item = list[index]
                if let title = item.catagoryShowName, title.isEmpty == false {
                    arrName.append(title)
                }
                else {
                    arrName.append("未知类目")
                }
            } // for
        }

        let categoryModel = HomeHotSaleModel(chartCatagoryList: chartCatagoryList)
        categoryModel.categoryNameList = arrName
        return categoryModel
    }
}

//extension HomeHotSaleModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeHotSaleListCell"
//    }
//}


/*
 catagoryShowName：类目名称
 */
final class HomeHotSaleTypeItemModel: NSObject, JSONAbleType {
    var catagoryCode: String?                           // 类目编码
    var catagoryShowName: String?                       // 类目名称
    var catagoryList: [HomeHotSaleProductItemModel]?    // 商品列表
    
    init(catagoryCode: String, catagoryShowName: String?, catagoryList: [HomeHotSaleProductItemModel]?) {
        self.catagoryCode = catagoryCode
        self.catagoryShowName = catagoryShowName
        self.catagoryList = catagoryList
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeHotSaleTypeItemModel {
        let json = JSON(json)
        
        let catagoryCode = json["catagoryCode"].stringValue
        let catagoryShowName = json["catagoryShowName"].stringValue
        
        var catagoryList: [HomeHotSaleProductItemModel]?
        if let list = json["catagoryList"].arrayObject {
            catagoryList = (list as NSArray).mapToObjectArray(HomeHotSaleProductItemModel.self)
        }
        
        return HomeHotSaleTypeItemModel(catagoryCode: catagoryCode, catagoryShowName: catagoryShowName, catagoryList: catagoryList)
    }
}

/*
 catagoryShowName：类目名称；
 factory：厂商名称；
 factoryId：厂商id；
 imgUrl：商品图片；
 pMC：销售量
 price：价格
 productName：商品名
 rCV_REG_PROV：站点id
 shortName：通用名
 showCount：库存量
 spec：规格
 spu_code：药城药品编码；
 status：
 0.资质认证后可见 1.价钱不展示 (下架) 2.加入渠道后可见 3.限时特价 4.正常采购价
 5.登录后可见 6.资质审核后可见 7.渠道待审核 8.不在销售区域内
 9.缺货 -1.无任何状态 10.卖家缺货 11.采购权限待审核 12.采购权限审核通过
 13.采购权限审核未通过 14.采购权限变更待审核 15.采购权限已禁用 16.申请采购权限可见
 */
final class HomeHotSaleProductItemModel: NSObject, JSONAbleType {
    var factory: String?        // 厂商名称
    var factoryId: String?      // 厂商id
    var imgUrl: String?         // 图片url
    //var pMC: String?            // 销售量
    var price: String?          // 价格
    var productName: String?    // 商品名称
    var rCV_REG_PROV: String?   // 站点id
    var shortName: String?      // 通用名
    //var showCount: String?      // 库车
    var spec: String?           // 规格
    var spu_code: String?       // 药城药品编码spucode(商品id)
    var status: Int?            // 商品状态
    
    init(factory: String?, factoryId: String?, imgUrl: String?, price: String?, productName: String?, rCV_REG_PROV: String?, shortName: String?, spec: String?, spu_code: String?, status: Int?) {
        self.factory = factory
        self.factoryId = factoryId
        self.imgUrl = imgUrl
        self.price = price
        self.productName = productName
        self.rCV_REG_PROV = rCV_REG_PROV
        self.shortName = shortName
        self.spec = spec
        self.spu_code = spu_code
        self.status = status
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeHotSaleProductItemModel {
        let json = JSON(json)
        
        let factory = json["factory"].stringValue
        let factoryId = json["factoryId"].stringValue
        let imgUrl = json["imgUrl"].stringValue
        let price = json["price"].stringValue
        let productName = json["productName"].stringValue
        let rCV_REG_PROV = json["rCV_REG_PROV"].stringValue
        let shortName = json["shortName"].stringValue
        let spec = json["spec"].stringValue
        let spu_code = json["spu_code"].stringValue
        let status = json["status"].intValue
        
        return HomeHotSaleProductItemModel(factory: factory, factoryId: factoryId, imgUrl: imgUrl, price: price, productName: productName, rCV_REG_PROV: rCV_REG_PROV, shortName: shortName, spec: spec, spu_code: spu_code, status: status)
    }
}
