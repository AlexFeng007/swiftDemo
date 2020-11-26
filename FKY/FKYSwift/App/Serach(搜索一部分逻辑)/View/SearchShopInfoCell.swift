//
//  SearchShopInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class SearchShopInfoCell: UITableViewCell {
    var gotoShopAction: emptyClosure?//进入店铺
    var clickBannerAction: ((Int, HomeCircleBannerItemModel)->())?//点击banner
    var shopInfomodel:SearchShopInfoModel?
    // 轮播视图
    fileprivate lazy var cycleView: SDCycleScrollView = {
        let cycle = SDCycleScrollView ()
        cycle.showPageControl = false
        //        cycle.pageControlDotSize = CGSize(width: 10, height: 2)
        //        cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        //        cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        //        cycle.currentPageDotImage = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 10, height: 2))
        //        cycle.pageDotImage = UIImage.imageWithColor(RGBAColor(0xFFFFFF, alpha: 0.5), size: CGSize.init(width: 10, height: 2))
        cycle.autoScroll = true
        cycle.delegate = self
        cycle.layer.masksToBounds = true
        cycle.layer.cornerRadius =  WH(8)
        return cycle
    }()
    
    fileprivate lazy var pageControl: NewCirclePageControl = {
        let view = NewCirclePageControl.init(frame: CGRect.zero)
        view.pages = 0
        return view
    }()
    //背景视图
    //  头边状态 和渐变
    fileprivate lazy var bgView: UIView = {
        //        let gradientColors: [CGColor] = [RGBAColor(0xFFB088, alpha: 0.22).cgColor,RGBAColor(0xFD61B4, alpha: 0.22).cgColor]
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        //  gradientLayer.colors = gradientColors
//        //渲染的起始位置
//        // gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        //渲染的终止位置
//        // gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.masksToBounds = true
//        //  gradientLayer.borderColor = RGBAColor(0xFF2D5C, alpha: 0.22).cgColor
//        //gradientLayer.borderWidth = 0.5
//        gradientLayer.cornerRadius = WH(8)
//        gradientLayer.backgroundColor = UIColor.white.cgColor
//        gradientLayer.shadowColor = UIColor(red: 0.15, green: 0.18, blue: 0.34, alpha: 0.15).cgColor
//        gradientLayer.shadowOffset = CGSize(width: 0, height: 0)
//        gradientLayer.shadowOpacity = 1
//        gradientLayer.shadowRadius = WH(15)
//        gradientLayer.shouldRasterize = true
//        gradientLayer.rasterizationScale = UIScreen.main.scale
//        gradientLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(10), height: WH(64))
        //设置frame和插入view的layer
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(10), height: WH(55)))
        headView.backgroundColor = UIColor.clear
        //        headView.layer.masksToBounds = true
        //               headView.layer.borderColor = RGBAColor(0xFF2D5C, alpha: 0.22).cgColor
        //               headView.layer.cornerRadius = WH(4)
        //headView.layer.backgroundColor = UIColor.white.cgColor
        //gradientLayer.frame = headView.bounds
      //  headView.layer.insertSublayer(gradientLayer, at: 0)
        //                headView.layer.masksToBounds = true
        //                headView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        //                headView.layer.borderWidth = 1
        //                headView.layer.cornerRadius = WH(4)
        return headView
    }()
    
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CALayer()
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        // bgLayer1.masksToBounds = true
        bgLayer1.cornerRadius = WH(8)
        bgLayer1.shadowColor = UIColor(red: 0.15, green: 0.18, blue: 0.34, alpha: 0.15).cgColor
        bgLayer1.shadowOffset = CGSize(width: 0, height: 0)
        bgLayer1.shadowOpacity = 1
        bgLayer1.shadowRadius = WH(8)
        bgLayer1.shouldRasterize = true
        bgLayer1.rasterizationScale = UIScreen.main.scale

        return bgLayer1
    }()
    //店铺名称
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = t73.font
        label.textColor = t7.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    // 收藏按钮
    fileprivate lazy var shopBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = t33.font
        btn.setTitle("进入店铺", for: .normal)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        //btn.layer.borderWidth = 1
        //btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(13)
        btn.isEnabled = false
        //        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
        //            guard let strongSelf = self else {
        //                return
        //            }
        //            guard let block = strongSelf.gotoShopAction else {
        //                return
        //            }
        //            block()
        //            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //    // loading子视图
    //    fileprivate lazy var loadingItemView: UIActivityIndicatorView = {
    //        let view = UIActivityIndicatorView.init(style: .gray)
    //        view.hidesWhenStopped = true
    //        return view
    //    }()
    lazy var tagsContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    //专区描述字段
    fileprivate var desLabel: UILabel = {
        let label = UILabel()
        //label.isHidden = true
        label.fontTuple = t3
        label.font = t29.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        cycleView.isHidden = true
        self.contentView.addSubview(cycleView)
        cycleView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(10))
            make.right.equalTo(self.contentView.snp.right).offset(WH(-10))
            make.bottom.equalTo(self.contentView.snp.bottom).offset(WH(-9))
            make.height.equalTo((SCREEN_WIDTH - WH(20))*110/355.0)
        })
        
        cycleView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(cycleView).offset(WH(-7.5))
            make.right.equalTo(cycleView).offset(WH(-18))
            make.left.equalTo(cycleView).offset(WH(300))
            make.height.equalTo(WH(4))
        }
        
        shopBtn.isHidden = true
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(5))
            make.right.equalTo(self.contentView.snp.right).offset(WH(-5))
            make.height.equalTo(WH(55))
            make.top.equalTo(self.contentView.snp.top)
            
        })
       // bgView.layer.addSublayer(contentLayer)
       // contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(10), height: WH(64))
        bgView.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.gotoShopAction else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        bgView.addGestureRecognizer(tapGestureMsg)
        
        bgView.addSubview(tagsContentView)
        tagsContentView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(9))
            make.top.equalTo(bgView.snp.top).offset(WH(12))
            //make.top.equalTo(titleLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(64))
        }
        
        bgView.addSubview(shopBtn)
        shopBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView.snp.right).offset(-WH(12))
            make.centerY.equalTo(bgView.snp.centerY)
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(tagsContentView.snp.right).offset(WH(5))
            make.centerY.equalTo(tagsContentView.snp.centerY)
            make.height.equalTo(WH(15))
            make.right.equalTo(shopBtn.snp.left).offset(WH(-5))
        })
        
        bgView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            //make.centerY.equalTo(tagsContentView.snp.centerY)
            make.top.equalTo(tagsContentView.snp.bottom).offset(WH(8))
            make.left.equalTo(tagsContentView.snp.left)
        }
    }
    
}
extension SearchShopInfoCell {
    //店铺首页section的头视图
    func configShopMainHeadViewData(_ baseModel : SearchShopInfoModel?){
        // self.loadingItemView.stopAnimating()
        self.bgView.isHidden = true
        pageControl.isHidden = true
        if let model = baseModel {
            self.shopInfomodel = model
            if let shopBanner = model.shopAdList,shopBanner.banners != nil,shopBanner.banners?.isEmpty == false{
                //有banner
                if let ban = shopBanner.banners {
                    
                    self.cycleView.imageURLStringsGroup = ban.map({$0.imgPath!})
                    self.cycleView.isHidden = false
                }else{
                    self.cycleView.imageURLStringsGroup = []
                    self.cycleView.isHidden = true
                }
                self.contentView.sendSubviewToBack(self.cycleView)
                let bannerWidth = WH(17) * 2 + WH(4 + 5) * CGFloat(shopBanner.banners!.count - 1)
                pageControl.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(cycleView).offset(WH(-7.5))
                    make.right.equalTo(cycleView).offset(WH(-18))
                    make.left.equalTo(cycleView).offset(SCREEN_WIDTH - WH(10) - bannerWidth)
                    make.height.equalTo(WH(4))
                }
                pageControl.isHidden = false
                pageControl.pages = shopBanner.banners!.count
                pageControl.setPageDotsView()
                // self.bringSubviewToFront(bgView)
            }else{
                //无banner
                self.cycleView.isHidden = true
                self.cycleView.imageURLStringsGroup = []
            }
            //自营店铺信息
            self.bgView.isHidden = false
            shopBtn.isHidden = false
            desLabel.isHidden = false
            titleLabel.text = model.enterpriseName ?? ""
            var desStr = ""
            if model.sendThreshold != nil{
                desStr = "\(model.sendThreshold ?? "")元起送"
            }
            
            if model.freeShippingThreshold != nil {
                desStr = desStr  + " \(model.freeShippingThreshold ?? "")元包邮"
            }
            desLabel.text = desStr
            //动态添加tag
            _ = tagsContentView.subviews.map {
                $0.removeFromSuperview()
            }
            
            var tips = [String]()
            var tagImgView: UIImageView? = nil
            
            if let isZY = model.isSelfShop, isZY == 1 {
                if let houseName = model.storeName, houseName.isEmpty == false {
                    if let image = FKYSelfTagManager.shareInstance.tagNameImageForSearch(tagName: houseName, colorType: .red,font:UIFont.boldSystemFont(ofSize: WH(10))) {
                        tagImgView = UIImageView(image: image)
                        tagsContentView.addSubview(tagImgView!)
                        tagImgView!.snp.makeConstraints { (make) in
                            make.centerY.equalTo(tagsContentView)
                            make.left.equalTo(tagsContentView)
                        }
                    }else {
                        tips.append("自营")
                    }
                }else {
                    tips.append("自营")
                }
            }
            var lastTipLabel: UILabel?
            for (index, tip) in tips.enumerated() {
                let width = tip.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t28.font], context: nil).size.width + WH(12)
                
