//
//  FKYNewProductRegisterViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

/// cell 类型
enum NewProductRegisterCellType {
    /// 信息输入cell
    case inputCell
    /// 标品cell
    case productCell
    /// 上传图片cell
    case uploadImageCel
}

@objc final class FKYNewProductRegisterViewModel: NSObject,JSONAbleType {
    
    /// 标品列表
    var products = [FKYStandardProductModel]()
    /// 标品搜索结果 0 无数据，1有数据 默认0
    var searchResult = 0
    /// sectionList
    var sectionList = [FKYNewProductRegisterSectionModel()]
    /// 提交的入参
    var submitParam = ["avgMonthSales":"",//月均采购量
                       "barcode":"",//条形码
                       "imagePaths":"",//图片列表 逗号分割多条
                       "masterId":"",//    标品id
                       "purchasePrice":"",//采购价格
                       "userPhone":""]//登记用户手机号
    
    override init() {
        super.init()
        /// 初始化viewModel
        self.initializeViewData()
    }
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->FKYNewProductRegisterViewModel {
        let json = JSON(json)
        let model = FKYNewProductRegisterViewModel()
        let productList = json["products"].arrayValue as NSArray
        model.products = productList.mapToObjectArray(FKYStandardProductModel.self) ?? [FKYStandardProductModel]()
        model.searchResult = json["searchResult"].intValue
        return model
    }
}

/// 网络请求
extension FKYNewProductRegisterViewModel {
    ///提交参数
    func submitProductInfo(callBack:@escaping (_ isSuccess:Bool,_ Msg:String)->()){
        FKYRequestService.sharedInstance()?.requestForSubmitNewProduct(withParam: self.submitParam, completionBlock: { [weak self] (success, error, response, model) in
            guard self != nil else{
                return
            }
            
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callBack(false,msg)
                return
            }
            callBack(true,"提交成功")
        })
    }
    
    /// 获取标品列表
    func requestStandardProductList(param:[String:AnyObject],callBack:@escaping (_ isSuccess:Bool,_ Msg:String)->()) {
        
        FKYRequestService.sharedInstance()?.requestForGetStandardProductSetList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else{
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callBack(false,msg)
                return
            }
            
            // 请求成功 整理数据
            if let data = response as? NSDictionary {
                if let productArray = data["products"] as? NSArray{
                    strongSelf.products.removeAll()
                    strongSelf.products = productArray.mapToObjectArray(FKYStandardProductModel.self) ?? [FKYStandardProductModel]()
                }
                strongSelf.searchResult = data["searchResult"] as! Int
                
            }
            callBack(true,"")
        })
    }
}

//MARK: - 整理数据
extension FKYNewProductRegisterViewModel {
    
    /// 更新用户手机号
    func updataUserPhone(){
        let cellModel = self.sectionList[1].cellList[0]
        cellModel.inputText = UserDefaults.standard.object(forKey: "user_mobile") as? String ?? ""
    }
    
    /// 检查参数是否按要求填写完整
    func isInputFull() -> (Bool,String) {
        self.initializeSubmitParam()
        if self.submitParam["barcode"]!.isEmpty {
            return (false,"请扫描条形码(69码)")
        }
        if self.submitParam["userPhone"]!.isEmpty {// 电话号码
            return (false,"请填写手机号")
        }else{
            let reg = "^1[0-9]+$"
            let pre = NSPredicate(format: "SELF MATCHES %@", reg)
            if !pre.evaluate(with: self.submitParam["userPhone"]!) {
                return (false,"请填写1开头手机号")
            }
            if self.submitParam["userPhone"]!.count != 11{
                return (false,"请填正确格式手机号")
            }
        }
        if !(self.submitParam["avgMonthSales"]!.isEmpty) {
            let reg = "^[0-9]+$"
            let pre = NSPredicate(format: "SELF MATCHES %@", reg)
            if !pre.evaluate(with: self.submitParam["avgMonthSales"]!) {
                return (false,"请输入正确的月均采购量")
            }
            if submitParam["avgMonthSales"]!.count > 7{
                return (false,"月均采购最多不能超过百万(7位数字)")
            }
        }
        if !(self.submitParam["purchasePrice"]!.isEmpty) {
            let reg = "^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$"
            let pre = NSPredicate(format: "SELF MATCHES %@", reg)
            if !pre.evaluate(with: self.submitParam["purchasePrice"]!) {
                return (false,"请输入正确的期望采购价,最多两位小数")
            }
            if self.submitParam["purchasePrice"]!.count > 10{
                return (false,"请输入正确的期望采购价,最多10位含小数")
            }
        }
        if self.submitParam["masterId"]!.isEmpty{
            if self.submitParam["imagePaths"]!.isEmpty{
                return (false,"请上传药盒正面、背面、侧面等含有药品信息的图片")
            }
        }
        return (true,"")
    }
    
