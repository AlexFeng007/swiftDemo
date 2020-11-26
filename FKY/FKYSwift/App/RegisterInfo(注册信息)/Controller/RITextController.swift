//
//  RITextController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  注册信息（资料管理）之文本内容...<公司信息 & 收货信息>

import UIKit

class RITextController: UIViewController {
    //MARK: - Property
    
    // ViewModel
    fileprivate lazy var viewModel = RITextViewModel()
    
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
    
    // 顶部提示视图...<置顶>
    fileprivate lazy var viewTip: RITopTipView = {
        let view = RITopTipView()
        view.configView("企业名称请与营业执照保持一致，否则卖家会拒绝为您发货")
        return view
    }()
    
    // 输入列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.backgroundView = nil
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.separatorColor = RGBColor(0xE5E5E5) // 分隔线颜色
        view.rowHeight = UITableView.automaticDimension // 设置高度自适应
        view.estimatedRowHeight = cellHeightInput // 预设高度
        view.tableHeaderView = self.viewProgress
        //view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(30)))
            view.backgroundColor = .clear
            return view
        }()
        view.register(RISwitchCell.self, forCellReuseIdentifier: "RISwitchCell")
        view.register(RITextInputCell.self, forCellReuseIdentifier: "RITextInputCell")
        view.register(RISelectInfoCell.self, forCellReuseIdentifier: "RISelectInfoCell")
        view.register(RITextLongInputCell.self, forCellReuseIdentifier: "RITextLongInputCell")
        view.register(RISelectLongInfoCell.self, forCellReuseIdentifier: "RISelectLongInfoCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 进度视图...<table-header>
    fileprivate lazy var viewProgress: RITopProgressView = {
        let view = RITopProgressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(80)))
        // 默认处于步骤1
        view.configView(1)
        return view
    }()
    
    // 底部视图...<下一步>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xFFFFFF)
        // 按钮
        view.addSubview(self.btnSubmit)
        self.btnSubmit.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(10), left: WH(20), bottom: WH(10), right: WH(20)))
        }
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    // 下一步按钮
    fileprivate lazy var btnSubmit: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("下一步", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitAction()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 企业地区选择选择视图...<三级地址>...<包含定位功能>
    fileprivate lazy var addressPickerView: RegisterAddressPickerView = {
        let picker = RegisterAddressPickerView.init(frame: CGRect.zero, location: true)
        return picker
    }()
    
    // 收货地区选择视图...<四级地址>...<不包含定位功能>
    fileprivate lazy var areaPickerView: FKYDeliveryAddressPickerView = {
        // 默认使用读取本地db文件的方式来获取数据源
        let pickView = FKYDeliveryAddressPickerView(Provider: FKYAddressLocalProvider())
        return pickView
    }()
    
    // 全局引用当前类型的cell
    fileprivate var receiveBtnCell: RISwitchCell?
    // 全局引用键盘是否显示
    fileprivate var keyboardShow: Bool = false
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupClosure()
        setupData()
        setupRequest()
        
        // app进后台时缓存数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveCacheData), name: UIApplication.willResignActiveNotification, object: nil)
        
        // 监控键盘
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 开启切换
        IQKeyboardManager.shared().previousNextDisplayMode = .default
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 20.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隐藏切换
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("RITextController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
        // 缓存
        //saveCacheData()
    }
}


// MARK: - UI
extension RITextController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("资料管理")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            FKYNavigator.shared().pop()
            // 从缓存中读的数据，且用户未提交，则返回时需保存
            if strongSelf.viewModel.dataFromCacheFlag {
                strongSelf.viewModel.saveEnterpriseInfoForCache()
            }
        }
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        // 底部提交视图
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(WH(62))
        }
        
        // 顶部提示视图
        view.addSubview(viewTip)
        let heightTip = viewTip.getContentHeight()
        viewTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.navBar!.snp.bottom)
            //make.height.equalTo(WH(32))
            make.height.equalTo(heightTip)
        }
        
        // 中间列表视图
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewBottom.snp.top)
            make.top.equalTo(viewTip.snp.bottom)
        }
        tableview.reloadData()
        
        // (企业)地区选择视图
        view.addSubview(addressPickerView)
        addressPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        addressPickerView.isHidden = true
        view.sendSubviewToBack(addressPickerView)
        
        // (收货)地区选择视图
        view.addSubview(areaPickerView)
        areaPickerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        areaPickerView.isHidden = true
        view.sendSubviewToBack(areaPickerView)
    }
}


