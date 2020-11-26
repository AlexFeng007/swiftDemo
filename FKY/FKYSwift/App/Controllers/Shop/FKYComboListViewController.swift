//
//  FKYComboListViewController.swift
//  FKY
//
//  Created by Andy on 2018/10/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  超值套餐

import UIKit

class FKYComboListViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    /// 套餐类型 1 搭配2固定 默认2 搭配在FKYMatchingPackageVC里面，不要本vc里面用1
    @objc var packageType = 2
    
    /// 商品的spuCode 上一个界面传过来
    @objc var spuCode:String = ""
    
    /// 分页的index 初始值取1_0 后续取后台给的
    @objc var position:String = "1_0"
    
    /// 商家id(企业id)，上一个页面传过来
    @objc var sellerCode : NSInteger = 0
    @objc var dinnerType : NSInteger = 0
    @objc var enterpriseName : String?
    @objc var comboList : [ComboListModel] = {
        let mArr = NSMutableArray()
        return mArr as! [ComboListModel]
    }()
    
    fileprivate lazy var shopProvider: ShopItemProvider = {
        let shopProvider = ShopItemProvider()
        return shopProvider
    }()
    var badgeView_nav: JSBadgeView? //显示添加数量
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        
        cv.register(FKYComboDetailCellCollectionViewCell.self, forCellWithReuseIdentifier: "FKYComboDetailCellCollectionViewCell")
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(FKYComboListViewController.loadMore))
        footer?.setTitle("--没有更多啦！--", for: .noMoreData)
        cv.mj_footer = footer
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.top)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        return cv
    }()
    
    //企业名称
    fileprivate lazy var companyAptitudeView : UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        let label : UILabel = UILabel.init()
        label.text = self.enterpriseName
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH - WH(95))
            make.height.equalTo(WH(20))
            make.left.equalTo(view.snp.left).offset(WH(22))
        })
        
        let line = UIView()
        line.backgroundColor = RGBColor(0x999999)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0.5))
            make.right.left.bottom.equalTo(view)
        }
        
        return view
    }()
    
    //联系供应商
    fileprivate lazy var contactSupplyView : UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = RGBColor(0xF4F4F4)
        
        let contactBtn = UIButton.init(type: UIButton.ButtonType.custom)
        contactBtn.setImage(UIImage.init(named: "ContectEnterprise_Icon"), for: .normal)
        contactBtn.setTitle("联系供应商", for: .normal)
        contactBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        contactBtn.titleLabel?.font = t21.font
        contactBtn.backgroundColor = RGBColor(0xFFFFFF)
        contactBtn.layer.cornerRadius = WH(4)
        contactBtn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        contactBtn.layer.borderWidth = WH(0.5)
        bgView.addSubview(contactBtn)
        contactBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(WH(7))
            make.height.equalTo(WH(40))
            make.right.equalTo(bgView.snp.right).offset(-WH(20))
            make.left.equalTo(bgView.snp.left).offset(WH(20))
        }
        contactBtn.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                //点击客服
                FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                    let v = vc as! GLWebVC
                    v.urlPath = String.init(format:"%@?platform=3&supplyId=%@&openFrom=%d",API_IM_H5_URL,"\(strongSelf.sellerCode)",3)
                    v.navigationController?.isNavigationBarHidden = true
                }, isModal: false)
            }
        })
        
        let topLine = UIView()
        topLine.backgroundColor = RGBColor(0xCCCCCC)
        bgView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0.5))
            make.right.left.top.equalTo(bgView)
        }
        
        return bgView
    }()
    
    
    fileprivate lazy var comboService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    fileprivate lazy var navBar: UIView = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar!.backgroundColor = RGBColor(0xFF2D5C)
        self.fky_setupTitleLabel("超值套餐")
        self.fky_hiddedBottomLine(true)
        self.NavigationTitleLabel!.fontTuple = (color:RGBColor(0xffffff),font:UIFont.boldSystemFont(ofSize: WH(17)))
        self.fky_setupLeftImage("togeterBack") {
            FKYNavigator.shared().pop()
        }
        
        let carBtn = UIButton.init(type: UIButton.ButtonType.custom)
        carBtn.setImage(UIImage.init(named: "car_combo_pic"), for: UIControl.State.normal)
        carBtn.addTarget(self, action: #selector(onCarBtnClick(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(carBtn)
        carBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-WH(11))
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(36))
            make.centerY.equalTo(self.NavigationTitleLabel!)
        }
        
        let bv = JSBadgeView(parentView: carBtn, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-6), y: WH(8))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeTextColor = RGBColor(0xFF2D5C)
        bv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
        self.badgeView_nav = bv
        
        return self.NavigationBar!
    }()
    
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        getDinnerAndProductBySell()
        if  self.enterpriseName == nil || self.enterpriseName!.isEmpty == true{
            self.getBaseEnterpriseInfo()
        }
        setupView()
        getShowCusterInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentViewController.shared.item = self
        UIApplication.shared.statusBarStyle = .lightContent
        
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
            self.changeBadgeNumber(true)
            self.refreshCollectionView()
        }, failure: { (reason) in
            self.toast(reason)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CurrentViewController.shared.item  = nil
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        view.endEditing(true)
    }
    
    
    //MARK: - setupView
    func setupView() {
        self.view.backgroundColor = RGBColor(0xF4F4F4)
        self.view.addSubview(self.contactSupplyView)
        self.contactSupplyView.snp.makeConstraints ({ (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-bootSaveHeight())
            make.left.right.equalTo(self.view)
            make.height.equalTo(0)
        })
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        self.updateEnterpriceNameView()
        
    }
    func updateEnterpriceNameView(){
        if let str = self.enterpriseName ,str.count > 0{
            self.view.addSubview(self.companyAptitudeView)
            self.companyAptitudeView.snp.makeConstraints ({ (make) in
                make.top.equalTo(self.navBar.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(WH(40))
            })
            self.collectionView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.companyAptitudeView.snp.bottom)
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.contactSupplyView.snp.top)
            })

        }else {
            self.collectionView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.navBar.snp.bottom)
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.contactSupplyView.snp.top)
            })
        }
    }
    // MARK: - CollectionViewDelegate&DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comboList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYComboDetailCellCollectionViewCell", for: indexPath) as! FKYComboDetailCellCollectionViewCell
        cell.layer.shadowColor = RGBColor(0xEBEBEB).cgColor
        cell.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        cell.layer.shadowOpacity = 1
        cell.configCell(comboList: (self.comboList as NSArray) as! [ComboListModel], index: indexPath.row)
        
        cell.toastAddProductNum = { [weak self] msg in
            if let strogSelf = self {
                strogSelf.toast(msg)
            }
        }
        
        cell.addShopButtonCallBlock = {
            [weak self] (count : Int) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            var isAddCard = true
            // 在FKYCartModel中查找当前套餐model
            for cartModel in FKYCartModel.shareInstance().productArr {
                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel , cartOfInfoModel.promotionId != nil,cartOfInfoModel.promotionId.intValue == Int(strongSelf.comboList[indexPath.row].promotionId!)! {
                    isAddCard = false
                }
            }
            
            strongSelf.showLoading()
            
            if strongSelf.comboList[indexPath.row].carOfCount > 0 && !isAddCard{
                // 更新购物车
                if ((strongSelf.comboList[indexPath.row].productList != nil) && (strongSelf.comboList[indexPath.row].productList!.count > 0)) {
                    let shoppingCartDtoList = NSMutableArray()
                    
                    // 在FKYCartModel中找出当前套餐model
                    for cartModel in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel , cartOfInfoModel.promotionId != nil,cartOfInfoModel.promotionId.intValue == Int(strongSelf.comboList[indexPath.row].promotionId!)! {
                            
                            for index in (0..<cartOfInfoModel.comboItems.count){
                                let dic = NSMutableDictionary()
                                let comboItemsStr = cartOfInfoModel.comboItems[index] as! String
                                
                                let range: Range = comboItemsStr.range(of: "-")!
                                let locationLow: Int = comboItemsStr.distance(from: comboItemsStr.startIndex, to: range.lowerBound)
                                let shoppingCartId = comboItemsStr.prefix(locationLow)
                                
                                let locationUp: Int = comboItemsStr.distance(from: comboItemsStr.startIndex, to: range.upperBound)
                                let wasBuyCount = comboItemsStr.suffix(comboItemsStr.count - locationUp)
                                
                                dic["shoppingCartId"] = shoppingCartId
                                let minStap = (Int(String(wasBuyCount)) ?? 0) / cartOfInfoModel.buyNum.intValue
                                dic["productNum"] = minStap * count
                                if FKYPush.sharedInstance().pushID != nil ,FKYPush.sharedInstance().pushID.isEmpty == false {
                                    dic["pushId"] = FKYPush.sharedInstance().pushID ?? ""
                                }
                                shoppingCartDtoList.add(dic)
                            }
                            
                        }
                    }
                    
                    let comboItemDto = NSMutableDictionary()
                    comboItemDto["itemList"] = shoppingCartDtoList
                    
                    let service = FKYCartService()
                    service.editing = false
                    service.updateShopCartForProduct(withParam: comboItemDto as? [AnyHashable : Any], success: { (mutiplyPage,aResponseObject) in
                        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
                            strongSelf.dismissLoading()
                            strongSelf.changeBadgeNumber(true)
                            //更新cell的model的产品数量
                            strongSelf.comboList[indexPath.row].carOfCount = count
                            strongSelf.toast("套餐已成功加入购物车")
                            strongSelf.popThousandRedPackViewWithData(aResponseObject)
                        }, failure: { (reason) in
                            //
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        })
                    }, failure: { (reason) in
                        strongSelf.dismissLoading()
                        strongSelf.toast(reason)
                    })
                }
            } else {
                strongSelf.addNewBI_Record(strongSelf.comboList[indexPath.row],indexPath.row)
                // 加车
                strongSelf.shopProvider.addShopCart(strongSelf.comboList[indexPath.row], HomeString.SHOPITEM_TT_ADD_SOURCE_TYPE,count: count) { (reason, data) in
                    // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                    if let re = reason {
                        if re == "成功" {
                            //更新加车
                            FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
                                //更新cell的model的产品数量
                                strongSelf.comboList[indexPath.row].carOfCount = count
                                
                                strongSelf.dismissLoading()
                                strongSelf.changeBadgeNumber(true)
                                strongSelf.toast("套餐已成功加入购物车")
                                strongSelf.popThousandRedPackViewWithData(data)
                            }, failure: { (reason) in
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                            })
                        }else {
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    }
                }
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - WH(20), height: FKYComboDetailCellCollectionViewCell.getCellHeight(self.comboList[indexPath.row]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(15), right: WH(10))
    }
    
    // MARK: -Private method
    
    
    /// 上拉加载
    @objc func loadMore(){
        self.getDinnerAndProductBySell()
    }
    
    @objc func onCarBtnClick(_ sender : UIButton){
        FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
            let v = vc as! FKY_ShopCart
            v.canBack = true
        }, isModal: false)
    }
        
    // 请求套餐信息
    func getDinnerAndProductBySell() {
        //let params = ["seller_code" : sellerCode,"dinner_type":2]
        guard self.position.isEmpty == false else{
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        let params = ["enterpriseId":self.sellerCode,
                      "spuCode":self.spuCode,
        "pageSize":10,
        "position":self.position,
        "type":self.packageType] as [String : Any]
        
        self.comboService?.getDinnerAndProductBySellCodeBlock(withParam:params , completionBlock: {(responseObject, anError)  in
            if anError == nil {
                if let dataDic = responseObject as? NSDictionary{
                    if let position = dataDic["position"],let position_t = position as? String {
                        self.collectionView.mj_footer.endRefreshing()
                        self.position = position_t
                    }else{
                        self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    if let dataDic_t = dataDic["dinners"], let data = dataDic_t as? NSArray  {
                        for combo in data {
                            if let comboModel = combo as? NSDictionary{
                                let comboListModel = comboModel.mapToObject(ComboListModel.self)
                                self.comboList.append(comboListModel)
                                
                            }
                        }
                        
                        if self.comboList.count == 0{
                            self.toast("暂时没有满足的套餐活动")
                        }
                        self.refreshCollectionView()
                    }else {
                        // 无数据
                        self.toast("暂时没有满足的套餐活动")
                    }
                }
                
            }else{
                
            }
        })
    }
    //请求企业基本信息
    func getBaseEnterpriseInfo(){
        self.shopProvider.getShopBaseInfoWithEnterpriseId(("\(self.sellerCode)")){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.enterpriseName = msg
            } else {
               strongSelf.enterpriseName = ""
            }
             strongSelf.updateEnterpriceNameView()
        }
    }
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            guard self != nil else {
                return
            }
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                var str: String = ""
                let count = FKYCartModel.shareInstance().productCount
                if count <= 0 {
                    str = ""
                }
                else if count > 99 {
                    str = "99+"
                } else {
                    str = String(count)
                }
                strongSelf.badgeView_nav!.badgeText = str
            }
        }
    }
    
    func refreshCollectionView() {
        // 在FKYCartModel中找出当前套餐model,赋值count
        for index in 0..<self.comboList.count{
            if FKYCartModel.shareInstance().productArr.count > 0{
                for cartModel in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                        
                        if cartOfInfoModel.promotionId != nil && cartOfInfoModel.promotionId.intValue == Int(self.comboList[index].promotionId!)!{
                            self.comboList[index].carOfCount = cartOfInfoModel.buyNum.intValue
                            break
                        }else{
                            self.comboList[index].carOfCount = 0
                        }
                    }
                }
            }else{
                self.comboList[index].carOfCount = 0
            }
        }
        self.collectionView.reloadData()
    }
    
    //加车埋点
    func addNewBI_Record(_ comModel: ComboListModel,_ selectionNum : Int) {
        var itemContent = ""
        if let productArr = comModel.productList {
            for productModel  in productArr {
                if itemContent.count > 0 {
                    itemContent = itemContent+",\(productModel.supplyId ?? "")|\(productModel.spuCode ?? "")"
                }else {
                    itemContent = "\(productModel.supplyId ?? "")|\(productModel.spuCode ?? "")"
                }
            }
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "套餐专区", sectionId: "S6401", sectionPosition: "\(selectionNum)", sectionName: comModel.promotionName, itemId: "I9999", itemPosition: "0", itemName: "加车", itemContent: itemContent, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
// MARK:请求网络
extension FKYComboListViewController {
    //判断是否显示联系客服入口
    func getShowCusterInfo (){
        if FKYLoginAPI.loginStatus() == .unlogin {
            //隐藏卖家入口
            self.contactSupplyView.isHidden = true
            self.contactSupplyView.snp.updateConstraints ({ (make) in
                make.height.equalTo(0)
            })
            return
        }
        FKYRequestService.sharedInstance()?.requesImShow(withParam: ["enterpriseId":self.sellerCode], completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            if success==true,let showNum = response as? Int,showNum==0 {
                //展示卖家客服入口
                strongSelf.contactSupplyView.isHidden = false
                strongSelf.contactSupplyView.snp.updateConstraints ({ (make) in
                    make.height.equalTo(WH(54))
                })
            }else{
                //隐藏卖家入口
                strongSelf.contactSupplyView.isHidden = true
                strongSelf.contactSupplyView.snp.updateConstraints ({ (make) in
                    make.height.equalTo(0)
                })
            }
        })
    }
}
extension FKYComboListViewController {
    //千人千面弹框
    func popThousandRedPackViewWithData(_ model:Any?) {
        var desModel:FKYAddCarResultModel?
        if let dataModel = model as? FKYAddCarResultModel {
            desModel = dataModel
        }else if let dataModel = model as? NSDictionary {
            desModel = dataModel.mapToObject(FKYAddCarResultModel.self)
        }
        if let dataModel = desModel , let arr = dataModel.supplyCartList ,arr.count > 0 {
            //请求千人千面优惠券
            let dic = ["couponParamList":arr] as [String : AnyObject]
            FKYRequestService.sharedInstance()?.requestForThousandCouponsInCart(withParam: dic, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                guard success else {
                    // 失败
                    return
                }
                if let desModel = model as? FKYThousandCouponDetailModel {
                    if let desSuccess = desModel.successStr ,desSuccess == "1" {
                        //弹出千人千面框
                        let thousandPacketView: FKYThousandRedPacketView = FKYThousandRedPacketView.init(desModel)
                        thousandPacketView.show()
                    }
                }
            })
        }
    }
    
}
