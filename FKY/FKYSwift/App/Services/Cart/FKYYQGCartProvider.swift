//
//  FKYYQGCartProvider.swift
//  FKY
//
//  Created by 寒山 on 2018/10/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

class FKYYQGCartProvider: NSObject {
    //MARK: - Property
    
    fileprivate lazy var cartService: FKYCartNetRequstSever? = {
        return FKYCartNetRequstSever.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYCartNetRequstSever
    }()
    var sectionArray:[CartMerchantInfoModel] = [] // 商家数组...<每个商家均可包含多个商品与套餐>
    var preferetialArr = [CartMerchantInfoModel]() //优惠明细的店铺
    @objc dynamic var changedArray:[CartChangeInfoModel] = [] //库存发生变化的商品列表
    @objc dynamic var selectedAll: Bool = false   // 是否为全选
    @objc dynamic var selectedTotalPrice: Double = 0 // 全选后的总价格
    @objc dynamic var cartPaySum: Double = 0// 所有选中商品的 应付金额 减去满减 金额
    @objc dynamic var discountAmount: Double = 0// 购物车折扣/满减金额
    @objc dynamic var canUseCouponPrice: NSNumber? //可用券商品价格
    @objc dynamic var reducePrice: Double = 0 //已减价格
    
    @objc dynamic var selectedTotalRebate: Double = 0 // 全选后的预计返利信息 价格 app购物车总额（未减满减金额，不包含邮费）
    @objc dynamic var selectedTypeCount: Int = 0  // 购物车中商品类型数量
    @objc dynamic var isEditing:Bool = false // 0: 正常 1: 编辑
    @objc dynamic var cartRebateProductSum:Int = 0; // 所有选中返利商品的 数量
    @objc dynamic var sectionCount: Int = 0  //数组数量
    @objc dynamic var selMerchantCount: Int = 0  //数组数量
    @objc dynamic var foldSectionArray = Set<Int>()//折叠商家的列表
    
    @objc dynamic var totalPrice: Double = 0  //订单总金额
    @objc dynamic var goodsNum: Int = 0   //订单商品数
    
