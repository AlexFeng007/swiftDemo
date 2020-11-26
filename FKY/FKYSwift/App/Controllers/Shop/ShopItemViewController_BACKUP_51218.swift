//
//  ShopItemViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  店铺详情...<商家之商品列表>
//  注：涉及到列表界面的打标需求需修改当前文件

import UIKit
import SnapKit


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

protocol ShopCellHandlerProtocol {
    //点击cell
    func clickShopItem(_ model: ShopProductCellModel)
    //加入购物车
    func addCarInfo(_ model: ShopProductCellModel ,_ prdNum : Int)
    //申请加入渠道
    func applyEnjoyChannal(_ model: ShopProductCellModel)
    //申请采购权限 purchase
    func applyPurchaseAuthority(_ model: ShopProductCellModel)
    //加入购物车提示
    func alertToastInfo(_ msg : String)
    //点击首页广告图
    func clickBannerPic(_ adModel : ShopAdModel)
}

let HEADER_H = WH(75+28) + naviBarHeight() //头视图高
let HEADER_NO_NOTIC_H = WH(75) + naviBarHeight() //头视图高
let SEGMET_H = WH(46) //头视图高
let GET_FAILED_TXT = "加载失败"

@objc
class ShopItemViewController: UIViewController,
FSearchBarProtocol ,UIScrollViewDelegate ,ShopCellHandlerProtocol{
    //MARK: - Property
    dynamic var shopId: String? //店铺id
    //无商品视图
    fileprivate var firstNoDataView : UIView?
    fileprivate var shopAllProductNoDataView : UIView?
    //加载失败显示view
    fileprivate var firstGetFailedView : UIView?
    fileprivate var shopAllProductGetFailedView : UIView?
    
    fileprivate lazy var shareView: ShareView = {
        let view = ShareView()
        return view
    }()
    
    fileprivate lazy var headerView :ShopHeaderView = {
        let view = ShopHeaderView()
        view.searchBar.delegate = self
        weak var weakSelf = self
        view.clickHeaderViewClosure = { index in
            weakSelf?.view.endEditing(true)
            if index == 1{
                //公告
                let alertController = UIAlertController.init(title:"公告", message: weakSelf?.shopModel?.shopDetail?.notice, preferredStyle: .alert)
                let cancelAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                cancelAction.setValue(RGBColor(0xFF2D5C), forKey: "titleTextColor")
                alertController.addAction(cancelAction)
                weakSelf?.present(alertController, animated: true, completion: nil)
            }else if index == 2 {
                //查看资质
                FKYNavigator.shared().openScheme(FKY_ShopMaterial.self, setProperty: { (vc) in
                    let controller = vc as! ShopMaterialViewController
                    controller.supplyid = self.shopId!
                    controller.type = "checkAptitude"
                }, isModal: false)
            }else if index == 3 {
                //分享
                if self.shopModel != nil {
                    weakSelf?.createShareView()
                    weakSelf?.shareView.appearClourse!()
                }
            }else if index == 4 {
                //购物车
                weakSelf?.BI_Record(.MAINSTORE_YC_CLICKCART)
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 2
                })
            }
        }
        return view
    }()
    
    fileprivate lazy var segment : HMSegmentedControl = {
        let titles = ["首页", "全部商品", "企业信息"]
        let sv = HMSegmentedControl()
        sv.isHidden = true
        sv.sectionTitles = titles;
        sv.selectionIndicatorColor = RGBColor(0xFF2D5C)
        sv.titleTextAttributes = [NSFontAttributeName : t12.font]
        sv.selectedTitleTextAttributes = [NSFontAttributeName : t12.font ,NSForegroundColorAttributeName : RGBColor(0xFF2D5C)]
        sv.selectionIndicatorHeight = 2
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.indexChangeBlock = { index in
            self.selectedIndex = index
        }
        return sv
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame:CGRect.zero)
        sv.isHidden = true
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .white
        sv.contentSize = CGSize(width: SCREEN_WIDTH.multiple(3), height:0)
        return sv
    }()
    
    //当前所在界面（0，1，2）
    fileprivate var value: Int = 0
    fileprivate var selectedIndex: Int {
        get {
            return value
        }
        set {
            value = newValue
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(self.value), y: 0)
            }) { (ret) in
                
            }
            if lookAllProduct == false , value == 1 {
                self.getShopAllProductData(isClear: false)
                lookAllProduct = true
            }
            
        }
    }
    
    fileprivate lazy var shopFirstView : ShopFirstPageView = {
        let qv = ShopFirstPageView()
        qv.shopCellHandleProtocol = self
        return qv
    }()
    
    fileprivate lazy var allProductView : ShopAllProductView = {
        let qv = ShopAllProductView()
        return qv
    }()
    
    fileprivate lazy var shopDetailView : ShopDetailMsgView = {
        let qv = ShopDetailMsgView()
        return qv
    }()
    
    fileprivate lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("联系供应商", for: .normal)
        button.setImage(UIImage.init(named: "contactShop"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        button.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        return button;
    }()
    
    fileprivate lazy var viewErrorView: FKYBlankView = {
        let view: FKYBlankView = FKYBlankView.init(initWithFrame: CGRect.zero, andImage: UIImage.init(named: "icon_production_face"), andTitle: nil, andSubTitle: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var lookAllProduct :Bool = false //判断是否第一次查看全部商品
    fileprivate var shopProvider: ShopItemProvider?
    fileprivate var shopModel:ShopItemModel? //首页及店铺信息model
    
    fileprivate lazy var logic: ShopItemLogic? = {
        return ShopItemLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? ShopItemLogic
    }()
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopProvider = ShopItemProvider()
        self.getShopBasisInfoAndFirstPageData()
        // 登录成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        // 提交采购权限成功后，刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: FKYSubmitPurchaseAuthSuccess), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.changeBadgeNumber()
<<<<<<< HEAD
        
        FKYAnalyticsManager.sharedInstance.BI_Record(self, extendParams:["PageValue":self.shopId as AnyObject], eventId: nil)

=======
        // FKYAnalyticsManager.sharedInstance.BI_Record(self, extendParams:nil, eventId: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
>>>>>>> feature/shopRevision
    }
    deinit {
        // 移除KVO
        // 移除通知
        print("ShopItemViewController销毁")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    //MARK: - setupView
    func setupView() {
        self.view.backgroundColor = bg7
        setupHeaderAndContentView()
        setupConsultView()
    }
    
    
    //MARK: - Private
    fileprivate func showWrongView(_ errorMessage: String) {
        self.view.addSubview(viewErrorView)
        viewErrorView.backgroundColor = RGBColor(0xf3f3f3)
        viewErrorView.setTitle(errorMessage)
        viewErrorView.snp.makeConstraints({[weak self] (make) in
            make.left.right.bottom.equalTo(self!.view)
            make.top.equalTo(self!.view.snp.top).offset(naviBarHeight())
        })
    }
    
    //MARK: - Notification
    func reloadData() {
        // 刷新界面数据
        self.getShopBasisInfoAndFirstPageData()
        self.getShopAllProductData(isClear: true)
    }
}

//MARK: 更新数据和界面相关
extension ShopItemViewController {
    fileprivate func updateAllViewWithGetFailde(_ tagNum : Int ,_ hideView : Bool){
        if tagNum == 1{
            if hideView {
                firstGetFailedView?.isHidden = true
            }else {
                self.scrollView.isHidden = false
                if firstGetFailedView == nil {
                    self.shopFirstView.layoutIfNeeded()
                    weak var weakself = self
                    firstGetFailedView = self.showEmptyNoDataCustomView(self.view, "no_shop_pic", GET_FAILED_TXT,false) {
                        weakself?.getShopBasisInfoAndFirstPageData()
                    }
                    firstGetFailedView?.snp.remakeConstraints({ (make) in
                        make.left.right.bottom.equalTo(self.view)
                        make.height.equalTo(SCREEN_HEIGHT-HEADER_NO_NOTIC_H)
                    })
                } else {
                    firstGetFailedView?.isHidden = false
                }
            }
        }else  if tagNum == 2 {
            if hideView {
                 shopAllProductGetFailedView?.isHidden = true
            }else {
                if shopAllProductGetFailedView == nil {
                    self.allProductView.layoutIfNeeded()
                    weak var weakself = self
                    shopAllProductGetFailedView = self.showEmptyNoDataCustomView(self.allProductView, "no_shop_pic", GET_FAILED_TXT,false) {
                        weakself?.getShopAllProductData(isClear: true)
                    }
                } else {
                    shopAllProductGetFailedView?.isHidden = false
                }
            }
        }
    }
    fileprivate func updateAllProducViewInfo(_ model: ShopAllProductModel){
        //全部商品无产品判断
        if model.allProduct?.count == 0{
            if shopAllProductNoDataView == nil {
                self.allProductView.layoutIfNeeded()
                shopAllProductNoDataView = self.showEmptyNoDataCustomView(self.allProductView, "no_shop_pic", "暂无宝贝",true) {
                }
            }else{
                //全部商品
                shopAllProductNoDataView?.isHidden = false;
            }
        } else {
            
            shopAllProductNoDataView?.isHidden = true
        }
    }
    fileprivate func updateViewInfo() {
        var settingHeight : CGFloat!
        var headerH : CGFloat!
        //判断是否有告示
        if ((self.shopModel?.shopDetail?.notice) == nil || self.shopModel?.shopDetail?.notice?.count == 0 ) {
            headerH = HEADER_NO_NOTIC_H
            self.headerView.hideNoticView(true)
        }else{
            headerH = HEADER_H
            self.headerView.hideNoticView(false)
        }
        self.headerView.snp.makeConstraints ({ (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(headerH)
        })
        
        //首页有无产品判断
        if self.shopModel?.shopAdList?.count == 0 && self.shopModel?.shopFloorInfo?.count == 0{
            if firstNoDataView == nil {
                self.shopFirstView.layoutIfNeeded()
                firstNoDataView = self.showEmptyNoDataCustomView(self.shopFirstView, "no_shop_pic", "暂无宝贝",true) {
                }
            }else{
                //首页有产品
                firstNoDataView?.isHidden = false;
            }
        } else {
            
            firstNoDataView?.isHidden = true
        }
        
        // 显示小能判断
        if self.shopModel?.shopDetail?.xiaonengId != nil &&  self.shopModel?.shopDetail?.xiaonengId?.count > 0 {
            settingHeight = 43
            settingButton.isHidden = false;
        }else{
            settingHeight = 0
            settingButton.isHidden = true;
        }
        
        self.segment.isHidden = false
        self.scrollView.isHidden = false
        //列表
        self.scrollView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.view).offset(-WH(settingHeight))
        })
        self.view.layoutIfNeeded()
        //更新视图
        self.shopFirstView.frame = CGRect(x: SCREEN_WIDTH.multiple(0), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
        self.allProductView.frame = CGRect(x: SCREEN_WIDTH.multiple(1), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
        self.shopDetailView.frame = CGRect(x: SCREEN_WIDTH.multiple(2), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
        
    }
    
    func changeBadgeNumber() {
        let deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {
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
                
                self.headerView.badgeView!.badgeText = str
            }
        }
    }
    func showEmptyNoDataCustomView(_ bgView :UIView,_ img : String,_ title:String,_ isHideBtn:Bool,callback:@escaping ()->()) -> UIView{
        let bg = UIView()
        bg.backgroundColor = bg1
        bgView.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
        let imageView = UIImageView.init(image: UIImage.init(named: img))
        bg.addSubview(imageView)

        let titleLabel = UILabel()
        let attributes = [ NSFontAttributeName: FontConfig.font14, NSForegroundColorAttributeName: ColorConfig.color999999]
        titleLabel.attributedText = NSAttributedString.init(string: title, attributes: attributes)
        titleLabel.textAlignment = .center
        bg.addSubview(titleLabel)
        
        var topOffy : CGFloat
        if isHideBtn {
            topOffy = WH(15+20)
        }else{
            topOffy = WH(15+20+20+28)
        }
        imageView.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(bg.snp.centerY).offset(-topOffy)
            make.centerX.equalTo(bg)
        })
        
        titleLabel.snp.makeConstraints ({ (make) in
            make.top.equalTo(imageView.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(20))
            make.centerX.equalTo(bg)
        })
        
        if !isHideBtn {
            let button = UIButton()
            button.setTitle(HomeString.EMPTY_PAGE_BUTTON_TITLE, for: .normal)
            button.setBackgroundImage(UIImage.init(named: HomeString.EMPTY_PAGE_BUTTON_BG), for: .normal)
            button.setTitleColor(ColorConfig.color333333, for: .normal)
            button.setTitleColor(ColorConfig.color999999, for: .highlighted)
            button.titleLabel?.font = FontConfig.font14
            _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                callback()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            bg.addSubview(button)
            button.snp.makeConstraints ({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(WH(20))
                make.centerX.equalTo(bg)
                make.size.equalTo(CGSize(width: WH(86), height: WH(28)))
            })

        }

        return bg
    }
}
//MARK: 头视图布局
extension ShopItemViewController {
    func setupHeaderAndContentView() {
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints ({ (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(HEADER_H)
        })
        self.view.addSubview(self.segment)
        self.segment.snp.makeConstraints ({ (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(SEGMET_H)
        })
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints ({ (make) in
            make.top.equalTo(self.segment.snp.bottom).offset(1)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        self.view.layoutIfNeeded()
        for index in 0..<3 {
            if index == 0 {
                //首页
                self.scrollView.addSubview(self.shopFirstView)
                self.shopFirstView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
            }else if index == 1{
                //全部商品
                self.scrollView.addSubview(self.allProductView)
                allProductView.shopCellHandleProtocol = self
                weak var weakself = self
                allProductView.defaultBtnBlock = {
                    weakself?.getShopAllProductData(isClear: true)
                }
                allProductView.nextListBlock = {
                    guard (weakself?.allProductView.hasNextPage)! else {
                        weakself?.allProductView.stopLoading()
                        return
                    }
                    weakself?.allProductView.page += 1
                    weakself?.getShopAllProductData(isClear: false)
                }
                self.allProductView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
            }else{
                //企业信息
                self.scrollView.addSubview(self.shopDetailView)
                self.shopDetailView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width:SCREEN_WIDTH, height: scrollView.bounds.size.height)
            }
            
        }
        
    }
}
// MARK: 小能(聊天)
extension ShopItemViewController {
    func setupConsultView() {
        self.view.addSubview(settingButton)
        var buttonH = 43
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.top)! > CGFloat.init(0) { // iPhone X
                buttonH = Int(43 + iPhoneX_SafeArea_BottomInset)
            }
        }
        settingButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(WH(CGFloat(buttonH)))
        }
        settingButton.isHidden = true;
        weak var weakself = self
        _ = self.settingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            if weakself?.shopModel?.shopDetail?.xiaonengId?.count > 0 {
                let chat : NTalkerChatViewController = NTalker.standardIntegration().startChat(withSettingId:weakself?.shopModel?.shopDetail?.xiaonengId)
                chat.pushOrPresent = false
                chat.isCancelButtonHiden = true
                let nav : UINavigationController = UINavigationController.init(rootViewController: chat)
                nav.navigationBar.isTranslucent = false
                weakself?.present(nav, animated: true, completion: {
                    
                })
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}
// MARK: -UIScrollViewDelegate
extension ShopItemViewController {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / self.view.bounds.size.width
        segment.setSelectedSegmentIndex(UInt(index), animated: true)
        selectedIndex = Int(index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
}

// MARK: -FSearchBarProtocol
extension ShopItemViewController {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
        if self.shopModel != nil {
            allProductView.keyword = search ?? ""
            self.getShopAllProductData(isClear: true)
            selectedIndex = 1
            self.segment.selectedSegmentIndex = 1
        }
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
        
    }
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        
    }
}

//MARK: - Share
extension ShopItemViewController {
    // 创建分享页面
    func createShareView() -> () {
        self.view.addSubview(self.shareView)
        self.shareView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        shareView.WeChatShareClourse = { () in
            self.WXShare()
        }
        shareView.WeChatFriendShareClourse = { () in
            self.WXFriendShare()
        }
        shareView.QQShareClourse = { () in
            self.QQShare()
        }
        shareView.QQZoneShareClourse = { () in
            self.QQZoneShare()
        }
        shareView.SinaShareClourse = { () in
            self.SinaShare()
        }
    }
    //MARK: - Share
    func shareUrl() -> String {
        if let shopId = self.shopId {
            return String.init(format: "https://m.yaoex.com/shop.html?enterpriseId=%@", shopId)
        }
        return "https://m.yaoex.com/shop.html?enterpriseId="
    }
    
