//
//  RITextViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit


//MARK: - RITextInputType

// 资料管理之输入框类型
enum RITextInputType: Int {
    // 所有类型
    case enterpriseName = 0             // [选择]...企业名称
    case enterpriseType = 1             // [选择]...企业类型
    case enterpriseArea = 2             // [选择]...（企业）所在地区
    case enterpriseAddress = 3          // [输入]...（企业）详细地址
    case enterpriseLegalEntity = 4      // [输入]...（企业）法人
    case enterpriseBankInfo = 5         // [选择]...（企业）银行信息
    case allInOneSelect = 6             // [开关]...是否批零一体
    case enterpriseNameRetail = 7       // [选择]...（零售企业）名称
    case enterpriseAreaRetail = 8       // [选择]...（零售企业）所在地区
    case enterpriseAddressRetail = 9    // [输入]...（零售企业）详细地址
    case storeNumberRetail = 10         // [输入]...（零售企业）门店数
    case drugScope = 11                 // [选择]...经营范围
    case receiveName = 12               // [输入]...（收货人）姓名
    case receivePhone = 13              // [输入]...（收货人）电话
    case receiveArea = 14               // [选择]...（收货人）所在地区
    case receiveAddress = 15            // [输入]...（收货人）详细地址
    case saleAddress = 16               // [输入]...销售单打印地址
    case samePersonSelect = 17          // [开关]...与收货人信息一致
    case buyerName = 18                 // [输入]...（采购员）姓名
    case buyerPhone = 19                // [输入]...（采购员）电话
    case inviteCode = 20                // [输入]...邀请码
    case businessAccount = 21           // [输入]...业务员子账号
    
    // 标题
    var typeName: String {
        switch self {
        case .enterpriseName:
            return "企业名称"
        case .enterpriseType:
            return "企业类型"
        case .enterpriseArea:
            return "注册地区"
        case .enterpriseAddress:
            return "注册详细地址"
        case .enterpriseLegalEntity:
            return "企业法人"
        case .enterpriseBankInfo:
            return "银行信息"
        case .allInOneSelect:
            return "是否批发零售一体"
        case .enterpriseNameRetail:
            return "企业名称"
        case .enterpriseAreaRetail:
            return "注册地区"
        case .enterpriseAddressRetail:
            return "注册详细地址"
        case .storeNumberRetail:
            return "门店数"
        case .drugScope:
            return "经营范围"
        case .receiveName:
            return "收货人"
        case .receivePhone:
            return "手机号或固话"
        case .receiveArea:
            return "收货地区"
        case .receiveAddress:
            return "注册收货地址"
        case .saleAddress:
            return "销售单打印地址"
        case .samePersonSelect:
            return "与收货人信息一致"
        case .buyerName:
            return "采购员"
        case .buyerPhone:
            return "采购员联系方式"
        case .inviteCode:
            return "邀请码"
        case .businessAccount:
            return "业务员子账号"
        }
    }
    
    // 描述
    var typeDescription: String {
        switch self {
        case .enterpriseName:
            return "请填写企业名称"
        case .enterpriseType:
            return "请选择企业类型，提交后不可更改"
        case .enterpriseArea:
            return "请选择注册地址省、市、区信息"
        case .enterpriseAddress:
            return "请与营业执照上的详细地址保持一致"
        case .enterpriseLegalEntity:
            return "请输入企业法人姓名"
        case .enterpriseBankInfo:
            return "请填写企业银行信息"
        case .allInOneSelect:
            return "批发为自营连锁企业连锁"
        case .enterpriseNameRetail:
            return "请填写零售企业名称"
        case .enterpriseAreaRetail:
            return "请选择注册地址省、市、区信息"
        case .enterpriseAddressRetail:
            return "请与营业执照上的详细地址保持一致"
        case .storeNumberRetail:
            return "请填写门店数量"
        case .drugScope:
            return "请选择经营范围"
        case .receiveName:
            return "请填写收货人姓名"
        case .receivePhone:
            return "1开头手机号或0开头固话"
        case .receiveArea:
            return "请选择注册地址省、市、区信息"
        case .receiveAddress:
            return "请填写收货详细地址"
        case .saleAddress:
            return "请填写销售单上的打印地址"
        case .samePersonSelect:
            return "请完善采购人员相关信息，以便卖家及时联系"
        case .buyerName:
            return "请填写采购员姓名"
        case .buyerPhone:
            return "请填写采购员联系方式"
        case .inviteCode:
            return "请填写邀请码"
        case .businessAccount:
            return "请填写业务员子账号"
        }
    }
    
    // 是否必填
    var typeInputMust: Bool {
        switch self {
        case .enterpriseName:
            return true
        case .enterpriseType:
            return true
        case .enterpriseArea:
            return true
        case .enterpriseAddress:
            return true
        case .enterpriseLegalEntity:
            return true
        case .enterpriseBankInfo:
            return true
        case .allInOneSelect:
            return true
        case .enterpriseNameRetail:
            return true
        case .enterpriseAreaRetail:
            return true
        case .enterpriseAddressRetail:
            return true
        case .storeNumberRetail:
            return true
        case .drugScope:
            return true
        case .receiveName:
            return true
        case .receivePhone:
            return true
        case .receiveArea:
            return true
        case .receiveAddress:
            return true
        case .saleAddress:
            return true
        case .samePersonSelect:
            return true
        case .buyerName:
            return true
        case .buyerPhone:
            return true
        case .inviteCode:
            return false
        case .businessAccount:
            return false
        }
    }
    
    // 输入框键盘类型
    var typeKeyboard: UIKeyboardType {
        switch self {
        case .enterpriseName:
            return .default
        case .enterpriseType:
            return .default
        case .enterpriseArea:
            return .default
        case .enterpriseAddress:
            return .default
        case .enterpriseLegalEntity:
            return .default
        case .enterpriseBankInfo:
            return .default
        case .allInOneSelect:
            return .default
        case .enterpriseNameRetail:
            return .default
        case .enterpriseAreaRetail:
            return .default
        case .enterpriseAddressRetail:
            return .default
        case .storeNumberRetail:
            return .numberPad
        case .drugScope:
            return .default
        case .receiveName:
            return .default
        case .receivePhone:
            return .numberPad
        case .receiveArea:
            return .default
        case .receiveAddress:
            return .default
        case .saleAddress:
            return .default
        case .samePersonSelect:
            return .default
        case .buyerName:
            return .default
        case .buyerPhone:
            return .numberPad
        case .inviteCode:
            return .default
        case .businessAccount:
            return .default
        }
    }
    
    // 输入框最大可输入字数
    var typeNumberMax: Int {
        switch self {
        case .enterpriseName:
            return 50
        case .enterpriseType:
            return 20
        case .enterpriseArea:
            return 50
        case .enterpriseAddress:
            return 300 //产品说不限制 但是我默默的限制
        case .enterpriseLegalEntity:
            return 12
        case .enterpriseBankInfo:
            return 20
        case .allInOneSelect:
            return 20
        case .enterpriseNameRetail:
            return 50
        case .enterpriseAreaRetail:
            return 50
        case .enterpriseAddressRetail:
            return 100
        case .storeNumberRetail:
            return 5
        case .drugScope:
            return 800
        case .receiveName:
            return 12
        case .receivePhone:
            return 12
        case .receiveArea:
            return 60
        case .receiveAddress:
            return 100
        case .saleAddress:
            return 120
        case .samePersonSelect:
            return 20
        case .buyerName:
            return 12
        case .buyerPhone:
            return 12
        case .inviteCode:
            return 6
        case .businessAccount:
            return 30
        }
    }
}

