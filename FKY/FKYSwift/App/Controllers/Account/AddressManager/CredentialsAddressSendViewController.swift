//
//  CredentialsAddressSendViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  编辑收发货地址...<新增／编辑地址> 

import UIKit
import SnapKit

// MARK : 编辑收发货地址
typealias ReceiverAddressSaveClosure = (ZZReceiveAddressModel?)->(Void)


// MARK: -
class CredentialsAddressSendViewController: UIViewController, FKY_CredentialsAddressSendViewController {
    //MARK: - Property
    
    // 导航栏
    fileprivate lazy var navBar: UIView! = {
        if let _ = self.NavigationBar {
            //
        } else {
            self.fky_setupNavBar()
        }
        return self.NavigationBar!
    }()
    
    // 保存btn
    fileprivate lazy var btnSaveForSubmit: UIButton! = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.fontTuple = btn16.title
        button.layer.cornerRadius = WH(3)
        button.backgroundColor = btn16.defaultStyle.color
        button.setTitle("保存, 并提交", for: UIControl.State())
        button.addTarget(self, action: #selector(onBtnSaveForSubmit(_:)), for: .touchUpInside)
        return button
    }()
    
    // UICollectionView
    fileprivate lazy var collectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.alwaysBounceVertical = true
        cv.register(CredentialsInputCCell.self, forCellWithReuseIdentifier: "CredentialsInputCCell")
        cv.register(CredentialsSelectCCell.self, forCellWithReuseIdentifier: "CredentialsSelectCCell")
        cv.register(CredentialsAddressCRView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsAddressCRView")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BuyerSelectView")
        return cv
    }()
    
    // 地址选择视图
    fileprivate lazy var addressPickerView: FKYDeliveryAddressPickerView! = {
        // 默认使用读取本地db文件的方式来获取数据源
        let pickView = FKYDeliveryAddressPickerView(Provider: FKYAddressLocalProvider())
        //let pickView = FKYDeliveryAddressPickerView(Provider: FKYAddressRemoteProvider())
        // 若是编辑，而非新增，则需要传递对应的地址model
        if let addr = self.address {
            // 将省市区数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
            pickView.province = FKYAddressItemModel.init(code: addr.provinceCode, name: addr.provinceName, level: "1", parentCode: nil)
            pickView.city = FKYAddressItemModel(code: addr.cityCode, name: addr.cityName, level: "2", parentCode: nil)
            pickView.district = FKYAddressItemModel(code: addr.districtCode, name: addr.districtName, level: "3", parentCode: nil)
            pickView.town = FKYAddressItemModel(code: addr.avenu_code, name: addr.avenu_name, level: "4", parentCode: nil)
        }
        // 选择完成
        pickView.selectOverClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.editAddress.provinceName = pickView.province?.name
            strongSelf.editAddress.provinceCode = pickView.province?.code
            strongSelf.editAddress.cityName = pickView.city?.name
            strongSelf.editAddress.cityCode = pickView.city?.code
            strongSelf.editAddress.districtName = pickView.district?.name
            strongSelf.editAddress.districtCode = pickView.district?.code
            strongSelf.editAddress.avenu_name = pickView.town?.name
            strongSelf.editAddress.avenu_code = pickView.town?.code
            strongSelf.collectionView.reloadData()
        }
        // loading
        pickView.showLoadingClosure = { [weak self] showFlag in
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
        pickView.showToastClosure = { [weak self] (tip: String?) in
            guard let strongSelf = self else {
                return
            }
            guard let msg = tip, !msg.isEmpty else {
                return
            }
            strongSelf.toast(msg)
        }
        return pickView
    }()
    
    // 仓库地址视图引用...<主要用来直接刷新当前仓库地址，从而避免刷新整个collectionview，造成keyboard无法收回的bug>
    fileprivate var footerView: CredentialsAddressCRView?
    
    // 来源
    var fromType: NSString?
    
    // (企业)用户信息model
    var zzModel: ZZModel?
    
    // 通过企业名称获取的企业信息model
    var enterpriseInfoFromErp: ZZEnterpriseInfo?
    
    fileprivate var titleArray: [String] = ["收货人", "手机号或固话", "所在地区", "详细地址"]
    fileprivate var baseInfoProvider = CredentialsBaseInfoProvider()
    fileprivate var editAddress = ZZReceiveAddressModel()
    fileprivate var isSelect: Bool = false
    
    // 用户从地址列表界面传递用于编辑的地址model
    var address: ZZReceiveAddressModel? {
        willSet{
            print("willSet")
            // fix bug: 不可直接赋值，否则用户修改信息后，不保存，直接返回，导致地址信息已变更~!@
            //self.editAddress = newValue!
            if newValue != nil {
                // 列表界面传递过来的新值
                let address_temp: ZZReceiveAddressModel? = newValue!
                // 赋值
                if address_temp != nil {
                    self.editAddress = ZZReceiveAddressModel()
                    self.editAddress.id = address_temp?.id
                    self.editAddress.enterpriseId = address_temp?.enterpriseId
                    self.editAddress.receiverName = address_temp?.receiverName
                    self.editAddress.provinceCode = address_temp?.provinceCode
                    self.editAddress.cityCode = address_temp?.cityCode
                    self.editAddress.districtCode = address_temp?.districtCode
                    self.editAddress.avenu_code = address_temp?.avenu_code
                    self.editAddress.provinceName = address_temp?.provinceName
                    self.editAddress.cityName = address_temp?.cityName
                    self.editAddress.districtName = address_temp?.districtName
                    self.editAddress.avenu_name = address_temp?.avenu_name
                    self.editAddress.address = address_temp?.address
                    self.editAddress.print_address = address_temp?.print_address
                    self.editAddress.contactPhone = address_temp?.contactPhone
                    self.editAddress.defaultAddress = address_temp?.defaultAddress
                    self.editAddress.purchaser = address_temp?.purchaser
                    self.editAddress.purchaser_phone = address_temp?.purchaser_phone
                }
            }
        }
        didSet{
            print("didSet")
        }
    }
    
    // closure
    var saveClosure: ReceiverAddressSaveClosure?    // 完成
    var returnClosure: (()->())?                    // 返回
    
    
    // MARK: - LifeCircle
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showEnterpriseInfoFromErp()
        self.collectionView!.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // 移除通知
        //NotificationCenter.default.removeObserver(self)
        print("CredentialsAddressSendViewController")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.view.backgroundColor = bg2
        
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("编辑收发货地址")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal"){ [weak self] in
            if let returnActionCallBack = self!.returnClosure {
                returnActionCallBack()
            }
            FKYNavigator.shared().pop()
        }
        
        var bottomHeight = WH(10)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                bottomHeight = iPhoneX_SafeArea_BottomInset
            }
        }
    
        self.view.addSubview(btnSaveForSubmit)
        btnSaveForSubmit.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.view).offset(-bottomHeight)
            make.right.equalTo(self.view).offset(WH(-20))
            make.left.equalTo(self.view).offset(WH(20))
            make.height.equalTo(btn16.size.height)
        })
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.btnSaveForSubmit.snp.top).offset(WH(-10))
        })
        
        self.view.addSubview(self.addressPickerView)
        self.addressPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.view.sendSubviewToBack(self.addressPickerView)
        self.addressPickerView.isHidden = true
    }
}


