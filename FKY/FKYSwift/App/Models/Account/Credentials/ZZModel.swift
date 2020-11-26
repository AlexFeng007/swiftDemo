//
//  ZZModel.swift
//  FKY
//
//  Created by mahui on 2016/11/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  基本信息model

import Foundation
import SwiftyJSON

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


final class ZZModel: NSObject, JSONAbleType {
    
    var userName: String? // 业务员子账号???
    var inviteCode: String? // 邀请码
    var isAuditfailedReason: String? // 审核失败原因
    var canModifyName: Bool? = true // 是否可修改企业名称
    
    // 企业类型相关
    var listTypeInfo: [EnterpriseOriginTypeModel]? // 用户当前企业类型
    var enterpriseTypeList: [EnterpriseChooseModel]? // 用户可修改（选择）的企业类型
    
    // 企业信息相关...<名称、地区、地址>
    var enterprise: ZZBaseInfoModel? // (批发企业or非批发企业)企业信息
    var enterpriseRetail: ZZAllInOneBaseInfoModel? // (批零一体)零售企业信息
    
    // 银行相关...<默认仅一项>
    var qualification: [ZZFileModel]? // 银行资质model数组
    
    // 经营范围
    var drugScopeList: [DrugScopeModel]? // 用户选中的经营范围model数组
    
    // 收货地址
    var address: [ZZReceiveAddressModel]? // 地址...<只取第一个>
    var receiverAddressList: [ZZReceiveAddressModel]? // 地址列表...<不再返回>
    var deliveryAreaList: [SalesDestrictModel]? // 配送区域列表...<销售区域列表>...<未使用>
    
    // （上传图片）资质相关
    var qcList: [ZZFileModel]? // (批发企业or非批发企业)企业资质model数组
    var qualificationRetailList: [ZZAllInOneFileModel]? // (批零一体)零售企业资质model数组
    
    // 资质审核相关数组???
    var qualityAuditList: [ZZQualityAuditModel]? // 查询资质信息
    var usermanageAuditStatus: [ZZRefuseReasonModel]? // 非批零一体资质审核详情...<usermanagerAuditDetail ???>
    var retailAuditDetailList: [ZZAllInOneRefuseReasonModel]? // 批零一体审核详情
    
    //
    var bankInfoModel: ZZBankInfoModel? //
    var LegalPersonModel: ZZFileModel? //
    
    
    // 页面存储介质
    override init() {
        self.listTypeInfo = [EnterpriseOriginTypeModel]()
        self.enterpriseTypeList = [EnterpriseChooseModel]()
        
        self.qualification = [ZZFileModel]()
        
        self.drugScopeList = [DrugScopeModel]()
        
        self.address = [ZZReceiveAddressModel]()
        self.receiverAddressList = [ZZReceiveAddressModel]()
        self.deliveryAreaList = [SalesDestrictModel]()
        
        self.qcList = [ZZFileModel]()
        self.qualificationRetailList = [ZZAllInOneFileModel]()
        
        self.qualityAuditList = [ZZQualityAuditModel]()
        self.usermanageAuditStatus = [ZZRefuseReasonModel]()
        self.retailAuditDetailList = [ZZAllInOneRefuseReasonModel]()
        
        self.enterprise = ZZBaseInfoModel()
        self.enterpriseRetail = ZZAllInOneBaseInfoModel()
        
        self.bankInfoModel = ZZBankInfoModel()
        self.LegalPersonModel = ZZFileModel()
    }
    
