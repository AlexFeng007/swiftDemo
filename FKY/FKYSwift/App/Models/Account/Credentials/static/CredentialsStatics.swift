//
//  CredentialsStatics.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/2.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

// 资质证书类型枚举
enum QCType: Int {
    case legalPerson = 1                    // 企业法人委托证书
    case headLogo = 2                       // 头像
    case bankAccount = 3                    // 银行开户许可证
    case orgCode = 21                       // 组织机构代码证
    case taxRegister = 22                   // 税务登记证
    case businessLicense = 23               // 营业执照
    case societyCreditCode = 24             // 统一社会信用代码
    case medicalInstitution = 25            // 医疗机构执业许可证（盈利性）
    case drugBusinessSTD = 26               // 药品经营质量管理规范（GSP证书）
    case drugTrading = 27                   // 药品经营许可证
    case drugProduceLic = 28                // 药品生产许可证
    case drugProduceSTD = 29                // 药品生产质量管理规范（GMP）
    case instrumentsProduceLic = 30         // 医疗器械生产许可证
    case foodProduceLic = 31                // 保健食品生产（卫生）许可证
    case instrumentsBusinessLic = 32        // （一类 二类）医疗器械经营许可证
    case threeInstrumentsBusinessLic = 38   // （三类）医疗器械经营许可证
    case foodCirculatesLic = 33             // 食品流通许可证
    case medicalInstitutionNonProfit = 34   // 医疗机构执业许可证（非盈利性）
    case otherType = 35                     // 企业其他资质...<多图>
    case allinoneType = 36                  // 批发零售证明文件
    case allinoneOtherType = 37             // 批发零售企业其他资质...<多图>
    case creatBillMaterial = 41             // 发票开票资料
    case buyerIdentityFront = 42            // 采购员身份证正面
    case buyPowerLicense = 44               // 采购委托书
    case qualityGuaranteeDeal = 45          // 质保协议
    
    // 35、37 两种类型特殊，可上传多图
    
    var valueDes: Int {
        return self.rawValue
    }
    
    var maxCount: Int {
        switch self {
        case .qualityGuaranteeDeal:
            fallthrough
        case .bankAccount:
            fallthrough
        case .orgCode:
            fallthrough
        case .taxRegister:
            fallthrough
        case .businessLicense:
            fallthrough
        case .societyCreditCode:
            fallthrough
        case .medicalInstitution:
            fallthrough
        case .drugBusinessSTD:
            fallthrough
        case .drugTrading:
            fallthrough
        case .drugProduceLic:
            fallthrough
        case .drugProduceSTD:
            fallthrough
        case .instrumentsProduceLic:
            fallthrough
        case .foodProduceLic:
            fallthrough
        case .instrumentsBusinessLic:
            fallthrough
        case .threeInstrumentsBusinessLic:
            fallthrough
        case .foodCirculatesLic:
            fallthrough
        case .allinoneType:
            fallthrough
        case .buyPowerLicense:
            fallthrough
        case .creatBillMaterial:
            fallthrough
        case .buyerIdentityFront:
            fallthrough
        case .medicalInstitutionNonProfit:
            return 1
        case .otherType, .allinoneOtherType:
            return 10
        case .legalPerson:
            fallthrough
        case .headLogo:
            return 0
        }
    }
    
    var description: String {
        switch self {
        case .legalPerson:
            return "企业法人委托证书"
        case .headLogo:
            return "头像"
        case .bankAccount:
            return "银行开户许可证"
        case .orgCode:
            return "组织机构代码证"
        case .taxRegister:
            return "税务登记证"
        case .businessLicense:
            return "营业执照"
        case .societyCreditCode:
            return "统一社会信用代码"
        case .medicalInstitution:
            return "医疗机构执业许可证（盈利性）"
        case .drugBusinessSTD:
            return "药品经营质量管理规范（GSP证书）"
        case .drugTrading:
            return "药品经营许可证"
        case .drugProduceLic:
            return "药品生产许可证"
        case .drugProduceSTD:
            return "药品生产质量管理规范（GMP）"
        case .instrumentsProduceLic:
            return "医疗器械生产许可证"
        case .foodProduceLic:
            return "保健食品生产（卫生）许可证"
        case .instrumentsBusinessLic:
            return "二类医疗器械经营许可证"
        case .threeInstrumentsBusinessLic:
            return "三类医疗器械经营许可证"
        case .foodCirculatesLic:
            return "食品流通许可证"
        case .medicalInstitutionNonProfit:
            return "医疗机构执业许可证（非盈利性）"
        case .buyPowerLicense:
            return "采购委托书"
        case .creatBillMaterial:
            return "发票开票资料"
        case .buyerIdentityFront:
            return "采购员身份证"
        case .otherType, .allinoneOtherType:
            return "企业其他资质"
        case .allinoneType:
            return "批发零售证明文件"
        case .qualityGuaranteeDeal:
            return "质保协议"
        }
    }
}