// MARK: - Data
extension RITextController {
    //
    fileprivate func setupData() {
        //
    }
}


// MARK: - Request
extension RITextController {
    //
    fileprivate func setupRequest() {
        // 默认先请求接口数据...<防止同一账号多台手机登录操作时出现问题>
        requestForEnterpriseInfo(false)
    }
    
    // 请求用户输入的文本信息...<企业信息+收货信息+资质图片>
    fileprivate func requestForEnterpriseInfo(_ refresh: Bool) {
        if refresh == false {
            // 非刷新，则需要loading
            showLoading()
        }
        viewModel.requestForInputTextInfo { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            if refresh == false {
                // 非刷新
                strongSelf.dismissLoading()
            }
            else {
                // 刷新
                strongSelf.tableview.reloadData()
                return
            }
            // 是否需要读取缓存数据
            var needCache: Bool = false
            if success {
                print("企业资质信息请求成功")
                if strongSelf.viewModel.dataFromCacheFlag == false {
                    // 接口有数据
                }
                else {
                    // 接口无数据
                    needCache = true
                }
            }
            else {
                print("企业资质信息请求失败")
                needCache = true
            }
            // 接口有返回数据，则直接显示；接口未返回数据，则读缓存数据
            if needCache {
                // 需读取缓存
                strongSelf.requestForCacheData()
            }
            else {
                // 刷新
                strongSelf.tableview.reloadData()
                // 请求经营范围
                strongSelf.requestForDrugScope(false)
            }
        }
    }
    
    // 从缓存中读取用户本地保存的企业信息data...<用户填写企业信息后未提交>
    fileprivate func requestForCacheData() {
        showLoading()
        viewModel.getEnterpriseInfoFromCache { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                print("有缓存")
            }
            else {
                print("无缓存")
            }
            // 刷新
            strongSelf.tableview.reloadData()
            // 请求经营范围
            strongSelf.requestForDrugScope(false)
        }
    }
    
    // 请求经营范围
    fileprivate func requestForDrugScope(_ jump: Bool) {
        if jump {
            showLoading()
        }
        viewModel.requestForDrugScope { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            if jump {
                strongSelf.dismissLoading()
            }
            if success {
                print("经营范围请求成功")
                if jump {
                    // 跳转到经营范围界面...<防止界面进入时的那次请求失败>
                    strongSelf.selectDrugScrope()
                }
                // 刷新
                strongSelf.tableview.reloadData()
            }
            else {
                print("经营范围请求失败")
                if jump {
                    strongSelf.toast("获取经营范围失败")
                }
            }
        }
    }
    
    // 通过企业名称来获取企业信息
    fileprivate func requestEnterpriseInfoByName(_ name: String?, _ type: RITextInputType) {
        guard let name = name, name.isEmpty == false else {
            return
        }
        
        // test
//        //let name_ = "福州市鼓楼区华济堂药店"
//        //let name_ = "长沙县星沙灰埠诚益信大药房"
//        //let name_ = "唐山惠好医药连锁有限公司钱营店"
//        let name_ = "上海金平医药有限公司"
//        //let name_ = "七台河市新兴区新林大药房"
//        //let name_ = "珠海市民众医药有限公司拱北店"
        
        showLoading()
        viewModel.requestForEnterpriseInfoFromErp(name, type) { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                print("查询企业信息失败")
                return
            }
            // 成功
            print("查询企业信息成功")
            // 刷新
            strongSelf.tableview.reloadData()
            // 显示查询到的地区、地址信息
            strongSelf.showEnterpriseInfoFromErp(type)
            // 显示收货地区、地址
            if type == .enterpriseName {
                strongSelf.showReceiveInfoFromErp()
            }
        }
    }
    
    // 提交
    fileprivate func requestForSubmit() {
        showLoading()
        viewModel.requestForSubmit { [weak self] (success, msg, data) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success {
                print("提交成功")
                // 跳转
                FKYNavigator.shared()?.openScheme(FKY_RIImageController.self, setProperty: { (vc) in
                    let controller: RIImageController = vc as! RIImageController
                    controller.showMode = .submit // 上传并提交审核
                }, isModal: false, animated: true)
                // 删除缓存
                strongSelf.viewModel.deleteEnterpriseInfoInCache()
                // 判断是否需要刷新
                strongSelf.requestForRefresh()
            }
            else {
                print("提交失败")
                strongSelf.toast(msg)
            }
        }
    }
    
    // 若是保存，则需要刷新界面以获取各类型id（否则用户在当前界面再次提交时接口报错）；若是更新，则不需要刷新；
    fileprivate func requestForRefresh() {
        // 若model中已有这两个id，则表示一定是更新，而不是保存
        if let model = viewModel.enterpriseInfoModel.enterprise, let id = model.id, id > 0, let eid = model.enterpriseId, eid.isEmpty == false {
            return
        }
        
        // 刷新
        requestForEnterpriseInfo(true)
    }
}


