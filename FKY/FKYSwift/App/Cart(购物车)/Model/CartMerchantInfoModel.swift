//
//  CartMerchantInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc final class CartMerchantInfoModel: NSObject, JSONAbleType {
    
    var allTotalMoney:NSNumber? //       供应商下所有商品总金额（套餐按原价价格计算的总商品金额）
    var canUseCouponMoney:NSNumber? //   供应商下可用卷商品金额
    var checkedAll:Bool?     //    供应商下的商品是否全选    boolean
    var comboShareMoney:NSNumber? //    套餐优惠金额
    var manjianShareMoney:NSNumber? //    满减优惠金额    number
    var manzheShareMoney :NSNumber? //       满折优惠金额    number
    var freeShippingAmount:NSNumber?    //   供应商包邮金额    number    @mock=2000
    var freeShippingNeed:NSNumber?    //   还差多少金额包邮    number
    var freight:NSNumber?    //    订单的运费，该运费是总运费,，还没有拆单的运费    number    @mock=10
    
    var shortWarehouseName:String? //自营仓名
    var couponFlag:Bool?    //    优惠券标识    boolean
    var discountAmount:NSNumber? //   供应商订单折扣/满减金额    number    @mock=10
    var shopExtendTag : String? //店铺扩展标签（商家，xx仓，旗舰店，加盟店）
    var shopExtendType : Int? //店铺扩展类型（0普通店铺，1旗舰店 2加盟店 3自营店）
    
    
    var needAmount:NSNumber?    //    供应商起送金差额    number    @mock=0
    
    var supplyFreight:NSNumber?    //    供应商订单运费    number    @mock=10
    var supplyId:Int?   //     供应商ID    number    @mock=8353
    var supplyName:String?    //    供应商名称    string    @mock=广东壹号药业有限公司-ziying
    var supplySaleSill:NSNumber?    //    供应商起售门槛    number    @mock=1000
    var supplyType:NSNumber?   //     供应商类型（0：自营；1：MP商家）    number    @mock=0
    var totalAmount:NSNumber?     //     供应商订单总金额    number    @mock=1020（套餐按套餐价格计算的总商品金额）
    ///满￥800.00包邮，还差￥800.00 文描
    var freightAndSaleSillDesc:String?
    //    var freightRuleList:[String]?
    //    var invalidCount:Int?   //    失效品种数
    var productGroupList:[ProductGroupListInfoModel]?            // 商品数据列表
    var rowDataForShow:[BaseCartCellProtocol] = [] // 自定义商品组楼层展
    
    var editStatus:Int = 0// 0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中
    var foldStatus:Bool = false  // 自定义折叠状态 false 展开   true 收起
    var preferetialArr = [FKYShopPreferetialModel]() //优惠列表(本地处理字段)
    var products:[ProductGroupListInfoModel] = []          // 自定义选择商品数据
    var indexSection = 0 //记录在数组中的序号（1，2，3，4）
    ///是否展示去凑单按钮 true展示
    var addMoreShowFlag:Bool = false
    var desTotalAmount:Double = 0.0 //计算优惠明细中的合计
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartMerchantInfoModel {
        let json = JSON(json)
        let model = CartMerchantInfoModel()
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        model.couponFlag = json["couponFlag"].boolValue
        model.discountAmount = json["discountAmount"].numberValue
        model.freeShippingAmount = json["freeShippingAmount"].numberValue
        model.freeShippingNeed = json["freeShippingNeed"].numberValue
        model.freight = json["freight"].numberValue
        model.checkedAll = json["checkedAll"].boolValue
        model.needAmount = json["needAmount"].numberValue
        model.supplyFreight = json["supplyFreight"].numberValue
        model.supplyId = json["supplyId"].intValue
        
        model.supplyName = json["supplyName"].stringValue
        model.supplySaleSill = json["supplySaleSill"].numberValue
        model.supplyType = json["supplyType"].numberValue
        model.totalAmount = json["totalAmount"].numberValue
        
        model.comboShareMoney = json["comboShareMoney"].numberValue
        model.manjianShareMoney = json["manjianShareMoney"].numberValue
        model.manzheShareMoney = json["manzheShareMoney"].numberValue
        model.allTotalMoney = json["allTotalMoney"].numberValue
        model.canUseCouponMoney = json["canUseCouponMoney"].number
        model.freightAndSaleSillDesc = json["freightAndSaleSillDesc"].stringValue
        
        model.addMoreShowFlag = json["addMoreShowFlag"].boolValue
        
        model.shopExtendTag = json["shopExtendTag"].stringValue
        model.shopExtendType = json["shopExtendType"].intValue
        
        if json["productGroupList"].array != nil{
            let array = json["productGroupList"].arrayObject
            var list: [ProductGroupListInfoModel]? = []
            if let arr = array{
                list = (arr as NSArray).mapToObjectArray(ProductGroupListInfoModel.self)
            }
            model.productGroupList = list
        }
        
        
        //优惠明细列表
        var totalPreMoney : Double = 0.0
        //        if let num = model.canUseCouponMoney ,num.doubleValue > 0 {
        //            let preModel = FKYShopPreferetialModel()
        //            preModel.preferetialName = "可用券金额"
        //            preModel.preferetialMoney = String.init(format: "¥%.2f",num.doubleValue)
        //            model.preferetialArr.insert(preModel, at: 0)
        //        }
        if let num = model.manjianShareMoney ,num.doubleValue > 0 {
            let preModel = FKYShopPreferetialModel()
            preModel.preferetialName = "满减"
            preModel.preferetialMoney = String.init(format: "-¥%.2f",num.doubleValue)
            model.preferetialArr.append(preModel)
            totalPreMoney = totalPreMoney + num.doubleValue
        }
        if let num = model.manzheShareMoney ,num.doubleValue > 0 {
            let preModel = FKYShopPreferetialModel()
            preModel.preferetialName = "满折"
            preModel.preferetialMoney = String.init(format: "-¥%.2f",num.doubleValue)
            model.preferetialArr.append(preModel)
            totalPreMoney = totalPreMoney + num.doubleValue
        }
        //        if let num = model.comboShareMoney ,num.doubleValue > 0 {
        //            let preModel = FKYShopPreferetialModel()
        //            preModel.preferetialName = "套餐"
        //            preModel.preferetialMoney = String.init(format: "-¥%.2f",num.doubleValue)
        //            model.preferetialArr.append(preModel)
        //            totalPreMoney = totalPreMoney + num.doubleValue
        //        }
        if totalPreMoney > 0 {
            let preModel = FKYShopPreferetialModel()
            preModel.preferetialName = "共优惠"
            preModel.preferetialMoney =  String.init(format: "-¥%.2f",totalPreMoney)
            model.preferetialArr.append(preModel)
        }
        if let num = model.totalAmount ,num.doubleValue > 0 {
            model.desTotalAmount = num.doubleValue - totalPreMoney
        }
        if let num = model.totalAmount ,num.doubleValue > 0 {
            if  model.preferetialArr.count > 0 {
                let preModel = FKYShopPreferetialModel()
                preModel.preferetialName = "商品金额"
                preModel.preferetialMoney = String.init(format: "¥%.2f",num.doubleValue)
                model.preferetialArr.insert(preModel, at: 0)
            }
        }else {
            model.preferetialArr.removeAll()
        }
        
        return model
    }
}
//MARK: -私有方法
extension CartMerchantInfoModel{
    //预言字段
    @objc override func value(forKey key: String) -> Any? {
        switch key {
        case "checkedAll":
            return checkedAll
        case "isectionProductUnValidForSection":
            return isectionProductUnValidForSection()
        case "isSelectedAllForEditStatus":
            return isSelectedAllForEditStatus()
        default:
            return nil
        }
    }
    //处理商家信息
    func configCartSectionRowData(){
        //        if let needAmountNum = self.needAmount,needAmountNum.floatValue > 0{
        //            //商品未达起送金额
        //            let cellSectionTipsInfo = CartCellSectionTipsInfoProtocol()
        //            cellSectionTipsInfo.sectionInfo = self
        //            rowDataForShow.append(cellSectionTipsInfo)
        //        }else if let freeShippingNeedNum = self.freeShippingNeed,freeShippingNeedNum.floatValue > 0{
        //            //商品未达包邮金额
        //            let cellSectionTipsInfo = CartCellSectionTipsInfoProtocol()
        //            cellSectionTipsInfo.sectionInfo = self
        //            rowDataForShow.append(cellSectionTipsInfo)
        //        }
        //具体的商品和促销信息
        if let productList  = self.productGroupList,productList.isEmpty == false{
            
            for index in 0...(productList.count - 1){
                let item = productList[index]
                item.supplyId = "\(self.supplyId ?? 0)"
                
                let cellSpacesInfo = CartCellSeparateSpaceProtocol()
                rowDataForShow.append(cellSpacesInfo)
                
                rowDataForShow.append(contentsOf: item.getSectionDeatilInfo())
                
            }
            
        }
        
    }
    //获取选中商品的购物车ID
    func getSelectedProductShoppingIds()->[String]{
        var selectCartListArray:[String] = []
        if self.productGroupList != nil{
            for item in self.productGroupList!{
                if item.groupItemList != nil{
                    for object in item.groupItemList!{
                        if object.productStatus  == 0 && (object.checkStatus ?? false) == true {
                            selectCartListArray.append("\(object.shoppingCartId ?? 0)")
                        }
                    }
                }
            }
        }
        return selectCartListArray
    }
    //    //获取被选中的并且有调拨提示的
    //    func getSelectedNeedAlertShoppingCartProductList()->[CartProdcutnfoModel]{
    //        var selectNeedAlertCartListArray:[CartProdcutnfoModel] = []
    //        if self.productGroupList != nil{
    //            for item in self.productGroupList!{
    //                if item.groupItemList != nil{
    //                    for object in item.groupItemList!{
    //                        if object.productStatus  == 0 && (object.checkStatus ?? false) == true && object.shareStockVO != nil {
    //                            selectNeedAlertCartListArray.append(object)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        return selectNeedAlertCartListArray
    //    }
    // 判断当前商家中的所有商品是否为编辑全选中状态
    @objc func isSelectedAllForEditStatus()->Bool{
        var unSelectedArray:[CartProdcutnfoModel] = []
        if self.productGroupList != nil{
            for item in self.productGroupList!{
                if item.groupItemList != nil{
                    let RegexSelected = NSPredicate.init(format:"editStatus == 1")
                    let tempArray :NSMutableArray = NSMutableArray.init(array: item.groupItemList!)
                    let selectedArray:[CartProdcutnfoModel]  = (tempArray).filtered(using: RegexSelected) as! [CartProdcutnfoModel]
                    unSelectedArray.append(contentsOf: selectedArray)
                }
            }
        }
        if unSelectedArray.isEmpty == false{
            return false
        }
        return true
    }
    //    NSMutableArray *unSelectedArray = [NSMutableArray array];
    //    [self.productGroupList each:^(FKYProductGroupListInfoModel *object) {
    //        NSArray *itemUnSelectedArray = [object.groupItemList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"editStatus == 1"]];
    //        [unSelectedArray addObjectsFromArray:itemUnSelectedArray];
    //    }];
    //    if (unSelectedArray.count > 0) {
    //        return NO;
    //    }
    // 判断当前商家中的所有商品是否全部无效
    @objc func isectionProductUnValidForSection() -> Bool {
        // 总商品个数
        var total = 0
        // 无效商品个数统计
        var count = 0
        if self.productGroupList != nil{
            for item in self.productGroupList!{
                if item.groupItemList != nil{
                    for object in item.groupItemList!{
                        total += 1
                        if object.productStatus  != 0 {
                            count += 1
                        }
                    }
                }
            }
        }
        return count == total
    }
    //用来判断点击去凑单的原因
    func sectionTipsStatus()->(GoToShopClickType){
        if let needAmountNum = self.needAmount,needAmountNum.floatValue > 0{
            //商品未达起送金额
            return  CartMinSaleGatherClickType
        }else if let freeShippingNeedNum = self.freeShippingNeed,freeShippingNeedNum.floatValue > 0{
            //商品未达包邮金额
            return  CartFreightGatherClickType
        }
        return  CartFreightGatherClickType
    }
}

final class FKYShopPreferetialModel: NSObject {
    // MARK: - properties
    var preferetialName : String?            //优惠名称
    var preferetialMoney : String?          //优惠金额
}
