//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

enum CouponEntryType {
    case unknown // 未定义
    case cart   // 购物车弹窗，根据企业id查询优惠券列表
    case productDetail // 商品详情弹窗，根据企业id&商品编码查询优惠券列表
}

class FKYCouponSheetViewModel {
    // MARK: - properties
    /// 初始化配置
    var usageType: CouponItemUsageType?
    
    /// 初始化赋值
    var spuCode: String?
    var enterpriseId: String?
    
    /// 用于保存接口返回数据数组
    var models: Array<AnyObject> = []
    
    var receiveType: Bool {
        get {
            return usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE || usageType == .CART_GET_COUPON_RECEIVE
        }
    }
    
    var receivedType: Bool {
        get {
            return usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVED || usageType == .CART_GET_COUPON_RECEIVED
        }
    }
    
    // MARK: - life cycle

    // MARK: - public
    func resultOfSwitchUsageTypeToReceive() -> Bool {
        if receiveType { return false }
        if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVED {
            usageType = .PRODUCTDETAIL_GET_COUPON_RECEIVE
        } else if usageType == .CART_GET_COUPON_RECEIVED {
            usageType = .CART_GET_COUPON_RECEIVE
        }
        return true
    }
    
    func resultOfSwitchUsageTypeToReceived() -> Bool {
        if receivedType { return false }
        if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE {
            usageType = .PRODUCTDETAIL_GET_COUPON_RECEIVED
        } else if usageType == .CART_GET_COUPON_RECEIVE {
            usageType = .CART_GET_COUPON_RECEIVED
        }
        return true
    }
}

// MARK: - logic
extension FKYCouponSheetViewModel {
    /// 领取优惠券业务操作
    ///
    /// - Parameters:
    ///   - model: 对应的数据对象
    ///   - finishedCallback: 回调
    func receiveCoupon(_ model: CouponTempModel!, _ finishedCallback : @escaping (_ msg: String?) -> ()) {
        CouponProvider().receiveCoupon(byTemplateCode: model.templateCode!) { [weak self] (couponModel, msg, status) in
            if self?.usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE || self?.usageType == .CART_GET_COUPON_RECEIVE, (couponModel != nil) {
                for (index, value) in (self?.models.enumerated())! {
                    if let tempDo = value as? CouponTempModel {
                        if tempDo.id == model.id {
                            couponModel?.receiveCouponStatus = status!
                            self?.models[index] = couponModel!
                            break
                        }
                    }
                }
                finishedCallback(msg)
            } else {
                self?.dynamicBinding(finishedCallback: { (message) in
                    finishedCallback(msg)
                })
            }
        }
    }
    
    /// 获取优惠券列表
    ///
    /// - Parameter finishedCallback: 回调
    func dynamicBinding(finishedCallback : @escaping (_ errorMsg: String?) -> ()) {
        // 网络请求，操作models数据内容
        if usageType == .CART_GET_COUPON_RECEIVE {
            CouponProvider().fetchCouponReceiveList(withEnterpriseId: self.enterpriseId ?? "", callback: {[weak self] (items, msg) in
                self?.models = items == nil ? [] : items! as Array<AnyObject>
                if (msg != nil) {
                    finishedCallback(msg)
                    return
                }
                finishedCallback(nil)
            })
        } else if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE {
            CouponProvider().fetchCouponReceiveList(withSpuCode: self.spuCode ?? "", enterpriseId: self.enterpriseId ?? "", needAll: 0) {[weak self] (items, msg) in
                self?.models = items == nil ? [] : items! as Array<AnyObject>
                if (msg != nil) {
                    finishedCallback(msg)
                    return
                }
                finishedCallback(nil)
            }
        } else if usageType == .CART_GET_COUPON_RECEIVED {
            CouponProvider().fetchCouponReceivedList(withEnterpriseId: self.enterpriseId ?? "") {[weak self] (items, msg) in
                self?.models = items == nil ? [] : items! as Array<AnyObject>
                if (msg != nil) {
                    finishedCallback(msg)
                    return
                }
                finishedCallback(nil)
            }
        } else if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVED {
            CouponProvider().fetchCouponReceivedList(withSpuCode: self.spuCode ?? "", enterpriseId: self.enterpriseId ?? "", callback: {[weak self] (items, msg) in
                self?.models = items == nil ? [] : items! as Array<AnyObject>
                if (msg != nil) {
                    finishedCallback(msg)
                    return
                }
                finishedCallback(nil)
            })
        } else {
            print("未知类型，无法继续！")
        }
    }
}

// MARK: - private methods
extension FKYCouponSheetViewModel {
    
    
}