    //获取一起购进去单列表
    func getYQGCartInfoList(withParameter parameter: NSDictionary,handler: @escaping (_ success: Bool, _ message: String)->()){
        self.cartService?.getCartUpdateListBlock(withParam:parameter as! [String : Any], completionBlock: {[weak self](responseObject, anError)  in
            guard let selfStrong = self else {
                handler(false, "请求失败")
                return
            }
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    let model = data.mapToObject(CartInfoViewModel.self)
                    if let supplyCartList = model.supplyCartList,supplyCartList.isEmpty == false{
                        for sectionModel in supplyCartList{
                            sectionModel.configCartSectionRowData()
                            //记录折叠状态
                            for sectionId in selfStrong.foldSectionArray{
                                if sectionModel.supplyId == sectionId{
                                    sectionModel.foldStatus = true
                                }else{
                                    sectionModel.foldStatus = false
                                }
                            }
                        }
                        selfStrong.sectionArray.removeAll()
                        selfStrong.sectionArray.append(contentsOf: supplyCartList)
                    }else{
                        selfStrong.sectionArray.removeAll()
                    }
                    if let arr = model.preferetialCarList,arr.isEmpty == false {
                        selfStrong.preferetialArr.removeAll()
                        selfStrong.preferetialArr.append(contentsOf: arr)
                    }else {
                        selfStrong.preferetialArr.removeAll()
                    }
                    selfStrong.isEditing = false;
                    selfStrong.updateCartInfo(model)
                    handler(true, "获取成功")
                    return
                }
                handler(true,"成功")
            }else{
                var msg = "访问失败"
                if let errorMsg : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                handler(false,msg)
            }
        });
    }
    //一起购购物车更改数量
    func getYQGCartuUpdateNum(withParameter parameter: NSDictionary,handler: @escaping (_ success: Bool, _ message: String)->()){
        self.cartService?.updateGoodNumBlock(withParam:(parameter as! [AnyHashable : Any]) , completionBlock: {[weak self](responseObject, anError)  in
            guard let selfStrong = self else {
                handler(false, "请求失败")
                return
            }
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    let model = data.mapToObject(CartInfoViewModel.self)
                    if let supplyCartList = model.supplyCartList,supplyCartList.isEmpty == false{
                        for sectionModel in supplyCartList{
                            sectionModel.configCartSectionRowData()
                            //记录折叠状态
                            for sectionId in selfStrong.foldSectionArray{
                                if sectionModel.supplyId == sectionId{
                                    sectionModel.foldStatus = true
                                }else{
                                    sectionModel.foldStatus = false
                                }
                            }
                        }
                        selfStrong.sectionArray.removeAll()
                        selfStrong.sectionArray.append(contentsOf: supplyCartList)
                    }else{
                        selfStrong.sectionArray.removeAll()
                    }
                    if let arr = model.preferetialCarList,arr.isEmpty == false {
                        selfStrong.preferetialArr.removeAll()
                        selfStrong.preferetialArr.append(contentsOf: arr)
                    }else {
                        selfStrong.preferetialArr.removeAll()
                    }
                    selfStrong.isEditing = false;
                    selfStrong.updateCartInfo(model)
                    handler(true, "获取成功")
                    return
                }
                handler(true,"成功")
            }else{
                var msg = "访问失败"
                if let errorMsg : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                handler(false,msg)
            }
        });
    }

    //一起购购物车删除
    func deleteYQGCartGoods(withParameter parameter: NSDictionary,handler: @escaping (_ success: Bool, _ message: String)->()){
        self.cartService?.deleteGoodsBlockParam((parameter as! [AnyHashable : Any]) , completionBlock: {[weak self](responseObject, anError)  in
            guard let selfStrong = self else {
                handler(false, "请求失败")
                return
            }
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    let model = data.mapToObject(CartInfoViewModel.self)
                    if let supplyCartList = model.supplyCartList,supplyCartList.isEmpty == false{
                        for sectionModel in supplyCartList{
                            sectionModel.configCartSectionRowData()
                            //记录折叠状态
                            for sectionId in selfStrong.foldSectionArray{
                                if sectionModel.supplyId == sectionId{
                                    sectionModel.foldStatus = true
                                }else{
                                    sectionModel.foldStatus = false
                                }
                            }
                        }
                        selfStrong.sectionArray.removeAll()
                        selfStrong.sectionArray.append(contentsOf: supplyCartList)
                    }else{
                        selfStrong.sectionArray.removeAll()
                    }
                    if let arr = model.preferetialCarList,arr.isEmpty == false {
                        selfStrong.preferetialArr.removeAll()
                        selfStrong.preferetialArr.append(contentsOf: arr)
                    }else {
                        selfStrong.preferetialArr.removeAll()
                    }
                    selfStrong.isEditing = false;
                    selfStrong.updateCartInfo(model)
                    handler(true, "获取成功")
                    return
                }
                handler(true,"成功")
            }else{
                var msg = "访问失败"
                if let errorMsg : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                handler(false,msg)
            }
        });
    }
    //一起购购物车更改勾选状态
    func updateYQGCartGoodsSelectState(withParameter parameter: NSDictionary,handler: @escaping (_ success: Bool, _ message: String)->()){
        self.cartService?.updateGoodSelectStateBlockParam((parameter as! [AnyHashable : Any]) , completionBlock: {[weak self](responseObject, anError)  in
            guard let selfStrong = self else {
                handler(false, "请求失败")
                return
            }
            if anError == nil {
                if let data = responseObject as? NSDictionary {
                    let model = data.mapToObject(CartInfoViewModel.self)
                    if let supplyCartList = model.supplyCartList,supplyCartList.isEmpty == false{
                        for sectionModel in supplyCartList{
                            sectionModel.configCartSectionRowData()
                            //记录折叠状态
                            for sectionId in selfStrong.foldSectionArray{
                                if sectionModel.supplyId == sectionId{
                                    sectionModel.foldStatus = true
                                }else{
                                    sectionModel.foldStatus = false
                                }
                            }
                        }
                        selfStrong.sectionArray.removeAll()
                        selfStrong.sectionArray.append(contentsOf: supplyCartList)
                    }else{
                        selfStrong.sectionArray.removeAll()
                    }
                    if let arr = model.preferetialCarList,arr.isEmpty == false {
                        selfStrong.preferetialArr.removeAll()
                        selfStrong.preferetialArr.append(contentsOf: arr)
                    }else {
                        selfStrong.preferetialArr.removeAll()
                    }
                    selfStrong.isEditing = false;
                    selfStrong.updateCartInfo(model)
                    handler(true, "获取成功")
                    return
                }
                handler(true,"成功")
            }else{
                var msg = "访问失败"
                if let errorMsg : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                handler(false,msg)
            }
        });
        
    }
    //一起购购物车结算校验
    // 结算校验接口，当购买商品与库存有不同时，返回对应的商品列表
    func  checkCartSumbit(withParameter parameter: NSDictionary,handler: @escaping (_ success: Bool, _ message: String)->()){
        FKYRequestService.sharedInstance()?.sumitCheckCheckSattusInCart(withParam: (parameter as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                handler(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                handler(false, msg)
                return
            }
            // 请求成功
            if let data = response as? NSArray {
                selfStrong.changedArray.removeAll()
                selfStrong.changedArray .append(contentsOf: (data as NSArray).mapToObjectArray(CartChangeInfoModel.self)!)
                handler(true, "成功")
                return
            }
            handler(false, "失败")
        })
    }
    
    //更新购物车数据
    func updateCartInfo(_ cartInfo :CartInfoViewModel){
        //        self.isSelectAll = cartInfo.checkedAll
        //        self.goodsNum = cartInfo.checkedProducts.intValue
        //        self.totalPrice = cartInfo.totalAmount.doubleValue
        //        self.sectionCount = self.sectionArray.count
        self.cartRebateProductSum  = cartInfo.checkedRebateProducts ?? 0
        self.selectedTypeCount = cartInfo.checkedProducts ?? 0
        self.discountAmount = (cartInfo.discountAmount ?? 0).doubleValue
        self.canUseCouponPrice = cartInfo.allCanUsecouponAmount 
        self.selectedTotalRebate = (cartInfo.rebateAmount ?? 0).doubleValue
        self.selMerchantCount = self.getSelectMerchantNum()
        //价格放在最后赋值 和 rx 相关
        self.selectedTotalPrice = (cartInfo.appShowMoney ?? 0).doubleValue
        self.cartPaySum = (cartInfo.totalAmount ?? 0).doubleValue
        // 是否为全选
        self.selectedAll = cartInfo.checkedAll ?? false
        self.sectionCount = self.sectionArray.count
    }
    //判断当前商家下的所有商品是否均无效~!  若均无效，则商家headerview中的勾选按钮置灰 YES-无效
    func  sectionProductUnValidForSection (_ section:NSInteger) ->Bool {
        if self.sectionArray.count == 0{
            return true
        }
        if section >= self.sectionArray.count{
            return false
        }
        var total = 0
        var count = 0
        let model =  self.sectionArray[section]
        if let groupList = model.productGroupList{
            for object in  groupList{
                if object.groupItemList != nil{
                    for item in object.groupItemList!{
                        total += 1
                        if 0 != item.productStatus{
                            count += 1
                        }
                    }
                }
            }
        }
        return count == total
    }
    //    更新所有商品的编辑状态
    func updateSectionModelForEditing(sectionModel  : CartMerchantInfoModel,handler: @escaping (_ success: Bool, _ message: String)->()){
        if !self.isEditing{
            return;
        }
        sectionModel.editStatus = sectionModel.editStatus == 1 ? 2 : 1
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            if sectionModel.productGroupList != nil{
                for object in sectionModel.productGroupList!{
                    if object.groupItemList != nil{
                        for item in object.groupItemList!{
                            //if  item.supplyId ==  sectionModel.supplyId {。//因为聚宝盆
                            item.editStatus = sectionModel.editStatus;
                            object.editStatus = sectionModel.editStatus;
                            // }
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async(execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedAll = strongSelf.isAllProductSelectedForEdit()
                handler(true,"成功")
            })
        }
    }
    // 更新购物车的商品列表中各商品的编辑状态
    func updateCartListForIsEdit(isEdit : Bool,handler: @escaping (_ success: Bool, _ message: String)->()){
        
        for model in self.sectionArray{
            if model.productGroupList != nil{
                for object in model.productGroupList!{
                    if isEdit{
                        object.editStatus = 1
                    }else{
                        object.editStatus = 0
                    }
                    if object.groupItemList != nil{
                        for item in object.groupItemList! {
                            if isEdit{
                                item.editStatus = 1
                            }else{
                                item.editStatus = 0
                            }
                        }
                    }
                }
                if isEdit{
                    model.editStatus = 1
                }else{
                    model.editStatus = 0
                }
            }
        }
        if self.isEditing {
            self.selectedAll = false;
        }else {
            self.selectedAll = self.isAllProductSelected()
        }
        handler(true,"成功")
    }
    // 判断是否为全选
    func isAllProductSelected() -> Bool{
        let RegexSelected = NSPredicate.init(format:"checkedAll == YES  || isectionProductUnValidForSection == YES ")
        let tempArray :NSMutableArray = NSMutableArray.init(array: self.sectionArray)
        let selectedArray  = (tempArray).filtered(using: RegexSelected)
        if selectedArray.count == self.sectionArray.count {
            return true
        }
        return false
    }
    func updateProductForEditing(sectionModel : CartMerchantInfoModel,handler: @escaping (_ success: Bool, _ message: String)->()){
        if self.isEditing == false{
            return;
        }
        sectionModel.editStatus = sectionModel.editStatus == 1 ? 2 : 1
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            if sectionModel.isSelectedAllForEditStatus() {
                sectionModel.editStatus = 2;
            }else{
                sectionModel.editStatus = 1;
            }
            DispatchQueue.main.async(execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedAll = strongSelf.isAllProductSelectedForEdit()
                handler(true,"成功")
            })
        }
    }
    // 判断所有商品是否为编辑状态下的全选
    func isAllProductSelectedForEdit() -> Bool{
        let RegexSelected = NSPredicate.init(format:"isSelectedAllForEditStatus == NO")
        let tempArray :NSMutableArray = NSMutableArray.init(array: self.sectionArray)
        let selectedArray  = (tempArray).filtered(using: RegexSelected)
        if selectedArray.count > 0 {
            return false
        }
        return true
        
    }
    //判断是否有选择商品
    func isAllProductUnSelected() -> Bool{
        var unSelectCount = 0;        // 未选中商品数量
        var productCount = 0;         // 商品总数
        var editUnSelectCount = 0;    // 编辑状态下未选中商品数量
        var editProductCount = 0;     // 编辑状态下商品总数
        for sectionModel in self.sectionArray{
            if sectionModel.productGroupList != nil{
                for object in sectionModel.productGroupList!{
                    if object.groupItemList != nil{
                        for item in object.groupItemList!{
                            if 0 == item.productStatus {
                                productCount += 1
                                if !(item.checkStatus ?? false){
                                    unSelectCount += 1;
                                }
                            }
                            if self.isEditing{
                                editProductCount += 1;
                                if item.editStatus != 2 {
                                    editUnSelectCount += 1;
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
        if self.isEditing {
            return editUnSelectCount == editProductCount;
        }
        return unSelectCount == productCount;
    }
    
    //编辑状态下删除...<批量>
    func deleteSelectedShopCartSuccess(handler2: @escaping (_ success: Bool, _ message: String)->()){
        DispatchQueue.global(qos: .userInitiated).async {
            var  arr:[Any] = []
            if self.isEditing{
                for sectionModel in self.sectionArray{
                    if sectionModel.productGroupList != nil{
                        for object in sectionModel.productGroupList!{
                            if object.groupItemList != nil{
                                for item in object.groupItemList!{
                                    if (item.editStatus == 2) {
                                        arr.append(item.shoppingCartId as Any)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            DispatchQueue.main.async(execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                var jsonParam = [String: Any]()
                jsonParam["shoppingcartid"] = arr
                jsonParam["fromwhere"] = 2
                //分享者ID
                if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                    jsonParam["shareUserId"] = cpsbd
                }
                strongSelf.deleteYQGCartGoods(withParameter: jsonParam as NSDictionary, handler: {(success,msg) in
                    if success == true{
                        handler2(true,"成功")
                    }else{
                        handler2(false,msg)
                    }
                    
                })
            })
        }
    }
    //获取选择的商品
    func getSelectedShoppingCartList() -> [Any]{
        var shoppingCartIds:[Any] = []
        for sectionModel in self.sectionArray{
            shoppingCartIds.append(contentsOf: sectionModel.getSelectedProductShoppingIds())
        }
        return shoppingCartIds
    }
    func getSelectedShoppingProductList() -> [Any]{
        var shoppingCartIds:[Any] = []
        for sectionModel in self.sectionArray {
            shoppingCartIds.append(contentsOf: sectionModel.getSelectedProductShoppingIds())
        }
        return shoppingCartIds
    }
    //编辑状态下全选
    func  setSelectAllProductForEdit(selectAll : Bool,handler: @escaping (_ success: Bool, _ message: String)->()){
        for sectionModel in self.sectionArray{
            if sectionModel.productGroupList != nil {
                for object in sectionModel.productGroupList!{
                    if self.isEditing {
                        object.editStatus = selectAll == true ? 2 : 1
                    }
                    if  object.groupItemList != nil{
                        for item in object.groupItemList!{
                            if self.isEditing {
                                item.editStatus = selectAll == true ? 2 : 1
                            }
                        }
                    }
                    
                }
            }
            
            if self.isEditing {
                sectionModel.editStatus = selectAll == true ? 2 : 1
            }
        }
        if self.isEditing {
            self.selectedAll = selectAll
        }
        handler(true,"成功")
    }
    
    //更新购物车数量(当购物车数量被清空时)
    fileprivate func updateTogeterBuyCartNum() {
        FKYVersionCheckService.shareInstance()?.syncMixCartNumberSuccess(nil, failure: nil)
    }
    
    //pragma mark - 判断用户 所有商品都未达到 起批价
    // 未有商品被勾选的商家不在考虑范围之内，即只考虑有商品被勾选的商家
    func allStepPriceUnValid() -> (Bool){
        // 未达到起批价的商家数量
        var unvalidcount = 0
        var list = [CartMerchantInfoModel]()
        for sectionModel in self.sectionArray{
            if let totalAmount = sectionModel.totalAmount ,totalAmount.floatValue > 0 {
                list.append(sectionModel)
            }
        }
        for sectionModel in list{
            if self.checkStepPriceValidForShop(sectionModel) == false{
                unvalidcount += 1
            }
        }
        if unvalidcount == list.count {
            return true;
        }
        return false
    }
    
    func checkStepPriceValidForShop(_ model:CartMerchantInfoModel) -> (Bool){
        if let totalAmount = model.totalAmount ,totalAmount.floatValue > 0 {
            // 有订单总金额，即当前商家中有商品被勾选
            if let needAmount = model.needAmount ,needAmount.floatValue > 0 {
                // 有起送金差额，不可结算
                return false
            }
            else {
                // 无起送金差额，可结算
                return true
            }
        }
        else {
            // 无订单总金额，即当前商家中无商品被勾选...<肯定达不到起批价>
            return false
        }
    }
     //获取搜索未达起送金额商家信息
        func getNeedacountMerchantInfo()->(Int,[CartMerchantInfoModel]){
            var  merchantList:[CartMerchantInfoModel] = []
            var list = [CartMerchantInfoModel]()
            var index = 0
            for sectionModel in self.sectionArray{
                index = index + 1
                sectionModel.indexSection = index
                if let totalAmount = sectionModel.totalAmount ,totalAmount.floatValue > 0 {
                    list.append(sectionModel)
                }
            }
            //0:正常情况 ;1：部分商家未达到起送金额；2:所有商品都未达到起送金额
            var typeIndex = 0
            for sectionModel in list{
                if self.checkStepPriceValidForShop(sectionModel) == false{
                    typeIndex = 1
                    merchantList.append(sectionModel)
                }
            }
            //未满起送金额的数组大于0并且是全部都未达到起送金额
            if merchantList.count > 0 && merchantList.count == list.count {
                typeIndex = 2
            }
            return (typeIndex,merchantList)
        }
    //获取选中商家个数
    func getSelectMerchantNum()->Int{
        var merchantCount = 0
        for sectionModel in self.sectionArray{
            if let allTotalMoney = sectionModel.allTotalMoney ,allTotalMoney.floatValue > 0 {
                merchantCount += 1
            }
        }
        return merchantCount
    }
}

//MARK: -折叠section
extension FKYYQGCartProvider{
    //增加折叠商家
    func addFoldSection(_ sectionId:Int){
        foldSectionArray.insert(sectionId)
    }
    //删除折叠商家
    func deleteFoldSection(_ sectionId:Int){
        foldSectionArray.remove(sectionId)
    }
}
