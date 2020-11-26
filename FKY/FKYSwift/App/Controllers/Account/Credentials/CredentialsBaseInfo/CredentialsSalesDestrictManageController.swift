//
//  CredentialsSalesDestrictManageController.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  （填写基本信息之）销售设置...<不再使用>

import UIKit


typealias DistrictSaveClosure = (String?,[SalesDestrictModel]?)->()

// MARK: 销售区域设置
class CredentialsSalesDestrictManageController:
UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout  {
    //MARK: Private Property
    fileprivate var navBar: UIView?
    fileprivate var rightBar: UIButton?
    fileprivate var titleArray: [String] = ["订单起售金额","卖方销售区域"]
    fileprivate var destrictArray: [SalesDestrictModel] = [SalesDestrictModel]() // 销售区域数组
    fileprivate var province: ProvinceModel?    // 省
    fileprivate var district: ProvinceModel?    // 市
    fileprivate var country: ProvinceModel?     // 区
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(FKYCredentialsInputWithUnitCollectionCell.self, forCellWithReuseIdentifier: "FKYCredentialsInputWithUnitCollectionCell")
        cv.register(FKYCredentialsAddDestrictCell.self, forCellWithReuseIdentifier: "FKYCredentialsAddDestrictCell")
        cv.register(CredentialsDestrictEditCell.self, forCellWithReuseIdentifier: "CredentialsDestrictEditCell")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    fileprivate lazy var addressPickerView: RegisterAddressPickerView = {
        let picker = RegisterAddressPickerView.init(frame: CGRect.zero, location: false)
        return picker
    }()
    
    var orderPrice: String? = ""
    var originOrderPrice: String? = ""
    var originDestrictDes: [String] = []
    var refuseReason: String?
    var saveClosure: DistrictSaveClosure?
    var useFor: ViewConrollerUseType = .forUpdate
    
    var selesDestrict: ProvinceModel? {
        willSet{
            self.province = newValue
            if newValue?.secondModel != nil {
                district = newValue?.secondModel?.first
                if let coun = newValue?.secondModel?.first {
                    country = coun
                }
            }

            let destrictModel = SalesDestrictModel(province: province!, city: district, district: country)
            destrictArray.append(destrictModel)
            collectionView.reloadData()
            
            // 将省市区数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
            //self.saveAreaDataForPickerview()
        }
    }
    
    // 销售区域数组?!
    var selesDestrictArray: [SalesDestrictModel]? {
        willSet{
            if let _ = newValue {
                destrictArray = newValue!
                collectionView.reloadData()
            }
        }
    }
    
    //MARK: Private Method
    fileprivate func isEditInfo() -> Bool {
        if self.orderPrice != self.originOrderPrice {
            return true
        }
        if let selesDestrictArray = selesDestrictArray {
            if let aryOriginDestrictDes = (selesDestrictArray as NSArray).value(forKeyPath: "getLocaltionDes") as? [String], let aryCurDestrictDes = (destrictArray as NSArray).value(forKeyPath: "getLocaltionDes") as? [String] {
                if (aryOriginDestrictDes == aryCurDestrictDes) {
                    return false
                }else{
                    return true
                }
            }else{
                return false
            }
        }else{
            if destrictArray.count <= 0 {
                return false
            }else {
                return true
            }
        }
    }
    
    // 保存至pickerview
    fileprivate func saveAreaDataForPickerview() {
        // 省
        if let modelP = self.province {
            self.addressPickerView.province = RegisterAddressItemModel(name: modelP.infoName, code: modelP.infoCode)
            // 市
            if let modelD = self.district {
                self.addressPickerView.city = RegisterAddressItemModel(name: modelD.infoName, code: modelD.infoCode)
                // 区
                if let modelC = self.country {
                    self.addressPickerView.district = RegisterAddressItemModel(name: modelC.infoName, code: modelC.infoCode)
                }
            }
        }
    }
    
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("销售设置")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal"){[weak self] in
            if let strongSelf = self {
                strongSelf.view.endEditing(true)
                switch strongSelf.useFor {
                case .forRegister:
                    if strongSelf.isEditInfo() {
                        FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "您更改的信息还未保存，确定返回？", handler: { (alertView, isRight) in
                            if isRight {
                                FKYNavigator.shared().pop()
                            }
                        })
                    }else {
                        FKYNavigator.shared().pop()
                    }
                    
                case .forUpdate:
                    FKYNavigator.shared().pop()
                }
            }
        }
        self.fky_setupRightImage("") {
            // 保存
            self.collectionView.endEditing(true)
            
            if self.orderPrice == nil || self.orderPrice == "" {
                self.toast("请先填写起售金额")
                return
            }
            if self.destrictArray.count <= 0 {
                self.toast("请先选择销售范围")
                return
            }
            
            if let closure = self.saveClosure {
                closure(self.orderPrice, self.destrictArray)
            }
            FKYNavigator.shared().pop()
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.fontTuple = t19
        self.fky_hiddedBottomLine(false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        self.view.addSubview(addressPickerView)
        self.view.sendSubviewToBack(addressPickerView)
        addressPickerView.isHidden = true
        addressPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
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
            strongSelf.province = provinceObj   // 省
            strongSelf.district = cityObj       // 市
            strongSelf.country = districtObj    // 区
            // 增加新的地区
            if strongSelf.addressPickerView.province != nil {
                strongSelf.addDistrictToDistrictArray()
            }
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
    }
    
    func showAddressPickerView() {
        collectionView.endEditing(true)
        // 显示地址选择视图
        self.view.bringSubviewToFront(self.addressPickerView)
        self.addressPickerView.isHidden = false
        self.addressPickerView.showWithAnimation()
        self.addressPickerView.showSelectStatus()
    }
    
    //MARK: Life Cycle
    override func loadView() {
        super.loadView()
        originOrderPrice = orderPrice
        setupView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionViewDelegate&DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.titleArray.count + self.destrictArray.count)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            //
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsInputWithUnitCollectionCell", for: indexPath) as! FKYCredentialsInputWithUnitCollectionCell
            cell.configCell(title: self.titleArray[indexPath.row], content: orderPrice)
            cell.saveClosure = {[weak self] price in
                if let strongSelf = self {
                    strongSelf.orderPrice = price
                    strongSelf.collectionView.reloadData()
                }
            }
            cell.toastClosure = {[weak self] msg in
                if let strongSelf = self, msg != "" {
                    strongSelf.toast(msg)
                }
            }
            return cell
        }
        
        if indexPath.row == 1 {
            // 选择地区
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsAddDestrictCell", for: indexPath) as! FKYCredentialsAddDestrictCell
            cell.addDestrictClosure = {[weak self] in
                if let strongSelf = self {
                    strongSelf.showAddressPickerView()
                }
            }
            cell.configCell(self.titleArray[indexPath.row])
            return cell
        }
        
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsDestrictEditCell", for: indexPath) as! CredentialsDestrictEditCell
        let destrictModel = self.destrictArray[indexPath.row - 2]
        cell.configCell(destrictModel)
        cell.deleteClosure = {[weak self, weak collectionView] in
            if let strongSelf = self {
                strongSelf.destrictArray.remove(at: indexPath.row - 2)
            }
            if let strongCollectionView = collectionView {
                strongCollectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.refuseReason != nil {
            let height = self.refuseReason!.heightForRefuseReason() + h8 + h1
            return CGSize(width: SCREEN_WIDTH,height: height)
        }
        return CGSize(width: SCREEN_WIDTH, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            v.configCell("拒绝原因:", content: self.refuseReason)
            v.backgroundColor = bg1
            return v
        }else{
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            return v
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    // 新增销售区域
    func addDistrictToDistrictArray() {
        // 已有全国
        if let mo = self.destrictArray.first, mo.provinceCode == "000000" {
            self.destrictArray = [mo]
            self.toast("区域重复, 请重新选择")
            self.collectionView.reloadData()
            return
        }
        
        let destrictModel = SalesDestrictModel(province: self.province!, city: self.district, district: self.country)
        // 新增全国
        if destrictModel.provinceCode == "000000" {
            self.destrictArray = [destrictModel]
            self.collectionView.reloadData()
            return
        }
        
        // 去重
        let repeatArr = self.destrictArray.filter({ (model) -> Bool in
            return model.equalsTo(destrictModel)
        })
        if repeatArr.count <= 0 {
            self.destrictArray.append(destrictModel)
        }else{
            self.toast("区域重复, 请重新选择")
        }
        
        // 过滤全省
        let allProcvinceArray = self.destrictArray.filter({ (model) -> Bool in
            return (model.cityName == "")
        })
        if allProcvinceArray.count > 0 {
            self.destrictArray = self.destrictArray.filter({ (model) -> Bool in
                let allProvince = allProcvinceArray.filter({ (province) -> Bool in
                    return (province.provinceCode == model.provinceCode && model.cityName != "")
                })
                if allProvince.count > 0 {
                    self.toast("区域重复, 请重新选择")
                }
                return allProvince.count == 0
            })
        }
        
        // 过滤全市
        let allDistrictArray = self.destrictArray.filter({ (model) -> Bool in
            return (model.districtCode == "")
        })
        if allDistrictArray.count > 0 {
            self.destrictArray = self.destrictArray.filter({ (model) -> Bool in
                let allDistrict = allDistrictArray.filter({ (district) -> Bool in
                    return (district.cityCode == model.cityCode && model.districtName != "")
                })
                if allDistrict.count > 0 {
                    self.toast("区域重复, 请重新选择")
                }
                return allDistrict.count == 0
            })
        }
        
        self.collectionView.reloadData()
    }
}
