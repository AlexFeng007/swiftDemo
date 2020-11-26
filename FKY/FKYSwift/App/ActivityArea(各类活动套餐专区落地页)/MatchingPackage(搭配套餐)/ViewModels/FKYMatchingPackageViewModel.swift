//
//  FKYMatchingPackageViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageViewModel: NSObject {
    
    /// 请求接口套餐的类型 1 搭配套餐 2固定套餐 默认1
    var packgeType = 1;
    
    ///区列表
    var sectionList:[FKYMatchingPackageSectionModel] = []
    
    /// 企业ID/店铺ID 从上一个界面传过来
    var enterpriseId:String = ""
    /// 商品的spuCode 从上一个界面传过来
    var spuCode:String = ""
    
    /// 购物车加车Model
    var cartRequstSever:FKYCartNetRequstSever = FKYCartNetRequstSever.logic(with: HJNetworkManager.sharedInstance()?.generateOperationManger(withOwner: self)) as! FKYCartNetRequstSever
    
    // MARK: - 网络请求回的原始数据
    /// 套餐列表
    var dinners:[FKYMacthingPackageModel] = []
    /// 企业名称
    var enterpriseName:String = ""
    /// 下一页的index 第一页传 1_0 后面的传后台给的 如果为空说明没有下一页
    var position:String = ""
}

//MARK: - 数据处理
extension FKYMatchingPackageViewModel{
    
    func progressData(){
        self.sectionList.removeAll()
        
        if self.dinners.isEmpty {
            let section = FKYMatchingPackageSectionModel()
            section.isHaveSectionHeader = false
            let cell = FKYMatchingPackageCellModel()
            cell.cellType = .noProductCell
            section.cellList.append(cell)
            self.sectionList.append(section)
        }
        
        for dinner in self.dinners {
            let section = FKYMatchingPackageSectionModel()
            section.packageName = dinner.promotionName
            section.packageModel = dinner
            section.cellList = self.creatCellListInSection(cellDataList:dinner.productList)
            self.sectionList.append(section)
        }
    }
    
    /// 创建一个section中的cell列表
    func creatCellListInSection(cellDataList:[FKYProductModel]) -> [FKYMatchingPackageCellModel]{
        /// 返回的cell列表
        var cellList:[FKYMatchingPackageCellModel] = []
        /// 主品的数组
        var mainProductList:[FKYProductModel] = []
        /// 搭配品数组
        var matchProductList:[FKYProductModel] = []
        
        /// 分离出主品和搭配品（后台已经做了排序，但是这里做一遍容错，顺便处理没有主品的情况）
        for product in cellDataList {
            if product.isMainProduct == 1 {// 是主品
                mainProductList.append(product)
            }else{
                matchProductList.append(product)
            }
        }
        
        /// 创建主品的cell
        for (index,product) in mainProductList.enumerated() {
            let cell:FKYMatchingPackageCellModel = FKYMatchingPackageCellModel()
            cell.cellData = product
            cell.cellType = .productCell
            product.isSelected = true
            
            if index == mainProductList.count-1 {// 最后一个
                cell.isShowBottomMargin = false
            }
            cellList.append(cell)
        }
        
        /// 创建搭配品的cell
        for (index,product) in matchProductList.enumerated() {
            let cell = FKYMatchingPackageCellModel()
            cell.cellType = .productCell
            cell.cellData = product
            if index == 0,mainProductList.isEmpty == true{
                cell.isShowBottomMargin = false
            }
            
            if index == matchProductList.count-1 {// 最后一个
                cell.isShowBottomMargin = false
            }
            cellList.append(cell)
        }
        
        /// 创建购买套餐的cell
        if mainProductList.isEmpty == false||matchProductList.isEmpty == false{
            let cell1 = FKYMatchingPackageCellModel()
            cell1.cellType = .buyCell

            let cell2 = FKYMatchingPackageCellModel()
            cell2.cellType = .emptyCell
            cellList.append(cell1)
            cellList.append(cell2)
        }
        
        /// 根据产品要求，永远将分割cell放在第二个
        if cellList.count >= 2,cellList[0].cellType != .noProductCell {
            let cell = FKYMatchingPackageCellModel()
            cell.cellType = .marginCell
            cellList.insert(cell, at: 1)
        }
        
        return cellList
    }
    
    /// 初始化套餐优惠价和原价信息
    func installPackagePriceInfo(){
        for section in self.sectionList{
            for cell in section.cellList {
                if cell.cellType == .buyCell {
                    cell.dinnerPrice = section.packageModel.dinnerPrice
                    cell.originalPrice = section.packageModel.dinnerOriginPrice
                    cell.dinnerID = "\(section.packageModel.promotionId)"
                }
            }
        }
    }
    