    func shareImage() -> String {
        if let model : ShopAdModel = self.shopModel?.shopAdList?.first {
            return model.ad_pic_url!
        }else{
            return ""
        }
    }
    
    func shareMessage() -> String {
        let info = self.shopModel?.shopDetail?.enterpriseName
        return info!
    }
    
    func WXShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToWX(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_WECHAT)
    }
    func WXFriendShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToWXFriend(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_MOMENTS)
    }
    func QQShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToQQ(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_QQ)
    }
    func QQZoneShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToQQZone(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_QZONE)
    }
    func SinaShare() -> () {
        let url = self.shareUrl()
        FKYShareManage.shareToSina(withOpenUrl: url, andMessage: self.shareMessage(), andImage: self.shareImage())
        self.BI_Record(.MAINSTORE_YC_SHARE_WEIBO)
    }
    
}
//MARK: - Request相关
extension ShopItemViewController {
    //首页接口(返回首页信息及企业信息)
    
    func getShopBasisInfoAndFirstPageData(){
        self.showLoading()
        weak var weakself = self
        logic?.fetchShopDetailData(enterpriseid: self.shopId!, callback: { (model, error) in
            weakself?.dismissLoading()
            if let shopModel = model {
                weakself?.shopModel = shopModel
                weakself?.shopFirstView.setupViewData(shopModel)
                weakself?.headerView.configHeaderViewData(shopModel.shopDetail!)
                weakself?.shopDetailView.configView(model: shopModel.shopDetail!)
                weakself?.updateViewInfo()
                weakself?.updateAllViewWithGetFailde(1, true)
            }else {
                weakself?.toast(error)
                weakself?.updateAllViewWithGetFailde(1, false)
            }
            
        })
    }
    //全部商品信息
    func getShopAllProductData(isClear: Bool) {
        self.showLoading()
        weak var weakself = self
        logic?.fetchShopAllProductData(enterpriseid: shopId!, page: StringValue(allProductView.page), size: StringValue(allProductView.size), keyword: allProductView.keyword, priceSeq: allProductView.priceSeq, salesVolume: allProductView.salesVolume, callback: { (model, error) in
            
            weakself?.dismissLoading()
            if let allProductModel = model {
                weakself?.allProductView.configView(allProductModel, isClear: isClear)
                weakself?.updateAllProducViewInfo(allProductModel)
                weakself?.updateAllViewWithGetFailde(2, true)
            }else {
                weakself?.toast(error)
                weakself?.updateAllViewWithGetFailde(2, false)
            }
        })
    }
}