    // init
    init(drugScopeList: [DrugScopeModel]?, receiverAddressList: [ZZReceiveAddressModel]?, enterprise: ZZBaseInfoModel?, enterpriseRetail: ZZAllInOneBaseInfoModel?, qcList: [ZZFileModel]?, qualificationRetailList: [ZZAllInOneFileModel]?, deliveryAreaList: [SalesDestrictModel]?, listTypeInfo: [EnterpriseOriginTypeModel]?, qualityAuditList: [ZZQualityAuditModel]?, enterpriseTypeList: [EnterpriseChooseModel]?, usermanageAuditStatus: [ZZRefuseReasonModel]?, canModifyName: Bool?, inviteCode: String?, userName: String?, isAuditfailedReason: String?, retailAuditDetailList: [ZZAllInOneRefuseReasonModel]?, qualification: [ZZFileModel]?, rulesAddressList: [ZZReceiveAddressModel]?) {
        self.drugScopeList = drugScopeList
        self.receiverAddressList = receiverAddressList
        self.enterprise = enterprise
        self.enterpriseRetail = enterpriseRetail
        self.qcList = qcList
        self.qualification = qualification
        self.qualificationRetailList = qualificationRetailList
        self.deliveryAreaList = deliveryAreaList
        self.address = rulesAddressList
        
        self.listTypeInfo = listTypeInfo
        self.qualityAuditList = qualityAuditList
        self.enterpriseTypeList = enterpriseTypeList
        
        self.usermanageAuditStatus = usermanageAuditStatus
        self.retailAuditDetailList = retailAuditDetailList
        
        if let _ = enterprise?.accountName, let _ = enterprise?.bankCode, let _ = enterprise?.bankName, let _ = qualification {
            let bankFileModelArray = qualification!.filter({ (zzfilemodel) -> Bool in
                return zzfilemodel.typeId==QCType.bankAccount.rawValue
            })
            self.bankInfoModel = ZZBankInfoModel()
            self.bankInfoModel?.accountName = enterprise!.accountName!
            self.bankInfoModel?.bankName = enterprise!.bankName!
            self.bankInfoModel?.bankCode = enterprise!.bankCode!
            self.bankInfoModel?.QCFile = bankFileModelArray.first
        }
        
        //2018.04.24 标注修改的地方
        self.LegalPersonModel = ZZFileModel()
        
        if let canModifyNameBool = canModifyName {
            self.canModifyName = canModifyNameBool
        }
        else {
            self.canModifyName = true
        }
        
        if let inviteCodeStr = inviteCode {
            self.inviteCode = inviteCodeStr
        }
        if let userNameStr = userName {
            self.userName = userNameStr
        }
        if let isAuditfailedReasonStr = isAuditfailedReason {
            self.isAuditfailedReason = isAuditfailedReasonStr
        }
    }
    
    // MARK: NSKeyedArchiver For Init
    init(drugScopeList: [DrugScopeModel]?, receiverAddressList: [ZZReceiveAddressModel]?, enterprise: ZZBaseInfoModel?, enterpriseRetail: ZZAllInOneBaseInfoModel?, qcList: [ZZFileModel]?, qualificationRetailList: [ZZAllInOneFileModel]?, deliveryAreaList: [SalesDestrictModel]?, listTypeInfo: [EnterpriseOriginTypeModel]?, qualityAuditList: [ZZQualityAuditModel]?, enterpriseTypeList: [EnterpriseChooseModel]?, usermanageAuditStatus: [ZZRefuseReasonModel]?, canModifyName: Bool?, inviteCode: String?, userName: String?, isAuditfailedReason: String?, bankInfoModel: ZZBankInfoModel?, retailAuditDetailList: [ZZAllInOneRefuseReasonModel]?, qualification: [ZZFileModel]?, rulesAddressList: [ZZReceiveAddressModel]?) {
        self.drugScopeList = drugScopeList
        self.receiverAddressList = receiverAddressList
        self.enterprise = enterprise
        self.enterpriseRetail = enterpriseRetail
        self.qcList = qcList
        self.qualificationRetailList = qualificationRetailList
        self.qualification = qualification
        self.deliveryAreaList = deliveryAreaList
        self.address = rulesAddressList;
        
        self.listTypeInfo = listTypeInfo
        self.qualityAuditList = qualityAuditList
        self.enterpriseTypeList = enterpriseTypeList
        
        self.usermanageAuditStatus = usermanageAuditStatus
        self.retailAuditDetailList = retailAuditDetailList
        self.bankInfoModel = bankInfoModel
        self.LegalPersonModel = ZZFileModel()
        
        if let canModifyNameBool = canModifyName {
            self.canModifyName = canModifyNameBool
        }
        else {
            self.canModifyName = true
        }
        
        if let inviteCodeStr = inviteCode {
            self.inviteCode = inviteCodeStr
        }
        if let userNameStr = userName {
            self.userName = userNameStr
        }
        if let isAuditfailedReasonStr = isAuditfailedReason {
            self.isAuditfailedReason = isAuditfailedReasonStr
        }
    }
    
    // json解析...<Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ data: [String : AnyObject]) -> ZZModel {
        let json = JSON(data)
        
        var enterprise : ZZBaseInfoModel?
        let dic = json["enterprise"].dictionaryObject
        if let _ = dic {
            let t = dic! as NSDictionary
            enterprise = t.mapToObject(ZZBaseInfoModel.self)
        } else {
            enterprise = ZZBaseInfoModel()
        }
        var enterpriseRetail: ZZAllInOneBaseInfoModel?
        let enterpriseRetailDic = json["enterpriseRetail"].dictionaryObject
        if let _ = enterpriseRetailDic {
            let t = enterpriseRetailDic! as NSDictionary
            enterpriseRetail = t.mapToObject(ZZAllInOneBaseInfoModel.self)
        } else {
            enterpriseRetail = ZZAllInOneBaseInfoModel()
        }
        
