//
//  ShopProvider.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import RxSwift


class SearchResultProvider: NSObject {
    
    fileprivate var logic: HJLogic? //adapter接口类
    
    // 商品搜索相关
    var productList: NSMutableArray?    // 商品列表
    var shopList: NSMutableArray?       // 店铺列表
    //    var pageCount: NSInteger?           // 总页数...<未使用>
    var totalCount: NSInteger?          // 总条数...<未使用>
    var totalPage: NSInteger?           // 总页数
    var spaceNum: NSInteger = 5           //每个钩子商品的间隔数目
    var tableHeadHeight = WH(0)   //顶部的高度
    var zy_xiaoneng_id: String?         // 小能id???
    var isShowGzProduct: Bool = false          ///  判断是否需要展示第一个钩子商品
    var isShowHotSellProduct: Bool = false          ///  判断是否需要展示了热销商品
    var isShowMPGzProduct: Bool = false          ///  判断是否需要展示MPo钩子商品
    var isShowSearchShopInfo: Bool = false          ///  判断是否需要展示顶部的店铺信息
    var isNormalSearch: Bool = false          ///  判断是否是首页搜索
    var suggestWords = [SearchSuggestModel]()   // 搜索之推荐词
    var gzProductModel : HomeProductModel?   //第一个钩子商品
    var searchShopModel : SearchShopInfoModel?   //店铺信息
    var mpHockProductModel :SearchMpHockProductModel?//mp钩子商品
    var mpGZProductModel : HomeProductModel?   //MP钩子商品传给返利展区
    var hotSellProductModel :ShopProductCellModel? //搜索热销商品
    // 店铺搜索相关
    var sellerList: [SerachSellersInfoModel] = []
    var refreshTableViewAction: emptyClosure?//刷新tableView
    /// recallStatus 1:高分 2:低分 3:   0结果有建议词   4:  0结果无建议词 5 0搜词
    var recallStatus = ""
    var newKeyWord = ""
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    fileprivate lazy var shopItemlogic: ShopItemLogic? = {
        return ShopItemLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? ShopItemLogic
    }()
    