let cellHeightInput: CGFloat = WH(46)
let cellHeightSwitch: CGFloat = WH(70)


//MARK: - RITextViewModel

class RITextViewModel: NSObject {
    // MARK: - Property
    
    // closure
    var refreshClosure: emptyClosure?
    
    // 默认当前数据读取于缓存
    var dataFromCacheFlag: Bool = true
    
    // 用户id...<用于按用户维度来缓存数据>
    let userid: String = ( (FKYLoginAPI.loginStatus() == .unlogin) ? "" : FKYLoginAPI.currentUserId() )
    
    /***************************************************/
    // 界面展示数据
    
    // 企业名称
    var enterpriseName: String?
    
    // 企业类型model
    var enterpriseType: EnterpriseTypeModel?
    
    // 企业地区model
    var enterpriseArea: RIAddressModel = {
        let model = RIAddressModel()
        model.receiveFlag = false
        return model
    }()
    
    // 企业详细地址
    var enterpriseAddress: String?
    
    // 企业法人
    var enterpriseLegalEntity: String?
    
    // 银行信息model
    var bankInfo: ZZBankInfoModel?
    
    // 是否为批发企业
    var wholesaleFlag = false
    
    // 若为批发企业，则是否为批零一体
    var allInOneFlag = false
    
    // 零售企业名称
    var enterpriseNameRetail: String?
    
    // 零售企业地区model
    var enterpriseAreaRetail: RIAddressModel = {
        let model = RIAddressModel()
        model.receiveFlag = false
        return model
    }()
    
    // 零售企业详情地址
    var enterpriseAddressRetail: String?
    
    // 零售企业门店数
    var storeNumberRetail: String?
    
    // 经营范围...<只保存用户已勾选的项>
    var drugScopes = [DrugScopeModel]()
    
    // 收货人（姓名）
    var receiveName: String?
    
    // 收货人联系方式
    var receivePhone: String?
    
    // 收货地区
    var receiveArea: RIAddressModel = {
        let model = RIAddressModel()
        model.receiveFlag = true
        return model
    }()
    
    // 收货（详细）地址
    var receiveAddress: String?
    
    // 销售单打印地址
    var saleAddress: String?
    
    // 采购人是否与收货人一致
    var samePersonFlag = false
    
    // 采购员（姓名）
    var buyerName: String?
    
    // 采购员联系方式
    var buyerPhone: String?
    
    // 邀请码
    var inviteCode: String?
    
    // 业务员子账号
    var businessAccount: String?
    // 是否可修改业务员名称
    var canModifyBusinessAccount: Bool = true

    /***************************************************/
    // 业务数据
    
    // 缓存的企业资质信息model
    //var enterpriseInfoCacheObj: ZZModel?
    
    // (资质信息接口返回 or 本地缓存)资质信息model
    var enterpriseInfoModel: ZZModel = ZZModel()
    
    // 通过企业名称获取的企业信息model
    var enterpriseInfoFromErp: ZZEnterpriseInfo?
    
    // 通过零售企业名称获取的企业信息model
    var enterpriseInfoRetailFromErp: ZZEnterpriseInfo?
    
    // 接口返回的所有经营范围列表...<默认都是未勾选的>
    var drugScopesList = [DrugScopeModel]()
    
    // 本地默认固定选中的经营范围
    let defaultSelectedDrugScope = ["生化药品","化学药制剂","中药饮片","中成药","生物制品","抗生素制剂","一类医疗器械","化妆品","日用消毒制品"]
    
    // 用户手动清空所有勾选的经营范围...<默认为flase>
    var drugScopesRemoveAll = false
    
    // 默认非用户操作...<收货人信息一致按钮勾选>
    var userSelectFlag: Bool = false
    
    /***************************************************/
    // tableview本地结构数据
    
    // section标题数组
    var sectionTitleList = ["填写基本信息(必填)",
                            "选择经营范围(必填)",
                            "填写收货信息(必填)",
                            "填写邀请信息(非必填)"]
    
    // tableview结构数组...<section>
    var sectionList: [[RITextInputType]] {
        get {
            // cell数组
            let section0 = [RITextInputType.enterpriseName,
                            RITextInputType.enterpriseType,
                            RITextInputType.enterpriseArea,
                            RITextInputType.enterpriseAddress,
                            RITextInputType.enterpriseLegalEntity,
                            RITextInputType.enterpriseBankInfo,
                            RITextInputType.allInOneSelect,
                            RITextInputType.enterpriseNameRetail,
                            RITextInputType.enterpriseAreaRetail,
                            RITextInputType.enterpriseAddressRetail,
                            RITextInputType.storeNumberRetail]
            let section1 = [RITextInputType.drugScope]
            let section2 = [RITextInputType.receiveName,
                            RITextInputType.receivePhone,
                            RITextInputType.receiveArea,
                            RITextInputType.receiveAddress,
                            RITextInputType.saleAddress,
                            RITextInputType.samePersonSelect,
                            RITextInputType.buyerName,
                            RITextInputType.buyerPhone]
            let section3 = [
                            RITextInputType.businessAccount]
            // section数组
            return [section0, section1, section2, section3]
        }
    }
    
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
}


// MARK: - TableView Data