//MARK: - ShopCellHandlerProtocol
extension ShopItemViewController {
    func clickShopItem(_ model: ShopProductCellModel) {
        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode:nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "goProductdetail", itemPosition: "7", itemName:nil, viewController: self)
        
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = model.productId
            v.vendorId = "\(model.vendorId!)"
        }, isModal: false)
    }
    func addCarInfo(_ product: ShopProductCellModel, _ prdNum: Int) {
        
        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "addCart", itemPosition: "6", itemName:nil, viewController: self)
        self.showLoading()
        // 加车
        weak var weakSelf = self
        self.shopProvider?.addShopCart(product, count: prdNum, completionClosure: { (reason, data) in
            // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
            
            // toast
            if let re = reason {
                weakSelf?.toast(re)
            }
            
            // 加车成功则重置...<限购>
            product.limitCanBuyNumber = 0
            // 限购之剩余可购买数量
            if let res = data {
                // limitCount
                // limitBuyCycleType
                // limitCanBuyNum
                if res.value(forKeyPath: "limitCanBuyNum") != nil && (res.value(forKeyPath: "limitCanBuyNum") as AnyObject).isKind(of: NSNumber.self) {
                    if let limitCanBuyNum = res.value(forKeyPath: "limitCanBuyNum") {
                        let limit = Int(limitCanBuyNum as! NSNumber)
                        print("limit:" + String(limit))
                        product.limitCanBuyNumber = limit
                    }
                }
            }
            //加车成功后刷新加车状态
            if weakSelf?.selectedIndex == 0 {
                self.shopFirstView.refreshCollectionView()
            }else if weakSelf?.selectedIndex == 1 {
                self.allProductView.refreshCollectionView()
            }
            weakSelf?.changeBadgeNumber()
            self.dismissLoading()
        })
        
    }
    func applyEnjoyChannal(_ model: ShopProductCellModel) {
        FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "确定加入渠道", handler: { (_,isRight) in
            if isRight {
                let service = SearchResultProvider()
                service.addToChannl(model.productId!,venderId: "\(model.vendorId!)", callback: {
                    (message) in
                    self.toast(message)
                })
            }
        })
    }
    func applyPurchaseAuthority(_ model: ShopProductCellModel) {
        if model.statusDesc == -9 || model.statusDesc == -11 {
            // 无采购权限 or 权限审核不通过
            // 商家id
            var sellerCode: String = SELF_SHOP_ID
            var isSelfSale: Bool = true
            if let venderId = model.vendorId, "\(venderId)" == SELF_SHOP_ID {
                // 自营
                isSelfSale = true
                sellerCode = SELF_SHOP_ID
            }
            else {
                // 非自营
                isSelfSale = false
                if let venderId = model.vendorId {
                    sellerCode = "\(venderId)"
                }
                else {
                    sellerCode = ""
                }
            }
            // NO-申请 YES-查看
            let isCheckContent: Bool = (model.statusDesc == -9) ? false : true
            
            // 界面跳转...<申请采购权限>
            FKYNavigator.shared().openScheme(FKY_PurchaseAuthority.self, setProperty: { (vc) in
                // VC
                let paVC = vc as! FKYPurchaseAuthorityVC
                paVC.sellerCode = sellerCode // 商家id
                paVC.isSelfSale = isSelfSale // 是否自营
                paVC.isCheckContent = isCheckContent // 是否第一次填写or查看
            }, isModal: false)
        }
<<<<<<< HEAD
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
            cell.goToActivityClosure = {
                FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                    let v = vc as! FKY_Web
                    v.urlPath = "https://m.yaoex.com/blob/activity_rules.html"
                    v.title = "活动时间"
                    v.barStyle = .barStyleWhite
                })
            }
            cell.selectedBannerClosure = { (url) in
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "clickBanner", itemPosition: "4", itemName:nil,extendParams:nil, viewController: self)
                
                visitSchema(url)
            }
            cell.configCellForActivityShop(self.shopProvider!.banners!, activityButtonHiden: true, activityInfo: self.promotionInfo)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYReusableForShopPLHeader", for: indexPath) as! FKYReusableForShopPLHeader
