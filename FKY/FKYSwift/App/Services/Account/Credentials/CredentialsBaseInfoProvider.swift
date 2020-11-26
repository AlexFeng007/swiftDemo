//
//  CredentialsBaseInfoProvider.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/29.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  基本信息model

import Foundation
import RxSwift

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


typealias CompleteClosure = (Bool, String?)->()
typealias CompleteClosureWithCode = (Bool, Int, String?)->()


final class CredentialsBaseInfoProvider: NSObject {
    //    fileprivate let defaultSelectedDrugScope: [String] = ["生化药品","化学药制剂","中药材","中药饮片","中成药","生物制品","抗生素制剂","化学原料药","抗生素原料药","一类医疗器械","诊断试剂","食品","保健食品","乳制品（含婴幼儿配方乳粉）","化妆品","日用消毒制品","含可待因复方口服液","胰岛素"]
    // v4.3.0更改注册时默认勾选的经营范围为：生化药品、化学药制剂、中药饮片、中成药、生物制品、抗生素制剂、一类医疗器械、食品、化妆品、日用消毒制品
    fileprivate let defaultSelectedDrugScope: [String] = ["生化药品","化学药制剂","中药饮片","中成药","生物制品","抗生素制剂","一类医疗器械","化妆品","日用消毒制品"]
    
    var credentialRequestSever : FKYPublicNetRequestSevice = (FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice)!
    
    var baseInfoModel: ZZModel?                                                 // 企业基本信息
    var drugScopes: [DrugScopeModel]? = [DrugScopeModel]()                      // 经营范围
    var enterpriseArray: [EnterpriseTypeModel] = [EnterpriseTypeModel]()        // 企业类型
    var usermanageAuditStatus: [ZZRefuseReasonModel] = [ZZRefuseReasonModel]()  // // 非批零一体拒绝原因
    var retailAuditStatus: [ZZAllInOneRefuseReasonModel] = [ZZAllInOneRefuseReasonModel]() // 批零一体拒绝原因
    
    // 填写的信息
    var enterpriseType: EnterpriseTypeModel?
    var inputBaseInfo: ZZModel = ZZModel()
    var sectionModelArray:[[ZZBaseInfoSectionType]] = ZZBaseInfoSectionType.allValues
    
    // 通过企业名称获取的企业信息model
    var enterpriseInfoFromErp: ZZEnterpriseInfo?
    
    //MARK: “基本企业信息”，Section Count的获取
    func numberOfSections() -> Int {
        return sectionModelArray.count
    }
    
    //MARK: “基本企业信息”，Section Type的获取
    func numberOfRowCountIn(_ section: Int) -> Int {
        return sectionModelArray[section].count
    }
    
    //MARK: “基本企业信息”，Cell Type的获取
    func getContentTypeFor(_ indexPath: IndexPath) -> ZZBaseInfoSectionType {
        return sectionModelArray[indexPath.section][indexPath.row]
    }
    
    //MARK: 是否批零一体状态获取
    func isWholeSaleRetailState() -> Bool {
        return inputBaseInfo.enterprise?.isWholesaleRetail == 1
    }
    
    //MARK: “基本企业信息”,Cell Content的获取
    func contentInForInputType(_ sectionType: ZZBaseInfoSectionType) -> String {
        switch sectionType {
        case .EnterpriseName: // 企业名称
            if let enterpriseName = inputBaseInfo.enterprise?.enterpriseName {
                return enterpriseName
            }else {
                return ""
            }
        case .EnterpriseType: // 企业类型
            return inputBaseInfo.getEnterpriseTypeForBaseInfoRegister()
        case .Location: // 所在地区
            if let addressLocation = inputBaseInfo.enterprise?.addressJustLocation {
                return addressLocation
            } else {
                return ""
            }
        case .AddressDetail: // 详细地址
            if let addressDetailDes = inputBaseInfo.enterprise?.registeredAddress {
                return addressDetailDes
            }else {
                return ""
            }
        case .DrugScope: // 经营范围
            var typeName = ""
            inputBaseInfo.drugScopeList?.forEach({ (scope) in
                if typeName == "" {
                    typeName = scope.drugScopeName
                }else{
                    typeName = typeName + "," + scope.drugScopeName
                }
            })
            return typeName
        case .EnterpriseLegalPerson: //  企业法人
            if let personName = inputBaseInfo.enterprise?.legalPersonname {
                return personName as String
            }else {
                return ""
            }
        case .DeliveryAddress: // 收发货地址
            return ""
        case .BankInfo: // 银行信息
            if let model = inputBaseInfo.bankInfoModel, let name =  model.bankName {
                return name
            }
            return ""
        case .SaleSet: // 销售设置
            if inputBaseInfo.enterprise?.orderSAmount != nil && inputBaseInfo.enterprise?.orderSAmount != "" {
                return "起批价:\(inputBaseInfo.enterprise!.orderSAmount!)元"
            }
            return ""
        case .InvitationCode: // 邀请码
            if let inviteCode = inputBaseInfo.inviteCode {
                return inviteCode as String
            }else {
                return ""
            }
        case .SalesManPhone: // 负责业务员
            if let userName = inputBaseInfo.userName {
                return userName as String
            }else {
                return ""
            }
        case .AllInOneLocation: // 批零一体零售企业所在地区
            if let addressLocation = inputBaseInfo.enterpriseRetail?.addressJustLocation {
                return addressLocation
            } else {
                return ""
            }
        case .AllInOneAddress: // 批零一体零售企业详细地址
            if let addressDetailDes = inputBaseInfo.enterpriseRetail?.registeredAddress {
                return addressDetailDes
            }else {
                return ""
            }
        case .AllInOneName: // 批零一体零售企业企业名称
            if let enterpriseName = inputBaseInfo.enterpriseRetail?.enterpriseName {
                return enterpriseName
            }else {
                return ""
            }
        case .AllInOneShopNumbers: // 批零一体零售企业门店数
            if let shopNum = inputBaseInfo.enterpriseRetail?.shopNum {
                return "\(shopNum)"
            }else {
                return ""
            }
        case .AllInOne:
            return ""
        }
    }
    