// 批零一体错误类型枚举
enum QCWholeSaleRetailErrorType: Int {
    case baseInfo = 1                       // 批量一体的基本信息
    case orgCode = 21                       // 组织机构代码证
    case taxRegister = 22                   // 税务登记证
    case businessLicense = 23               // 营业执照
    case societyCreditCode = 24             // 统一社会信用代码
    case prove = 36                         // 批发零售证明文件
    case other = 37                         // 批发零售企业其他资质
    case qualityGuaranteeDeal = 45          // 质保协议
}

// 非批零一体错误类型枚举
enum QCErrorType: Int {
    case baseInfo = 1                       // 基本资料审核
    case bankInfo = 2                       // 企业银行信息
    case drugScope = 3                      // 经营范围
    case addressList = 4                    // 收发货地址
    case salesDistrict = 5                  // 销售设置
    
    case orgCode = 21                       // 组织机构代码证
    case taxRegister = 22                   // 税务登记证
    case businessLicense = 23               // 营业执照
    case societyCreditCode = 24             // 统一社会信用代码
    case medicalInstitution = 25            // 医疗机构执业许可证（盈利性）
    case drugBusinessSTD = 26               // 药品经营质量管理规范（GSP证书）
    case drugTrading = 27                   // 药品经营许可证
    case drugProduceLic = 28                // 药品生产许可证
    case drugProduceSTD = 29                // 药品生产质量管理规范（GMP）
    case instrumentsProduceLic = 30         // 医疗器械生产许可证
    case foodProduceLic = 31                // 保健食品生产（卫生）许可证
    case instrumentsBusinessLic = 32        // 医疗器械经营许可证
    case threeInstrumentsBusinessLic = 38   // 三类医疗器械经营许可证
    case foodCirculatesLic = 33             // 食品流通许可证
    case medicalInstitutionNonProfit = 34   // 医疗机构执业许可证（非盈利性）
    case otherType = 35                     // 企业其他资质
    case creatBillMaterial = 41             // 发票开票资料
    case buyerIdentityFront = 42            // 采购员身份证正面
    case buyPowerLicense = 44               // 采购委托书
    case qualityGuaranteeDeal = 45          // 质保协议
}

enum ZZBaseInfoSectionType: String {
    case EnterpriseName = "企业名称"
    case EnterpriseType = "企业类型"
    case Location = "所在地区"
    case AddressDetail = "详细地址"
    case EnterpriseLegalPerson = "企业法人"
    case AllInOne = "是否批发零售一体"
    case AllInOneName = "企业名称 "
    case AllInOneLocation = "所在地区 "
    case AllInOneAddress = "详细地址 "
    case AllInOneShopNumbers = "门店数"
    case DrugScope = "经营范围"
    case DeliveryAddress = "收货地址"
    case BankInfo = "银行信息"
    case SaleSet = "销售设置"
    case InvitationCode = "邀请码"
    case SalesManPhone = "业务员子账号"
    
    var description: String {
        switch self {
        case .EnterpriseName:
            return "请输入企业名称"
        case .EnterpriseType:
            return "请选择，提交后不可更改"
        case .Location:
            return "请选择"
        case .AddressDetail:
            return "要和营业执照上的详细地址一致"
        case .EnterpriseLegalPerson:
            return "请输入企业法人名字"
        case .DrugScope:
            return "请选择"
        case .DeliveryAddress:
            return ""
        case .BankInfo:
            return "请输入企业银行信息"
        case .SaleSet:
            return "请输入起批价和销售区域"
        case .InvitationCode:
            return "非必填"
        case .AllInOne:
            return "批发为自营连锁企业采购"
        case .AllInOneName:
            return "请输入零售企业名称"
        case .AllInOneLocation:
            return "请选择"
        case .AllInOneAddress:
            return "请填写详细地址"
        case .AllInOneShopNumbers:
            return "请输入门店数"
        case .SalesManPhone:
            return "非必填"
        }
    }
    
