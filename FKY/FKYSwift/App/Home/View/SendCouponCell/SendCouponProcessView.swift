//
//  SendCouponProcessView.swift
//  FKY
//
//  Created by 寒山 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class SendCouponProcessView: UICollectionReusableView {
    @objc var checkRuleCkick: emptyClosure?//查看活动规则
    //大背景
    fileprivate lazy var backGroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFF2E7)
        return view
    }()
    
    //最上面的渐变图案
    fileprivate lazy var topBgView: UIView! = {
        let gradientColors: [CGColor] = [RGBColor(0xFF5B26).cgColor, RGBColor(0xFF4921).cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(260)))
        // view.backgroundColor = RGBColor(0xC70500)
        //view.backgroundColor = UIColor.clear
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    //撒花图片
    fileprivate lazy var successImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "coupon_success_top_icon"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    //活动描述
    fileprivate var promotionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(20))
        label.textAlignment = .center
        label.textColor = RGBColor(0xFAFDE0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    //参与时间
    fileprivate var promotiontTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.textAlignment = .center
        label.textColor = RGBColor(0xFAFDE0)
        return label
    }()
    
    //获奖文描
    fileprivate var successDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .center
        label.textColor = RGBColor(0xFAFDE0)
        return label
    }()
    
    //优惠券图片
    fileprivate lazy var couponImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "coupon_nohad_icon"))
        return imageView
    }()
    //完成进度背景
    fileprivate lazy var processsView: UIView! = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //已完成的背景图
    fileprivate lazy var complentView: UIView! = {
//        let gradientColors: [CGColor] = [RGBColor(0xFFF2E7).cgColor, RGBColor(0xFF6E2C).cgColor]
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        //渲染的起始位置
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        //渲染的终止位置
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(94), height: WH(8)))
//        gradientLayer.frame = view.bounds
//        view.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundColor = RGBColor(0xFFF2E7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    fileprivate lazy var unComplentView: UIView! = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xFFF2E7).cgColor
        return view
    }()
    fileprivate lazy var processDescView: UIView! = {
       let bgLayer1 = CALayer()
        bgLayer1.backgroundColor = RGBColor(0xFFF2E7).cgColor
       // bgLayer1.masksToBounds = true
       bgLayer1.cornerRadius = WH(10)
       bgLayer1.shadowColor = UIColor(red: 0.89, green: 0.21, blue: 0.06, alpha: 0.57).cgColor
       bgLayer1.shadowOffset = CGSize(width: 0, height: 4)
       bgLayer1.shadowOpacity = 1
       bgLayer1.shadowRadius = 1
       bgLayer1.shouldRasterize = true
       bgLayer1.rasterizationScale = UIScreen.main.scale
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: WH(42), height: WH(20)))
        bgLayer1.frame = view.bounds
        view.layer.insertSublayer(bgLayer1, at: 0)
        view.backgroundColor = .clear
        //view.layer.masksToBounds = true