    override init() {
        super.init()
        logic = HJLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HJLogic
        self.productList = []
        self.shopList = []
    }
    // 搜索商品列表
    func getProductList(_ params: [String: AnyObject]?, callback: @escaping ()->()) {
        var mTask: URLSessionDataTask? = URLSessionDataTask.init()
        let param: HJOperationParam = HJOperationParam.init(businessName: "api/search", methodName: "searchProductList", versionNum: "", type: kRequestPost, param: params) {[weak self] (responseObj, error) in
            guard let strongSelf = self else {
                return
            }
            if error != nil {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请重新手动登录")
                    }
                }
                callback()
            }
            else {
                if let json = responseObj as? NSDictionary {
                    
                    ///本次搜索状态
                    strongSelf.recallStatus = ((json as AnyObject).value(forKeyPath: "recallStatus") as? String) ?? ""
                    strongSelf.newKeyWord = ((json as AnyObject).value(forKeyPath: "newKeyWord") as? String) ?? ""
                    // 总页数
                    strongSelf.totalPage = (json as AnyObject).value(forKeyPath: "pageCount") as? NSInteger
                    //self.pageCount = (json as AnyObject).value(forKeyPath: "pageCount") as? NSInteger
                    strongSelf.totalCount = (json as AnyObject).value(forKeyPath: "totalCount") as? NSInteger
                    // 小能id
                    strongSelf.zy_xiaoneng_id = (json as AnyObject).value(forKeyPath: "zy_xiaoneng_id") as? String
                    // 商品列表
                    if  let prodArray = (json as AnyObject).value(forKeyPath: "shopProducts") as? NSArray {
                        strongSelf.productList?.addObjects(from: prodArray.mapToObjectArray(HomeProductModel.self)!)
                        //选取钩子商品并且判断能否是特价和满折来展示
                        if String(format:"\((params as AnyObject).value(forKeyPath: "nowPage") ?? 1)") == "1"{
                            //清空数据
                            strongSelf.isShowGzProduct = false
                            strongSelf.isShowHotSellProduct = false
                            strongSelf.isShowMPGzProduct = false
                            strongSelf.gzProductModel = nil
                            strongSelf.mpHockProductModel = nil
                            //选取钩子商品
                            if strongSelf.isNormalSearch == true{
                                if strongSelf.productList != nil && strongSelf.productList!.count > 0{
                                    let model = strongSelf.productList![0] as! HomeProductModel
                                    let productInfoArray = prodArray.mapToObjectArray(HomeProductModel.self)
                                    
                                    if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0{
                                        //特价
                                        if productInfoArray != nil && productInfoArray!.count > 0 {
                                            let gzModel = productInfoArray![0] as HomeProductModel
                                            if gzModel.statusDesc == 0 && gzModel.isZiYingFlag == 1{
                                                //正常状态下的商品才可以复制成钩子商品
                                                strongSelf.isShowGzProduct = true
                                                gzModel.productType = .TJProduct
                                                if strongSelf.productList!.count > strongSelf.spaceNum{
                                                    strongSelf.productList?.insert(gzModel, at: strongSelf.spaceNum)
                                                }else{
                                                    strongSelf.productList?.add(gzModel)
                                                }
                                            }
                                        }
                                    }else if model.isHasSomeKindPromotion(["16"]) {
                                        //满折
                                        if productInfoArray != nil && productInfoArray!.count > 0 {
                                            let gzModel = productInfoArray![0]  as HomeProductModel
                                            if gzModel.statusDesc == 0 && gzModel.isZiYingFlag == 1{
                                                //正常状态下的商品才可以复制成钩子商品
                                                strongSelf.isShowGzProduct = true
                                                gzModel.productType = .MZProduct
                                                if strongSelf.productList!.count > strongSelf.spaceNum{
                                                    strongSelf.productList?.insert(gzModel, at: strongSelf.spaceNum)
                                                }else{
                                                    strongSelf.productList?.add(gzModel)
                                                }
                                            }
                                        }
                                        
                                    }
                                    //判断是否可以成为展示的钩子商品
                                    if productInfoArray != nil && productInfoArray!.count > 0 {
                                        let gzModel = productInfoArray![0] as HomeProductModel
                                        if gzModel.statusDesc != 2 {
                                            //不再经营范围的不需要判断热销和mp钩子
                                            strongSelf.gzProductModel = gzModel
                                            //第一页不满 不用请求
                                            //if strongSelf.productList != nil && strongSelf.productList!.count >= 2*strongSelf.spaceNum{
                                            strongSelf.getHotSellProduct()
                                            // }
                                        }else{
                                            strongSelf.gzProductModel = nil
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        //获取mp的钩子商品
                        if String(format:"\((params as AnyObject).value(forKeyPath: "nowPage") ?? 1)") == "2"{
                            //第二页不满 不用请求
                            // if (strongSelf.totalCount ?? 0) >= 3*strongSelf.spaceNum{
                            if strongSelf.isNormalSearch == true{
                                strongSelf.getMPHotSellProduct()
                            }
                            //  }
                        }
                    }
                    // 推荐词
                    if  let list = (json as AnyObject).value(forKeyPath: "suggestWords") as? NSArray,
                        let arr = list.mapToObjectArray(SearchSuggestModel.self), arr.count > 0 {
                        strongSelf.suggestWords.removeAll()
                        strongSelf.suggestWords.append(contentsOf: arr)
                    }
                }
                callback()
            }
        }
        mTask = self.logic?.operationManger.request(with: param)
    }
    
    // 加入渠道
    func addToChannl(_ spucode:String, venderId:String, callback:@escaping (_ message:String)->()) {
        let dic = ["spuCode": spucode,
                   "sellerCode": venderId]
        _ = self.publicService?.applyChannelBlock(withParam:dic , completionBlock: {(responseObject, anError)  in
            if anError == nil {
                callback("渠道申请成功，等待审批!")
            }
            else {
                var errMsg = "网络连接失败"
                if let errorUserInfo : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                    errMsg = errorUserInfo
                }
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errMsg = "用户登录过期, 请重新手动登录"
                    }
                }
                callback(errMsg)
            }
        })
    }
    
