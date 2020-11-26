//
//  SendCouponDetailInfoController.swift
//  FKY
//
//  Created by 寒山 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  浏览送券详情

import UIKit

class SendCouponDetailInfoController: UIViewController {
    fileprivate var navBar: UIView?
    fileprivate var viewModel: SendCouponInfoViewModel = {
        let vm = SendCouponInfoViewModel()
        return vm
    }()
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            // 上拉加载更多
            self?.getHotSellProductInfo()
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0xF73131)
        return footer!
    }()
    //列表
    fileprivate lazy var productCollectView: UICollectionView = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH - WH(112)*3 - WH(22))/2.0
        flowLayout.minimumLineSpacing = WH(9)
        //        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = RGBColor(0xFFF2E7)
        cv.alwaysBounceVertical = true
        cv.mj_footer = self.mjfooter
        cv.mj_footer.isAutomaticallyHidden = true
        cv.register(SendCoupondHotSellProductCell.self, forCellWithReuseIdentifier: "SendCoupondHotSellProductCell") // 加车cell
        cv.register(SendCouponProcessView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SendCouponProcessView")
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        return cv
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSendCouponInfo()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>SendCouponDetailInfoController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.getHotSellProductInfo()
    }
    // MARK: init Method
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xFFF2E7)
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            if let strongSelf = self {
                // 返回
                FKYNavigator.shared().pop()
            }
        }
        var marginBottom: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                marginBottom = iPhoneX_SafeArea_BottomInset
            }
        }
        
        fky_setupTitleLabel( "逛药城，享优惠")
        self.view.addSubview(productCollectView)
        productCollectView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(self.view).offset(-marginBottom)
        }
    }
    /// 弹出错误提示弹窗
    func popErrorView(errorText:String){
        let errorVC = FKYBandingBankCardErrorVC()
        errorVC.showTipsForCommon(errorText,"活动规则")
        errorVC.modalPresentationStyle = .overFullScreen
        self.present(errorVC, animated: false) {}
    }
}
extension SendCouponDetailInfoController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // header
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SendCouponProcessView", for: indexPath) as! SendCouponProcessView
            section.configSectionItemCell(self.viewModel.sendCouponInfoMoel,!self.viewModel.dataSource.isEmpty)
            section.checkRuleCkick = {[weak self] in
                //查看规则
                if let strongSelf = self,strongSelf.viewModel.sendCouponInfoMoel != nil,strongSelf.viewModel.sendCouponInfoMoel!.ruleList?.isEmpty == false{
                    strongSelf.popErrorView(errorText: strongSelf.viewModel.sendCouponInfoMoel!.ruleList?.joined(separator: "\n\n") ?? "")
                }
            }
            return section
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productModel:OftenBuyProductItemModel = self.viewModel.dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendCoupondHotSellProductCell", for: indexPath) as! SendCoupondHotSellProductCell
        cell.configHotSellItemCell(productModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:OftenBuyProductItemModel = self.viewModel.dataSource[indexPath.row]
        self.biNewRecord(indexPath.row,model)
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = model.spuCode!
            v.vendorId = "\(model.supplyId!)"
        }, isModal: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WH(112), height: WH(140))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(314))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(11), bottom: WH(0), right: WH(10))
    }
}
//MARK-请求
extension SendCouponDetailInfoController{
    //获取浏览获取优惠券进度
    func getSendCouponInfo(){
        viewModel.getSendCouponInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.productCollectView.reloadData()
            if success{
                
            } else {
                // 失败
                if  strongSelf.viewModel.dataSource.count == 0{
                    
                }
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //获取热销商品信息
    func getHotSellProductInfo(){
        showLoading()
        self.viewModel.getAllHotSellProductInfo(callback: { [weak self] in
            if let strongSelf = self {
                strongSelf.productCollectView.reloadData()
                strongSelf.refreshDismiss()
            }
        }) { [weak self] (msg) in
            if let strongSelf = self {
                strongSelf.refreshDismiss()
                strongSelf.toast(msg)
            }
        }
    }
    func refreshDismiss() {
        self.dismissLoading()
        if  self.viewModel.hasNextPage {
            self.productCollectView.mj_footer.endRefreshing()
        }else{
            self.productCollectView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
//MARK-埋点
extension SendCouponDetailInfoController{
    //埋点（点击cell）
    fileprivate func biNewRecord(_ index: Int, _ product: OftenBuyProductItemModel) {
        
        var itemContent = ""
        if let supplyId = product.supplyId {
            itemContent = "\(supplyId)|\(product.spuCode ?? "")"
        }
        let extendParams:[String:AnyObject] = ["pageValue":"逛药城，享优惠" as AnyObject,"storage":product.storage as AnyObject,"pm_price":product.pm_price as AnyObject,"pm_pmtn_type":product.pm_pmtn_type as AnyObject]
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9998", itemPosition: "\(index+1)", itemName: "点进商详", itemContent: itemContent, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
    }
    
    
}
