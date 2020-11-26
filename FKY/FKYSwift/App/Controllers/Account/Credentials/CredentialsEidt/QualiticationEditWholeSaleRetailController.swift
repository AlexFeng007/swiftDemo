//
//  QualiticationEditWholeSaleRetailController.swift
//
//
//  Created by Rabe on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  批发零售信息...<批发企业模式>

import Foundation

class QualiticationEditWholeSaleRetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate {
    //MARK: Private Property
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent(self.textTips, numberOfLines: 0)
        return view
    }()
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(CredentialsInputCollectionCell.self, forCellWithReuseIdentifier: "CredentialsInputCollectionCell")
        view.register(CredentialsSelectCollectionCell.self, forCellWithReuseIdentifier: "CredentialsSelectCollectionCell")
        view.register(FKYCredentialsBaseInfoAddressDetailCollectionCell.self, forCellWithReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.register(QualiticationSwitchCCell.self, forCellWithReuseIdentifier: "QualiticationSwitchCCell")
        view.backgroundColor = RGBColor(0xf5f5f5)
        return view
    }()
    
    fileprivate lazy var addressPickerView: RegisterAddressPickerView = {
        let picker = RegisterAddressPickerView.init(frame: CGRect.zero, location: false)
        return picker
    }()
    
    fileprivate var sectionList: [ZZBaseInfoSectionType] {
        get {
            if isWholeSaleRetail {
                return [.AllInOne, .AllInOneName, .AllInOneLocation, .AllInOneAddress, .AllInOneShopNumbers]
            } else {
                return [.AllInOne]
            }
        }
    }
    
    var saveClosure: ((_ enterpriseName: String, _ isWholeSaleRetail: Bool, _ location: ProvinceModel, _ addressDetail: String, _ shopNum: Int)->())?
    var navBar : UIView?
    var enterpriseBaseInfo : [String: AnyObject] = [:]
    var textTips : String = ""
    
    var baseinfo: ZZModel?  // 基本资料
    var isWholeSaleRetail: Bool = false
    
    //MARK: Private Property
    fileprivate func checkBaseInfo(_ completion: CompleteClosure) {
        if let isWholeSaleRetail = enterpriseBaseInfo["isWholeSaleRetail"] as? Int, isWholeSaleRetail == 0 {
            // 非批零一体
            completion(true, "")
            return
        }
        // 企业名称
        if let enterpriseName = enterpriseBaseInfo["enterpriseName"] as? String, enterpriseName != "" {
            let words = enterpriseName.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                completion(false, "请填写正确\(ZZEnterpriseInputType.EnterpriseName.rawValue)")
                return
            }
        }else {
            completion(false, "请先填写\(ZZEnterpriseInputType.EnterpriseName.rawValue)")
            return
        }
        
        // 地区全称...<省市区>
        var location = ""
        if let locationModel = enterpriseBaseInfo["location"] as? ProvinceModel, let pname = locationModel.infoName {
            location = pname
            if let city = locationModel.secondModel?.first, let cname = city.infoName {
                location = location + " " + cname
                if let district = city.secondModel?.first, let dname = district.infoName {
                    location = location + " " + dname
                }
            }
        }
        if location.count > 0 {
            let words = location.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                return completion(false, "请先选择\(ZZEnterpriseInputType.Location.rawValue)")
            }
        }else{
            return completion(false, "请先选择\(ZZEnterpriseInputType.Location.rawValue)")
        }
        
        // 地址
        if let registeredAddress = enterpriseBaseInfo["addressDetail"] as? String, registeredAddress != ""{
            let words = registeredAddress.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                completion(false, "请填写正确\(ZZEnterpriseInputType.AddressDetail.rawValue)")
                return
            }
        }else {
            completion(false, "请先填写\(ZZEnterpriseInputType.AddressDetail.rawValue)")
            return
        }
        
        completion(true, "")
    }
    
    // 保存
    fileprivate func onClickSaveButton() {
        self.collectionView.endEditing(true)
        self.checkBaseInfo{[weak self] (issuccess, message) in
            if let strongSelf = self {
                if issuccess == true {
                    // 内容合法
                    if let closure = strongSelf.saveClosure {
                        let name = strongSelf.enterpriseBaseInfo["enterpriseName"] ?? "" as AnyObject
                        let isWholeSaleRetail = strongSelf.enterpriseBaseInfo["isWholeSaleRetail"] ?? false as AnyObject
                        let location = strongSelf.enterpriseBaseInfo["location"] as! ProvinceModel
                        let addressDetail = strongSelf.enterpriseBaseInfo["addressDetail"] ?? "" as AnyObject
                        let shopNum = strongSelf.enterpriseBaseInfo["shopNum"] ?? 0 as AnyObject
                        closure(name as! String, isWholeSaleRetail as! Bool, location, addressDetail as! String, shopNum as! Int)
                    }
                    FKYNavigator.shared().pop()
                }
                else {
                    // 内容非法
                    strongSelf.toast(message)
                }
            }
        }
    }
    
    //MARK: Public Method
    
    // 设置
    func configZZModel(baseInfo: ZZModel) {
        isWholeSaleRetail = baseInfo.enterprise?.isWholesaleRetail == 1
        enterpriseBaseInfo["enterpriseName"] = baseInfo.enterpriseRetail?.enterpriseName as AnyObject
        enterpriseBaseInfo["isWholeSaleRetail"] = baseInfo.enterprise?.isWholesaleRetail as AnyObject
        enterpriseBaseInfo["addressDetail"] = baseInfo.enterpriseRetail?.registeredAddress as AnyObject
        enterpriseBaseInfo["shopNum"] = baseInfo.enterpriseRetail?.shopNum as AnyObject
        
        if let locationModel = baseInfo.enterpriseRetail?.addressProvinceDetail {
            enterpriseBaseInfo["location"] = locationModel
            // 将省市区数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
            self.addressPickerView.province = RegisterAddressItemModel(name: locationModel.infoName, code: locationModel.infoCode)
            if let city = locationModel.secondModel?.first {
                self.addressPickerView.city = RegisterAddressItemModel(name: city.infoName, code: city.infoCode)
                if let district = city.secondModel?.first {
                    self.addressPickerView.district = RegisterAddressItemModel(name: district.infoName, code: district.infoCode)
                }
            }
        }
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("批发企业模式")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_setupRightImage("") {[weak self] in
            if let strongSelf = self {
                strongSelf.onClickSaveButton()
            }
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.fontTuple = t19
        self.fky_hiddedBottomLine(false)
        
        // 地区选择完成
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
            strongSelf.enterpriseBaseInfo["location"] = provinceObj
            // 刷新
            strongSelf.collectionView.reloadData()
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
        self.view.addSubview(addressPickerView)
        self.view.sendSubviewToBack(addressPickerView)
        addressPickerView.isHidden = true
        addressPickerView.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.edges.equalTo(strongSelf.view)
            }
        })
        
        self.view.addSubview(viewTips)
        viewTips.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(viewTips.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDataSource &UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = self.sectionList[indexPath.row]
        switch type {
        case .AllInOne: // 批发零售一体
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QualiticationSwitchCCell", for: indexPath) as! QualiticationSwitchCCell
            cell.configCell(withTitle: type.rawValue, isSwitchOn: enterpriseBaseInfo["isWholeSaleRetail"] as! Bool)
            cell.callback = { state in
                self.isWholeSaleRetail = state
                self.enterpriseBaseInfo["isWholeSaleRetail"] = state as AnyObject
                collectionView.reloadData()
            }
            return cell
        case .AllInOneName, .AllInOneShopNumbers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCollectionCell", for: indexPath) as! CredentialsInputCollectionCell
            cell.isCanEdit = true
            
            var content = ""
            var inputType: ZZEnterpriseInputType = .RetailEnterpriseName
            if type == .AllInOneName {
                content = enterpriseBaseInfo["enterpriseName"] as! String
            } else if type == .AllInOneShopNumbers {
                content = "\(enterpriseBaseInfo["shopNum"] as! Int)"
                inputType = .ShopNum
            }
            cell.configCell(type.rawValue, content: content, type: inputType, defaultContent: type.description, isShowStarView: true)
            cell.saveClosure = {[weak collectionView, weak self] msg in
                if type == .AllInOneName {
                    if let strongSelf = self {
                        strongSelf.enterpriseBaseInfo["enterpriseName"] = msg as AnyObject
                    }
                } else if type == .AllInOneShopNumbers {
                    if let strongSelf = self {
                        if msg.count > 0 {
                            strongSelf.enterpriseBaseInfo["shopNum"] = Int(msg) as AnyObject
                        } else {
                            strongSelf.enterpriseBaseInfo["shopNum"] = 0 as AnyObject
                        }
                    }
                }
                if let strongCollectionView = collectionView {
                    strongCollectionView.reloadData()
                }
            }
            return cell
        case .AllInOneLocation: // 所在地区
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsSelectCollectionCell", for: indexPath) as! CredentialsSelectCollectionCell
            var location = ""
            if let locationModel = enterpriseBaseInfo["location"] as? ProvinceModel,let pname = locationModel.infoName {
                location = pname
                if let city = locationModel.secondModel?.first, let cname = city.infoName {
                    location = location + " " + cname
                    if let district = city.secondModel?.first, let dname = district.infoName {
                        location = location + " " + dname
                    }
                }
            }
            cell.configCell(type.rawValue , content: location, isShowIndicatorView: true, isShowStarView: true, defaultContent: type.description)
            cell.hideCameraBtn()
            return cell
        case .AllInOneAddress: // 详细地址
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell", for: indexPath) as! FKYCredentialsBaseInfoAddressDetailCollectionCell
            cell.canEdit = true
            var content = ""
            if let addressDetail = enterpriseBaseInfo["addressDetail"] as? String {
                content = addressDetail
            }
            cell.configCell(type.rawValue, content: content, type: .AddressDetail, defaultContent: type.description, isShowStarView: true)
            cell.toastClosure = { msg in
                self.toast(msg)
            }
            cell.saveClosure = {[weak collectionView, weak self] msg in
                if let strongSelf = self {
                    strongSelf.enterpriseBaseInfo["addressDetail"] = msg as AnyObject
                }
                if let strongCollectionView = collectionView {
                    strongCollectionView.reloadData()
                }
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(56))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = self.sectionList[indexPath.row]
        
        if type == .AllInOneLocation {
            // 选择地区
            self.view.endEditing(true)
            // 显示地址选择视图
            self.view.bringSubviewToFront(self.addressPickerView)
            self.addressPickerView.isHidden = false
            self.addressPickerView.showWithAnimation()
            self.addressPickerView.showSelectStatus()
        }
    }
}