extension RITextViewModel {
    // 获取各cell的显示状态
    func getCellShowStatus(_ type: RITextInputType) -> Bool {
        switch type {
        case .enterpriseName:
            return true
        case .enterpriseType:
            return true
        case .enterpriseArea:
            return true
        case .enterpriseAddress:
            return true
        case .enterpriseLegalEntity:
            if wholesaleFlag {
                // 批发企业
                return true
            }
            else {
                // 非批发企业
                return false
            }
        case .enterpriseBankInfo:
            if wholesaleFlag {
                // 批发企业
                return true
            }
            else {
                // 非批发企业
                return false
            }
        case .allInOneSelect:
            if wholesaleFlag {
                // 批发企业
                return true
            }
            else {
                // 非批发企业
                return false
            }
        case .enterpriseNameRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return true
            }
            else {
                // 其它
                return false
            }
        case .enterpriseAreaRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return true
            }
            else {
                // 其它
                return false
            }
        case .enterpriseAddressRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return true
            }
            else {
                // 其它
                return false
            }
        case .storeNumberRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return true
            }
            else {
                // 其它
                return false
            }
        case .drugScope:
            return true
        case .receiveName:
            return true
        case .receivePhone:
            return true
        case .receiveArea:
            return true
        case .receiveAddress:
            return true
        case .saleAddress:
            return true
        case .samePersonSelect:
            return true
        case .buyerName:
            return true
        case .buyerPhone:
            return true
        case .inviteCode:
            return true
        case .businessAccount:
            return true
        }
    }
    
    // 获取各cell的高度
    func getCellHeight(_ type: RITextInputType) -> CGFloat {
        switch type {
        case .enterpriseName:
            return cellHeightInput
        case .enterpriseType:
            return cellHeightInput
        case .enterpriseArea:
            return cellHeightInput
        case .enterpriseAddress:
            return cellHeightInput
        case .enterpriseLegalEntity:
            if wholesaleFlag {
                // 批发企业
                return cellHeightInput
            }
            else {
                // 非批发企业
                return CGFloat.leastNormalMagnitude
            }
        case .enterpriseBankInfo:
            if wholesaleFlag {
                // 批发企业
                return cellHeightInput
            }
            else {
                // 非批发企业
                return CGFloat.leastNormalMagnitude
            }
        case .allInOneSelect:
            if wholesaleFlag {
                // 批发企业
                return cellHeightSwitch
            }
            else {
                // 非批发企业
                return CGFloat.leastNormalMagnitude
            }
        case .enterpriseNameRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return cellHeightInput
            }
            else {
                // 其它
                return CGFloat.leastNormalMagnitude
            }
        case .enterpriseAreaRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return cellHeightInput
            }
            else {
                // 其它
                return CGFloat.leastNormalMagnitude
            }
        case .enterpriseAddressRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return cellHeightInput
            }
            else {
                // 其它
                return CGFloat.leastNormalMagnitude
            }
        case .storeNumberRetail:
            if wholesaleFlag, allInOneFlag {
                // 批发企业 & 批零一体
                return cellHeightInput
            }
            else {
                // 其它
                return CGFloat.leastNormalMagnitude
            }
        case .drugScope:
            return cellHeightInput
        case .receiveName:
            return cellHeightInput
        case .receivePhone:
            return cellHeightInput
        case .receiveArea:
            return cellHeightInput
        case .receiveAddress:
            return cellHeightInput
        case .saleAddress:
            return cellHeightInput
        case .samePersonSelect:
            return cellHeightSwitch
        case .buyerName:
            return cellHeightInput
        case .buyerPhone:
            return cellHeightInput
        case .inviteCode:
            return cellHeightInput
        case .businessAccount:
            return cellHeightInput
        }
    }
    
    // 获取各cell的文本内容
    func getCellValue(_ type: RITextInputType) -> String? {
        switch type {
        case .enterpriseName:
            //
            return enterpriseName
        case .enterpriseType:
            //
            return (enterpriseType?.paramName ?? "")
        case .enterpriseArea:
            //
            return enterpriseArea.detailArea
        case .enterpriseAddress:
            //
            return enterpriseAddress
        case .enterpriseLegalEntity:
            //
            return enterpriseLegalEntity
        case .enterpriseBankInfo:
            guard let bank = bankInfo, let name = bank.bankName, name.isEmpty == false else {
                return nil
            }
            return name
        case .allInOneSelect:
            return nil
        case .enterpriseNameRetail:
            //
            return enterpriseNameRetail
        case .enterpriseAreaRetail:
            //
            return enterpriseAreaRetail.detailArea
        case .enterpriseAddressRetail:
            //
            return enterpriseAddressRetail
        case .storeNumberRetail:
            //
            return storeNumberRetail
        case .drugScope:
            //
            guard drugScopes.count > 0 else {
                return nil
            }
            guard enterpriseType != nil else {
                return nil
            }
            var typeName: String = ""
            drugScopes.forEach({ (scope) in
                if typeName == "" {
                    typeName = scope.drugScopeName
                }
                else {
                    typeName = typeName + ", " + scope.drugScopeName
                }
            })
            return typeName
        case .receiveName:
            //
            return receiveName
        case .receivePhone:
            //
            return receivePhone
        case .receiveArea:
            //
            return receiveArea.detailArea
        case .receiveAddress:
            //
            return receiveAddress
        case .saleAddress:
            //
            return saleAddress
        case .samePersonSelect:
            return nil
        case .buyerName:
            //
            //return buyerName
            if samePersonFlag {
                // 与收货人信息一致
                return receiveName
            }
            else {
                // 不一致
                return buyerName
            }
        case .buyerPhone:
            //
            //return buyerPhone
            if samePersonFlag {
                // 与收货人信息一致
                return receivePhone
            }
            else {
                // 不一致
                return buyerPhone
            }
        case .inviteCode:
            //
            return inviteCode
        case .businessAccount:
            //
            return businessAccount
        }
    }
    
    // 保存各cell的文本内容
    func setCellValue(_ type: RITextInputType, _ txt: String?, _ data: Any?) {
        switch type {
        case .enterpriseName:
            //
            enterpriseName = txt
        case .enterpriseType:
            //
            saveEnterpriseTypeModel(data)
        case .enterpriseArea:
            //
            saveEnterpriseAreaModel(data)
        case .enterpriseAddress:
            //
            enterpriseAddress = txt
        case .enterpriseLegalEntity:
            //
            enterpriseLegalEntity = txt
        case .enterpriseBankInfo:
            //
            saveBankInfoModel(data)
        case .allInOneSelect:
            methodEmpty()
        case .enterpriseNameRetail:
            //
            enterpriseNameRetail = txt
        case .enterpriseAreaRetail:
            //
            saveEnterpriseAreaRetailModel(data)
        case .enterpriseAddressRetail:
            //
            enterpriseAddressRetail = txt
        case .storeNumberRetail:
            //
            storeNumberRetail = txt
        case .drugScope:
            saveDrugScope(data)
        case .receiveName:
            //
            receiveName = txt
        case .receivePhone:
            //
            receivePhone = txt
        case .receiveArea:
            //
            saveReceiveAreaModel(data)
        case .receiveAddress:
            //
            receiveAddress = txt
        case .saleAddress:
            //
            saleAddress = txt
        case .samePersonSelect:
            methodEmpty()
        case .buyerName:
            //
            buyerName = txt
        case .buyerPhone:
            //
            buyerPhone = txt
        case .inviteCode:
            //
            inviteCode = txt
        case .businessAccount:
            //
            businessAccount = txt
        }
    }
    
    // 实时更新收货地址相关信息状态
    func updateReceiveInfoStatus(_ type: RITextInputType, _ txt: String?) -> Bool {
        switch type {
        case .enterpriseName:
            return false
        case .enterpriseType:
            return false
        case .enterpriseArea:
            return false
        case .enterpriseAddress:
            return false
        case .enterpriseLegalEntity:
            return false
        case .enterpriseBankInfo:
            return false
        case .allInOneSelect:
            return false
        case .enterpriseNameRetail:
            return false
        case .enterpriseAreaRetail:
            return false
        case .enterpriseAddressRetail:
            return false
        case .storeNumberRetail:
            return false
        case .drugScope:
            return false
        case .receiveName:
            //
            return saveReceiveInfoStatus()
        case .receivePhone:
            //
            return saveReceiveInfoStatus()
        case .receiveArea:
            //
            return  false
        case .receiveAddress:
            //
            return saveSaleAddress()
        case .saleAddress:
            return false
        case .samePersonSelect:
            methodEmpty()
        case .buyerName:
            //
            return saveReceiveInfoStatus()
        case .buyerPhone:
            //
            return saveReceiveInfoStatus()
        case .inviteCode:
            return  false
        case .businessAccount:
            return  false
        }

        return  false
    }
    
    // 获取各开关cell的状态
    func getCellSwitchStatus(_ type: RITextInputType) -> Bool {
        if type == .allInOneSelect {
           return allInOneFlag
        }
        else if type == .samePersonSelect {
            // 需实时判断状态
            let sameFlag = checkSameStatusForReceiveInfo()
            if sameFlag == true {
                // 相同，则强制设置
                samePersonFlag = true
            }
            return samePersonFlag
        }
        
        return false
    }
    
    // 保存各开关cell的状态
    func setCellSwitchStatus(_ type: RITextInputType, _ status: Bool) {
        if type == .allInOneSelect {
            allInOneFlag = status
        }
        else if type == .samePersonSelect {
            samePersonFlag = status
        }
    }
    
    // 实时判断收货地址信息是否一致
    func checkSameStatusForReceiveInfo() -> Bool {
        if let name = receiveName, name.isEmpty == false,
            let phone = receivePhone, phone.isEmpty == false,
            (name == buyerName),
            (phone == buyerPhone) {
            // 一致
            return true
        }
        else {
            // 不一致
            return false
        }
    }
}


// MARK: - Private

extension RITextViewModel {
    // 空方法
    fileprivate func methodEmpty() {
        //
    }
    