    func getQualificationBaseRowInfo(_ row:ZZEnterpriseInputType) -> String? {
        switch row {
        case .RetailEnterpriseName: // 零售企业名称
            return baseInfoModel?.enterpriseRetail?.enterpriseName
        case .RetailLocation: // 零售企业所在地区
            return baseInfoModel?.enterpriseRetail?.addressDetailDesc
        case .WholeSaleType: // 批零一体批发企业模式
            return baseInfoModel?.enterprise?.isWholesaleRetail == 1 ? "批零一体" : "非批零一体"
        case .ShopNum: // 批零一体门店数
            return "\(baseInfoModel?.enterpriseRetail?.shopNum ?? 0)家"
        case .EnterpriseName:
            return baseInfoModel?.enterprise?.enterpriseName
        case .EnterpriseLegalPerson:
            return baseInfoModel?.enterprise?.legalPersonname
        case .EnterpriseType:
            return baseInfoModel?.getEnterpriseTypeName()
        case .Location:
            return baseInfoModel?.enterprise?.addressDetailDesc
        case .BankName:
            return baseInfoModel?.bankInfoModel?.bankName
        case .BankCode:
            return baseInfoModel?.bankInfoModel?.bankCode
        case .BankAccountName:
            return baseInfoModel?.bankInfoModel?.accountName
        case .BasePrice:
            if let orderSAmount = baseInfoModel?.enterprise!.orderSAmount {
                return "\(orderSAmount)元"
            }
            return "0 元"
        case .SalesDistrict:
            if let deliveryAreaList = baseInfoModel?.deliveryAreaList {
                if let lcationNames = (deliveryAreaList as NSArray).value(forKeyPath: "getLocaltionDes") as? [String] {
                    return lcationNames.joined(separator: "、")
                }else {
                    return ""
                }
            }
            return ""
        case .DrugScope:
            if let drugScopeList = baseInfoModel?.drugScopeList {
                if let drugScopeNames = (drugScopeList as NSArray).value(forKeyPath: "drugScopeName") as? [String] {
                    return drugScopeNames.joined(separator: "、")
                }else {
                    return ""
                }
            }
            return ""
        default:
            return nil
        }
    }
    
    func getQualificationDeliveryAddressInfo(_ row:ZZEnterpriseInputType) ->  ZZReceiveAddressModel? {
        if row == .DeliveryAddress{
            if self.baseInfoModel?.address != nil && (self.baseInfoModel?.address?.isEmpty)! {
                return nil
            }
            if let deliveryAreaList = self.baseInfoModel?.address {
                return deliveryAreaList[0]
            }
            return nil;
        }
        return nil;
    }
    
    func saveEnterpriseInfo(_ msg: String?, type: ZZEnterpriseInputType){
        if type == .EnterpriseName {
            self.inputBaseInfo.enterprise?.enterpriseName = msg
        }
        if type == .LegalPerson {
            self.inputBaseInfo.enterprise?.legalPersonname = msg
        }
        if type == .ContectPerson {
            self.inputBaseInfo.enterprise?.contactsName = msg
        }
        if type == .TelePhone {
            self.inputBaseInfo.enterprise?.enterpriseCellphone = msg
        }
    }
    
    func isChooseEnterpriseTypes() -> Bool {
        if let enterpriseTypeList = inputBaseInfo.listTypeInfo, enterpriseTypeList.count > 0 {
            return (enterpriseTypeList.first?.paramName.count > 0)
        }
        else {
            return false
        }
    }
    
    // 前提是当前企业类型必须是批发企业~!@
    func updateAllInOneItems(withSwitchState state: Bool) {
        // 是否批零一体设置
        inputBaseInfo.enterprise?.isWholesaleRetail = state ? 1 : 0
        
        guard state == true else {
            // 仅批发企业...<非批零一体>
            sectionModelArray = ZZBaseInfoSectionType.allValuesForPF
            return
        }
        // 批发零售一体...<批零一体>
        sectionModelArray = ZZBaseInfoSectionType.allValuesForALLINONE
    }
    
    // 保存企业类型
    func saveEnterpriseTypesForUserInfo(_ type: EnterpriseTypeModel) {
        self.enterpriseType = type
        //self.inputBaseInfo.enterpriseTypeList = [type.mapToEnterpriseOriginTypeModel()]
        self.inputBaseInfo.listTypeInfo = [type.mapToEnterpriseOriginTypeModel()]
        
        /*
         before 3.5.1(包括3.5.1)
         "终端客户" 清除之前的销售设置记录 —— 针对终端企业没有"销售设置"，清空"销售设置"信息(deliveryAreaList)
         "生产企业" 清除之前的经营范围 —— 针对"生产企业"没有"经营范围"的选择，并清空之前的"经营范围"的选择(drugScopeList)
         "批发企业" 恢复所有的设置
         start 3.6.0
         去掉了生产企业
         */
        if let typeName = self.enterpriseType?.paramName {
            // 进一步判断
            switch typeName {
            case ZZEnterpriseType.PF.rawValue:
                self.inputBaseInfo.enterprise?.roleType = 3
                if self.inputBaseInfo.enterprise?.isWholesaleRetail == 1 {
                    self.sectionModelArray = ZZBaseInfoSectionType.allValuesForALLINONE
                } else {
                    self.sectionModelArray = ZZBaseInfoSectionType.allValuesForPF
                }
                break
            case ZZEnterpriseType.SC.rawValue:
                break
            case ZZEnterpriseType.ZD.rawValue:
                fallthrough
            default:
                // 终端清除之前的销售设置记录
                self.inputBaseInfo.enterprise?.roleType = 1
                self.sectionModelArray = ZZBaseInfoSectionType.allValues
                break
            }
        } else {
            // 默认非批发企业
            self.sectionModelArray = ZZBaseInfoSectionType.allValues
        }
    }
    
