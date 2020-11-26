//
//  CouponEnum.swiftm.swift
//  FKY
//
//  Created by Rabe on 17/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

/// 优惠券类型
///
/// - platform: 平台券
/// - shop: 店铺券
enum CouponItemType {
    case platform
    case shop
}

/// 优惠券使用场景
///
/// - PRODUCTDETAIL_GET_COUPON_RECEIVE: 【使用场景】商品详情弹窗-可领取
/// - PRODUCTDETAIL_GET_COUPON_RECEIVED: 【使用场景】商品详情弹窗-已领取
/// - CART_GET_COUPON_RECEIVE: 【使用场景】购物车弹窗-可领取
/// - CART_GET_COUPON_RECEIVED: 【使用场景】购物车弹窗-已领取
/// - MY_COUPON_LIST_ENABLED: 【使用场景】我的优惠券-列表-可用
/// - MY_COUPON_LIST_USED: 【使用场景】我的优惠券-列表-已用
/// - MY_COUPON_LIST_OUTDATE: 【使用场景】我的优惠券-列表-过期
/// - USE_COUPON_ENABLED: 【使用场景】检查订单-使用优惠券-可用
/// - USE_COUPON_DISABLED: 【使用场景】检查订单-使用优惠券-不可用
enum CouponItemUsageType {
    case PRODUCTDETAIL_GET_COUPON_RECEIVE
    case PRODUCTDETAIL_GET_COUPON_RECEIVED
    case CART_GET_COUPON_RECEIVE
    case CART_GET_COUPON_RECEIVED
    case MY_COUPON_LIST_ENABLED
    case MY_COUPON_LIST_USED
    case MY_COUPON_LIST_OUTDATE
    case USE_COUPON_ENABLED
    case USE_COUPON_DISABLED
    
    /// 空页面title
    func emptyPageTitle() -> String {
        switch self {
        case .CART_GET_COUPON_RECEIVE, .PRODUCTDETAIL_GET_COUPON_RECEIVE: return "暂无可领取优惠券"
        case .CART_GET_COUPON_RECEIVED, .PRODUCTDETAIL_GET_COUPON_RECEIVED: return "暂无已领取优惠券"
        case .MY_COUPON_LIST_ENABLED, .USE_COUPON_ENABLED: return "暂无可用优惠券"
        case .MY_COUPON_LIST_USED: return "暂无已用优惠券"
        case .MY_COUPON_LIST_OUTDATE: return "暂无过期优惠券"
        case .USE_COUPON_DISABLED: return "暂无不可用优惠券"
        }
    }
    
    /// 我的优惠券列表请求时的status（对应接口文档）
    func couponListParameterStatus() -> Int {
        switch self {
        case .MY_COUPON_LIST_ENABLED: return 0
        case .MY_COUPON_LIST_USED: return 1
        case .MY_COUPON_LIST_OUTDATE: return 3
        default: return -1
        }
    }
    
    /// 我的优惠券列表根据index返回usageType
    static func couponListType(withIndex index: Int) -> CouponItemUsageType {
        switch index {
        case 1:
            return .MY_COUPON_LIST_USED
        case 2:
            return .MY_COUPON_LIST_OUTDATE
        default:
            return .MY_COUPON_LIST_ENABLED
        }
    }
    
    /// 使用优惠券列表根据index返回usageType
    static func useCouponListType(withIndex index: Int) -> CouponItemUsageType {
        switch index {
        case 1:
            return .USE_COUPON_DISABLED
        default:
            return .USE_COUPON_ENABLED
        }
    }
}