    // 保存企业类型model
    fileprivate func saveEnterpriseTypeModel(_ model: Any?) {
        guard let obj = model, obj is EnterpriseTypeModel else {
            return
        }
        enterpriseType = obj as? EnterpriseTypeModel
        
        // 判断是否为批发企业
        if let name = enterpriseType?.paramName, name.isEmpty == false {
            if name == "批发企业" {
                // 批发企业
                wholesaleFlag = true
                allInOneFlag = false
            }
            else {
                // 非批发企业
                wholesaleFlag = false
                allInOneFlag = false
            }
        }
        else {
            // 默认为非批发企业
            wholesaleFlag = false
            // 非批零一体
            allInOneFlag = false
        }
    }
    
    // 保存企业地区model
    fileprivate func saveEnterpriseAreaModel(_ model: Any?) {
        guard let obj = model, obj is RIAddressModel else {
            return
        }
        //enterpriseArea = obj as! RIAddressModel
        enterpriseArea.setValue(obj as! RIAddressModel)
    }
    
    // 保存零售企业地区model
    fileprivate func saveEnterpriseAreaRetailModel(_ model: Any?) {
        guard let obj = model, obj is RIAddressModel else {
            return
        }
        //enterpriseAreaRetail = obj as! RIAddressModel
        enterpriseAreaRetail.setValue(obj as! RIAddressModel)
    }
    
    // 保存收货地区model
    fileprivate func saveReceiveAreaModel(_ model: Any?) {
        guard let obj = model, obj is RIAddressModel else {
            return
        }
        //receiveArea = obj as! RIAddressModel
        receiveArea.setValue(obj as! RIAddressModel)
    }
    
    // 保存银行信息model
    fileprivate func saveBankInfoModel(_ model: Any?) {
        //
    }
    
    // 保存经营范围
    fileprivate func saveDrugScope(_ model: Any?) {
        //
    }
    
    // 更新保存收货地址信息是否一致按钮状态
    fileprivate func saveReceiveInfoStatus() -> Bool {
        // 默认不需刷新
        var needRefresh = false
        // 更新btn状态
        if let name = receiveName, name.isEmpty == false,
            let phone = receivePhone, phone.isEmpty == false,
            (name == buyerName),
            (phone == buyerPhone) {
            // 不为空，且相等
            if samePersonFlag == false {
                // 需刷新
                needRefresh = true
            }
            if !userSelectFlag {
                // 非用户操作
                samePersonFlag = true
            }
        }
        else {
            // 其它
            if samePersonFlag == true {
                // 需刷新
                needRefresh = true
            }
            if !userSelectFlag {
                // 非用户操作
                samePersonFlag = false
            }
        }
        // 返回是否需要刷新
        return needRefresh
    }
    
    // 自动填充仓库地址
    fileprivate func saveSaleAddress() -> Bool {
        // 若已经有了仓库地址，则不自动填充
//        if let saleAddr = saleAddress, saleAddr.isEmpty == false {
//            return false
//        }
        
        // 无详细地址
        guard let receiveAddr = receiveAddress, receiveAddr.isEmpty == false else {
            return false
        }
        
        // 地区
        let area: String = receiveArea.detailArea
        
        // 自动拼装的仓库地址
        var stockAddress = area + receiveAddr
        stockAddress = stockAddress.replacingOccurrences(of: " ", with: "")
        
        // 保存
        saleAddress = stockAddress
        return true
    }
}


// MARK: - Public

extension RITextViewModel {
    // 保存企业地区model
    func saveEnterpriseArea(_ province: RegisterAddressItemModel, _ city: RegisterAddressItemModel, _ district: RegisterAddressItemModel) {
        enterpriseArea.provinceCode = province.code
        enterpriseArea.provinceName = province.name
        enterpriseArea.cityCode = city.code
        enterpriseArea.cityName = city.name
        enterpriseArea.districtCode = district.code
        enterpriseArea.districtName = district.name
    }
    
    // 保存零售企业地区model
    func saveEnterpriseAreaRetail(_ province: RegisterAddressItemModel, _ city: RegisterAddressItemModel, _ district: RegisterAddressItemModel) {
        enterpriseAreaRetail.provinceCode = province.code
        enterpriseAreaRetail.provinceName = province.name
        enterpriseAreaRetail.cityCode = city.code
        enterpriseAreaRetail.cityName = city.name
        enterpriseAreaRetail.districtCode = district.code
        enterpriseAreaRetail.districtName = district.name
    }
    
    // 保存收货地区model...<可能只有三级，而不是四级>
    func saveReceiveArea(_ province: FKYAddressItemModel, _ city: FKYAddressItemModel, _ district: FKYAddressItemModel, _ town: FKYAddressItemModel?) {
        receiveArea.provinceCode = province.code
        receiveArea.provinceName = province.name
        receiveArea.cityCode = city.code
        receiveArea.cityName = city.name
        receiveArea.districtCode = district.code
        receiveArea.districtName = district.name
        receiveArea.avenu_code = town?.code
        receiveArea.avenu_name = town?.name
    }
    
    // 仓库地址自动填充
    func autoSettingSaleAddress() {
        // 保存
        _ = saveSaleAddress()
    }
}


// MARK: - Request

extension RITextViewModel {
    // 请求经营范围
    func requestForDrugScope(_ block: @escaping (Bool)->()) {
        FKYRequestService.sharedInstance()?.requestForDrugScope(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                block(false)
                return
            }
            // 请求成功
            if let list: [FKY.DrugScopeModel] = model as? [DrugScopeModel], list.count > 0 {
                // 有数据
                strongSelf.drugScopesList.removeAll()
                strongSelf.drugScopesList.append(contentsOf: list)
                strongSelf.processDrugScopeData()
                block(true)
            }
            else {
                // 无数据
                block(false)
            }
        })
    }
    
    // 请求资质信息
    func requestForInputTextInfo(_ block: @escaping (Bool)->()) {
        FKYRequestService.sharedInstance()?.requestForEnterpriseDocInfo(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                block(false)
                return
            }
            // 请求成功
            if let obj = model, obj is ZZModel {
                // 有数据...<保存>
                strongSelf.enterpriseInfoModel = obj as! ZZModel
                // 数据处理
                strongSelf.processEnterpriseInfoModelForShow()
                //
                if  strongSelf.businessAccount?.isEmpty == false{
                    strongSelf.canModifyBusinessAccount = false
                }else{
                    strongSelf.canModifyBusinessAccount = true
                }
                // 判断有无资质数据...<若有，则表示用户之前有提交；若无，则表示用户未提交过数据>
                if let obj = strongSelf.enterpriseInfoModel.enterprise,
                    let name = obj.enterpriseName, name.isEmpty == false,
                    let eid = obj.enterpriseId, eid.isEmpty == false,
                    let id = obj.id, id > 0 {
                    // 用户有提交...<不需要读缓存，直接数据处理后显示>
                    strongSelf.dataFromCacheFlag = false
                    print("接口有返回数据，则用户之前有提交~!@")
                }
                else {
                    // 用户未提交...<需继续读缓存>
                    print("接口未返回数据，则用户之前无提交...")
                }
                block(true)
            }
            else {
                // 无数据
                block(false)
            }
        })
    }
    
    // 通过企业名来获取企业信息
    func requestForEnterpriseInfoFromErp(_ name: String, _ type: RITextInputType, _ block: @escaping (Bool)->()) {
        FKYRequestService.sharedInstance()?.requestForEnterpriseInfoFromErp(withParam: ["enterpriseName" : name], completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                block(false)
                return
            }
            // 请求成功
            if let json = response as? NSDictionary, let info = json["businessInformation"] as? NSDictionary {
                // (非空)字典
                let model = info.mapToObject(ZZEnterpriseInfo.self)
                if type == .enterpriseName {
                    // （非）批发企业
                    strongSelf.enterpriseInfoFromErp = model
                    // 保存企业法人
                    if let person = model.businessLicense?.learPerson, person.isEmpty == false {
                        strongSelf.enterpriseLegalEntity = person
                    }
                    // test
                    //strongSelf.enterpriseInfoFromErp?.businessLicense?.registeredAddress = "黑龙江省,七台河市,桃山区,桃北街东北亚财富中心综合楼"
                }
                else if type == .enterpriseNameRetail {
                    // 零售企业
                    strongSelf.enterpriseInfoRetailFromErp = model
                    // test
                    //strongSelf.enterpriseInfoRetailFromErp?.businessLicense?.registeredAddress = "浙江,温州市,龙湾区,光谷软件园E5楼5楼华中药交所"
                }
                block(true)
            }
            else {
                if type == .enterpriseName {
                    strongSelf.enterpriseInfoFromErp = nil
                }
                else if type == .enterpriseNameRetail {
                    strongSelf.enterpriseInfoRetailFromErp = nil
                }
                block(false)
            }
        })
    }
    
    // 提交...<提交成功后需删除缓存数据>
    func requestForSubmit(_ block: @escaping (Bool, String?, Any?)->()) {
        // 入参
        let params = getEnterpriseInfoData()
        FKYRequestService.sharedInstance()?.requestForSubmitEnterpriseTextInfo(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                var msg = "提交失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg, nil)
                return
            }
            // 请求成功
            block(true, nil, nil)
        })
    }
    
    // 通过企业名称关键词来模糊查询企业名称列表
    class func requestForEnterpriseNameFromErp(_ name: String, _ block: @escaping (Bool, String?, Any?)->()) {
        FKYRequestService.sharedInstance()?.requestForEnterpriseNameFromErp(withParam: ["enterpriseName" : name], completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                var msg = "查询失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg, nil)
                return
            }
            // 请求成功
            var list = [String]()
            if let array: [String] = response as? [String] {
                list = array
            }
            block(true, nil, list)
        })
    }
}