    // ???
    func handleEnterpriseTypesForAPI() {
        var enterpriseRoleType = 0
        if let roleType = inputBaseInfo.enterprise?.roleType {
            enterpriseRoleType = roleType
        }
        else {
            if let enterpriseTypeList = inputBaseInfo.listTypeInfo {
                if let _ = (enterpriseTypeList as NSArray).filtered(using: NSPredicate(format: "remark == '终端客户'")).first as? EnterpriseOriginTypeModel {
                    enterpriseRoleType = 1
                }
                else {
                    if let enterpriseType = inputBaseInfo.listTypeInfo?.first {
                        if "批发企业" == enterpriseType.remark {
                            enterpriseRoleType = 3
                        }
                    }
                }
            }
        }
        
        switch enterpriseRoleType {
        case 1:// 1: 终端
            // 终端清除之前的销售设置记录
            self.inputBaseInfo.enterprise?.roleType = 1
            self.inputBaseInfo.deliveryAreaList = [SalesDestrictModel]()
            self.sectionModelArray = ZZBaseInfoSectionType.allValues
            if let enterpriseModel = inputBaseInfo.listTypeInfo?.first {
                self.enterpriseType = EnterpriseTypeModel(paramCode: enterpriseModel.paramCode, paramName: enterpriseModel.paramName, paramValue: enterpriseModel.paramValue)
            }
        case 2:// 2: 生产
            break
        case 3://3: 批发
            self.inputBaseInfo.enterprise?.roleType = 3
            updateAllInOneItems(withSwitchState: inputBaseInfo.enterprise?.isWholesaleRetail == 1)
            if let enterpriseModelList = inputBaseInfo.listTypeInfo, let enterpriseModel = enterpriseModelList.first {
                var paramValue = "11;12;13;14"
                if let paramValues = (enterpriseModelList as NSArray).value(forKeyPath: "paramValue") as? [String] {
                    paramValue = (paramValues as NSArray).componentsJoined(by: ";")
                }
                self.enterpriseType = EnterpriseTypeModel(paramCode: enterpriseModel.paramCode, paramName: enterpriseModel.remark, paramValue: paramValue)
            }
            break
        default:
            print("enterpriseRoleType exception")
            break
        }
    }
    