    /// 给提交的参数赋值
    func initializeSubmitParam(){
        self.submitParam["avgMonthSales"] = self.sectionList[2].cellList[0].inputText
        self.submitParam["barcode"] = self.sectionList[0].cellList[0].inputText
        var imagePathsList:[String] = []
        for imageModel in self.sectionList[3].cellList[0].uploadImageList{
            if imageModel.isHaveImage {
                imagePathsList.append(imageModel.imageUrl)
            }
        }
        let imagePath:String = imagePathsList.joined(separator: ",")
        self.submitParam["imagePaths"] = imagePath
        if self.sectionList[0].cellList.count > 1{
            self.submitParam["masterId"] = "\(self.sectionList[0].cellList[1].productInfo.masterId)"
        }
        self.submitParam["purchasePrice"] = self.sectionList[2].cellList[1].inputText
        self.submitParam["userPhone"] = self.sectionList[1].cellList[0].inputText
    }
    
    /// 更新二维码条码
    func updataBarcode(barcode:String){
        guard self.sectionList.count > 0 else {
            return
        }
        let cell = self.sectionList[0].cellList[0]
        cell.inputText = barcode
    }
    
    /// 用户选择了一个商品
    func userSelectedProduct(product:FKYStandardProductModel){
        guard self.sectionList.count > 0 else {
            return
        }
        if self.sectionList[0].cellList.count == 1{// 还未插入商品信息
            
            let cell1 = FKYNewProductRegisterCellModel()
            cell1.configCell(cellType: .productCell, isShowScanButton: false, isEnabelTFEditer: false, titleTexxt: "", inputText: "", holderText: "", isFirstCell: false, isLastCell: true, isNeedShowMarginLine: false)
            cell1.productInfo = product
            self.sectionList[0].cellList.append(cell1)
            let cell2 = self.sectionList[0].cellList[0]
            cell2.isLastCell = false
            cell2.isNeedShowMarginLine = true
        }else if self.sectionList[0].cellList.count == 2{// 已经插入过商品信息
            let cell = self.sectionList[0].cellList[1]
            cell.productInfo = product
        }
        if product.masterId == 0{// 空的
            self.updataUploadImageString(string: "上传图片(必填，不超过三张图片)")
        }else{
            self.updataUploadImageString(string: "上传图片(选填，不超过三张图片)")
        }
    }
    
    /// 更新上传图片的文描
    func updataUploadImageString(string:String){
        self.sectionList[3].sectionTitle = string
    }
    
    /// 插入标品信息cell
    func insertProductCell(productInfo:FKYStandardProductModel){
        guard self.sectionList.count > 0 else {
            return
        }
        
        guard self.sectionList[0].cellList.count > 0 else {
            return
        }
        
        let cell1 = self.sectionList[0].cellList[0]
        cell1.isLastCell = false
        cell1.isNeedShowMarginLine = true
        
        let cell2 = FKYNewProductRegisterCellModel()
        cell2.configCell(cellType: .productCell, isShowScanButton: false, isEnabelTFEditer: false, titleTexxt: "", inputText: "", holderText: "", isFirstCell: false, isLastCell: true, isNeedShowMarginLine: false, productInfo: productInfo)
        self.sectionList[0].cellList.append(cell2)
    }
    
