//
//  ZZUploadHelpFile.swift
//  FKY
//
//  Created by mahui on 2016/12/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

/*

 21 22 23 //  24   35  小类
 public static final int NPMI=1;//非公立医疗机构 25
 public static final int PMI=2;//公立医疗机构 34
 public static final int MD=3;//单体药店 26 27
 public static final int CP=4;//连锁药店 26 27
 public static final int Clinic=5;//诊所 25
 public static final int PPE=6;//药品生产企业 28 29
 public static final int MDME=7;//医疗器械生产企业 30
 public static final int HFPE=8;//保健食品生产企业 31
 public static final int PWE=11;//药品批发企业 26 27
 public static final int MEWE=12;//医疗器械批发企业 32
 public static final int HFWE=13;//保健食品批发企业 33
 public static final int WBE=14;//商贸批发企业
 
 
 case OrgCode = 21                       // 组织机构代码证
 case TaxRegister = 22                   // 税务登记证
 case BusinessLicense = 23               // 营业执照
 case SocietyCreditCode = 24             // 统一社会信用代码
 case MedicalInstitution = 25            // 医疗机构执业许可证（盈利性）
 case DrugBusinessSTD = 26               // 药品经营质量管理规范（GSP证书）
 case DrugTrading = 27                   // 药品经营许可证
 case DrugProduceLic = 28                // 药品生产许可证
 case DrugProduceSTD = 29                // 药品生产质量管理规范（GMP）
 case InstrumentsProduceLic = 30         // 医疗器械生产许可证
 case FoodProduceLic = 31                // 保健食品生产（卫生）许可证
 case InstrumentsBusinessLic = 32        // 医疗器械经营许可证
 case FoodCirculatesLic = 33             // 食品流通许可证
 case MedicalInstitutionNonProfit = 34   // 医疗机构执业许可证（非盈利性）
 case OtherType = 35                     // 企业其他资质
 
 */


import Foundation

class ZZUploadHelpFile: NSObject {
    // MARK: - property
    var dataSource : [QCType] = []
    var sectionData = NSArray()
    var rowData = NSArray()
    
    // MARK: - init
    override init() {
        super.init()
    }
    
    /*
        {
            "data": [{
            "paramValue": "11;12;13;14",
            "paramName": "批发企业"
            }, {
            "paramValue": "1",
            "paramName": "非公立医疗机构"
            }, {
            "paramValue": "2",
            "paramName": "公立医疗机构"
            }, {
            "paramValue": "3",
            "paramName": "单体药店"
            }, {
            "paramValue": "4",
            "paramName": "连锁总店"
            }, {
            "paramValue": "5",
            "paramName": "个体诊所"
            }, {
            "paramValue": "8",
            "paramName": "连锁门店"
            }],
            "rtn_code": "0",
            "rtn_ext": "",
            "rtn_ftype": "0",
            "rtn_msg": "",
            "rtn_tip": ""
        }
    */
    
    // MARK: - 非批零一体 根据企业类型和是否三证合一来确定要展示哪些资质
    func typeList(_ is3merge1:Bool, typeList:[EnterpriseOriginTypeModel],roleType:Int) -> () {
        //
        let arr1 = [QCType.orgCode, QCType.taxRegister, QCType.businessLicense]
        let arr2 = [QCType.societyCreditCode]
        var dataSource = [QCType]()
        // 三证or合一
        if is3merge1 {
            dataSource += arr2
        }else{
            dataSource += arr1
        }
        
        // 判断是否是生产企业...<默认非生产企业，因为手机端App不返回生产企业>
        var isProductType = false
        
        // 特定资质
        for item:EnterpriseOriginTypeModel in typeList {
            //by 3.6.0 批发企业 (11;12;13;14)子类型合并，
            for typeId in item.getEnterpriseIds() {
                switch typeId {
                case 1: // 非公立医疗机构
                    dataSource.append(QCType.medicalInstitution)
                case 2: // 公立医疗机构
                    dataSource.append(QCType.medicalInstitutionNonProfit)
                case 3: // 单体药店
                    dataSource.append(QCType.drugBusinessSTD)
                    dataSource.append(QCType.drugTrading)
                case 4: // 连锁药店
                    dataSource.append(QCType.drugBusinessSTD)
                    dataSource.append(QCType.drugTrading)
                case 5: // 诊所
                    dataSource.append(QCType.medicalInstitution)
                case 6: // 药品生产企业
                    dataSource.append(QCType.drugProduceLic)
                    dataSource.append(QCType.drugProduceSTD)
                    isProductType = true
                case 7: // 医疗器械生产企业
                    dataSource.append(QCType.instrumentsProduceLic)
                    isProductType = true
                case 8: // 保健食品生产企业 连锁加盟点
                    
                    //roleType 终端是1 生产是2 拿来区分这个typeId 是生产还是 连锁加盟类型的商家
                    if roleType == 1{
                        dataSource.append(QCType.drugBusinessSTD)
                        dataSource.append(QCType.drugTrading)
                    }else if roleType == 2{
                        dataSource.append(QCType.foodProduceLic)
                        isProductType = true
                    }
                  
                case 11: // 药品批发企业
                    dataSource.append(QCType.drugBusinessSTD)
                    dataSource.append(QCType.drugTrading)
                case 12: // 医疗器械批发企业
                    dataSource.append(QCType.instrumentsBusinessLic)
                    dataSource.append(QCType.threeInstrumentsBusinessLic)
                case 13: // 保健食品批发企业
                    dataSource.append(QCType.foodCirculatesLic)
                case 14: // 商贸批发企业
                    break
                case 15://3.5.0 单体药店/连锁药店拆分后，针对“连锁药店”的资质上传做相应的修改
                    dataSource.append(QCType.drugBusinessSTD)
                    dataSource.append(QCType.drugTrading)
                    break
                default:
                    break
                }
            }
        }
        
        // 41: "发票开票资料"42: "采购员身份证正面",44"采购委托书"
        dataSource.append(QCType.creatBillMaterial)
        dataSource.append(QCType.buyerIdentityFront)
        dataSource.append(QCType.buyPowerLicense)
        
        // 质保协议
        //dataSource.append(QCType.qualityGuaranteeDeal)
        
        if !isProductType {
            // 非生产企业
            if !dataSource.contains(QCType.instrumentsBusinessLic) {
                dataSource.append(QCType.instrumentsBusinessLic)
            }
            if !dataSource.contains(QCType.threeInstrumentsBusinessLic) {
                dataSource.append(QCType.threeInstrumentsBusinessLic)
            }
            if !dataSource.contains(QCType.foodCirculatesLic) {
                dataSource.append(QCType.foodCirculatesLic)
            }
        }
        
        // 其它
        dataSource.append(QCType.otherType)
        self.dataSource = dataSource
    }
    