=======
        else if model.statusDesc == -12 {
            // 采购权限已禁用
>>>>>>> feature/shopRevision
            
            // 弹出提示
            var venderName = "供应商" // 默认
            if let vender = model.vendorName, vender.isEmpty == false {
                venderName = vender
            }
            let tip = String.init(format: "您的采购权限被关闭，\n可联系 %@ 进行咨询！", venderName)
            //                        let alert = UIAlertView.init(title: nil, message: tip, delegate: nil, cancelButtonTitle: "知道啦")
            //                        alert.show()
            
<<<<<<< HEAD
            weak var weakSelf = self
            // 加车
            cell.addCartClosure = { (product,count) in
            let outOfStock: String = (product.statusDesc == -5) ? "1" : "0"
            FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "addCart", itemPosition: "6", itemName:nil,extendParams:["PageValue":self.shopId as AnyObject,"eventid":"button_addCart" as AnyObject,"outofstock":outOfStock as AnyObject,"demand":count as AnyObject,"storage":product.stockCount as AnyObject], viewController: self)
                self.showLoading()
                // 加车
                self.shopProvider?.addShopCart(product, count: count, completionClosure: { (reason, data) in
                    // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                    
                    // toast
                    if let re = reason {
                        self.toast(re)
                    }
                    
                    // 加车成功则重置...<限购>
                    product.limitCanBuyNumber = 0
                    // 限购之剩余可购买数量
                    if let res = data {
                        // limitCount
                        // limitBuyCycleType
                        // limitCanBuyNum
                        if res.value(forKeyPath: "limitCanBuyNum") != nil && (res.value(forKeyPath: "limitCanBuyNum") as AnyObject).isKind(of: NSNumber.self) {
                            if let limitCanBuyNum = res.value(forKeyPath: "limitCanBuyNum") {
                                let limit = Int(limitCanBuyNum as! NSNumber)
                                print("limit:" + String(limit))
                                product.limitCanBuyNumber = limit
                            }
                        }
                    }
                    
                    // 更新
                    weakSelf?.selectedSection = nil
                    let maxSection = self.collectionView.numberOfSections
                    if indexPath.section < maxSection {
                        let indexSet = IndexSet(integer: indexPath.section)
                        weakSelf?.collectionView.reloadSections(indexSet)
                    }
                    else {
                        // exception handle
                        weakSelf?.collectionView.reloadData()
                    }
                    weakSelf?.changeBadgeNumber()
                    var promotions = product.promotionList?.filter({ (po) -> Bool in
                        return po.promotionId == weakSelf?.promotionId
                    })
                    if (weakSelf?.promotionId == nil) {
                        promotions = product.promotionList
                    }
                    if (promotions?.count > 0) {
                        self.getAvtivityInfo()
                    }
                    self.dismissLoading()
                })
            }
            //
            cell.toastClosure = {(msg)in
                self.toast(msg)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            //
            switch indexPath.section {
            case 0:
                // 店铺
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeShopSection", for: indexPath) as! HomeShopSection
                var shopName: String? = nil
                if(self.shopProvider!.shopInfo != nil){
                    shopName = self.shopProvider!.shopInfo!.shopName
                }
                section.configSection(shopName,subTitle:"企业资质")
                section.moreShop = {
                    if let shopDocList = self.shopProvider?.shopDocList, shopDocList.count > 0 {
                        
                        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "getQualifile", itemPosition: "17", itemName:nil,extendParams:nil, viewController: self)
                        
                        FKYNavigator.shared().openScheme(FKY_ShopMaterial.self, setProperty: { (vc) in
                            let v = vc as! ShopMaterialViewController
                            v.shopDocList = self.shopProvider!.shopDocList!
                        })
                    }else{
                        self.toast("暂无资质")
                    }
                }
                return section
            case 1:
                // ???
                if indexPath.section == 1 && self.viewType != .none {
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FKYReuseFooter", for: indexPath) as! FKYReuseFooter
                    
                    footer.allProductsClouser = {
                        self.viewType = .noraml
                        self.initNetwork()
                        self.getServiceData("", priceRange: .ASC)
                    }
                    footer.activityProductsClouser = {
                        self.viewType = .fullReduce
                        self.initNetwork()
                        self.fullReduceProducts()
                    }
                    return footer
                }else{
                    let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                    section.backgroundColor = bg2
                    return section
                }
            default:
                // 商品cell
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ShopProductItemCell", for: indexPath) as! ShopProductItemCell
                
                // 配置cell
                let model = self.dataSource[indexPath.section - 2] as HomeProductModel
                var editing = false
                if self.selectedSection != nil {
                    editing = self.selectedSection! == indexPath.section
                }
                section.configCell(model, editing:editing)

                weak var weakSelf = self
                // 加车(入口)...<展示底部的加车栏>
                section.selectedAction = {
                    // update
                    if weakSelf?.selectedSection != nil && weakSelf?.selectedSection == indexPath.section {
                        // 隐藏
                        weakSelf?.selectedSection = nil
                    }
                    else {
                        // 显示
                        if let section = weakSelf?.selectedSection {
                            // 显示另外一个...<需先隐藏之前已显示的>
                            weakSelf?.selectedSection = nil
                            let maxSection = self.collectionView.numberOfSections
                            if section < maxSection {
                                let indexSet = IndexSet(integer: section)
                                weakSelf?.collectionView.reloadSections(indexSet)
                            }
                            else {
                                // exception handle
                                weakSelf?.collectionView.reloadData()
                            }
                        }
                        else {
                            // 显示全新一个
                        }
                        weakSelf?.selectedSection = indexPath.section
                    }
                    
                    let maxSection = self.collectionView.numberOfSections
                    if indexPath.section < maxSection {
                        let indexSet = IndexSet(integer: indexPath.section)
                        weakSelf?.collectionView.reloadSections(indexSet)
                    }
                    else {
                        // exception handle
                        weakSelf?.collectionView.reloadData()
                    }
                }
                // 登录
                section.loginClosure = {
                    FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true)
                }
