//
//  ShopListEnum.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

enum ShopListTemplateType: Int {
    case unknow000 = 0
    case banners = 1
    case mpNavigation = 2       // 导航按钮
    case secondsKill = 3        // 秒杀专区
    case highQualityShops = 4   // 优质商家  豆腐块广告
    case majorActivity = 8      // 大型活动  中通广告
    case areaChoice = 5         // 区域精选    区域精选
    case clinicArea = 6         // 诊所专供    区域精选
    case recommendedArea = 7    // 推荐专区
}

enum ShopListTemplateActionType {
    case unknow
    case banners_clickItem
    case mpNavigation_clickItem
    case highQualityShops_clickItem
    case majorActivity_clickItem
    case ActivityZone_clickItem
    case ActivityZone_clickItemMore
    case login
    case product_cartNumChanged
    case product_addCart
}

enum ShopListSecondKillType {
    case unknow
    case shopping
    case willBegin
    case alreadyEnd
}

enum RefreshType {
    case header
    case footer
    case loading
}
