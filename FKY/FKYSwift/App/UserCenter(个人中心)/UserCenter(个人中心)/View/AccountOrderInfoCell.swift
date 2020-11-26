//
//  AccountOrderInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  个人中心用户订单信息

import UIKit
//["待付款","待发货","待收货","退换货/售后",全部] //订单类型title
enum AccountOrderCellType: Int {
    case WaitPay = 0
    case WaitSend = 1
    case Sending = 2
    case RCType = 3
    case ALL = 4
}
class AccountOrderInfoCell: UITableViewCell {
    var clickOrderCellTypeAction :((_ cellType:AccountOrderCellType)->())? //点击订单类型
    var cellOrderCellTypeArr:[AccountOrderCellType] = [.WaitPay,.WaitSend,.Sending,.RCType]
    var userInfo:AccountInfoModel?
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = WH(6)
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xE5E5E5, alpha: 1)
        return view
    }()
    
    //订单类型列表
    fileprivate lazy var bottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(AccountOrderTypeCell.self, forCellWithReuseIdentifier: "AccountOrderTypeCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                view.contentInsetAdjustmentBehavior = .never
                view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                view.scrollIndicatorInsets = view.contentInset
            }
        }
        return view
    }()
    //cell 类型的icon
    fileprivate lazy var celltypeIcon: UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    
    //cell title
    fileprivate var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    // 查看更多按钮
    fileprivate lazy var cellDirImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "account_see_more")
        return iv
    }()
    // cell 功能描述
    fileprivate lazy var cellDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textColor = RGBColor(0x999999)
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickOrderCellTypeAction {
                closure(.ALL)
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(contentBgView)
        contentBgView.addSubview(topView)
        contentBgView.addSubview(lineView)
        contentBgView.addSubview(bottomView)
        
        topView.addSubview(celltypeIcon)
        topView.addSubview(cellTitleLabel)
        topView.addSubview(cellDirImg)
        topView.addSubview(cellDescLabel)
        
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(16))
            make.right.equalTo(self.contentView).offset(WH(-16))
            make.bottom.equalTo(self.contentView).offset(WH(-10))
        }
        
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentBgView)
            make.height.equalTo(WH(39))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentBgView)
            make.height.equalTo(0.5)
            make.top.equalTo(topView.snp.bottom)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentBgView)
            make.top.equalTo(lineView.snp.bottom)
        }
        
        celltypeIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(topView).offset(WH(13))
            make.width.height.equalTo(WH(18))
        }
        
        cellTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(celltypeIcon.snp.right).offset(WH(8))
        }
        
        cellDirImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.right.equalTo(topView).offset(WH(-13))
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(11))
        }
        cellDescLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.right.equalTo(cellDirImg.snp.left).offset(WH(-5))
        }
        
    }
    func configCell(_ userInfoModel:AccountInfoModel?) {
        self.userInfo = userInfoModel
        cellTitleLabel.text = "我的订单"
        cellDescLabel.text = "全部订单"
        celltypeIcon.image = UIImage(named: "account_order_icon")
        bottomView.reloadData()
    }
    
}
extension  AccountOrderInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellOrderCellTypeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(SCREEN_WIDTH - WH(32))/4.0 - 0.5, height:WH(82))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = cellOrderCellTypeArr[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountOrderTypeCell", for: indexPath) as!  AccountOrderTypeCell
        cell.configCell(self.userInfo,cellType)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = cellOrderCellTypeArr[indexPath.row]
        if let closure = self.clickOrderCellTypeAction {
            closure(cellType)
        }
    }
}
class AccountOrderTypeCell: UICollectionViewCell {
    //icon图片
    fileprivate var orderTypeIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //cell title
    fileprivate var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    var cartBadgeView : JSBadgeView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(orderTypeIcon)
        contentView.addSubview(typeLabel)
        orderTypeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.height.width.equalTo(WH(30))
            make.centerX.equalTo(contentView)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderTypeIcon.snp.bottom).offset(WH(5))
            make.centerX.equalTo(contentView)
        }
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.orderTypeIcon, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(1), y: WH(3))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            cbv?.badgeStrokeColor =  RGBColor(0xFF2D5C)
            cbv?.badgeStrokeWidth =  1
            return cbv
        }()
    }
    func configCell(_ userInfoModel:AccountInfoModel?,_ cellType:AccountOrderCellType) {
        if cellType == .WaitPay{
            typeLabel.text = "待付款"
            orderTypeIcon.image = UIImage(named: "order_waitPay_icon")
            if FKYLoginAPI.loginStatus() == .unlogin && userInfoModel != nil {
                self.cartBadgeView?.badgeText = ""
            }else{
                if let unPayNumber = userInfoModel?.unPayNumber,unPayNumber > 0{
                    self.cartBadgeView?.badgeText = "\(unPayNumber)"
                }else{
                    self.cartBadgeView?.badgeText = ""
                }
            }
        }else if cellType == .WaitSend{
            typeLabel.text = "待发货"
            orderTypeIcon.image = UIImage(named: "order_wait_send_icon")
            if FKYLoginAPI.loginStatus() == .unlogin && userInfoModel != nil {
                self.cartBadgeView?.badgeText = ""
            }else{
                if let deliverNumber = userInfoModel?.deliverNumber,deliverNumber > 0{
                    self.cartBadgeView?.badgeText = "\(deliverNumber)"
                }else{
                    self.cartBadgeView?.badgeText = ""
                }
                
            }
        }else if cellType == .Sending{
            typeLabel.text = "待收货"
            orderTypeIcon.image = UIImage(named: "order_sending_icon")
            if FKYLoginAPI.loginStatus() == .unlogin  && userInfoModel != nil{
                self.cartBadgeView?.badgeText = ""
            }else{
                if let reciveNumber = userInfoModel?.reciveNumber,reciveNumber > 0{
                    self.cartBadgeView?.badgeText = "\(reciveNumber)"
                }else{
                    self.cartBadgeView?.badgeText = ""
                }
            }
        }else if cellType == .RCType{
            typeLabel.text = "退换货/售后"
            orderTypeIcon.image = UIImage(named: "order_rc_icon")
            if FKYLoginAPI.loginStatus() == .unlogin && userInfoModel != nil{
                self.cartBadgeView?.badgeText = ""
            }else{
                if let rmaCount = userInfoModel?.rmaCount,rmaCount > 0{
                    self.cartBadgeView?.badgeText = "\(rmaCount)"
                }else{
                    self.cartBadgeView?.badgeText = ""
                }
            }
        }
    }
}

