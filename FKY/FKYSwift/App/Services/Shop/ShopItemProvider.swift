//
//  ShopProvider.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class ShopItemProvider: NSObject {
    //共用字段
    fileprivate(set) open var nowPage: Int = 1
    fileprivate var per: Int = 10
    fileprivate(set) open var totalPage: Int = 1
    fileprivate var params:[String: AnyObject]?
    //满折专区的请求
    var hasNextPage = true  //判断是否有下一页
    var currentPosition:String = "1_0" //下一个请求页
    
    var enterBaseInfoModel : FKYShopEnterInfoModel? //头部基本信息
    //满折 返利专区列表字段
    var sellerName : String? //店铺名称
    var rebateRuleText : String? //返利规则文描
    var rebateText : String? //返利门槛文描
    
    //满减满赠特价列表需要字段
    var shopProducts: [Any]? //返利专区使用
    // var banners: [HomeBannerModel]?
    var shopInfo: HomeShopModel?
    //var shopDocList: [ShopMaterialModel]?
    fileprivate var enterpriseId: String?
    fileprivate var promotionId: String?
    fileprivate var type: Int?
    
    //更具商户id 获取商户资质信息方法需要字段
    var erpInfos: [ShopMaterialModel]?
    fileprivate var nowPromotionPage: Int = 1
    fileprivate var promotionParams:[String: AnyObject]?
    
    //加车方法需要字段
    fileprivate var typeIndex : Int = 0 //类型
    
    var shareTypeName: String? //分享来源 埋点用
    
    
    fileprivate var logic: HJLogic?
    
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    fileprivate lazy var shopItemlogic: ShopItemLogic? = {
        return ShopItemLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? ShopItemLogic
    }()
    
    fileprivate lazy var cartService: FKYCartNetRequstSever? = {
        return FKYCartNetRequstSever.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYCartNetRequstSever
    }()
    
    override init() {
        //  self.banners = []
        self.shopInfo = nil
        self.erpInfos = []
        self.shopProducts = []
    }
    
    
    /// /// 商详上报后台游览数据《李瑞安》
    func upLoadViewData(enterpriseId:String,spuCode:String,sellerCode:String){
        guard FKYLoginAPI.loginStatus() != FKYLoginStatus.unlogin else {
            return
        }
        let param = ["enterpriseId":enterpriseId,"spuCode":spuCode,"sellerCode":sellerCode]
        FKYRequestService.sharedInstance()?.upLoadViewData(withParam: param, completionBlock: { (isSuccess, error, response, model) in
            
        })
    }
    
    //多品专区商品信息
    func getRebateShopItem(_ params:[String: AnyObject]? ,callback:@escaping ()->(), errorCallBack:@escaping ((_ statusCode: Int, _ message: String)->())) {
        self.enterpriseId = params!["enterpriseId"]! as? String
        self.promotionId = params!["promotionId"] as? String
        self.per = 10
        self.params = ["enterpriseId": params!["enterpriseId"]!,
                       "position": self.currentPosition as AnyObject,
                       "pageSize": self.per as AnyObject,
                       "activityId": self.promotionId! as AnyObject
        ]
        
        FKYRequestService.sharedInstance()?.requestForRebateMargin(withParam: self.params, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = error?.localizedDescription ?? "切数据请求失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                errorCallBack(-2, msg)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary{
                if strongSelf.currentPosition == "1_0"{
                    //第一个清空数据
                    strongSelf.shopProducts?.removeAll()
                }
                if  let prodArray = json.object(forKey: "productList") as? NSArray {
                    let prods:[HomeCommonProductModel] = prodArray.mapToObjectArray(HomeCommonProductModel.self)!
                    strongSelf.shopProducts?.append(contentsOf: prods)
                    if prodArray.count < strongSelf.per || strongSelf.currentPosition.isEmpty == true {
                        strongSelf.hasNextPage = false
                    }else{
                        strongSelf.hasNextPage = true
                    }
                }else{
                    strongSelf.hasNextPage = false
                }
                
                if let sellerNameStr = json.object(forKey: "enterpriseName") as? String {
                    strongSelf.sellerName = sellerNameStr
                }
                if let  position = json.object(forKey: "position") as? String {
                    strongSelf.currentPosition =  position
                }
                if let desc = json.object(forKey: "rebateRuleText") as? String {
                    strongSelf.rebateRuleText = desc
                }
                if let rebateTex = json.object(forKey: "rebateText") as? String {
                    strongSelf.rebateText = rebateTex
                }
                callback()
            }
            
        })
    }
    //满折专区商品信息
    func getFullDiscountShopItem(_ params:[String: AnyObject]? ,callback:@escaping ()->(), errorCallBack:@escaping ((_ statusCode: Int, _ message: String)->())) {
        self.enterpriseId = params!["enterpriseId"]! as? String
        self.promotionId = params!["promotionId"] as? String
        self.per = 10
        self.params = ["enterpriseId": params!["enterpriseId"]!,
                       "position": self.currentPosition as AnyObject,
                       "pageSize": self.per as AnyObject,
                       "promotionId": self.promotionId! as AnyObject
        ]
        
        FKYRequestService.sharedInstance()?.requestForFullDiscountMargin(withParam: self.params, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = error?.localizedDescription ?? "切数据请求失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                errorCallBack(-2, msg)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary{
                if strongSelf.currentPosition == "1_0"{
                    //第一个清空数据
                    strongSelf.shopProducts?.removeAll()
                }
                if  let prodArray = json.object(forKey: "productList") as? NSArray {
                    let prods:[HomeCommonProductModel] = prodArray.mapToObjectArray(HomeCommonProductModel.self)!
                    strongSelf.shopProducts?.append(contentsOf: prods)
                    if prodArray.count < strongSelf.per || strongSelf.currentPosition.isEmpty == true {
                        strongSelf.hasNextPage = false
                    }else{
                        strongSelf.hasNextPage = true
                    }
                }else{
                    strongSelf.hasNextPage = false
                }
                
                if let sellerNameStr = json.object(forKey: "enterpriseName") as? String {
                    strongSelf.sellerName = sellerNameStr
                }
                if let  position = json.object(forKey: "position") as? String {
                    strongSelf.currentPosition =  position
                }
                if let desc = json.object(forKey: "desc") as? String {
                    strongSelf.rebateRuleText = desc
                }
                callback()
            }
            
        })
    }
    //特价专区商品信息
    func getSpecialPriceShopItem(_ params:[String: AnyObject]? ,callback:@escaping ()->(), errorCallBack:@escaping ((_ statusCode: Int, _ message: String)->())) {
        self.enterpriseId = params!["enterpriseId"]! as? String
        self.per = 10
        self.params = ["enterpriseId": params!["enterpriseId"]!,
                       "position": self.currentPosition as AnyObject,
                       "pageSize": self.per as AnyObject,
        ]
        
        FKYRequestService.sharedInstance()?.requestForSpecialMargin(withParam: self.params, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = error?.localizedDescription ?? "切数据请求失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                errorCallBack(-2, msg)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary{
                if strongSelf.currentPosition == "1_0"{
                    //第一个清空数据
                    strongSelf.shopProducts?.removeAll()
                }
                if  let prodArray = json.object(forKey: "productList") as? NSArray {
                    let prods:[HomeCommonProductModel] = prodArray.mapToObjectArray(HomeCommonProductModel.self)!
                    strongSelf.shopProducts?.append(contentsOf: prods)
                    if prodArray.count < strongSelf.per || strongSelf.currentPosition.isEmpty == true {
                        strongSelf.hasNextPage = false
                    }else{
                        strongSelf.hasNextPage = true
                    }
                }else{
                    strongSelf.hasNextPage = false
                }
                
                if let sellerNameStr = json.object(forKey: "enterpriseName") as? String {
                    strongSelf.sellerName = sellerNameStr
                }
                if let  position = json.object(forKey: "position") as? String {
                    strongSelf.currentPosition =  position
                }
                if let desc = json.object(forKey: "desc") as? String {
                    strongSelf.rebateRuleText = desc
                }
                callback()
            }
            
        })
    }
    // 满减 满赠
    func getShopItem(_ params:[String: AnyObject]? ,callback:@escaping ()->(), errorCallBack:@escaping ((_ statusCode: Int, _ message: String)->())) {
        self.enterpriseId = params!["enterpriseId"]! as? String
        self.type = params!["type"] as? Int
        self.promotionId = params!["promotionId"] as? String
        self.nowPage = 1
        self.per = 10
        self.params = ["enterpriseId": params!["enterpriseId"]!,
                       "keyword": params!["keyword"]!,
                       "priceSeq": params!["priceSeq"]!,
                       "nowPage": self.nowPage as AnyObject,
                       "per": self.per as AnyObject,
                       "queryAll": "yes" as AnyObject,
                       "promotionId": self.promotionId! as AnyObject
        ]
        if let type = self.type, self.type != 2 {
            self.params!["type"] = type as AnyObject
        }
        
        _ = self.publicService?.getShopIndexBlock(withParam:self.params, completionBlock: {[weak self] (responseObject, anError)  in
            if anError == nil {
                guard let strongSelf = self else {
                    return
                }
                if let data = responseObject as? NSDictionary  {
                    if  let shopDic = data.object(forKey: "shopInfo") as? NSDictionary {
                        strongSelf.shopInfo = shopDic.mapToObject(HomeShopModel.self)
                    }
                    if  let prodArray = data.object(forKey: "shopProducts") as? NSArray {
                        strongSelf.shopProducts = prodArray.mapToObjectArray(HomeProductModel.self)
                        
                        if strongSelf.shopProducts != nil {
                            for product in strongSelf.shopProducts! {
                                if let  productModel = product as? HomeProductModel{
                                    if let houseName = productModel.ziyingTag, houseName.isEmpty == false {
                                        productModel.isZiYingFlag = 1
                                    }
                                }
                                
                            }
                        }
                        
                        strongSelf.totalPage = data.object(forKey: "pageCount") as! Int
                    }
                }
                callback()
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请重新登录。")
                    }
                }
                let msg = anError?.localizedDescription ?? "数据请求失败"
                errorCallBack(-2, msg)
            }
        })
    }
    
    func getNextProductList(_ callback:@escaping ()->()) {
        if self.hasNext() {
            self.nowPage = self.nowPage + 1
            self.params = ["nowPage":  "\(self.nowPage)" as AnyObject,
                           "per": "\(10)" as AnyObject,
                           "keyword": "" as AnyObject,
                           "priceSeq": "default" as AnyObject,
                           "enterpriseId": self.enterpriseId! as AnyObject,
                           "queryAll":"no" as AnyObject,
                           "promotionId": self.promotionId! as AnyObject]
            if let type = self.type, self.type != 2 {
                self.params!["type"] = type as AnyObject
            }
            
            _ = self.publicService?.getShopIndexBlock(withParam:self.params, completionBlock: {[weak self] (responseObject, anError)  in
                guard let strongSelf = self else {
                    return
                }
                if anError == nil {
                    if  let prodArray = (responseObject as AnyObject).value(forKeyPath: "shopProducts") as? NSArray {
                        let prods:[HomeProductModel] = prodArray.mapToObjectArray(HomeProductModel.self)!
                        prods.forEach({ (model) in
                            if let houseName = model.ziyingTag, houseName.isEmpty == false {
                                model.isZiYingFlag = 1
                            }
                            strongSelf.shopProducts!.append(model)
                        })
                    }
                }
                else {
                    if let err = anError {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            FKYAppDelegate!.showToast("用户登录过期, 请重新登录。")
                        }
                    }
                }
                callback()
            })
        }
        else {
            callback()
        }
    }
    
    func hasNext() -> Bool {
        return self.totalPage > self.nowPage
    }
    
    //获取返利专区列表数据
    func getProfitList(_ params:[String: AnyObject]?, _ shopId:String? ,_ isFresh:Bool ,errorCallBack:@escaping (( _ message: String?)->())){
        var desParams :[String: AnyObject] = [:]
        self.per = 10
        if isFresh == true {
            //刷新
            self.shopProducts!.removeAll()
            self.nowPage = 1
        }else {
            //加载更多
            self.nowPage = self.nowPage + 1
        }
        desParams["pageNo"] = "\(self.nowPage)" as AnyObject
        desParams["pageSize"] = "\(self.per)" as AnyObject
        desParams["activityId"] = params!["promotionId"] as AnyObject
        desParams["enterpriseId"] = (shopId ?? "") as AnyObject
        FKYRequestService.sharedInstance()?.getProfitListInfo(withParam: desParams, completionBlock: {[weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                errorCallBack(msg)
                return
            }
            // 解析数据
            if let data = response as? NSDictionary {
                if  let prodArray = data.object(forKey: "productList") as? NSArray {
                    prodArray.forEach({ (dic) in
                        if let jsonDic =  dic as? [String : AnyObject] {
                            strongSelf.shopProducts!.append(HomeProductModel.parseProfitProductArr(jsonDic))
                        }
                    })
                }
                if let pageNum = data.object(forKey: "pageCount") as? Int {
                    strongSelf.totalPage = pageNum
                }
                if let sellerNameStr = data.object(forKey: "sellerName") as? String {
                    strongSelf.sellerName = sellerNameStr
                }
                if let rebateRuleStr = data.object(forKey: "rebateRuleText") as? String {
                    strongSelf.rebateRuleText = rebateRuleStr
                }
                if let rebateStr = data.object(forKey: "rebateText") as? String {
                    strongSelf.rebateText = rebateStr
                }
                errorCallBack(nil)
            }
            else {
                errorCallBack("获取失败")
            }
        })
        
    }
    //获取返利的文描
    func getProfitRebateText(_ params:[String: AnyObject]?,errorCallBack:@escaping ((_ tipStr :String?)->())){
        FKYRequestService.sharedInstance()?.getProfitRebateInfo(withParam: params, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                errorCallBack(nil)
                return
            }
            //解析数据
            if let data = response as? NSDictionary  {
                if let rebateMessageStr = data.object(forKey: "multiRebateMessage") as? String {
                    errorCallBack(rebateMessageStr)
                }
                errorCallBack(nil)
            }
            errorCallBack(nil)
        })
    }
    
    // MARK:加车
    func addShopCart(_ model: Any,_ sourceType:String? ,count: Int, completionClosure:@escaping (_ reason: String?, _ model: Any?)->()) {
        //
        var paramJson =  [String: Any]()
        var paramArray = [Any]()
        paramJson["addType"] = "1"
        paramJson["sourceType"] = sourceType ?? ""
        //分享bd 的佣金Id
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            paramJson["shareUserId"] = cpsbd
        }
        if let productCellModel = model as? HomeProductModel {
            //旧的产品模型
            var params = ["supplyId": "\(productCellModel.vendorId)",
                "spuCode": "\(productCellModel.productId)",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            if (productCellModel.productPromotion != nil && productCellModel.productPromotion!.promotionId != nil) {
                params["promotionId"] = productCellModel.productPromotion!.promotionId!;
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params);
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productCellModel.productId, sellerCode: "\(productCellModel.vendorId)")
        }
        else if let productNewModel = model as? ShopProductCellModel {
            //新的模型
            var params = ["supplyId": "\(productNewModel.vendorId!)",
                "spuCode": "\(productNewModel.productId!)",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            if (productNewModel.productPromotion != nil && productNewModel.productPromotion!.promotionId != nil) {
                params["promotionId"] = productNewModel.productPromotion!.promotionId!;
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productId!, sellerCode: "\(productNewModel.vendorId!)")
        }
        else if let productNewModel = model as? OftenBuyProductItemModel {
            // 常购清单改版模型
            var params = ["supplyId": "\(productNewModel.supplyId!)",
                "spuCode": "\(productNewModel.spuCode!)",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params);
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode!, sellerCode: "\(productNewModel.supplyId!)")
        }else if let productNewModel = model as? FKYTogeterBuyModel {
            //一起购商品列表返回模型
            var params = ["supplyId": "\(productNewModel.enterpriseId!)",
                "spuCode": "\(productNewModel.spuCode!)",
                "productNum": "\(count)",
                "promotionId" : productNewModel.togeterBuyId
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            paramJson["fromwhere"] = "2"
            self.typeIndex = 4
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode!, sellerCode: productNewModel.enterpriseId!)
        }else if let productNewModel = model as? FKYTogeterBuyDetailModel {
            //一起购商品详情模型
            var params = ["supplyId": "\(productNewModel.sellerId!)",
                "spuCode": "\(productNewModel.spuCode!)",
                "productNum": "\(count)",
                "promotionId" : productNewModel.buyTogetherId
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            paramJson["fromwhere"] = "2"
            self.typeIndex = 4
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode!, sellerCode: productNewModel.sellerId!)
        }else if let productNewModel = model as? FKYFullProductModel {
            var params = ["supplyId": productNewModel.enterpriseId,
                          "spuCode": "\(productNewModel.spuCode ?? "0")",
                "productNum": "\(count)",
                "promotionId" : "\(productNewModel.promotionId ?? 0)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode ?? "0", sellerCode: productNewModel.enterpriseId ?? "")
        }else if let productNewModel = model as? FKYMedicinePrdDetModel{
            //中药材加车
            var params = ["supplyId": productNewModel.productSupplyId ?? "0",
                          "spuCode":  productNewModel.productCode ?? "0",
                          "productNum": "\(count)",
                "promotionId" : productNewModel.promotionId ?? "0"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productCode ?? "0", sellerCode: productNewModel.productSupplyId ?? "0")
        }else if let productNewModel = model as? ComboListModel{ // 固定套餐加车
            for item : ComboProductListModel in productNewModel.productList! {
                let params : NSMutableDictionary = NSMutableDictionary.init()
                params.setValue(item.supplyId, forKey: "supplyId")
                params.setValue("\((Int(item.doorsill!)! * count))", forKey: "productNum")
                params.setValue((model as! ComboListModel).promotionId, forKey: "promotionId")
                params.setValue(item.spuCode, forKey: "spuCode")
                if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                    params.setValue(FKYPush.sharedInstance().pushID ?? "", forKey: "pushId")
                }
                paramArray.append(params)
            }
            paramJson["addType"] = "3"

        }else if let productNewModel = model as? SeckillActivityProductsModel {// 秒杀加车
            //新的模型
            var params = ["supplyId": productNewModel.sellerCode ?? "0",
                          "spuCode": "\(productNewModel.spuCode!)",
                "productNum": "\((Int(productNewModel.seckillMinimumPacking!)! * count))"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode!, sellerCode: productNewModel.sellerCode ?? "0")
        }else if let productNewModel = model as? FKYSameProductModel {
            //商品详情中推荐商品加车
            var params = ["supplyId": "\(productNewModel.supplyId!)",
                "spuCode": "\(productNewModel.spuCode!)",
                "productNum": "\(count)"
            ]
            if let promotionArr = productNewModel.promotionList ,promotionArr.count > 0 {
                let productPromotion = promotionArr[0]
                params["promotionId"] = productPromotion.promotionId
            }
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode!, sellerCode: productNewModel.supplyId!)
        }else if let productNewModel = model as? HomeCommonProductModel {
            //商品详情中推荐商品加车
            var params = ["supplyId": "\(productNewModel.supplyId)",
                "spuCode": "\(productNewModel.spuCode)",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode, sellerCode: "\(productNewModel.supplyId)")
        }else if let productNewModel = model as? HomeRecommendProductItemModel {
            //商品详情中推荐商品加车
            
            if  productNewModel.isTogetherProduct{
                //一起购
                var params = ["supplyId": "\(productNewModel.supplyId!)",
                    "spuCode": "\(productNewModel.productCode!)",
                    "productNum": "\(count)",
                    "promotionId" : "\(productNewModel.buyTogetherId!)" 
                ]
                if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                    params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
                }
                paramJson["fromwhere"] = "2"
                self.params = params as [String : AnyObject]
                paramArray.append(params)
                upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productCode!, sellerCode: "\(productNewModel.supplyId!)")
            }else{
                var params = ["supplyId": "\(productNewModel.supplyId!)",
                    "spuCode": "\(productNewModel.productCode!)",
                    "productNum": "\(count)"
                ]
                if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                    params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
                }
                self.params = params as [String : AnyObject]
                paramArray.append(params)
                upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productCode!, sellerCode: "\(productNewModel.supplyId!)")
            }
        }else if let productNewModel = model as? ShopListProductItemModel{
            //MARK:店铺馆首页普通商品模型
            var params = [
                "supplyId": productNewModel.productSupplyId,
                "spuCode": productNewModel.productCode,
                "productNum": "\(count)",
                "promotionId":productNewModel.promotionId
                ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productCode ?? "", sellerCode: productNewModel.productSupplyId ?? "")
        }else if let productNewModel = model as? ShopListSecondKillProductItemModel{
            //MARK:店铺馆首页秒杀商品模型
            var params = [
                "supplyId": productNewModel.productSupplyId,
                "spuCode": productNewModel.productCode,
                "productNum": "\(count)",
                "promotionId":productNewModel.promotionId
                ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.productCode ?? "", sellerCode: productNewModel.productSupplyId ?? "")
        }else if let productNewModel = model as? FKYProductObject{
            //MARK:店铺馆首页秒杀商品模型
            var params = [
                "supplyId": productNewModel.sellerCode,
                "spuCode": productNewModel.spuCode,
                "productNum": "\(count)",
                ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            if let promotionArr = productNewModel.promotionList ,promotionArr.count > 0 {
                let productPromotion = promotionArr[0]
                params["promotionId"] = (productPromotion as AnyObject).promotionId
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode, sellerCode: productNewModel.sellerCode)
        }else if let productNewModel = model as? ShopProductItemModel{
            //MARK:店铺馆全部商品
            var params = [
                "supplyId": productNewModel.sellerCode ,
                "spuCode": productNewModel.spuCode ,
                "productNum": "\(count)" ,
                ]
            //            if let promotionArr = productNewModel.productPromotionInfos ,promotionArr.count > 0 {
            //                let productPromotion = promotionArr[0]
            //                params["promotionId"] = (productPromotion as AnyObject).promotionId
            //            }
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode ?? "", sellerCode:  productNewModel.sellerCode ?? "")
        }else if let productNewModel = model as? FKYShopPromotionBaseProductModel {
            //新的模型
            var params = ["supplyId": "\(productNewModel.sellerCode ?? "")",
                "spuCode": "\(productNewModel.spuCode ?? "" )",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            if let promotionModel = productNewModel.productPromotion ,let proId = promotionModel.promotionId {
                params["promotionId"] = proId
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode ?? "" , sellerCode: productNewModel.sellerCode ?? "")
        }else if let productNewModel = model as? HomeRecommendProductItemModel {
            //新的模型
            var params = ["supplyId": "\(productNewModel.supplyId ?? 0)",
                "spuCode": "\(productNewModel.spuCode ?? "" )",
                "productNum": "\(count)"
            ]
            //            if let promotionModel = productNewModel.productPromotion ,let proId = promotionModel.promotionId {
            //                params["promotionId"] = proId
            //            }
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode ?? "", sellerCode: "\(productNewModel.supplyId ?? 0)")
        }else if let productNewModel = model as? FKYPreferetailModel {
            //商家特惠
            var params = ["supplyId": "\(productNewModel.sellerCode ?? "0")",
                "spuCode": "\(productNewModel.spuCode ?? "" )",
                "productNum": "\(count)"
            ]
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params)
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productNewModel.spuCode ?? "" , sellerCode: productNewModel.sellerCode ?? "0")
        }
        
        paramJson["ItemList"] = paramArray
        
        shopItemlogic?.fetchAddShoppingProduct(paramJson, callback: { [weak self](model, error)  in
            guard let strongSelf = self else {
                return
            }
            if error == nil {
                //数据ok
                if let statusCode = (model as AnyObject).value(forKeyPath: "statusCode"), (statusCode as! Int) != 0 {
                    //由于后台不愿意改别人代码，app端兼容判断取那一层message提示错误信息(statusCode==1 取内层message statusCode==2 取外层message)
                    var message : String?
                    if (statusCode as! Int) == 1 {
                        if let arr  = (model as AnyObject).value(forKeyPath: "cartResponseList") as? NSArray ,arr.count > 0 {
                            message =  (arr[0] as AnyObject).value(forKeyPath: "message") as? String
                        }
                    }else {
                        message  = (model as AnyObject).value(forKeyPath: "message") as? String
                    }
                    // 操作失败
                    let data = (model as AnyObject).value(forKeyPath: "data") as AnyObject
                    completionClosure(message ?? "加车失败", data)
                    return
                }
                // 操作成功(解析数据)
                if let data = model{
                    let resultModel = (data as NSDictionary).mapToObject(FKYAddCarResultModel.self)
                    completionClosure("成功", resultModel)
                    if let totalCount = resultModel.productsCount{
                        if strongSelf.typeIndex == 4 {
                            FKYCartModel.shareInstance().togeterBuyProductCount = totalCount
                        }else {
                            FKYCartModel.shareInstance().productCount = totalCount
                        }
                    }
                    //                    if let arr = resultModel.needAlertCartList ,arr.count > 0 {
                    //                        //弹出共享仓提示
                    //                        let pdshareVC = PDShareStockTipVC()
                    //                        pdshareVC.popTitle = "调拨发货提醒"
                    //                        pdshareVC.tipTxt = resultModel.shareStockDesc
                    //                        pdshareVC.dataList = arr
                    //                        pdshareVC.showOrHidePopView(true)
                    //                    }
                }
            }
            else {
                completionClosure(error ?? "加车失败", nil)
            }
        })
    }
    /*
     addType    加车类型（单品加车：1，再次购买：2，固定套餐加车：3，搭配套餐加车：4，批量加车：5）    number    必填（选择批量加车）
     fromwhere    购物车类型（3：立即下单，4：小程序立即下单，5：单品包邮加车）    number    必填
     itemList    需要校验的商品列表    array<object>
         productNum    商品购买数量    string    必填
         promotionId    单品包邮活动商品主键id    number    非必填（单品包邮必填）
         spuCode    商品的spu编码    string    必填
         supplyId    供应商企业ID    string    必填
         wisdomBuyVersion    智采版本号    number    非必填（智采必填）
     shareUserId    分佣者id    string    非必填（小程序立即下单必填）
     sourceType    加车来源类型    number    非必填（不填默认为0）
     */
    //MARK:即下单商品校验
    func checkSingleProductInfoWithBuyRightNow(_ model: Any,_ sourceType:String? ,count: Int, completionClosure:@escaping (_ reason: String?, _ model: Any?)->()) {
        var paramJson =  [String: Any]()
        var paramArray = [Any]()
        paramJson["addType"] = "1"
        paramJson["sourceType"] = sourceType ?? ""
        //分享bd 的佣金Id
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            paramJson["shareUserId"] = cpsbd
        }
        if let productCellModel = model as? FKYPackageRateModel {
            //单品包邮
            var params = ["supplyId": "\(productCellModel.enterpriseId ?? 0)",
                "spuCode": productCellModel.spuCode,
                "productNum": "\(count)"
            ]
            params["promotionId"] = "\(productCellModel.promotionId ?? 0)"
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                params["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            self.params = params as [String : AnyObject]
            paramArray.append(params);
            paramJson["fromwhere"] = "5"
            upLoadViewData(enterpriseId: FKYLoginAPI.currentUser()?.ycenterpriseId ?? "", spuCode: productCellModel.spuCode ?? "", sellerCode: "\(productCellModel.enterpriseId ?? 0)")
        }
        paramJson["ItemList"] = paramArray
        FKYRequestService.sharedInstance()?.postCheckSimpleItemInfo(withParam: paramJson, completionBlock: { [weak self] (success, error, response, model) in
            guard let _ = self else{
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "验证失败"
                completionClosure(msg,nil)
                return
            }
            if let data = response as? Dictionary<String,AnyObject> {
                if let getCode = data["statusCode"] as? Int ,getCode == 0 {
                    //是否可以进入检查页标识 0：可以 1：不可以
                    completionClosure(nil,nil)
                }else {
                    var message : String?
                    if let checkSimpleArr = data["checkSimpleList"] as? NSArray,checkSimpleArr.count > 0 {
                        message = (checkSimpleArr[0] as AnyObject).value(forKeyPath: "message") as? String
                    }
                    completionClosure(message ?? "验证失败",nil)
                }
            }else {
                completionClosure("验证失败",nil)
            }
        })
    }
    
    func queryCartPromotion(_ promotionId:String?, completionClosure:@escaping (_ reason: String?)->()) {
        var params = ["promotionId": promotionId ?? ""]
        _ = self.cartService?.queryFullReductionInfoBlock(withParam: params, completionBlock: {[weak self](responseObject, anError)  in
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    if(!data.isKind(of: NSNull.self)) {
                        // let totalCount = data["totalCount"] as! Int
                        // let totalPrice = Float(data["totalPrice"] as! Double)
                        //  let msg = data["msg"]  as! String  //self.generateToastMessage(totalCount, totalPrice: totalPrice,promotionModel: promotion!)
                        //    let msg =  self.generateToastMessage(totalCount, totalPrice: totalPrice,promotionModel: promotion!)
                        var msg = ""
                        if let m = data["msg"] as? String , m.isEmpty == false {
                            msg = m
                        }
                        completionClosure(msg)
                        return
                    }
                }
                completionClosure(nil)
                // }
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请重新登录。")
                    }
                }
                completionClosure(nil)
            }
        })
    }
    
    func generateToastMessage(_ count: NSInteger, totalPrice: Float, promotionModel:FKYPromationInfoModel) -> String? {
        var promotionDes = ""
        if promotionModel.promotionType == nil {
            return promotionDes
        }
        if promotionModel.ruleList == nil || promotionModel.ruleList!.count <= 0 {
            return nil
        }
        
        var object = promotionModel.ruleList.first as! CartPromotionRule
        
        var i = 0
        while i < promotionModel.ruleList.count {
            let model = promotionModel.ruleList[i] as! CartPromotionRule
            if promotionModel.promotionPre != nil {
                if promotionModel.promotionPre.intValue == 0 {
                    if model.promotionSum.floatValue > totalPrice {
                        object = model
                        break
                    }
                    else if i == promotionModel.ruleList.count - 1{
                        object = model
                        break
                    }
                }
                else {
                    if model.promotionSum.intValue > count {
                        object = model
                        break
                    }
                    else if i == promotionModel.ruleList.count - 1{
                        object = model
                        break
                    }
                }
            }
            i+=1
        }
        
        var unit = ""
        if promotionModel.promotionPre != nil && promotionModel.promotionPre.intValue == 1 {
            unit = "盒"
        }
        if promotionModel.promotionPre != nil && promotionModel.promotionPre.intValue == 0 {
            unit = "元"
        }
        
        let type = Int(promotionModel.promotionType)
        //满减
        if (type == 2 || type == 3) {
            if (promotionModel.promotionPre != nil) {
                if Int(promotionModel.promotionPre) == 0 {
                    if totalPrice < object.promotionSum.floatValue {
                        promotionDes = "您已购买\(totalPrice)\(unit), 还差\(object.promotionSum.floatValue - totalPrice)\(unit),就可立"
                    }else{
                        promotionDes = "您已购买\(totalPrice)\(unit),立"
                    }
                }else{
                    if count < object.promotionSum!.intValue {
                        promotionDes = "您已购买\(count)\(unit), 还差\(NSInteger(object.promotionSum!) - count)\(unit),就可立"
                    }else{
                        promotionDes = "您已购买\(count)\(unit),"
                    }
                }
            }
            if (promotionModel.method != nil) {
                if Int(promotionModel.method) == 0 {
                    promotionDes = promotionDes + "减\(object.promotionMinu!)元"
                }else if Int(promotionModel.method) == 1 {
                    promotionDes = promotionDes + "打\(object.promotionMinu!)折"
                }else if Int(promotionModel.method) == 2 {
                    promotionDes = promotionDes + "每个立减\(object.promotionMinu!)元"
                }
            }
            return promotionDes
        }
        //满赠
        if (type == 5 || type == 6) {
            if (promotionModel.promotionPre != nil) {
                if promotionModel.promotionPre.intValue == 0 {
                    if totalPrice < object.promotionSum.floatValue {
                        promotionDes = "您已购买\(totalPrice)\(unit), 凑够\(object.promotionSum!)\(unit),就可以赠送\(object.promotionMinu!)"
                    }else{
                        promotionDes = "您已购买\(totalPrice)\(unit), 可赠送\(object.promotionMinu!)"
                    }
                }else{
                    if count < object.promotionSum!.intValue {
                        promotionDes = "您已购买\(count)\(unit), 凑够\(object.promotionSum!)\(unit),就可以赠送\(object.promotionMinu!)"
                    }else{
                        promotionDes = "您已购买\(count)\(unit), 可赠送\(object.promotionMinu!)"
                    }
                }
            }
            return promotionDes
        }
        //满赠积分
        if (type == 7 || type == 8) {
            if (promotionModel.promotionPre != nil) {
                if promotionModel.promotionPre.intValue == 0 {
                    if totalPrice < object.promotionSum.floatValue {
                        
                        if promotionModel.method.int32Value == 0 {
                            
                            promotionDes = "您已购买\(totalPrice)\(unit), 凑够\(object.promotionSum!)\(unit),就可以赠送\(object.promotionMinu!)积分"
                        }else{
                            promotionDes = "您已购买\(totalPrice)\(unit), 凑够\(object.promotionSum!)\(unit),就可以每件赠送\(object.promotionMinu!)积分"
                        }
                    }else{
                        
                        if promotionModel.method.int32Value == 0 {
                            promotionDes = "您已购买\(totalPrice)\(unit), 可赠送\(object.promotionMinu!)积分"
                        }else{
                            promotionDes = "您已购买\(totalPrice)\(unit), 每件可赠送\(object.promotionMinu!)积分"
                            
                        }
                    }
                }else{
                    if count < object.promotionSum!.intValue {
                        if promotionModel.method.int32Value == 0 {
                            
                            promotionDes = "您已购买\(count)\(unit), 凑够\(object.promotionSum!)\(unit),就可以赠送\(object.promotionMinu!)积分"
                        }else{
                            promotionDes = "您已购买\(count)\(unit), 凑够\(object.promotionSum!)\(unit),每件就可以赠送\(object.promotionMinu!)积分"
                        }
                    }else{
                        
                        if promotionModel.method.int32Value == 0 {
                            promotionDes = "您已购买\(count)\(unit), 可赠送\(object.promotionMinu!)积分"
                        }else{
                            promotionDes = "您已购买\(count)\(unit), 每件可赠送\(object.promotionMinu!)积分"
                        }
                        
                    }
                }
            }
            return promotionDes
        }
        //加价购
        if (type == 9) {
            if object.productPromotionChange == nil || object.productPromotionChange.count <= 0 {
                return nil
            }
            
            var unit = ""
            var strTotalPrice: String = ""
            var strPromotionSum: String = ""
            if promotionModel.promotionPre != nil && promotionModel.promotionPre.intValue == 1 {
                if let ruleDes = promotionModel.unit {
                    unit = ruleDes
                }else {
                    unit = "盒"
                }
                strTotalPrice = "\(Int(count))"
                strPromotionSum = String.init(format: "%.zi", object.promotionSum.intValue)
                
                if let giftProducts =  (object.productPromotionChange as NSArray).value(forKey: "shortName") as? NSArray {
                    if count < object.promotionSum.intValue {
                        promotionDes = "您已购买\(strTotalPrice)\(unit), 凑够\(strPromotionSum)\(unit)"
                    }else{
                        promotionDes = "您已购满\(strPromotionSum)\(unit);"
                    }
                    promotionDes = promotionDes + "可换购\(giftProducts.componentsJoined(by: "、"));"
                    
                    return promotionDes
                }else {
                    return nil
                }
            }
            if promotionModel.promotionPre != nil && promotionModel.promotionPre.intValue == 0 {
                unit = "元"
                strTotalPrice = String.init(format: "%.2f", totalPrice)
                strPromotionSum = String.init(format: "%.2f", object.promotionSum.floatValue)
                
                if let giftProducts =  (object.productPromotionChange as NSArray).value(forKey: "shortName") as? NSArray {
                    if totalPrice < object.promotionSum.floatValue {
                        promotionDes = "您已购买\(strTotalPrice)\(unit), 凑够\(strPromotionSum)\(unit)"
                    }else{
                        promotionDes = "您已购满\(strPromotionSum)\(unit);"
                    }
                    promotionDes = promotionDes + "可换购\(giftProducts.componentsJoined(by: "、"));"
                    
                    return promotionDes
                }else {
                    return nil
                }
            }
        }
        return nil
    }
    
    // MARK - 更具商户id 获取商户资质信息
    func getSupplyInfo(_ params:[String: String]? ,callback:@escaping (NSArray?,String?)->()) {
        self.nowPromotionPage = 1
        self.promotionParams = params! as [String : AnyObject]
        self.publicService?.queryEnterpriseQcListBySupplyIdBlock(withParam: promotionParams, completionBlock: {[weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            if error == nil {
                if let prodArray = response as? NSArray {
                    let prods:[ShopMaterialModel] = prodArray.mapToObjectArray(ShopMaterialModel.self)!
                    prods.forEach({ (model) in
                        strongSelf.erpInfos?.append(model)
                    })
                }
                callback(strongSelf.erpInfos! as NSArray, nil)
            }
            else {
                var errMsg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errMsg = "用户登录过期, 请重新登录。"
                    }
                }
                callback(nil, errMsg)
            }
        })
    }
    
    // MARK - 口令过期判断 & 请求商品列表接口
    // isCommand判断口令是否过期
    func getCrmProductList(_ isRefresh: Bool, _ isCommand: Bool, _ commandShareId: String, _ completionHandler: @escaping (_ success: Bool, _ msg: String?,_ needLoadMore: Bool) -> ()) {
        
        if isRefresh {
            nowPage = 1
            shopProducts?.removeAll()
            totalPage = 0
            per = 10
        }
        
        var param: [String: Any] = ["shareId": commandShareId]
        param["pageIndex"] = nowPage
        param["pageSize"] = per
        
        if let user = FKYLoginAPI.currentUser(), let userId = user.userId {
            param["customerId"] = userId
        } else {
            param["customerId"] = ""
        }
        
        publicService?.getCrmProductList(withParam: param, completionBlock: { [weak self](responseObject, anError) in
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    if let bdShardId = data.object(forKey: "userId"), String(format:"\(bdShardId)").isEmpty == false {
                        FKYLoginAPI.shareInstance()?.bdShardId = String(format:"\(bdShardId)")
                    }
                    guard  let isPast = data.object(forKey: "isPast") as? Int, isPast == 0 else {
                        completionHandler(false, "口令过期", false)
                        return
                    }
                    //解析数据
                    guard isCommand == false else {
                        completionHandler(true, "", true)
                        return
                    }
                    
                    guard let list = data["list"] as? NSArray else {
                        completionHandler(false, "请求失败", true)
                        return
                    }
                    
                    if let shareTypeName = data.object(forKey: "shareTypeName") as? String, shareTypeName.isEmpty == false {
                        self?.shareTypeName = shareTypeName
                    }
                    
                    let canLoadMore = (list.count == self?.per)
                    list.mapToObjectArray(FKYCommandProductModel.self)?.forEach { (model) in
                        self?.shopProducts?.append(model.toHomeProductModel())
                    }
                    
                    if canLoadMore {
                        self?.nowPage += 1
                    }
                    
                    if let total = data.object(forKey: "total") as? Int, total > 0 {
                        if let strongSelf = self {
                            if total % strongSelf.per == 0 {
                                strongSelf.totalPage = total / strongSelf.per
                            }else {
                                strongSelf.totalPage = total / strongSelf.per + 1
                            }
                        }
                    }
                    
                    completionHandler(true, "", canLoadMore)
                    
                } else {
                    completionHandler(false, "请求失败", false)
                }
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2  && isCommand == false{
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请重新登录。")
                    }
                }
                
                completionHandler(false, "请求失败", false)
            }
        })
    }
    
    //获取商家基本信息
    func getShopBaseInfoWithEnterpriseId(_ shopId:String?,_ callback:@escaping (Bool,String?)->()) {
        FKYRequestService.sharedInstance()?.requestForGetShopEnterpriseInfo(withParam: ["enterpriseId":shopId ?? ""], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callback(false,msg)
                return
            }
            if let infoModel = model as? FKYShopEnterInfoModel {
                strongSelf.enterBaseInfoModel = infoModel
                callback(true,infoModel.enterpriseName ?? "")
            }
        })
    }
}