// MARK: - Cache

extension RITextViewModel {
    // 获取缓存的企业信息
    func getEnterpriseInfoFromCache(_ block: @escaping (Bool)->()) {
        // read
        ZZModel.getHistoryData(userid) { [weak self] (zzModel) in
            guard let strongSelf = self else {
                return
            }
            print("读取缓存数据完毕")
            if let model: ZZModel = zzModel {
                // 有本地缓存的数据...<直接显示>
                strongSelf.enterpriseInfoModel = model
                strongSelf.processEnterpriseInfoModelForShow()
                block(true)
            }
            else {
                // 无本地缓存的数据
                block(false)
            }
        }
    }
    
    // 保存缓存的企业信息
    func saveEnterpriseInfoForCache() {
        // 保存用户更新的数据
        saveDataToEnterpriseInfoModel()
        // write
        enterpriseInfoModel.saveHistoryData(userid)
        print("保存缓存数据完毕")
    }
    
    // 删除保存的企业信息...<一定是提交成功后的操作>
    func deleteEnterpriseInfoInCache() {
        // delete
        ZZModel.removeHistoryData(userid)
        print("删除缓存数据完毕")
        // 更新状态
        dataFromCacheFlag = false
    }
}


// MARK: - 数据处理

extension RITextViewModel {
    // 处理经营范围数据
    func processDrugScopeData() {
        guard drugScopesList.count > 0 else {
            return
        }
        
        // 更新是否选中的经营范围...<接口返回的原始数组>
        if drugScopes.count > 0 {
            // 有勾选的项
            drugScopesList.forEach { (item) in
                let list = drugScopes.filter({ (model) -> Bool in
                    return model.drugScopeId == item.drugScopeId
                })
                // 更新选中状态
                if list.count > 0 {
                    item.selected = true
                }
                else {
                    item.selected = false
                }
            } // for
        }
        else {
            // 无勾选的项
            guard drugScopesRemoveAll == false else {
                // 用户手动清空所有勾选项
                drugScopesList.forEach { (item) in
                    item.selected = false
                } // for
                return
            }
            
            // 非用户手动清空...<第一次进>
            let searchPredicate = NSPredicate(format: "self.drugScopeName IN %@", defaultSelectedDrugScope)
            if let selectedScopeArray = (drugScopesList as NSArray).filtered(using: searchPredicate) as? [DrugScopeModel] {
                drugScopes = selectedScopeArray
                // 全部选中
                drugScopes.forEach({ (obj) in
                    obj.selected = true
                }) // for

                drugScopesList.forEach { (item) in
                    let list = drugScopes.filter({ (model) -> Bool in
                        return model.drugScopeId == item.drugScopeId
                    })
                    // 更新选中状态
                    if list.count > 0 {
                        item.selected = true
                    }
                    else {
                        item.selected = false
                    }
                } // for
            }
        }
    }
    