    // MARK: - 批零一体 根据企业类型和是否三证合一来确定要展示哪些资质
    func fetchTypeList(_ viewType: QualiticationViewType, is3merge1: Bool, typeList: [EnterpriseOriginTypeModel],roleType:Int) -> [QCType] {
        // viewType
        // -1 非批零一体
        // 0 批零一体之批发企业
        // 1 批零一体之零售企业
        // 2 批零一体之批零一体
        
        if viewType == .wholeSaleAndRetail {
            // 批发零售证明文件、企业其他资质
            return [QCType.allinoneType, QCType.allinoneOtherType]
        }
        
        // 营业执照、组织代码机构、税务登记
        let threeQualitications = [QCType.orgCode, QCType.taxRegister, QCType.businessLicense]
        // 统一社会信用代码
        let oneQualitication = [QCType.societyCreditCode]
        
        var dataSource = [QCType]()
        // 三证or合一
        if is3merge1 {
            dataSource += oneQualitication
        } else {
            dataSource += threeQualitications
        }
        
        // 判断是否是生产企业...<默认非生产企业，因为手机端App不返回生产企业>
        var isProductType = false
        
        // 特定资质
        for item:EnterpriseOriginTypeModel in typeList {
            //by 3.6.0 批发企业 (11;12;13;14)子类型合并，
            for typeId in item.getEnterpriseIds() {
                switch typeId {
                case 1: // 非公立医疗机构
//                    dataSource.append(QCType.medicalInstitution)
                    if !dataSource.contains(QCType.medicalInstitution) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.medicalInstitution)
                    }
                case 2: // 公立医疗机构
//                    dataSource.append(QCType.medicalInstitutionNonProfit)
                    if !dataSource.contains(QCType.medicalInstitutionNonProfit) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.medicalInstitutionNonProfit)
                    }
                case 3: // 单体药店
//                    dataSource.append(QCType.drugBusinessSTD)
//                    dataSource.append(QCType.drugTrading)
                    if !dataSource.contains(QCType.drugBusinessSTD) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugBusinessSTD)
                    }
                    if !dataSource.contains(QCType.drugTrading) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugTrading)
                    }
                case 4: // 连锁药店
//                    dataSource.append(QCType.drugBusinessSTD)
//                    dataSource.append(QCType.drugTrading)
                    if !dataSource.contains(QCType.drugBusinessSTD) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugBusinessSTD)
                    }
                    if !dataSource.contains(QCType.drugTrading) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugTrading)
                    }
                case 5: // 诊所
//                    dataSource.append(QCType.medicalInstitution)
                    if !dataSource.contains(QCType.medicalInstitution) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.medicalInstitution)
                    }
                case 6: // 药品生产企业
//                    dataSource.append(QCType.drugProduceLic)
//                    dataSource.append(QCType.drugProduceSTD)
                    if !dataSource.contains(QCType.drugProduceLic) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugProduceLic)
                    }
                    if !dataSource.contains(QCType.drugProduceSTD) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugProduceSTD)
                    }
                    isProductType = true
                case 7: // 医疗器械生产企业
//                    dataSource.append(QCType.instrumentsProduceLic)
                    if !dataSource.contains(QCType.instrumentsProduceLic) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.instrumentsProduceLic)
                    }
                    isProductType = true
                case 8: // 保健食品生产企业  连锁加盟店