    /// 根据相应的规则计算商品数量和价格 type 1 步减 2步加 3用户自行输入
    func changeProductNum(product:FKYProductModel, type:Int,inputNum:String) {
        product.preBuyNum = self.getProductNum(product: product, type: type, inputNum: inputNum)
        self.calculationPackagePrice()
    }
    
    /// 根据规则计算更改后的商品数量  type 1 步减 2步加 3用户自行输入 inputNum用户输入的数量
    func getProductNum(product:FKYProductModel, type:Int,inputNum:String) -> Int{
        /// 步长
        var stepLenght = 1
        /// 单品最大购买量 -1表示不限购
        var maxBuyNum = -1
        /// 最终计算出的可购买数量
        var finalBuyNum = product.preBuyNum
        /// 重置商品的最大最小购买量状态
        product.isMinimumBuyNum = false
        product.isMaximumBuyNum = false
        
        if product.minimumPacking > 0{
            stepLenght = product.minimumPacking
        }
        
        if product.maxBuyNum == -1 {// 不限购
            if product.stockCount > 0{// 有库存限制
                maxBuyNum = product.stockCount
            }else{
                maxBuyNum = 0
            }
        }else {// 限购
            if product.maxBuyNum>0{
                if product.maxBuyNum < product.stockCount{
                    maxBuyNum = product.maxBuyNum
                }else{
                    maxBuyNum = product.stockCount
                }
            }
        }
        
        if type == 1{//步减
            if product.preBuyNum - stepLenght < product.doorsill {// 单品小于最小购买门槛
                product.isMinimumBuyNum = true
                product.isMaximumBuyNum = false
                finalBuyNum = product.doorsill
                return finalBuyNum
            }
            finalBuyNum = product.preBuyNum - stepLenght
            return finalBuyNum
        }else if type == 2{//步加
            if maxBuyNum != -1 , product.preBuyNum + stepLenght > maxBuyNum{// 超过最大限购数量
                product.isMinimumBuyNum = false
                product.isMaximumBuyNum = true
                finalBuyNum = product.preBuyNum
                return finalBuyNum
            }
            finalBuyNum = product.preBuyNum + stepLenght
            return finalBuyNum
        }else if type == 3{// 用户自行输入
            let inputNum = Int(inputNum) ?? product.preBuyNum
            if inputNum < product.doorsill { // 单品小于最小购买门槛
                product.isMinimumBuyNum = true
                product.isMaximumBuyNum = false
                finalBuyNum = product.doorsill
                return finalBuyNum
            }
            let DWT = (inputNum - product.doorsill) % stepLenght
            if DWT > 0{// 说明不是按照步长加的，那么采取向上取整的方案
                let count = Int((inputNum - product.doorsill) / stepLenght) + 1
                if maxBuyNum != -1 , product.doorsill + count*stepLenght > maxBuyNum{// 超过最大限购数量 则返回最多可以购买的数量
                    product.isMinimumBuyNum = false
                    product.isMaximumBuyNum = true
                    let modulus:Int = Int((maxBuyNum - product.doorsill) / stepLenght)
                    finalBuyNum = product.doorsill + modulus*stepLenght
                    return finalBuyNum
                }
                finalBuyNum = product.doorsill + count*stepLenght
                return finalBuyNum
            }
            if maxBuyNum != -1 , inputNum > maxBuyNum{// 超过最大限购数量 则返回最多可以购买的数量
                product.isMinimumBuyNum = false
                product.isMaximumBuyNum = true
                let modulus:Int = Int((maxBuyNum - product.doorsill) / stepLenght)
                finalBuyNum = product.doorsill + modulus*stepLenght
                return finalBuyNum
            }
            finalBuyNum = inputNum
            return finalBuyNum
        }
        finalBuyNum = product.preBuyNum
        return finalBuyNum
    }
    
    /// 更改商品数量后重新计算套餐的结算价
    func calculationPackagePrice(product:FKYProductModel = FKYProductModel()){
        for section in self.sectionList {
            var dinnerPrice:Double = 0
            var dinnerOriginPrice:Double = 0
            var buyCell = FKYMatchingPackageCellModel()
            for cell in section.cellList {
                if cell.cellType == .buyCell {
                    buyCell = cell
                    continue
                }
                
                guard cell.cellData.isSelected,cell.cellType == .productCell else{
                    continue
                }
                let temp_dinnerPrice = cell.cellData.dinnerPrice * Double(cell.cellData.preBuyNum)
                let temp_dinnerOriginPrice = cell.cellData.originalPrice * Double(cell.cellData.preBuyNum)
                dinnerPrice += temp_dinnerPrice
                dinnerOriginPrice += temp_dinnerOriginPrice
            }
            buyCell.dinnerPrice = dinnerPrice
            buyCell.originalPrice = dinnerOriginPrice
            buyCell.dinnerID = "\(section.packageModel.promotionId)"
        }
    }
    
