//
//  FKYPopShopCouponListViewController.swift
//  FKY
//
//  Created by yyc on 2020/4/1.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
let POP_SHOP_COUPON_LIST_MAX_VIEW_H = WH(420)+bootSaveHeight() //内容视图最大的高度

class FKYPopShopCouponListViewController: UIViewController {

    //MARK: - Property
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
    
     //优惠券列表
    fileprivate lazy var couponsView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYCouponsViewCell.self, forCellWithReuseIdentifier: "FKYCouponsViewCell")
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = RGBColor(0xffffff)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        
        // tableview
        view.addSubview(self.couponsView)
        self.couponsView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
        }
        
        return view
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
                strongSelf.showOrHideCouponPopListView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(0.5))
        }
        return view
    }()
    
    // 店铺列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var couponArr = [FKYShopCouponsInfoModel]() //优惠券列表
    var closePopView : (()->(Void))?  //关闭弹框
    var clickCouponsTableView : ((Int,Int,FKYShopCouponsInfoModel)->(Void))? //点击视图（1:立即领取 2:查看可用商品 3:可用商家）
    //MARK:入参数
    fileprivate  var contentView_H : CGFloat = 0.0 //内容视图的高度
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
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
        self.showOrHideCouponPopListView(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYPopShopCouponListViewController deinit~!@")
    }

}
extension FKYPopShopCouponListViewController {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopListView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(contentView_H)
            make.height.equalTo(contentView_H)
        }
    }
}

//MARK: - Public(弹框)
extension FKYPopShopCouponListViewController {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopListView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            //添加在根视图上面
            if let window = UIApplication.shared.keyWindow {
                if let rootView = window.rootViewController?.view {
                    window.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                       make.edges.equalTo(rootView)
                    })
                }
            }

            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(contentView_H)
            })
            self.view.layoutIfNeeded()
            self.viewTop.isHidden = true
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewTop.isHidden = false
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
                    strongSelf.viewTop.isHidden = true
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(strongSelf.contentView_H)
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
    @objc func configPopCouponListViewController(_ arr:[FKYShopCouponsInfoModel]) {
        if arr.count > 0 {
            lblTitle.text = "共\(arr.count)张优惠券"
            self.couponArr = arr
            var lineNum = arr.count/2
            if arr.count%2 > 0 {
                lineNum += 1
            }
            let total_content_h = (SHOP_COUPONS_H+WH(3))*CGFloat(lineNum) + WH(56+11) + WH(20) +  bootSaveHeight()
            self.contentView_H = total_content_h > CONTENT_POP_SHOP_LIST_MAX_VIEW_H ? CONTENT_POP_SHOP_LIST_MAX_VIEW_H : total_content_h
            self.showOrHideCouponPopListView(true)
            self.couponsView.reloadData()
        }
    }
    @objc func reloadPopCouponListViewController(){
        if viewShowFlag == true {
            self.couponsView.reloadData()
        }
    }
    @objc func removeMySelf() {
        if viewShowFlag == true {
           viewShowFlag = false
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}

extension FKYPopShopCouponListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.couponArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(SCREEN_WIDTH-WH(23))/2.0, height:SHOP_COUPONS_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:WH(11), left: WH(10), bottom: WH(23), right: WH(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCouponsViewCell", for: indexPath) as! FKYCouponsViewCell
        
        cell.configCell(self.couponArr[indexPath.item])
        cell.clickCouponsView = { [weak self] (typeIndex) in
            if let strongSelf = self {
                if let block = strongSelf.clickCouponsTableView {
                    block(typeIndex,indexPath.item,strongSelf.couponArr[indexPath.item])
                }
            }
        }
        return cell
    }
    
}