//                    dataSource.append(QCType.foodProduceLic)
                   
                    //roleType 终端是1 生产是2 拿来区分这个typeId 是生产还是 连锁加盟类型的商家
                    if roleType == 1{
                        if !dataSource.contains(QCType.drugBusinessSTD) {
                            // 不包含则加入...<保证不会重复加入>
                            dataSource.append(QCType.drugBusinessSTD)
                        }
                        if !dataSource.contains(QCType.drugTrading) {
                            // 不包含则加入...<保证不会重复加入>
                            dataSource.append(QCType.drugTrading)
                        }
                    }else if roleType == 2{
                        if !dataSource.contains(QCType.foodProduceLic) {
                            // 不包含则加入...<保证不会重复加入>
                            dataSource.append(QCType.foodProduceLic)
                        }
                        isProductType = true
                    }
                case 11: // 药品批发企业
//                    dataSource.append(QCType.drugBusinessSTD)
//                    dataSource.append(QCType.drugTrading)
                    if !dataSource.contains(QCType.drugBusinessSTD) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugBusinessSTD)
                    }
                    if !dataSource.contains(QCType.drugTrading) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugTrading)
                    }
                case 12: // 医疗器械批发企业（一二三类医疗器械经营）
//                    dataSource.append(QCType.instrumentsBusinessLic)
                    if !dataSource.contains(QCType.instrumentsBusinessLic) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.instrumentsBusinessLic)
                    }
                    if !dataSource.contains(QCType.threeInstrumentsBusinessLic) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.threeInstrumentsBusinessLic)
                    }
                case 13: // 保健食品批发企业
//                    dataSource.append(QCType.foodCirculatesLic)
                    if !dataSource.contains(QCType.foodCirculatesLic) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.foodCirculatesLic)
                    }
                case 14: // 商贸批发企业
                    break
                case 15://3.5.0 单体药店/连锁药店拆分后，针对“连锁药店”的资质上传做相应的修改
//                    dataSource.append(QCType.drugBusinessSTD)
//                    dataSource.append(QCType.drugTrading)
                    if !dataSource.contains(QCType.drugBusinessSTD) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugBusinessSTD)
                    }
                    if !dataSource.contains(QCType.drugTrading) {
                        // 不包含则加入...<保证不会重复加入>
                        dataSource.append(QCType.drugTrading)
                    }
                    break
                default:
                    break
                } // swith
            } // for
        } // for
        
        // 41: "发票开票资料"42: "采购员身份证正面",44"采购委托书"
        if viewType != .retail {
            //不是零售企业
            dataSource.append(QCType.creatBillMaterial)
            dataSource.append(QCType.buyerIdentityFront)
            dataSource.append(QCType.buyPowerLicense)
        }
        // 质保协议
