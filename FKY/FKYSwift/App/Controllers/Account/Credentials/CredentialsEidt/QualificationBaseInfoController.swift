//
//  BaseInfoAppear.swift
//  FKY
//
//  Created by mahui on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  基本资料 or 原资料

import UIKit

class QualificationBaseInfoController: UIViewController {
    
    //MARK: Property
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(FKYCredentialsInfoCell.self, forCellWithReuseIdentifier: "FKYCredentialsInfoCell")
        view.register(FKYCredentialsInfoOneLineCell.self, forCellWithReuseIdentifier: "FKYCredentialsInfoOneLineCell")
        view.register(FKYCredentialsJustInfoCell.self, forCellWithReuseIdentifier: "FKYCredentialsJustInfoCell")
        view.register(FKYQualiticationImageCell.self, forCellWithReuseIdentifier: "FKYQualiticationImageCell")
        view.register(QualificationSegmentViewCCell.self, forCellWithReuseIdentifier: "QualificationSegmentViewCCell")
        view.register(FKYQualificationAppInfoCell.self, forCellWithReuseIdentifier: "FKYQualificationAppInfoCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.register(FKYCredentialsAddressCell.self, forCellWithReuseIdentifier: "FKYCredentialsAddressCell")
        view.register(FKYQualificationInfoSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYQualificationInfoSectionHeader")
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableDefaultFooterView")
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableDefaultHeaderView")
        return view
    }()
    
    fileprivate lazy var statusView: ZZStatusView = {
        let view = ZZStatusView()
        //
        view.checkOriginClource = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoading()
            strongSelf.baseInfoService.zzHasOriginInfo({ [weak self] (issuccess, message) in
                if let strongSelf = self {
                    strongSelf.dismissLoading()
                    if issuccess {
                        let vc = QualificationBaseInfoController()
                        FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
                        vc.isFromOriginInfo = true
                    }
                    else {
                        strongSelf.toast(message)
                    }
                }
            })
        }
        return view
    }()
    
    fileprivate var sectionAndRowContent: [[ZZEnterpriseInputType:[ZZEnterpriseInputType]]] = []
    fileprivate var selectedImageView: UIImageView?
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate var zzfileMap: [Int: [ZZFileProtocol]] = [:]
    fileprivate var selectedZZFileTag: Int = 0 // 当前tag
    
    var baseInfoService = CredentialsBaseInfoProvider()
    var isFromOriginInfo = false // YES use baseInfoService‘s baseinfo, NO use baseInfoService's input
    var param: [String:Int]?
    var canEidting = false // 默认不可编辑
    var navBar: UIView?
    var fromType: NSString?
    
