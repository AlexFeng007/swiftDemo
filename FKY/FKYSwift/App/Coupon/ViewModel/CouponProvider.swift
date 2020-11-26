//
//  CouponProvider.swift
//  FKY
//
//  Created by Rabe on 10/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  优惠券模块所有接口调用

import Foundation
import SwiftyJSON

class CouponProvider: NSObject {
    static let DEFAULT_NETWORK_ERRMSG = "服务器繁忙，请稍后再试！"
    
    var manager: HJOperationManager?
    
    override init() {
        super.init()
        self.manager = HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)
    }
    
    /*
     接口说明:
     用户领取优惠券接口
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponReceiveByTemplateCode
     
     参数说明：
     templateCode - 优惠券模板编码
     
     返回结果：
     data - CouponModel
     */
    func receiveCoupon(byTemplateCode templateCode: String, callback:@escaping (_ couponItem : CouponModel?, _ message: String?, _ status: Int?)->()) {
        let parameters = [ "template_code": templateCode ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceiveByTemplateCode", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录", 0)
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG, 0)
            } else {
                if let data = responseObj as? NSDictionary {
                    let item = data.mapToObject(CouponModel.self)
                    callback(item, "领取成功", 1)
                } else {
                    callback(nil, CouponProvider.DEFAULT_NETWORK_ERRMSG, 0)
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     根据商品查询可领取的优惠券列表
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponReceiveBySpuCode
     
     参数说明：
     enterpriseId - 企业id
     spuCode - 商品spuCode
     
     返回结果：
     data - List<CouponTempModel>
     */
    func fetchCouponReceiveList(withSpuCode spuCode: String, enterpriseId: String, needAll: Int,  callback:@escaping (_ couponItems : NSArray?, _ message: String?)->()) {
        let parameters = ["spu_code": spuCode , "enterprise_id": enterpriseId ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceiveBySpuCode", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                if let data = responseObj as? NSArray {
                    let items = data.mapToObjectArray(CouponTempModel.self)! as NSArray
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     根据商品查询用户用户已领取的优惠券列表
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponReceivedBySpuCode
     
     参数说明：
     enterpriseId - 企业id
     spuCode - 商品spuCode
     
     返回结果：
     data - List<CouponModel>
     */
    func fetchCouponReceivedList(withSpuCode spuCode: String, enterpriseId: String,  callback:@escaping (_ couponItems : NSArray?, _ message: String?)->()) {
        let parameters = ["spu_code": spuCode , "enterprise_id": enterpriseId ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceivedBySpuCode", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                if let data = responseObj as? NSArray {
                    let items = data.mapToObjectArray(CouponModel.self)! as NSArray
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     根据商家的id查询该商家可领的优惠券列表
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponReceiveByEnterpriseId
     
     参数说明：
     enterpriseId - 企业id
     
     返回结果：
     data - List<CouponTempModel>
     */
    func fetchCouponReceiveList(withEnterpriseId enterpriseId: String,  callback:@escaping (_ couponItems : NSArray?, _ message: String?)->()) {
        let parameters = ["enterprise_id": enterpriseId ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceiveByEnterpriseId", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                if let data = responseObj as? NSArray {
                    let items = data.mapToObjectArray(CouponTempModel.self)! as NSArray
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     根据商家的id查询该用户已领取的优惠券列表
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponReceivedByEnterpriseId
     
     参数说明：
     enterpriseId - 企业id
     
     返回结果：
     data - List<CouponModel>
     */
    func fetchCouponReceivedList(withEnterpriseId enterpriseId: String,  callback:@escaping (_ couponItems : NSArray?, _ message: String?)->()) {
        let parameters = ["enterprise_id": enterpriseId ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponReceivedByEnterpriseId", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                if let data = responseObj as? NSArray {
                    let items = data.mapToObjectArray(CouponModel.self)! as NSArray
                    callback(items, nil)
                } else {
                    callback(nil, nil)
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     查询我的优惠券列表http
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/couponList
     
     参数说明：
     couponStatus - 优惠券状态 0未使用 1已使用 3已过期 4所有 / 默认4 查询所有
     timeLimit - 查询优惠券的时间范围 0.全部、1.近三个月、2.近一年 / 默认为0
     page - 当前页 当前页数，页数从1开始
     
     返回结果：
     data
         - List<CouponModel>
         - "paginator": {
                 "endRow": 1,
                 "firstPage": true,
                 "hasNextPage": false,
                 "hasPrePage": false,
                 "lastPage": true,
                 "limit": 10,
                 "nextPage": 1,
                 "offset": 0,
                 "page": 1,      //当前页数
                 "prePage": 1,
                 "slider": [ 1 ],
                 "startRow": 1,
                 "totalCount": 1,//总记录数
                 "totalPages": 1 // 总页数
         }
     */
    func fetchMyCouponList(withStatus status: Int, _ page: Int, callback:@escaping (_ items: NSArray?, _ paginator: PaginatorModel?, _ message: String?)->()) {
        let parameters = ["coupon_status": status, "time_limit": 0, "page": page ] as [String : Any]
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "couponList", versionNum: "", type: kRequestPost, param: parameters) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(nil, nil, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(nil, nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            }
            else {
                guard let response = responseObj as? Dictionary<String,Any> else {
                    callback(nil, nil, CouponProvider.DEFAULT_NETWORK_ERRMSG)
                    return
                }

                if let arr = response["data"] as? NSArray {
                    let items = arr.mapToObjectArray(CouponModel.self)! as NSArray
                    if let paginator = response["paginator"] as? NSDictionary {
                        let pageModel = paginator.mapToObject(PaginatorModel.self)
                        callback(items, pageModel, nil)
                    } else {
                        callback(items, nil, nil)
                    }
                } else {
                    if let paginator = response["paginator"] as? NSDictionary {
                        let pageModel = paginator.mapToObject(PaginatorModel.self)
                        callback(nil, pageModel, nil)
                    } else {
                        callback(nil, nil, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
                    }
                }
            }
        }
        self.manager!.request(with: param)
    }
    
    /*
     接口说明:
     查询是否有注册激活送券活动http
     
     接口路径:
     http://gateway-b2b.fangkuaiyi.com/promotion/coupon/hasRegisterActivity
     
     参数说明：
     无
     
     返回结果：
     
     返回json样例：
     {"data":1}
     */
    @objc func queryRegisterCouponStatus(withCallback callback:@escaping (_ hasActivity: Bool, _ message: String?)->()) {
        let param: HJOperationParam = HJOperationParam.init(businessName: "promotion/coupon", methodName: "hasRegisterActivity", versionNum: "", type: kRequestPost, param: nil) { (responseObj, error) in
            if let err = error {
                let e = err as NSError
                if e.code == 2 {
                    // token过期
                    callback(false, "用户登录过期, 请手动重新登录")
                    return
                }
                callback(false, error?.localizedDescription ?? CouponProvider.DEFAULT_NETWORK_ERRMSG)
            } else {
                
                if let data = responseObj as? Int {
                    if data == 1 {
                        callback(true, "有注册送券活动")
                    } else {
                        callback(false, "无注册送券活动")
                    }
                } else {
                    callback(false, CouponProvider.DEFAULT_NETWORK_ERRMSG)
                }
            }
        }
        self.manager!.request(with: param)
    }
}