    //获取店铺信息
    func getSearcheMainShop(_ params: [String: AnyObject]?, callback: @escaping ()->()){
        FKYRequestService.sharedInstance()?.queryLocalMainStoreInfo(withParam: nil, completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                callback()
                return
            }
            selfStrong.isShowSearchShopInfo = false
            guard success else {
                // 失败
                //   var msg = error?.localizedDescription ?? "失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        //msg = "用户登录过期，请重新手动登录"
                    }
                }
                selfStrong.searchShopModel = nil
                callback()
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                if let dicData = data["data"] as? NSDictionary ,dicData.allKeys.count != 0{
                    let model = dicData.mapToObject(SearchShopInfoModel.self)
                    selfStrong.searchShopModel = model
                    selfStrong.isShowSearchShopInfo = true
                }else{
                    selfStrong.searchShopModel = nil
                }
                callback()
                return
            }else{
                selfStrong.searchShopModel = nil
            }
            callback()
        })
    }
    //获取mp钩子商品信息
    func getMPHotSellProduct(){
        let dic = NSMutableDictionary()
        dic["spuCode"] =  self.gzProductModel?.spuCode ?? ""
        FKYRequestService.sharedInstance()?.queryMPHookGood(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                return
            }
            guard success else {
                // 失败
                //  var msg = error?.localizedDescription ?? "失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        //  msg = "用户登录过期，请重新手动登录"
                    }
                }
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                let model = data.mapToObject(SearchMpHockProductModel.self)
                selfStrong.isShowMPGzProduct = true
                selfStrong.mpGZProductModel = HomeProductModel.parseMPHockProduct(data as! [String : AnyObject])
                selfStrong.mpHockProductModel = model
                if  model.productPromotionInfo != nil &&  model.productPromotionInfo?.promotionType == "16"{
                    model.productType = .MZProduct
                }else if let promotionNum =  model.productPromotion?.promotionPrice , promotionNum > 0 {
                    model.productType = .TJProduct
                }
                if selfStrong.isShowGzProduct == true && selfStrong.isShowHotSellProduct == true{
                    //展示了第一个钩子商品和热销
                    if selfStrong.productList!.count >= (3*selfStrong.spaceNum + 2){
                        selfStrong.productList?.insert(model, at: (3*selfStrong.spaceNum + 2))
                    }
                }else if selfStrong.isShowGzProduct == true || selfStrong.isShowHotSellProduct == true{
                    if selfStrong.productList!.count >= (3*selfStrong.spaceNum + 1){
                        selfStrong.productList?.insert(model, at: (3*selfStrong.spaceNum + 1))
                    }
                }else{
                    if selfStrong.productList!.count >= (3*selfStrong.spaceNum){
                        selfStrong.productList?.insert(model, at: (3*selfStrong.spaceNum))
                    }
                    //                    else{
                    //                        selfStrong.productList?.add(model)
                    //                    }
                }
                if let callBack = selfStrong.refreshTableViewAction{
                    callBack()
                }
                return
            }
        })
    }
    //
    //获取自营热销榜商品
    func getHotSellProduct(){
        let dic = NSMutableDictionary()
        dic["spuCode"] =  self.gzProductModel?.spuCode ?? ""
        FKYRequestService.sharedInstance()?.querySearchHotsellInfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                return
            }
            guard success else {
                // 失败
                //  var msg = error?.localizedDescription ?? "失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        //  msg = "用户登录过期，请重新手动登录"
                    }
                }
                return
            }
            if let data = response as? NSDictionary {
                // 请求成功
                if  let prodArray = data.object(forKey: "productList") as? NSArray {
                    prodArray.forEach({ (dic) in
                        if let jsonDic =  dic as? NSDictionary {
                            selfStrong.isShowHotSellProduct = true
                            let model = jsonDic.mapToObject(ShopProductCellModel.self)
                            selfStrong.hotSellProductModel = model
                            if selfStrong.isShowGzProduct == true{
                                //展示了第一个钩子商品
                                if selfStrong.productList!.count >= (2*selfStrong.spaceNum + 1){
                                    selfStrong.productList?.insert(model, at: (2*selfStrong.spaceNum + 1))
                                }
                                //                                else if selfStrong.productList!.count < (2*selfStrong.spaceNum + 1){
                                //                                    //selfStrong.productList?.add(model)
                                //                                }else{
                                //                                    //selfStrong.productList?.add(model)
                                //                                }
                            }else{
                                if selfStrong.productList!.count >= (2*selfStrong.spaceNum){
                                    selfStrong.productList?.insert(model, at: (2*selfStrong.spaceNum))
                                }
//                                    //为了测试暂时放开
//                                else{
//                                    selfStrong.productList?.add(model)
//                                }
                            }
                            if let callBack = selfStrong.refreshTableViewAction{
                                callBack()
                            }
                            return
                        }
                    })
                }
            }
        })
    }
}