//        if viewType == .wholeSale || viewType == .undefined {
//            dataSource.append(QCType.qualityGuaranteeDeal)
//        }
        
        // 非生产企业均需要加上两个资质文件：医疗器械经营许可证 & 食品流通许可证
        if viewType == .wholeSale || viewType == .undefined {
            // 非批零一体 or 批零一体之批发企业
            if !isProductType {
                // 非生产企业
//                if !dataSource.contains(QCType.instrumentsBusinessLic) {
//                    dataSource.append(QCType.instrumentsBusinessLic)
//                }
//                if !dataSource.contains(QCType.foodCirculatesLic) {
//                    dataSource.append(QCType.foodCirculatesLic)
//                }
                
                // 先删除，后增加...<保证非必填的项在必填项之后>
                if let index = dataSource.lastIndex(of: QCType.instrumentsBusinessLic) {
                    dataSource.remove(at: index)
                }
                if let index = dataSource.lastIndex(of: QCType.threeInstrumentsBusinessLic) {
                    dataSource.remove(at: index)
                }
                if let index = dataSource.lastIndex(of: QCType.foodCirculatesLic) {
                    dataSource.remove(at: index)
                }
                dataSource.append(QCType.instrumentsBusinessLic)
                dataSource.append(QCType.threeInstrumentsBusinessLic)
                dataSource.append(QCType.foodCirculatesLic)
            }
        }
        // 批零一体企业类型（批发企业、零售信息、批零一体）中，仅批发企业加医疗器械经营许可证 & 食品流通许可证&三类医疗器械经营许可证
        if viewType == .retail {
            // 批零一体之零售企业
            if let index = dataSource.lastIndex(of: QCType.instrumentsBusinessLic) {
                dataSource.remove(at: index)
            }
            if let index = dataSource.lastIndex(of: QCType.threeInstrumentsBusinessLic) {
                dataSource.remove(at: index)
            }
            if let index = dataSource.lastIndex(of: QCType.foodCirculatesLic) {
                dataSource.remove(at: index)
            }
        }
        
        // 其它
        dataSource.append(QCType.otherType)
        return dataSource
    }
    
    /*
     备注：
     
     // 1. 非批零一体 or 批零一体之批发企业
     组织代码机构 QCType.orgCode
     税务登记 QCType.taxRegister
     营业执照 QCType.businessLicense
     统一社会信用代码 QCType.societyCreditCode
     药品经营质量管理规范（GSP证书） QCType.drugBusinessSTD
     药品经营许可证 QCType.drugTrading
     发票开票资料 QCType.creatBillMaterial
     采购员身份证 QCType.buyerIdentityFront
     采购委托书 QCType.buyPowerLicense
     质保协议 QCType.qualityGuaranteeDeal
     医疗器械经营许可证 QCType.instrumentsBusinessLic
     食品流通许可证 QCType.foodCirculatesLic
     其它 QCType.otherType
     
     // 2. 批零一体之零售企业 or 批零一体之批零一体
     组织代码机构 QCType.orgCode
     税务登记 QCType.taxRegister
     营业执照 QCType.businessLicense
     统一社会信用代码 QCType.societyCreditCode
     药品经营质量管理规范（GSP证书） QCType.drugBusinessSTD
     药品经营许可证 QCType.drugTrading
     其它 QCType.otherType
     +
     批发零售证明文件 QCType.allinoneType
     其他 QCType.allinoneOtherType
     */
    
    // MARK: - 优化
    
    // 除其它资质外的所有资质类型列表
    class func getAllQcTypeList() -> [QCType] {
        var dataSource = [QCType]()
        
        // 营业执照、组织代码机构、税务登记
        let threeQualitications = [QCType.orgCode, QCType.taxRegister, QCType.businessLicense]
        // 统一社会信用代码
        let oneQualitication = [QCType.societyCreditCode]
        dataSource += threeQualitications
        dataSource += oneQualitication
        
        // 医疗机构执业许可证（盈利性）
        dataSource.append(QCType.medicalInstitution)
        // 医疗机构执业许可证（非盈利性）
        dataSource.append(QCType.medicalInstitutionNonProfit)
        // 药品经营质量管理规范（GSP证书）
        dataSource.append(QCType.drugBusinessSTD)
        // 药品经营许可证
        dataSource.append(QCType.drugTrading)
        // 药品生产许可证
        dataSource.append(QCType.drugProduceLic)
        // 药品生产质量管理规范（GMP）
        dataSource.append(QCType.drugProduceSTD)
        // 医疗器械生产许可证
        dataSource.append(QCType.instrumentsProduceLic)
        // 保健食品生产（卫生）许可证
        dataSource.append(QCType.foodProduceLic)
        // 一二类医疗器械经营许可证
        dataSource.append(QCType.instrumentsBusinessLic)
        // 三类医疗器械经营许可证
        dataSource.append(QCType.threeInstrumentsBusinessLic)
        // 食品流通许可证
        dataSource.append(QCType.foodCirculatesLic)
        // 发票开票资料
        dataSource.append(QCType.creatBillMaterial)
        // 采购员身份证
        dataSource.append(QCType.buyerIdentityFront)
        // 采购委托书
        dataSource.append(QCType.buyPowerLicense)
        // 质保协议
        //dataSource.append(QCType.qualityGuaranteeDeal)
        // 批发零售证明文件
        dataSource.append(QCType.allinoneType)
        
        return dataSource
    }
    
    class func getAllQcModelList(_ isNormal: Bool, _ list: [QCType]) -> [ZZFileProtocol] {
        var dataSource = [ZZFileProtocol]()
        
        for type in list {
            // 新建model
            // 非批零一体 or 批零一体之批发企业 <使用通用的ZZFileModel>
            // 批零一体之零售企业 or 批零一体之批零一体 <使用特殊的ZZAllInOneFileModel>
            var model: ZZFileProtocol = isNormal ? ZZFileModel() : ZZAllInOneFileModel()
            // 赋值...<主要是类型>
            model.typeId = type.rawValue
            // 加入
            dataSource.append(model)
        } // for
        
        return dataSource
    }
    
    // allList:所有资质类型列表（包含不需要显示和上传的资质，仅仅是用来最大化包含所有可能需要的资质）
    // valueList:已上传or本地缓存的部分/全部的资质类型列表
    class func setValueForAllQcModelList(_ allList: [ZZFileProtocol], _ valueList: [ZZFileProtocol]) {
        for var modelValue in valueList {
            for var modelNew in allList {
                if modelNew.typeId == modelValue.typeId {
                    modelNew.enterpriseId = modelValue.enterpriseId
                    modelNew.fileId = modelValue.fileId
                    modelNew.filePath = modelValue.filePath
                    modelNew.fileName = modelValue.fileName
                    modelNew.qualificationNo = modelValue.qualificationNo
                    modelNew.starttime = modelValue.starttime
                    modelNew.endtime = modelValue.endtime
                } // if 相同类型，直接赋全值
            } // for
        } // for
    }
    
    // MARK: - 资质上传页要展示的资质文件
