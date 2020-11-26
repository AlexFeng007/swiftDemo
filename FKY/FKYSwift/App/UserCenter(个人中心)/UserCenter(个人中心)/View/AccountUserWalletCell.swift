//
//  AccountUserWalletCell.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  个人中心用户资产信息

import UIKit
// ["购物金","返利金","优惠券","1药贷"]
enum AccountWallteCellType: Int {
    case AccountWallteCellTypeShoppingMoney = 0
    case AccountWallteCellTypeRebate = 1
    case AccountWallteCellTypeCounple = 2
    case AccountWallteCellTypeLoan = 3
    case AccountWallteCellTypeBanking = 4
}
class AccountUserWalletCell: UITableViewCell {
    var clickWallteCellTypeAction :((_ cellType:AccountWallteCellType)->())? //点击钱包类型
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
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            //            if let closure = strongSelf.touchItem {
            //                closure()
            //            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
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
        view.register(AccountWalletTypeCell.self, forCellWithReuseIdentifier: "AccountWalletTypeCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        //view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate lazy var pageControl: NewCirclePageControl = {
        let view = NewCirclePageControl.init(frame: CGRect.zero)
        view.currentPageColor =  RGBColor(0xFF2D5C)
        view.normalPageColor =  RGBColor(0xECE6E7)
        view.dotNomalSize = CGSize(width:WH(6),height:WH(3))   // 正常点的size
        view.dotBigSize = CGSize(width:WH(14),height:WH(3))   // 正常点的size
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
        contentBgView.addSubview(pageControl)
        
        topView.addSubview(celltypeIcon)
        topView.addSubview(cellTitleLabel)
        
        
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
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentBgView)
            make.height.equalTo(WH(3))
            make.bottom.equalTo(contentBgView.snp.bottom).offset(-WH(9))
            make.width.equalTo(WH(0))
        }
        
        celltypeIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(topView).offset(WH(12))
            make.width.equalTo(WH(20))
            make.height.equalTo(WH(15))
        }
        
        cellTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(celltypeIcon.snp.right).offset(WH(7))
        }
        
    }
    func configCell(_ userInfoModel:AccountInfoModel?) {
        self.userInfo = userInfoModel
        cellTitleLabel.text = "我的钱包"
        celltypeIcon.image = UIImage(named: "my_wallet_icon")
        if let model = userInfoModel ,model.cellTypeArr.count > 4 {
            pageControl.isHidden = false
            bottomView.isScrollEnabled = true
            bottomView.snp.updateConstraints { (make) in
                make.bottom.equalTo(contentBgView.snp.bottom).offset(-WH(8))
            }
            var pageNum = model.cellTypeArr.count/4
            if model.cellTypeArr.count%4 > 0 {
                pageNum = pageNum + 1
            }
            pageControl.pages = pageNum
            pageControl.setPageDotsView()
            bottomView.contentOffset.x = 0
            let pageW = WH(16)+CGFloat(pageNum-1)*WH(6+5)
            pageControl.snp.updateConstraints { (make) in
                make.width.equalTo(pageW)
            }
        }else {
            pageControl.isHidden = true
            bottomView.isScrollEnabled = false
            bottomView.snp.updateConstraints { (make) in
                make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(0))
            }
        }
        bottomView.reloadData()
    }
    
}
extension  AccountUserWalletCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.userInfo {
            return model.cellTypeArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = self.userInfo {
            if model.cellTypeArr.count > 3 {
                return CGSize(width:(SCREEN_WIDTH - WH(32))/4.0 - 0.5, height:WH(82))
            }else{
                return CGSize(width:(SCREEN_WIDTH - WH(32))/3.0 - 0.5, height:WH(82))
            }
        }
        return CGSize(width:WH(0), height:WH(0))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountWalletTypeCell", for: indexPath) as!  AccountWalletTypeCell
        if let model = self.userInfo {
            let cellType = model.cellTypeArr[indexPath.row]
            cell.configCell(self.userInfo, cellType)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.userInfo {
            let cellType = model.cellTypeArr[indexPath.row]
            if let closure = self.clickWallteCellTypeAction {
                closure(cellType)
            }
        }
    }
}
extension AccountUserWalletCell {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showPageIndex(scrollView)
    }
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showPageIndex(scrollView)
    }
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        showPageIndex(scrollView)
    }
    func showPageIndex(_ scrollView: UIScrollView){
        if scrollView.contentOffset.x > 0 {
            let index: Int = Int(scrollView.contentOffset.x / SCREEN_WIDTH) + 1
            pageControl.setCurrectPage(index)
        }else {
            pageControl.setCurrectPage(0)
        }
    }
}
class AccountWalletTypeCell: UICollectionViewCell {
    //icon图片
    //cell title
    fileprivate var walletNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    //cell title
    fileprivate var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0x666666)
        return label
    }()
    
    fileprivate var tagView: AccountTagView = {
        let tagView =  AccountTagView()
        return tagView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(walletNumLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(tagView)
        walletNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(21))
            make.height.equalTo(WH(15))
            make.centerX.equalTo(contentView)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletNumLabel.snp.bottom).offset(WH(10))
            make.centerX.equalTo(contentView)
        }
        
        tagView.snp.makeConstraints { (make) in
            make.bottom.equalTo(walletNumLabel.snp.top)
            make.left.equalTo(contentView.snp.centerX).offset(WH(8.5))
            make.height.equalTo(WH(17))
            make.width.equalTo(WH(36))
        }
    }
    func configCell(_ userInfoModel:AccountInfoModel?,_ cellType:AccountWallteCellType) {
        tagView.isHidden = true
        tagView.snp.updateConstraints { (make) in
            make.width.equalTo(WH(36))
        }
        if cellType == .AccountWallteCellTypeShoppingMoney{
            typeLabel.text = "购物金"
            if FKYLoginAPI.loginStatus() == .unlogin {
                walletNumLabel.text = "****"
            }else{
                if  let gwjBalance = userInfoModel?.gwjBalance{
                    walletNumLabel.text =  String(format: "%.2f", gwjBalance.doubleValue)
                }else{
                    walletNumLabel.text = "****"
                }
                //购物金接口返回提示
                if let signStr = userInfoModel?.angleSignText,signStr.count > 0{
                    tagView.isHidden = false
                    tagView.configTagView(signStr)
                    tagView.snp.updateConstraints { (make) in
                        make.width.equalTo(WH(45))
                    }
                }
            }
        }else if cellType == .AccountWallteCellTypeRebate{
            typeLabel.text = "返利金"
            if FKYLoginAPI.loginStatus() == .unlogin {
                walletNumLabel.text = "****"
            }else{
                if  let accountRemain = userInfoModel?.accountRemain{
                    walletNumLabel.text =  String(format:  "%.2f", accountRemain.doubleValue)
                }else{
                    walletNumLabel.text = "****"
                }
                //待到账标签
                if let rebatePendingAmount = userInfoModel?.rebatePendingAmount,rebatePendingAmount.floatValue > 0{
                    tagView.isHidden = false
                    tagView.configTagView("待到账")
                }
            }
        }else if cellType == .AccountWallteCellTypeCounple{
            typeLabel.text = "优惠券"
            if FKYLoginAPI.loginStatus() == .unlogin {
                walletNumLabel.text = "****"
            }else{
                if  let couponCount = userInfoModel?.couponCount{
                    walletNumLabel.text =  String(format: "%ld", couponCount)
                }else{
                    walletNumLabel.text = "****"
                }
            }
        }else if cellType == .AccountWallteCellTypeBanking {
            typeLabel.text = "1药贷-上银金融"
            walletNumLabel.text = "****"
            if FKYLoginAPI.loginStatus() == .unlogin {
                walletNumLabel.text = "****"
            }else{
                if let shModel = userInfoModel?.shBankModel {
                    if shModel.auditStatus == "1"{
                        //已申请通过 需要显示额度信息 <(0：未激活；1：已激活；2：激活失败；3：待打款认证)>
                        if shModel.entStatus == "0" {
                            walletNumLabel.text = "未激活"
                        }else if shModel.entStatus == "1"{
                            walletNumLabel.text =  String(format: "%.2f", shModel.avaliLimitTotal ?? 0)
                        }else if shModel.entStatus == "2" {
                            walletNumLabel.text = "激活失败"
                        }else if shModel.entStatus == "3" {
                            walletNumLabel.text = "待打款认证"
                        }else {
                            walletNumLabel.text =  String(format: "%.2f", shModel.avaliLimitTotal ?? 0)
                        }
                    }else if shModel.auditStatus == "2"{
                        //审核未通过，需要显示不通过原因
                        walletNumLabel.text = "审核未通过"
                    }else if shModel.auditStatus == "3"{
                        //未申请 需要跳转中间页 申请
                        walletNumLabel.text = "去申请"
                    }else{
                        walletNumLabel.text = "申请中"
                    }
                }
            }
        }else if cellType == .AccountWallteCellTypeLoan{
            typeLabel.text = "1药贷"
            if FKYLoginAPI.loginStatus() == .unlogin {
                walletNumLabel.text = "****"
            }else{
                walletNumLabel.text = "****"
                if let yydInfo = userInfoModel?.yydInfo{
                    typeLabel.text = yydInfo.yydTitle ?? "1药贷"
                    if let aboutToExpire = yydInfo.aboutToExpire,aboutToExpire == 1{
                        //打将到期的标
                        tagView.isHidden = false
                        tagView.configTagView("将到期")
                    }
                    if let isAuditIng = yydInfo.isAudit ,(isAuditIng == 1 || isAuditIng == 5) { //质管审核通过或资质过期
                        if let isCheckIng = yydInfo.isCheck, (isCheckIng == 1 || isCheckIng == 3) {
                            // BD状态为审核通过或变更
                            if yydInfo.status == "05"{
                                //通过审核
                                if let limitOverdue = yydInfo.limitOverdue,limitOverdue == 0{
                                    walletNumLabel.text = String(format: "%.2f", yydInfo.remainAmount?.doubleValue ?? 0)
                                    return
                                }
                            }
                        }
                    }
                }
                if let yydInfo = userInfoModel?.yydInfo{
                    //tagView.isHidden = false
                    walletNumLabel.text = yydInfo.loanDesc ?? ""
                    //tagView.configTagView("NEW")
                    tagView.isHidden = yydInfo.hideTag ?? true
                }
                
            }
        }
    }
}

