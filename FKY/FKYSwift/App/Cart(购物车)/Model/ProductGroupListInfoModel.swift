//
//  ProductGroupListInfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ProductGroupListInfoModel: NSObject, JSONAbleType{
    var comboAmount:NSNumber?    //   套餐有值，套餐是否全选
    var groupId:String? //    商品组ID    string    @mock=$order('','15254','15335')
    var groupItemList:[CartProdcutnfoModel]?    //    商品列表    array<object>
    var groupName:String?    //    商品组名称    string    @mock=$order('','搭配套餐测试请勿删','固定套餐购物车测试')
    var groupType:Int?    //    商品组类型（0：普通商品组；1：搭配套餐；2：固定套餐 3：多品返利组 4:满减，5：满折）
    
    //   var comboAmount:Int?   //    固定套餐有值，当前固定套餐的合计金额    number    2989.5
    var comboMaxNum:Int?    //    固定套餐有值，当前固定套餐的最大可购买套数    number    6
    var comboNum:Int?    //    固定套餐有值，当前固定套餐购买套数    number    5
    var comboLimitNum:Int?    //    固定套餐限购数
    var checkedAll:Bool?    //    套餐有值，套餐是否全选    boolean    true
    
    var supplyId:String? //自定义 从上层传来
    var editStatus:Int = 0 // 自定义0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中
    var outMaxReason:String?//超出最大可售数量，最多只能购买9999
    var lessMinReson:String?//该普通商品最小起批量为1 p
    var multiRebateTip:String?//多品返利文描
    var valid:Bool?    //    套餐有值，套餐是否有效 boolean    true
    var comboStatus:Int = 0    //  套餐是否有效可选, 0:可选, 1: 不可选
    var desc:String?//组描述
    var  joinDesc:String?//组描述
    var  shareMoney:NSNumber?//活动优惠金额，套餐，满减，满折均取此值
    @objc static func fromJSON(_ json: [String : AnyObject]) ->ProductGroupListInfoModel {
        let json = JSON(json)
        let model = ProductGroupListInfoModel()
        model.groupId = json["groupId"].stringValue
        model.groupName = json["groupName"].stringValue
        model.groupType = json["groupType"].intValue
        model.comboAmount = json["comboAmount"].numberValue
        model.comboMaxNum = json["comboMaxNum"].intValue
        model.comboNum = json["comboNum"].intValue
        model.comboLimitNum = json["comboLimitNum"].intValue
        model.comboStatus = json["comboStatus"].intValue
        model.checkedAll = json["checkedAll"].boolValue
        model.valid = json["valid"].boolValue
        //  model.supplyId = json["supplyId"].intValue
        
        model.outMaxReason = json["outMaxReason"].stringValue
        model.lessMinReson = json["lessMinReson"].stringValue
        model.multiRebateTip = json["multiRebateTip"].stringValue
        
        model.desc = json["desc"].stringValue
        model.joinDesc = json["joinDesc"].stringValue
        model.shareMoney = json["shareMoney"].numberValue
        
        if let _ = json["groupItemList"].array{
            let array = json["groupItemList"].arrayObject
            var list: [CartProdcutnfoModel]? = []
            if let arr = array{
                list = (arr as NSArray).mapToObjectArray(CartProdcutnfoModel.self)
            }
            model.groupItemList = list
        }
        
        return model
    }
}
//MARK: -私有方法
extension ProductGroupListInfoModel{
    //处理商家产品信息 进行数据分类商品组类型（0：普通商品组；1：搭配套餐；2：固定套餐；3：多品返利组不用啦,4:满减，5：满折）
    func getSectionDeatilInfo() -> [BaseCartCellProtocol]{
        var aryShowData:[BaseCartCellProtocol] = []
        if self.groupItemList == nil || self.groupItemList?.isEmpty == true{
            return aryShowData
        }
        if let productGroupType = self.groupType{
            if productGroupType == 0{
                for index in 0...(self.groupItemList!.count - 1){
                    let item =  self.groupItemList![index]
                    //普通商品
                    let cellProductInfo = CartCellProductProtocol()
                    cellProductInfo.productModel = item
                    if index == 0{
                        cellProductInfo.firstObject = true
                    }
                    if index == (self.groupItemList!.count - 1){
                        cellProductInfo.lastObject = true
                    }
                    
                    cellProductInfo.productType = .CartCellProductTypeNormal
                    aryShowData.append(cellProductInfo)
                }
            }else if productGroupType == 1{
                //搭配套餐
                //套餐信息
                let cellTaoCanInfo = CartCellTaoCanProtocol()
                cellTaoCanInfo.taoCanName = self.groupName ?? ""
                cellTaoCanInfo.modelInfo = self
                aryShowData.append(cellTaoCanInfo)
                
                for index in 0...(self.groupItemList!.count - 1){
                    let item =  self.groupItemList![index]
                    let cellProductInfo = CartCellProductProtocol()
                    cellProductInfo.productModel = item
                    cellProductInfo.firstObject = false//((index == 0) ? true:false)
                    cellProductInfo.lastObject = false//((index == (self.groupItemList!.count - 1)) ? true:false)
                    cellProductInfo.productType = .CartCellProductTypeTaoCan
                    aryShowData.append(cellProductInfo)
                }
                //底部小计
                let cellTaoCanPromotionInfo =  CartCellTaocanPromationInfoProtocol()
                cellTaoCanPromotionInfo.shareMoney = self.shareMoney
                cellTaoCanPromotionInfo.comboAmount = self.comboAmount
                aryShowData.append(cellTaoCanPromotionInfo)
            }else if productGroupType == 2{
                //固定套餐
                let cellTaoCanInfo = CartCellFixTaoCanProtocol()
                cellTaoCanInfo.taoCanName = self.groupName ?? ""
                cellTaoCanInfo.modelInfo = self
                if let limitNum = self.comboLimitNum,limitNum > 0{
                    cellTaoCanInfo.fixComobLimitFlag = true
                    cellTaoCanInfo.fixComobLimitNum = limitNum
                }else{
                    cellTaoCanInfo.fixComobLimitFlag = false
                }
                aryShowData.append(cellTaoCanInfo)
                
                for index in 0...(self.groupItemList!.count - 1){
                    let item =  self.groupItemList![index]
                    let cellProductInfo = CartCellProductProtocol()
                    cellProductInfo.productModel = item
                    cellProductInfo.firstObject = false//((index == 0) ? true:false)
                    cellProductInfo.lastObject = false//((index == (self.groupItemList!.count - 1)) ? true:false)
                    cellProductInfo.productType = .CartCellProductTypeFixTaoCan
                    aryShowData.append(cellProductInfo)
                }
                //底部小计
                let cellTaoCanPromotionInfo =  CartCellTaocanPromationInfoProtocol()
                cellTaoCanPromotionInfo.shareMoney = self.shareMoney
                cellTaoCanPromotionInfo.comboAmount = self.comboAmount
                aryShowData.append(cellTaoCanPromotionInfo)
            }else if productGroupType == 4{
                //满减组
                let promotionInfo = CartCellPromotionInfoProtocol()
                promotionInfo.promotionType = .CartPromotionTypeMJ
                promotionInfo.promotionId = self.groupId
                promotionInfo.promotionName = self.joinDesc ?? ""
                promotionInfo.supplyId = self.supplyId ?? ""
                
                aryShowData.append(promotionInfo)
                
                for index in 0...(self.groupItemList!.count - 1){
                    let item =  self.groupItemList![index]
                    let cellProductInfo = CartCellProductProtocol()
                    if index == 0{
                        promotionInfo.promationInfoModel = item.promotionMJ
                    }
                    cellProductInfo.productModel = item
                    cellProductInfo.firstObject = false
                    cellProductInfo.lastObject = ((index == (self.groupItemList!.count - 1)) ? true:false)
                    cellProductInfo.productType = .CartCellProductTypePromotion
                    aryShowData.append(cellProductInfo)
                }
            }else if productGroupType == 5{
                //满折
                let promotionInfo = CartCellPromotionInfoProtocol()
                promotionInfo.promotionType = .CartPromotionTypeMZ
                promotionInfo.promotionId = self.groupId
                promotionInfo.promotionName = self.joinDesc ?? ""
                promotionInfo.supplyId = self.supplyId ?? ""
                aryShowData.append(promotionInfo)
                
                for index in 0...(self.groupItemList!.count - 1){
                    let item =  self.groupItemList![index]
                    let cellProductInfo = CartCellProductProtocol()
                    cellProductInfo.productModel = item
                    if index == 0{
                        promotionInfo.promationInfoModel = item.promotionManzhe
                    }
                    cellProductInfo.firstObject = false
                    cellProductInfo.lastObject = ((index == (self.groupItemList!.count - 1)) ? true:false)
                    cellProductInfo.productType = .CartCellProductTypePromotion
                    aryShowData.append(cellProductInfo)
                }
            }
        }
        return aryShowData
    }
    // 判断当前商家中的所有商品是否为编辑全选中状态
    func isSelectedAllForEditStatus()->Bool{
        if self.groupItemList == nil{
            return true
        }
        let RegexSelected = NSPredicate.init(format:"editStatus == 1")
        let tempArray :NSMutableArray = NSMutableArray.init(array: self.groupItemList!)
        let unSelectedArray:[CartProdcutnfoModel]  = (tempArray).filtered(using: RegexSelected) as! [CartProdcutnfoModel]
        if unSelectedArray.isEmpty == false{
            return false
        }
        return true
    }
}