    /// 处理套餐列表数据
    func progressMatchingPackageList(_ responseDic:[String: Any]){
        let temp = ([FKYMacthingPackageModel].deserialize(from: responseDic["dinners"] as? [Any]) as? [FKYMacthingPackageModel]) ?? [FKYMacthingPackageModel]()
        for dinner in temp {
            for product in dinner.productList {
                product.preBuyNum = product.doorsill
                product.isMinimumBuyNum = true
            }
        }
        self.dinners += temp
        self.enterpriseName = (responseDic["enterpriseName"] as? String) ?? ""
        self.position = (responseDic["position"] as? String) ?? ""
    }
    
    /// 验证当前套餐是否符合加购规则 有主品的时候必须选中主品和另一个搭配品，没有主品的时候必须选中两个及以上搭配品
    func isCanAddToCart(dinnerID:String) -> (Bool,String){
        /// 主品的数组
        var mainProductList:[FKYProductModel] = []
        /// 搭配品数组
        var matchProductList:[FKYProductModel] = []
        
        /// 分离出主品和搭配品（后台已经做了排序，但是这里做一遍容错，顺便处理没有主品的情况）
        var cellDataList:[FKYProductModel] = []
        for dinner in self.dinners {
            if "\(dinner.promotionId)" == dinnerID{
                cellDataList = dinner.productList
            }
        }
        
        for product in cellDataList {
            if product.isMainProduct == 1 {// 是主品
                mainProductList.append(product)
            }else{
                matchProductList.append(product)
            }
        }
        
        /// 主品的选中数量
        var mainProductSelectCount:Int = 0
        /// 搭配品的选中数量
        var matchingProductSelectCount:Int = 0
        
        for product in mainProductList {
            if product.isSelected {
                mainProductSelectCount += 1
            }
        }
        
        for product in matchProductList {
            if product.isSelected {
                matchingProductSelectCount += 1
            }
        }
        
        /// 如果有主品
        if mainProductList.count > 0 , mainProductSelectCount > 0, matchingProductSelectCount > 0 {
            return (true,"")
        }else if mainProductList.count > 0 , mainProductSelectCount > 0, matchingProductSelectCount <= 0{
            return (false,"必须购买1个及以上搭配品")
        }else if mainProductList.count > 0 , mainProductSelectCount <= 0, matchingProductSelectCount > 0{
            return (false,"必须购买1个及以上主品")
        }else if mainProductList.count > 0 , mainProductSelectCount <= 0, matchingProductSelectCount <= 0{
            return (false,"必须购买1个及以上主品和1个及以上搭配品")
        }
        
        /// 如果没有主品
        if mainProductList.count <= 0,matchingProductSelectCount >= 2{
            return (true,"")
        }else if mainProductList.count <= 0,matchingProductSelectCount < 2 {
            return (false,"必须购买2个及以上搭配品")
        }
        return (false,"未知错误")
    }
}

//MARK: - 网络请求
extension FKYMatchingPackageViewModel{
    
    /// 获取搭配套餐加入购物车
    func requestAddPackageToCart(dinnerID:String, block: @escaping (Bool, String?)->()){
        let isCan = self.isCanAddToCart(dinnerID:dinnerID)
        guard isCan.0 else {
            block(false,isCan.1)
            return
        }
        /// 已经选中的商品
        var selectedProductList:[FKYProductModel] = []
        /// 摘出这个套餐中已经选中的商品
        for dinner in self.dinners {
            if "\(dinner.promotionId)" == dinnerID {
                for product in dinner.productList {
                    if product.isSelected{
                        selectedProductList.append(product)
                    }
                }
            }
        }
        
        var itemList:[[String:Any]] = []
        for product in selectedProductList {
            var productDic:[String:Any] = [:]
            productDic["supplyId"] = product.supplyId
            productDic["productNum"] = product.preBuyNum
            productDic["spuCode"] = product.spuCode
            productDic["promotionId"] = dinnerID
            if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                productDic["pushId"] = FKYPush.sharedInstance().pushID ?? ""
            }
            itemList.append(productDic)
        }
        var param = [String:Any]()
        param["addType"] = 4
        param["sourceType"] = HomeString.PRODUCT_DP_ADD_SOURCE_TYPE
        param["ItemList"] = itemList
        self.cartRequstSever.addGoodsIntoCartBlock(withParam: param) { [weak self] (response, error) in
            guard let _ = self else{
                block(false,"内存泄露")
                return
            }
            guard error == nil else{
                let msg = error?.localizedDescription ?? ""
                block(false,msg)
                return
            }
            guard let responseDic = response as? [String: Any] else {
                block(false, "数据解析失败")
                return
            }
            let statusCode = (responseDic["statusCode"] as? Int) ?? 1
            let message = (responseDic["message"] as? String) ?? ""
            if statusCode == 0 {// 成功
                block(true, "")
            }else{// 失败为1的时候
                block(false, message)
            }
        }
    }
    
    /// 获取搭配套餐列表
    func requestMatchingPackageList(block: @escaping (Bool, String?)->()){
        let param = ["enterpriseId":self.enterpriseId,
                     "spuCode":self.spuCode,
                     "pageSize":10,
                     "position":self.position,
                     "type":self.packgeType] as [String : Any]
        FKYRequestService.sharedInstance()?.requestForMatchingPackageList(withParam: param, completionBlock: { [weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "内存溢出")
                return
            }

            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }

            guard let responseDic = response as? [String: Any] else {
                block(false, "数据解析失败")
                return
            }
            weakSelf.progressMatchingPackageList(responseDic)
            block(true, "")
        })
    }
}