//MARK: - Notification

extension RITextController {
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardShow = true
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardShow = false
    }
}


// MARK: - Private
extension RITextController {
    // 选择地区...<企业地区为三级，收货地区为四级>
    fileprivate func selectAddressArea(_ type: RITextInputType) {
        if type == .enterpriseArea || type == .enterpriseAreaRetail {
            // 企业地区 or 零售企业地区
            if type == .enterpriseArea {
                // 企业地区
                if let pcode = viewModel.enterpriseArea.provinceCode, pcode.isEmpty == false {
                    // 有值
                    // 保存到pickerview中
                    addressPickerView.province = RegisterAddressItemModel(name: viewModel.enterpriseArea.provinceName, code: viewModel.enterpriseArea.provinceCode)
                    addressPickerView.city = RegisterAddressItemModel(name: viewModel.enterpriseArea.cityName, code: viewModel.enterpriseArea.cityCode)
                    addressPickerView.district = RegisterAddressItemModel(name: viewModel.enterpriseArea.districtName, code: viewModel.enterpriseArea.districtCode)
                    //addressPickerView.address = viewModel.enterpriseAddress
                }
                else {
                    // 无值
                    addressPickerView.province = nil
                    addressPickerView.city = nil
                    addressPickerView.district = nil
                    //addressPickerView.address = nil
                }
            }
            else {
                // 零售企业地区
                if let pcode = viewModel.enterpriseAreaRetail.provinceCode, pcode.isEmpty == false {
                    // 有值
                    // 保存到pickerview中
                    addressPickerView.province = RegisterAddressItemModel(name: viewModel.enterpriseAreaRetail.provinceName, code: viewModel.enterpriseAreaRetail.provinceCode)
                    addressPickerView.city = RegisterAddressItemModel(name: viewModel.enterpriseAreaRetail.cityName, code: viewModel.enterpriseAreaRetail.cityCode)
                    addressPickerView.district = RegisterAddressItemModel(name: viewModel.enterpriseAreaRetail.districtName, code: viewModel.enterpriseAreaRetail.districtCode)
                    //addressPickerView.address = viewModel.enterpriseAddressRetail
                }
                else {
                    // 无值
                    addressPickerView.province = nil
                    addressPickerView.city = nil
                    addressPickerView.district = nil
                    //addressPickerView.address = nil
                }
            }
            
            // 显示地址选择视图
            view.bringSubviewToFront(addressPickerView)
            addressPickerView.isHidden = false
            addressPickerView.flagMultiUse = true   // 多个地址栏共用当前这一个picker
            addressPickerView.selectType = type     // 当前地址栏类型
            addressPickerView.showWithAnimation()
            addressPickerView.showSelectStatus()
        }
        else if type == .receiveArea {
            // 收货地区
            
            // 赋值
            if let pcode = viewModel.receiveArea.provinceCode, pcode.isEmpty == false {
                // 有值
                // 将省市区镇数据保存到pickerview中，便于视图弹出时自动显示当前保存的地区信息
                areaPickerView.province = FKYAddressItemModel.init(code: viewModel.receiveArea.provinceCode, name: viewModel.receiveArea.provinceName, level: "1", parentCode: nil)
                areaPickerView.city = FKYAddressItemModel(code: viewModel.receiveArea.cityCode, name: viewModel.receiveArea.cityName, level: "2", parentCode: nil)
                areaPickerView.district = FKYAddressItemModel(code: viewModel.receiveArea.districtCode, name: viewModel.receiveArea.districtName, level: "3", parentCode: nil)
                areaPickerView.town = FKYAddressItemModel(code: viewModel.receiveArea.avenu_code, name: viewModel.receiveArea.avenu_name, level: "4", parentCode: nil)
            }
            else {
                // 无值
                areaPickerView.province = nil
                areaPickerView.city = nil
                areaPickerView.district = nil
                areaPickerView.town = nil
            }
            
            // 显示地址选择视图
            view.bringSubviewToFront(areaPickerView)
            areaPickerView.isHidden = false
            areaPickerView.showWithAnimation()
            areaPickerView.showSelectStatus()
        }
        else {
            // error
            print("错误的celltype")
        }
    }
    
