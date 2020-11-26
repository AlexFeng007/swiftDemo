//
//  RIImageViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

// 资质类型
enum RIQualificationType: Int {
    // 所有类型
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
}


class RIImageViewModel: NSObject {
    // MARK: - Property
    
    // tab标题数组
    var tabTitleList = [String]()
    
    // tab内容结构数组...<section>
    var tabContentList = [RIQualificationModel]()
    
    // 其它资质类型可上传的最大图片数量
    var maxCount: Int = 10
    
    // 1.用户已提交的资质model...<查看or修改>...<上个界面传递过来的接口数据>
    // 2.用户缓存的资质model...<上传>...<仅缓存了当前界面的资质图片数据>
    var zzImageModel: ZZModel?
    
    // 界面展示模式...<默认是上传图片、提交审核>
    var showMode: RIImageMode = .submit
    
    // 用户id...<用于按用户维度来缓存数据>
    let userid: String = ( (FKYLoginAPI.loginStatus() == .unlogin) ? "" : FKYLoginAPI.currentUserId() )
    
    
    // MARK: - Init
    
    override init() {
        super.init()
        //
    }
}


// MARK: - CollectionView Data

extension RIImageViewModel {
    // 判断当前section（企业类型）是否显示三证合一开关栏
    func getSwitchShowStatus(_ section: Int) -> Bool {
        // section个数...<企业类型个数>
        let sectionCount = tabContentList.count
        // 异常判断
        guard sectionCount > section else {
            return false
        }
        
        return tabContentList[section].show3Merge1
    }
    
    // 获取当前section（企业类型）中的三证合一开关状态
    func getSwitchValue(_ section: Int) -> Bool {
        // section个数...<企业类型个数>
        let sectionCount = tabContentList.count
        // 异常判断
        guard sectionCount > section else {
            return false
        }
        
        return tabContentList[section].is3Merge1
    }
    
    // 获取当前sectoin的企业类型名称
    func getSectionTitle(_ section: Int) -> String {
        guard tabTitleList.count > section else {
            return "企业"
        }
        return tabTitleList[section]
    }
}


// MARK: - Public

extension RIImageViewModel {
    // 更新指定section下资质列表model的三证合一显示状态
    func updateStatusFor3Merge1(_ status: Bool, _ section: Int) {
        guard tabContentList.count > section else {
            return
        }
        
        // 当前tab对应的资质列表model
        let model: RIQualificationModel = tabContentList[section]
        guard model.show3Merge1 == true else {
            return
        }
        
        // 更新总的三证合一状态
        model.is3Merge1 = status
        
        // 更新当前tab下各资质项的显示状态
        if let list = model.qualicationList, list.count > 0 {
            // 清空展示数据源
            model.qualicationListShow.removeAll()
            
            // 当前资质列表有数据
            for item in list {
                // 更新各资质项的展示状态
                if let is3Merge1 = item.is3Merge1, (is3Merge1 == 0 || is3Merge1 == 1) {
                    // 字段非空，则表示与三证合一有关，需进一步判断是否显示
                    if is3Merge1 == 0 {
                        // 组织机构代码证、税务登记证、营业执照...<三证合一时不显示>
                        item.showFlag = (model.is3Merge1 ? false : true)
                    }
                    else {
                        // 统一社会信用代码...<三证合一时显示>
                        item.showFlag = (model.is3Merge1 ? true : false)
                    }
                }
                else {
                    // 字段为空，则表示与三证合一无关，一定显示
                    item.showFlag = true
                }
                
                // 保存需要显示的项
                if item.showFlag {
                    model.qualicationListShow.append(item)
                }
            } // for
        }
        else {
            // 当前资质列表无数据
        }
    }
    
    // 更新(增加or删除)资质图片...<传nil为删除>...<仅针对单个图片的上传、删除操作>
    func updateQualificationImage(_ imgurl: String?, _ imgname: String?, _ index: IndexPath) {
        guard tabContentList.count > index.section else {
            return
        }
        
        // 当前tab对应的资质列表model
        let model: RIQualificationModel = tabContentList[index.section]
        // 界面上展示的数据源数组
        let list = model.qualicationListShow
        guard list.count > 0, list.count > index.row else {
            return
        }
        
        // 用户当前操作的其它资质项
        let item: RIQualificationItemModel = list[index.row]
        
        // 更新当前项
        if let txt = imgurl, txt.isEmpty == false {
            // 不为空，保存
            item.imgUrlQualifiction = txt
            item.fileName = imgname
        }
        else {
            // 为空，删除
            item.imgUrlQualifiction = nil
            item.fileName = nil
        }
        //判断过期提示的显示问题
        item.updateFlag = true
        // 更新原始的数据源
        let indexSearch = model.getQualificationItemIndex(item)
        if indexSearch >= 0, let array = model.qualicationList, array.count > indexSearch {
            let obj: RIQualificationItemModel = array[indexSearch]
            // 同步更新
            obj.imgUrlQualifiction = item.imgUrlQualifiction
            obj.fileName = item.fileName
        }
        
        // 单独处理逻辑...<其它资质35 or 批零一体其它资质37>
        if let typeid = item.qualificationTypeId, (typeid == 35 || typeid == 37) {
            updateQualifictionForOtherType(index, typeid)
        }
    }
    