//    func rowData(_ is3merge1:Bool,typeList:[EnterpriseOriginTypeModel],qcList:[ZZFileModel]?) -> NSArray? {
//        self.typeList(is3merge1, typeList: typeList,roleType: )
////        self.mapArrayToDictionary(qcList)
//        return self.mapArrayToDictionary(qcList)
//    }
    
    // MARK: - 从qcList（资质列表）中根据企业类型筛选要展示的数据
    func mapArrayToDictionary(_ qcList:[ZZFileModel]?) -> (NSArray){
        var eidtView = [[String:ZZMidModel]]()
        var checkView = [[String:ZZMidModel]]()
        for i in 0..<(self.dataSource.count) {
            let type = self.dataSource[i]
            let origin = ZZMidModel()
            for model :ZZFileModel in qcList! {
                if type.rawValue == model.typeId {
                    origin.pathList.append(model.filePath!)
                    if model.qualificationNo != nil{
                        origin.fileCode = model.qualificationNo!
                    }
                    if model.rawEndTime != nil{
                        origin.endDate = model.rawEndTime!
                    }
                    if model.rawStartTime != nil{
                        origin.startDate = model.rawStartTime!
                    }
                }
            }
            let dic = ["\(type.rawValue)" : origin]
            if origin.pathList.count >= 1 {
                let data = ["\(type.rawValue)" : origin]
                checkView.append(data)
            }
            eidtView.append(dic)
        }
        return eidtView as (NSArray)
    }
    
    // MARK: - 从qcList（资质列表）中根据企业类型筛选要展示的数据
    func checkZZFile(_ qcList:[ZZFileModel]?) -> ([[String:ZZMidModel]]){
        var checkView = [[String:ZZMidModel]]()
        for i in 0..<(self.dataSource.count) {
            let type = self.dataSource[i]
            let origin = ZZMidModel()
            for model :ZZFileModel in qcList! {
                if type.rawValue == model.typeId {
                    origin.pathList.append(model.filePath!)
                    if model.qualificationNo != nil{
                        origin.fileCode = model.qualificationNo!
                    }
                    if model.rawEndTime != nil{
                        origin.endDate = model.rawEndTime!
                    }
                    if model.rawStartTime != nil{
                        origin.startDate = model.rawStartTime!
                    }
                }
            }
            if origin.pathList.count >= 1 {
                let data = ["\(type.rawValue)" : origin]
                checkView.append(data)
            }
        }
        return checkView
    }
    
//    // MARK: - 资质上传页要展示的资质文件
//    func checkZZFileRowData(_ is3merge1:Bool,typeList:[EnterpriseOriginTypeModel],qcList:[ZZFileModel]?) -> [[String:ZZMidModel]]? {
//        self.typeList(is3merge1, typeList: typeList)
//        self.mapArrayToDictionary(qcList)
//        return self.checkZZFile(qcList)
//    }

    // MARK: - 用来保存资质的编码、开始和结束时间
    func zzFileCodeAndDate(_ qcList:[ZZFileModel]?) -> NSArray? {
        var section = [[String:ZZFileModel]]()
        for i in 0..<(self.dataSource.count) {
            let type = self.dataSource[i]
            let origin = ZZFileModel()
            origin.qualificationNo = "请填写"
            origin.rawEndTime = "请选择"
            origin.rawStartTime = "请选择"
            for model :ZZFileModel in qcList! {
                if type.rawValue == model.typeId {
                    if model.qualificationNo != nil{
                        origin.qualificationNo = model.qualificationNo
                    }
                    if model.rawEndTime != nil{
                        origin.rawEndTime = model.rawEndTime
                    }
                    if model.rawStartTime != nil{
                        origin.rawStartTime = model.rawStartTime
                    }
                }
            }
            let dictionary = ["\(type.rawValue)" : origin]
            section.append(dictionary)
        }
        return section as NSArray
    }
    
    // MARK: - 分区title
    func sectionTitle(_ type : Int) -> String? {
        switch type {
        case 1:
            return "企业法人委托证书"
        case 2:
            return "头像"
        case 3:
            return "银行开户许可证"
        case 21:
            return "组织机构代码证"
        case 22:
            return "税务登记证"
        case 23:
            return "营业执照"
        case 24:
            return "统一社会信用代码"
        case 25:
            return "医疗机构执业许可证（盈利性）"
        case 26:
            return "药品经营质量管理规范（GSP证书）"
        case 27:
            return "药品经营许可证"
        case 28:
            return "药品生产许可证"
        case 29:
            return "药品生产质量管理规范（GMP）"
        case 30:
            return "医疗器械生产许可证"
        case 31:
            return "保健食品生产（卫生）许可证"
        case 32:
            return "二类医疗器械经营许可证"
        case 38:
            return "三类医疗器械经营许可证"
        case 33:
            return "食品流通许可证"
        case 34:
            return "医疗机构执业许可证（非盈利性）"
        case 35:
            return "企业其他资质"
        case 36:
            return "批发零售证明文件"
        case 37:
            return "企业其他资质"
        case 44:
            return "采购委托书"
        case 41:
            return "发票开票资料"
        case 42:
            return "采购员身份证"
        case 45:
            return "质保协议"
        default:
            return nil
        }
    }
    
