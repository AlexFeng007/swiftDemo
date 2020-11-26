//
//  FKYDrawPrizeCouponModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYDrawPrizeCouponModel: NSObject,HandyJSON {
    required override init() {}
    
    /// 可用店铺 list
    //var allowShops:null,
    /// 排序是否可用 0 不可用 1 可用
    //var availableSort:null,
    
    /// 开始时间
    var begindate = ""
    
    /// 优惠券不可用商品列表数组
    //var blackProductList:null,
    /// 优惠券可使用店铺 bool
    //var canUsePlatformShopCoupon:null,
    
    /// 优惠券ID 唯一标识
    var couponCode = ""
    
    /// 平台券可以使用的商家列表
    var couponDtoShopList:[FKYCanUseCouponShopModel] = []
    
    /// 优惠券名称
    var couponName = ""
    
    /// 1-手动发券 2 注册送券
    var couponSource = ""
    
    /// 优惠券模板编号
    var couponTempCode = ""
    
    /// 优惠券模板id
    var couponTempId = ""
    
    /// 优惠券类型 1 满减券
    var couponType = ""
    
    /// 可用优惠券商品spu 数组
    var couponUseSpuList = ""
    
    /// 优惠券领取时间
    var createTime = ""
    
    /// 优惠券面值
    var denomination = ""
    
    /// 结束时间
    var endDate = ""
    
    /// 企业id
    var enterpriseId = ""
    
    /// 企业名称
    var enterpriseName = ""
    
    //var getCondition:null,
    
    /// 优惠券号
    var id = ""
    
    /// 是否选中 0-未选中 1-已选中 2-不可选
    var isCheckCoupon = ""
    
    /// 是否限制商品 0-不限制 1-限制
    var isLimitProduct = ""
    
    ///  是否限制店铺0 不限 1限制
    var isLimitShop = ""
    
    /// 平台券时是否限制当前店铺可用 0-不限（当前店铺可用） 1-限制（当前店铺不可用）
    var isLimitThisShop = ""
    
    /// 是否与平台劵互斥,0-不互斥,1-互斥
    var isPlatformMutex = ""
    
    /// 优惠券是否可用 0-不可用 1-可用
    var isUseCoupon = ""
    
    /// 使用限制金额
    var limitprice = ""
    
    /// true表示由于互斥而不可选
    var noCheckByMutex = false
    
    //var received:true,
    
    /// 每个用户可以领取张数
    var repeatAmount = ""
    
    /// 发券失败原因（批量发券时用到）
    var sendMsg = ""
    
    /// 发券成功与否状态（批量发券时用到）0-失败 1-成功 -1 参数错误
    var sendStatus = ""
    
    /// 优惠券开始生效天数
    var startEffectiveDays = ""
    
    /// 优惠券状态
    var status = ""
    
    /// 优惠券企业id
    var tempEnterpriseId = ""
    
    /// 优惠券企业名称
    var tempEnterpriseName = ""
    
    /// 模板类型0-店铺券  1-平台券
    var tempType = ""
    
    /// 使用订单
    var useOrderNo = ""
    
    /// 优惠券可用商品列表 数组
    var useProductList = ""
    
    /// 此优惠券使用商品总额(按商品金额算，不减优惠)
    var useProductPrice = ""
    
    /// 使用时间
    var useTime = ""
}

class FKYCanUseCouponShopModel:NSObject,HandyJSON{
    required override init() {}
    
    /// 商家ID
    var tempEnterpriseId = ""
    
    /// 商家名称
    var tempEnterpriseName = ""
}