    // 选择企业类型
    fileprivate func selectEnterpriseType() {
        // 跳转企业类型选择界面
        let enterpriseVC = CredentialsEnterpriseTypeController()
        // 赋值
        enterpriseVC.selectedEnterpriseType = viewModel.enterpriseType
        // 企业类型选择回调
        enterpriseVC.saveClosure = { [weak self, weak tableview] (enterpriseType) in
            guard let strongSelf = self else {
                return
            }
            guard let type = enterpriseType else {
                return
            }
            // 保存
            strongSelf.viewModel.setCellValue(.enterpriseType, nil, type)
            // 刷新界面
            if let tv = tableview {
                tv.reloadData()
            }
        }
        // 跳转
        FKYNavigator.shared().topNavigationController.pushViewController(enterpriseVC, animated: true, snapshotFirst: false)
    }
    
    // 填写银行信息
    fileprivate func inputBankInfo() {
        let bankInfoVC = CredentialsBankInfoController()
        bankInfoVC.canEdit = true
        bankInfoVC.useFor = .forRegister
        bankInfoVC.bankInfoModel = viewModel.bankInfo
        bankInfoVC.saveClosure = { [weak self, weak tableview] (bankInfo) in
            guard let strongSelf = self else {
                return
            }
            // 保存
            strongSelf.viewModel.bankInfo = bankInfo
            // 设置类型id
            if let obj: ZZFileModel = strongSelf.viewModel.bankInfo?.QCFile {
                obj.typeId = 3
            }
            // 刷新界面
            if let tv = tableview {
                tv.reloadData()
            }
        }
        FKYNavigator.shared().topNavigationController.pushViewController(bankInfoVC, animated: true, snapshotFirst: false)
    }
    
    // 选择经营范围
    fileprivate func selectDrugScrope() {
        guard viewModel.enterpriseType != nil else {
            toast("请先选择企业类型")
            return
        }
        
        // 未获取经营范围，需实时请求一次
        guard viewModel.drugScopesList.count > 0 else {
            requestForDrugScope(true)
            return
        }
        
        let businessScopeVC = CredentialsBusinessScopeForBaseInfoController()
        businessScopeVC.drugScopes = viewModel.drugScopesList
        businessScopeVC.saveClosure = { [weak self, weak tableview] (scopes) in
            guard let strongSelf = self else {
                return
            }
            // 保存...<只保存所有已选中的项>
            if let list = scopes, list.count > 0 {
                strongSelf.viewModel.drugScopes = list
                strongSelf.viewModel.drugScopesRemoveAll = false
            }
            else {
                strongSelf.viewModel.drugScopes.removeAll()
                strongSelf.viewModel.drugScopesRemoveAll = true
            }
            // 更新
            //strongSelf.viewModel.processDrugScopeData()
            
            // 刷新界面
            if let tv = tableview {
                tv.reloadData()
            }
        }
        FKYNavigator.shared().topNavigationController.pushViewController(businessScopeVC, animated: true, snapshotFirst: false)
    }
    
    // app进后台时缓存数据
    @objc fileprivate func saveCacheData() {
        print("saveCacheData for text")
        // 从缓存中读的数据，且用户未提交，则返回时需保存
        if viewModel.dataFromCacheFlag {
            viewModel.saveEnterpriseInfoForCache()
        }
    }
}


// MARK: - Action
extension RITextController {
    // 提交
    fileprivate func submitAction() {
        // 合法性校验
        let result: (Bool, String?) = viewModel.checkSubmitStatus()
        guard result.0 == true else {
            if let txt = result.1, txt.isEmpty == false {
                toast(txt)
            }
            return
        }

        // 提交
        requestForSubmit()
    }
    
