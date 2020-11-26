//
//  COFollowQualificaViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class COFollowQualificaViewController: UIViewController {
    var followQualitySelAction : ((CheckOrderModel)->(Void))?  //选择类型
    var modelCO: CheckOrderModel?  //检查订单的数组
    var suppluId:String? //判断当前当家
    fileprivate var viewModel: COFollowQualiicatyViewModel = {
        let vm = COFollowQualiicatyViewModel()
        return vm
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.rowHeight = WH(100)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(COFollowQualificaProductInfoCell.self, forCellReuseIdentifier: "COFollowQualificaProductInfoCell")
        tableV.estimatedRowHeight = WH(100)
        tableV.estimatedSectionHeaderHeight = 0
        tableV.estimatedSectionFooterHeight = 0
        //WH(130)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    //顶部视图
    fileprivate lazy var viewHeader:COFollowQualityHeadView = {
        let view = COFollowQualityHeadView()
        view.clickTypeBtnBlock = { [weak self] (index,selState) in
            guard let strongSelf = self else {
                return
            }
            if index == 1{
                //商品
                strongSelf.viewModel.productTypeSelState = selState
                if let  firstMarketingQualifications = strongSelf.viewModel.shopModel?.firstMarketingQualifications,firstMarketingQualifications.isEmpty == false{
                    strongSelf.viewHeader.configqualificationTypeData(firstMarketingQualifications, strongSelf.viewModel.enterpriseTypeSelState, strongSelf.viewModel.productTypeSelState)
                }
                if selState == true{
                    strongSelf.tableView.isHidden = false
                }else{
                    strongSelf.viewModel.clearAllProductSelType(handler: {[weak self] success in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.tableView.reloadData()
                    })
                    strongSelf.tableView.isHidden = true
                }
            }else if index  == 0{
                //企业
                //strongSelf.tableView.isHidden = true
                strongSelf.viewModel.enterpriseTypeSelState = selState
                if selState == true{
                    strongSelf.addEnterpriseDataBIRecord()
                }
                if let  firstMarketingQualifications = strongSelf.viewModel.shopModel?.firstMarketingQualifications,firstMarketingQualifications.isEmpty == false{
                    strongSelf.viewHeader.configqualificationTypeData(firstMarketingQualifications, strongSelf.viewModel.enterpriseTypeSelState, strongSelf.viewModel.productTypeSelState)
                }
            }
        }
        return view
    }()
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xFFFFFF)
        // 按钮
        view.addSubview(self.btnSave)
        self.btnSave.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(WH(10))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(WH(-30))
            make.height.equalTo(WH(42))
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
    // 提交按钮
    fileprivate lazy var btnSave: UIButton = {
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
        btn.setTitle("确定", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.followQualitySelAction{
                FKYNavigator.shared().pop()
                let checkOrderModel = strongSelf.viewModel.saveAllShopFollowQuality()
                block(checkOrderModel)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate var navBar: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.modelCO = self.modelCO
        viewModel.suppluId = self.suppluId
        self.setupNavigationBar()
        self.setupContentView()
        setUpData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("HomePromotionMsgListInfoVC deinit~!@")
    }
    
}

// MARK:ui相关
extension COFollowQualificaViewController {
    //MARK: 导航栏
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupTitleLabel("选择首营资料")
        self.NavigationTitleLabel?.font = UIFont.boldSystemFont(ofSize:WH(18))
        self.navBar?.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
    }
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        view.addSubview(viewHeader)
        viewHeader.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.height.equalTo(WH(94))
        }
        
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(WH(62) + margin)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(viewBottom.snp.top)
            make.top.equalTo(self.viewHeader.snp.bottom)
        }
        self.tableView.isHidden = true
    }
    
}
// MARK:data相关
extension COFollowQualificaViewController {
    func setUpData(){
        viewModel.queryCurrectShopProduct (handler: {[weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            if let  firstMarketingQualifications = strongSelf.viewModel.shopModel?.firstMarketingQualifications,firstMarketingQualifications.isEmpty == false{
                strongSelf.viewHeader.configqualificationTypeData(firstMarketingQualifications, strongSelf.viewModel.enterpriseTypeSelState, strongSelf.viewModel.productTypeSelState)
            }
            if strongSelf.viewModel.productTypeSelState  == true{
                strongSelf.tableView.isHidden = false
            }else{
                strongSelf.tableView.isHidden = true
            }
            strongSelf.tableView.reloadData()
        })
    }
    
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension COFollowQualificaViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: COFollowQualificaProductInfoCell = tableView.dequeueReusableCell(withIdentifier: "COFollowQualificaProductInfoCell", for: indexPath) as! COFollowQualificaProductInfoCell
        cell.selectionStyle = .none
        let productModel = self.viewModel.productList[indexPath.row]
        cell.configCell(productModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(100)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(10)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productModel = self.viewModel.productList[indexPath.row]
        if productModel.customerRequestProductType == 0{
            //未设置任何资质
            self.addSelProductDataBIRecord(productModel,indexPath.row + 1)
            let window = UIApplication.shared.keyWindow!
            guard let rootView = window.rootViewController?.view else { return }
            //弹框已经有了
            for subView in rootView.subviews {
                if subView is COProductFollowQualityTypeListView {
                    let selListView = subView as! COProductFollowQualityTypeListView
                    selListView.showOrHidePopView(true)
                    return
                }
            }
            
            let selListView = COProductFollowQualityTypeListView()
            selListView.showOrHidePopView(true)
            selListView.selectTypeAction  = { [weak self] type in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.updateProductSelType(type, "\(productModel.productId ?? 0)", handler: {[weak self] success in
                    guard let strongSelf = self else {
                        return
                    }
                    if (type == 1 || type == 2){
                        strongSelf.addProductDataBIRecord(productModel,indexPath.row + 1,type)
                    }
                    if let  firstMarketingQualifications = strongSelf.viewModel.shopModel?.firstMarketingQualifications,firstMarketingQualifications.isEmpty == false{
                        strongSelf.viewHeader.configqualificationTypeData(firstMarketingQualifications, strongSelf.viewModel.enterpriseTypeSelState, strongSelf.viewModel.productTypeSelState)
                    }
                    strongSelf.tableView.reloadData()
                })
            }
        }else{
            //设置了资质 清空
            viewModel.updateProductSelType(0, "\(productModel.productId ?? 0)", handler: {[weak self] success in
                guard let strongSelf = self else {
                    return
                }
                if let  firstMarketingQualifications = strongSelf.viewModel.shopModel?.firstMarketingQualifications,firstMarketingQualifications.isEmpty == false{
                    strongSelf.viewHeader.configqualificationTypeData(firstMarketingQualifications, strongSelf.viewModel.enterpriseTypeSelState, strongSelf.viewModel.productTypeSelState)
                }
                strongSelf.tableView.reloadData()
            })
        }
        
    }
    
}
extension  COFollowQualificaViewController {
    //选择企业资质
    func addEnterpriseDataBIRecord(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S3001", sectionPosition: nil, sectionName: "企业首营", itemId: nil, itemPosition: nil, itemName:nil, itemContent: "\(self.viewModel.shopModel?.supplyId ?? 0)", itemTitle: self.viewModel.shopModel?.supplyName ?? "", extendParams: nil, viewController: self)
        
    }
    //选择商品
    func addSelProductDataBIRecord(_ productModel:COProductModel,_ index: Int){
        let itemName = "选择商品"
        let itemId = "I3001"
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S3002", sectionPosition: "\(index)", sectionName: "商品首营", itemId: itemId, itemPosition: nil, itemName:itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
    //选择商品首营资质
    func addProductDataBIRecord(_ productModel:COProductModel,_ index: Int,_ type:Int){
        var itemName = ""
        var itemId = ""
        let itemContent = "\(productModel.supplyId ?? 0)|\(productModel.spuCode ?? "")"
        if type == 2{
            //全套
            itemName = "全套"
            itemId = "I3002"
        }else if type == 1{
            //批件
            itemName = "批件"
            itemId = "I3003"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S3002", sectionPosition: "\(index)", sectionName: "商品首营", itemId: itemId, itemPosition: nil, itemName:itemName, itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