// MARK: - enterpriseInfoFromErp
extension CredentialsAddressSendViewController {
    // 显示Erp返回的企业地址信息
    fileprivate func showEnterpriseInfoFromErp() {
        //
        if let addr = editAddress.address, addr.isEmpty == false {
            // 用户已经有地址
            return
        }
        
        guard let eModel = enterpriseInfoFromErp, let bCer = eModel.businessCertification, let bAddress = bCer.warehouseAddress, bAddress.isEmpty == false else {
            // 关键值为空
            return
        }
        
        let list = bAddress.split(separator: ",")
        guard list.count == 5, let province = list.first, province.isEmpty == false, let addr = list.last, addr.isEmpty == false else {
            // 不为5段
            return
        }
        
        //  省、市、区、镇名称
        let provinceCode: String? = String(list[0])
        let cityCode: String? = String(list[1])
        let districtCode: String? = String(list[2])
        let townCode: String? = String(list[3])
        let addressName: String? = String(list[4])
        
        guard let pCode = provinceCode, let cCode = cityCode, let dCode = districtCode, let tCode = townCode, pCode.isEmpty == false, cCode.isEmpty == false, dCode.isEmpty == false, tCode.isEmpty == false else {
            // 省、市、区、 镇名称有的为空
            return
        }
        
        self.showLoading()
        
        // 查省
        FKYAddressLocalProvider.queryAddressNameFromCode(pCode, 1) { (model) in
            guard let model = model else {
                self.dismissLoading()
                return
            }
            // 省model
            let provinceModel: FKYAddressItemModel? = model
            guard let provinceM = provinceModel else {
                self.dismissLoading()
                return
            }
            
            // 查市
            FKYAddressLocalProvider.queryAddressNameFromCode(cCode, 2, resultBlock: { (model) in
                guard let model = model else {
                    self.dismissLoading()
                    return
                }
                // 市model
                let cityModel: FKYAddressItemModel? = model
                guard let cityM = cityModel else {
                    self.dismissLoading()
                    return
                }
                
                // 查区
                FKYAddressLocalProvider.queryAddressNameFromCode(dCode, 3, resultBlock: { (model) in
                    guard let model = model else {
                        self.dismissLoading()
                        return
                    }
                    // 区model
                    let districtModel: FKYAddressItemModel? = model
                    guard let districtM = districtModel else {
                        self.dismissLoading()
                        return
                    }
                    
                    // 查镇
                    FKYAddressLocalProvider.queryAddressNameFromCode(tCode, 4, resultBlock: { (model) in
                        guard let model = model else {
                            self.dismissLoading()
                            return
                        }
                        // 镇model
                        let townModel: FKYAddressItemModel? = model
                        guard let townM = townModel else {
                            self.dismissLoading()
                            return
                        }
                        
                        // 全部查到
                        self.editAddress.provinceName = provinceM.name
                        self.editAddress.provinceCode = provinceM.code
                        self.editAddress.cityName = cityM.name
                        self.editAddress.cityCode = cityM.code
                        self.editAddress.districtName = districtM.name
                        self.editAddress.districtCode = districtM.code
                        self.editAddress.avenu_name = townM.name
                        self.editAddress.avenu_code = townM.code
                        self.editAddress.address = addressName
                        
                        // 将省市区数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
                        self.addressPickerView.province = FKYAddressItemModel.init(code: self.editAddress.provinceCode, name: self.editAddress.provinceName, level: "1", parentCode: nil)
                        self.addressPickerView.city = FKYAddressItemModel(code: self.editAddress.cityCode, name: self.editAddress.cityName, level: "2", parentCode: nil)
                        self.addressPickerView.district = FKYAddressItemModel(code: self.editAddress.districtCode, name: self.editAddress.districtName, level: "3", parentCode: nil)
                        self.addressPickerView.town = FKYAddressItemModel(code: self.editAddress.avenu_code, name: self.editAddress.avenu_name, level: "4", parentCode: nil)
                        
                        // 刷新
                        self.collectionView!.reloadData()
                        self.dismissLoading()
                        
                        // 仓库地址填充
                        self.autoSettingStockAddress()
                    })
                })
            })
        }
    }
}


