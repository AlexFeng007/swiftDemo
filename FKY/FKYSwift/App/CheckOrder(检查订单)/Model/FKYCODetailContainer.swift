//
//  FKYCODetailContainer.swift
//  FKY
//
//  Created by My on 2019/12/3.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//每个cell
enum FKYCOItemType {
    case unknown
    case address  //收件地址信息
    
    case shopName //店铺名
    case productSingle //单品
    case productMore //多品
    case leaveMessage //留言
    case gift //赠品
    case productCoupon //商品优惠券
    case couponCode //优惠券码
    case useRebate //使用返利抵扣 操作
    case shopBuyMoney //购物金
    case payTypeSingle //只有在线支付方式
    case payTypeDouble // 在线支付 + 线下转账
    
    case platform //选择平台优惠券
    
    case invoice //发票
    case invoiceTip //发票提示
    case productAmount //商品金额
    case discountAmount //立减
    case rebateMoney //使用返利金抵扣
    case rebatePlatformMoney //使用平台返利金抵扣
    case allShopBuyMoney //使用的购物金抵扣
    case shopCouponMoney//店铺优惠券
    case platformCouponMoney //平台优惠券
    case freight //运费
    case getRebate //订单完成后可获返利金
    case payAmount //应付总金额
    case saleAgreement //销售合同
    case followQualification //跟随资质
}

class FKYCODetailContainer: NSObject {
    var sectionType: FKYCOSectionType? //section类型
    var cellType: FKYCOItemType? //cell类型
    var data: Any? //数据源
}