    // 缓存用户已更新的信息到总的企业资质model中...<界面展示内容转接口model>
    fileprivate func saveDataToEnterpriseInfoModel() {
        // 企业信息models
        var model: ZZBaseInfoModel = ZZBaseInfoModel.init()
        if let obj = enterpriseInfoModel.enterprise {
            model = obj
        }
        
        // 企业名称
        model.enterpriseName = enterpriseName
        
        // 企业详细地址
        model.registeredAddress = enterpriseAddress
        
        // 企业地区
        model.provinceName = enterpriseArea.provinceName
        model.province = enterpriseArea.provinceCode
        model.cityName = enterpriseArea.cityName
        model.city = enterpriseArea.cityCode
        model.districtName = enterpriseArea.districtName
        model.district = enterpriseArea.districtCode
        
        // 银行信息
        if let bankModel = bankInfo {
            model.bankName = bankModel.bankName
            model.bankCode = bankModel.bankCode
            model.accountName = bankModel.accountName
            if let obj = bankModel.QCFile {
                // 银行信息类型id固定为3
                obj.typeId = 3
                // 保有
                if let list = enterpriseInfoModel.qualification, list.count > 0 {
                    var arrayTemp = Array.init(list)
                    arrayTemp[0] = obj
                    enterpriseInfoModel.qualification = arrayTemp
                }
                else {
                    enterpriseInfoModel.qualification = [obj]
                }
            }
        }
        
        // 企业法人
        model.legalPersonname = enterpriseLegalEntity
        
        // 是否为批发企业...<1 or 3>
        if wholesaleFlag {
            // 批发企业
            model.roleType = 3
        }
        else {
            // 非批发企业
            model.roleType = 1
        }
        
        // 是否批零一体...<前提为批发企业>
        if allInOneFlag {
            // 批零一体
            model.isWholesaleRetail = 1
        }
        else {
            // 非批零一体
            model.isWholesaleRetail = 0
        }
        
        // 赋值
        enterpriseInfoModel.enterprise = model
        
        /************************************/

        // 企业类型
        if let obj = enterpriseType {
            let pCode = obj.paramCode
            let pName = obj.paramName
            let pValue = obj.paramValue
            
            if let list = enterpriseInfoModel.listTypeInfo, list.count > 0 {
                // 有企业类型数组
                let type: EnterpriseOriginTypeModel = list[0]
                let obj = EnterpriseOriginTypeModel.init(typeId: type.typeId, paramCode: pCode, paramName: pName, paramValue: pValue, remark: type.remark, createUser: type.createUser, createTime: type.createTime, updateTime: type.updateTime, updateUser: type.updateUser)
                var arrTemp = Array.init(list)
                arrTemp[0] = obj
                enterpriseInfoModel.listTypeInfo = arrTemp
            }
            else {
                // 无企业类型数组
                let obj = EnterpriseOriginTypeModel.init(typeId: "", paramCode: pCode, paramName: pName, paramValue: pValue, remark: "", createUser: "", createTime: "", updateTime: "", updateUser: "")
                enterpriseInfoModel.listTypeInfo = [obj]
            }
        }
        
        /************************************/
        
        // 零售企业信息
        var modelRetail: ZZAllInOneBaseInfoModel = ZZAllInOneBaseInfoModel.init()
        if let obj = enterpriseInfoModel.enterpriseRetail {
            modelRetail = obj
        }
        
        // 企业名称
        modelRetail.enterpriseName = enterpriseNameRetail
        
        // 企业详细地址
        modelRetail.registeredAddress = enterpriseAddressRetail
        
        // 企业地区
        modelRetail.provinceName = enterpriseAreaRetail.provinceName
        modelRetail.province = enterpriseAreaRetail.provinceCode
        modelRetail.cityName = enterpriseAreaRetail.cityName
        modelRetail.city = enterpriseAreaRetail.cityCode
        modelRetail.districtName = enterpriseAreaRetail.districtName
        modelRetail.district = enterpriseAreaRetail.districtCode
        
        // 门店数
        if let number = storeNumberRetail, number.isEmpty == false {
            modelRetail.shopNum = Int(number)
        }
        
        // 赋值
        enterpriseInfoModel.enterpriseRetail = modelRetail
        
        /************************************/
        
        // 经营范围
        enterpriseInfoModel.drugScopeList = drugScopes
        
        /************************************/
        
        // 收货信息
        var modelAddress = ZZReceiveAddressModel.init()
        if let list = enterpriseInfoModel.address, list.count > 0 {
            modelAddress = list[0]
        }
        
        // 收货人姓名
        modelAddress.receiverName = receiveName
        // 收货人联系方法
        modelAddress.contactPhone = receivePhone
        
        // 收货地区
        modelAddress.address = receiveArea.address
        modelAddress.provinceName = receiveArea.provinceName
        modelAddress.provinceCode = receiveArea.provinceCode
        modelAddress.cityName = receiveArea.cityName
        modelAddress.cityCode = receiveArea.cityCode
        modelAddress.districtName = receiveArea.districtName
        modelAddress.districtCode = receiveArea.districtCode
        modelAddress.avenu_name = receiveArea.avenu_name
        modelAddress.avenu_code = receiveArea.avenu_code
        
        // 收货（详细）地址
        modelAddress.address = receiveAddress
        
        // 销售单打印地址
        modelAddress.print_address = saleAddress
        
        // 采购员（姓名）
        modelAddress.purchaser = buyerName
        
        // 采购员联系方式
        modelAddress.purchaser_phone = buyerPhone
        
        // 赋值
        if let list = enterpriseInfoModel.address, list.count > 0 {
            var arrayTemp = Array.init(list)
            arrayTemp[0] = modelAddress
            enterpriseInfoModel.address = arrayTemp
        }
        else {
            enterpriseInfoModel.address = [modelAddress]
        }
        
        /************************************/
        
        // 邀请码
        enterpriseInfoModel.inviteCode = inviteCode
        
        // 业务员子账号
        enterpriseInfoModel.userName = businessAccount
    }
    
    // 处理企业资质信息数据...<接口model转界面展示内容>
    fileprivate func processEnterpriseInfoModelForShow() {
        // 企业信息
        if let model = enterpriseInfoModel.enterprise {
            // 企业名称
            enterpriseName = model.enterpriseName
            
            // 企业详细地址
            enterpriseAddress = model.registeredAddress
            
            // 企业地区
            enterpriseArea.address = model.registeredAddress
            enterpriseArea.provinceName = model.provinceName
            enterpriseArea.provinceCode = model.province
            enterpriseArea.cityName = model.cityName
            enterpriseArea.cityCode = model.city
            enterpriseArea.districtName = model.districtName
            enterpriseArea.districtCode = model.district
            enterpriseArea.receiveFlag = false
            
            // 银行信息 bankInfo
            let bankModel = ZZBankInfoModel.init()
            bankModel.bankName = model.bankName
            bankModel.bankCode = model.bankCode
            bankModel.accountName = model.accountName
            if let list = enterpriseInfoModel.qualification, list.count > 0 {
                // 通常第1个为银行信息model
                //bankModel.QCFile = list[0]
                for item: ZZFileModel in list {
                    if item.typeId == 3 {
                        // 银行信息
                        bankModel.QCFile = item
                        break
                    }
                } // for
            }
            bankInfo = bankModel
            
            // 企业法人
            enterpriseLegalEntity = model.legalPersonname
            
            // 是否为批发企业
            if let type = model.roleType, type == 3 {
                // 批发企业
                wholesaleFlag = true
            }
            else {
                // 非批发企业
                wholesaleFlag = false
            }
            
            // 是否批零一体...<前提为批发企业>
            if let value = model.isWholesaleRetail, value == 1 {
                allInOneFlag = true
            }
            else {
                allInOneFlag = false
            }
        }
        
        // 企业类型
//        processEnterpriseType()
//        if enterpriseType == nil {
//            if let list = enterpriseInfoModel.listTypeInfo, list.count > 0 {
//                let type: EnterpriseOriginTypeModel = list[0]
//                let eType = EnterpriseTypeModel.init(paramCode: type.paramCode, paramName: type.paramName, paramValue: type.paramValue)
//                enterpriseType = eType
//            }
//        }
        if let list = enterpriseInfoModel.listTypeInfo, list.count > 0 {
            let type: EnterpriseOriginTypeModel = list[0]
            let eType = EnterpriseTypeModel.init(paramCode: type.paramCode, paramName: type.paramName, paramValue: type.paramValue)
            enterpriseType = eType
        }
        
        // 零售企业信息
        if let model = enterpriseInfoModel.enterpriseRetail {
            // 企业名称
            enterpriseNameRetail = model.enterpriseName
            
            // 企业详细地址
            enterpriseAddressRetail = model.registeredAddress
            
            // 企业地区
            enterpriseAreaRetail.address = model.registeredAddress
            enterpriseAreaRetail.provinceName = model.provinceName
            enterpriseAreaRetail.provinceCode = model.province
            enterpriseAreaRetail.cityName = model.cityName
            enterpriseAreaRetail.cityCode = model.city
            enterpriseAreaRetail.districtName = model.districtName
            enterpriseAreaRetail.districtCode = model.district
            enterpriseAreaRetail.receiveFlag = false
            
            // 门店数
            if let value = model.shopNum, value > 0 {
                storeNumberRetail = "\(value)"
            }
            else {
                storeNumberRetail = nil
            }
        }
        
        // 经营范围
        drugScopes.removeAll()
        if let list = enterpriseInfoModel.drugScopeList, list.count > 0 {
            // 有值
            drugScopes.append(contentsOf: list)
        }
        
        // 收货信息
        if let list = enterpriseInfoModel.address, list.count > 0 {
            // 地址model
            let model = list[0]
            
            // 收货人姓名
            receiveName = model.receiverName
            // 收货人联系方法
            receivePhone = model.contactPhone
            
            // 收货地区
            receiveArea.address = model.address
            receiveArea.provinceName = model.provinceName
            receiveArea.provinceCode = model.provinceCode
            receiveArea.cityName = model.cityName
            receiveArea.cityCode = model.cityCode
            receiveArea.districtName = model.districtName
            receiveArea.districtCode = model.districtCode
            receiveArea.avenu_name = model.avenu_name
            receiveArea.avenu_code = model.avenu_code
            receiveArea.receiveFlag = true
            
            // 收货（详细）地址
            receiveAddress = model.address
            
            // 销售单打印地址
            saleAddress = model.print_address
            
            // 采购人是否与收货人一致
            //samePersonFlag = false
            
            // 采购员（姓名）
            buyerName = model.purchaser
            
            // 采购员联系方式
            buyerPhone = model.purchaser_phone
        }
        
        // 邀请码
        inviteCode = enterpriseInfoModel.inviteCode
        
        // 业务员子账号
        businessAccount = enterpriseInfoModel.userName
    }
    