    func emptyString(_ string: String?) -> Bool {
        if let toCheckString = string, string != "" {
            let words = toCheckString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                return true
            }else {
                return false
            }
        }
        return true
    }
    
    // MARK: - 企业基本信息 填写校验
    func isCanSubmitEnterpriseBaseInfo() -> Bool {
        func validString(_ value: String?) -> Bool {
            if let ret = value, (ret as NSString).length > 0 {
                let words = ret.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    return false
                }
            } else {
                return false
            }
            return true
        }
        // 企业名称
        guard validString(inputBaseInfo.enterprise?.enterpriseName) else {
            return false
        }
        // 企业类型
        if enterpriseType == nil {
            if let enterpriseTypeList = inputBaseInfo.enterpriseTypeList, enterpriseTypeList.count > 0 {
            } else {
                return false
            }
        }
        // 所在地区
        guard validString(inputBaseInfo.enterprise?.addressJustLocation) else {
            return false
        }
        // 详细地址
        guard validString(inputBaseInfo.enterprise?.registeredAddress) else {
            return false
        }
        // 是否批零一体
        if inputBaseInfo.enterprise?.isWholesaleRetail == 1 {
            // 批零一体企业名称
            guard validString(inputBaseInfo.enterpriseRetail?.enterpriseName) else {
                return false
            }
            // 批零一体所在地区
            guard validString(inputBaseInfo.enterpriseRetail?.addressJustLocation) else {
                return false
            }
            // 批零一体详细地址
            guard validString(inputBaseInfo.enterpriseRetail?.registeredAddress) else {
                return false
            }
            // 门店数
            guard let model = inputBaseInfo.enterpriseRetail, let shopNumber = model.shopNum, shopNumber > 0 else {
                return false
            }
        }
        // 企业法人
        if inputBaseInfo.enterprise?.roleType == 3{
            guard validString(inputBaseInfo.enterprise?.legalPersonname) else {
                return false
            }
        }
        // 经营范围
        if let arr = inputBaseInfo.drugScopeList, arr.count > 0{
        } else {
            return false
        }
        
        if inputBaseInfo.enterprise?.roleType != 1 {
            //银行信息
            if let bankInfo = inputBaseInfo.bankInfoModel {
                if emptyString(bankInfo.bankName) || emptyString(bankInfo.bankCode) {
                    return false
                }
            }else{
                return false
            }
            //批发企业去掉销售设置
            if (inputBaseInfo.enterprise?.roleType != 3) {
                // 销售设置
                if let arr = inputBaseInfo.deliveryAreaList, arr.count > 0{
                    // 校验起售金额
                    if let price = inputBaseInfo.enterprise?.orderSAmount, price != "" {
                        
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: 检查填写页面的数据
    func checkEditEnterpriseBaseInfo(_ complete:(Bool,String?)->()) {
        // checkBaseInfo
        if let name =  baseInfoModel?.enterprise?.enterpriseName, (name as NSString).length > 0 {
            let words = name.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                return complete(false, "请先填写\(ZZEnterpriseInputType.EnterpriseName.rawValue)")
            }
        }
        else {
            return complete(false, "请先填写\(ZZEnterpriseInputType.EnterpriseName.rawValue)")
        }
        
        if let _ = baseInfoModel?.enterprise?.addressProvinceDetail , let addressDetail = baseInfoModel?.enterprise?.registeredAddress, (addressDetail as NSString).length > 0 {
            let words = addressDetail.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                return complete(false, "请先填写\(ZZEnterpriseInputType.AddressDetail.rawValue)")
            }
        }
        else {
            return complete(false, "请先填写\(ZZEnterpriseInputType.AddressDetail.rawValue)")
        }
        //批发企业
        if baseInfoModel?.enterprise?.roleType == 3{
            if let legalPersonname = baseInfoModel?.enterprise?.legalPersonname ,(legalPersonname as NSString).length > 0 {
                let words = legalPersonname.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    return complete(false, "请先填写\(ZZEnterpriseInputType.EnterpriseLegalPerson.rawValue)")
                }
            }
            else {
                return complete(false, "请先填写\(ZZEnterpriseInputType.EnterpriseLegalPerson.rawValue)")
            }
        }
        
        
        // 经营范围
        if baseInfoModel?.enterprise?.roleType != 2 {
            if let arr = baseInfoModel?.drugScopeList, arr.count > 0 {
                //
            }
            else {
                return complete(false, "请先选择\(ZZBaseInfoSectionType.DrugScope.rawValue)")
            }
        }
        
        // 终端不校验 销售设置 和 银行信息
        if baseInfoModel?.enterprise?.roleType != 1 {
            if let bankInfo = baseInfoModel?.bankInfoModel {
                if emptyString(bankInfo.bankName) || emptyString(bankInfo.bankCode) {
                    return complete(false, "请先填写\(ZZBaseInfoSectionType.BankInfo.rawValue)")
                }
            }
            else {
                return complete(false, "请先填写\(ZZBaseInfoSectionType.BankInfo.rawValue)")
            }
            
            if baseInfoModel?.enterprise?.roleType != 3 { //批发企业去掉销售设置
                if let arr = baseInfoModel?.deliveryAreaList, arr.count > 0 {
                    // 校验起售金额
                    if let price = baseInfoModel?.enterprise?.orderSAmount, (price as NSString).length <= 0 {
                        return complete(false, "请先填写\(ZZEnterpriseInputType.BasePrice.rawValue)")
                    }
                }
                else {
                    return complete(false, "请先选择\(ZZBaseInfoSectionType.SaleSet.rawValue)")
                }
            }
        }
        
        return complete(true, nil)
    }
    
    // MARK: - 保存填写的基本信息
    func firstSaveEnterpriseInfo(_ complete: @escaping CompleteClosureWithCode) {
        let dict:[String: AnyObject] = self.firstGenerateBaseInfoDict()
        self.credentialRequestSever.saveEnterpriseBlock(withParam: dict) { (response, error) in
            if error == nil {
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, 0, message)
                }
                else {
                    complete(true, 0, "成功")
                }
            }
            else {
                var errorMsg = "失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, (error! as NSError).code, errorMsg)
            }
        }
    }
    
    // MARK: - 获取基本信息
    func queryBaseInfo(_ callback: @escaping ()->()) {
        self.credentialRequestSever.queryEnterpriseByIdBlock(withParam: nil) { (response, error) in
            if error == nil {
                // 成功
                if let baseInfo = response as? NSDictionary {
                    // 有返回
                    self.baseInfoModel = baseInfo.mapToObject(ZZModel.self)
                    self.inputBaseInfo = baseInfo.mapToObject(ZZModel.self)
                    // TODO: 企业类型 　”listTypeInfo“ 字段解析
                    // after 3.5.1 ，之前回根据企业类型回额外显示或隐藏一些信息的填写入口
                    if let arr = self.inputBaseInfo.enterpriseTypeList, arr.count > 0 {
                        self.handleEnterpriseTypesForAPI()
                    }
                }
                else {
                    // 无返回
                    self.baseInfoModel = nil
                    self.inputBaseInfo = ZZModel()
                }
                
                if self.baseInfoModel != nil {
                    self.baseInfoModel!.filterQCList()
                    self.inputBaseInfo.filterQCList()
                }
                callback()
            }
            else {
                // 失败
                var errorMsg = "请求失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                        FKYAppDelegate!.showToast(errorMsg)
                    }
                }
                callback()
            }
        }
    }
    
    // MARK: - 获取原资料信息
    func zzOriginInfo(_ callback: @escaping ()->()) {
        self.credentialRequestSever.queryPassedEnterpriseInfoBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let json = response as? NSDictionary {
                    self.baseInfoModel = json.mapToObject(ZZModel.self)
                }
                else {
                    self.baseInfoModel = nil
                }
                
                if self.baseInfoModel != nil {
                    self.baseInfoModel!.filterQCList()
                }
                callback()
            }
            else {
                var errorMsg = "请求失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                FKYAppDelegate!.showToast(errorMsg)
                callback()
            }
        }
    }
    
    // MARK: - 获取原资料信息
    func zzHasOriginInfo(_ completion: @escaping CompleteClosure) {
        self.credentialRequestSever.queryPassedEnterpriseInfoBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let json = response as? NSDictionary {
                    self.baseInfoModel = json.mapToObject(ZZModel.self)
                }
                else {
                    self.baseInfoModel = nil
                }
                if self.baseInfoModel != nil {
                    self.baseInfoModel!.filterQCList()
                }
                completion(true, nil)
            }
            else {
                var errorMsg = "失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                completion(false, errorMsg)
            }
        }
    }
    
    // MARK:- 获取经营范围
    func getDrugScope(_ callback: @escaping ()->()) {
        self.credentialRequestSever.getDrugScopeBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let scopes = response as? NSArray {
                    self.drugScopes = scopes.mapToObjectArray(DrugScopeModel.self)
                    // 更新是否选中的经营范围
                    if self.inputBaseInfo.drugScopeList?.count > 0 {
                        self.drugScopes?.forEach({ (ele) in
                            let filteredArr = self.inputBaseInfo.drugScopeList?.filter({ (model) -> Bool in
                                return model.drugScopeId == ele.drugScopeId
                            })
                            if filteredArr?.count > 0 {
                                ele.selected = true
                            }
                        })
                    }
                }
                else {
                    self.drugScopes = []
                }
                callback()
            }
            else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                self.drugScopes = []
                callback()
            }
        }
    }
    
    // MARK:- 基本资料获取经营范围，没有经营范围，就设置默认的经营范围
    func getDrugScopeForBaseInfo(_ callback: @escaping ()->()) {
        self.credentialRequestSever.getDrugScopeBlock(withParam: nil) { (response, error) in
            if error == nil {
                // 成功
                if let scopes = response as? NSArray {
                    self.drugScopes = scopes.mapToObjectArray(DrugScopeModel.self)
                    // 更新是否选中的经营范围
                    if self.inputBaseInfo.drugScopeList?.count > 0 {
                        self.drugScopes?.forEach({ (ele) in
                            let filteredArr = self.inputBaseInfo.drugScopeList?.filter({ (model) -> Bool in
                                return model.drugScopeId == ele.drugScopeId
                            })
                            if filteredArr?.count > 0 {
                                ele.selected = true
                            }
                        })
                    }
                    else {
                        if let drugScopes = self.drugScopes {
                            let searchPredicate = NSPredicate(format: "self.drugScopeName IN %@", self.defaultSelectedDrugScope)
                            if let selectedScopeArray = (drugScopes as NSArray).filtered(using: searchPredicate) as? [DrugScopeModel] {
                                self.inputBaseInfo.drugScopeList = selectedScopeArray
                                self.drugScopes?.forEach({ (ele) in
                                    let filteredArr = self.inputBaseInfo.drugScopeList?.filter({ (model) -> Bool in
                                        return model.drugScopeId == ele.drugScopeId
                                    })
                                    if filteredArr?.count > 0 {
                                        ele.selected = true
                                    }
                                })
                            }
                        }
                    }
                }
                else {
                    self.drugScopes = []
                }
                callback()
            }
            else {
                // 失败
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                self.drugScopes = []
                callback()
            }
        }
    }
    
    // MARK:- 获取企业类型
    func getRollType(_ callback: @escaping ()->()) {
        self.credentialRequestSever.getAllRollTypeNewBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let rolls = response as? NSArray {
                    if let types = rolls.mapToObjectArray(EnterpriseTypeModel.self) {
                        self.enterpriseArray = types
                    }
                    else {
                        self.enterpriseArray = []
                    }
                }
                callback()
            }
            else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                callback()
            }
        }
    }
    
    // MARK: - 获取收发货地址
    func getAddressList(_ callback: @escaping ()->()) {
        self.credentialRequestSever.getReceiverAddressListBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let address = response as? NSArray {
                    let addresses = address.mapToObjectArray(ZZReceiveAddressModel.self)
                    self.inputBaseInfo.receiverAddressList = addresses
                }
                else {
                    self.inputBaseInfo.receiverAddressList = []
                }
                callback()
            }
            else {
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期，请重新手动登录")
                    }
                }
                callback()
            }
        }
    }
    
    // MARK: - 修改收发货地址
    func updateAddress(_ params:ZZReceiveAddressModel? , complete:@escaping (Bool, String?)->()) {
        self.credentialRequestSever.updateReceiverAddressBlock(withParam: ["usermanageReceiverAddressDft":params?.reverseJSON() ?? ""]) { (response, error) in
            if error == nil {
                // 成功
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, message)
                }
                else {
                    complete(true, "修改成功")
                }
            }
            else {
                // 失败
                var errorMsg = ""
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, errorMsg)
            }
        }
    }
    
    // MARK: - 新增收发货地址
    func addAddress(_ params:ZZReceiveAddressModel?, complete: @escaping (Bool, ZZReceiveAddressModel?, String?)->()) {
        self.credentialRequestSever.saveReceiverAddressBlock(withParam: ["usermanageReceiverAddressDft" : params?.reverseJSON() ?? ""]) { (response, error) in
            if error == nil {
                // 成功
                if let address = response as? NSDictionary {
                    let addresses = address.mapToObject(ZZReceiveAddressModel.self)
                    complete(true, addresses, nil)
                }
                else {
                    // 当前情况视作失败???
                    complete(false, nil, nil)
                }
            }
            else {
                // 失败
                var errorMsg = ""
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, nil, errorMsg)
            }
        }
    }
    
    // MARK: - 删除收发货地址
    func deleteAddress(_ addressId:String , complete:@escaping (Bool, String?)->()) {
        self.credentialRequestSever.deleteReceiverAddressBlock(withParam: ["id": addressId]) { (response, error) in
            if error == nil {
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, message)
                }
                else {
                    complete(true, "删除成功")
                }
            }
            else {
                var errorMsg = "删除失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, errorMsg)
            }
        }
    }
    
    // MARK: - 设置默认收发货地址
    func setDefaultAddress(_ addressId:String, complete: @escaping (Bool, String?)->()) {
        self.credentialRequestSever.updDefReceiverAddressBlock(withParam: ["id": addressId]) { (response, error) in
            if error == nil {
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, message)
                }
                else {
                    complete(true, "设置成功")
                }
            }
            else {
                var errorMsg = "设置失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, errorMsg)
            }
        }
    }
    
    // MARK: 资质状态查询
    func zzStatus(_ callback: @escaping (_ statusCode:NSNumber?)->()) {
        self.credentialRequestSever.getAuditStatusBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let json = response as? NSDictionary {
                    if let statusCode = (json as AnyObject).value(forKeyPath: "statusCode") as? NSNumber {
                        callback(statusCode)
                    }
                    else {
                        callback(-2)
                    }
                }
                else {
                    callback(-2)
                }
            }
            else {
                callback(-2)
            }
        }
    }
    
    // MARK: 提交审核
    func submitToService(_ para:[String:AnyObject] , complete: @escaping (Bool, String?)->()) {
        self.credentialRequestSever.submitAuditDftBlock(withParam: para) { (response, error) in
            if error == nil {
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, message)
                }
                else {
                    complete(true, "提交成功")
                }
            }
            else {
                var errorMsg = "提交失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, errorMsg)
            }
        }
    }
    
    // MARK 资质文件保存
    func sazeZZFile(_ param: [String:AnyObject], complete: @escaping (Bool, String?)->()) -> () {
        self.credentialRequestSever.saveQcDftListBlock(withParam:["map" : param]) { (response, error) in
            if error == nil {
                if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                    complete(true, message)
                }
                else {
                    complete(true, "保存成功")
                }
            }
            else {
                var errorMsg = "保存失败"
                if let errorMessage = error?.localizedDescription {
                    errorMsg = "\(errorMessage)"
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                complete(false, errorMsg)
            }
        }
    }
    
    // MARK: - 保存基本信息(企业基本信息等)
    func createSaveEnterpriseInfo(_ isChangeBankInfo:Bool, complete: @escaping (Bool, String?)->()) {
        var dict:[String: AnyObject] = self.generateBaseInfoDict()
        if isChangeBankInfo {
            dict = self.generateBankInfoDict()
        }
        
        self.credentialRequestSever.createSaveEnterpriseDftBlock(withParam:dict , completionBlock: {(responseObject, anError)  in
            if anError == nil {
                complete(true, "成功")
            }
            else {
                var errorMsg = anError?.localizedDescription ?? "失败"
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }else {
                        // 修改企业类型和注册地址省份open var userInfo: [String : Any] { get }
                        let errorUseInfo:[String : Any] = e.userInfo
                        if  let rtn_code = errorUseInfo["rtn_code"] {
                            if let code = rtn_code as? String,code == "8" {
                               complete(true, errorMsg)
                               return
                            }
                        }
                       
                    }
                }
                complete(false, errorMsg)
            }
        })
    }
    
    // MARK: - 根据企业名称获取企业信息
    func getEnterpriseInfoFromErp(_ name: String, _ callback: @escaping (Bool, String?)->()) {
        self.credentialRequestSever.getEnterpriseInfoFromErp(withParam:["enterpriseName" : name]) { (response, error) in
            if error == nil {
                // 成功
                if let json = response as? NSDictionary, let info = json["businessInformation"] as? NSDictionary {
                    // (非空)字典
                    self.enterpriseInfoFromErp = info.mapToObject(ZZEnterpriseInfo.self)
                }
                else {
                    self.enterpriseInfoFromErp = nil
                }
                callback(true, "查询成功")
            }
            else {
                // 失败
                //                var errorMsg = "查询失败"
                //                if let errorMessage = error?.localizedDescription {
                //                    errorMsg = "\(errorMessage)"
                //                }
                var errorMsg: String? = nil
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        errorMsg = "用户登录过期，请重新手动登录"
                    }
                }
                callback(false, errorMsg)
            }
        }
    }
    
    
    // MARK: - 根据inputBaseInfo 生成第一次基本信息的填写
    func firstGenerateBaseInfoDict() -> [String: AnyObject] {
        var parms:[String: AnyObject] = ["enterprise": "" as AnyObject,"checkedList": "" as AnyObject,"deliveryAreas": "" as AnyObject,"typeData": "" as AnyObject,"inviteCode": "" as AnyObject,"userName": "" as AnyObject]
        
        var baseInfo = combineBaseInfo(inputBaseInfo, parms: &parms) // 获取时可能包含typeData
        var allInOne = combineAllInOne(inputBaseInfo, parms: &baseInfo) // 批零一体
        var drugScope = combineDrugScope(inputBaseInfo, parms: &allInOne)
        var bankInfo = combineBankInfo(inputBaseInfo, parms: &drugScope) // 更新baseInfo 也需要更新typeData
        var deliveryAreaList = combineDeliveryAreaList(inputBaseInfo, parms: &bankInfo)
        if let inviteCode = inputBaseInfo.inviteCode {
            deliveryAreaList["inviteCode"] = inviteCode as AnyObject
        }
        if let userName = inputBaseInfo.userName {
            deliveryAreaList["userName"] = userName as AnyObject
        }
        
        return deliveryAreaList
    }
    
    // MARK: - 根据baseInfoModel 生成保存基本信息需要的入参
    func generateBaseInfoDict() -> [String: AnyObject] {
        if let ent = self.baseInfoModel?.enterprise {
            let entRetail = self.baseInfoModel?.enterpriseRetail
            
            // 用户修改企业类型后传的类型id
            var changeid = 0
            if let tid = ent.type_id {
                changeid = tid
            }
            // 企业法人委托证
            var attachMent:[String: AnyObject] = ["typeId": "1" as AnyObject,
                                                  "fileId": "iPhoneUpload" as AnyObject,
                                                  "fileName": "iPhoneFile.jpg" as AnyObject,
                                                  "url": "/fky/img/test/1480576682185.jpg" as AnyObject]
            if let legalPerson = self.baseInfoModel?.LegalPersonModel {
                let picInfo = legalPerson.filePath
                var picAddress = ""
                if picInfo != nil {
                    picAddress = (picInfo! as NSString).replacingOccurrences(of: "http://p8.maiyaole.com", with: "")
                    picAddress = picAddress.replacingOccurrences(of: "https://p8.maiyaole.com", with: "")
                }
                if (picAddress as NSString).length <= 0 {
                    let typeId = getEnterpriseTypeId(self.baseInfoModel!)
                    let typeData:[String: Any] = ["attachment":[],"typeId":typeId]
                    let params = [ "typeUpd": "1",
                                   "typeId": changeid,
                                   "typeData": typeData,
                                   "enterprise": ent.reverseJSONFirst(),
                                   "enterpriseRetail": entRetail?.reverseJSON() ?? ""] as [String : Any]
                    return params as [String : AnyObject]
                }
                attachMent["url"] = picAddress as AnyObject
            }
            let typeId = getEnterpriseTypeId(self.baseInfoModel!)
            let typeData:[String: Any] = ["attachment":[attachMent],"typeId":typeId]
            
            let params = [ "typeUpd": "1",
                           "type_id": changeid,
                           "typeData": typeData,
                           "enterprise": ent.reverseJSONFirst(),
                           "enterpriseRetail": entRetail?.reverseJSON() ?? ""] as [String : Any]
            return params as [String : AnyObject]
        }
        return ["typeUpd": "1" as AnyObject, "enterprise": "" as AnyObject, "enterpriseRetail": "" as AnyObject]
    }
    
    // MARK: - 根据baseInfoModel 生成保存银行信息需要的入参
    func generateBankInfoDict() -> [String: AnyObject] {
        if let ent = self.baseInfoModel?.enterprise {
            var attachMent:[String: String] = ["typeId": "3",
                                               "fileId": "iPhoneUpkload",
                                               "fileName": "iPhoneFile.jpg",
                                               "url": "/fky/img/test/1480576682185.jpg"]
            if let bankInfo = self.baseInfoModel?.bankInfoModel {
                ent.bankCode = bankInfo.bankCode
                ent.bankName = bankInfo.bankName
                ent.accountName = bankInfo.accountName
                // 银行开户许可证
                let picInfo = bankInfo.QCFile?.filePath
                var picAddress = ""
                if picInfo != nil {
                    picAddress = (picInfo! as NSString).replacingOccurrences(of: "http://p8.maiyaole.com", with: "")
                    picAddress = picAddress.replacingOccurrences(of: "https://p8.maiyaole.com", with: "")
                }
                attachMent["url"] = picAddress
            }
            let attachArr: [[String: String]] = [attachMent]
            let typeId = getEnterpriseTypeId(self.baseInfoModel!)
            let typeData:[String: AnyObject] = ["attachment":attachArr as AnyObject,
                                                "typeId":typeId as AnyObject]
            let params = [
                "typeUpd": "2", // 企业类型 paramValue
                "typeData": typeData,
                "enterprise": ent.reverseJSONFirst()] as [String : Any]
            
            return params as [String : AnyObject]
        }
        return ["typeUpd": "2" as AnyObject, "enterprise": "" as AnyObject]
    }
    
    // MARK: - 保存经营范围
    func updateDrugScope(_ complete:@escaping CompleteClosure) {
        if let scopeList = self.baseInfoModel?.drugScopeList {
            let scopeListArray = (scopeList as NSArray).reverseToJSON()
            let dict = ["checkedList": scopeListArray]
            self.credentialRequestSever.saveDrugScopeDftBlock(withParam: ["jsonObj":dict]) { (response, error) in
                if error == nil {
                    if let message = (response as AnyObject).value(forKeyPath: "message") as? String {
                        complete(true, message)
                    }
                    else {
                        complete(true, "保存成功")
                    }
                }
                else {
                    var errorMsg = error?.localizedDescription ?? "保存失败"
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            errorMsg = "用户登录过期，请重新手动登录"
                        }
                    }
                    complete(false, errorMsg)
                }
            }
        }
    }
    
    // MARK: - 保存销售设置
    func saveDeliveryAreaList(_ complete: @escaping CompleteClosure) {
        if let areaList = self.baseInfoModel?.deliveryAreaList {
            let areaListArray = (areaList as NSArray).reverseToJSON()
            var parms:[String: AnyObject] = ["orderSAmount": "" as AnyObject,
                                             "deliveryAreas": areaListArray as AnyObject]
            if let orderStepPrice = self.baseInfoModel?.enterprise?.orderSAmount {
                parms["orderSAmount"] = orderStepPrice as AnyObject
            }
            self.credentialRequestSever.saveDftBlock(withParam: parms) { (response, error) in
                if error == nil {
                    if let json = response as? NSDictionary ,let message = (json as AnyObject).value(forKeyPath: "message") as? String {
                        complete(true, message)
                    }
                    else {
                        complete(true, "成功")
                    }
                }
                else {
                    var errorMsg = error?.localizedDescription ?? "失败"
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            errorMsg = "用户登录过期，请重新手动登录"
                        }
                    }
                    complete(false, errorMsg)
                }
            }
        }
    }
    
    // MARK: - 组装请求入参
    // MARK: - 组装基本信息 获取企业类型 typeId
    func getEnterpriseTypeId(_ zzmodel: ZZModel) -> String {
        var typeId = ""
        //if zzmodel.enterpriseTypeList != nil && zzmodel.enterpriseTypeList!.count > 0 {
        if zzmodel.listTypeInfo != nil && zzmodel.listTypeInfo!.count > 0 {
            //let typeArray = zzmodel.enterpriseTypeList!.map({ (mo) -> String in
            let typeArray = zzmodel.listTypeInfo!.map({ (mo) -> String in
                return mo.getParamValueForAPI()
            })
            typeId = (typeArray as NSArray).componentsJoined(by: ",") // 企业ID
        }
        if let enterpriseType = self.enterpriseType {
            typeId = enterpriseType.getParamValueForAPI()
        }
        return typeId
    }
    
    // MARK: - 组装基本信息 根据基本信息和企业法人委托证生成enterprise字段 和TypeData字段'
    func combineBaseInfo(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        // 首次填写, 企业类型
        if let ent = zzmodel.enterprise {
            //非批发企业，起批价置空
            if 1 == ent.roleType {
                ent.orderSAmount = ""
            }
            if let bankInfo = zzmodel.bankInfoModel {
                ent.bankCode = bankInfo.bankCode
                ent.bankName = bankInfo.bankName
                ent.accountName = bankInfo.accountName
            }
            
            // 首次填写基本资料，isCheck字段按接口要求写死为12
            ent.isCheck = 12
            let enterpriseDict = ent.reverseJSONFirst()
            let typeId = getEnterpriseTypeId(self.inputBaseInfo)
            // 生成rollType
            let typeData:[String: Any] = ["attachment":[],"typeId":typeId,]
            let pms:[String: AnyObject] = ["typeData": typeData as AnyObject, "enterprise": enterpriseDict as AnyObject]
            return pms
        }
        
        return ["typeData": "" as AnyObject, "enterprise": "" as AnyObject]
    }
    
    // MARK: - 组装批零一体零售企业基本信息
    func combineAllInOne(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        guard let ent = zzmodel.enterpriseRetail, zzmodel.enterprise?.isWholesaleRetail == 1 else {
            return parms
        }
        let enterpriseDict = ent.reverseJSON()
        parms["enterpriseRetail"] = enterpriseDict as AnyObject
        return parms
    }
    
    // MARK: - 组装经营范围 生成checkedList字段
    func combineDrugScope(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        if let scopeList = zzmodel.drugScopeList {
            let scopeListArray = (scopeList as NSArray).reverseToJSON()
            parms["checkedList"] = scopeListArray as AnyObject
            return parms
        }
        return parms
    }
    
    // MARK: - 企业银行信息 更新TypeData字段 和enterprise字段
    func combineBankInfo(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        let typeId = getEnterpriseTypeId(zzmodel)
        var attachMent:[String: AnyObject] = ["typeId": "3" as AnyObject,
                                              "fileId": "iPhoneUpkload" as AnyObject,
                                              "fileName": "iPhoneFile.jpg" as AnyObject,
                                              "url": "/fky/img/test/1480576682185.jpg" as AnyObject]
        if let bankInfo = zzmodel.bankInfoModel {
            // 银行开户许可证
            let picInfo = bankInfo.QCFile?.filePath
            var picAddress = ""
            if picInfo != nil {
                picAddress = (picInfo! as NSString).replacingOccurrences(of: "http://p8.maiyaole.com", with: "")
                picAddress = picAddress.replacingOccurrences(of: "https://p8.maiyaole.com", with: "")
            }
            
            if (picAddress as NSString).length > 0 {
                attachMent["url"] = picAddress as AnyObject
                let attachArr: [[String: AnyObject]] = [attachMent]
                let typeData:[String: AnyObject] = ["attachment":attachArr as AnyObject,
                                                    "typeId":typeId as AnyObject]
                parms["typeData"] = typeData as AnyObject
            }
        }
        return parms
    }
    
    // MARK: - 销售设置 生成deliveryAreaList字段
    func combineDeliveryAreaList(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        //非批发企业，销售设置置空  3.8.7批发企业隐藏销售设置
        if (1 == zzmodel.enterprise?.roleType || 3 == zzmodel.enterprise?.roleType) {
            parms["deliveryAreas"] = NSArray() as AnyObject
            return parms
        }
        if let deliveryAreas = zzmodel.deliveryAreaList, deliveryAreas.count > 0 {
            parms["deliveryAreas"] = (deliveryAreas as NSArray).reverseToJSON() as AnyObject
            return parms
        }
        parms["deliveryAreas"] = NSArray() as AnyObject
        return parms
    }
    
    // MARK: - 资质信息 生成TypeData字段
    func combineTypeData(_ zzmodel: ZZModel, parms:inout [String: AnyObject]) -> [String: AnyObject] {
        // 保存资质入参
        let typeId = getEnterpriseTypeId(zzmodel)
        zzmodel.qcList = zzmodel.qcList?.filter({ (qcfile) -> Bool in
            if 0 != qcfile.typeId , let file_path = qcfile.filePath {
                if (qcfile.typeId == 1 && (file_path as NSString).contains("p8.maiyaole.com")){
                    return false
                }
                if (qcfile.typeId == 3 && (file_path as NSString).contains("p8.maiyaole.com")){
                    return false
                }
            }
            return true
        })
        if let qclist = zzmodel.qcList, qclist.count > 0 {
            var attachArr: [[String: AnyObject]] = (qclist as NSArray).reverseToJSON()
            let atts = (parms["typeData"]?.value(forKey: "attachment"))! as! [[String : AnyObject]]
            atts.forEach { (obj) in
                attachArr.append(obj)
            }
            let typeData:[String: AnyObject] = ["attachment":attachArr as AnyObject,
                                                "typeId":typeId as AnyObject]
            parms["typeData"] = typeData as AnyObject
        }
        return parms
    }
    
    func sectionTypeWithTypeForQualification() -> [[ZZEnterpriseInputType:[ZZEnterpriseInputType]]] {
        if let roleType = self.baseInfoModel?.enterprise?.roleType {
            let isWholeSaleRetail = baseInfoModel?.enterprise?.isWholesaleRetail == 1
            let wsrTypes = [ZZEnterpriseInputType.WholeSaleAndRetailInfo: ZZEnterpriseInputType.WholeSaleAndRetailInfo.wholeSaleRetailSubTypes(isWholeSaleRetail)]
            var typeArray: [[ZZEnterpriseInputType:[ZZEnterpriseInputType]]] = []
            switch roleType {
            case 1:// 1: 终端
                typeArray = [[.BaseInfo: ZZEnterpriseInputType.BaseInfo.subTypes(roleType)],  [.DrugScope: ZZEnterpriseInputType.DrugScope.subTypes(roleType)],[.DeliveryAddress: ZZEnterpriseInputType.DeliveryAddress.subTypes(roleType)],[.ZZfile: ZZEnterpriseInputType.ZZfile.subTypes(roleType)]]
                break
            case 2:// 2: 生产
                typeArray = [[.BaseInfo: ZZEnterpriseInputType.BaseInfo.subTypes(roleType)],[.DeliveryAddress: ZZEnterpriseInputType.DeliveryAddress.subTypes(roleType)],[.BankInfo: ZZEnterpriseInputType.BankInfo.subTypes(roleType)],[.SaleSet: ZZEnterpriseInputType.SaleSet.subTypes(roleType)],[.ZZfile: ZZEnterpriseInputType.ZZfile.subTypes(roleType)]]
                break
                
            default://3: 批发
                typeArray = [[.BaseInfo: ZZEnterpriseInputType.BaseInfo.subTypes(roleType)],wsrTypes, [.DrugScope: ZZEnterpriseInputType.DrugScope.subTypes(roleType)],[.DeliveryAddress: ZZEnterpriseInputType.DeliveryAddress.subTypes(roleType)],[.BankInfo: ZZEnterpriseInputType.BankInfo.subTypes(roleType)],[.ZZfile: ZZEnterpriseInputType.ZZfile.subTypes(roleType)]]
                break
            }
            typeArray.append([.LegalInfo: ZZEnterpriseInputType.LegalInfo.subTypes(roleType)])
            return typeArray
        }
        else {
            return []
        }
    }
    
    func reasonTypeForSectionType(_ sectionType: ZZEnterpriseInputType, zztype: Int?) -> Int? {
        switch sectionType {
        case .BaseInfo:
            return QCErrorType.baseInfo.rawValue
        case .DrugScope:
            return QCErrorType.drugScope.rawValue
        case .Address:
            return QCErrorType.addressList.rawValue
        case .BankInfo:
            return QCErrorType.bankInfo.rawValue
        case .SaleSet:
            return QCErrorType.salesDistrict.rawValue
        case .DeliveryAddress:
            return QCErrorType.addressList.rawValue
        case .ZZfile:
            if zztype == nil {
                return nil
            }
            return zztype
        default:
            return QCErrorType.baseInfo.rawValue
        }
    }
    
    func reasonTypeForWholeSaleRetailSectionType(_ sectionType: ZZEnterpriseInputType, zztype: Int?) -> Int? {
        switch sectionType {
        case .BaseInfo:
            return QCWholeSaleRetailErrorType.baseInfo.rawValue
        case .ZZfile:
            if zztype == nil {
                return nil
            }
            return zztype
        default:
            return QCWholeSaleRetailErrorType.baseInfo.rawValue
        }
    }
    
    func refuseReasonForSectionType(_ inputType: ZZEnterpriseInputType, zztype: Int?) -> String? {
        if inputType == .WholeSaleAndRetailInfo {
            let refuseModel = self.baseInfoModel?.retailAuditDetailList?.filter({ (model) -> Bool in
                if let type = reasonTypeForWholeSaleRetailSectionType(inputType, zztype: zztype) {
                    return model.status == 2 && model.type == type
                }
                return false
            })
            if refuseModel?.count > 0 {
                return refuseModel?.first?.failedReason
            }
            return nil
        }
        else {
            let refuseModel = self.baseInfoModel?.usermanageAuditStatus?.filter({ (model) -> Bool in
                if let type = reasonTypeForSectionType(inputType, zztype: zztype) {
                    return model.status == 2 && model.type == type
                }
                return false
            })
            if refuseModel?.count > 0 {
                return refuseModel?.first?.failedReason
            }
            return nil
        }
    }
}