    // 判断是否需要自动跳转到经营范围界面...<商详之不可购买<缺少经营范围>需要直接跳转到经营范围>
    var needJumpToDrugScope = false
    
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        self.setupNavbar()
        self.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("QualificationBaseInfoController deinit")
    }
    
    
    //MARK: - UI
    
    fileprivate func setupNavbar() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        
        if self.isFromOriginInfo {
            self.fky_setupTitleLabel("原资料")
        }
        else {
            self.fky_setupTitleLabel("基本资料")
        }
        
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_setupRightImage("") { [weak self] in
            if let strongSelf = self {
                strongSelf.toSubmitInfo()
            }
        }
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let type = strongSelf.fromType, type == "addAddress" {
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                }, isModal: false)
            }
            else {
                if let isCheck = strongSelf.baseInfoService.baseInfoModel?.enterprise?.isCheck, isCheck == 3 {
                    // 资质变更状态
                    FKYProductAlertView.show(withTitle: nil, leftTitle: "仍要离开", leftColor: .black, rightTitle: "提交审核", rightColor: RGBColor(0xFF2D5C), message: "您尚未提交资质审核。为了不影响您的购物体验，请尽快提交资质审核。", titleColor: nil, handler: { [weak self] (_, isRight) in
                        if let strongInSelf = self {
                            if isRight {
                                strongInSelf.toSubmitInfo()
                            }else{
                                FKYNavigator.shared().pop()
                            }
                        }
                    })
                }else{
                    FKYNavigator.shared().pop()
                }
                
            }
        }
        self.NavigationBarRightImage!.setTitle("提交审核", for: UIControl.State())
        self.NavigationBarRightImage!.isHidden = self.isFromOriginInfo
        self.NavigationBarRightImage!.fontTuple = t19
        self.fky_hiddedBottomLine(false)
    }
    
    //
    fileprivate func setupView() {
        statusView.checkOriginClource = { [weak self] in
            if let strongSelf = self {
                strongSelf.showLoading()
                strongSelf.baseInfoService.zzHasOriginInfo({[weak self] (issuccess, message) in
                    if let strongSelf = self {
                        strongSelf.dismissLoading()
                        if issuccess {
                            let vc = QualificationBaseInfoController()
                            FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
                            vc.isFromOriginInfo = true
                        }
                        else {
                            strongSelf.toast(message)
                        }
                    }
                })
            }
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo((navBar?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    
    //MARK: - Request
    
    // 请求基本资料数据
    fileprivate func requestData() {
        if self.isFromOriginInfo {
            // 查看原资料
            self.showLoading()
            self.baseInfoService.zzOriginInfo({ [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.canEidting = false // 固定不可编辑
                strongSelf.statusView.setStatusContent(statusDes: "", statusDesTextColor: nil , backroundColor: nil, isShowRightButton: false)
                strongSelf.statusView.setSelfZZStatus(qualityAudit: [])
                strongSelf.statusView.frame.size.height = 0
                strongSelf.sectionAndRowContent = strongSelf.baseInfoService.sectionTypeWithTypeForQualification()
                strongSelf.makeQCListData()
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
            })
        }
        else {
            // 基本资料页面
            self.showLoading()
            self.baseInfoService.queryBaseInfo{ [weak self] () in
                guard let strongSelf = self else {
                    return
                }
                var statusInfo:[String:AnyObject] = [:]
                if let statusCode = strongSelf.baseInfoService.baseInfoModel?.enterprise?.isCheck {
                    statusInfo = ZZUploadHelpFile().titleForZZStatus(statusCode)
                }
                else {
                    statusInfo = ZZUploadHelpFile().titleForZZStatus(-2)
                }
                
                if let codeString =  statusInfo["title"] as? String {
                    let canViewOriginInfo = statusInfo["originStatus"] as! Bool
                    strongSelf.canEidting = statusInfo["eidtStatus"] as! Bool
                    strongSelf.statusView.setStatusContent(statusDes: codeString, statusDesTextColor: (statusInfo["titleColor"] as? UIColor), backroundColor: (statusInfo["backGroundColor"] as? UIColor), isShowRightButton: canViewOriginInfo)
                    strongSelf.NavigationBarRightImage?.isHidden = !(codeString == "变更")
                }
                
                // 设置高度
                strongSelf.statusView.heightBackBlock = { [weak self] height in
                    if let strongInSelf = self {
                        strongInSelf.statusView.frame.size.height = height
                    }
                }
                
                let qualityAudit = strongSelf.baseInfoService.baseInfoModel?.qualityAuditList
                if qualityAudit != nil {
                    strongSelf.statusView.setSelfZZStatus(qualityAudit: qualityAudit!)
                }
                else {
                    strongSelf.statusView.setSelfZZStatus(qualityAudit: [])
                }
                strongSelf.sectionAndRowContent = strongSelf.baseInfoService.sectionTypeWithTypeForQualification()
                strongSelf.makeQCListData()
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
                
                //资质过期提示。自动跳转
                if let type = strongSelf.fromType, type == "expireData" {
                    let  path = IndexPath.init(row:0, section: strongSelf.sectionAndRowContent.count - 1)
                    strongSelf.collectionView.scrollToItem(at: path, at: .top, animated: false)
                }
                // 判断是否需要自动跳转到经营范围界面
                strongSelf.jumpToDrugScope()
            }
        }
    }
    
    
    //MARK: - Private
    
    // 自动跳转到经营范围界面
    fileprivate func jumpToDrugScope() {
        guard needJumpToDrugScope else {
            // 不需要自动跳转
            return
        }
        
        guard self.canEidting else {
            // 不可编辑
            return
        }
        
        // 只跳一次
        needJumpToDrugScope = false
        
        // 跳转经营范围
        let businessScopeVC = CredentialsBusinessScopeController()
        if let refuseReasonStr = self.baseInfoService.refuseReasonForSectionType(.DrugScope, zztype: nil) {
            businessScopeVC.refuseReason = refuseReasonStr
        }
        if let _ = self.baseInfoService.baseInfoModel?.drugScopeList {
            businessScopeVC.selectedScopes = self.baseInfoService.baseInfoModel?.drugScopeList
        }
        businessScopeVC.saveClosure = { [weak self] (scopeList) in
            guard let strongSelf = self else {
                return
            }
            // 保存经营范围
            strongSelf.baseInfoService.baseInfoModel?.drugScopeList = scopeList
            strongSelf.baseInfoService.updateDrugScope(strongSelf.completionHandler)
        }
        FKYNavigator.shared().topNavigationController.pushViewController(businessScopeVC, animated: true, snapshotFirst: false)
    }
    
    // 提交审核
    fileprivate func toSubmitInfo() {
        // 普通批发企业改变为批零一体企业时，提交审核前先验证资质是否上传
        if baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1 { // 是批零一体企业
            if zzfileMap.count > 1 {
                let arr = zzfileMap[1]
                if !validateSubmitQualitication(arr: arr!, viewType: .retail) {
                    self.toast("零售企业没有上传资质！")
                    return
                }
            }
            if zzfileMap.count > 2 {
                let arr = zzfileMap[2]
                if !validateSubmitQualitication(arr: arr!, viewType: .wholeSaleAndRetail) {
                    self.toast("批零一体没有上传资质！")
                    return
                }
            }
        }
        
        //根据经营范围来判断资质 viewtype 随意传 没影响
        if zzfileMap.count > 0 {
            let arr = zzfileMap[0]
            let (status, msg) = validateSubmitQualiticationForDrugScope(arr: arr!, viewType: .wholeSaleAndRetail)
            guard status == true else {
                // 不合法
                toast(msg)
                return
            }
        }
        
        self.showLoading()
        // 校验页面数据
        self.NavigationBarRightImage?.isUserInteractionEnabled = false
        DispatchQueue.global().async { [weak self] in
            if let strongSelf = self {
                //信息校验时间比较长，会阻塞主线程
                strongSelf.baseInfoService.checkEditEnterpriseBaseInfo({ (issuccess, reason) in
                    if issuccess == false {
                        DispatchQueue.main.async { [weak self] in
                            if let strongSelf = self {
                                strongSelf.NavigationBarRightImage?.isUserInteractionEnabled = true
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async { [weak self] in
                            if let strongSelf = self {
                                strongSelf.baseInfoService.submitToService(["is3merge1":(strongSelf.baseInfoService.baseInfoModel?.enterprise?.is3merge1)! as AnyObject], complete: { [weak self] (result, message) in
                                    if let strongSelf = self {
                                        strongSelf.NavigationBarRightImage?.isUserInteractionEnabled = true
                                        strongSelf.dismissLoading()
                                        strongSelf.toast(message)
                                    }
                                    if result {
                                        let vc = CredentialsCompleteViewController()
                                        FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
                                    }
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
    //
    fileprivate func validateSubmitQualitication(arr: [ZZFileProtocol], viewType: QualiticationViewType) -> Bool {
        let is3merge1 = baseInfoService.baseInfoModel?.enterpriseRetail?.is3merge1 == 1 // 零售企业是否三证合一
        let roleType = baseInfoService.baseInfoModel?.enterprise?.roleType
        
        // 所有非必填  对于 二三类医疗器械经营许可和食品放在下面的方法里校验32, 33,38
        var notMustUploadFileType = [2, 28, 29, 30, 31, 32, 33,38, 35, 37,41,42,44]
        
        if 1 != roleType && 3 != roleType {
            // 批发类型的企业，26这种需要改为必填
            notMustUploadFileType.append(26)
        }
        
        if viewType != .undefined && viewType != .wholeSale {
            // 质保协议必填
            notMustUploadFileType.append(45)
        }
        
        // 当前用户所有已经填写的必填项
        let toCheckImageFiles = (arr as NSArray).filtered(using: NSPredicate(format: "NOT (typeId IN %@)", notMustUploadFileType))
        // 当前类型企业的所有必填
        if let enterpriseTypeList = baseInfoService.baseInfoModel?.listTypeInfo {
            let qcTypes = ZZUploadHelpFile().fetchTypeList(viewType, is3merge1: is3merge1, typeList: enterpriseTypeList,roleType: roleType!)
            let mustUploadFileType = qcTypes.filter { (fileType) -> Bool in
                return !notMustUploadFileType.contains(fileType.rawValue)
            }
            if toCheckImageFiles.count < mustUploadFileType.count {
                // 至少有一个必填项无值
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    
    //对于 二三类医疗器械经营许可和食品放在下面的方法里校验
    fileprivate func validateSubmitQualiticationForDrugScope(arr: [ZZFileProtocol], viewType: QualiticationViewType) -> (Bool,String) {
        
        // 所有必填
        var mustUploadFileType = [Int]()
        
        // 二级医疗器械  经营范围256 资质id 32
        if let instrumentsLic = (baseInfoService.baseInfoModel?.drugScopeList! as! NSArray).filtered(using: NSPredicate(format: "drugScopeId == '256'")) as? [DrugScopeModel] {
            if instrumentsLic.isEmpty == false{
                mustUploadFileType.removeAll()
                mustUploadFileType.append(32)
                let toCheckImageFiles = (arr as NSArray).filtered(using: NSPredicate(format: "(typeId IN %@)", mustUploadFileType))
                if toCheckImageFiles.isEmpty == true{
                    return (false,"请上传二类医疗器械经营许可证")
                }
            }
        }
        
        //三级医疗器械  257 38
        if let threeInstrumentsLic = (baseInfoService.baseInfoModel?.drugScopeList! as! NSArray).filtered(using: NSPredicate(format: "drugScopeId == '257'")) as? [DrugScopeModel] {
            if threeInstrumentsLic.isEmpty == false{
                mustUploadFileType.removeAll()
                mustUploadFileType.append(38)
                let toCheckImageFiles = (arr as NSArray).filtered(using: NSPredicate(format: "(typeId IN %@)", mustUploadFileType))
                if toCheckImageFiles.isEmpty == true{
                    return (false,"请上传三类医疗器械经营许可证")
                }
            }
        }
        
        //食品 食品 260 33
        if let foodLic = (baseInfoService.baseInfoModel?.drugScopeList! as! NSArray).filtered(using: NSPredicate(format: "drugScopeId == '260'")) as? [DrugScopeModel] {
            if foodLic.isEmpty == false{
                mustUploadFileType.removeAll()
                mustUploadFileType.append(33)
                // 当前用户所有已经填写的必填项
                let toCheckImageFiles = (arr as NSArray).filtered(using: NSPredicate(format: "(typeId IN %@)", mustUploadFileType))
                if toCheckImageFiles.isEmpty == true{
                    return (false,"请上传食品流通许可证")
                }
            }
        }
        
        return (true,"")
    }
    
    // 跳转子界面
    fileprivate func pushNextVCWhenCanEdit(_ sectionType: ZZEnterpriseInputType) {
        switch sectionType {
        case .BaseInfo: // 修改基本资料
            if !self.canEidting {
                return
            }
            let vc = QualiticationEidtBaseInfoController()
            if let zzModel = baseInfoService.baseInfoModel {
                vc.setEnterpriseBaseInfoUse(baseInfo: zzModel)
            } else {
                vc.setEnterpriseBaseInfoUse(baseInfo: baseInfoService.inputBaseInfo)
            }
            
            if let errorContent = self.baseInfoService.refuseReasonForSectionType(sectionType, zztype: nil) {
                vc.textTips = errorContent
            }
            // 保存企业基本信息
            vc.saveClosure = {[weak self] (enterpriseName, enterpriseType, location, addressDetail,legalPersonname) in
                if let strongSelf = self {
                    // 新增了企业类型~!@
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.enterpriseName = enterpriseName
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.addressProvinceDetail = location
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.registeredAddress = addressDetail
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.type_id = enterpriseType
                    if strongSelf.baseInfoService.baseInfoModel?.enterprise?.roleType == 3{ //批发企业
                        strongSelf.baseInfoService.baseInfoModel?.enterprise?.legalPersonname = legalPersonname
                    }
                    // 保存
                    strongSelf.baseInfoService.createSaveEnterpriseInfo(false, complete: strongSelf.completionHandler)
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
            break
        case .WholeSaleAndRetailInfo: // 修改批发零售信息
            if !self.canEidting {
                return
            }
            let vc = QualiticationEditWholeSaleRetailController()
            if let zzModel = baseInfoService.baseInfoModel {
                vc.configZZModel(baseInfo: zzModel)
            } else {
                vc.configZZModel(baseInfo: baseInfoService.inputBaseInfo)
            }
            
            if let errorContent = self.baseInfoService.refuseReasonForSectionType(sectionType, zztype: nil) {
                vc.textTips = errorContent
            }
            // 保存企业基本信息
            vc.saveClosure = { [weak self] (enterpriseName, isWholeSaleRetail, location, addressDetail, shopNum) in
                if let strongSelf = self {
                    strongSelf.baseInfoService.baseInfoModel?.enterpriseRetail?.enterpriseName = enterpriseName
                    strongSelf.baseInfoService.baseInfoModel?.enterpriseRetail?.addressProvinceDetail = location
                    strongSelf.baseInfoService.baseInfoModel?.enterpriseRetail?.registeredAddress = addressDetail
                    strongSelf.baseInfoService.baseInfoModel?.enterpriseRetail?.shopNum = shopNum
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail = isWholeSaleRetail ? 1 : 0
                    // 保存
                    strongSelf.baseInfoService.createSaveEnterpriseInfo(false, complete: strongSelf.completionHandler)
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
            break
        case .DrugScope: // 经营范围
            if !self.canEidting {
                // 不可编辑
                let businessScopeVC = QualiticationBusniessScopeController()
                businessScopeVC.refuseReason = self.baseInfoService.refuseReasonForSectionType(.DrugScope, zztype: nil)
                businessScopeVC.zzinfoModel = self.baseInfoService.baseInfoModel
                FKYNavigator.shared().topNavigationController.pushViewController(businessScopeVC, animated: true, snapshotFirst: false)
            }
            else {
                // 经营范围
                let businessScopeVC = CredentialsBusinessScopeController()
                if let refuseReasonStr = self.baseInfoService.refuseReasonForSectionType(.DrugScope, zztype: nil) {
                    businessScopeVC.refuseReason = refuseReasonStr
                }
                if let _ = self.baseInfoService.baseInfoModel?.drugScopeList {
                    businessScopeVC.selectedScopes = self.baseInfoService.baseInfoModel?.drugScopeList
                }
                businessScopeVC.saveClosure = { [weak self] (scopeList) in
                    if let strongSelf = self {
                        // 保存经营范围
                        strongSelf.baseInfoService.baseInfoModel?.drugScopeList = scopeList
                        strongSelf.baseInfoService.updateDrugScope(strongSelf.completionHandler)
                    }
                }
                FKYNavigator.shared().topNavigationController.pushViewController(businessScopeVC, animated: true, snapshotFirst: false)
            }
            break
        case .DeliveryAddress: // 收货地址
            if !self.canEidting {
                return
            }
            let addressDetailVC = CredentialsAddressSendViewController()
            addressDetailVC.fromType = "add"
            addressDetailVC.address = self.baseInfoService.getQualificationDeliveryAddressInfo(.DeliveryAddress)
            // 保存地址
            addressDetailVC.saveClosure = { [weak self] address in
                if let strongSelf = self {
                    strongSelf.showLoading()
                    if strongSelf.baseInfoService.getQualificationDeliveryAddressInfo(.DeliveryAddress) != nil {
                        // 更新地址
                        strongSelf.baseInfoService.updateAddress(address, complete: {(issuccess, message) in
                            strongSelf.toast(message)
                            // 获取地址列表
                            // self!.baseInfoService.getAddressList({ [weak self] in
                            strongSelf.dismissLoading()
                            strongSelf.requestData()
                            // })
                        })
                    }
                    else {
                        // 新增地址
                        strongSelf.baseInfoService.addAddress(address, complete: {(issuccess, addr, message) in
                            if issuccess {
                                strongSelf.toast("保存成功")
                            }
                            else {
                                //self!.toast("保存失败")
                                var msg = "保存失败"
                                if let message = message, message.isEmpty == false {
                                    msg = message
                                }
                                strongSelf.toast(msg)
                            }
                            // 获取地址列表
                            //self!.baseInfoService.getAddressList({ [weak self] in
                            strongSelf.dismissLoading()
                            strongSelf.requestData()
                            //})
                        })
                    }
                }
            }
             FKYNavigator.shared().topNavigationController.pushViewController(addressDetailVC, animated:true, snapshotFirst: false)
            break
        case .BankInfo: // 企业银行信息
            let BankInfoVC = CredentialsBankInfoController()
            BankInfoVC.useFor = .forUpdate
            if let bankInfoModel = self.baseInfoService.baseInfoModel?.bankInfoModel {
                BankInfoVC.bankInfoModel = bankInfoModel
            }
            BankInfoVC.canEdit = self.canEidting
            BankInfoVC.refuseReason = self.baseInfoService.refuseReasonForSectionType(.BankInfo, zztype: nil)
            BankInfoVC.saveClosure = { [weak self] bankInfoModel in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.baseInfoService.baseInfoModel?.bankInfoModel = bankInfoModel
                strongSelf.baseInfoService.createSaveEnterpriseInfo(true, complete: strongSelf.completionHandler)
            }
            FKYNavigator.shared().topNavigationController.pushViewController(BankInfoVC, animated: true, snapshotFirst: false)
            break
        case .SaleSet: // 销售设置
            if !self.canEidting {
                return
            }
            let destrictManageVC = CredentialsSalesDestrictManageController()
            destrictManageVC.useFor = .forUpdate
            destrictManageVC.orderPrice = self.baseInfoService.baseInfoModel?.enterprise?.orderSAmount
            destrictManageVC.refuseReason = self.baseInfoService.refuseReasonForSectionType(.SaleSet, zztype: nil)
            if let districtArray = self.baseInfoService.baseInfoModel?.deliveryAreaList {
                destrictManageVC.selesDestrictArray = districtArray
            }
            destrictManageVC.saveClosure = {[weak self] (price, districts) in
                if let strongSelf = self {
                    // 销售区域
                    strongSelf.baseInfoService.baseInfoModel?.deliveryAreaList = districts
                    strongSelf.baseInfoService.baseInfoModel?.enterprise?.orderSAmount = price
                    strongSelf.baseInfoService.saveDeliveryAreaList(strongSelf.completionHandler)
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(destrictManageVC, animated: true, snapshotFirst: false)
            break
        case .ZZfile: // 资质文件
            if !self.canEidting {
                return
            }
            // 跳转
            FKYNavigator.shared()?.openScheme(FKY_RIImageController.self, setProperty: { [weak self] (vc) in
                if let strongSelf = self {
                    let controller: RIImageController = vc as! RIImageController
                    controller.showMode = .update // 查看并修改
                    if let model = strongSelf.baseInfoService.baseInfoModel {
                        controller.zzModel = model
                    }
                }
                }, isModal: false, animated: true)
            break
        default:
            break
        }
    }
    
    //MARK: 过滤掉银行信息图片
    fileprivate func makeQCListData() {
        // 重置
        zzfileMap = [:]
        
        // 非空
        guard let zzModel = self.baseInfoService.baseInfoModel, let enterpriseTypeList = zzModel.listTypeInfo else {
            return
        }
        
        // helper
        let fileHelper = ZZUploadHelpFile()
        
        // 非批零一体 & 批零一体的批发企业
        let enterpriseSelect: Bool = (self.baseInfoService.baseInfoModel?.enterprise?.is3merge1 == 1) // 是否三证合一
        let isWholeSaleRetail: Bool = (baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1) // 是否为批零一体
        let viewType: QualiticationViewType = (isWholeSaleRetail ? .wholeSale : .undefined) // 是否为批零一体之批发企业 or 非批零一体
        let dataSourceOne = fileHelper.fetchTypeList(viewType, is3merge1: enterpriseSelect, typeList: enterpriseTypeList,roleType: (zzModel.enterprise?.roleType)! )
        var tagNumberOneArray: [ZZFileProtocol] = []
        if let qcsList = zzModel.qcList {
            for qcType in dataSourceOne {
                if let alreadyUploadFileModel = (qcsList as NSArray).filtered(using: NSPredicate(format: "typeId == \(qcType.rawValue)")) as? [ZZFileProtocol] {
                    tagNumberOneArray.append(contentsOf: alreadyUploadFileModel)
                }
            }
        }
        zzfileMap[0] = tagNumberOneArray
        
        // 如果是批零一体 处理 零售企业 & 批零一体
        if isWholeSaleRetail {
            var tagNumberTwoArray: [ZZFileProtocol] = []
            var tagNumberThreeArray: [ZZFileProtocol] = []
            
            // 零售企业
            let enterpriseRetailSelect: Bool = (self.baseInfoService.baseInfoModel?.enterpriseRetail?.is3merge1 == 1) // 是否为三证合一
            let dataSourceTwo = fileHelper.fetchTypeList(.retail, is3merge1: enterpriseRetailSelect, typeList: enterpriseTypeList,roleType: (zzModel.enterprise?.roleType)!)
            let dataSourceThree = fileHelper.fetchTypeList(.wholeSaleAndRetail, is3merge1: enterpriseRetailSelect, typeList: enterpriseTypeList,roleType: (zzModel.enterprise?.roleType)!)
            if let qcsList = zzModel.qualificationRetailList {
                for qcType in dataSourceTwo {
                    if let alreadyUploadFileModel = (qcsList as NSArray).filtered(using: NSPredicate(format: "typeId == \(qcType.rawValue)")) as? [ZZFileProtocol] {
                        tagNumberTwoArray.append(contentsOf: alreadyUploadFileModel)
                    }
                }
                for qcType in dataSourceThree {
                    if let alreadyUploadFileModel = (qcsList as NSArray).filtered(using: NSPredicate(format: "typeId == \(qcType.rawValue)")) as? [ZZFileProtocol] {
                        tagNumberThreeArray.append(contentsOf: alreadyUploadFileModel)
                    }
                }
            }
            
            zzfileMap[1] = tagNumberTwoArray
            zzfileMap[2] = tagNumberThreeArray
        }
    }
    
    // 更新结束接口
    fileprivate func completionHandler(_ issuccess: Bool, message: String?) {
        if issuccess == true {
            // 更新信息成功后，需再调一次接口刷新界面数据~!@
            if  message == "成功"{
                 self.requestData()
            }else{
                //资质修改提示
                let alert = COAlertView.init(frame: CGRect.zero)
                alert.configView(message ?? "", "", "", "确定", .oneBtn)
                alert.showAlertView()
                alert.doneBtnActionBlock = {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.requestData()
                }
            }
        }
        else {
            self.toast(message, time: 2)
        }
    }
    
    //MARK: - 查看大图
    fileprivate func showPhotoBrowser(_ image: UIImage?, url: String, superView: UIView) {
        if url.isEmpty == true, image == nil {
            return
        }
        
        // imageview
        //        let imgview = UIImageView.init(frame: CGRect.init(x: (SCREEN_WIDTH - WH(0)) / 2, y: (SCREEN_HEIGHT - WH(0)) / 2, width: WH(0), height: WH(0)))
        //        imgview.contentMode = UIViewContentMode.scaleAspectFit
        //        if let img = image {
        //            // 有图片
        //            if img.size.width == 800, img.size.height == 800 {
        //                // 默认占用图，非用户上传图...<占用图800*800>
        //                imgview.sd_setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "image_default_img"))
        //            }
        //            else {
        //                // 用户上传图片
        //                imgview.image = img
        //            }
        //        }
        //        else {
        //            imgview.sd_setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "image_default_img"))
        //        }
        //        // 新版查看大图
        //        let imageViewer = XHImageViewer.init()
        //        imageViewer.showPageControl = true
        //        imageViewer.userPageNumber = true
        //        imageViewer.hideWhenOnlyOne = true
        //        imageViewer.showSaveBtn = true
        //        imageViewer.show(withImageViews: [imgview], selectedView: imgview)
        
        /*
         说明：关于资质相关的四个查看大图功能，需要有保存与旋转图片功能。
         */
        
        //
        let photo = SKPhoto.photoWithImageURL(url)
        photo.shouldCachePhotoURLImage = true
        //
        let browser = SKPhotoBrowser(originImage: image!, photos: [photo], animatedFromView: superView)
        browser.initializePageIndex(0)
        browser.delegate = self
        if #available(iOS 13, *) {
            browser.modalPresentationStyle = .fullScreen
        }
        FKYNavigator.shared().topNavigationController.present(browser, animated: true, completion: nil)
    }
    
    fileprivate func uploadImageWrongTips(_ fileType: Int,_ sectionNum:Int) -> NSAttributedString {
        if let fileTypeTitle = ZZUploadHelpFile().sectionTitle(fileType) {
            if let errorContent = self.baseInfoService.baseInfoModel?.refuseReasonForSectionCellType(ZZEnterpriseInputType.ZZfile, zztype: fileType,sectionNum), errorContent != "" {
                let allImageDes = "\(fileTypeTitle)\n\(errorContent)"
                let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = 10
                paragraphStyle.alignment = .left
                mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                
                mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x343434),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E ),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: errorContent))
                return NSAttributedString(attributedString: mutabelAttribute)
            }
            else {
                let mutabelAttribute = NSMutableAttributedString(string: fileTypeTitle)
                mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x161616),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15))], range: NSMakeRange(0, fileTypeTitle.count))
                return NSAttributedString(attributedString: mutabelAttribute)
            }
        }
        return NSAttributedString(string: "")
    }
}


//MARK: - UICollectionViewDelegate
extension QualificationBaseInfoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionAndRowContent.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[section-1]
        if let sectionType = sectionInfo.keys.first {
            switch sectionType {
            case .BaseInfo: // 基本信息
                fallthrough
            case .WholeSaleAndRetailInfo: // 批发零售信息
                fallthrough
            case .DrugScope: // 经营范围
                fallthrough
            case .DeliveryAddress: // 收货地址
                fallthrough
            case .BankInfo: // 企业银行信息
                fallthrough
            case .SaleSet: // 销售设置
                fallthrough
            case .LegalInfo: // 企业法人信息
                if let rowCount = sectionInfo[sectionType]?.count {
                    return rowCount
                }
                return 0
            case .ZZfile: // 资质文件
                if selectedZZFileTag > zzfileMap.count - 1 {
                    selectedZZFileTag = 0
                }
                let dataSource: [ZZFileProtocol] = zzfileMap[selectedZZFileTag]!
                let segmentRow = baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1 ? 1 : 0
                return dataSource.count + segmentRow
            default:
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.contentView.addSubview(self.statusView)
            self.statusView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(cell)
            }
            return cell
        }
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[indexPath.section-1]
        if let sectionType = sectionInfo.keys.first {
            if .ZZfile != sectionType {
                if let rowInfo: ZZEnterpriseInputType = sectionInfo[sectionType]?[indexPath.row] {
                    switch rowInfo {
                    case .EnterpriseType: // 企业类型
                        fallthrough
                    case .WholeSaleType: // 批发企业模式
                        fallthrough
                    case .EnterpriseLegalPerson: //企业法人
                        fallthrough
                    case .ShopNum: // 批零一体门店数
                        fallthrough
                    case .BankCode: // 银行账号
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsInfoOneLineCell", for: indexPath) as! FKYCredentialsInfoOneLineCell
                        cell.configCell(title: rowInfo.rawValue, contentTitle: self.baseInfoService.getQualificationBaseRowInfo(rowInfo))
                        return cell
                    case .EnterpriseName: // 企业名称
                        fallthrough
                    case .RetailEnterpriseName: // 零售企业名称
                        fallthrough
                    case .RetailLocation: // 零售企业所在地区
                        fallthrough
                    case .Location: // 所在地区
                        fallthrough
                    case .BankName: // 开户银行
                        fallthrough
                    case .BankAccountName: // 开户名
                        fallthrough
                    case .BasePrice: // 订单起售金额
                        fallthrough
                    case .SalesDistrict: // 卖方销售区域
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsInfoCell", for: indexPath) as! FKYCredentialsInfoCell
                        cell.configCell(title: rowInfo.rawValue, contentTitle: self.baseInfoService.getQualificationBaseRowInfo(rowInfo))
                        return cell
                    case .DrugScope: // 经营范围
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsJustInfoCell", for: indexPath) as! FKYCredentialsJustInfoCell
                        cell.configCell(content: self.baseInfoService.getQualificationBaseRowInfo(rowInfo))
                        return cell
                    case .DeliveryAddress: // 收发货地址
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsAddressCell", for: indexPath) as! FKYCredentialsAddressCell
                        cell.configCell(self.baseInfoService.getQualificationDeliveryAddressInfo(rowInfo))
                        cell.addAddressBlock = { [weak self] in
                            if let strongSelf = self {
                                let addressDetailVC = CredentialsAddressSendViewController()
                                addressDetailVC.fromType = "add"
                                //
                                addressDetailVC.saveClosure = { address in
                                    strongSelf.showLoading()
                                    // 新增地址
                                    strongSelf.baseInfoService.addAddress(address, complete: {(issuccess, addr, message) in
                                        if issuccess {
                                            strongSelf.toast("保存成功")
                                        }
                                        else {
                                            var msg = "保存失败"
                                            if let message = message, message.isEmpty == false {
                                                msg = message
                                            }
                                            strongSelf.toast(msg)
                                        }
                                        
                                        // 获取地址列表
                                        // strongSelf.baseInfoService.getAddressList({ [weak self] in
                                        strongSelf.dismissLoading()
                                        strongSelf.requestData()
                                        // })
                                    })
                                }
                                FKYNavigator.shared().topNavigationController.pushViewController(addressDetailVC, animated:true, snapshotFirst: false)
                            }
                            
                        }
                        return cell
                    case .LegalInfo: // 底部信息
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualificationAppInfoCell", for: indexPath) as! FKYQualificationAppInfoCell
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                        return cell
                    }
                }
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                    return cell
                }
            }
            else {
                // 资质图片文件Cell
                let isWholeSaleRetail = baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1
                let zzfileRow = isWholeSaleRetail ? (indexPath.row - 1) : indexPath.row
                
                // 批零一体segment cell
                if indexPath.row == 0, isWholeSaleRetail {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QualificationSegmentViewCCell", for: indexPath) as! QualificationSegmentViewCCell
                    cell.indexChangeBlock = {[weak self] index in
                        if let strongSelf = self {
                            strongSelf.selectedZZFileTag = index
                            collectionView.reloadData()
                        }
                    }
                    return cell
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualiticationImageCell", for: indexPath) as! FKYQualiticationImageCell
                let currentZZFileDataSource: [ZZFileProtocol] = zzfileMap[selectedZZFileTag]!
                let imageFileMode = currentZZFileDataSource[zzfileRow]
                if let filePath = imageFileMode.filePath, filePath != "" {
                    // 查看大图
                    cell.viewLargerImageClosure = {[weak self] (image, imageView) in
                        if let strongSelf = self {
                            strongSelf.selectedImageView = imageView
                            strongSelf.showPhotoBrowser(image, url: filePath, superView: imageView)
                        }
                    }
                }
                if 0 != imageFileMode.typeId {
                    cell.configCell(imageUrl: imageFileMode.filePath, title: self.uploadImageWrongTips(imageFileMode.typeId,selectedZZFileTag),imageFileMode.expiredRemark ?? "")
                }
                else {
                    cell.configCell(imageUrl: imageFileMode.filePath, title: NSAttributedString(string: ""),imageFileMode.expiredRemark ?? "")
                }
                
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[indexPath.section-1]
        if let sectionType = sectionInfo.keys.first {
            switch sectionType {
            case .BaseInfo: // 基本信息
                fallthrough
            case .WholeSaleAndRetailInfo: // 批发零售信息
                fallthrough
            case .DrugScope: // 经营范围
                fallthrough
                //            case .EnterpriseLegalPerson: //企业法人
            //                fallthrough
            case .DeliveryAddress: // 收货地址
                fallthrough
            case .BankInfo: // 企业银行信息
                fallthrough
            case .SaleSet: // 销售设置
                fallthrough
            case .ZZfile: // 资质文件
                if kind == UICollectionView.elementKindSectionHeader {
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FKYQualificationInfoSectionHeader", for: indexPath) as! FKYQualificationInfoSectionHeader
                    // 查看详情
                    view.didSelectedClosure = { [weak self] in
                        if let strongSelf = self {
                            strongSelf.pushNextVCWhenCanEdit(sectionType)
                        }
                    }
                    let errorContent = self.baseInfoService.refuseReasonForSectionType(sectionType, zztype: nil)
                    var isCanEdit = self.canEidting
                    //银行信息和销售设置在，基本资料中的待电子审核的时候可以查看
                    if (.DrugScope == sectionType || .BankInfo == sectionType) {
                        //在“基本资料”和“原资料”，可以查看更多关于“银行信息”和“经营范围”
                        if !self.canEidting {
                            isCanEdit = true
                        }
                    }
                    view.configCell(title: sectionType.rawValue, rightTitle: errorContent, canEdit: isCanEdit)
                    return view
                }
                else {
                    let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableDefaultFooterView", for: indexPath)
                    view.backgroundColor = RGBColor(0xF5F5F5)
                    return view
                }
            case .LegalInfo: // 企业法人信息
                if kind == UICollectionView.elementKindSectionHeader{
                    let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableDefaultHeaderView", for: indexPath)
                    view.backgroundColor = UIColor.white
                    return view
                }
                else {
                    let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableDefaultFooterView", for: indexPath)
                    view.backgroundColor = UIColor.white
                    return view
                }
            default:
                if kind == UICollectionView.elementKindSectionHeader{
                    let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableDefaultHeaderView", for: indexPath)
                    return view
                }
                else {
                    let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableDefaultFooterView", for: indexPath)
                    return view
                }
            }
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableDefaultHeaderView", for: indexPath)
            return view
        }
        else {
            let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableDefaultFooterView", for: indexPath)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize.zero
        }
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[section-1]
        if let sectionType = sectionInfo.keys.first {
            switch sectionType {
            case .BaseInfo:
                fallthrough
            case .WholeSaleAndRetailInfo:
                fallthrough
            case .DrugScope:
                fallthrough
            case .DeliveryAddress:
                fallthrough
            case .BankInfo:
                fallthrough
            case .SaleSet:
                fallthrough
                //            case .EnterpriseLegalPerson: //企业法人
            //                fallthrough
            case .ZZfile:
                return CGSize(width: SCREEN_WIDTH, height: WH(10))
            case .LegalInfo:
                fallthrough
            default:
                return CGSize.zero
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[section-1]
        if let sectionType = sectionInfo.keys.first {
            switch sectionType {
            case .BaseInfo:
                fallthrough
                //            case .EnterpriseLegalPerson: //企业法人
            //                fallthrough
            case .WholeSaleAndRetailInfo:
                fallthrough
            case .DrugScope:
                fallthrough
            case .DeliveryAddress:
                fallthrough
            case .BankInfo:
                fallthrough
            case .SaleSet:
                fallthrough
            case .ZZfile:
                return CGSize(width: SCREEN_WIDTH, height: WH(46))
            case .LegalInfo:
                fallthrough
            default:
                return CGSize.zero
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: SCREEN_WIDTH, height: self.statusView.frame.size.height + 0.1)
        }
        
        let sectionInfo: [ZZEnterpriseInputType:[ZZEnterpriseInputType]] = sectionAndRowContent[indexPath.section-1]
        
        if let sectionType = sectionInfo.keys.first {
            if .ZZfile != sectionType {
                if let rowInfo: ZZEnterpriseInputType = sectionInfo[sectionType]?[indexPath.row] {
                    switch rowInfo {
                    case .EnterpriseType:
                        fallthrough
                    case .EnterpriseLegalPerson: //企业法人
                        fallthrough
                    case .WholeSaleType: // 批发企业模式
                        fallthrough
                    case .BankCode:
                        return CGSize(width: SCREEN_WIDTH, height: WH(30))
                    case .DrugScope: // 经营范围
                        let drugScopeString = self.baseInfoService.getQualificationBaseRowInfo(rowInfo);
                        guard let content = drugScopeString, content.isEmpty == false else {
                            return CGSize(width: SCREEN_WIDTH, height: WH(30))
                        }
                        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(16))]
                        let size = (content as NSString).boundingRect(with: CGSize(width:SCREEN_WIDTH - WH(16) * 2, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
                        var height: CGFloat = size.height + WH(2) + WH(10) // 加上计算误差 及 上下间隔
                        // 最低高度
                        if height <= WH(30) {
                            height = WH(30)
                        }
                        return CGSize(width: SCREEN_WIDTH, height: height)
                    case .DeliveryAddress:
                        if self.baseInfoService.getQualificationDeliveryAddressInfo(.DeliveryAddress) != nil {
                            let address: ZZReceiveAddressModel? = self.baseInfoService.getQualificationDeliveryAddressInfo(.DeliveryAddress)
                            let drugScopeString:String?
                            if (address?.print_address) != nil {
                                drugScopeString = "仓库地址：" + (address?.print_address)!
                            }
                            else {
                                drugScopeString = "仓库地址："
                            }
                            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14))]
                            
                            let receiveAddressSize = address?.addressDetailDesc.boundingRect(with: CGSize(width:SCREEN_WIDTH - WH(20), height:WH(42) + WH(15)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
                            let size = drugScopeString?.boundingRect(with: CGSize(width:SCREEN_WIDTH - WH(20), height:WH(42) + WH(10)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
                            return CGSize(width: SCREEN_WIDTH, height: (WH(62 + 5 + 5 + 10 + 10 ) + WH(50) + size!.height + receiveAddressSize!.height + WH(14)))
                        }
                        else {
                            return CGSize(width: SCREEN_WIDTH, height: WH(187))
                        }
                    case .EnterpriseName:
                        fallthrough
                    case .RetailEnterpriseName: // 零售企业名称
                        fallthrough
                    case .RetailLocation: // 零售企业所在地区
                        fallthrough
                    case .BasePrice:
                        fallthrough
                    case .BankAccountName:
                        fallthrough
                    case .BankName:
                        fallthrough
                    case .ShopNum: // 批零一体门店数
                        fallthrough
                    case .Location:
                        fallthrough
                    case .SalesDistrict:
                        var height = WH(35)
                        if let adress = self.baseInfoService.getQualificationBaseRowInfo(rowInfo), adress != "" {
                            let width = SCREEN_WIDTH - WH(16)*2 - WH(10) - rowInfo.rawValue.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], context: nil).size.width
                            let heightText = adress.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], context: nil).size.height + WH(18)
                            if heightText > height {
                                height = heightText
                            }
                        }
                        return CGSize(width: SCREEN_WIDTH, height: height)
                    case .LegalInfo:
                        return CGSize(width: SCREEN_WIDTH, height: WH(238))
                    default:
                        return CGSize.zero
                    }
                }
                else {
                    return CGSize.zero
                }
            }
            else {
                //图片文件Cell Size
                let isWholesaleRetail = baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1
                if isWholesaleRetail, indexPath.row == 0 {
                    // 是批零一体且第一行
                    return CGSize(width: SCREEN_WIDTH, height: 45)
                }
                
                let isWholeSaleRetail = baseInfoService.baseInfoModel?.enterprise?.isWholesaleRetail == 1
                let zzfileRow = isWholeSaleRetail ? (indexPath.row - 1) : indexPath.row
                let currentZZFileDataSource: [ZZFileProtocol] = zzfileMap[selectedZZFileTag]!
                let model = currentZZFileDataSource[zzfileRow]
                let roleType = baseInfoService.baseInfoModel?.enterprise?.roleType
                
                let fileHelper = ZZUploadHelpFile()
                if fileHelper.notMustUploadFileType(withZZModel:baseInfoService.baseInfoModel!, roleType: roleType!, typeId: model.typeId) {
                    return CGSize(width: SCREEN_WIDTH, height: WH(90))
                }
                else {
                    return CGSize(width: SCREEN_WIDTH, height: WH(90))
                }
            }
        }
        else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}


//MARK: - SKPhotoBrowserDelegate
extension QualificationBaseInfoController: SKPhotoBrowserDelegate {
    func didDismissAtPageIndex(_ index: Int) {
        self.collectionView.reloadData()
    }
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        reload()
    }
    
    //    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
    //        return self.selectedImageView
    //    }
}

