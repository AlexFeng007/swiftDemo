//
//  FKYNativeRouter.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/15.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

//MARK: 首页模式轮播banner之查看详情
func jumpBannerDetailActionWithAll(jumpType: Int?, jumpInfo: String?, jumpExpandOne: String?, jumpExpandTwo: String?) {
    if let type = jumpType {
        switch type {
        case 2: // 商品详情页
            jumpProductDetail(productCode: jumpInfo, productSupplyId: jumpExpandTwo)
        case 3: // 搜索详情页
            FKYNavigator.shared().openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let controller = vc as! FKYSearchResultVC
                // jumpInfo(类目编码)与jumpExpandOne(关键字)两个属性不会同时存在
                if let tid = jumpInfo, tid.isEmpty == false {
                    // 类目编码
                    controller.selectedAssortId = tid
                }
                else {
                    controller.selectedAssortId = ""
                }
                if let keyword = jumpExpandOne, keyword.isEmpty == false {
                    // 关键字
                    controller.keyword = keyword
                }
                else {
                    controller.keyword = ""
                }
            })
        case 4: // 店铺主页
            FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                let controller = vc as! FKYNewShopItemViewController
                if let sid = jumpInfo, sid.isEmpty == false {
                    // 店铺id
                    controller.shopId = sid
                }
                else {
                    controller.shopId = ""
                }
            }, isModal: false)
        case 5: // 活动链接
            if let url = jumpInfo {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.p_openPriveteSchemeString(url)
                }
            }
        default:
            if let url = jumpInfo {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.p_openPriveteSchemeString(url)
                }
            }
        }
    }
}

//MARK: 跳转商详页
func jumpProductDetail(productCode: String?, productSupplyId: String?) {
    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
        let controller = vc as! FKY_ProdutionDetail
        // 商品id(spucode)与供应商id(venderid)两个属性需同时存在
        if let pid = productCode, pid.isEmpty == false {
            // 商品id(spucode)
            controller.productionId = pid
        }
        else {
            controller.productionId = ""
        }
        if let vid = productSupplyId, vid.isEmpty == false {
            // 供应商id(venderid)
            controller.vendorId = vid
        }
        else {
            controller.vendorId = ""
        }
    }, isModal: false)
}

//MARK: 链接模式模式轮播banner之查看详情

func visitSchema(_ schema: String) {
   // 此方法被p_openPriveteSchemeString替代
    if let app = UIApplication.shared.delegate as? AppDelegate {
        if  schema.isEmpty == false {
            app.p_openPriveteSchemeString(schema)
        }
    }
}