        let drugScope = json["drugScopeList"].arrayObject
        let addressList = json["receiverAddressList"].arrayObject
        let qc = json["qcList"].arrayObject
        let qlist = json["qualification"].arrayObject
        let qRetailList = json["qualificationRetailList"].arrayObject
        let deliveryArea = json["deliveryAreaList"].arrayObject
        let listTypeInfo = json["listTypeInfo"].arrayObject
        let qualityAuditList = json["qualityAuditList"].arrayObject
        let enterpriseTypeList = json["enterpriseTypeList"].arrayObject // add
        let refuseReasonList = json["usermanagerAuditDetails"].arrayObject
        let allinoneRefuseReasonList = json["retailAuditDetailList"].arrayObject
        let qruleAddress = json["address"].arrayObject
        
        var receiverAddressList:[ZZReceiveAddressModel]?
        var drugScopeList:[DrugScopeModel]?
        var rulesAddressList:[ZZReceiveAddressModel]?
        var qcList:[ZZFileModel]?
        var qualification: [ZZFileModel]?
        var qualificationRetailList: [ZZAllInOneFileModel]?
        var deliveryAreaList:[SalesDestrictModel]?
        var typeList : [EnterpriseOriginTypeModel]?
        var auditList : [ZZQualityAuditModel]?
        var enterpriseList: [EnterpriseChooseModel]?
        var usermanagerAuditDetails: [ZZRefuseReasonModel]?
        var retailAuditDetailList: [ZZAllInOneRefuseReasonModel]?
        
        if let scopes = drugScope {
            drugScopeList = (scopes as NSArray).mapToObjectArray(DrugScopeModel.self)
        }
        if let rulesAddress = qruleAddress{
             rulesAddressList = (rulesAddress as NSArray).mapToObjectArray(ZZReceiveAddressModel.self)
        }
        if let addressArray = addressList {
            receiverAddressList = (addressArray as NSArray).mapToObjectArray(ZZReceiveAddressModel.self)
        }
        if let _ = qc {
            qcList = (qc! as NSArray).mapToObjectArray(ZZFileModel.self)
        }
        if let _ = qlist {
            qualification = (qlist! as NSArray).mapToObjectArray(ZZFileModel.self)
        }
        if let _ = qRetailList {
            qualificationRetailList = (qRetailList! as NSArray).mapToObjectArray(ZZAllInOneFileModel.self)
        }
        if let _ = deliveryArea {
            deliveryAreaList = (deliveryArea! as NSArray).mapToObjectArray(SalesDestrictModel.self)
        }
        if let list = listTypeInfo {
            typeList = (list as NSArray).mapToObjectArray(EnterpriseOriginTypeModel.self)
        }
        if let list = qualityAuditList {
            auditList = (list as NSArray).mapToObjectArray(ZZQualityAuditModel.self)
        }
        if let list = enterpriseTypeList {
            enterpriseList = (list as NSArray).mapToObjectArray(EnterpriseChooseModel.self)
        }
        if let reasonList = refuseReasonList {
            usermanagerAuditDetails = (reasonList as NSArray).mapToObjectArray(ZZRefuseReasonModel.self)
        }
        if let areasonList = allinoneRefuseReasonList {
            retailAuditDetailList = (areasonList as NSArray).mapToObjectArray(ZZAllInOneRefuseReasonModel.self)
        }
        
        var canModifyName = true
        if json["canModifyName"] != JSON.null {
            canModifyName = json["canModifyName"].boolValue
        }
        
        //let canModifyName = json["canModifyName"].boolValue
        let inviteCode = json["inviteCode"].string
        let userName = json["userName"].string
        let isAuditfailedReason = json["isAuditfailedReason"].string

