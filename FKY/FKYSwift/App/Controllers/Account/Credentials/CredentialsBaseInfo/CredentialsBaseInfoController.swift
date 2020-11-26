//
//  CredentialsBaseInfoController.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  填写基本信息...<企业>

import UIKit
import SnapKit
import RxSwift
import AipOcrSdk

class CredentialsBaseInfoController: UIViewController {
    //MARK: - Property
    
    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    
    // 内容视图
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        cv.register(CredentialsSelectCollectionCell.self, forCellWithReuseIdentifier: "CredentialsSelectCollectionCell")
        cv.register(CredentialsInputCollectionCell.self, forCellWithReuseIdentifier: "CredentialsInputCollectionCell")
        cv.register(FKYCredentialsBaseInfoAddressDetailCollectionCell.self, forCellWithReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell")
        cv.register(CredentialsAllInOneCCell.self, forCellWithReuseIdentifier: "CredentialsAllInOneCCell")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableFooterView")
        cv.register(CredentialsSubmitCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsSubmitCollectionView")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
        
    // 地区选择...<包含定位功能>
    fileprivate lazy var addressPickerView: RegisterAddressPickerView = {
        let picker = RegisterAddressPickerView.init(frame: CGRect.zero, location: true)
        return picker
    }()
    
    // 提示视图
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent("特别提醒：企业名称请一定要和营业执照上的名称一致，如果不一致，供应商会拒绝为您发货！", numberOfLines: 2)
        return view
    }()
    
    fileprivate var aipGeneralVC : UIViewController!
    fileprivate var provider: CredentialsBaseInfoProvider = CredentialsBaseInfoProvider()
    fileprivate var selectedImageView: UIImageView?
    fileprivate var isUploadEnterpriseInfoSuccess: Bool = false
    fileprivate var picArr: [String]?
    fileprivate var originZZModelHashString: String = ""
    fileprivate var lastChooseEnterpriseID: String = ""
    
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AipOcrService.shard().auth(withAK: "4G3M4Wn8asuFlr4GepvHaeaS", andSK: "zEwWdqmXineVoqjD6uQmXW61OKlFLlE3")
        getBaseInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        // 导航栏设置
        self.fky_setupTitleLabel("填写基本信息")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self]  in
            if let strongSelf = self {
                strongSelf.view.endEditing(true)
                strongSelf.toSaveTempUserInfoToNative()
                if strongSelf.isUploadEnterpriseInfoSuccess {
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 4
                    }, isModal: false)
                } else {
                    FKYNavigator.shared().pop()
                }
            }
        }
        
        // 顶部提示视图
        self.view.addSubview(viewTips)
        viewTips.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        
        //
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(viewTips.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        // 地区选择视图
        self.view.addSubview(addressPickerView)
        self.addressPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.view.sendSubviewToBack(self.addressPickerView)
        self.addressPickerView.isHidden = true        
        // 选择完成
        addressPickerView.selectOverClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let district = strongSelf.addressPickerView.district else {
                return
            }
            guard let city = strongSelf.addressPickerView.city else {
                return
            }
            guard let province = strongSelf.addressPickerView.province else {
                return
            }
            // 区
            let districtObj = ProvinceModel.init(infoCode: district.code, infoName: district.name, secondModel: nil)
            // 市
            let cityObj = ProvinceModel.init(infoCode: city.code, infoName: city.name, secondModel: [districtObj])
            // 省
            let provinceObj = ProvinceModel.init(infoCode: province.code, infoName: province.name, secondModel: [cityObj])
            // 保存
            if strongSelf.addressPickerView.type == .Location {
                // 企业所在地区...<地址>
                strongSelf.provider.inputBaseInfo.enterprise?.registeredAddress =  strongSelf.addressPickerView.address
                // 保存最终地址数据
                strongSelf.provider.inputBaseInfo.enterprise?.addressProvinceDetail = provinceObj
            }
            else if strongSelf.addressPickerView.type == .AllInOneLocation {
                // 批发企业所有地区...<地址>
                strongSelf.provider.inputBaseInfo.enterpriseRetail?.registeredAddress =  strongSelf.addressPickerView.address
                // 保存最终地址数据
                strongSelf.provider.inputBaseInfo.enterpriseRetail?.addressProvinceDetail = provinceObj
            }
            // 刷新
            strongSelf.collectionView.reloadData()
        }
        // 定位失败
        addressPickerView.locationErrorClosure = { [weak self] (erroCode, reason) in
            guard let strongSelf = self else {
                return
            }
            if 10 == erroCode {
                let title = "定位服务未开启"
                let message = "请进入系统-[设置]-[隐私]-[定位服务] 中打开开关,并允许1药城使用定位服务"
                let allContent = "\(title)\n\(message)"
                let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: allContent)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(14)), range: (allContent as NSString).range(of: message))
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0x343434), range: NSMakeRange(0, title.count))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacingBefore = 4
                paragraphStyle.alignment = .center
                attribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allContent as NSString).length))
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(18)), range: NSMakeRange(0, title.count))
                
                FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", leftColor: RGBColor(0x3580FA), rightTitle: "立即开启", rightColor: RGBColor(0x3580FA), attributeMessage: NSAttributedString(attributedString: attribute)) { (alertView, isRight) in
                    if isRight {
                        if let telURL: URL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(telURL)
                        }
                    }
                }
            }
            else {
                // "自动匹配地址失效，请手动选择地址"
                
                if erroCode == -1 {
                    // 定位失败
                    strongSelf.toast("定位失败，请手动选择")
                }
                else if erroCode == -2 {
                    // 地址反编码失败
                    strongSelf.toast("检索详细地址失败，请手动选择")
                }
                else if erroCode == -3 {
                    // 通过name查询code失败
                    strongSelf.toast("查询地址编码失败，请手动选择")
                }
                else {
                    // 其它
                    strongSelf.toast(reason)
                }
            }
        }
        // 定位成功
        addressPickerView.locationSuccessClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast("定位成功")
        }
        // loading
        addressPickerView.showLoadingClosure = { [weak self] (showFlag) in
            guard let strongSelf = self else {
                return
            }
            if showFlag {
                strongSelf.showLoading()
            }
            else {
                strongSelf.dismissLoading()
            }
        }
        // toast
        addressPickerView.showToastClosure = { [weak self] (msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(msg)
        }
        // alert
        addressPickerView.showAlertClosure = { [weak self] (showFlag) in
            guard let strongSelf = self else {
                return
            }
            guard showFlag else {
                return
            }
            
            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                let cancelAction = UIAlertAction.init(title:"取消", style: .cancel, handler: { (action) in
                    //strongSelf.toast("定位权限未开启，无法获取当前位置。")
                })
                let okAction = UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
                    UIApplication.shared.openURL(appSettings as URL)
                })
                let alert = UIAlertController.init(title:"定位权限未开启，请到设置->1药城->位置中开启!", message: nil, preferredStyle: .alert)
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                strongSelf.present(alert, animated: true, completion: nil)
            }
            else {
                strongSelf.toast("定位权限未开启，无法获取当前位置。")
            }
        }
    }
    
    
    //MARK: - Data
    
    // 获取基本信息数据
    fileprivate func getBaseInfo() {
        self.showLoading()
        
        // 0. 先读取本地缓存数据
        ZZModel.getHistoryData { [weak self] (zzModel) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            
            // 1.1 有本地缓存的数据
            if let model = zzModel {
                // 保存
                strongSelf.provider.inputBaseInfo = model
                strongSelf.originZZModelHashString = model.hashString()
                
                // 显示企业基本信息...<本地保存>
                strongSelf.showEnterpriseBaseInfo()
                return
            }
            
            // 1.2 无本地缓存的数据
            strongSelf.showLoading()
            
            // 实时请求数据
            strongSelf.provider.queryBaseInfo { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                
                // 显示企业基本信息...<接口读取>
                strongSelf.showEnterpriseBaseInfo()
            }
        }
    }
    
    
    //MARK: - Show
    
    // 显示企业基本信息...<本地保存 or 接口读取>
    fileprivate func showEnterpriseBaseInfo() {
        // 处理企业信息 获取基本的 要传的数据 类型
        self.handleEnterpriseInfo()
        
        // 获取省市区数据
        self.showAddressInfo()
        
        // 实时请求经营范围
        self.requestDrugScopeForBaseInfo()
        
        // 实时请求企业信息（根据企业名称）
        self.requestCurrentEnterpriseFromErp()
    }
    
    // 处理企业信息???
    fileprivate func handleEnterpriseInfo() {
        if let arr = self.provider.inputBaseInfo.listTypeInfo, arr.count > 0 {
            self.provider.handleEnterpriseTypesForAPI()
            self.initLastChooseEnterpriseID(arr)
        }
    }
    
    // 显示省市区数据
    fileprivate func showAddressInfo() {
        guard let compamyModel = self.provider.inputBaseInfo.enterprise else {
            return
        }
        
        // 保存到pickerview中
        self.addressPickerView.province = RegisterAddressItemModel(name: compamyModel.provinceName, code: compamyModel.province)
        self.addressPickerView.city = RegisterAddressItemModel(name: compamyModel.cityName, code: compamyModel.city)
        self.addressPickerView.district = RegisterAddressItemModel(name: compamyModel.districtName, code: compamyModel.district)
    }
    
    // 实时请求经营范围
    fileprivate func requestDrugScopeForBaseInfo() {
        self.showLoading()
        self.provider.getDrugScopeForBaseInfo { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.originZZModelHashString = strongSelf.provider.inputBaseInfo.hashString()
            strongSelf.collectionView.reloadData()
        }
    }
    
    //
    fileprivate func requestCurrentEnterpriseFromErp() {
        // 有企业信息 & 企业名称
        guard let company: ZZBaseInfoModel = self.provider.inputBaseInfo.enterprise, let name = company.enterpriseName, name.isEmpty == false else {
            return
        }

        // 判断有无地址信息
        var showFlat = true // 默认显示
        if let province = company.province, province.isEmpty == false,
            let provinceName = company.provinceName, provinceName.isEmpty == false,
            let city = company.city, city.isEmpty == false,
            let cityName = company.cityName, cityName.isEmpty == false,
            let district = company.district, district.isEmpty == false,
            let districtName = company.districtName, districtName.isEmpty == false {
            // 有省市区，不显示
            showFlat = false
        }
        // 开始请求
        self.requestEnterpriseInfoByName(name, showFlat)
    }
    
    
    // MARK: - Private
    
    // 保存用户本地填写的数据
    fileprivate func toSaveTempUserInfoToNative() {
        if self.provider.inputBaseInfo.hashString() != self.originZZModelHashString {
            self.provider.inputBaseInfo.saveHistoryData()
        }
    }
    
    // 获取最后选择的企业id???
    fileprivate func initLastChooseEnterpriseID(_ enterpriseTypeList: [EnterpriseOriginTypeModel]) {
        if let paramValues = (enterpriseTypeList as NSArray).value(forKeyPath: "paramValue") as? [String] {
            lastChooseEnterpriseID = (paramValues as NSArray).componentsJoined(by: ";")
        }
    }
    
    // 延迟toast...<不展示>
    fileprivate func showToast(_ msg: String?, _ after: CGFloat) {
        //self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //self.aipGeneralVC = nil
            self.toast(msg)
        }
    }
    
    // OCR图像文字识别
    fileprivate func analysisImage(mImage: UIImage, type: ZZBaseInfoSectionType) {
        self.showLoading()
        AipOcrService.shard().detectBusinessLicense(from: mImage, withOptions: nil, successHandler: { [weak self] (result) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.dismissLoading()
                strongSelf.aipGeneralVC?.dismiss(animated: false, completion: {
                    if let dic = (result as AnyObject).value(forKeyPath: "words_result") as? NSDictionary {
                        if let nameDict = (dic as AnyObject).value(forKeyPath: "单位名称") as? NSDictionary {
                            if let nameStr = (nameDict as AnyObject).value(forKeyPath: "words") as? String {
                                if (nameStr == "无" || nameStr.isEmpty == true) {
                                    //没有单位名称的值
                                    //strongSelf.toast("识别失败")
                                    strongSelf.showToast("识别失败", 0.5)
                                } else {
                                    strongSelf.showEnterpriseNameList(enterpriseName: nameStr, isScan: true, type: type)
                                }
                            } else {
                                //没有单位名称的值
                                strongSelf.toast("识别失败")
                            }
                        } else {
                            //没有单位名称的key
                            strongSelf.toast("识别失败")
                        }
                    } else {
                        strongSelf.toast("识别失败")
                        //返回数据不是字典
                    }
                })
            }
        }, failHandler: { [weak self] (error) in
            // 失败
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.dismissLoading()
                strongSelf.toast("无法识别, 请重试")
            }
        })
    }
    
    // 展示企业名称列表视图
    fileprivate func showEnterpriseNameList(enterpriseName: String, isScan: Bool, type: ZZBaseInfoSectionType) {
        UIGraphicsBeginImageContextWithOptions(collectionView.bounds.size, true, 0.0)
        collectionView.drawHierarchy(in: collectionView.bounds, afterScreenUpdates: true)
        let snapImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 实时联想搜索的企业名称列表vc
        let eenvc: CredentialsEnterpriseNameListController = CredentialsEnterpriseNameListController()
        eenvc.screenShot = snapImg
        eenvc.enterEnterpriseName = enterpriseName
        eenvc.isScan = isScan
        eenvc.type = type
        // 关键字输入完成
        eenvc.enterEnterpriseInTextField = { [weak self] (enterpriseName) in
            guard let strongSelf = self else {
                return
            }
            if type == .EnterpriseName {
                // 保存企业名称
                strongSelf.provider.inputBaseInfo.enterprise?.enterpriseName = enterpriseName
                // 用户仅输入关键字，无地区、地址信息，故需保存/显示后面接口请求到的新地区、地址
                strongSelf.requestEnterpriseInfoByName(enterpriseName, true)
            }
            else if type == .AllInOneName {
                //
                strongSelf.provider.inputBaseInfo.enterpriseRetail?.enterpriseName = enterpriseName
            }
            strongSelf.collectionView.reloadData()
        }
        // 已搜集到对应的企业及地区、地址
        eenvc.selectEnterpriseInCell = { [weak self] (enterpriseModel) in
            guard let strongSelf = self else {
                return
            }
            if type == .EnterpriseName {
                // 企业
                if (isScan && enterpriseModel == nil) {
                    strongSelf.provider.inputBaseInfo.enterprise?.enterpriseName = enterpriseName
                } else {
                    strongSelf.provider.inputBaseInfo.enterprise?.enterpriseName = enterpriseModel?.enterpriseName
                }
                
                // 区
                let districtObj = ProvinceModel.init(infoCode: enterpriseModel?.district, infoName: enterpriseModel?.districtName, secondModel: nil)
                // 市
                let cityObj = ProvinceModel.init(infoCode: enterpriseModel?.city, infoName: enterpriseModel?.cityName, secondModel: [districtObj])
                // 省
                let provinceObj = ProvinceModel.init(infoCode: enterpriseModel?.province, infoName: enterpriseModel?.provinceName, secondModel: [cityObj])
                // 保存最终地址数据
                strongSelf.provider.inputBaseInfo.enterprise?.addressProvinceDetail = provinceObj
                // 保存(街道详情)地址
                strongSelf.provider.inputBaseInfo.enterprise?.registeredAddress =  enterpriseModel?.detailAddress
                // 保存到pickerview中
                strongSelf.addressPickerView.province = RegisterAddressItemModel(name: enterpriseModel?.provinceName, code: enterpriseModel?.province)
                strongSelf.addressPickerView.city = RegisterAddressItemModel(name: enterpriseModel?.cityName, code: enterpriseModel?.city)
                strongSelf.addressPickerView.district = RegisterAddressItemModel(name: enterpriseModel?.districtName, code: enterpriseModel?.district)
                
                // 用户选择实时联想到的企业model，有地区、地址信息，故无需显示/保存后面接口请求到的新地区、地址
                strongSelf.requestEnterpriseInfoByName(strongSelf.provider.inputBaseInfo.enterprise?.enterpriseName, false)
            }
            else if type == .AllInOneName {
                // 批零一体企业
                if (isScan && enterpriseModel == nil) {
                    strongSelf.provider.inputBaseInfo.enterpriseRetail?.enterpriseName = enterpriseName
                } else {
                    strongSelf.provider.inputBaseInfo.enterpriseRetail?.enterpriseName = enterpriseModel?.enterpriseName
                }
                
                // 区
                let districtobject = ProvinceModel.init(infoCode: enterpriseModel?.district, infoName: enterpriseModel?.districtName, secondModel: nil)
                // 市
                let cityobject = ProvinceModel.init(infoCode: enterpriseModel?.city, infoName: enterpriseModel?.cityName, secondModel: [districtobject])
                // 省
                let addressObject = ProvinceModel.init(infoCode: enterpriseModel?.province, infoName: enterpriseModel?.provinceName, secondModel: [cityobject])
                // 保存最终地址数据
                strongSelf.provider.inputBaseInfo.enterpriseRetail?.addressProvinceDetail = addressObject
                // 保存(街道详情)地址
                strongSelf.provider.inputBaseInfo.enterpriseRetail?.registeredAddress =  enterpriseModel?.detailAddress
                // 保存到pickerview中
                strongSelf.addressPickerView.province = RegisterAddressItemModel(name: enterpriseModel?.provinceName, code: enterpriseModel?.province)
                strongSelf.addressPickerView.city = RegisterAddressItemModel(name: enterpriseModel?.cityName, code: enterpriseModel?.city)
                strongSelf.addressPickerView.district = RegisterAddressItemModel(name: enterpriseModel?.districtName, code: enterpriseModel?.district)
            }
            strongSelf.collectionView.reloadData()
        }
        // 返回
        eenvc.popOutCallBack = {
            FKYNavigator.shared().popWithoutAnimation()
        }
        // 显示
        FKYNavigator.shared().topNavigationController.pushViewController(eenvc, animated: false, snapshotFirst: false)
    }
    
    // 通过企业名称来获取企业信息
    fileprivate func requestEnterpriseInfoByName(_ name: String?, _ showFlag: Bool) {
        guard let name = name, name.isEmpty == false else {
            return
        }
        
        self.showLoading()
        self.provider.getEnterpriseInfoFromErp(name) { [weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                strongSelf.dismissLoading()
                return
            }
            // 成功
            strongSelf.dismissLoading()
            // 需要显示
            if showFlag {
                strongSelf.showEnterpriseInfoFromErp()
            }
        }
    }
    
    // 显示企业信息中的地区、地址内容
    fileprivate func showEnterpriseInfoFromErp() {
        guard let model = self.provider.enterpriseInfoFromErp, let businessLicense = model.businessLicense, let address = businessLicense.registeredAddress, address.isEmpty == false else {
            return
        }
        
        let list = address.split(separator: ",")
        guard list.count == 4, let province = list.first, province.isEmpty == false, let addr = list.last, addr.isEmpty == false else {
            return
        }
        
        //  省、市、区名称
        let provinceName: String? = String(list[0])
        let cityName: String? = String(list[1])
        let districtName: String? = String(list[2])
        let addressName: String? = String(list[3])
        
        guard let pName = provinceName, let cName = cityName, let dName = districtName, pName.isEmpty == false, cName.isEmpty == false, dName.isEmpty == false else {
            return
        }
        
        self.showLoading()
        // 查询code
        RegisterAddressPickerView.queryAreaCodeOrName(pName, cName, dName) { [weak self] (model, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard let obj: RegisterAddressQueryItemModel = model else {
                // 失败
                return
            }
            guard let province = obj.tAddressProvince, let codeP = province.code, codeP.isEmpty == false else {
                return
            }
            guard let city = obj.tAddressCity, let codeC = city.code, codeC.isEmpty == false else {
                return
            }
            guard let district = obj.tAddressCountry, let codeD = district.code, codeD.isEmpty == false else {
                return
            }
            
            // (街道详情)地址
            strongSelf.provider.inputBaseInfo.enterprise?.registeredAddress = addressName
            // 区
            let districtObject = ProvinceModel.init(infoCode: codeD, infoName: dName, secondModel: nil)
            // 市
            let cityObject = ProvinceModel.init(infoCode: codeC, infoName: cName, secondModel: [districtObject])
            // 省
            let provinceObject = ProvinceModel.init(infoCode: codeP, infoName: pName, secondModel: [cityObject])
            // 保存最终地址数据
            strongSelf.provider.inputBaseInfo.enterprise?.addressProvinceDetail = provinceObject
            // 刷新
            strongSelf.collectionView.reloadData()
        }
    }
    
    
    //MARK: - Notification
    
    @objc func appResignActive() {
        self.toSaveTempUserInfoToNative()
    }
}