//    /// MARK: - 分区title
//    func sectionTitleDes(_ type : Int) -> String? {
//        switch type {
//        case 1:
//            return "请上传正面清晰的照片"
//        case 2:
//            return "头像"
//        case 3:
//            return "银行开户许可证"
//        case 21:
//            return "组织机构代码证"
//        case 22:
//            return "税务登记证"
//        case 23:
//            return "营业执照"
//        case 24:
//            return "统一社会信用代码"
//        case 25:
//            return "医疗机构执业许可证（盈利性）"
//        case 26:
//            return "药品经营质量管理规范（GSP证书）"
//        case 27:
//            return "药品经营许可证"
//        case 28:
//            return "药品生产许可证"
//        case 29:
//            return "药品生产质量管理规范（GMP）"
//        case 30:
//            return "医疗器械生产许可证"
//        case 31:
//            return "保健食品生产（卫生）许可证"
//        case 32:
//            return "医疗器械经营许可证"
//        case 33:
//            return "食品流通许可证"
//        case 34:
//            return "医疗机构执业许可证（非盈利性）"
//        case 35:
//            return "企业其他资质"
//        case 36:
//            return "批发零售证明文件"
//        case 37:
//            return "企业其他资质"
//        case 44:
//            return "采购委托书"
//        case 41:
//            return "发票开票资料"
//        case 42:
//            return "采购员身份证"
//        default:
//            return nil
//        }
//    }
    
    // MARK: - 分区title
    func isMustUploadFile(_ fileType : Int, roleType: Int?,drugScopeList: [DrugScopeModel]?) -> Bool {
        switch fileType {
        case 1:
            return true//"企业法人委托证书"
        case 2:
            return false//"头像"
        case 3:
            return true//"银行开户许可证"
        case 21:
            return true//"组织机构代码证"-通用必填
        case 22:
            return true//"税务登记证"-通用必填
        case 23:
            return true//"营业执照"-通用必填
        case 24:
            return true//"统一社会信用代码"-通用必填
        case 25:
            return true//"医疗机构执业许可证（盈利性）"-特有必填
        case 26:
            // 1: 终端, 2: 生产, 3: 批发
            if 1 == roleType {
                return true//"药品经营质量管理规范（GSP证书）"-特有必填
            }else if 3 == roleType {
                // 为批发企业时，当前类型需修改为必填
                return true
            }else {
                return false
            }
        case 27:
            return true//"药品经营许可证"-特有必填
        case 28:
            return false//"药品生产许可证"-特有非必填
        case 29:
            return false//"药品生产质量管理规范（GMP）"-特有非必填
        case 30:
            return false//"医疗器械生产许可证"-特有非必填
        case 31:
            return false//"保健食品生产（卫生）许可证"-特有非必填
        case 32:
            if let threeInstrumentsLic = (drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '256'")) as? [DrugScopeModel] {
                if threeInstrumentsLic.isEmpty == false{
                    return true
                }
            }
            return false//"医疗器械经营许可证"--经营范围选择一二类医疗器械则必填 其他非必填
        case 38:
            if let threeInstrumentsLic = (drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '257'")) as? [DrugScopeModel] {
                if threeInstrumentsLic.isEmpty == false{
                     return true
                }
            }
            return false//"三类医疗器械经营许可证"--经营范围选择三类医疗器械则必填 其他非必填
        case 33:
            if let threeInstrumentsLic = (drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '260'")) as? [DrugScopeModel] {
                if threeInstrumentsLic.isEmpty == false{
                    return true
                }
            }
            return false//"食品流通许可证"-经营范围选择食品则必填 其他非必填
        case 34:
            return true//"医疗机构执业许可证（非盈利性）"-特有必填
        case 35:
            return false//"企业其他资质"
        case 36:
            return true //"批发零售证明文件"-必填
        case 41:
            return true //"发票开票资料 - 通用必填"
        case 42:
            return true //"采购员身份证 - 通用必填"
        case 44:
            return true //"采购委托书 - 通用必填"
        case 45:
            return true //"质保协议- 通用必填"
        case 37:
            return false //"批发零售企业其他资质"-非必填
        default:
            return true
        }
    }
    
    //待电子审核:0; 审核通过:1; 审核不通过:2 ;变更:3 ; 待纸质审核:4; 变更待电子审核:5; 变更待纸质审核:6 ;变更审 核不通过:7 ;11、12、13、14:资质信息填写一部分;-1 : 资质 未填写(新用户)
    
    // MARK: - 根据资质状态 返回可编辑状态   可查看原资质状态  及code对应的文描
    func titleForZZStatus(_ statusCode:Int) -> ([String:AnyObject]) {
        var dic = ["title":"","eidtStatus":false,"originStatus":false] as [String : Any]
        switch statusCode {
        case 0:
            dic = ["title":"待电子审核", "titleColor":RGBColor(0x3580FA), "backGroundColor":RGBColor(0xF2F7FF), "eidtStatus":false,"originStatus":false]
        case 1:
            dic = ["title":"审核通过", "titleColor":RGBColor(0x49BA2A), "backGroundColor":RGBColor(0xF4FCF2),"eidtStatus":true,"originStatus":false]
        case 2:
            dic = ["title":"审核不通过", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":true,"originStatus":false]
        case 3:
            dic = ["title":"变更", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":true,"originStatus":true]
        case 4:
            dic = ["title":"待纸质审核", "titleColor":RGBColor(0x3580FA), "backGroundColor":RGBColor(0xF2F7FF),"eidtStatus":false,"originStatus":false]
        case 5:
            dic = ["title":"变更待电子审核", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":false,"originStatus":true]
        case 6:
            dic = ["title":"变更待纸质审核", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":false,"originStatus":true]
        case 7:
            dic = ["title":"变更审核不通过", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":true,"originStatus":true]
        case 11,12,13,14:
            dic = ["title":"","eidtStatus":false,"originStatus":false]
        case -1:
            dic = ["title":"未填写","eidtStatus":false,"originStatus":false]
        default:
            dic = ["title":"","eidtStatus":false,"originStatus":false]
        }
        return dic as ([String : AnyObject])
    }
    
    // MARK: - 通过isAudit判断 0：未审核，1：审核通过，2：审核未通过，3：待发货审核，4：变更待发货审核，5：资质过期
    func titleForZZSelfStatus(_ statusCode:Int) -> ([String:AnyObject]) {
        var dic = ["title":"","eidtStatus":false,"originStatus":false] as [String : Any]
        switch statusCode {
        case 0:
            dic = ["title":"未审核", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xF2F7FF), "eidtStatus":false,"originStatus":false]
        case 1:
            dic = ["title":"审核通过", "titleColor":RGBColor(0x49BA2A), "backGroundColor":RGBColor(0xF4FCF2),"eidtStatus":true,"originStatus":false]
        case 2:
            dic = ["title":"审核不通过", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":true,"originStatus":false]
        case 3:
            dic = ["title":"待发货审核", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xF2F7FF),"eidtStatus":false,"originStatus":false]
        case 4:
            dic = ["title":"变更待发货审核", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":false,"originStatus":true]
        case 5:
            dic = ["title":"资质过期", "titleColor":RGBColor(0xFF394E), "backGroundColor":RGBColor(0xFFF7F6),"eidtStatus":false,"originStatus":true]
        case -1:
            dic = ["title":"未填写","eidtStatus":false,"originStatus":false]
        default:
            dic = ["title":"","eidtStatus":false,"originStatus":false]
        }
        return dic as ([String : AnyObject])
    }
    
    // MARK: - 资质状态描述
    func titleWithStatusCode(_ statusCode:Int) -> String {
        let dic = self.titleForZZStatus(statusCode)
        return dic["title"] as! String
    }
    
    // MARK: -  是否可编辑
    func eidtingStatusWithStatusCode(_ statusCode:Int) -> Bool {
        let dic = self.titleForZZStatus(statusCode)
        return dic["eidtStatus"] as! Bool
    }
    
    // MARK: -  是否可查看原资料
    func originFileCanCheckWithStatusCode(_ statusCode:Int) -> Bool {
        let dic = self.titleForZZStatus(statusCode)
        return dic["originStatus"] as! Bool
    }
    
    // MARK: -  保存资质文件参数转化
    func saveFileParam(_ arr:[[String: ZZMidModel]], is3merge1:Bool, callBack:(_ message:String,_ para:[String:AnyObject],_ result:Bool)->()) {
        var dic:[String:AnyObject] = ["is3merge1":0 as AnyObject,"qcDftList":"" as AnyObject]
        var resultArray = [ZZFileModel]()
        var message = "没有上传资质图片"
        var result = true
        if is3merge1 {
            dic["is3merge1"] = 1 as AnyObject
        }else{
            dic["is3merge1"] = 0 as AnyObject
        }
        for item:[String:ZZMidModel] in arr {
            for (key,value) in item {
                if value.pathList.count < 1 && Int(key) != 35{
                  message = self.sectionTitle(Int(key)!)! + message
                    result = false
                    callBack(message,dic,result)
                    return
                }else{
                    for path in value.pathList {
                        let model = ZZFileModel()
                        model.typeId = Int(key)!
                        model.qualificationNo = value.fileCode
                        model.rawStartTime = value.startDate
                        model.rawEndTime = value.endDate
                        let list:[String] = (path?.components(separatedBy: ".com"))!
                        model.filePath = list.last
                        resultArray.append(model)
                    }
                }
            }
        }
        let json = (resultArray as NSArray).reverseToJSON()
        dic["qcDftList"] = json as AnyObject
        callBack(message,dic,result)
    }
    
    // MARK: -  保存资质文件参数转化
    func validateSubmitQualitication(withZZModel zzModel: ZZModel, currentViewType: QualiticationViewType, qviews: [QualiticationCollectionView], callBack:(_ message: String,_ para:[String: AnyObject], _ result: Bool)->()) {
        let is3merge1 = (zzModel.enterprise?.is3merge1 == 1 ? 1 : 0)
        let is3merge2 = (zzModel.enterpriseRetail?.is3merge1 == 1 ? 1 : 0)
        let isWholesaleRetail = (zzModel.enterprise?.isWholesaleRetail == 1 ? 1 : 0)
        let roleType = zzModel.enterprise?.roleType
        
        var dic:[String:AnyObject] = ["is3merge1": is3merge1 as AnyObject,
                                      "is_wholesale_retail": isWholesaleRetail as AnyObject,
                                      "qcDftList": "" as AnyObject,
                                      "qualificationRetailList": "" as AnyObject,
                                      "is3merge2": is3merge2 as AnyObject]
        let fileModelArray = NSMutableArray.init()
        var message = "没有上传资质图片"
        var result = true
        
        // 所有非必填
        var notMustUploadFileType = [2, 28, 29, 30, 31, 35, 37]
        if 1 != roleType && 3 != roleType {
            // 批发类型的企业，26这种需要改为必填
            notMustUploadFileType.append(26)
        }
        if currentViewType != .wholeSale && currentViewType != .undefined{
            // 批零一体企业 非批发企业质保协议不是必填
            notMustUploadFileType.append(45)
        }
        // 二级医疗器械  经营范围256 资质id 32
        if let instrumentsLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '256'")) as? [DrugScopeModel] {
            if instrumentsLic.isEmpty == true{
                notMustUploadFileType.append(32)
            }
        }
        //三级医疗器械  257 38
        if let threeInstrumentsLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '257'")) as? [DrugScopeModel] {
            if threeInstrumentsLic.isEmpty == true{
                notMustUploadFileType.append(38)
            }
        }
        //食品 食品 260 33
        if let foodLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '260'")) as? [DrugScopeModel] {
            if foodLic.isEmpty == true{
                notMustUploadFileType.append(33)
            }
        }
        
        for (_, value) in qviews.enumerated() {
            //
            var aryFiles: [ZZFileProtocol] = []
            value.dataSource.forEach({ (tuple) in
                aryFiles.append(contentsOf: tuple.fileModels)
            })
            // 当前用户所有已经填写的必填项
            let toCheckImageFiles = (aryFiles as NSArray).filtered(using: NSPredicate(format: "NOT (typeId IN %@)", notMustUploadFileType))
            // 当前类型企业的所有必填
            let mustUploadFileType = value.qcTypes.filter { (fileType) -> Bool in
                return !notMustUploadFileType.contains(fileType.rawValue)
            }
            
            for (_, model) in aryFiles.enumerated() {
                // 判断是否有证件号和效期
                // 仅批发企业判断和非批零一体企业
                
                if model.filePath == nil || model.filePath == "" {
                    if !notMustUploadFileType.contains(model.typeId) {
                        message = self.sectionTitle(model.typeId)! + "没有上传资质图片"
                        result = false
                        if currentViewType == value.viewType {
                            callBack(message, dic, result)
                            return
                        }
                    }
                }
                
                if model.typeId == 45 || model.typeId == 41 || model.typeId == 42 || model.typeId == 44 || model.typeId == 32 || model.typeId == 38 || model.typeId == 33 {
                    // 二 三类医疗器械经营许可证，食品流通许可证，采购委托书，开票资料，身份证、质保协议、证件号和效期是非必填的
                }
                else {
                    //
                }
            } // for
            
            if toCheckImageFiles.count < mustUploadFileType.count {
                // 至少有一个必填项无值
                result = false
                // 第一个无值的索引...<默认最后一个>
                var zzIndex = toCheckImageFiles.count
                // 查找
                for index in 0 ..< mustUploadFileType.count {
                    // 类型
                    let type : QCType = mustUploadFileType[index]
                    // 当前类型是否有值...<默认为无值>
                    var hasFlag = false
                    
                    for i in 0 ..< toCheckImageFiles.count {
                        let model : ZZFileProtocol = toCheckImageFiles[i] as! ZZFileProtocol
                        if model.typeId == type.rawValue {
                            hasFlag = true
                            break
                        }
                    } // for
                    
                    if !hasFlag {
                        zzIndex = index
                        break
                    }
                } // for
                // 最终的提示文字
                message = self.sectionTitle( mustUploadFileType[zzIndex].rawValue)! + message
                // 当前页校验已完成
                if currentViewType == value.viewType {
                    callBack(message, dic, result)
                    return
                }
            }
            else {
                // 所有必填项均有值
                let notEmptyImageFiles = (aryFiles as NSArray).filtered(using: NSPredicate(format: "NOT (getFilPathForUplaodAPI = '' || getFilPathForUplaodAPI = nil)"))
                if value.viewType == .undefined || value.viewType == .wholeSale {
                    // 非批零一体&批零一体的批发企业直接组装qcDftList
                    let json = (notEmptyImageFiles as NSArray).reverseToJSON()
                    dic["qcDftList"] = json as AnyObject
                } else {
                    // 批零一体零售企业&批零一体将资质文件放进数组中待处理...<.retail or .wholeSaleAndRetail>
                    fileModelArray.addObjects(from: notEmptyImageFiles)
                }
                
                // 非批零一体提交审核直接返回，不处理待处理数组
                if value.viewType == .undefined {
                    callBack(message, dic, result)
                    return
                }
                
                // 批零一体提交审核时，处理待处理数组组装qualificationRetailList
                if value.viewType == .wholeSaleAndRetail {
                    let json = (fileModelArray as NSArray).reverseToJSON()
                    dic["qualificationRetailList"] = json as AnyObject
                    callBack(message, dic, result)
                    return
                }
                
                if currentViewType == value.viewType {
                    callBack(message, dic, result)
                    return
                }
            }
        } // for
    }
    
    // MARK: -  判断是否必填项
    func notMustUploadFileType(withZZModel zzModel: ZZModel, roleType: Int, typeId : Int) -> Bool {
        var notMustUploadFileType = [2, 28, 29, 30, 31, 35, 37]
        if 1 != roleType && 3 != roleType {
            // 批发类型的企业，26这种需要改为必填
            notMustUploadFileType.append(26)
        }
        
        // 二级医疗器械  经营范围256 资质id 32
        if let instrumentsLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '256'")) as? [DrugScopeModel] {
            if instrumentsLic.isEmpty == true{
                notMustUploadFileType.append(32)
            }
        }
        //三级医疗器械  257 38
        if let threeInstrumentsLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '257'")) as? [DrugScopeModel] {
            if threeInstrumentsLic.isEmpty == true{
                notMustUploadFileType.append(38)
            }
        }
        //食品 食品 260 33
        if let foodLic = (zzModel.drugScopeList! as NSArray).filtered(using: NSPredicate(format: "drugScopeId == '260'")) as? [DrugScopeModel] {
            if foodLic.isEmpty == true{
                notMustUploadFileType.append(33)
            }
        }
        if notMustUploadFileType.contains(typeId){
            return true
        }else {
            return false
        }
    }
}