    static let allValues = [[EnterpriseName, EnterpriseType, Location, AddressDetail], [DrugScope], [InvitationCode],[SalesManPhone]]
    static let allValuesForPF = [[EnterpriseName, EnterpriseType, Location, AddressDetail], [AllInOne], [EnterpriseLegalPerson,DrugScope, .BankInfo], [InvitationCode],[SalesManPhone]]
    static let allValuesForALLINONE = [[EnterpriseName, EnterpriseType, Location, AddressDetail], [AllInOne, AllInOneName, AllInOneLocation, AllInOneAddress, AllInOneShopNumbers], [EnterpriseLegalPerson,DrugScope, .BankInfo], [InvitationCode],[SalesManPhone]]
}


enum ViewConrollerUseType: Int {
    case forRegister = 0
    case forUpdate = 1
}

enum ZZEnterpriseType: String {
    case ZD = "终端客户"
    case SC = "生产企业"
    case PF = "批发企业"
}

enum ZZEnterpriseBankInputType: String {
    case BankName = "开户银行"
    case BankCode = "银行账号"
    case BankAccountName = "开户名  "
    case BankPic = "开户证明"
    
    var description: String {
        switch self {
        case .BankName:
            return "请填写开户银行，精确到支行"
        case .BankCode:
            return "请填写正确的银行账号"
        case .BankAccountName:
            return "请填写完整开户名称"
        case .BankPic:
            return "请先上传银行开户证明"
        }
    }
}

enum ZZEnterpriseWholeSaleRetailInputType: String {
    case AllInOne = "是否批发零售一体"
    case AllInOneName = "企业名称"
    case AllInOneLocation = "所在地区"
    case AllInOneAddress = "详细地址"
    case AllInOneShopNumbers = "门店数"
}

enum ZZEnterpriseInputType: String {
    case refuseReason = "拒绝原因"
    case BaseInfo = "基本信息"
    case EnterpriseType = "企业类型"
    case EnterpriseName = "企业名称"
    case LegalPerson = "法定代表"
    case EnterpriseLegalPerson = "企业法人"
    case ContectPerson = "联系人"
    case TelePhone = "手机号"
    case AddressDetail = "详细注册地址"
    case LegalImg = "企业法人委托证"
    
    case WholeSaleAndRetailInfo = "批发零售信息"
    case WholeSaleType = "批发企业模式"
    case RetailEnterpriseName = "零售企业名称"
    case RetailLocation = "所在地区 "
    
    case DrugScope = "经营范围"
    case Address = "收发货地址"
    case BankInfo = "企业银行信息"
    case SaleSet = "销售设置"
    case ZZfile = "资质文件"
    case DeliveryAddress = "收货地址"

    // 其他样式控制
    case Location = "所在地区"
    case InvitationCode = "邀请码"
    case SalesManPhone = "业务员子账号"
    case ShopNum = "门店数"
    case BankCode = "银行账号"
    case BasePrice = "订单起售金额"
    case BankPic = "银行开户许可证"
    case BankName = "开户银行"
    case BankAccountName = "开户名  "
    case SalesDistrict = "卖方销售区域"
    case LegalInfo = "企业法人信息"//非接口需要的信息，仅用于显示
    
    //企业基本信息Row Type Contents
    static let basicInformationRowValues = [BaseInfo,EnterpriseType,EnterpriseName,LegalPerson,AddressDetail]
    
    func wholeSaleRetailSubTypes(_ isWholeSale: Bool) -> [ZZEnterpriseInputType] {
        if isWholeSale {
            return [.WholeSaleType, .RetailEnterpriseName, .RetailLocation, .ShopNum]
        } else {
            return [.WholeSaleType]
        }
    }
    
    func subTypes(_ roleType:Int) -> [ZZEnterpriseInputType] {
        switch self {
        case .BaseInfo:
            //批发企业
            if roleType == 3{
                return [.EnterpriseName, .EnterpriseType, .Location, .EnterpriseLegalPerson]
            }
            return [.EnterpriseName, .EnterpriseType, .Location]
        case .DrugScope:
            return [.DrugScope]
        case .DeliveryAddress:
            return [.DeliveryAddress]
        case .BankInfo:
            return [.BankName, .BankCode, .BankAccountName]
        case .SaleSet:
            return [.BasePrice, .SalesDistrict]
        case .ZZfile:
            return [.ZZfile]
        case .LegalInfo:
            return [.LegalInfo]
        default:
            return []
        }
    }
}

struct RefuseReasonStyle {
    let font: UIFont = t31.font
    let color: UIColor = t31.color
    let lineSpacing: CGFloat = WH(12)
    let width: CGFloat = SCREEN_WIDTH - (2 * j1)
    let padding: CGFloat = j1
}