    // 从返回数据中来判断企业类型...<App端只有1和3两种大的企业类型>...<未使用>
    fileprivate func processEnterpriseType() {
        // 企业类型
        var enterpriseRoleType = 0
        if let roleType = enterpriseInfoModel.enterprise?.roleType {
            enterpriseRoleType = roleType
        }
        else {
            if let enterpriseTypeList = enterpriseInfoModel.listTypeInfo, enterpriseTypeList.count > 0 {
                if let _ = (enterpriseTypeList as NSArray).filtered(using: NSPredicate(format: "remark == '终端客户'")).first as? EnterpriseOriginTypeModel {
                    enterpriseRoleType = 1 //
                }
                else {
                    if let enterpriseType: EnterpriseOriginTypeModel = enterpriseTypeList.first {
                        if "批发企业" == enterpriseType.remark {
                            enterpriseRoleType = 3
                        }
                    }
                }
            }
        }
        
        switch enterpriseRoleType {
        case 1:// 1: 终端
            wholesaleFlag = false
            allInOneFlag = false
            if let model = enterpriseInfoModel.enterprise {
                model.roleType = 1
            }
            if let list = enterpriseInfoModel.listTypeInfo, list.count > 0 {
                let typeModel: EnterpriseOriginTypeModel = list[0]
                // 保存企业类型model
                enterpriseType = EnterpriseTypeModel(paramCode: typeModel.paramCode, paramName: typeModel.paramName, paramValue: typeModel.paramValue)
            }
        case 2:// 2: 生产
            break
        case 3://3: 批发
            wholesaleFlag = true
            allInOneFlag = false
            if let model = enterpriseInfoModel.enterprise {
                model.roleType = 3
                // 是否批零一体...<前提为批发企业>
                if let value = model.isWholesaleRetail, value == 1 {
                    allInOneFlag = true
                }
                else {
                    allInOneFlag = false
                }
            }
            if let list = enterpriseInfoModel.listTypeInfo, let type = list.first {
                // 批发企业固定的类型id
                var paramValue = "11;12;13;14"
                if let valueArray = (list as NSArray).value(forKeyPath: "paramValue") as? [String] {
                    paramValue = (valueArray as NSArray).componentsJoined(by: ";")
                }
                // 保存企业类型model
                enterpriseType = EnterpriseTypeModel(paramCode: type.paramCode, paramName: type.paramName, paramValue: paramValue)
            }
            break
        default:
            print("enterpriseRoleType exception")
            break
        }
    }
}


// MARK: - 封装入参

extension RITextViewModel {
    // 参数合法性检测
    func checkSubmitStatus() -> (Bool, String?) {
        // 非空判断函数
        func isValid(_ content: String?) -> (Bool, String?) {
            // 为空
            guard let txt = content, txt.isEmpty == false else {
                return (false, nil)
            }
            // 去空格和换行
            let result = (txt as NSString).trimmingWhitespaceAndNewlines()
            guard let res = result, res.isEmpty == false else {
                return (false, nil)
            }
            return (true, res)
        }
        
        // 0.企业名称
        var result: (Bool, String?) = isValid(enterpriseName)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入企业名称")
        }
        // 字数限制
//        guard let txt: String = result.1, txt.count <= RITextInputType.enterpriseName.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        // 1.企业类型
        guard let type = enterpriseType else {
            return (false , "请选择企业类型")
        }
        guard type.isValid() else {
            return (false , "请选择企业类型")
        }
        
        // 2.企业所在地区
        guard enterpriseArea.isValidForEnterpriseArea() else {
            return (false , "请选择企业所在地区")
        }
        
        // 3.企业详细地址
        result = isValid(enterpriseAddress)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入企业详细地址")
        }
        // 字数限制
//        guard let txtA: String = result.1, txtA.count <= RITextInputType.enterpriseAddress.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        // 4.经营范围
        guard drugScopes.count > 0 else {
            return (false , "请选择经营范围")
        }
        
        if wholesaleFlag {
            // 批发企业
            
            // 5.企业法人
            result = isValid(enterpriseLegalEntity)
            // 非空判断
            guard result.0 == true else {
                return (false , "请输入企业法人")
            }
            // 字数限制
//            guard let txtB: String = result.1, txtB.count <= RITextInputType.enterpriseLegalEntity.typeNumberMax else {
//                return (false , "超过字数限制")
//            }
            
            // 6.银行信息
            guard let model = bankInfo else {
                return (false, "请填写银行信息")
            }
            guard model.isValid() else {
                return (false, "银行信息不能为空")
            }
            
            if allInOneFlag {
                // 批零一体
                
                // 7.零售企业名称
                result = isValid(enterpriseNameRetail)
                // 非空判断
                guard result.0 == true else {
                    return (false , "请输入零售企业名称")
                }
                // 字数限制
//                guard let txtC: String = result.1, txtC.count <= RITextInputType.enterpriseNameRetail.typeNumberMax else {
//                    return (false , "超过字数限制")
//                }
                
                // 8.零售企业所在地区
                guard enterpriseAreaRetail.isValidForEnterpriseArea() else {
                    return (false , "请选择零售企业所在地区")
                }
                
                // 9.零售企业详细地址
                result = isValid(enterpriseAddressRetail)
                // 非空判断
                guard result.0 == true else {
                    return (false , "请输入零售企业详细地址")
                }
                // 字数限制
//                guard let txtD: String = result.1, txtD.count <= RITextInputType.enterpriseAddressRetail.typeNumberMax else {
//                    return (false , "超过字数限制")
//                }
                
                // 10.零售企业门店数
                result = isValid(storeNumberRetail)
                // 非空判断
                guard result.0 == true else {
                    return (false , "请输入零售企业门店数")
                }
                // 字数限制
//                guard let txtE: String = result.1, txtE.count <= RITextInputType.storeNumberRetail.typeNumberMax else {
//                    return (false , "超过字数限制")
//                }
            }
        }
        
        // 11. 收货人姓名
        result = isValid(receiveName)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入收货人姓名")
        }
        // 字数限制
//        guard let txtF: String = result.1, txtF.count <= RITextInputType.receiveName.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        // 12.收货人电话
        result = isValid(receivePhone)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入收货人联系方式")
        }
        // 字数限制
//        guard let txtG: String = result.1, txtG.count <= RITextInputType.receivePhone.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        // 13.收货地区
        guard receiveArea.isValidForReceiveArea() else {
            return (false , "请选择收货地区")
        }
        
        // 14.收货详细地址
        result = isValid(receiveAddress)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入收货详细地址")
        }
        // 字数限制
//        guard let txtH: String = result.1, txtH.count <= RITextInputType.receiveAddress.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        // 15.销售单打印地址
        result = isValid(saleAddress)
        // 非空判断
        guard result.0 == true else {
            return (false , "请输入销售单打印地址")
        }
        // 字数限制