    // 当上传其它资质类型时，需确定当前可上传的最大图片数量...<非其它资质类型仅可上传1张图片>
    func getMaxUploadImageNeededForOtherType(_ index: IndexPath, _ typeid: Int) -> Int {
        // 非其它资质类型，仅可上传1张图片
        guard typeid == 35 || typeid == 37 else {
            return 1
        }
        
        // 其它资质类型可上传最多10张图片
        guard tabContentList.count > index.section else {
            return 1
        }
        
        // 当前tab对应的资质列表model
        let model: RIQualificationModel = tabContentList[index.section]
        // 界面上展示的数据源数组
        let list = model.qualicationListShow
        guard list.count > 0, list.count > index.row else {
            return 1
        }
        
        // 当前资质类型已上传的图片数量
        let number = model.getQualificationImageNumberForOtherType(typeid)        
        return maxCount - number
    }
    
    // 一次同时上传多张其它资质类型图片时的逻辑处理
    func addMultiQualificationImageForOtherType(_ listUrl: [String], _ listName: [String], _ index: IndexPath) {
        guard tabContentList.count > index.section else {
            return
        }
        
        // 当前tab对应的资质列表model
        let model: RIQualificationModel = tabContentList[index.section]
        // 界面上展示的数据源数组
        let list = model.qualicationListShow
        guard list.count > 0, list.count > index.row else {
            return
        }
        
        // 用户当前操作的其它资质项
        let item: RIQualificationItemModel = list[index.row]
        
        // error...<非其它资质类型>
        guard let typeid = item.qualificationTypeId, (typeid == 35 || typeid == 37) else {
            return
        }
        
        // 当前资质类型已上传的图片数量
        let uploadNumber = model.getQualificationImageNumberForOtherType(typeid)
        // 待上传的图片数量
        let leftNumber = maxCount - uploadNumber
        // 当前最终上传的图片数量
        let currentNumber = (listUrl.count <= leftNumber ? listUrl.count : leftNumber)
        
        // 上传N张图片，则新建N个资质model，并赋值
        var tag: Int = item.tagQualification
        var array = [RIQualificationItemModel]()
        for i in 0..<currentNumber {
            let url: String = listUrl[i]
            let obj: RIQualificationItemModel = item.createNewModel()
            obj.tagQualification = tag
            obj.imgUrlQualifiction = url
            obj.fileName = (listName.count > i ? listName[i] : nil)
            obj.showFlag = true
            obj.updateFlag = true
            array.append(obj)
            tag = tag + 1
        } // for
        
        // 先同步删除...<删一个>
        let indexSearch = model.getQualificationItemIndex(item)
        if indexSearch >= 0, let array = model.qualicationList, array.count > indexSearch {
            model.qualicationList!.remove(at: indexSearch)
        }
        model.qualicationListShow.remove(at: index.row)
        
        // 再同步增加...<加多个>
        model.qualicationList!.append(contentsOf: array)
        model.qualicationListShow.append(contentsOf: array)
        
        // 判断是否已全部上传完毕
        if uploadNumber + currentNumber == maxCount {
            // 已全部上传完
        }
        else {
            // 未全部上传完
            let lastObj: RIQualificationItemModel? = model.qualicationListShow.last
            guard let obj = lastObj else {
                return
            }
            // 增加空资质model
            let im: RIQualificationItemModel = obj.createNewModel()
            im.tagQualification = obj.tagQualification + 1
            im.imgUrlQualifiction = nil
            im.fileName = nil
            im.showFlag = true
            im.updateFlag = true
            // 同步增加
            model.qualicationList!.append(im)
            model.qualicationListShow.append(im)
        }
    }
}


// MARK: - Private