// MARK: - UICollectionViewDelegate
extension CredentialsBaseInfoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfRowCountIn(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentType = provider.getContentTypeFor(indexPath)
        let content = provider.contentInForInputType(contentType)
        var defaultValue = ""
        if content == "" {
            defaultValue = contentType.description
        }
        switch contentType {
        case .EnterpriseName, .AllInOneName: // 企业名称
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsSelectCollectionCell", for: indexPath) as! CredentialsSelectCollectionCell
            cell.configCell(contentType.rawValue, content: content, isShowIndicatorView: false, isShowStarView: true, defaultContent: defaultValue)
            // 拍照来自动识别...<OCR>
            cell.callBlock{ [weak self] in
                if let strongSelf = self {
                    FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "imagerecognition", itemPosition: "1", itemName:nil,extendParams:nil, viewController: strongSelf)
                    
                    if FKYJurisdictionTool.getCameraJueiaDiction() == true {
                        let vc = AipGeneralVC.viewController(handler: {(image) in
                            strongSelf.analysisImage(mImage: image!, type: contentType);
                        })
                        strongSelf.aipGeneralVC = vc
                        strongSelf.present(vc!, animated: true, completion: nil)
                    }
                }
            }
            return cell
        case .EnterpriseType: // 企业类型
            fallthrough
        case .Location, .AllInOneLocation: // 所在地区
            fallthrough
        case .DeliveryAddress: // 收发货地址
            fallthrough
        case .DrugScope: // 经营范围
            fallthrough
        case .BankInfo: // 银行信息
            fallthrough
        case .SaleSet: // 销售设置
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsSelectCollectionCell", for: indexPath) as! CredentialsSelectCollectionCell
            cell.configCell(contentType.rawValue, content: content, isShowIndicatorView: true, isShowStarView: true, defaultContent: defaultValue)
            cell.hideCameraBtn()
            return cell
        case .AddressDetail, .AllInOneAddress: // 详细地址
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell", for: indexPath) as! FKYCredentialsBaseInfoAddressDetailCollectionCell
            cell.canEdit = true
            cell.configCell(contentType.rawValue, content: content, type: .AddressDetail, defaultContent: contentType.description, isShowStarView: true)
            cell.toastClosure = { msg in
                self.toast(msg)
            }
            cell.saveClosure = { msg in
                if contentType == .AddressDetail {
                    self.provider.inputBaseInfo.enterprise?.registeredAddress = msg
                } else if contentType == .AllInOneAddress {
                    self.provider.inputBaseInfo.enterpriseRetail?.registeredAddress = msg
                }
                collectionView.reloadData()
            }
            return cell
        case .AllInOne: // 批发零售一体
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsAllInOneCCell", for: indexPath) as! CredentialsAllInOneCCell
            cell.configCell(withTitle: contentType.rawValue, content: defaultValue, isSwitchOn: provider.isWholeSaleRetailState())
            // 是否(批发企业之)批零一体
            cell.callback = { state in
                self.provider.updateAllInOneItems(withSwitchState: state)
                collectionView.reloadData()
                // 清除缓存...<资质上传>
                ZZModelQCListInfoPartInfo.removeQCList()
            }
            return cell
        case .InvitationCode, .AllInOneShopNumbers, .SalesManPhone,.EnterpriseLegalPerson: // 邀请码 & 门店数 & 业务员子账号&企业法人
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCollectionCell", for: indexPath) as! CredentialsInputCollectionCell
            cell.isCanEdit = true
            let type: ZZEnterpriseInputType = {
                if contentType == .SalesManPhone{
                    return .SalesManPhone
                }else if contentType == .InvitationCode{
                    return .InvitationCode
                }else if contentType == .EnterpriseLegalPerson{
                    return .EnterpriseLegalPerson
                }else{
                    return .ShopNum
                }
            }()
            let isShowStar:Bool = {
                var  isShowType = false
                if contentType == .AllInOneShopNumbers || contentType == .EnterpriseLegalPerson{
                    isShowType = true
                }
                return isShowType
            }()
            cell.configCell(contentType.rawValue, content: content, type: type, defaultContent: contentType.description, isShowStarView: isShowStar)
            cell.toastClosure = { msg in
                self.toast(msg)
            }
            cell.saveClosure = { msg in
                if contentType == .InvitationCode {
                    self.provider.inputBaseInfo.inviteCode = msg
                }else if contentType == .SalesManPhone {
                    self.provider.inputBaseInfo.userName = msg
                }else if contentType == .AllInOneShopNumbers {
                    self.provider.inputBaseInfo.enterpriseRetail?.shopNum = Int(msg)
                }else if contentType == .EnterpriseLegalPerson {
                    self.provider.inputBaseInfo.enterprise?.legalPersonname = msg
                }
                collectionView.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            //
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView", for: indexPath)
            v.backgroundColor = bg2
            return v
        }
        else {
            //
            if (indexPath.section >= (provider.numberOfSections() - 1)) {
                // 
                let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsSubmitCollectionView", for: indexPath) as! CredentialsSubmitCollectionView
                // 提交
                v.submitClosure = {
                    // 开始提交基本资料
                    self.showLoading()
                    self.provider.firstSaveEnterpriseInfo({ [weak self] (success, code, message) in
                        guard let strongSelf = self else {
                            return
                        }
                        if success == false {
                            // 失败
                            if -4 == code {
                                strongSelf.dismissLoading()
                                let title = "该企业已经注册过了"
                                let message = "请检查重输或者拨打客服热线解决"
                                let allContent = "\(title)\n\(message)"
                                let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: allContent)
                                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(14)), range: (allContent as NSString).range(of: message))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0x343434), range: NSMakeRange(0, title.count))
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.paragraphSpacingBefore = 4
                                paragraphStyle.alignment = .center
                                attribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allContent as NSString).length))
                                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: WH(18)), range: NSMakeRange(0, title.count))
                                
                                FKYProductAlertView.show(withTitle: nil, leftTitle: "拨打客服热线", leftColor: RGBColor(0x3580FA), rightTitle: "取消", rightColor: RGBColor(0x3580FA), attributeMessage: NSAttributedString(attributedString: attribute)) { (alertView, isRight) in
                                    if !isRight {
                                        if let telURL: URL = URL(string: "tel:4009215767") {
                                            UIApplication.shared.openURL(telURL)
                                        }
                                    }
                                }
                            }
                            else {
                                strongSelf.dismissLoading()
                                strongSelf.toast(message)
                            }
                        }
                        else {
                            // 成功
                            let addressDetailVC = CredentialsAddressSendViewController()
                            addressDetailVC.fromType = "forRegitster"
                            addressDetailVC.zzModel = strongSelf.provider.inputBaseInfo // 传送model
                            addressDetailVC.enterpriseInfoFromErp = strongSelf.provider.enterpriseInfoFromErp
                            // 传递地址
                            if let list = strongSelf.provider.inputBaseInfo.address, list.count > 0 {
                                addressDetailVC.address = list[0]
                            }
                            // 返回
                            addressDetailVC.returnClosure = { [weak self] in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.getBaseInfo()
                            }
                            FKYNavigator.shared().topNavigationController.pushViewController(addressDetailVC, animated:true, snapshotFirst: false)
                            
                            //
                            strongSelf.isUploadEnterpriseInfoSuccess = true
                            strongSelf.originZZModelHashString = strongSelf.provider.inputBaseInfo.hashString()
                            strongSelf.dismissLoading()
                            // 清除缓存
                            ZZModel.removeHistoryData()
                        }
                    })
                }
                v.configSubmitTtile("下一步", isCanSubmit: provider.isCanSubmitEnterpriseBaseInfo())
                v.backgroundColor = bg2
                return v
            }
            else {
                //
                let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableFooterView", for: indexPath)
                v.backgroundColor = bg2
                return v
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentType = provider.getContentTypeFor(indexPath)
        switch contentType {
        case .EnterpriseName:
            fallthrough
        case .EnterpriseType:
            fallthrough
        case .Location:
            fallthrough
        case .AddressDetail:
            fallthrough
        case .EnterpriseLegalPerson:
            fallthrough
        case .DeliveryAddress:
            fallthrough
        case .DrugScope:
            fallthrough
        case .InvitationCode:
            fallthrough
        case .BankInfo:
            fallthrough
        case .AllInOneName:
            fallthrough
        case .AllInOneLocation:
            fallthrough
        case .AllInOneAddress:
            fallthrough
        case .AllInOneShopNumbers:
            fallthrough
        case .SalesManPhone: // 业务员子账号
            fallthrough
        case .SaleSet:
            return CGSize(width: SCREEN_WIDTH, height: WH(56))
        case .AllInOne:
            return CGSize(width: SCREEN_WIDTH, height: WH(75))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionNumber = provider.numberOfSections()
        if (section == (sectionNumber - 1)) {//最后提交按钮作为FooterView
            return CGSize(width: SCREEN_WIDTH, height: (WH(24) + (SCREEN_WIDTH*0.9*0.13) + WH(24)))
        }
        return CGSize(width: SCREEN_WIDTH, height: WH(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.endEditing(true)
        let contentType = provider.getContentTypeFor(indexPath)
        switch contentType {
        case .EnterpriseName, .AllInOneName:   // 企业名称
            let nameStr = provider.contentInForInputType(contentType)
            self.showEnterpriseNameList(enterpriseName:nameStr, isScan: false, type: contentType)
            break
        case .EnterpriseType:   // 企业类型
            collectionView.endEditing(true)
            // 跳转企业类型选择界面
            let enterpriseVC = CredentialsEnterpriseTypeController()
            enterpriseVC.selectedEnterpriseType = self.provider.enterpriseType
            // 已选
            enterpriseVC.saveClosure = { [weak self, weak collectionView] type in
                guard let strongSelf = self else {
                    return
                }
                guard let type = type else {
                    return
                }
                // 企业类型有变化
                if strongSelf.lastChooseEnterpriseID != type.paramValue {
                    // 清除缓存...<资质上传>
                    ZZModelQCListInfoPartInfo.removeQCList()
                    // 重置
                    strongSelf.provider.inputBaseInfo.qcList = []
                    strongSelf.provider.inputBaseInfo.qualificationRetailList = []
                    strongSelf.provider.inputBaseInfo.enterprise?.is3merge1 = 0
                    strongSelf.provider.inputBaseInfo.enterprise?.isWholesaleRetail = 0
                }
                // 保存企业类型
                strongSelf.provider.saveEnterpriseTypesForUserInfo(type)
                // 保存企业ids
                strongSelf.lastChooseEnterpriseID = type.paramValue
                // 刷新
                if let strongCollection = collectionView {
                    strongCollection.reloadData()
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(enterpriseVC, animated: true, snapshotFirst: false)
            return
        case .Location, .AllInOneLocation: // 所在地区
            // 隐藏键盘
            collectionView.endEditing(true)
            
            // 赋值
            if contentType == .Location {
                // 有值则保存
                if let compamyModel = self.provider.inputBaseInfo.enterprise {
                    // 保存到pickerview中
                    self.addressPickerView.province = RegisterAddressItemModel(name: compamyModel.provinceName, code: compamyModel.province)
                    self.addressPickerView.city = RegisterAddressItemModel(name: compamyModel.cityName, code: compamyModel.city)
                    self.addressPickerView.district = RegisterAddressItemModel(name: compamyModel.districtName, code: compamyModel.district)
                    self.addressPickerView.address = compamyModel.registeredAddress
                }
                else {
                    // 无值
                    self.addressPickerView.province = nil
                    self.addressPickerView.city = nil
                    self.addressPickerView.district = nil
                    self.addressPickerView.address = nil
                }
            }
            else {
                // 有值则保存
                if let compamyModel = self.provider.inputBaseInfo.enterpriseRetail {
                    // 保存到pickerview中
                    self.addressPickerView.province = RegisterAddressItemModel(name: compamyModel.provinceName, code: compamyModel.province)
                    self.addressPickerView.city = RegisterAddressItemModel(name: compamyModel.cityName, code: compamyModel.city)
                    self.addressPickerView.district = RegisterAddressItemModel(name: compamyModel.districtName, code: compamyModel.district)
                    self.addressPickerView.address = compamyModel.registeredAddress
                }
                else {
                    // 无值
                    self.addressPickerView.province = nil
                    self.addressPickerView.city = nil
                    self.addressPickerView.district = nil
                    self.addressPickerView.address = nil
                }
            }
            
            // 显示地址选择视图
            self.view.bringSubviewToFront(self.addressPickerView)
            self.addressPickerView.type = contentType   // 当前地址栏类型
            self.addressPickerView.flagMultiUse = true  // 多个地址栏共用当前这一个picker
            self.addressPickerView.isHidden = false
            self.addressPickerView.showWithAnimation()
            self.addressPickerView.showSelectStatus()
            break
        case .DrugScope: // 经营范围
            collectionView.endEditing(true)
            if provider.isChooseEnterpriseTypes() {
                let businessScopeVC = CredentialsBusinessScopeForBaseInfoController()
                if let allDurgScope = provider.drugScopes {
                    businessScopeVC.drugScopes = allDurgScope
                }
                businessScopeVC.saveClosure = { scopes in
                    if let scs = scopes {
                        self.provider.inputBaseInfo.drugScopeList = scs
                        collectionView.reloadData()
                    }
                }
                FKYNavigator.shared().topNavigationController.pushViewController(businessScopeVC, animated: true, snapshotFirst: false)
            }
            else {
                toast("请先选择企业类型")
            }
            return
        case .BankInfo: // 银行信息
            let bankInfoVC = CredentialsBankInfoController()
            bankInfoVC.useFor = .forRegister
            bankInfoVC.canEdit = true
            if let bankModel = provider.inputBaseInfo.bankInfoModel {
                bankInfoVC.bankInfoModel = bankModel
            }
            bankInfoVC.saveClosure = {[weak self, weak collectionView] model in
                if let strongSelf = self {
                    strongSelf.provider.inputBaseInfo.bankInfoModel = model
                }
                if let strongCollection = collectionView {
                    strongCollection.reloadData()
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(bankInfoVC, animated: true, snapshotFirst: false)
            return
        case .SaleSet:  // 销售设置
            if provider.isChooseEnterpriseTypes() {
                let destrictManageVC = CredentialsSalesDestrictManageController()
                destrictManageVC.useFor = .forRegister
                destrictManageVC.orderPrice = self.provider.inputBaseInfo.enterprise?.orderSAmount
                if let districtArray = provider.inputBaseInfo.deliveryAreaList {
                    destrictManageVC.selesDestrictArray = districtArray
                }
                destrictManageVC.saveClosure = {[weak self, weak collectionView] (price, districts) in
                    if  let _ = districts {
                        if let strongSelf = self {
                            strongSelf.provider.inputBaseInfo.deliveryAreaList = districts
                            strongSelf.provider.inputBaseInfo.enterprise?.orderSAmount = price
                        }
                        if let strongCollection = collectionView {
                            strongCollection.reloadData()
                        }
                    }
                }
                FKYNavigator.shared().topNavigationController.pushViewController(destrictManageVC, animated: true, snapshotFirst: false)
            }
            else {
                toast("请先选择企业类型")
            }
            return
        case .AddressDetail:    // 详情地址
            fallthrough
        case .InvitationCode:   // 邀请码
            fallthrough
        case .SalesManPhone:   // 邀请码
            fallthrough
        default:
            return
        }
    }
}
