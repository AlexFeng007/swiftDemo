//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit
import SwiftyJSON


/// 可领取优惠券对象，对应接口文档的CouponTempDto对象
/// 文档地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=16197016
/*
 
 名称  说明  类型  示例值  备注
 id    id    Integer
 enterpriseId    企业id    String
 couponName    优惠券名称    String
 templateCode    优惠券模板编号    String
 couponType    优惠券类型    Integer
 isLimitProduct    是否限制商品    Integer         0-不限制 1-限制
 couponStartTime    领券开始时间    Date
 couponEndTime    领券结束时间    Date
 denomination    优惠券面值    BigDecimal
 limitprice    优惠券使用金额限制    BigDecimal
 begindate    生效开始时间    Date
 endDate    生效结束时间    Date
 tempEnterpriseName 发券企业名    String
 "couponDtoShopList":[         优惠券可用店铺列表
 {
 "tempEnterpriseId": "99999",
 "tempEnterpriseName": "优惠券企业名称"
 },
 {
 "tempEnterpriseId": "99999",
 "tempEnterpriseName": "优惠券企业名称"
 }
 ]
 
 */
// MARK: - CouponTempModel 对象<弹框中的优惠券模型>
final class CouponTempModel: NSObject, JSONAbleType {
    
    // MARK: - properties
    var id : Int?
    var enterpriseId : String?
    var couponName : String?
    var templateCode: String?
    var couponType: Int?
    var tempType : Int? //当tempType=1时为平台券，tempType = 0 时为店铺券。。
    var isLimitProduct: Int? //是否限制商品 0-不限制 1-限制 2-排除商品
    var couponStartTime: String?
    var couponEndTime: String?
    var denomination: Int?
    var limitprice: Int?
    var begindate: String?
    var endDate: String?
    var couponTimeText : String? //优惠券的日期（新加）
    var tempEnterpriseName: String?
    /// 优惠券限制详细描述
    var couponDescribe:String = ""
    var couponDtoShopList: [UseShopModel]? = nil
    var couponFullName: String?{ //优惠券名称
        get {
            return "满" + "\(limitprice ?? 0)" + "减" + "\(denomination ?? 0)"
        }
    }
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> CouponTempModel {
        let json = JSON(json)
        let model = CouponTempModel()
        
        model.id = json["id"].intValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.couponName = json["couponName"].stringValue
        model.templateCode = json["templateCode"].stringValue
        model.couponType = json["couponType"].intValue
        model.tempType = json["tempType"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.couponStartTime = json["couponStartTime"].stringValue
        model.couponEndTime = json["couponEndTime"].stringValue
        model.denomination = json["denomination"].intValue
        model.limitprice = json["limitprice"].intValue
        model.begindate = json["begindate"].stringValue.removeHHMMSS()
        model.endDate = json["endDate"].stringValue.removeHHMMSS()
        model.couponTimeText = json["couponTimeText"].stringValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        model.couponDescribe = json["couponDescribe"].stringValue
        var couponDtoShopList: [UseShopModel]?
        if let j = json["couponDtoShopList"].arrayObject {
            couponDtoShopList = (j as NSArray).mapToObjectArray(UseShopModel.self)
        }
        model.couponDtoShopList = couponDtoShopList
        return model
    }
}

// MARK: - private methods
extension CouponTempModel {
    
}


/// 已领取优惠券对象，对应接口文档的CouponDto对象
/// 文档地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=16197055
/*
 
 名称  说明  类型  示例值  备注
 id    id    Integer    1
 couponCode    优惠券号    String
 couponTempId    优惠券模板id    Integer
 couponTempCode    优惠券模板编号    String
 enterpriseId    企业id    String
 denomination    优惠券面值    BigDecimal
 limitprice    使用限制金额    BigDecimal
 status    优惠券状态    Integer
 begindate    开始时间    Date
 endDate    结束时间    Date
 useTime    使用时间    Date
 useOrderNo    使用订单    String
 createTime    优惠券领取时间    Date
 couponName    优惠券名称    String
 tempEnterpriseId    优惠券企业id    String
 tempEnterpriseName    优惠券企业名称    String
 repeatAmount    每个用户可以领取张数    Integer
 isLimitProduct    是否限制商品    Integer         0-不限制 1-限制
 couponType 优惠券类型    Integer         1 满减券
 tempType 优惠券类别    Integer         0-店铺券 1 -平台券
 isLimitShop 是否限制店铺    Integer 0-不限 1 -限制 平台券时使用
 "couponDtoShopList":[         优惠券可用店铺列表
 {
 "tempEnterpriseId": "99999",
 "tempEnterpriseName": "优惠券企业名称"
 },
 {
 "tempEnterpriseId": "99999",
 "tempEnterpriseName": "优惠券企业名称"
 }
 ]
 
 */
// MARK: - CouponModel 对象
final class CouponModel: NSObject, JSONAbleType {
    // MARK: - properties
    /// 接口字段
    var id : Int?
    var couponCode : String?
    var couponTempId : Int?
    var couponTempCode: String?
    var enterpriseId: String?
    var denomination: Int?
    var limitprice: Int?
    var status: Int?
    var begindate: String?
    var endDate: String?
    var useTime: String?
    var useOrderNo: String?
    var createTime: String?
    var couponName: String?
    var tempEnterpriseId: String?
    var tempEnterpriseName: String?
    var repeatAmount: Int?
    var isLimitProduct: Int?
    var couponType: Int?
    var tempType: Int? //当tempType=1时为平台券，tempType = 0 时为店铺券。。
    var isLimitShop: Int?
    var couponDtoShopList: [UseShopModel]?
    /// 优惠券限制详细描述
    var couponDescribe:String = ""
    