// MARK: - User Action
extension CredentialsAddressSendViewController {
    // 保存当前地址~!@
    @objc func onBtnSaveForSubmit(_ sender: UITextField) {
        // 保存
        self.collectionView?.endEditing(true)
        
        // 校验
        if let receiverName = self.editAddress.receiverName, receiverName != "" {
            let justwords = receiverName.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写收货人")
                return
            }
        } else {
            self.toast("请先填写收货人")
            return
        }
        if let contactPhone = self.editAddress.contactPhone, contactPhone != "" {
            let justwords = contactPhone.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写联系方式")
                return
            }
            let regex = "^((1[3-9][0-9]))\\d{8}$|^0\\d{2,3}-?\\d{7,8}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: justwords)
            if isValid == false{
                self.toast("您的联系方式格式有误，请输1开头手机号或区号0开头固定电话")
                return
            }
        } else {
            self.toast("请先填写联系方式")
            return
        }
        if self.editAddress.provinceCode == nil || self.editAddress.provinceCode == "" {
            self.toast("请先选择所在地区")
            return
        }
        if let address = self.editAddress.address, address != "" {
            let justwords = address.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写详细地址")
                return
            }
        } else {
            self.toast("请先填写详细地址")
            return
        }
        if let print_address = self.editAddress.print_address, print_address != "" {
            let justwords = print_address.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写仓库地址")
                return
            }
        } else {
            self.toast("请先填写仓库地址")
            return
        }
        if isSelect {
            self.editAddress.purchaser = self.editAddress.receiverName
            self.editAddress.purchaser_phone = self.editAddress.contactPhone
        }
        if let purchaser = self.editAddress.purchaser, purchaser != "" {
            let justwords = purchaser.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写采购员")
                return
            }
        } else {
            self.toast("请先填写采购员")
            return
        }
        if let phone = self.editAddress.purchaser_phone, phone != "" {
            let justwords = phone.replacingOccurrences(of: " ", with: "")
            if 0 >= justwords.count {
                self.toast("请先填写采购员联系方式")
                return
            }
            let regex = "^((1[3-9][0-9]))\\d{8}$|^0\\d{2,3}-?\\d{7,8}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: justwords)
            if isValid == false{
                self.toast("您的联系方式格式有误，请输1开头手机号或区号0开头固定电话")
                return
            }
        } else {
            self.toast("请先填写采购员联系方式")
            return
        }
        
        if  self.fromType == "selectList" || self.fromType == "submit" || self.fromType == "forRegitster" {
            // 从购物车、选择收货地址、提交订单等流程进入 注册完善资料?
            if self.address != nil && self.fromType == "forRegitster" {
                // 编辑地址 & 注册（基本资料）
                self.showLoading()
                self.baseInfoProvider.updateAddress(self.editAddress, complete: { (issuccess, message) in
                    self.dismissLoading()
                    if issuccess {
                        // 更新成功
                        FKYNavigator.shared()?.openScheme(FKY_RIImageController.self, setProperty: { (vc) in
                            let controller: RIImageController = vc as! RIImageController
                            controller.showMode = .submit // 上传
                        }, isModal: false, animated: true)
                    }
                    else {
                        // 更新失败
                        self.toast(message)
                    }
                })
            }
            else {
                // 新增地址
                self.showLoading()
                self.baseInfoProvider.addAddress(self.editAddress, complete: {(issuccess, addressInfo, msg) in
                    self.dismissLoading()
                    if issuccess {
                        // 新增成功
                        if self.fromType == "selectList" || self.fromType == "submit" {
                            // 其它
                            if let closure = self.saveClosure {
                                closure(self.editAddress)
                            }
                            FKYNavigator.shared().pop()
                            //
                            self.toast("保存成功")
                        }
                        if self.fromType == "forRegitster" {
                            // 注册（基本资料）
                            self.address = addressInfo
                            // 跳转下个界面
                            FKYNavigator.shared()?.openScheme(FKY_RIImageController.self, setProperty: { (vc) in
                                let controller: RIImageController = vc as! RIImageController
                                controller.showMode = .submit // 上传
                            }, isModal: false, animated: true)
                        }
                    }
                    else {
                        // 新增失败
                        var message = "保存失败"
                        if let msg = msg, msg.isEmpty == false {
                            message = msg
                        }
                        self.toast(message)
                    }
                })
            }
        }
        else {
            // 从个人中心之地址管理流程进入...<不再有此入口>
            if let closure = self.saveClosure {
                closure(self.editAddress)
            }
            FKYNavigator.shared().pop()
        }
    }
}