    /// 移除商品信息cell
    func removeProductCell(){
        guard self.sectionList.count > 0 else {
            return
        }
        
        guard self.sectionList[0].cellList.count > 1 else {
            return
        }
        self.sectionList[0].cellList.removeLast()
        let cell1 = self.sectionList[0].cellList[0]
        cell1.isLastCell = true
        cell1.isNeedShowMarginLine = false
        self.updataUploadImageString(string: "上传图片(必填，不超过三张图片)")
    }
    
    /// 移除上传的商品图片信息
    func remvoeUploadImageInfo(){
        let uploadCellModel = self.sectionList[3].cellList[0]
        uploadCellModel.uploadImageList.removeAll()
        let imageModel = UploadImageModel()
        uploadCellModel.uploadImageList.append(imageModel)
    }
    
    /// 初始化页面数据
    func initializeViewData(){
        self.sectionList.removeAll()
        let section1 = FKYNewProductRegisterSectionModel()
        section1.sectionTitle = "扫描条形码(69码)"
        let cell1_1 = FKYNewProductRegisterCellModel()
        cell1_1.configCell(cellType: .inputCell, isShowScanButton: true, isEnabelTFEditer: false, titleTexxt: "条形码(69码)", inputText:"" , holderText: "请扫描条形码(69码)", isFirstCell: true, isLastCell: true, isNeedShowMarginLine: false)
        section1.cellList.append(cell1_1)
        
        let section2 = FKYNewProductRegisterSectionModel()
        section2.sectionTitle = "填写联系方式"
        let cell2_1 = FKYNewProductRegisterCellModel()
        cell2_1.configCell(cellType: .inputCell, isShowScanButton: false, isEnabelTFEditer: true, titleTexxt: "手机号", inputText: UserDefaults.standard.object(forKey: "user_mobile") as? String ?? "", holderText: "1开头手机号", isFirstCell: true, isLastCell: true, isNeedShowMarginLine: false)
        cell2_1.inpuInfoType = "1"
        section2.cellList.append(cell2_1)
        
        let section3 = FKYNewProductRegisterSectionModel()
        section3.sectionTitle = "填写采购信息(选填)"
        let cell3_1 = FKYNewProductRegisterCellModel()
        let cell3_2 = FKYNewProductRegisterCellModel()
        cell3_1.configCell(cellType: .inputCell, isShowScanButton: false, isEnabelTFEditer: true, titleTexxt: "月均采购量", inputText: "", holderText: "填写数量", isFirstCell: true, isLastCell: false, isNeedShowMarginLine: true)
        cell3_1.inpuInfoType = "2"
        cell3_2.configCell(cellType: .inputCell, isShowScanButton: false, isEnabelTFEditer: true, titleTexxt: "期望采购价", inputText: "", holderText: "填写价格", isFirstCell: false, isLastCell: true, isNeedShowMarginLine: false)
        cell3_2.inpuInfoType = "3"
        section3.cellList.append(cell3_1)
        section3.cellList.append(cell3_2)
        
        let section4 = FKYNewProductRegisterSectionModel()
        section4.sectionTitle = "上传图片(必填，不超过三张图片)"
        let cell4_1 = FKYNewProductRegisterCellModel()
        cell4_1.configCell(cellType: .uploadImageCel, isShowScanButton: false, isEnabelTFEditer: false, titleTexxt: "请上传药盒正面、背面、侧面（含有药品信息的）照片", inputText: "", holderText: "", isFirstCell: true, isLastCell: true, isNeedShowMarginLine: false)
        let imageModel = UploadImageModel()
        cell4_1.uploadImageList.append(imageModel)
        section4.cellList.append(cell4_1)
        
        self.sectionList.append(section1)
        self.sectionList.append(section2)
        self.sectionList.append(section3)
        self.sectionList.append(section4)
    }
    
