//
//  AccountUserInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//。个人中心用户信息

import UIKit

class AccountUserInfoCell: UITableViewCell {
    @objc var settingBlock: emptyClosure?//设置
    @objc var loginBlock: emptyClosure?//登录
    @objc var vipRulesOrVipListBlock: emptyClosure?//进入vip专区或者了解会员
    @objc var vipRulesBlock: emptyClosure?//会员规则了解
    @objc var enterComplentInfoBlock: emptyClosure?//完善资料
    @objc var switchShopBlock: emptyClosure?//切换店铺
    //个人信息背景
    fileprivate lazy var accountInfoBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //会员信息背景
    fileprivate lazy var vipInfoBgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "account_vip_bg")
        return view
    }()
    
    // 头像
    fileprivate lazy var avtorImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "account_avtor_icon")
        return iv
    }()
    //用户名和店铺名区域
    fileprivate lazy var userInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() == .unlogin {
                if let closure = strongSelf.loginBlock {
                    closure()
                }
            }else{
                if let closure = strongSelf.enterComplentInfoBlock {
                    closure()
                }
            }
            
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //用户名字
    fileprivate lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.text = "登录/注册"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 0
        //        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //店铺名
    fileprivate lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
        label.text = "登录更精彩"
        return label
    }()
    // vipIcon图片
    fileprivate lazy var vipIconImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "account_info_vip_icon")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.vipRulesBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    // 设置图片
    fileprivate lazy var setIconImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = UIImage(named: "account_set_icon")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.settingBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    //切换店铺
    fileprivate lazy var switchShopView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.switchShopBlock{
                block()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    fileprivate lazy var switchShopBorderView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //切换店铺label
    fileprivate var switchShopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        label.text = "切换企业"
        return label
    }()
    //切换店铺icon
    fileprivate lazy var switchShopIcon: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "switch_shop_icon"))
        return imageView
    }()
    
    // 会员专区icon
    fileprivate lazy var vipViewIconImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "account_vip_view_bg")
        return iv
    }()
    // 会员专区icon底部文描
    fileprivate var vipViewIconBottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xEBDBB2)
        return label
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xFFF3C2, alpha: 0.41)
        return view
    }()
    //会员信息描述
    fileprivate lazy var vipDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textColor = RGBAColor(0xFFFFFF, alpha: 0.85)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    //进入专区按钮
    fileprivate lazy var enterVipView: UIView = {
        let gradientColors: [CGColor] = [RGBColor(0xE9C577).cgColor, RGBColor(0xEBDDB6).cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: WH(62), height: WH(23))
        gradientLayer.cornerRadius = WH(11.5)
        
        let btn = UIView()
        btn.layer.addSublayer(gradientLayer)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.vipRulesOrVipListBlock{
                block()
            }
        }).disposed(by: disposeBag)
        btn.addGestureRecognizer(tapGesture)
        return btn
    }()
    fileprivate var enterVipBtn:UILabel = {
        let btn = UILabel()
        btn.textAlignment = .center
        btn.font = UIFont.boldSystemFont(ofSize: WH(11))
        btn.textColor = RGBColor(0x52360F)
        return btn
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
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.contentView.addSubview(accountInfoBgView)
        self.contentView.addSubview(vipInfoBgView)
        accountInfoBgView.addSubview(avtorImageView)
        accountInfoBgView.addSubview(userNameLabel)
        accountInfoBgView.addSubview(shopNameLabel)
        accountInfoBgView.addSubview(vipIconImg)
        accountInfoBgView.addSubview(userInfoView)
        
        accountInfoBgView.addSubview(switchShopView)
        switchShopView.addSubview(switchShopBorderView)
        switchShopView.addSubview(switchShopLabel)
        switchShopView.addSubview(switchShopIcon)
        accountInfoBgView.addSubview(setIconImg)
        
        vipInfoBgView.addSubview(vipViewIconImg)
        vipInfoBgView.addSubview(vipViewIconBottomLabel)
        vipInfoBgView.addSubview(lineView)
        vipInfoBgView.addSubview(vipDescLabel)
        vipInfoBgView.addSubview(enterVipView)
        enterVipView.addSubview(enterVipBtn)
        
        accountInfoBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(WH(-10))
        }
        
        vipInfoBgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(16))
            make.right.equalTo(self.contentView).offset(WH(-16))
            make.bottom.equalTo(self.contentView).offset(WH(-10))
            make.height.equalTo((SCREEN_WIDTH - WH(32))*66/343)
        }
        avtorImageView.snp.makeConstraints { (make) in
            make.left.equalTo(accountInfoBgView).offset(WH(16))
            make.width.height.equalTo(WH(43))
            make.top.equalTo(accountInfoBgView).offset(WH(62) + topMargin)
        }
        
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avtorImageView.snp.right).offset(WH(10))
            make.top.equalTo(accountInfoBgView).offset(WH(63.5) + topMargin)
            make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24))
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avtorImageView.snp.right).offset(WH(10))
            make.top.equalTo(shopNameLabel.snp.bottom).offset(WH(10))
           // make.height.equalTo(WH(13))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(4))
        }
        
        userInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(avtorImageView.snp.right).offset(WH(10))
            make.top.equalTo(shopNameLabel.snp.top)
            make.bottom.equalTo(userNameLabel.snp.bottom)
            make.right.equalTo(userNameLabel.snp.right)
        }
        
        vipIconImg.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.right).offset(WH(6))
            make.top.equalTo(shopNameLabel.snp.top).offset(WH(-1))
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(49))
        }
        //22 20 27
        setIconImg.snp.makeConstraints { (make) in
            make.right.equalTo(accountInfoBgView).offset(WH(-7))
            make.top.equalTo(accountInfoBgView).offset(WH(22) + topMargin)
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(40))
        }
        
        switchShopView.snp.makeConstraints { (make) in
            make.right.equalTo(accountInfoBgView)
            make.bottom.equalTo(userNameLabel.snp.bottom)
            make.height.equalTo(WH(25))
            make.width.equalTo(WH(74))
        }
        switchShopBorderView.frame = CGRect.init(x: 0, y:0, width: WH(74), height: WH(25))
        setMutiBorderRoundingCorners(self.switchShopBorderView, corner: WH(12.5))
        //switchShopView.layer.cornerRadius =  WH(12.5)
        //switchShopView.layer.borderWidth = 1
        // switchShopView.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        switchShopView.addSubview(switchShopIcon)
        switchShopView.addSubview(switchShopLabel)
        
        switchShopIcon.snp.makeConstraints { (make) in
            make.left.equalTo(switchShopView).offset(WH(8))
            make.centerY.equalTo(switchShopView)
            make.width.equalTo(11)
            make.height.equalTo(8)
        }
        switchShopLabel.snp.makeConstraints { (make) in
            make.left.equalTo(switchShopIcon.snp.right).offset(WH(3))
            make.centerY.equalTo(switchShopView)
        }
        
        vipViewIconImg.snp.makeConstraints { (make) in
            make.left.equalTo(vipInfoBgView).offset(WH(26))
            make.top.equalTo(vipInfoBgView).offset(WH(13))
            make.width.equalTo(WH(27))
            make.height.equalTo(WH(23))
        }
        vipViewIconBottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vipViewIconImg.snp.bottom).offset(WH(2))
            make.centerX.equalTo(vipViewIconImg.snp.centerX)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(vipInfoBgView).offset(WH(83))
            make.centerY.equalTo(vipInfoBgView)
            make.width.equalTo(1)
            make.height.equalTo(WH(33))
        }
        
        enterVipView.snp.makeConstraints { (make) in
            make.right.equalTo(vipInfoBgView).offset(WH(-15))
            make.centerY.equalTo(vipInfoBgView)
            make.width.equalTo(WH(62))
            make.height.equalTo(WH(23))
        }
        enterVipBtn.snp.makeConstraints { (make) in
            make.center.equalTo(enterVipView)
        }
        
        vipDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(WH(10))
            make.right.equalTo(enterVipView.snp.left).offset(WH(-4))
            make.centerY.equalTo(vipInfoBgView)
        }
        
    }
    //使用登录的用户信息
    func configCellByUserInfo(_ userInfoModel:FKYUserInfoModel?){
        
        switchShopView.isHidden = true
        vipInfoBgView.isHidden = true
        vipIconImg.isHidden = true
        shopNameLabel.snp.updateConstraints { (make) in
            make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(10))
        }
        if let model = userInfoModel {
            if FKYLoginAPI.loginStatus() == .unlogin {
                userNameLabel.text = "登录更精彩"
                shopNameLabel.text = "登录/注册"
            }else{
                // 用户名称
                if let userName = model.userName,userName.isEmpty == false{
                    userNameLabel.text = "用户名：\(userName)"
                }else{
                    userNameLabel.text = "用户名："
                }
                if let enterpriseName = model.enterpriseName,enterpriseName.isEmpty == false{
                    // 企业名称
                    shopNameLabel.text = enterpriseName
                    let contentSize = (shopNameLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(16))], context: nil).size
                    shopNameLabel.snp.updateConstraints { (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height))
                        make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24))
                    }
                }else{
                    // 无企业名称
                    userNameLabel.text = ""
                    if let userName = model.userName,userName.isEmpty == false{
                        shopNameLabel.text = "用户名：\(userName)"
                    }else{
                        shopNameLabel.text = "用户名："
                    }
                }
            }
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                if let nameList = user.nameList,nameList.count > 1 {
                    switchShopView.isHidden = false
                }
            }
        }
        
    }
    //使用个人中心聚合接口的个人信息
    func configCell(_ userInfoModel:AccountInfoModel?,_ isNotPerfectInformation:Bool?){
        switchShopView.isHidden = true
        vipInfoBgView.isHidden = true
        vipIconImg.isHidden = true
        shopNameLabel.snp.updateConstraints { (make) in
            make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(10))
        }
        if let model = userInfoModel {
            if FKYLoginAPI.loginStatus() == .unlogin {
                userNameLabel.text = "登录更精彩"
                shopNameLabel.text = "登录/注册"
            }else{
                // 用户名称
                if let userName = model.userName,userName.isEmpty == false{
                    userNameLabel.text = "用户名：\(userName)"
                }else{
                    userNameLabel.text = "用户名："
                }
                if let enterpriseName = model.enterpriseName,enterpriseName.isEmpty == false{
                    // 企业名称
                    shopNameLabel.text = enterpriseName
                    let contentSize = (shopNameLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(16))], context: nil).size
                    shopNameLabel.snp.updateConstraints { (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height))
                        make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24))
                    }
                }else{
                    if let userName = model.userName,userName.isEmpty == false{
                        shopNameLabel.text = "用户名：\(userName)"
                    }else{
                        shopNameLabel.text = "用户名："
                    }
                    // 无企业名称
                    if let _ = isNotPerfectInformation,isNotPerfectInformation! == true{
                        //需要完善资料
                        userNameLabel.text = "请完善基本信息"
                    }else{
                         ////待电子审核:0; 审核通过:1; 审核不通过:2 ;变更:3 ; 待纸质审核:4; 变更待电子审核:5; 变更待纸质审核:6 ;变更审 核不通过:7 ;11、12、13、14:资质信息填写一部分;-1 : 资质 未填写(新用户)
                        if let auditStatus = model.enterpriseAuditStatus{
                            if  auditStatus == 0 || auditStatus == 3 || auditStatus == 4 || auditStatus == 5 || auditStatus == 6{
                                userNameLabel.text = "正在审核中"
                            }else if  auditStatus == 2 || auditStatus == 7{
                                userNameLabel.text = "审核未通过请修改资料"
                            }else{
                                userNameLabel.text = ""
                            }
                        }else{
                            userNameLabel.text = ""
                        }
                    }
                }
            }
            
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser() {
                if let nameList = user.nameList,nameList.count > 1 {
                    switchShopView.isHidden = false
                }
            }
            
            if let vipInfo = model.vipInfo,let vipSymbol = vipInfo.vipSymbol{
                if vipSymbol == 0 || vipSymbol == 1{
                    vipInfoBgView.isHidden = false
                    //显示会员
                    vipViewIconBottomLabel.text = "药城会员"
                    if vipSymbol == 0 {
                        //非会员
                        enterVipBtn.text = "了解会员"
                        vipIconImg.isHidden = true
                        vipDescLabel.attributedText = subVipDescString(vipInfo.gmvGap ?? "",vipInfo.tips ?? "")
                    }else if vipSymbol == 1 {
                        //会员
                        vipIconImg.isHidden = false
                        enterVipBtn.text = "会员专区"
                        vipDescLabel.attributedText = subVipDescString(vipInfo.gmvGap ?? "",vipInfo.tips ?? "")
                   }
                }
            }
            
        }
    }
    
    //会员信息富文本
    fileprivate func subVipDescString(_ needNum:String,_ tips:String) -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString(string:tips, attributes: [NSAttributedString.Key.foregroundColor : RGBAColor(0xFFFFFF, alpha: 0.85), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(13))])
        let gmvRange: NSRange? = (attributedStrM.string as NSString).range(of: needNum)
        
        if gmvRange != nil && gmvRange?.location != NSNotFound {
            attributedStrM.addAttributes([NSAttributedString.Key.foregroundColor : RGBAColor(0xFFF3C2, alpha: 1), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(13))], range: gmvRange!)
        }
        return  attributedStrM
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat){
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0, y:0, width: WH(74), height: WH(25))
        maskLayer.lineWidth = 1
        maskLayer.strokeColor = RGBColor(0xE5E5E5).cgColor
        maskLayer.lineCap = CAShapeLayerLineCap.square
        maskLayer.path = maskPath.cgPath
        maskLayer.fillColor = RGBColor(0xffffff).cgColor
        view.layer.addSublayer(maskLayer)
    }
}
extension  AccountUserInfoCell{
    //计算高度
    static func configAccountUserInfoCellH(_ userInfoModel: Any) -> CGFloat{
        let topMargin = SKPhotoBrowser.getScreenTopMargin()
        if let model = userInfoModel as? AccountInfoModel{
            var baseHeight = WH(118)
            var contentSizeHeight  = WH(18)
            if let vipInfo = model.vipInfo,let vipSymbol = vipInfo.vipSymbol{
                if vipSymbol == 0 || vipSymbol == 1{
                    //显示会员
                    baseHeight = WH(180)
                }
            }
            var enterpriseNameStr = ""
            if let enterpriseName = model.enterpriseName,enterpriseName.isEmpty == false{
                // 企业名称
                enterpriseNameStr  = enterpriseName
                contentSizeHeight = enterpriseNameStr.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(16))], context: nil).size.height
            }else{
                if let userName = model.userName,userName.isEmpty == false{
                    enterpriseNameStr  = "用户名：\(userName)"
                }else{
                    enterpriseNameStr  = "用户名："
                }
            }
            return topMargin + baseHeight +  (contentSizeHeight > WH(40) ? WH(40):contentSizeHeight)
        }else if let model = userInfoModel as? FKYUserInfoModel{
            let baseHeight = WH(118)
            var contentSizeHeight  = WH(18)
            var enterpriseNameStr = ""
            if let enterpriseName = model.enterpriseName,enterpriseName.isEmpty == false{
                // 企业名称
                enterpriseNameStr  = enterpriseName
                contentSizeHeight = enterpriseNameStr.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(16) - WH(43) - WH(10) - WH(74) - WH(24), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(16))], context: nil).size.height
            }else{
                if let userName = model.userName,userName.isEmpty == false{
                    enterpriseNameStr  = "用户名：\(userName)"
                }else{
                    enterpriseNameStr  = "用户名："
                }
            }
            return topMargin + baseHeight +  (contentSizeHeight > WH(40) ? WH(40):contentSizeHeight)
        }
        return WH(136)
    }
}
