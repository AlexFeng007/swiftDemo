//
//  FKYNewProductRegisterVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 新品登记页面

import UIKit

class FKYNewProductRegisterVC: UIViewController {

    /// viewModel
    var viewModel = FKYNewProductRegisterViewModel()
    /// 条码
    var barcode = ""
    /// 导航栏
    lazy var navBar = UIView()
    /// 是否需要弹出 标品列表
    var isNeedPop = true
    
    /// 大图
    lazy var bigImageView = FKYBigImageView()
    
    /// 登记历史按钮
    lazy var historyButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("登记历史", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(14))
        bt.setTitleColor(RGBColor(0x666666), for: .normal)
        bt.addTarget(self, action: #selector(FKYNewProductRegisterVC.hisotoryButtonClicked), for: .touchUpInside)
        return bt
    }()
    /// 提交按钮容器视图
    lazy var containerSubmitView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    /// 提交按钮
    lazy var submitButton:UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
//        bt.layer.borderWidth = WH(1)
//        bt.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        bt.setTitle("提交", for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.addTarget(self, action: #selector(FKYNewProductRegisterVC.submitButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// mainTableView
    lazy var mainTableView:UITableView = {
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.bounces = false
        tableV.estimatedRowHeight = WH(300) //最多
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYNewProductRegisterInputCell.self, forCellReuseIdentifier: NSStringFromClass(FKYNewProductRegisterInputCell.self))
        tableV.register(FKYNewProductRegisterProductInfoCell.self, forCellReuseIdentifier: NSStringFromClass(FKYNewProductRegisterProductInfoCell.self ))
        tableV.register(FKYNewProductRegisterUploadImageCell.self, forCellReuseIdentifier: NSStringFromClass(FKYNewProductRegisterUploadImageCell.self ))
        tableV.register(FKYNewProductRegisterSectionHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FKYNewProductRegisterSectionHeader.self))
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    
    // 选择照片弹出视图view...<类似UIActionSheet>
    fileprivate lazy var imageSourceView: CredentialsUploadImageSourceView = {
        let view = CredentialsUploadImageSourceView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        // 选择类型
        view.selectSourceClosure = { [weak self] sourceType in
            guard let strongSelf = self else {
                return
            }
            if sourceType == "Album" {
                // 相册
                strongSelf.imageUploadController.pushImagePickerController()
            }
            else if (sourceType == "Camera") {
                // 相机
                strongSelf.imageUploadController.takePhoto()
            }
        }
        return view
    }()
    // 上传照片vc
    fileprivate lazy var imageUploadController: CredentialsImagePickController = {
        let view = CredentialsImagePickController()
        // 最大上传个数...<非其它资质类型默认仅可上传1张图片>
        view.maxImagesCount = 1
        // 图片上传完成
        view.uploadImageCompletionClosure = { [weak self] (imageUrlArr, filenames, errorInfo, toUploadImageCount) in
            guard let strongSelf = self else {
                return
            }
            
            // toast
            if errorInfo.count > 0 {
                // 有失败
                if (toUploadImageCount > 1) {
                    // 上传张数>1...<可能部分成功，可能全部失败>
                    var errorMsg = "上传成功了\(imageUrlArr.count)/\(toUploadImageCount):\n"
                    let failStrings = errorInfo.map({ (errorTuple) -> String in
                        return "第\(errorTuple.uploadIndex)张上传失败：\(errorTuple.errorMsg)"
                    })
                    errorMsg.append((failStrings as NSArray).componentsJoined(by: "\n"))
                    strongSelf.toast(errorMsg, delay: 1.5, numberOfLines: 0)
                }
                else {
                    // 最多上传1张...<完全失败>
                    if let errorTuple = errorInfo.first, errorTuple.errorMsg.isEmpty == false {
                        if errorTuple.errorMsg == "上传失败" {
                            strongSelf.toast("上传失败")
                        }
                        else {
                            strongSelf.toast("上传失败\n\(errorTuple.errorMsg)", delay: 1.0, numberOfLines: 0)
                        }
                    }
                    else{
                        strongSelf.toast("上传失败")
                    }
                }
            }else {
                if imageUrlArr.count > 0 {
                    let imageModel = UploadImageModel()
                    imageModel.imageUrl = imageUrlArr[0]
                    imageModel.isHaveImage = true
                    strongSelf.viewModel.addUploadImageView(imageModel: imageModel)
                    strongSelf.mainTableView.reloadData()
                }
            }
        }
        // 上传状态更新
        view.uploadStatusClosure = { [weak self] status in
            guard let strongSelf = self else {
                return
            }
            if status == .begin {
                strongSelf.showLoading()
            }
            if status == .complete {
                strongSelf.dismissLoading()
            }
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.sectionList[0].cellList[0].inputText = self.barcode
        self.mainTableView.reloadData()
        self.addNotify()
        self.checkLogin()
//        self.barcode = "6920312611029"
//        self.viewModel.updataBarcode(barcode: "6920312611029")
        self.mainTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isNeedPop && self.barcode.count > 0{
            self.requestProductInfo()
        }
        self.isNeedPop = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("FKYNewProductRegisterVC deinit~!@")
    }
}