    /// 成功上传一个图片
    func addUploadImageView(imageModel:UploadImageModel){
        let cellModel = self.sectionList[3].cellList[0]
        self.addUploadImage(imageModel: imageModel, cellModel: cellModel)
    }
    
    /// 移除一个上传的图片
    func removeUploadImage(imageModel:UploadImageModel,cellModel:FKYNewProductRegisterCellModel) {
        guard imageModel.isHaveImage else{
            return
        }
        
        guard let index = cellModel.uploadImageList.index(of: imageModel) else{
            return
        }
        let maxCount = 3// 最大的上传图片数量
        cellModel.uploadImageList.remove(at: index)
        if cellModel.uploadImageList.count == maxCount-1{
            var isHaveEmptyImage = false
            for image in cellModel.uploadImageList {
                if image.isHaveImage == false{
                    isHaveEmptyImage = true
                }
            }
            if isHaveEmptyImage {
                
            }else{
                let image = UploadImageModel()
                cellModel.uploadImageList.append(image)
            }
        }
    }
    
    /// 增加一个上传的图片
    func addUploadImage(imageModel:UploadImageModel,cellModel:FKYNewProductRegisterCellModel) {
        let maxCount = 3// 最大的上传图片数量
        var isHaveEmptyImage = false
        for image in cellModel.uploadImageList {
            if image.isHaveImage == false{
                isHaveEmptyImage = true
            }
        }
        
        if isHaveEmptyImage {
            cellModel.uploadImageList.insert(imageModel, at: cellModel.uploadImageList.count-1)
        }else{
            cellModel.uploadImageList.append(imageModel)
        }
        
        if cellModel.uploadImageList.count > maxCount {
            cellModel.uploadImageList.removeLast()
        }
    }
    
}

// MARK: - section模型对象
class FKYNewProductRegisterSectionModel:NSObject {
    /// section中的cell列表
    var cellList:[FKYNewProductRegisterCellModel] = []
    /// section的title
    var sectionTitle = "暂无分区标题"
}

// MARK: - cell模型对象
class FKYNewProductRegisterCellModel:NSObject {
    /// cell类型
    var cellType:NewProductRegisterCellType = .inputCell
    /// 是否展示扫描按钮
    var isShowScanButton = false
    /// 是否允许输入框编辑
    var isEnabelTFEditer = true
    /// title的文字
    var titleTexxt = "暂无标题"
    /// 输入的文字
    var inputText = "暂无输入文字"
    /// holder文字
    var holderText = "占位文字"
    /// 是否是第一个cell
    var isFirstCell = false
    /// 是否是最后一个cell
    var isLastCell = false
    /// 是否需要显示分割线
    var isNeedShowMarginLine = false
    /// 当前cell商品是否被选中
    var isSelected = false
    /// 标品信息
    var productInfo = FKYStandardProductModel()
    /// 上传的图片列表
    var uploadImageList:[UploadImageModel] = []
    /// 当前输入的信息  1手机号 2 采购量 3采购价
    var inpuInfoType = ""
    
    func configCell(cellType:NewProductRegisterCellType ,isShowScanButton:Bool ,isEnabelTFEditer:Bool ,titleTexxt:String ,inputText:String ,holderText:String ,isFirstCell:Bool ,isLastCell:Bool, isNeedShowMarginLine:Bool ,productInfo:FKYStandardProductModel = FKYStandardProductModel()){
        self.cellType = cellType
        self.isShowScanButton = isShowScanButton
        self.isEnabelTFEditer = isEnabelTFEditer
        self.titleTexxt = titleTexxt
        self.inputText = inputText
        self.holderText = holderText
        self.isFirstCell = isFirstCell
        self.isLastCell = isLastCell
        self.isNeedShowMarginLine = isNeedShowMarginLine
        self.productInfo = productInfo
    }
}

//MARK: - 上传图片的model
class UploadImageModel:NSObject{
    
    /// 是否有图片(当前是否显示图片)
    var isHaveImage = false
    /// 当前显示的图片
    var image = UIImage()
    /// 上传后image的地址
    var imageUrl = ""
}