// MARK: - Private
extension CredentialsAddressSendViewController {
    // 跳转到销售单示例界面
    fileprivate func showSaleInfo() {
        self.view.endEditing(true)
        let saleInfoVC = FKYShowSaleInfoViewController()
        FKYNavigator.shared().topNavigationController.pushViewController(saleInfoVC, animated: true, snapshotFirst: false)
    }
    
    // 自动填充仓库地址
    fileprivate func autoSettingStockAddress() {
        // 仓库地址
        var stockAddress: String? = self.editAddress.print_address
        if let sa = stockAddress, sa.isEmpty == false, sa.count > 0 {
            // 若已经有了仓库地址，则不自动填充
            return
        }
        
        // 详细地址
        var address: String? = self.editAddress.address
        address = address?.replacingOccurrences(of: " ", with: "")
        if let a = address, a.isEmpty == false, a.count > 0 {
            // 有详细地址
        }
        else {
            // 无详细地址
            return
        }
        
        // 地区
        var area: String? = self.editAddress.addressDistrictDesc
        if let a = area, a.isEmpty == false, a.count > 0 {
            // 有地区
        }
        else {
            // 无地区
            area = ""
        }
        
        // 自动拼装的仓库地址
        stockAddress = String(area! + address!)
        stockAddress = stockAddress?.replacingOccurrences(of: " ", with: "")
        self.editAddress.print_address = stockAddress
        
        // 刷新地址
        self.footerView?.configView(stockAddress)
    }
}