                let label = configLabelTip(tip)
                if let isZY = model.isSelfShop, isZY == 1, index == 0, tagImgView == nil {
                    label.backgroundColor = t73.color
                    label.textColor = t1.color
                } else {
                    label.textColor = t73.color
                }
                tagsContentView.addSubview(label)
                label.snp.makeConstraints { (make) in
                    make.centerY.equalTo(tagsContentView)
                    make.height.equalTo(WH(16))
                    make.width.equalTo(width)
                    if lastTipLabel != nil {
                        make.left.equalTo(lastTipLabel!.snp.right).offset(WH(5))
                    }else {
                        if tagImgView != nil {
                            make.left.equalTo(tagImgView!.snp.right).offset(WH(5))
                        }else {
                            make.left.equalTo(tagsContentView)
                        }
                        
                    }
                }
                
                lastTipLabel = label
            }
            
        }
    }
    
    //创建tag label
    func configLabelTip(_ tip: String) -> UILabel {
        let label = UILabel()
        label.text = tip
        label.font = t28.font
        label.layer.borderColor = t73.color.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        return label
    }
    static func  getCellContentHeight(_ baseModel : SearchShopInfoModel?) -> CGFloat{
        if let model = baseModel {
            if let shopBanner = model.shopAdList,shopBanner.banners != nil,shopBanner.banners?.isEmpty == false{
                //有banner
                return (SCREEN_WIDTH - WH(20))*110/355.0 + WH(9) + WH(55)
            }
        }
        return WH(60)
    }
    
}
extension SearchShopInfoCell : SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        pageControl.setCurrectPage(index)
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let shopBanner = shopInfomodel!.shopAdList,shopBanner.banners != nil,shopBanner.banners?.isEmpty == false{
            //有banner
            let bannerModel = shopBanner.banners![index] as HomeCircleBannerItemModel
            if let app = UIApplication.shared.delegate as? AppDelegate {
                if let url =  bannerModel.jumpInfo, url.isEmpty == false {
                    if let block = clickBannerAction {
                        block(index + 1, bannerModel)
                    }
                    app.p_openPriveteSchemeString(url)
                }
            }
        }
    }
}