extension RIImageViewModel {
    // 针对其它资质类型的更新（上传与删除）操作的处理逻辑...<单个图片上传or删除>
    fileprivate func updateQualifictionForOtherType(_ index: IndexPath, _ typeid: Int) {
        guard tabContentList.count > index.section else {
            return
        }
        
        // 当前tab对应的资质列表model
        let model: RIQualificationModel = tabContentList[index.section]
        // 界面上展示的数据源数组
        let list = model.qualicationListShow
        guard list.count > 0, list.count > index.row else {
            return
        }
        
        // 用户当前操作的其它资质项
        let item: RIQualificationItemModel = list[index.row]
        
        // 指定资质类型的相关信息元组
        let typeInfo: (Int, Int, RIQualificationItemModel?) = model.getQualificationItemInfo(typeid)
        // 数组中当前资质类型的model元素个数
        let showNumber: Int = typeInfo.0
        // 数组中最后一个当前资质类型的model元素
        let modelLast: RIQualificationItemModel? = typeInfo.2
        
        // (其它)资质项至少有一个
        guard showNumber > 0 else {
            return
        }
        guard let obj = modelLast else {
            return
        }
        
        // 最终的更新逻辑
        if let txt = item.imgUrlQualifiction, txt.isEmpty == false {
            // 上传图片...<有值>
            if showNumber >= maxCount {
                // 最多上传10张其它资质类型图片...<已达限额>
            }
            else {
                // 不足10张...<list中需新增一个空白项>
                let objNew: RIQualificationItemModel = obj.createNewModel()
                objNew.showFlag = true
                objNew.tagQualification = (obj.tagQualification + 1)
                // 两个数组同步增加
                model.qualicationListShow.append(objNew)
                model.qualicationList!.append(objNew)
            }
        }
        else {
            // 删除图片...<无值>
            guard showNumber >= 2 else {
                // 仅有一张时，只清空url字段，不删除model
                return
            }
            
            // 两个数组同步删除
            let indexSearch = model.getQualificationItemIndex(item)
            if indexSearch >= 0, let array = model.qualicationList, array.count > indexSearch {
                model.qualicationList!.remove(at: indexSearch)
            }
            model.qualicationListShow.remove(at: index.row)
            
            // 指定资质类型的相关信息元组
            let typeModel: (Int, Int, RIQualificationItemModel?) = model.getQualificationItemInfo(typeid)
            // 数组中当前资质类型的model元素个数
            let typeNumber: Int = typeModel.0
            // 数组中最后一个当前资质类型的model元素
            let typeLast: RIQualificationItemModel? = typeModel.2
            
            // (其它)资质项至少有一个
            guard typeNumber > 0 else {
                return
            }
            guard let type: RIQualificationItemModel = typeLast else {
                return
            }
            
            // 若最后一个同类型的资质model中无图片内容，则不需要新增
            guard let url = type.imgUrlQualifiction, url.isEmpty == false else {
                return
            }
            
            // 新增一个新的资质model
            let objNew: RIQualificationItemModel = type.createNewModel()
            objNew.showFlag = true
            objNew.tagQualification = (type.tagQualification + 1)
            // 两个数组同步增加
            model.qualicationListShow.append(objNew)
            model.qualicationList!.append(objNew)
        }
    }
}


// MARK: - Request