        return ZZModel(drugScopeList: drugScopeList, receiverAddressList: receiverAddressList, enterprise: enterprise, enterpriseRetail: enterpriseRetail, qcList: qcList, qualificationRetailList: qualificationRetailList, deliveryAreaList: deliveryAreaList, listTypeInfo: typeList, qualityAuditList:auditList, enterpriseTypeList: enterpriseList, usermanageAuditStatus: usermanagerAuditDetails, canModifyName: canModifyName, inviteCode: inviteCode, userName: userName, isAuditfailedReason: isAuditfailedReason, retailAuditDetailList: retailAuditDetailList, qualification: qualification, rulesAddressList: rulesAddressList)
    }
    
    // MARK 对证书进行分类
    func filterQCList() -> () {
        let arr1 = NSMutableArray()
        let arr2 = NSMutableArray()
        let arr3 = NSMutableArray()
        let arr21 = NSMutableArray()
        let arr22 = NSMutableArray()
        let arr23 = NSMutableArray()
        let arr24 = NSMutableArray()
        let arr25 = NSMutableArray()
        let arr26 = NSMutableArray()
        let arr27 = NSMutableArray()
        let arr28 = NSMutableArray()
        let arr29 = NSMutableArray()
        let arr30 = NSMutableArray()
        let arr31 = NSMutableArray()
        let arr32 = NSMutableArray()
        let arr33 = NSMutableArray()
        let arr34 = NSMutableArray()
        let arr35 = NSMutableArray()
        
        if self.qcList == nil {
            self.qcList = [ZZFileModel]()
        }
        
        for model : ZZFileModel in self.qcList! {
            switch model.typeId {
            case 1:
                arr1.add(model)
            case 2:
                arr2.add(model)
            case 3:
                arr3.add(model)
            case 21:
                arr21.add(model)
            case 22:
                arr22.add(model)
            case 23:
                arr23.add(model)
            case 24:
                arr24.add(model)
            case 25:
                arr25.add(model)
            case 26:
                arr26.add(model)
            case 27:
                arr27.add(model)
            case 28:
                arr28.add(model)
            case 29:
                arr29.add(model)
            case 30:
                arr30.add(model)
            case 31:
                arr31.add(model)
            case 32:
                arr32.add(model)
            case 33:
                arr33.add(model)
            case 34:
                arr34.add(model)
            case 35:
                arr35.add(model)
            default:
                break
            }
        }
        
        if let arr1FirstObject = arr1.firstObject {
            if let fileModel = arr1FirstObject as? ZZFileModel {
                self.LegalPersonModel = fileModel
            }
        }
        
        if let arr3FirstObject = arr3.firstObject {
            if let fileModel = arr3FirstObject as? ZZFileModel {
                if let bankInfoModel = self.bankInfoModel {
                    bankInfoModel.QCFile = fileModel
                }
            }
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
        case .DeliveryAddress:
            return QCErrorType.addressList.rawValue
        case .SaleSet:
            return QCErrorType.salesDistrict.rawValue
        case .ZZfile:
            if zztype == nil {
                return nil
            }
            return zztype
        default:
            return QCErrorType.baseInfo.rawValue
        }
    }
    
    func refuseReasonForSectionType(_ section: ZZEnterpriseInputType, zztype: Int?) -> String? {
        if enterprise?.isWholesaleRetail == 1  {
            // 批零一体
            let refuseModel = self.retailAuditDetailList?.filter({ (model) -> Bool in
                if let type = reasonTypeForWholeSaleRetailSectionType(section, zztype: zztype) {
                    return model.status == 2 && model.type == type
                }
                return false
            })
            
            if refuseModel?.count > 0 {
                return refuseModel?.first?.failedReason
            }
            return nil
        } else {
            // 非批零一体
            let refuseModel = self.usermanageAuditStatus?.filter({ (model) -> Bool in
                if let type = reasonTypeForSectionType(section, zztype: zztype) {
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
    
    func refuseReasonForSectionCellType(_ section: ZZEnterpriseInputType, zztype: Int?, _ sectionNum: Int?) -> String? {
        if enterprise?.isWholesaleRetail == 1 && sectionNum != 0 {
            // 批零一体
            let refuseModel = self.retailAuditDetailList?.filter({ (model) -> Bool in
                if let type = reasonTypeForWholeSaleRetailSectionType(section, zztype: zztype) {
                    return model.status == 2 && model.type == type
                }
                return false
            })
            
            if refuseModel?.count > 0 {
                return refuseModel?.first?.failedReason
            }
            return nil
        } else {
            // 非批零一体
            let refuseModel = self.usermanageAuditStatus?.filter({ (model) -> Bool in
                if let type = reasonTypeForSectionType(section, zztype: zztype) {
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
    
    func getEnterpriseTypeName() -> String {
        if let enterpriseTypeList = listTypeInfo {
            if let enterpriseType = (enterpriseTypeList as NSArray).filtered(using: NSPredicate(format: "remark == '终端客户'")).first as? EnterpriseOriginTypeModel {
                return enterpriseType.paramName
            }
            else {
                if let enterpriseType = self.listTypeInfo?.first {
                     return enterpriseType.remark
                }
                else {
                    return ""
                }
            }
        }
        else {
            return ""
        }
    }
    
    func getEnterpriseTypeForBaseInfoRegister() -> String {
        if let enterpriseTypeList = listTypeInfo {
            if let enterpriseType = (enterpriseTypeList as NSArray).filtered(using: NSPredicate(format: "remark == '终端客户'")).first as? EnterpriseOriginTypeModel {
                return enterpriseType.paramName
            }
            else {
                if let enterpriseType = self.listTypeInfo?.first {
                    if "生产企业" == enterpriseType.remark {
                        return ""
                    }
                    else {
                        return enterpriseType.remark
                    }
                }
                else {
                    return ""
                }
            }
        }
        else {
            return ""
        }
    }
}