//MARK: - 事件响应
extension FKYNewProductRegisterVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_NewProductRegisterScanButtonClicked{// 扫描按钮点击事件
            self.goToScan()
        }else if eventName == FKY_NewProductRegisterRechooseButtonClicked{// 重新选择标品
            self.rechooseProduct()
        }else if eventName == FKY_NewProductRegisterDeleteButtonClicked {// 删除图片
            let dic = userInfo[FKYUserParameterKey] as! [String:AnyObject]
            let cellModel = dic["cellModel"] as! FKYNewProductRegisterCellModel
            let imageModel = dic["imageModel"] as! UploadImageModel
            self.deletaPic(imageModel: imageModel, cellModel: cellModel)
        }else if eventName == FKY_NewProductRegisterSelectImageButtonClicked{// 选择图片
            let dic = userInfo[FKYUserParameterKey] as! [String:AnyObject]
            let imageModel = dic["imageModel"] as! UploadImageModel
            if imageModel.isHaveImage {
                self.lookImage(imageModel:imageModel)
            }else{
                self.uploadImage()
            }
        }else if eventName == FKY_DismissBigImageView {// 退出查看大图
            self.view.sendSubviewToBack(self.bigImageView)
            self.mainTableView.reloadData()
        }else if eventName == FKY_NewProductRegisterInpuBI {// 手机号，采购数量，采购价埋点事件
            let cellModel = userInfo[FKYUserParameterKey] as! FKYNewProductRegisterCellModel
            self.otherBI(cellModel:cellModel)
        }
    }
    
    func otherBI(cellModel:FKYNewProductRegisterCellModel){
        if cellModel.inpuInfoType == "1"{// 手机号
            self.NewBI(pageCode: "newProductRegister", itemId: "I9503", itemName: "填写手机号", itemPosition: "3")
        }else if cellModel.inpuInfoType == "2"{// 采购数量
            self.NewBI(pageCode: "newProductRegister", itemId: "I9503", itemName: "填写采购量", itemPosition: "4")
        }else if cellModel.inpuInfoType == "3"{// 采购价
            self.NewBI(pageCode: "newProductRegister", itemId: "I9503", itemName: "填写采购价", itemPosition: "5")
        }
    }
    
    /// 查看图片
    func lookImage(imageModel:UploadImageModel){
        self.bigImageView.showImage(imageModel: imageModel)
        self.view.bringSubviewToFront(self.bigImageView)
    }
    
    /// 上传图片
    func uploadImage(){
        // 弹出上传图片选择视图
        self.NewBI(pageCode: "newProductRegister", itemId: "I9503", itemName: "上传图片", itemPosition: "6")
        view.bringSubviewToFront(imageSourceView)
        imageSourceView.showClosure!()
    }
    
    /// 扫码
    func goToScan(){
        self.isNeedPop = false
        self.NewBI(pageCode: "newProductRegister", itemId: "I9501", itemName: "扫码", itemPosition: "1")
        FKYNavigator.shared().openScheme(FKY_ScanVC.self, setProperty: { (svc) in
            let v = svc as! FKYScanVC
            v.isNeedPopBackWithScanResualt = true
            v.barcodeCallBack = { barcode in
                if self.barcode == barcode{
                    
                }else{
                    self.viewModel.removeProductCell()
                    self.viewModel.remvoeUploadImageInfo()
                }
                self.barcode = barcode
                self.updataBarcode(barCode: barcode)
                self.isNeedPop = true
                self.mainTableView.reloadData()
            }
        }, isModal: false, animated: true)
    }
    
    ///重新选择标品
    func rechooseProduct(){
        self.NewBI(pageCode: "newProductRegister", itemId: "I9503", itemName: "重新选择", itemPosition: "2")
        let vc = FKYStandardProductListVC()
        vc.barcode = self.barcode
        vc.modalPresentationStyle = .overCurrentContext;
        vc.selectProductCallBack = {[weak self] productModel in
            guard let strongSelf = self else{
                return
            }
            strongSelf.viewModel.userSelectedProduct(product: productModel)
            strongSelf.mainTableView.reloadData()
            strongSelf.NewBI(pageCode: "newProductRegister", itemId: "I9502", itemName: "选择标品", itemPosition: "1")
        }
        self.present(vc, animated: false) {
            
        }
    }
    
    /// 删除图片
    func deletaPic(imageModel:UploadImageModel,cellModel:FKYNewProductRegisterCellModel){
        self.viewModel.removeUploadImage(imageModel: imageModel, cellModel: cellModel)
        self.mainTableView.reloadData()
    }
    
    /// 历史记录按钮点击
    @objc func hisotoryButtonClicked(){
        self.NewBI(pageCode: "newProductRegister", itemId: "I9500", itemName: "登记历史", itemPosition: "2")
        FKYNavigator.shared()?.openScheme(FKY_New_Product_Set_List.self)
    }
    
    ///提交按钮点击
    @objc func submitButtonClicked(){
        self.view.endEditing(true)
        let isInputFull = self.viewModel.isInputFull()
        if !isInputFull.0 {
            self.toast(isInputFull.1)
            return
        }
        
        self.NewBI(pageCode: "newProductRegister", itemId: "I9504", itemName: "提交", itemPosition: "1")
        self.viewModel.submitProductInfo { (isSuccess, Msg) in
            guard isSuccess else{
                self.toast(Msg)
                return
            }
            self.toast("提交成功")
//            FKYNavigator.shared()?.pop()
            FKYNavigator.shared()?.openScheme(FKY_New_Product_Set_List.self)
        }
    }
    
    /// 更新条码
    func updataBarcode(barCode:String){
        self.barcode = barCode
        self.viewModel.updataBarcode(barcode: barCode)
        self.mainTableView.reloadData()
    }
}