    // cell选择
    fileprivate func selectAction(_ type: RITextInputType) {
        // 隐藏键盘
        view.endEditing(true)
        
        if type == .enterpriseName ||
            type == .enterpriseNameRetail {
            // 企业名称
            let name = viewModel.getCellValue(type)
            searchEnterpriseName(enterpriseName: (name ?? ""), type: type)
        }
        else if type == .enterpriseArea ||
            type == .enterpriseAreaRetail ||
            type == .receiveArea {
            // 地区
            selectAddressArea(type)
        }
        else if type == .enterpriseType {
            // 企业类型
            selectEnterpriseType()
        }
        else if type == .enterpriseBankInfo {
            // 银行信息
            inputBankInfo()
        }
        else if type == .drugScope {
            // 经营范围
            selectDrugScrope()
        }
    }
    
    // cell开关
    fileprivate func switchAction(_ type: RITextInputType, _ openFlag: Bool) {
        // 先隐藏键盘
        //view.endEditing(true)
        
        if type == .allInOneSelect {
            // 是否批零一体
            viewModel.allInOneFlag = openFlag
        }
        else if type == .samePersonSelect {
            // 是否与收货人信息一致
            //viewModel.samePersonFlag = openFlag
            
            // 若本来就一致，则不刷新
            if viewModel.samePersonFlag == openFlag {
                return
            }
            
            // 当前为用户操作~!@
            viewModel.userSelectFlag = true
            // 禁止用户操作
            //view.isUserInteractionEnabled = false
            
            // 先隐藏键盘
            view.endEditing(true)
            
            // 判断逻辑
            if openFlag {
                // 选中...<用户手动选择保持一致>
                if let name = viewModel.receiveName, name.isEmpty == false,
                    let phone = viewModel.receivePhone, phone.isEmpty == false {
                    // 收货人信息完备
                    viewModel.samePersonFlag = openFlag
                }
                else {
                    // 收货人信息不完备
                    toast("请先完善收货人信息！")
                    viewModel.samePersonFlag = false
                }
            }
            else {
                // 未选中...<用户手动选择不一致>
                viewModel.samePersonFlag = openFlag
                
                // 当前两个收货信息已经一致，不可设置为NO
                if viewModel.checkSameStatusForReceiveInfo() {
                    toast("收货人信息一致，请手动修改！")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 更新
                strongSelf.viewModel.userSelectFlag = false
                // 放开用户操作
                //self.view.isUserInteractionEnabled = true
            }
        }
        
        // 延迟...<以便开关动画能完整展示>
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 刷新
            strongSelf.tableview.reloadData()
        }
    }
}


// MARK: - 企业名实时联想相关
extension RITextController {
    // 跳转企业名称列表视图
    fileprivate func searchEnterpriseName(enterpriseName: String, type: RITextInputType) {
        // 企业名称联想搜索界面
        let nameController = RIEnterpriseListController()
        nameController.cellType = type
        nameController.enterpriseName = (type == .enterpriseName ? viewModel.enterpriseName : viewModel.enterpriseNameRetail)
        // 选择item回调
        nameController.selectEnterpriseClosure = { [weak self] (name) in
            guard let strongSelf = self else {
                return
            }
            guard let txt = name, txt.isEmpty == false else {
                return
            }
            // 保存
            if type == .enterpriseName {
                // (非批发or批发)企业名称
                strongSelf.viewModel.enterpriseName = txt
            }
            else if type == .enterpriseNameRetail {
                // 零售企业名称
                strongSelf.viewModel.enterpriseNameRetail = txt
            }
            // 用户选择指定的企业名称，无地区、地址信息，故需保存/显示后面接口请求到的地区、地址信息
            strongSelf.requestEnterpriseInfoByName(txt, type)
            // 刷新
            strongSelf.tableview.reloadData()
        }
        // 编辑完成回调
        nameController.inputTextClosure = { [weak self] (txt) in
            guard let strongSelf = self else {
                return
            }
            // 保存企业名称
            if type == .enterpriseName {
                strongSelf.viewModel.enterpriseName = txt
            }
            else if type == .enterpriseNameRetail {
                strongSelf.viewModel.enterpriseNameRetail = txt
            }
            // 用户仅输入关键字，无地区、地址信息，故需保存/显示后面接口请求到的地区、地址信息
            strongSelf.requestEnterpriseInfoByName(txt, type)
            // 刷新
            strongSelf.tableview.reloadData()
        }
        FKYNavigator.shared().topNavigationController.pushViewController(nameController, animated: true, snapshotFirst: false)
    }
    