//MARK: - BI埋点要获取的属性
extension FKYMatchingPackageViewModel{
    
    func getSectionPosition(dinnerID:String) -> String{
        for (index,dinner) in self.dinners.enumerated() {
            if "\(dinner.promotionId)" == dinnerID {
                return "\(index + 1)"
            }
        }
        return ""
    }
    
    func getItemPosition(product:FKYProductModel) -> String{
        for dinner in self.dinners {
            for (index,temp) in dinner.productList.enumerated() {
                if temp.productId == product.productId {
                    return "\(index + 1)"
                }
            }
        }
        return ""
    }
    
    /// type == 1加车dinnerID必传
    /// type == 2进商品详情product必传
    func getItemContent(product:FKYProductModel,dinnerID:String,type:Int) -> String{
        var content:String = ""
        if type == 1{ // 加车
            /// 已经选中的商品
            var selectedProductList:[FKYProductModel] = []
            /// 摘出这个套餐中已经选中的商品
            for dinner in self.dinners {
                if "\(dinner.promotionId)" == dinnerID {
                    for product in dinner.productList {
                        if product.isSelected{
                            selectedProductList.append(product)
                        }
                    }
                }
            }
            for temp_Product in selectedProductList{
                content += ("\(temp_Product.supplyId)"+"|"+temp_Product.spuCode+",")
            }
            
        }else if type == 2{// 进商品详情
            content = "\(product.supplyId)"+"|"+product.spuCode
        }
        return content
    }
    
    /// type == 1加车dinnerID必传
    /// type == 2进商品详情product必传
    func getSectionName(product:FKYProductModel,dinnerID:String,type:Int) -> String{
        var sectionName:String = ""
        if type == 1 {// 加车
            /// 摘出这个套餐中已经选中的商品
            for (_,dinner) in self.dinners.enumerated() {
                if "\(dinner.promotionId)" == dinnerID {
                    sectionName = dinner.promotionName
                }
            }
        }else if type == 2{// 商品详情
            for dinner in self.dinners {
                for temp_product in dinner.productList {
                    if temp_product.productId == product.productId {
                        sectionName = dinner.promotionName
                    }
                }
            }
        }
        return sectionName
    }
    
    func getStorage(product:FKYProductModel) -> String{
        return "\(product.maxBuyNum)"+"|"+"\(product.stockCount)"
    }
    
    func getPm_price(product:FKYProductModel) -> String{
        return "\(product.dinnerPrice)"+"|"+"\(product.originalPrice)"
    }
    
    func getPm_pmtn_type() -> String{
        return "搭配套餐"
    }
}

//MARK: - sectionModel
class FKYMatchingPackageSectionModel:NSObject{
    /// cell列表
    var cellList:[FKYMatchingPackageCellModel] = []
    
    /// 套餐名称
    var packageName:String = ""
    /// 套餐信息
    var packageModel:FKYMacthingPackageModel = FKYMacthingPackageModel()
    /// 此section是否有header
    var isHaveSectionHeader = true
}

//MARK: - cellModel
class FKYMatchingPackageCellModel:NSObject{

    enum cellType {
        /// 未设置类型
        case noType
        /// 空视图
        case emptyCell
        /// 商品cell
        case productCell
        /// 套餐其它商品的分割cell
        case marginCell
        /// 购买套餐  结算cell
        case buyCell
        /// 空态图
        case noProductCell
    }
    
    /// cell类型
    var cellType:cellType = .noType
    
    /// 是否展示上方分割线 暂时未用到
    var isShowTopMargin = false
    
    /// 是否展示下方分割线
    var isShowBottomMargin = true
    
    /// cell高度 主要是空cell的高度
    var cellHeight = 0
    
    /// 当前cell的数据
    var cellData:FKYProductModel = FKYProductModel()
    /// 当前套餐的套餐价
    var dinnerPrice:Double = 0
    /// 当前套餐的原价
    var originalPrice:Double = 0
    /// 当前套餐的ID
    var dinnerID:String = ""
}