//MARK: - UI
extension FKYNewProductRegisterVC {
    
    func setupUI(){
        self.setNavigationView()
        self.view.addSubview(self.bigImageView)
        self.view.addSubview(self.mainTableView)
        self.view.addSubview(self.containerSubmitView)
        self.containerSubmitView.addSubview(self.submitButton)
        self.navBar.addSubview(self.historyButton)
        self.view.sendSubviewToBack(self.bigImageView)
        self.bigImageView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.historyButton.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-5))
            make.right.equalToSuperview().offset(WH(-16))
        }
        
        self.mainTableView.snp_remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navBar.snp_bottom)
            make.bottom.equalTo(self.containerSubmitView.snp_top)
        }
        // iPhoneX适配
        var height = WH(62)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                height += iPhoneX_SafeArea_BottomInset
            }
        }
        self.containerSubmitView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(height)
        }
        
        self.submitButton.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(10))
            make.left.equalToSuperview().offset(WH(19))
            make.width.equalTo(WH(336))
            make.height.equalTo(WH(42))
        }
        // 上传图片弹出框
        self.view.addSubview(self.imageSourceView)
        self.view.sendSubviewToBack(self.imageSourceView)
        // 上传图片vc
        addChild(imageUploadController)
        view.addSubview(imageUploadController.view)
        view.sendSubviewToBack(imageUploadController.view)
        
    }
    
    func setNavigationView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            guard let weakSelf = self else{
                return
            }
            FKYNavigator.shared().pop()
            weakSelf.NewBI(pageCode: "newProductRegister", itemId: "I9500", itemName: "返回", itemPosition: "1")
        }
        self.navBar.backgroundColor = bg1
        self.fky_setupTitleLabel("新品登记")
        self.fky_hiddedBottomLine(false)
    }
}