    // 显示企业信息中的地区、地址内容
    fileprivate func showEnterpriseInfoFromErp(_ type: RITextInputType) {
        // 非空地址字符串
        var addrString = ""
        // 非空判断
        if type == .enterpriseName {
            guard let model = viewModel.enterpriseInfoFromErp, let businessLicense = model.businessLicense, let address = businessLicense.registeredAddress, address.isEmpty == false else {
                return
            }
            addrString = address
        }
        else if type == .enterpriseNameRetail {
            guard let model = viewModel.enterpriseInfoRetailFromErp, let businessLicense = model.businessLicense, let address = businessLicense.registeredAddress, address.isEmpty == false else {
                return
            }
            addrString = address
        }
        
        // 必须4段...<省、市、区、地址>
        let list = addrString.split(separator: ",")
        guard list.count == 4, let province = list.first, province.isEmpty == false, let addr = list.last, addr.isEmpty == false else {
            return
        }
        
        //  省、市、区、地址
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
            
            // 省
            let province_ = RegisterAddressItemModel(name: pName, code: codeP)
            // 市
            let city_ = RegisterAddressItemModel(name: cName, code: codeC)
            // 区
            let district_ = RegisterAddressItemModel(name: dName, code: codeD)
            // 保存
            if type == .enterpriseName {
                // 保存企业地区
                strongSelf.viewModel.saveEnterpriseArea(province_, city_, district_)
                // 保存企业详细地址
                strongSelf.viewModel.enterpriseAddress = addressName
            }
            else if type == .enterpriseNameRetail {
                // 保存零售企业地区
                strongSelf.viewModel.saveEnterpriseAreaRetail(province_, city_, district_)
                // 保存企业详细地址
                strongSelf.viewModel.enterpriseAddressRetail = addressName
            }
            // 刷新
            strongSelf.tableview.reloadData()
        }
    }
    
    // 显示Erp返回的(企业)收货地址信息
    fileprivate func showReceiveInfoFromErp() {
        // 用户已经有地址
        if let addr = viewModel.receiveAddress, addr.isEmpty == false {
            return
        }
        
        // 关键值为空
        guard let eModel = viewModel.enterpriseInfoFromErp, let bCer = eModel.businessCertification, let bAddress = bCer.warehouseAddress, bAddress.isEmpty == false else {
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
                        
                        // 全部查到，则保存～！@
                        
                        // 省
                        let province = FKYAddressItemModel.init(code: provinceM.code, name: provinceM.name, level: "1", parentCode: nil)
                        // 市
                        let city = FKYAddressItemModel(code: cityM.code, name: cityM.name, level: "2", parentCode: nil)
                        // 区
                        let district = FKYAddressItemModel(code: districtM.code, name: districtM.name, level: "3", parentCode: nil)
                        // 镇
                        let town = FKYAddressItemModel(code: townM.code, name: townM.name, level: "4", parentCode: nil)
                        
                        // 保存
                        self.viewModel.saveReceiveArea(province, city, district, town)
                        self.viewModel.receiveAddress = addressName
                        // 仓库地址填充
                        self.viewModel.autoSettingSaleAddress()
                        
                        // 刷新
                        self.tableview.reloadData()
                        self.dismissLoading()
                    })
                })
            })
        }
    }
}