extension RIImageViewModel {
    // 请求资质图片列表
    func requestForImageUploadList(_ block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.requestForGetEnterpriseImageList(withParam: nil, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard isSuccess else {
                var msg = "请求失败"
                if let txt = error?.localizedDescription, txt.isEmpty == false {
                    msg = txt
                }
                block(false, msg)
                return
            }
            // 请求成功
            if let list: [RIQualificationModel] = model as? [RIQualificationModel], list.count > 0 {
                // 有数据...<保存>
                strongSelf.tabContentList = list
                // 根据不同模式做不同的数据处理
                if strongSelf.showMode == .submit {
                    // 上传图片并提交审核...<需要检查是否有缓存>
                    strongSelf.processImageModelForUpload()
                }
                else {
                    // （已上传图片、已提交审核情况下的）修改or查看资质图片列表
                    strongSelf.processImageModelForUpdate()
                }
                block(true, nil)
            }
            else {
                // 无数据
                block(false, "暂无数据")
            }
        })
    }
    
    // (上传资质图片)提交...<提交成功后需删除缓存数据>
    func requestForSubmit(_ block: @escaping (Bool, String?, Any?)->()) {
        // 入参
        let params = getEnterpriseInfoData()
        FKYRequestService.sharedInstance()?.requestForSubmitEnterpriseImageInfo(withParam: params, completionBlock: { (isSuccess, error, response, model) in
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
    
    // 提交提审
    func requestForReview(_ block: @escaping (Bool, String?, Any?)->()) {
        // 非批发企业or批发企业之非批零一体是否三证合一
        var is3merge1 = 0
        // 零售企业是否三证合一
        var is3merge2 = 0
        //
        for i in 0..<tabContentList.count {
            // 资质类型model
            let model = tabContentList[i]
            
            // 三证合一状态
            if i == 0 {
                // 非批发企业or批发企业
                is3merge1 = (model.is3Merge1 ? 1 : 0)
            }
            else if i == 1 {
                // 零售企业
                is3merge2 = (model.is3Merge1 ? 1 : 0)
            }
        } // for
        
        // 入参
        let params = ["is3merge1": is3merge1, "is3merge2": is3merge2]
        
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubmitQualificationReview(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            // 请求失败
            guard isSuccess else {
                var msg = "提交审核失败"
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
}


// MARK: - Cache

extension RIImageViewModel {
    // 获取缓存的企业信息
    func getEnterpriseInfoFromCache() {
        // read
        zzImageModel = ZZModel.getImageData(userid)
        print("读取缓存数据完毕")
        if zzImageModel == nil {
            print("无缓存数据")
        }
        else {
            print("有缓存数据")
        }
    }
    
    // 保存缓存的企业信息
    func saveEnterpriseInfoForCache() {
        // 将显示数据源转换成缓存数据源...<为缓存作准备>
        handleImageModelForCache()
        guard let model: ZZModel = zzImageModel else {
            print("无数据可缓存")
            return
        }
        
        // write
        model.saveImageData(userid)
        print("保存缓存数据完毕")
    }
    
    // 删除保存的企业信息...<一定是提交成功后的操作>
    func deleteEnterpriseInfoInCache() {
        // delete
        ZZModel.removeImageData(userid)
        print("删除缓存数据完毕")
    }
}


// MARK: - 数据处理

extension RIImageViewModel {
    // 显示用户已缓存的资质列表信息...<若无缓存，则所有资质url为空>
    fileprivate func processImageModelForUpload() {
        // 取缓存
        getEnterpriseInfoFromCache()
        // 数据处理...<先赋值，再显示>
        processImageModelForUpdate()
    }
    
    // 显示用户已提交审核的资质列表信息
    fileprivate func processImageModelForUpdate() {
        // 先赋值
        processQualificationListForValue()
        // 再确定显示数据源
        processQualificationListForShow()
    }
    
    // 处理资质信息接口/缓存返回的资质数据
    fileprivate func processQualificationListForValue() {
        // 无资质列表
        guard tabContentList.count > 0 else {
            return
        }
        
        // [资质信息接口or缓存]返回的数据model为空
        guard let model = zzImageModel else {
            return
        }
        
        // （非批发企业or批发企业之非批零一体）资质列表
        var qcList = [ZZFileModel]()
        if let list: [ZZFileModel] = model.qcList, list.count > 0 {
            qcList = list
        }
        // （零售企业&批零一体）资质列表
        var qcRetailList = [ZZAllInOneFileModel]()
        if let list: [ZZAllInOneFileModel] = model.qualificationRetailList, list.count > 0 {
            qcRetailList = list
        }
        
        // 遍历资质列表数组
        for i in 0..<tabContentList.count {
            // section-model
            let sectionModel: RIQualificationModel = tabContentList[i]
            // 是否三证合一
            var is3Merge1: Bool = false
            // qualification-list
            if let array = sectionModel.qualicationList, array.count > 0 {
                // 遍历
                for obj: RIQualificationItemModel in array {
                    if i == 0 {
                        // （非批发企业or批发企业之非批零一体）资质列表
                        for item: ZZFileModel in qcList {
                            // 给非其它资质类model赋值
                            if let tid = obj.qualificationTypeId, tid == item.typeId, tid != 35 {
                                obj.id = item.id
                                obj.enterpriseId = item.enterpriseId
                                obj.numberQualification = item.qualificationNo
                                obj.startTimeQualification = item.starttime
                                obj.endTimeQualification = item.endtime
                                obj.imgUrlQualifiction = item.filePath
                                obj.fileName = item.fileName
                                obj.expiredRemark = item.expiredRemark
                                obj.expiredType = item.expiredType
                            }
                            // 判断三证合一状态
                            if item.typeId == 21 || item.typeId == 22 || item.typeId == 23 {
                                // 非三证合一
                                is3Merge1 = false
                            }
                            else if item.typeId == 24 {
                                // 三证合一
                                is3Merge1 = true
                            }
                        } // for
                    }
                    else {
                        // （零售企业&批零一体）资质列表...<i == 2 || i == 3>
                        for item: ZZAllInOneFileModel in qcRetailList {
                            // 给非其它资质类model赋值
                            if let tid = obj.qualificationTypeId, tid == item.typeId, tid != 35, tid != 37 {
                                obj.id = item.id
                                obj.enterpriseId = item.enterpriseId
                                obj.numberQualification = item.qualificationNo
                                obj.startTimeQualification = item.starttime
                                obj.endTimeQualification = item.endtime
                                obj.imgUrlQualifiction = item.filePath
                                obj.fileName = item.fileName
                                obj.expiredRemark = item.expiredRemark
                                obj.expiredType = item.expiredType
                            }
                            // 判断三证合一状态
                            if item.typeId == 21 || item.typeId == 22 || item.typeId == 23 {
                                // 非三证合一
                                is3Merge1 = false
                            }
                            else if item.typeId == 24 {
                                // 三证合一
                                is3Merge1 = true
                            }
                            
                        } // for
                    }
                } // for
            } // if
            // 确定当前企业类型是否三证合一
            sectionModel.is3Merge1 = is3Merge1
        } // for
        
        /****************************************************/
        
        // 批发企业
        var listOther = [ZZFileModel]()
        // 零售企业
        var listRetailOther = [ZZAllInOneFileModel]()
        // 批零一体
        var listWholeOther = [ZZAllInOneFileModel]()
        // 筛选其它资质类型model
        for item: ZZFileModel in qcList {
            // 其它资质类model赋值
            if item.typeId == 35 {
                listOther.append(item)
            }
        } // for
        // 筛选其它资质类型model
        for item: ZZAllInOneFileModel in qcRetailList {
            // 其它资质类model赋值
            if item.typeId == 35 {
                listRetailOther.append(item)
            }
            else if item.typeId == 37 {
                listWholeOther.append(item)
            }
        } // for
        
        // 其它资质需单独处理
        for i in 0..<tabContentList.count {
            // section-model
            let sectionModel: RIQualificationModel = tabContentList[i]
            // qualification-list
            if let array = sectionModel.qualicationList, array.count > 0 {
                // 其它资质类型一般在最后
                let obj: RIQualificationItemModel = array.last!
                //
                if let typeid = obj.qualificationTypeId, (typeid == 35 || typeid == 37) {
                    if i == 0 {
                        // 无图片model的索引
                        let indexOther = array.count - 1
                        // 增加有图片的model
                        for item: ZZFileModel in listOther {
                            // 新建其它资质类型model，并赋值
                            let objNew: RIQualificationItemModel = obj.createNewModel()
                            objNew.id = item.id
                            objNew.enterpriseId = item.enterpriseId
                            objNew.numberQualification = item.qualificationNo
                            objNew.startTimeQualification = item.starttime
                            objNew.endTimeQualification = item.endtime
                            objNew.imgUrlQualifiction = item.filePath
                            objNew.fileName = item.fileName
                            obj.expiredRemark = item.expiredRemark
                            obj.expiredType = item.expiredType
                            sectionModel.qualicationList!.append(objNew)
                        } // for
                        if listOther.count == 0 {
                            // 无其它资质图片...<不作处理>
                        }
                        else if listOther.count >= maxCount {
                            // 其它资质图片已达最大数量...<删除前面无图片的model>
                            sectionModel.qualicationList!.remove(at: indexOther)
                        }
                        else {
                            // 有其它资质图片，且未达最大数量...<前面无图片的model移到最后>
                            sectionModel.qualicationList!.append(obj)
                            sectionModel.qualicationList!.remove(at: indexOther)
                        }
                    }
                    else if i == 1 {
                        // 无图片model的索引
                        let indexRetailOther = array.count - 1
                        // 增加有图片的model
                        for item: ZZAllInOneFileModel in listRetailOther {
                            // 新建其它资质类型model，并赋值
                            let objNew: RIQualificationItemModel = obj.createNewModel()
                            objNew.id = item.id
                            objNew.enterpriseId = item.enterpriseId
                            objNew.numberQualification = item.qualificationNo
                            objNew.startTimeQualification = item.starttime
                            objNew.endTimeQualification = item.endtime
                            objNew.imgUrlQualifiction = item.filePath
                            objNew.fileName = item.fileName
                            obj.expiredRemark = item.expiredRemark
                            obj.expiredType = item.expiredType
                            sectionModel.qualicationList!.append(objNew)
                        } // for
                        if listRetailOther.count == 0 {
                            // 无其它资质图片...<不作处理>
                        }
                        else if listRetailOther.count >= maxCount {
                            // 其它资质图片已达最大数量...<删除前面无图片的model>
                            sectionModel.qualicationList!.remove(at: indexRetailOther)
                        }
                        else {
                            // 有其它资质图片，且未达最大数量...<前面无图片的model移到最后>
                            sectionModel.qualicationList!.append(obj)
                            sectionModel.qualicationList!.remove(at: indexRetailOther)
                        }
                    }
                    else if i == 2 {
                        // 无图片model的索引
                        let indexWholeOther = array.count - 1
                        // 增加有图片的model
                        for item: ZZAllInOneFileModel in listWholeOther {
                            // 新建其它资质类型model，并赋值
                            let objNew: RIQualificationItemModel = obj.createNewModel()
                            objNew.id = item.id
                            objNew.enterpriseId = item.enterpriseId
                            objNew.numberQualification = item.qualificationNo
                            objNew.startTimeQualification = item.starttime
                            objNew.endTimeQualification = item.endtime
                            objNew.imgUrlQualifiction = item.filePath
                            objNew.fileName = item.fileName
                            obj.expiredRemark = item.expiredRemark
                            obj.expiredType = item.expiredType
                            sectionModel.qualicationList!.append(objNew)
                        } // for
                        if listWholeOther.count == 0 {
                            // 无其它资质图片...<不作处理>
                        }
                        else if listWholeOther.count >= maxCount {
                            // 其它资质图片已达最大数量...<删除前面无图片的model>
                            sectionModel.qualicationList!.remove(at: indexWholeOther)
                        }
                        else {
                            // 有其它资质图片，且未达最大数量...<前面无图片的model移到最后>
                            sectionModel.qualicationList!.append(obj)
                            sectionModel.qualicationList!.remove(at: indexWholeOther)
                        }
                    }
                }
                else {
                    // 最后一个不是其它资质类型...<error>
                }
            } // if
        } // for
    }
    
    // 对资质列表数据进行处理，并取出相关数据model组成展示数据源
    fileprivate func processQualificationListForShow() {
        tabTitleList.removeAll()
        guard tabContentList.count > 0 else {
            return
        }
        
        // 取各资质类型的tab标题
        for obj: RIQualificationModel in tabContentList {
            var title = "企业"
            if let titleQ = obj.qualificationTabName, titleQ.isEmpty == false {
                title = titleQ
            }
            tabTitleList.append(title)
        } // for
        
        // 设置各资质类型tab项是否显示三证合一
        for obj: RIQualificationModel in tabContentList {
            // 判断是否显示三证合一
            if let list = obj.qualicationList, list.count > 0 {
                // 当前资质列表有数据
                var show3Merge1 = false // 默认不显示三证合一开关
                for item in list {
                    if let is3Merge1 = item.is3Merge1, (is3Merge1 == 0 || is3Merge1 == 1) {
                        // 字段非空，则一定需要显示三证合一开关
                        show3Merge1 = true
                        break
                    }
                } // for
                obj.show3Merge1 = show3Merge1
            }
            else {
                // 当前资质列表无数据
                obj.show3Merge1 = false
            }
        } // for
        
        // 设置各资质类型tab项中的单个资质是否显示
        for obj: RIQualificationModel in tabContentList {
            // 初始化展示数据源
            obj.qualicationListShow.removeAll()
            // 默认三证合一开启~!@
            obj.is3Merge1 = (obj.show3Merge1 ? true : false)
            // 有数据
            if let list = obj.qualicationList, list.count > 0 {
                // 当前资质列表有数据
                
                // 1.判断当前企业类型中的三证合一状态
                if obj.show3Merge1 {
                    for item in list {
                        if let is3Merge1 = item.is3Merge1, (is3Merge1 == 0 || is3Merge1 == 1) {
                            // 与三证合一相关的资质项
                            if let txt = item.imgUrlQualifiction, txt.isEmpty == false {
                                // 当前资质项有图片
                                if is3Merge1 == 0 {
                                    obj.is3Merge1 = false
                                }
                                else {
                                    obj.is3Merge1 = true
                                }
                            }
                        }
                    } // for
                }
                
                // 2.抽取界面展示的资质项
                var index: Int = 0
                for item in list {
                    // 给每个资质item赋值tag
                    item.tagQualification = index
                    index = index + 1
                    
                    // 确定资质item的显示状态
                    if let is3Merge1 = item.is3Merge1, (is3Merge1 == 0 || is3Merge1 == 1) {
                        // 字段非空，则表示与三证合一有关，需进一步判断是否显示
                        if is3Merge1 == 0 {
                            // 组织机构代码证、税务登记证、营业执照...<三证合一时不显示>
                            item.showFlag = (obj.is3Merge1 ? false : true)
                        }
                        else {
                            // 统一社会信用代码...<三证合一时显示>
                            item.showFlag = (obj.is3Merge1 ? true : false)
                        }
                    }
                    else {
                        // 字段为空，则表示与三证合一无关，一定显示
                        item.showFlag = true
                    }
                    
                    // 保存可显示项
                    if item.showFlag {
                        obj.qualicationListShow.append(item)
                    }
                } // for
            }
            else {
                // 当前资质列表无数据
            }
        } // for
    }
    
    // 当前用户已上传的资质图片model转成可缓存的model类型...<为本地缓存作准备>
    fileprivate func handleImageModelForCache() {
        // 先置空
        zzImageModel = nil
        
        // 无资质列表
        guard tabContentList.count > 0 else {
            return
        }
        
        // （非批发企业or批发企业之非批零一体）资质列表
        var qcList = [ZZFileModel]()
        // （零售企业&批零一体）资质列表
        var qcRetailList = [ZZAllInOneFileModel]()
        
        // 遍历资质列表数组
        for i in 0..<tabContentList.count {
            // section-model
            let sectionModel: RIQualificationModel = tabContentList[i]
            // qualification-list
            if let array = sectionModel.qualicationList, array.count > 0 {
                // 遍历
                for obj: RIQualificationItemModel in array {
                    if i == 0 {
                        // （非批发企业or批发企业之非批零一体）资质列表
                        if let url = obj.imgUrlQualifiction, url.isEmpty == false {
                            // 保存有图片url的model
                            let item: ZZFileModel = ZZFileModel()
                            item.typeId = obj.qualificationTypeId ?? 0
                            item.qualificationNo = obj.numberQualification
                            item.starttime = obj.startTimeQualification
                            item.endtime = obj.endTimeQualification
                            item.filePath = obj.imgUrlQualifiction
                            item.fileName = obj.fileName
                            item.expiredRemark = obj.expiredRemark
                            item.expiredType = obj.expiredType
                            qcList.append(item)
                        }
                    }
                    else {
                        // （零售企业&批零一体）资质列表...<i == 2 || i == 3>
                        if let url = obj.imgUrlQualifiction, url.isEmpty == false {
                            // 保存有图片url的model
                            let item: ZZAllInOneFileModel = ZZAllInOneFileModel()
                            item.typeId = obj.qualificationTypeId ?? 0
                            item.qualificationNo = obj.numberQualification
                            item.starttime = obj.startTimeQualification
                            item.endtime = obj.endTimeQualification
                            item.filePath = obj.imgUrlQualifiction
                            item.fileName = obj.fileName
                            item.expiredRemark = obj.expiredRemark
                            item.expiredType = obj.expiredType
                            qcRetailList.append(item)
                        }
                    }
                } // for
            } // if
        } // for
        
        // 若两个数组均为空，则不缓存，说明用户没有上传图片
        guard qcList.count > 0 || qcRetailList.count > 0 else {
            print("未上传图片")
            return
        }
        
        // 新建model
        let zzModel: ZZModel = ZZModel()
        zzModel.qcList = qcList
        zzModel.qualificationRetailList = qcRetailList
        // 赋值<保存>
        zzImageModel = zzModel
    }
}


// MARK: - 封装入参

extension RIImageViewModel {
    // 参数合法性检测
    func checkSubmitStatus() -> (Bool, String?) {
        // 无资质列表
        guard tabContentList.count > 0 else {
            return (false, "获取数据失败，请返回重试")
        }
        
        // 遍历资质列表数组
        for i in 0..<tabContentList.count {
            // section-model
            let sectionModel: RIQualificationModel = tabContentList[i]
            // qualification-list
            let array = sectionModel.qualicationListShow
            if array.count > 0 {
                // 遍历item
                for obj: RIQualificationItemModel in array {
                    if let flag = obj.required, flag == true {
                        // 当前资质项必填
                        if let url = obj.imgUrlQualifiction, url.isEmpty == false {
                            // 有上传图片
                        }
                        else {
                            // 未上传图片
                            //                            var type = "[企业]"
                            //                            if let tValue = sectionModel.qualificationTabName, tValue.isEmpty == false {
                            //                                type = "[\(tValue)]"
                            //                            }
                            var title = "相关资质"
                            if let name = obj.qualificationName, name.isEmpty == false {
                                title = name
                            }
                            return (false, "请上传\(title)")
                        }
                    }
                } // for
            } // if
        } // for
        
        // 合法
        return (true, nil)
    }
    
    // 封装入参...<提交企业资质之图片内容>
    func getEnterpriseInfoData() -> [String: AnyObject] {
        //
        var params: [String: AnyObject] = [String: AnyObject]()
        
        /*
         说明：
         1.当前企业若为非批发企业or批发企业之非批零一体，直接把资质数据封装到qcDftList中
         2.当前企业若为批发企业之批零一体，则将批发企业资质封装到qcDftList中，将零售企业与批零一体两种资质共同封装到qualificationRetailList中
         */
        
        guard tabContentList.count > 0 else {
            return params
        }
        
        // 非批发企业or批发企业是否三证合一
        var is3merge1 = 0
        // 零售企业是否三证合一
        var is3merge2 = 0
        // 是否为批发企业之批零一体
        var is_wholesale_retail = 0
        // 非批发企业or批发企业资质列表
        var qcDftList = [RIQualificationItemModel]()
        // 零售企业&批零一体共同的资质列表
        var qualificationRetailList = [RIQualificationItemModel]()
        
        // 是否批零一体
        // 1. [非批发企业or批发企业之非批零一体]只有一个列表
        // 2. 批发企业之批零一体有三个列表
        if tabContentList.count > 1 {
            is_wholesale_retail = 1
        }
        
        for i in 0..<tabContentList.count {
            // 资质类型model
            let model = tabContentList[i]
            
            // 三证合一状态
            if i == 0 {
                // 非批发企业or批发企业
                is3merge1 = (model.is3Merge1 ? 1 : 0)
            }
            else if i == 1 {
                // 零售企业
                is3merge2 = (model.is3Merge1 ? 1 : 0)
            }
            
            // 资质列表
            if i == 0 {
                // 非批发企业or批发企业
                for item: RIQualificationItemModel in model.qualicationListShow {
                    // 有上传图片
                    if let imgurl = item.imgUrlQualifiction, imgurl.isEmpty == false {
                        item.isRetail = false // 非零售企业
                        qcDftList.append(item)
                    }
                } // for
            }
            else {
                // 零售企业...<i==1 or i==2>
                for item: RIQualificationItemModel in model.qualicationListShow {
                    // 有上传图片
                    if let imgurl = item.imgUrlQualifiction, imgurl.isEmpty == false {
                        item.isRetail = true // 零售企业
                        qualificationRetailList.append(item)
                    }
                } // for
            }
        } // for
        
        params["is3merge1"] = is3merge1 as AnyObject
        params["is3merge2"] = is3merge2 as AnyObject
        params["is_wholesale_retail"] = is_wholesale_retail as AnyObject
        if qcDftList.count > 0 {
            params["qcDftList"] = (qcDftList as NSArray).reverseToJSON() as AnyObject
        }
        if qualificationRetailList.count > 0 {
            params["qualificationRetailList"] = (qualificationRetailList as NSArray).reverseToJSON() as AnyObject
        }
        
        // map整体封装
        return ["map": params as AnyObject]
    }
}


/*
 上传/更新资质列表数据入参:
 {"qcDftList":[{"typeName":"组织机构代码证","typeId":"21","filePath":"\/img\/yc\/8b822c440367245c7a899e7a8899ef97.jpg","id":"144280","fileName":"8b822c440367245c7a899e7a8899ef97.jpg","enterpriseId":"144784"},{"typeName":"税务登记证","typeId":"22","filePath":"\/img\/yc\/f4d721d45d174d583b59b725db89496e.jpg","id":"144281","fileName":"f4d721d45d174d583b59b725db89496e.jpg","enterpriseId":"144784"},{"typeName":"营业执照","typeId":"23","filePath":"\/img\/yc\/cc176b83a9feaf8d77d2df8d853fe66d.jpg","id":"144282","fileName":"cc176b83a9feaf8d77d2df8d853fe66d.jpg","enterpriseId":"144784"},{"typeName":"药品经营质量管理规范（GSP证书）","typeId":"26","filePath":"\/img\/yc\/1c2cb2b88fe211549b03ead4f1a5e07f.jpg","id":"144283","fileName":"1c2cb2b88fe211549b03ead4f1a5e07f.jpg","enterpriseId":"144784"},{"typeName":"药品经营许可证","typeId":"27","filePath":"\/img\/yc\/281d55ef019b2a57449f90c84fceaef3.jpg","id":"144284","fileName":"281d55ef019b2a57449f90c84fceaef3.jpg","enterpriseId":"144784"},{"typeName":"发票开票资料","typeId":"41","filePath":"\/img\/yc\/070e97950537b863f36234bd6dd3d600.jpg","id":"144285","fileName":"070e97950537b863f36234bd6dd3d600.jpg","enterpriseId":"144784"},{"typeName":"采购员身份证（身份证正反面复印在一张A4纸上，盖店铺公章）","typeId":"42","filePath":"\/img\/yc\/f4db9eb6e65c0105d588f1a8dfa299bd.jpg","id":"144286","fileName":"f4db9eb6e65c0105d588f1a8dfa299bd.jpg","enterpriseId":"144784"},{"typeName":"采购委托书","typeId":"44","filePath":"\/img\/yc\/1bbd88c73e3706c2670875f4c394ec9b.jpg","id":"144287","fileName":"1bbd88c73e3706c2670875f4c394ec9b.jpg","enterpriseId":"144784"},{"typeName":"二类医疗器械经营许可证","typeId":"32","filePath":"\/img\/yc\/c285467d5dfcca78cd02248d2f71175f.jpg","id":"144288","fileName":"c285467d5dfcca78cd02248d2f71175f.jpg","enterpriseId":"144784"},{"typeName":"三类医疗器械经营许可证","typeId":"38","filePath":"\/img\/yc\/32f8ab302fc5d6cf00adf265505631ad.jpg","id":"144289","fileName":"32f8ab302fc5d6cf00adf265505631ad.jpg","enterpriseId":"144784"},{"typeName":"食品流通许可证","typeId":"33","filePath":"\/img\/yc\/3b040338cf4d09b40027619e2338ef8b.jpg","id":"144290","fileName":"3b040338cf4d09b40027619e2338ef8b.jpg","enterpriseId":"144784"},{"typeName":"其他资质","typeId":"35","filePath":"\/img\/yc\/6f7d90bce06e3e8b5f321ceaefee8f09.jpg","id":"144291","fileName":"6f7d90bce06e3e8b5f321ceaefee8f09.jpg","enterpriseId":"144784"},{"typeName":"其他资质","typeId":"35","filePath":"\/img\/yc\/9c67bc33d72ef087e5a6e4f3e25f7580.jpg","id":"144292","fileName":"9c67bc33d72ef087e5a6e4f3e25f7580.jpg","enterpriseId":"144784"}],"qualificationRetailList":[{"enterprise_id":"144784","file_name":"f2d424cab2e49fd58a8296295f08b854.jpg","type_name":"统一社会信用代码","file_path":"\/img\/yc\/f2d424cab2e49fd58a8296295f08b854.jpg","id":"117901","type_id":"24"},{"enterprise_id":"144784","file_name":"956cb73ca5557408d728a82b7ffd915a.jpg","type_name":"药品经营质量管理规范（GSP证书）","file_path":"\/img\/yc\/956cb73ca5557408d728a82b7ffd915a.jpg","id":"117902","type_id":"26"},{"enterprise_id":"144784","file_name":"f0485926afbf3764a27bf0d9aa5078bb.jpg","type_name":"药品经营许可证","file_path":"\/img\/yc\/f0485926afbf3764a27bf0d9aa5078bb.jpg","id":"117903","type_id":"27"},{"enterprise_id":"144784","file_name":"9a7eb1016d146a623b1074baad243d0c.jpg","type_name":"其他资质","file_path":"\/img\/yc\/9a7eb1016d146a623b1074baad243d0c.jpg","id":"117905","type_id":"35"},{"enterprise_id":"144784","file_name":"27404a95d0a1c04ddd94e832397c053e.jpg","type_name":"其他资质","file_path":"\/img\/yc\/27404a95d0a1c04ddd94e832397c053e.jpg","id":"117906","type_id":"35"},{"enterprise_id":"144784","file_name":"f693f9f920b588d8920d1c344847fe65.jpg","type_name":"批零一体资质证明文件","file_path":"\/img\/yc\/f693f9f920b588d8920d1c344847fe65.jpg","id":"117907","type_id":"36"},{"enterprise_id":"144784","file_name":"76547acbecbc51f8cdaa3161367a8fc5.jpg","type_name":"批零一体其它资质文件","file_path":"\/img\/yc\/76547acbecbc51f8cdaa3161367a8fc5.jpg","id":"117908","type_id":"37"}],"is_wholesale_retail":1,"is3merge1":0,"is3merge2":1}
 */