//MARK: - TableViewDelegate & DataSource
extension FKYNewProductRegisterVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionList[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.viewModel.sectionList[indexPath.section].cellList[indexPath.row]
        if cellModel.cellType == .inputCell{// 信息输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYNewProductRegisterInputCell.self)) as! FKYNewProductRegisterInputCell
            cell.showCellData(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .productCell{// 商品信息cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYNewProductRegisterProductInfoCell.self)) as! FKYNewProductRegisterProductInfoCell
            cell.showCellData(cellModel: cellModel)
            return cell
        }else if cellModel.cellType == .uploadImageCel {// 上传图片cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYNewProductRegisterUploadImageCell.self)) as! FKYNewProductRegisterUploadImageCell
            cell.showCellData(cellModel: cellModel)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = self.viewModel.sectionList[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FKYNewProductRegisterSectionHeader.self)) as! FKYNewProductRegisterSectionHeader
        header.showData(title: sectionModel.sectionTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(28)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - 网络请求
extension FKYNewProductRegisterVC{
    func requestProductInfo(){
        let param = ["barcode":self.barcode]
        self.viewModel.requestStandardProductList(param: param as [String : AnyObject]) { (isSuccess, Msg) in
            guard isSuccess else{
                self.toast(Msg)
                return
            }
            
            guard self.viewModel.products.count>0 else{
                return
            }
            
            let vc = FKYStandardProductListVC()
            vc.barcode = self.barcode
            vc.modalPresentationStyle = .overCurrentContext;
            vc.selectProductCallBack = {[weak self] productModel in
                guard let strongSelf = self else{
                    return
                }
                strongSelf.NewBI(pageCode: "newProductRegister", itemId: "I9502", itemName: "选择标品", itemPosition: "1")
                strongSelf.viewModel.userSelectedProduct(product: productModel)
                strongSelf.mainTableView.reloadData()
            }
            self.present(vc, animated: false) {
                
            }
            self.isNeedPop = false
        }
    }
}

//MARK: - 登录相关
extension FKYNewProductRegisterVC{
    func checkLogin(){
        if FKYLoginService.loginStatus() != .unlogin{// 已登录
            
        }else{// 未登录
            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: nil, isModal: true)
        }
    }
    
    /// 监听通知
    func addNotify(){
        NotificationCenter.default.addObserver(self, selector: #selector(FKYNewProductRegisterVC.updataUserInfo), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    
    /// 更新登录信息
    @objc func updataUserInfo(){
        self.viewModel.updataUserPhone()
        self.mainTableView.reloadData()
    }
}

//MARK: - BI
extension FKYNewProductRegisterVC{
    func NewBI(pageCode:String,itemId:String,itemName:String,itemPosition:String)  {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: ["pageCode":pageCode] as [String:AnyObject], viewController: self)
    }
}