    /// 给接口擦屁股的自定义字段
    var receiveCouponStatus: Int = -1 // -1.未领取； 0.系统错误；1.成功；2.未到领取时间；3.优惠券已过期；4.优惠券已领完；5.优惠券已达到领取限制；6.正在处理，请稍后再试；7.参数错误
    var isShowUseShopList:Bool = false//是否已展示平台券的可用店铺
    var couponFullName: String?{ //优惠券名称
        get {
            return "满" + "\(limitprice ?? 0)" + "减" + "\(denomination ?? 0)"
        }
    }
    // MARK: - life cycle
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> CouponModel {
        let json = JSON(json)
        let model = CouponModel()
        model.id = json["id"].intValue
        model.couponCode = json["couponCode"].stringValue
        model.couponTempId = json["couponTempId"].intValue
        model.couponTempCode = json["couponTempCode"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.denomination = json["denomination"].intValue
        model.limitprice = json["limitprice"].intValue
        model.status = json["status"].intValue
        model.begindate = json["begindate"].stringValue.removeHHMMSS()
        model.endDate = json["endDate"].stringValue.removeHHMMSS()
        model.useTime = json["useTime"].stringValue
        model.useOrderNo = json["useOrderNo"].stringValue
        model.createTime = json["createTime"].stringValue
        model.couponName = json["couponName"].stringValue
        model.tempEnterpriseId = json["tempEnterpriseId"].stringValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        model.repeatAmount = json["repeatAmount"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.couponType = json["couponType"].intValue
        model.tempType = json["tempType"].intValue
        model.isLimitShop = json["isLimitShop"].intValue
        model.couponDescribe = json["couponDescribe"].stringValue
        var couponDtoShopList: [UseShopModel]?
        if let j = json["couponDtoShopList"].arrayObject {
            couponDtoShopList = (j as NSArray).mapToObjectArray(UseShopModel.self)
        }
        model.couponDtoShopList = couponDtoShopList
        return model
    }
}

// MARK: - private methods
extension CouponModel {
    
}

// MARK: - CouponNewModel 对象<商品详情弹框模型>
final class CommonCouponNewModel: NSObject, JSONAbleType {
    // MARK: - properties
    //已领取优惠券字段
    var begindate: String? //生效开始时间
    var endDate: String? // 生效结束时间
    var couponCode : String?//优惠券号
    var couponTempCode: String? //优惠券模板编号
    var couponTempId : Int? //优惠券模板id
    var createTime: String? //优惠券领取时间
    var noCheckByMutex :Bool? //
    var tempEnterpriseId: String? //优惠券企业id
    //未领取优惠券字段
    var auditStatus: Int? //
    var couponAreaType: Int? //
    //var couponEndTime: String? //生效结束时间
    //var couponStartTime: String? //生效开始时间
    var couponSequence: Int? //
    var couponTimeText: String? //优惠券失效日期
    var couponType: Int?
    var creator: String? //
    var discount_degree: Float?
    var effectiveDays: Int?
    var effectiveType: Int?
    var getCondition: Int?
    var groupType: String? //
    var isLimitAmount: Int?
    var templateCode: String? //优惠券模板编号
    //公共参数
    var couponName: String? //优惠券名称
    var denomination: Int? //优惠券面值
    var enterpriseId: String? //企业id
    var id : Int?
    var isLimitProduct: Int? //是否限制商品 0-不限制 1-限制
    var isLimitShop: Int? //是否限制店铺  0-不限 1 -限制 平台券时使用
    var limitprice: Int? //优惠券使用金额限制
    var received :Bool? //true 领取 false 未领取
    var repeatAmount: Int? //每个用户可以领取张数
    var status: Int? //优惠券状态
    var tempEnterpriseName: String? //发券企业名
    var tempType: Int? //当tempType=1时为平台券，tempType = 0 时为店铺券。。
    var couponDtoShopList: [UseShopModel]?
    
    var showShopNameList = false //本地字段判断是否展示店铺列表
    /// 优惠券描述字段
    var couponDescribe:String = "";
    var couponFullName: String?{ //优惠券名称
        get {
            return "满" + "\(limitprice ?? 0)" + "减" + "\(denomination ?? 0)"
        }
    }
    // MARK: - life cycle
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> CommonCouponNewModel {
        let json = JSON(json)
        let model = CommonCouponNewModel()
        model.received = json["received"].boolValue
        //已领取优惠券字段
        model.couponCode = json["couponCode"].stringValue
        model.couponTempCode = json["couponTempCode"].stringValue
        model.couponTempId = json["couponTempId"].intValue
        model.createTime = json["createTime"].stringValue
        model.noCheckByMutex = json["noCheckByMutex"].boolValue
        model.tempEnterpriseId = json["tempEnterpriseId"].stringValue
        //（1:未领取时，如果是绝对时间，返回begindate，endDate ，如果是相对时间（比如领取后10天生效）2:领取后直接取begindate，endDate）
        model.begindate = json["begindate"].stringValue.removeHHMMSS()
        model.endDate = json["endDate"].stringValue.removeHHMMSS()
        //未领取优惠券字段
        model.auditStatus = json["auditStatus"].intValue
        model.couponAreaType = json["couponAreaType"].intValue
        model.couponSequence = json["couponSequence"].intValue
        model.couponTimeText = json["couponTimeText"].stringValue
        model.couponType = json["couponType"].intValue
        model.creator = json["creator"].stringValue
        model.discount_degree = json["discount_degree"].floatValue
        model.effectiveDays = json["effectiveDays"].intValue
        model.effectiveType = json["effectiveType"].intValue
        model.getCondition = json["getCondition"].intValue
        model.groupType = json["getCondition"].stringValue
        model.isLimitAmount = json["isLimitAmount"].intValue
        model.templateCode = json["templateCode"].stringValue
        //公共参数
        model.couponName = json["couponName"].stringValue
        model.denomination = json["denomination"].intValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.id = json["id"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.isLimitShop = json["isLimitShop"].intValue
        model.repeatAmount = json["repeatAmount"].intValue
        model.status = json["status"].intValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        model.tempType = json["tempType"].intValue
        //需要兼容字段
        
        model.limitprice = json["limitprice"].intValue
        //兼容直播间返回的model
        if let limitNum = json["limitPrice"].int {
            model.limitprice = limitNum
        }
        model.couponDescribe = json["couponDescribe"].stringValue
        
        var couponDtoShopList = [UseShopModel]()
        if let arr = json["allowShops"].arrayObject {
            for dic in arr {
                if let json = dic as? [String : AnyObject] {
                    couponDtoShopList.append(UseShopModel.pareDicWithCommonJSON(json))
                }
                
            }
        }
        //兼容直播间返回的model
        if let arr = json["relateShops"].arrayObject {
            for dic in arr {
                if let json = dic as? [String : AnyObject] {
                    couponDtoShopList.append(UseShopModel.fromJSON(json))
                }
                
            }
        }
        
        model.couponDtoShopList = couponDtoShopList
        return model
    }
}

