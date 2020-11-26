//
//  UseCouponController.swift
//  FKY
//
//  Created by zengyao on 2018/1/16.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  检查订单之使用优惠券

import UIKit

class UseCouponController: UIViewController {
    //MARK:ui属性
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    // 使用规则
    fileprivate lazy var infoBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.isHidden = true
        btn.setTitle("使用规则", for: .normal)
        btn.setTitleColor(t3.color, for: .normal)
        btn.titleLabel?.font = t3.font
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.popRuleInfoDetailView()
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 标题
        view.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1.0
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHideCouponPopView(false)
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        view.addSubview(self.infoBtn)
        self.infoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view.snp.right).offset(-WH(17))
        }
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    
    //
    fileprivate lazy var couponSegmentView: HMSegmentedControl = {
        let view = HMSegmentedControl()
        view.backgroundColor = RGBColor(0xffffff)
        view.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0x333333),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))]
        view.selectedTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0xFF2D5C),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))]
        view.selectionIndicatorColor = RGBColor(0xFF2D5C)
        view.selectionIndicatorHeight = WH(0.5)
        view.selectionStyle = .textWidthStripe
        view.selectionIndicatorLocation = .down
        view.borderType = .bottom
        view.borderColor = RGBColor(0xE5E5E5)
        view.borderWidth = 0.5
        view.indexChangeBlock = { [weak self] selectedNum in
            if let strongSelf = self {
                strongSelf.couponsScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(selectedNum), y: 0), animated: true)
            }
        }
        return view
    }()
    //可用券视图
    fileprivate lazy var canUseView:FKYCouponShopOrPrdView = {
        let view = FKYCouponShopOrPrdView()
        view.viewType = 1
        view.clickButtonBlock = { [weak self] (typeIndex,desModel) in
            guard let strongSelf = self else {
                return
            }
            if typeIndex==3 {
                //选中取消
                strongSelf.refreshCouponList(desModel)
            }
        }
        view.clickCertianBtnBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                if let block = strongSelf.callToblock ,let service = strongSelf.couponService{
                    block(service)
                }
                strongSelf.showOrHideCouponPopView(false)
            }
        }
        return view
    }()
    //不可用视图
    fileprivate lazy var noCanUseView: FKYCouponShopOrPrdView! = {
        let view = FKYCouponShopOrPrdView()
        view.viewType = 2
        view.clickButtonBlock = { [weak self] (typeIndex,desModel) in
            if typeIndex==1 {
                //可用商品
                FKYNavigator.shared().openScheme(FKY_ShopCouponProductController.self, setProperty: { (vc) in
                    let viewController = vc as! CouponProductListViewController
                    viewController.couponTemplateId = desModel.templateId ?? ""
                    viewController.shopId = desModel.sellerCode ?? "0"
                    viewController.couponName = desModel.getCouponFullName()
                    viewController.couponCode = desModel.couponCode ?? ""
                })
            }else if typeIndex==2{
                //可用商家
            }
        }
        return view
    }()
    //滚动视图
    fileprivate lazy var couponsScrollView: UIScrollView! = {
        let sv = UIScrollView(frame: .zero)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = RGBColor(0xFCFCFC)
        sv.contentSize = CGSize(width: SCREEN_WIDTH.multiple(2), height: 0)
        return sv
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFCFCFC)
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        view.addSubview(self.couponSegmentView)
        self.couponSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewTop.snp.bottom)
            make.right.left.equalTo(view)
            make.height.equalTo(WH(44))
        }
        view.addSubview(self.couponsScrollView)
        self.couponsScrollView.snp.makeConstraints { (make) in
            make.right.left.equalTo(view)
            make.top.equalTo(self.couponSegmentView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-bootSaveHeight())
        }
        self.couponsScrollView.addSubview(self.canUseView)
        self.canUseView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.couponsScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.couponsScrollView.snp.height)
        }
        self.couponsScrollView.addSubview(self.noCanUseView)
        self.noCanUseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.couponsScrollView)
            make.left.equalTo(self.canUseView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.couponsScrollView.snp.height)
        }
        return view
    }()
    
    
    //MARK:属性
    //不赋值则使用keyWindow
    var bgView: UIView?
    // 优惠券是否弹出是否已弹出
    var viewShowFlag: Bool = false
    typealias reBackBlock = (FKYCartSubmitService)->()
    
    // MARK: - properties
    //须传入参数
    var typeIndex = 0 //(0：店铺优惠券1：平台优惠券)
    var couponDicModel: FKYCouponDicModel? //请求参数
    
    var couponService : FKYCartSubmitService?
    var callToblock:reBackBlock?
    
    //请求的数据
    fileprivate var useList: [FKYReCheckCouponModel] = [FKYReCheckCouponModel]() //可用商品券或者可用平台券
    fileprivate var unUseList: [FKYReCheckCouponModel] = [FKYReCheckCouponModel]() //不可用商品券或者不可用平台券
    
    var couponCodeStrs = ""//选中的优惠券
    //MARK:控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.showOrHideCouponPopView(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>UseCouponController deinit~!@")
    }
    
}
//MARK:ui布局
extension UseCouponController {
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopView(false)
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(CONTENT_COUPON_VIEW_H)
            make.height.equalTo(CONTENT_COUPON_VIEW_H)
        }
    }
}
//MARK: - Public(弹框)
extension UseCouponController {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            // 显示
            if let iv = self.bgView {
                iv.addSubview(self.view)
                self.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(iv)
                })
            }else {
                //添加在根视图上面
                let window = UIApplication.shared.keyWindow
                if let rootView = window?.rootViewController?.view {
                    window?.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                        make.edges.equalTo(rootView)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(CONTENT_COUPON_VIEW_H)
            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(WH(0))
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
        }
        else {
            self.view.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(CONTENT_COUPON_VIEW_H)
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParent()
                        // 移除通知
                    }
            })
        }
    }
    
    //视图赋值
    @objc func configUseCouponViewController() {
        if self.typeIndex == 0 {
            self.lblTitle.text = "使用店铺优惠券"
        }else {
            self.lblTitle.text = "使用平台优惠券"
        }
        self.couponService = FKYCartSubmitService()
        self.couponSegmentView.setSelectedSegmentIndex(0, animated: true)
        self.couponsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.showOrHideCouponPopView(true)
        self.requestCouponData()
    }
}
//MARK:方法
extension UseCouponController {
    //显示使用规则
    fileprivate func popRuleInfoDetailView(){
        if let titleStr =  self.couponService?.couponRuleTitle ,let textStr = self.couponService?.couponRuleContent{
            let firstTextStr = textStr.replacingOccurrences(of: "<p>", with: "")
            let secondTextStr = firstTextStr.replacingOccurrences(of: "</p>", with: "\n")
            let thirdTextStr = secondTextStr.replacingOccurrences(of: "<br/>", with: "")
            let fourTextStr = thirdTextStr.replacingOccurrences(of: "<br>", with: "")
            if let viewConfig = WUAlertViewConfig.shared() {
                viewConfig.cornerRadius = WH(4)
                viewConfig.itemNormalBackgroundColor = t73.color
                viewConfig.itemNormalTextColor = RGBColor(0xffffff)
                viewConfig.buttonHeight = WH(42)
                viewConfig.itemPressedBackgroundColor = t73.color
                viewConfig.itemHighlightTextColor = RGBColor(0xffffff)
            }
            if let infoView = WUAlertView.init(title: titleStr, message: fourTextStr, items: [WUPopItemMake("知道了", .normal, nil)]){
                infoView.show()
                infoView.layer.cornerRadius = WH(13)
            }
            
        }
    }
    //更新数据
    fileprivate func refreshCouponViewWithData(){
        if self.typeIndex == 0{
            self.couponSegmentView.sectionTitles = ["可用店铺券(\(self.useList.count))","不可用店铺券(\(self.unUseList.count))"]
        }else {
            self.couponSegmentView.sectionTitles = ["可用平台券(\(self.useList.count))","不可用平台券(\(self.unUseList.count))"]
        }
        
        if let _ =  self.couponService?.couponRuleTitle ,let _ = self.couponService?.couponRuleContent{
            self.infoBtn.isHidden = false
        }else {
            self.infoBtn.isHidden = true
        }
        //更新列表
        //可用券列表
        self.canUseView.configCouponShopOrPrdViewData(self.typeIndex, self.useList)
        //不可用券列表
        self.noCanUseView.configCouponShopOrPrdViewData(self.typeIndex, self.unUseList)
    }
    
}
//MARK:
extension UseCouponController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        self.couponSegmentView.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}
//MARK:请求数据相关
extension UseCouponController {
    func refreshCouponList(_ model:FKYReCheckCouponModel) {
        if self.typeIndex == 0 {
            //店铺券
            self.couponCodeStrs = ""
            if model.isCheckCoupon == 1 {
                var oldCodeStrs=""
                if self.couponService?.checkCouponCodeStr != nil{
                    oldCodeStrs = (self.couponService?.checkCouponCodeStr)!
                }
                var arr = [String]()
                if oldCodeStrs.count > 0 {
                    arr = oldCodeStrs.components(separatedBy: ",")
                }
                let muArr = NSMutableArray(array: arr)
                if muArr.contains(model.couponCode){
                    muArr.remove(model.couponCode)
                }
                self.couponCodeStrs = muArr.componentsJoined(by: ",")
                if let model = self.couponDicModel , let arr = model.couponDTOList {
                    for dicModel in arr {
                        if dicModel.sellerCode == model.sellerCode{
                            dicModel.couponCodeList = muArr as? [String]
                        }
                    }
                }
                self.requestCouponData()
            } else  {
                var oldCodeStrs=""
                if self.couponService?.checkCouponCodeStr != nil{
                    oldCodeStrs = (self.couponService?.checkCouponCodeStr)!
                }
                if oldCodeStrs.count > 0 {
                    //选中未勾选时，但是已经有选中的优惠券，须先取消选择的优惠券
                    self.toast("请先取消已经勾选的优惠券再进行选择", time: 1.5)
                    return
                }
                var arr = [String]()
                if oldCodeStrs.count > 0 {
                    arr = oldCodeStrs.components(separatedBy: ",")
                }
                let muArr = NSMutableArray(array: arr)
                if !muArr.contains(model.couponCode){
                    muArr.add(model.couponCode)
                }
                self.couponCodeStrs = muArr.componentsJoined(by: ",")
                if let model = self.couponDicModel , let arr = model.couponDTOList {
                    for dicModel in arr {
                        if dicModel.sellerCode == model.sellerCode{
                            dicModel.couponCodeList = muArr as? [String]
                        }
                    }
                }
                self.requestCouponData()
            }
        }else {
            //平台券
            self.couponCodeStrs = ""
            if model.isCheckCoupon == 1 {
                var oldCodeStrs=""
                if self.couponService?.checkCouponCodeStr != nil{
                    oldCodeStrs = (self.couponService?.checkCouponCodeStr)!
                }
                var arr = [String]()
                if oldCodeStrs.count > 0 {
                    arr = oldCodeStrs.components(separatedBy: ",")
                }
                let muArr = NSMutableArray(array: arr)
                if muArr.contains(model.couponCode){
                    muArr.remove(model.couponCode)
                }
                self.couponCodeStrs = muArr.componentsJoined(by: ",")
                if let model = self.couponDicModel  {
                    model.platformCouponCode = self.couponCodeStrs
                }
                self.requestCouponData()
            } else  {
                var oldCodeStrs=""
                if self.couponService?.checkCouponCodeStr != nil{
                    oldCodeStrs = (self.couponService?.checkCouponCodeStr)!
                }
                if oldCodeStrs.count > 0 {
                    //选中未勾选时，但是已经有选中的优惠券，须先取消选择的优惠券
                    self.toast("请先取消已经勾选的优惠券再进行选择", time: 1.5)
                    return
                }
                var arr = [String]()
                if oldCodeStrs.count > 0 {
                    arr = oldCodeStrs.components(separatedBy: ",")
                }
                let muArr = NSMutableArray(array: arr)
                if !muArr.contains(model.couponCode){
                    muArr.add(model.couponCode)
                }
                self.couponCodeStrs = muArr.componentsJoined(by: ",")
                if let model = self.couponDicModel  {
                    model.platformCouponCode = self.couponCodeStrs
                }
                self.requestCouponData()
            }
        }
    }
    fileprivate func requestCouponData() {
        self.showLoading()
        self.couponService?.recheckCouponListPageInfo(self.couponDicModel?.getJson(), success: {[weak self] (mutiplyPage) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.useList.removeAll()
            strongSelf.unUseList.removeAll()
            if let couponArr = strongSelf.couponService?.couponListArray {
                for model in couponArr {
                    if model.isUseCoupon == 1 &&  model.isCheckCoupon != 2 {
                        strongSelf.useList.append(model)
                    }else {
                        strongSelf.unUseList.append(model)
                    }
                }
            }
            strongSelf.refreshCouponViewWithData()
            }, failure: {[weak self] (msg) in
                self?.dismissLoading()
                self?.toast(msg)
        })
    }
}