// MARK: - UICollectionViewDelegate
extension CredentialsAddressSendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.titleArray.count
        }
        else {
            return 2;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // 收货地址
            if indexPath.row == 2 {
                // 所在地区
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsSelectCCell", for: indexPath) as! CredentialsSelectCCell
                cell.configCell(self.titleArray[indexPath.row], content:self.editAddress.addressDistrictDesc)
                return cell
            }
            else {
                // 其它
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCCell", for: indexPath) as! CredentialsInputCCell
                if indexPath.row == 0 {
                    // 收货人
                    cell.configCell(self.titleArray[indexPath.row], content: self.editAddress.receiverName, type: .BaseInfo)
                    cell.saveClosure = { msg in
                        self.editAddress.receiverName = msg
                        self.collectionView.reloadData()
                    }
                }
                else if indexPath.row == 1 {
                    // 手机号或固话
                    cell.configCell(self.titleArray[indexPath.row], content: self.editAddress.contactPhone, type: .TelePhone)
                    cell.saveClosure = { msg in
                        self.editAddress.contactPhone = msg
                        self.collectionView.reloadData()
                    }
                }
                else if indexPath.row == 3 {
                    // 详细地址
                    cell.configCell(self.titleArray[indexPath.row], content: self.editAddress.address, type: .AddressDetail)
                    cell.saveClosure = { msg in
                        self.editAddress.address = msg
                        // 新增逻辑: 把详细地址带到下面的仓库地址中
                        self.autoSettingStockAddress()
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
//                            self.autoSettingStockAddress()
//                        })
                    }
                }
                return cell
            }
        }
        else {
            // 仓库地址
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCCell", for: indexPath) as! CredentialsInputCCell
            if indexPath.row == 0 {
                // 采购员
                cell.configCell("采购员", content: self.editAddress.purchaser, type: .BaseInfo)
                cell.saveClosure = { msg in
                    self.editAddress.purchaser = msg
                    self.collectionView.reloadData()
                }
            }
            else if indexPath.row == 1 {
                // 联系方式
                cell.configCell("联系方式", content: self.editAddress.purchaser_phone, type: .TelePhone)
                cell.saveClosure = { msg in
                    self.editAddress.purchaser_phone = msg
                    self.collectionView.reloadData()
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(50))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 地区选择
        if indexPath.section == 0, indexPath.row == 2 {
            // 隐藏键盘
            self.collectionView?.endEditing(true)
            // 显示地址选择视图
            self.view.bringSubviewToFront(self.addressPickerView!)
            self.addressPickerView!.isHidden = false
            self.addressPickerView!.showWithAnimation()
            self.addressPickerView!.showSelectStatus()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: SCREEN_WIDTH, height: WH(120))
        }
        else {
            return CGSize(width: SCREEN_WIDTH, height: WH(90))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionFooter {
                // 仓库地址
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsAddressCRView", for: indexPath) as! CredentialsAddressCRView
                view.configView(self.editAddress.print_address)
                view.saveClosure = { msg in
                    //print("saveAddress")
                    self.editAddress.print_address = msg
                }
                view.showSaleInfoClosure = { msg in
                    //print("showSaleInfo")
                    self.showSaleInfo()
                }
                self.footerView = view // 用于外部引用来更新地址
                return view
            }
        }
        else {
            if kind == UICollectionView.elementKindSectionFooter {
                // 底部视图...<与收货人信息一致>
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BuyerSelectView", for: indexPath)
                view.backgroundColor = UIColor.clear
                
                let topView = UIView()
                topView.backgroundColor = UIColor.white
                view.addSubview(topView)
                topView.snp.makeConstraints { (make) in
                    make.top.equalTo(view)
                    make.left.equalTo(view)
                    make.right.equalTo(view)
                    make.height.equalTo(WH(40))
                }
                
                let btn = UIButton()
                btn.backgroundColor = UIColor.clear
                btn.setTitle("与收货人信息一致", for: UIControl.State())
                btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
                btn.setTitleColor(RGBColor(0x666666), for: .normal)
                btn.setTitleColor(RGBColor(0x333333), for: .highlighted)
                btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(25), bottom: 0, right: 0)
                btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -WH(30), bottom: 0, right: 0)
                // 判断btn是否勾选
                if let name = self.editAddress.receiverName, name.isEmpty == false,
                    let phone = self.editAddress.contactPhone, phone.isEmpty == false,
                    (self.editAddress.receiverName == self.editAddress.purchaser),
                    (self.editAddress.contactPhone == self.editAddress.purchaser_phone) {
                    // 不为空，且相等
                    btn.setImage(UIImage(named: "icon_cart_selected"), for: UIControl.State())
                    self.isSelect = true
                }
                else {
                    // 其它
                    btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControl.State())
                    self.isSelect = false
                }
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    let purchaserCell = strongSelf.collectionView?.cellForItem(at: IndexPath(item: 0, section: 1)) as! CredentialsInputCCell
                    let purchaserPhoneCell = strongSelf.collectionView?.cellForItem(at: IndexPath(item: 1, section: 1)) as! CredentialsInputCCell
                    
                    strongSelf.isSelect = !strongSelf.isSelect
                    if strongSelf.isSelect {
                        // 选中
                        btn.setImage(UIImage(named: "icon_cart_selected"), for: UIControl.State())
                        
                        if let _ = strongSelf.editAddress.receiverName, let _ = strongSelf.editAddress.contactPhone {
                            // 收货人信息完备
                            purchaserCell.configCell("采购员", content: strongSelf.editAddress.receiverName, type: .BaseInfo)
                            purchaserPhoneCell.configCell("联系方式", content: strongSelf.editAddress.contactPhone, type: .TelePhone)
                        }
                        else {
                            // 收货人信息不完备
                            strongSelf.toast("请先完善收货人信息！")
                            
                            // 重置
                            btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControl.State())
                            strongSelf.isSelect = false
                        }
                    }
                    else {
                        // 未选中
                        if let name = strongSelf.editAddress.receiverName, name.isEmpty == false,
                            let phone = strongSelf.editAddress.contactPhone, phone.isEmpty == false,
                            (strongSelf.editAddress.receiverName == strongSelf.editAddress.purchaser),
                            (strongSelf.editAddress.contactPhone == strongSelf.editAddress.purchaser_phone) {
                            // 相同，不可手动变不同
                            strongSelf.toast("收货人信息一致，请手动修改！")
                            btn.setImage(UIImage(named: "icon_cart_selected"), for: UIControl.State())
                            return
                        }
                        
                        btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControl.State())
                        
                        purchaserCell.configCell("采购员", content: strongSelf.editAddress.purchaser, type: .BaseInfo)
                        purchaserPhoneCell.configCell("联系方式", content: strongSelf.editAddress.purchaser_phone, type: .TelePhone)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                topView.addSubview(btn)
                btn.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(topView)
                    make.left.equalTo(topView).offset(WH(5))
                    make.width.equalTo(WH(168))
                    make.height.equalTo(WH(40))
                })
                
                let bottomLabel = UILabel()
                bottomLabel.textColor = UIColor.init(red: 255/255.0, green: 79/255.0, blue: 79/255.0, alpha: 1)
                bottomLabel.numberOfLines = 0
                bottomLabel.minimumScaleFactor = 0.9
                bottomLabel.adjustsFontSizeToFitWidth = true
                bottomLabel.font = UIFont.systemFont(ofSize: WH(12))
                let str = "请注意：\n为方便卖家与您及时取得联系，请完善采购人员相关信息"
                let paraph = NSMutableParagraphStyle()
                paraph.lineSpacing = 4
                let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12)), NSAttributedString.Key.paragraphStyle: paraph]
                bottomLabel.attributedText = NSAttributedString(string: str, attributes: attributes)
                view.addSubview(bottomLabel)
                bottomLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(view).offset(WH(15))
                    make.right.equalTo(view).offset(WH(0))
                    make.top.equalTo(topView.snp.bottom)
                    make.height.equalTo(WH(50))
                }
                
                return view
            }
        }
        
        return UICollectionReusableView()
    }
}