//        view.layer.cornerRadius = WH(10)
//        view.layer.shadowColor = UIColor(red: 0.89, green: 0.21, blue: 0.06, alpha: 0.57).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowRadius = 1
        return view
    }()
    //进度描述
    fileprivate var processLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.textColor = RGBColor(0xF83232)
        return label
    }()
    
    //标签（平台券or商家券）
    fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        label.textAlignment = .center
        label.layer.borderWidth = WH(0.5)
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    //使用条件描述
    fileprivate var conditionsDesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0x666666)
        return label
    }()
    //使用日期
    fileprivate var dateLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0x999999)
        return label
    }()
    //金额
    fileprivate var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(28))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    
    fileprivate lazy var hotSellView: UIView! = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var leftSmallView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF73131)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2.5)
        return view
    }()
    fileprivate lazy var leftBigView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF73131)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    fileprivate lazy var rightSmallView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF73131)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2.5)
        return view
    }()
    fileprivate lazy var rightBigView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF73131)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    fileprivate var hotSellTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textColor = RGBColor(0xF73131)
        label.text = "热卖商品"
        return label
    }()
    //查看规则饿
    fileprivate lazy var checkRuleView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFF2E7)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.checkRuleCkick{
                block()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    fileprivate var checkRulLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xF73131)
        label.text = "活动规则"
        return label
    }()
    
    fileprivate lazy var ruleDirImageView: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "coupon_send_icon"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addSubview(topBgView)
        topBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(WH(260))
        }
        topBgView.addSubview(successImageView)
        successImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo((83*SCREEN_WIDTH)/375)
        }
        
        //375 × 83
        topBgView.addSubview(promotionTitleLabel)
        promotionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBgView.snp.top).offset(WH(36))
            make.centerX.equalTo(topBgView.snp.centerX)
            make.left.equalTo(topBgView).offset(WH(20))
        }
        
        topBgView.addSubview(promotiontTimeLabel)
        promotiontTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(promotionTitleLabel.snp.bottom).offset(WH(10))
            make.centerX.equalTo(topBgView.snp.centerX)
            make.height.equalTo(WH(13))
        }
        
        topBgView.addSubview(couponImageView)
        couponImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topBgView).offset(WH(103))
            make.centerX.equalTo(topBgView.snp.centerX)
            make.width.equalTo(WH(210))
            make.height.equalTo(WH(80))
        }
        
        topBgView.addSubview(successDescLabel)
        successDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(couponImageView.snp.bottom).offset(WH(14))
            make.centerX.equalTo(topBgView.snp.centerX)
            make.height.equalTo(WH(13))
        }
        topBgView.addSubview(processsView)
        processsView.snp.makeConstraints { (make) in
            make.top.equalTo(successDescLabel.snp.bottom).offset(WH(10))
            make.centerX.equalTo(topBgView.snp.centerX)
            make.height.equalTo(WH(8))
            make.width.equalTo(SCREEN_WIDTH - WH(94))
        }
        
        topBgView.addSubview(processDescView)
        processDescView.snp.makeConstraints { (make) in
            make.left.equalTo(processsView.snp.left)
            make.centerY.equalTo(processsView.snp.centerY)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(42))
            
        }
        processsView.addSubview(complentView)
        complentView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(processsView)
            make.right.equalTo(processDescView.snp.left).offset(WH(4))
        }
        
        processsView.addSubview(unComplentView)
        unComplentView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(processsView)
            make.left.equalTo(processDescView.snp.right).offset(WH(-4))
        }
        
        processDescView.addSubview(processLabel)
        processLabel.snp.makeConstraints { (make) in
            make.center.equalTo(processDescView)
        }
        
        couponImageView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(couponImageView.snp.top).offset(WH(11))
            make.left.equalTo(couponImageView.snp.left).offset(WH(21))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(35))
        }
        
        couponImageView.addSubview(conditionsDesLabel)
        conditionsDesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(18))
            make.left.equalTo(tagLabel.snp.left)
            make.width.lessThanOrEqualTo(WH(92))
        }
        
        couponImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsDesLabel.snp.bottom).offset(WH(3))
            make.left.equalTo(conditionsDesLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.equalTo(couponImageView)
        }
        couponImageView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(couponImageView)
            make.right.equalTo(couponImageView.snp.right).offset(-WH(23))
            make.width.lessThanOrEqualTo(WH(65))
        }
        
        backGroundView.addSubview(hotSellView)
        hotSellView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(WH(46))
        }
        hotSellView.addSubview(hotSellTitleLabel)
        hotSellView.addSubview(leftSmallView)
        hotSellView.addSubview(leftBigView)
        hotSellView.addSubview(rightSmallView)
        hotSellView.addSubview(rightBigView)
        hotSellTitleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(hotSellView)
        }
        leftBigView.snp.makeConstraints { (make) in
            make.right.equalTo(hotSellTitleLabel.snp.left).offset(-WH(16))
            make.centerY.equalTo(hotSellView)
            make.width.height.equalTo(WH(8))
        }
        leftSmallView.snp.makeConstraints { (make) in
            make.right.equalTo(leftBigView.snp.left).offset(-WH(13))
            make.centerY.equalTo(hotSellView)
            make.width.height.equalTo(WH(5))
        }
        rightBigView.snp.makeConstraints { (make) in
            make.left.equalTo(hotSellTitleLabel.snp.right).offset(WH(16))
            make.centerY.equalTo(hotSellView)
            make.width.height.equalTo(WH(8))
        }
        rightSmallView.snp.makeConstraints { (make) in
            make.left.equalTo(rightBigView.snp.right).offset(WH(13))
            make.centerY.equalTo(hotSellView)
            make.width.height.equalTo(WH(5))
        }
        
        topBgView.addSubview(checkRuleView)
        checkRuleView.frame = CGRect.init(x: SCREEN_WIDTH - WH(77), y: 7, width: WH(77), height: WH(28))
        //        checkRuleView.snp.makeConstraints { (make) in
        //            make.top.equalTo(topBgView).offset(WH(7))
        //            make.right.equalTo(topBgView)
        //            make.width.equalTo(WH(77))
        //            make.height.equalTo(WH(28))
        //        }
        checkRuleView.addSubview(ruleDirImageView)
        checkRuleView.addSubview(checkRulLabel)
        
        checkRulLabel.snp.makeConstraints { (make) in
            make.left.equalTo(checkRuleView).offset(WH(9))
            make.centerY.equalTo(checkRuleView)
        }
        
        ruleDirImageView.snp.makeConstraints { (make) in
            make.left.equalTo(checkRulLabel.snp.right).offset(WH(4))
            make.centerY.equalTo(checkRuleView)
            make.width.equalTo(8)
            make.height.equalTo(12)
        }
        setMutiBorderRoundingCorners(self.checkRuleView, corner: WH(14))
        couponImageView.isHidden = true
        checkRuleView.isHidden = true
        processsView.isHidden = true
        processDescView.isHidden = true
        hotSellTitleLabel.isHidden = true
        leftSmallView.isHidden = true
        leftBigView.isHidden = true
        rightSmallView.isHidden = true
        rightBigView.isHidden = true
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat)
        
    {
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    func configSectionItemCell(_ model:SendCouponInfoMoel?,_ showTitle:Bool) {
        if let infoModel = model{
            if showTitle == true{
                hotSellTitleLabel.isHidden = false
                leftSmallView.isHidden = false
                leftBigView.isHidden = false
                rightSmallView.isHidden = false
                rightBigView.isHidden = false
            }else{
                hotSellTitleLabel.isHidden = true
                leftSmallView.isHidden = true
                leftBigView.isHidden = true
                rightSmallView.isHidden = true
                rightBigView.isHidden = true
            }
            couponImageView.isHidden = false
            processsView.isHidden = false
            processDescView.isHidden = false
            if let ruleList = infoModel.ruleList,ruleList.isEmpty == false{
                checkRuleView.isHidden = false
            }else{
                checkRuleView.isHidden = true
            }
            promotionTitleLabel.text = infoModel.headText ?? ""
            let takeTime = "参与时间：\((infoModel.begin_time ?? "").removeHHMMSS() )-\((infoModel.end_time ?? "").removeHHMMSS())"
            let timeMutableStr = NSMutableAttributedString.init(string: takeTime)
            timeMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(13))], range: NSMakeRange(0, 5))
            promotiontTimeLabel.attributedText = timeMutableStr
            
            successDescLabel.text = infoModel.footText ?? ""
            
            //设置进度条内容和长度
            processLabel.text = "\((infoModel.view_count ?? 0) - (infoModel.surplus_view_count ?? 0))/\(infoModel.view_count ?? 0)"
            let denominator = ((infoModel.view_count ?? 0) != 0) ? (infoModel.view_count ?? 1):1
            let processsNum = CGFloat((infoModel.view_count ?? 0) - (infoModel.surplus_view_count ?? 0))/CGFloat(denominator)
            //  let complentDistance = (SCREEN_WIDTH - WH(94))*processsNum
            let distance = (SCREEN_WIDTH - WH(94) - WH(42))*processsNum
            //            if  distance != 0 &&  (complentDistance - distance)  < WH(4){
            //                distance =  complentDistance - WH(4)
            //            }
            //            complentView.snp.updateConstraints { (make) in
            //                make.width.equalTo(complentDistance)
            //            }
            processDescView.snp.updateConstraints { (make) in
                make.left.equalTo(processsView.snp.left).offset(distance)
            }
            if let hasSendCouponStatus = infoModel.hasSendCouponStatus,hasSendCouponStatus == true{
                couponImageView.image = UIImage(named: "coupon_had_icon")
            }else{
                couponImageView.image = UIImage(named: "coupon_nohad_icon")
            }
            if let couponsModel = infoModel.couponTemplate{
                if let limitprice = couponsModel.limitprice {
                    conditionsDesLabel.text = String.init(format: "满%d可用",limitprice)
                }else {
                    conditionsDesLabel.text = ""
                }
                dateLabel.text = ""
                if let endStr =  couponsModel.endDate,endStr.count > 0{
                    let endDate = PDViewSendCouponView.stringToDate(endStr,dateFormat:"yyyy-MM-dd")
                    let contentEndDate = PDViewSendCouponView.dateToString(endDate,dateFormat:"MM.dd")
                    if let startStr = couponsModel.begindate,startStr.count > 0 ,contentEndDate.count > 0 {
                        dateLabel.text = "\(startStr)-\(contentEndDate)"
                    }
                }else if let effectiveType =  couponsModel.effectiveType,effectiveType == 1{
                    if let effectiveDays = couponsModel.effectiveDays ,effectiveDays > 0 {
                        dateLabel.text =  "领取后\(effectiveDays)天内有效"
                    }
                }
                
                if let denomination = couponsModel.denomination  {
                    moneyLabel.text = String.init(format: "¥%d",denomination)
                    moneyLabel.adjustPriceLabelWihtFont(t27.font)
                }else {
                    moneyLabel.text = ""
                }
                if let type = couponsModel.tempType ,type==1 {
                    tagLabel.text = "平台券"
                }else{
                    tagLabel.text = "店铺券"
                }
            }
        }
    }
}