// MARK: - UITableViewDelegate
extension RITextController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.sectionList.count > section else {
            return 0
        }
        let cellList = viewModel.sectionList[section]
        return cellList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard viewModel.sectionList.count > indexPath.section else {
            return 0
        }
        let cellList = viewModel.sectionList[indexPath.section]
        guard cellList.count > indexPath.row else {
            return 0
        }
        
        // 多行文字输入/选择cell单独考虑..<动态高度>
        let type = cellList[indexPath.row]
        if type == .enterpriseAddress ||
            type == .enterpriseAddressRetail ||
            type == .receiveAddress ||
            type == .saleAddress ||
            type == .drugScope  ||
            type == .enterpriseName ||
            type == .enterpriseNameRetail ||
            type == .enterpriseArea ||
            type == .enterpriseAreaRetail ||
            type == .receiveArea ||
            type == .businessAccount {
            if viewModel.getCellShowStatus(type) {
                // 显示...<使用动态自适应高度>...<指定部分cell高度自适应>
                return tableView.rowHeight
            }
            else {
                // 隐藏
                return CGFloat.leastNormalMagnitude
            }
        }
        
        // 非多行文字输入cell...<固定高度>
        return viewModel.getCellHeight(type)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.sectionList.count > indexPath.section else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        let cellList = viewModel.sectionList[indexPath.section]
        guard cellList.count > indexPath.row else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        // cell类型
        let type = cellList[indexPath.row]
        if type == .enterpriseLegalEntity ||
            type == .storeNumberRetail ||
            type == .receiveName ||
            type == .receivePhone ||
            type == .buyerName ||
            type == .buyerPhone ||
            type == .inviteCode {
            // 直接输入文字类cell...<固定高度>
            // （批发or非批发）企业法人、零售企业门店数、收货人姓名、收货人手机号、采购员姓名、采购员手机号、邀请码
            let cell = tableView.dequeueReusableCell(withIdentifier: "RITextInputCell", for: indexPath) as! RITextInputCell
            // 配置cell
            let showFlag = viewModel.getCellShowStatus(type)
            let value = viewModel.getCellValue(type)
            cell.configCell(showFlag, type, value)
            // 输入文字改变中
            cell.changeText = { [weak self] (txt) in
                guard let strongSelf = self else {
                    return
                }
                // 保存内容
                strongSelf.viewModel.setCellValue(type, txt, nil)
            }
            // 输入完成
            cell.endEditing = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                guard type == .receiveName ||
                    type == .receivePhone ||
                    type == .buyerName ||
                    type == .buyerPhone else {
                        return
                }
                // 用户手动切换了开关状态
                if strongSelf.viewModel.userSelectFlag {
                    return
                }
                // 保存内容
                let txt = cell.getContent()
                strongSelf.viewModel.setCellValue(type, txt, nil)
                // 更新收货信息相关按钮状态，并刷新
                let needRefresh = strongSelf.viewModel.updateReceiveInfoStatus(type, nil)
                if needRefresh {
                    // 更新状态
//                    if let cell = strongSelf.receiveBtnCell {
//                        cell.updateSwitchValue(strongSelf.viewModel.samePersonFlag)
//                    }
                    strongSelf.tableview.reloadData()
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        else if type == .enterpriseAddress ||
            type == .enterpriseAddressRetail ||
            type == .receiveAddress ||
            type == .saleAddress ||
            type == .businessAccount {
            // 直接输入长文字类cell...<动态高度>
            // （批发or非批发）企业详细地址、零售企业详细地址、收货地址、打印地址、业务员子账号
            let cell = tableView.dequeueReusableCell(withIdentifier: "RITextLongInputCell", for: indexPath) as! RITextLongInputCell
            // 配置cell
            let showFlag = viewModel.getCellShowStatus(type)
            let value = viewModel.getCellValue(type)
            cell.configCell(showFlag, type, value)
            if type == .businessAccount{
                cell.setTextViewEditAble(viewModel.canModifyBusinessAccount) //保存到草稿表子账号 不可再修改
            }else{
                cell.setTextViewEditAble(true)
            }
            
            // 输入文字改变中
            cell.changeText = { [weak self] (txt, height, update) in
                guard let strongSelf = self else {
                    return
                }
                // 保存内容
                strongSelf.viewModel.setCellValue(type, txt, nil)
                // 更新高度
                if update {
                    print("高度有更新，需要刷新当前cell")
                    if #available(iOS 11, *) {
                        UIView.performWithoutAnimation {
                            strongSelf.tableview.performBatchUpdates({
                                //
                            }, completion: { (finishi) in
                                //
                            })
                        }
                    }
                    else {
                        UIView.setAnimationsEnabled(false)
                        strongSelf.tableview.beginUpdates()
                        //strongSelf.tableview.layoutIfNeeded()
                        //IQKeyboardManager.shared().reloadLayoutIfNeeded()
                        //strongSelf.tableview.reloadRows(at: [indexPath], with: .none)
                        //strongSelf.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        strongSelf.tableview.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
            // 输入完成
            cell.endEditing = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 更新收货信息相关按钮状态，并刷新
                let needRefresh = strongSelf.viewModel.updateReceiveInfoStatus(type, nil)
                if needRefresh {
                    // 更新状态
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        // 延迟刷新
                        strongSelf.tableview.reloadData()
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        else if type == .enterpriseType ||
            type == .enterpriseBankInfo {
            // 点击cell...<固定高度>
            // （批发or非批发）企业类型、银行信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "RISelectInfoCell", for: indexPath) as! RISelectInfoCell
            // 配置cell
            let showFlag = viewModel.getCellShowStatus(type)
            let value = viewModel.getCellValue(type)
            cell.configCell(showFlag, type, value)
            // 选择操作
            cell.callback = { [weak self] (cellType) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectAction(cellType)
            }
            cell.selectionStyle = .none
            return cell
        }
        else if type == .drugScope ||
            type == .enterpriseName ||
            type == .enterpriseNameRetail ||
            type == .enterpriseArea ||
            type == .enterpriseAreaRetail ||
            type == .receiveArea {
            // 点击cell...<动态高度>
            // 经营范围、（批发or非批发）企业名称、零售企业名称、（批发or非批发）企业所在地区、零售企业所在地区、收货地区
            let cell = tableView.dequeueReusableCell(withIdentifier: "RISelectLongInfoCell", for: indexPath) as! RISelectLongInfoCell
            // 配置cell
            let showFlag = viewModel.getCellShowStatus(type)
            let value = viewModel.getCellValue(type)
            cell.configCell(showFlag, type, value)
            // 选择操作
            cell.callback = { [weak self] (cellType) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectAction(cellType)
            }
            cell.selectionStyle = .none
            return cell
        }
        else if type == .allInOneSelect ||
            type == .samePersonSelect {
            // 开关cell
            // 是否批零一体、是否与收货人信息一致
            let cell = tableView.dequeueReusableCell(withIdentifier: "RISwitchCell", for: indexPath) as! RISwitchCell
            // 配置cell
            let showFlag = viewModel.getCellShowStatus(type)
            let switchValue = viewModel.getCellSwitchStatus(type)
            cell.configCell(showFlag, type, switchValue)
            // 保存当前类型的cell
            if type == .samePersonSelect {
                receiveBtnCell = cell
            }
            // 开关操作
            cell.callback = { [weak self] (cellType, openFlag) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.switchAction(cellType, openFlag)
            }
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "error")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let listTitle = viewModel.sectionTitleList
        guard listTitle.count > section else {
            return CGFloat.leastNormalMagnitude
        }
        
        return WH(46)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let listTitle = viewModel.sectionTitleList
        guard listTitle.count > section else {
            return nil
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(46)))
        view.backgroundColor = .clear
        
        // section标题
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.text = listTitle[section]
        view.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(15))
            make.bottom.equalTo(view).offset(-WH(9))
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - Block
extension RITextController {
    //
    fileprivate func setupClosure() {
        setupAreaPickerViewClosure()
        setupAddressPickerViewClosure()
    }
    
    // 收货地区block
    fileprivate func setupAreaPickerViewClosure() {
        // 选择完成
        areaPickerView.selectOverClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let district = strongSelf.areaPickerView.district else {
                return
            }
            guard let city = strongSelf.areaPickerView.city else {
                return
            }
            guard let province = strongSelf.areaPickerView.province else {
                return
            }
            // 保存
            strongSelf.viewModel.saveReceiveArea(province, city, district, strongSelf.areaPickerView.town)
            // 刷新
            strongSelf.tableview.reloadData()
        }
        // loading
        areaPickerView.showLoadingClosure = { [weak self] (showFlag) in
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
        areaPickerView.showToastClosure = { [weak self] (tip: String?) in
            guard let strongSelf = self else {
                return
            }
            guard let msg = tip, !msg.isEmpty else {
                return
            }
            strongSelf.toast(msg)
        }
    }
    
    // 企业地区block
    fileprivate func setupAddressPickerViewClosure() {
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
            // 保存
            if strongSelf.addressPickerView.selectType == .enterpriseArea {
                // (非批发or批发)企业所在地区...<地区>
                strongSelf.viewModel.saveEnterpriseArea(province, city, district)
                // 保存详细地址
                if let address = strongSelf.addressPickerView.address, address.isEmpty == false {
                    strongSelf.viewModel.enterpriseAddress = address
                }
            }
            else if strongSelf.addressPickerView.selectType == .enterpriseAreaRetail {
                // 零售企业所有地区...<地区>
                strongSelf.viewModel.saveEnterpriseAreaRetail(province, city, district)
                // 保存详细地址
                if let address = strongSelf.addressPickerView.address, address.isEmpty == false {
                    strongSelf.viewModel.enterpriseAddressRetail = address
                }
            }
            // 刷新
            strongSelf.tableview.reloadData()
        }
        // 定位失败
        addressPickerView.locationErrorClosure = { [weak self] (erroCode, reason) in
            guard let strongSelf = self else {
                return
            }
            if erroCode == 10 {
                //
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
}