//        guard let txtI: String = result.1, txtI.count <= RITextInputType.saleAddress.typeNumberMax else {
//            return (false , "超过字数限制")
//        }
        
        if samePersonFlag == false {
            // 与收货人信息不一致
            
            // 16.采购员（姓名）
            result = isValid(buyerName)
            // 非空判断
            guard result.0 == true else {
                return (false , "请输入采购员姓名")
            }
            // 字数限制
//            guard let txtJ: String = result.1, txtJ.count <= RITextInputType.buyerName.typeNumberMax else {
//                return (false , "超过字数限制")
//            }
            
            // 17.采购员联系方式
            result = isValid(buyerPhone)
            // 非空判断
            guard result.0 == true else {
                return (false , "请输入采购员联系方式")
            }
            // 字数限制
//            guard let txtK: String = result.1, txtK.count <= RITextInputType.buyerPhone.typeNumberMax else {
//                return (false , "超过字数限制")
//            }
        }
        else {
            // 与收货人信息一致...<pass>
        }
        
        // 邀请码
        //var inviteCode: String?
        
        // 业务员子账号
        //var businessAccount: String?
        
        return (true, nil)
    }
    
    // 封装入参...<提交企业资质之文本内容>
    func getEnterpriseInfoData() -> [String: AnyObject] {
        // 各个分散的显示数据保存到最终的model中
        saveDataToEnterpriseInfoModel()
        
        // enterprise + enterpriseRetail + checkedList + typeData + deliveryAreas + inviteCode + userName + usermanageReceiverAddressDft
        var parms: [String: AnyObject] = [String: AnyObject]()
        
        // 0. 企业信息...<enterprise>
        if let model = enterpriseInfoModel.enterprise {
            // 非批发企业，起批价置空
            if model.roleType == 1 {
                model.orderSAmount = ""
            }
            // 首次填写基本资料，isCheck字段按接口要求写死为12
            model.isCheck = 12
            // 企业信息
            let enterpriseDic = model.reverseJSONFirst()
            
            // 企业id
            let typeId = getEnterpriseTypeId()
            // 企业类型数据
            let typeData: [String: Any] = ["attachment": [], "typeId": typeId]
            
            if let id = model.id, id > 0, let eid = model.enterpriseId, eid.isEmpty == false {
                print("更新资质文本信息：id=\(id)，eid=\(eid)")
            }
            else {
                print("提交资质文本信息")
            }
            
            parms["enterprise"] = enterpriseDic as AnyObject
            parms["typeData"] = typeData as AnyObject
        }
        else {
            parms["enterprise"] = "" as AnyObject
            parms["typeData"] = "" as AnyObject
        }
        
        // 1. 零售企业信息...<enterpriseRetail>
        if wholesaleFlag == true, allInOneFlag == true, let model = enterpriseInfoModel.enterpriseRetail {
            // 批发企业，且为批零一体
            let enterpriseDic = model.reverseJSON()
            parms["enterpriseRetail"] = enterpriseDic as AnyObject
        }
        
        // 2. 经营范围...<checkedList>
        if let list = enterpriseInfoModel.drugScopeList {
            let array = (list as NSArray).reverseToJSON()
            parms["checkedList"] = array as AnyObject
        }
        
        // 3. 银行信息...<typeData>
        if let bank = bankInfo {
            var picAddress = "" // 银行开户许可证图片地址
            if let pInfo = bank.QCFile?.filePath, pInfo.isEmpty == false {
                // 去前缀 eg: "url": "/fky/img/test/1480576682185.jpg"
                picAddress = (pInfo as NSString).replacingOccurrences(of: "http://p8.maiyaole.com", with: "")
                picAddress = picAddress.replacingOccurrences(of: "https://p8.maiyaole.com", with: "")
            }
            if (picAddress as NSString).length > 0 {
                // 不为空
                let attachMent: [String: AnyObject] = ["typeId": "3" as AnyObject,
                                                       "fileId": "iPhoneUpload" as AnyObject,
                                                       "fileName": "iPhoneFile.jpg" as AnyObject,
                                                       "url": picAddress as AnyObject]
                // 文件model数组
                let attachArr: [[String: AnyObject]] = [attachMent]
                // 企业类型id
                let typeId = getEnterpriseTypeId()
                // 最终data
                let typeData: [String: AnyObject] = ["attachment": attachArr as AnyObject,
                                                    "typeId": typeId as AnyObject]
                parms["typeData"] = typeData as AnyObject
            }
        }
        
        // 4. 销售设置...<deliveryAreas>...<不再需要>
//        if let list = enterpriseInfoModel.deliveryAreaList, list.count > 0 {
//            parms["deliveryAreas"] = (list as NSArray).reverseToJSON() as AnyObject
//        }
//        parms["deliveryAreas"] = [] as AnyObject

        // 5. 收货信息...<usermanageReceiverAddressDft>
        if let list = enterpriseInfoModel.address, list.count > 0 {
            let model: ZZReceiveAddressModel = list[0]
            let obj: ZZReceiveAddressModel = model.getNewModel()
            if samePersonFlag {
                // 收货人信息一致
                obj.purchaser = "\(model.receiverName ?? "")"
                obj.purchaser_phone = "\(model.contactPhone ?? "")"
            }
            parms["usermanageReceiverAddressDft"] = obj.reverseJSON() as AnyObject
        }
        
        // 6. 邀请码和业务员子账号
        if let code = enterpriseInfoModel.inviteCode {
            parms["inviteCode"] = code as AnyObject
        }
        if let name = enterpriseInfoModel.userName {
            parms["userName"] = name as AnyObject
        }
        
        return parms
    }
    
    // 获取当前企业类型id
    fileprivate func getEnterpriseTypeId() -> String {
        var typeId = ""
        if let list = enterpriseInfoModel.listTypeInfo, list.count > 0 {
            let typeArray = list.map({ (obj) -> String in
                return obj.getParamValueForAPI()
            })
            // 企业ID
            typeId = (typeArray as NSArray).componentsJoined(by: ",")
        }
        if let eType = enterpriseType {
            typeId = eType.getParamValueForAPI()
        }
        return typeId
    }
}


/*
用户未提交时接口返回空数据
{
    "data": {
        "canModifyName": true,
        "drugScopeList": [],
        "enterprise": null,
        "qualificationRetailList": [],
        "qcList": [],
        "deliveryAreaList": []
    },
    "rtn_code": "0",
    "rtn_ext": "",
    "rtn_ftype": "0",
    "rtn_msg": "",
    "rtn_tip": ""
}
*/


/*
提交成功返回数据:
{
    "data": {
        "createTime": "2019-08-19 15:53:13",
        "contactPhone": "18507103285",
        "purchaser": "夏末",
        "updateTime": "2019-08-19 15:53:13",
        "avenu_name": "粮道街",
        "purchaser_phone": "18507103285",
        "print_address": "湖北武汉市武昌区粮道街体育总局副主任科员汇新能源有限公司总经理办公室主任助理研究员",
        "provinceCode": "18",
        "cityName": "武汉市",
        "cityCode": "205",
        "enterpriseId": "144751",
        "provinceName": "湖北",
        "id": 180733,
        "createUser": "144751",
        "districtName": "武昌区",
        "districtCode": "2030",
        "avenu_code": "420106005000",
        "address": "体育总局副主任科员汇新能源有限公司总经理办公室主任助理研究员",
        "defaultAddress": 0,
        "receiverName": "夏末",
        "updateUser": "144751"
    },
    "rtn_code": "0",
    "rtn_ext": "",
    "rtn_ftype": "0",
    "rtn_msg": "",
    "rtn_tip": ""
}
*/
