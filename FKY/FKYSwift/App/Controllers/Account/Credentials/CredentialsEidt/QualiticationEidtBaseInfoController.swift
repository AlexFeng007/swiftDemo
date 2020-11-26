//
//  EidtQualiticationBaseInfoController.swift
//  FKY
//
//  Created by mahui on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  基本信息

import Foundation


class QualiticationEidtBaseInfoController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UINavigationControllerDelegate {
    //MARK: Private Property
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent(self.textTips, numberOfLines: 0)
        return view
    }()
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.register(CredentialsInputCollectionCell.self, forCellWithReuseIdentifier: "CredentialsInputCollectionCell")
        view.register(CredentialsSelectCollectionCell.self, forCellWithReuseIdentifier: "CredentialsSelectCollectionCell")
        view.register(FKYCredentialsBaseInfoAddressDetailCollectionCell.self, forCellWithReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView")
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var addressPickerView: RegisterAddressPickerView = {
        let picker = RegisterAddressPickerView.init(frame: CGRect.zero, location: false)
        return picker
    }()
    
    fileprivate var sectionList: [ZZBaseInfoSectionType] = [.EnterpriseName,.EnterpriseType,.Location,.AddressDetail]
    fileprivate var sectionListInPifa: [ZZBaseInfoSectionType] = [.EnterpriseName,.EnterpriseType,.Location,.AddressDetail,.EnterpriseLegalPerson]
    
    //MARK: Public Property
    var saveClosure: ((_ enterpriseName: String, _ enterpriseType: Int, _ location: ProvinceModel, _ addressDetail: String,_ legalPersonname : String)->())?
    var navBar : UIView?
    var enterpriseBaseInfo : [String: AnyObject] = [:]
    var textTips : String = ""
    
    // added by xiazhiyong
    var baseinfo: ZZModel? // 基本资料
    var canChangeType = false // 默认不可修改企业类型
    var enterpriseType: EnterpriseTypeModel? = nil // 企业类型
    var chooseList = [EnterpriseTypeModel]() // 当前用户可选的企业类型数组
    var canModifyName: Bool? = true // 是否可修改企业名称和企业类型
    
    //MARK: Private Property
    fileprivate func checkBaseInfo(_ completion: CompleteClosure) {
        // 企业名称
        if let enterpriseName = enterpriseBaseInfo["enterpriseName"] as? String, enterpriseName != "" {
            let words = enterpriseName.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let justwords = words.joined(separator: "")
            if 0 >= justwords.count {
                completion(false, "请填写正确\(ZZEnterpriseInputType.EnterpriseName.rawValue)")
                return
            }
        }
        else {
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
        }
        else {
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
        }
        else {
            completion(false, "请先填写\(ZZEnterpriseInputType.AddressDetail.rawValue)")
            return
        }
        
        //批发企业
        if self.baseinfo!.enterprise?.roleType == 3{
            if let legalPersonname = enterpriseBaseInfo["legalPersonname"] as? String,(legalPersonname as NSString).length > 0 {
                let words = legalPersonname.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    completion(false, "请先填写\(ZZEnterpriseInputType.EnterpriseLegalPerson.rawValue)")
                    return
                }
            }
            else {
                completion(false, "请先填写\(ZZEnterpriseInputType.EnterpriseLegalPerson.rawValue)")
                return
            }
        }
        completion(true, "")
    }
    
    // 保存
    fileprivate func toSaveBaseInfo() {
        self.collectionView.endEditing(true)
        self.checkBaseInfo{[weak self] (issuccess,message) in
            if let strongSelf = self {
                if issuccess == true {
                    // 内容合法
                    if let closure = strongSelf.saveClosure {
                        var name = ""
                        if let enterpriseName = strongSelf.enterpriseBaseInfo["enterpriseName"] as? String {
                            name = enterpriseName
                        }
                        if let locationModel = strongSelf.enterpriseBaseInfo["location"] as? ProvinceModel {
                            var adress = ""
                            if let enterpriseName = strongSelf.enterpriseBaseInfo["addressDetail"] as? String {
                                adress = enterpriseName
                            }
                            //closure(name, locationModel, adress)
                            
                            var typeid: Int = 0 // 当前企业类型...<默认为0,无修改>
                            if strongSelf.enterpriseType != nil {
                                let value: String = (strongSelf.enterpriseType?.paramValue)!
                                typeid = Int(value)!
                            }
                            var legalPersonname = ""
                            if let personname = strongSelf.enterpriseBaseInfo["legalPersonname"] as? String {
                                legalPersonname = personname
                            }
                            closure(name, typeid, locationModel, adress, legalPersonname)
                        }
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
    func setEnterpriseBaseInfoUse(baseInfo: ZZModel) {
        // 企业名称
        if let enterpriseName = baseInfo.enterprise?.enterpriseName {
            enterpriseBaseInfo["enterpriseName"] = enterpriseName as AnyObject
        }
        else {
            enterpriseBaseInfo["enterpriseName"] = "" as AnyObject
        }
        
        // 企业类型
        enterpriseBaseInfo["enterpriseType"] = baseInfo.getEnterpriseTypeName() as AnyObject
        
        // 地区
        if let locationModel = baseInfo.enterprise?.addressProvinceDetail {
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
        
        // 地址
        if let addressDetail = baseInfo.enterprise?.registeredAddress {
            enterpriseBaseInfo["addressDetail"] = addressDetail as AnyObject
        }
        else {
            enterpriseBaseInfo["addressDetail"] = "" as AnyObject
        }
        
        // 新增逻辑
        self.getCurrentEnterpriseTypeAndChoostList(baseInfo: baseInfo)
        
        // 企业法人
        if self.baseinfo!.enterprise?.roleType == 3 {
            if let legalPersonname = baseInfo.enterprise?.legalPersonname {
                enterpriseBaseInfo["legalPersonname"] = legalPersonname as AnyObject
            }
            else {
                enterpriseBaseInfo["legalPersonname"] = "" as AnyObject
            }
        }
        
        // 判断是否可修改企业名称...<默认可修改>
        canModifyName = true
        if let value = baseInfo.canModifyName {
            canModifyName = value
        }
        // 刷新
        collectionView.reloadData()
    }
    
    //
    func getCurrentEnterpriseTypeAndChoostList(baseInfo: ZZModel) {
        // 终端用户<可修改~!@>
        self.baseinfo = baseInfo
        self.canChangeType = (baseInfo.enterprise?.roleType == 1 ? true : false)
        
        if self.canChangeType {
            // 可以修改
            var topType: EnterpriseOriginTypeModel? = nil
            if (self.baseinfo?.listTypeInfo) != nil && self.baseinfo?.listTypeInfo?.isEmpty == false {
                topType = (self.baseinfo?.listTypeInfo?.first)!
            }
            
            if (self.baseinfo?.enterpriseTypeList) != nil && self.baseinfo?.enterpriseTypeList?.isEmpty == false {
                for item in (self.baseinfo?.enterpriseTypeList)! {
                    // 类型转换成下个界面数据源所需的类型
                    let obj: EnterpriseTypeModel = item.mapToEnterpriseTypeModel()
                    self.chooseList.append(obj)
                    // 确定用户当前的企业类型
                    if topType != nil && topType?.paramValue == item.typeId {
                        self.enterpriseType = obj
                    }
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
        self.fky_setupTitleLabel("基本信息")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_setupRightImage("") {[weak self] in
            if let strongSelf = self {
                strongSelf.toSaveBaseInfo()
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
        setUpData()
    }
    
    func setUpData() {
        //批发企业
        if self.baseinfo!.enterprise?.roleType == 3{
            sectionList.append(.EnterpriseLegalPerson)
            collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDataSource &UICollectionViewDelegateFlowLayout
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = self.sectionList[indexPath.row]
        switch type {
        case .EnterpriseName: // 企业名称
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCollectionCell", for: indexPath) as! CredentialsInputCollectionCell
            cell.isCanEdit = (canModifyName ?? true) // 是否可修改
            // 配置cell
            var content = ""
            if let enterpriseName = enterpriseBaseInfo["enterpriseName"] as? String {
                content = enterpriseName
            }
            cell.configCell(type.rawValue, content: content, type: .EnterpriseName, isShowStarView: false)
            cell.saveClosure = {[weak collectionView, weak self] msg in
                if type == .EnterpriseName {
                    if let strongSelf = self {
                        strongSelf.enterpriseBaseInfo["enterpriseName"] = msg as AnyObject
                    }
                }
                if let strongCollectionView = collectionView {
                    strongCollectionView.reloadData()
                }
            }
            return cell
        case .EnterpriseType: // 企业类型
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsSelectCollectionCell", for: indexPath) as! CredentialsSelectCollectionCell
            var content = ""
            if let enterpriseType = enterpriseBaseInfo["enterpriseType"] as? String {
                content = enterpriseType
            }
            cell.configCell(type.rawValue , content: content, isShowIndicatorView: (self.canChangeType && (canModifyName ?? true)), isShowStarView: false, defaultContent: "")
            cell.hideCameraBtn()
            return cell
        case .Location: // 所在地区
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
            cell.configCell(type.rawValue , content: location, isShowIndicatorView: true, isShowStarView: false, defaultContent: "")
            cell.hideCameraBtn()
            return cell
        case .AddressDetail: // 详细地址
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell", for: indexPath) as! FKYCredentialsBaseInfoAddressDetailCollectionCell
            cell.canEdit = true
            var content = ""
            if let addressDetail = enterpriseBaseInfo["addressDetail"] as? String {
                content = addressDetail
            }
            cell.configCell(type.rawValue, content: content, type: .AddressDetail, defaultContent: type.description, isShowStarView: false)
            cell.inputTextMaxLong = 100
            cell.toastClosure = {[weak self] msg in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.toast(msg)
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
        case .EnterpriseLegalPerson: // 企业法人
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell", for: indexPath) as! FKYCredentialsBaseInfoAddressDetailCollectionCell
            cell.canEdit = true
            var content = ""
            if let legalPersonname = enterpriseBaseInfo["legalPersonname"] as? String  {
                content = legalPersonname
            }
            cell.configCell(type.rawValue, content: content, type: .EnterpriseLegalPerson, defaultContent: type.description, isShowStarView: false)
            cell.toastClosure = {[weak self] msg in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.toast(msg)
            }
            cell.saveClosure = {[weak collectionView, weak self] msg in
                if let strongSelf = self {
                    strongSelf.enterpriseBaseInfo["legalPersonname"] = msg as AnyObject
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
        let type = self.sectionList[indexPath.row]
        switch type {
        case .EnterpriseName:
            fallthrough
        case .EnterpriseType:
            fallthrough
        case .Location:
            fallthrough
        case .EnterpriseLegalPerson:
            fallthrough
        case .AddressDetail:
            return CGSize(width: SCREEN_WIDTH, height: WH(56))
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = self.sectionList[indexPath.row]
        
        if type == .Location {
            // 选择地区
            self.view.endEditing(true)
            // 显示地址选择视图
            self.view.bringSubviewToFront(self.addressPickerView)
            self.addressPickerView.isHidden = false
            self.addressPickerView.showWithAnimation()
            self.addressPickerView.showSelectStatus()
        }
        else if type == .EnterpriseType {
            // 修改企业类型
            if self.canChangeType == false || (canModifyName ?? true) == false{
                return
            }
            
            // 企业类型选择界面
            let enterpriseVC = CredentialsEnterpriseTypeController()
            enterpriseVC.changeEnterpriseType = true // 修改企业类型
            enterpriseVC.selectedEnterpriseType = self.enterpriseType // 当前企业类型
            enterpriseVC.AllEnterpriseType = self.chooseList // 可选择的所有企业类型数组
            enterpriseVC.saveClosure = {[weak self, weak collectionView] type in
                if let type = type {
                    if let strongSelf = self {
                        print("select")
                        strongSelf.enterpriseType = type
                        strongSelf.enterpriseBaseInfo["enterpriseType"] = type.paramName as AnyObject
                        if let strongCollection = collectionView {
                            strongCollection.reloadData()
                        }
                    }
                }
            }
            FKYNavigator.shared().topNavigationController.pushViewController(enterpriseVC, animated: true, snapshotFirst: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 是否可修改
        let isCanEdit = (canModifyName ?? true)
        if isCanEdit {
            // 企业名称可修改
            return CGSize.zero
        }
        else {
            // 企业名称不可修改
            return CGSize(width: SCREEN_WIDTH, height:WH(50))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 是否可修改
        let isCanEdit = (canModifyName ?? true)
        if isCanEdit {
            // 企业名称可修改
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView", for: indexPath)
            return view
        }
        else {
            // 企业名称不可修改
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView", for: indexPath)
            view.backgroundColor = .white
            
            if let viewTemp = view.viewWithTag(1000), viewTemp.isKind(of: UIView.self) {
                viewTemp.removeFromSuperview()
            }
            
            let viewBg = UIView()
            viewBg.tag = 1000
            viewBg.backgroundColor = RGBColor(0xFFF7EA)
            view.addSubview(viewBg)
            viewBg.snp.makeConstraints{ (make) in
                //make.edges.equalTo(view)
                make.left.right.top.equalTo(view)
                make.bottom.equalTo(view).offset(-WH(10))
            }
            
            let lblTip = UILabel()
            lblTip.backgroundColor = .clear
            lblTip.font = UIFont.boldSystemFont(ofSize: WH(14))
            lblTip.textColor = RGBColor(0xFFA920)
            lblTip.textAlignment = .left
            lblTip.numberOfLines = 0
            lblTip.text = "如您的企业名称、企业类型有误，请联系负责业务员进行修改。"
            viewBg.addSubview(lblTip)
            lblTip.snp.makeConstraints{ (make) in
                make.left.equalTo(viewBg).offset(WH(15))
                make.right.equalTo(viewBg).offset(-WH(10))
                make.centerY.equalTo(viewBg)
            }
            
            return view
        }
    }
}