=======
            let actionDone = UIAlertAction.init(title: "知道啦", style: .default, handler: { (action) in
>>>>>>> feature/shopRevision
                //
            })
            actionDone.setValue(RGBColor(0xFE5050), forKey: "titleTextColor")
            
            let alertVC = UIAlertController.init(title: nil, message: tip, preferredStyle: .alert)
            alertVC.addAction(actionDone)
            self.present(alertVC, animated: true, completion: {
                //
<<<<<<< HEAD
                section.activityaInfoAlterClosure = {
                    FKYProductAlertView.show(withTitle: nil, leftTitle: "确定", rightTitle: nil, message: model.activityDescription,titleColor:RGBColor(0xe60012), handler: { (_,isRight) in
                    })
                }
                // 商详
                section.touchItem = {
                    //let model = self.dataSource[indexPath.section - 2]
                    FKYAnalyticsManager.sharedInstance.BI_Record(floorCode:nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "goProductdetail", itemPosition: "7", itemName:nil,extendParams:nil, viewController: self)
                    
                    FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                        let v = vc as! FKY_ProdutionDetail
                        v.productionId = model.productId
                        v.vendorId = "\(model.vendorId!)"
                        }, isModal: false)
                }
                // 申请采购权限
                section.purchaseApplyClosure = {
                    if model.statusDesc == -9 || model.statusDesc == -11 {
                        // 无采购权限 or 权限审核不通过
                        
                        // 商家id
                        var sellerCode: String = SELF_SHOP_ID
                        var isSelfSale: Bool = true
                        if let venderId = model.vendorId, "\(venderId)" == SELF_SHOP_ID {
                            // 自营
                            isSelfSale = true
                            sellerCode = SELF_SHOP_ID
                        }
                        else {
                            // 非自营
                            isSelfSale = false
                            if let venderId = model.vendorId {
                                sellerCode = "\(venderId)"
                            }
                            else {
                                sellerCode = ""
                            }
                        }
                        // NO-申请 YES-查看
                        let isCheckContent: Bool = (model.statusDesc == -9) ? false : true
                        
                        // 界面跳转...<申请采购权限>
                        FKYNavigator.shared().openScheme(FKY_PurchaseAuthority.self, setProperty: { (vc) in
                            // VC
                            let paVC = vc as! FKYPurchaseAuthorityVC
                            paVC.sellerCode = sellerCode // 商家id
                            paVC.isSelfSale = isSelfSale // 是否自营
                            paVC.isCheckContent = isCheckContent // 是否第一次填写or查看
                        }, isModal: false)
                    }
                    else if model.statusDesc == -12 {
                        // 采购权限已禁用
                        
                        // 弹出提示
                        var venderName = "供应商" // 默认
                        if let vender = model.vendorName, vender.isEmpty == false {
                            venderName = vender
                        }
                        let tip = String.init(format: "您的采购权限被关闭，\n可联系 %@ 进行咨询！", venderName)
//                        let alert = UIAlertView.init(title: nil, message: tip, delegate: nil, cancelButtonTitle: "知道啦")
//                        alert.show()
                        
                        let actionDone = UIAlertAction.init(title: "知道啦", style: .default, handler: { (action) in
                            //
                        })
                        actionDone.setValue(RGBColor(0xFE5050), forKey: "titleTextColor")
                        
                        let alertVC = UIAlertController.init(title: nil, message: tip, preferredStyle: .alert)
                        alertVC.addAction(actionDone)
                        self.present(alertVC, animated: true, completion: {
                            //
                        })
                    }
                    else if model.statusDesc == -10 {
                        // 采购权限待审核
                    }
                }
                return section
            } // switch
        }
        else {
            //
            if indexPath.section == 0 && self.promotionModel != nil {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ActivityInfoFooterView", for: indexPath) as! ActivityInfoFooterView
                footer.configView(self.promotionModel!)
                return footer
            }
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            section.backgroundColor = .clear
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(110))
        case 1:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        default:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(40))
        case 1:
            if self.viewType == .none {
                return CGSize(width: SCREEN_WIDTH, height: WH(0))
            }else{
                return CGSize(width: SCREEN_WIDTH, height: WH(60))
            }
        default:
            return CGSize(width: SCREEN_WIDTH, height: WH(104))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && self.promotionModel != nil {
            let strProtmotion: String = "以下商品享受: " + self.promotionModel!.promotionDescriptionWithoutPromotionType()
            let textHeight: CGFloat = strProtmotion.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(12)), width: (SCREEN_WIDTH - (WH(10))*2), attributes: nil) + (WH(13) * 2)
            if textHeight > WH(60) {
                return CGSize(width: SCREEN_WIDTH, height: textHeight)
            }
            return CGSize(width: SCREEN_WIDTH, height: WH(60))
=======
            })
>>>>>>> feature/shopRevision
        }
        else if model.statusDesc == -10 {
            // 采购权限待审核
        }
    }
    func alertToastInfo(_ msg: String) {
        self.toast(msg)
    }
    func clickBannerPic(_ adModel: ShopAdModel) {
        FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: "0",floorName: nil, sectionCode: "0", sectionPosition: "0", sectionName: nil, itemCode: "clickBanner", itemPosition: "4", itemName:nil, viewController: self)
        visitSchema(adModel.ad_pic_url!)
    }
    
}


