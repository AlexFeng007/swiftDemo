//
//  LiveIntroProductInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播推荐商品

import UIKit

class LiveIntroProductInfoView: UIView {
    var timer:Timer!
    //背景
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var dirImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = UIImage(named: "live_currect_pro_dir")
        view.contentMode = .scaleToFill
        return view
    }()
    
    // 商品图片
    fileprivate lazy var productImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    //讲解中标签
    fileprivate lazy var iconView: UIView = {
        let view = UIView()
        view.backgroundColor =  RGBColor(0xF2EBFF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        
        let iconview = UIImageView()
        iconview.backgroundColor = UIColor.clear
        iconview.image = UIImage(named: "live_product_intro_icon")
        iconview.contentMode = .scaleToFill
        view.addSubview(iconview)
        iconview.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(WH(16))
            make.height.equalTo(WH(16))
        }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0x8D56EF)
        label.backgroundColor = .clear
        label.text = "主播力荐商品，正在讲解中"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view).offset(WH(-5))
        }
        
        return view
    }()
    //商品名
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x0E0E0E)
        label.backgroundColor = .clear
        return label
    }()
    
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var shopView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(12)
        return view
    }()
    
    fileprivate lazy var shopIcon: UILabel = {
        let btn = UILabel()
        btn.text = "立即抢购"
        btn.textColor = RGBColor(0xffffff)
        btn.font = t27.font
        btn.textAlignment = .right
        btn.backgroundColor = .clear
        return btn
    }()
    
    fileprivate lazy var shopDirImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "live_product_intro_dir_icon")
        return iv
    }()
    
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 1, green: 0.35, blue: 0.61, alpha: 1).cgColor, UIColor(red: 1, green: 0.18, blue: 0.36, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0.05, y: 0.23)
        bgLayer1.endPoint = CGPoint(x: 0.78, y: 0.78)
        return bgLayer1
    }()
    
    // 光图片
    fileprivate lazy var lightImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "live_product_shine_icon")
        return iv
    }()
    //    // 不可购买提示
    //    fileprivate lazy var statesDescLbl: UILabel = {
    //        let lbl = UILabel()
    //        lbl.backgroundColor = .clear
    //        lbl.font = UIFont.systemFont(ofSize: WH(14))
    //        lbl.textColor = RGBColor(0xFF2D5C)
    //        lbl.textAlignment = .left
    //        lbl.numberOfLines = 1
    //        lbl.adjustsFontSizeToFitWidth = true
    //        lbl.minimumScaleFactor = 0.6
    //        return lbl
    //    }()
    //
    //    // 不可购买提示(经营范围)
    //    fileprivate lazy var nobuyReasonLbl: UILabel = {
    //        let lbl = UILabel()
    //        lbl.backgroundColor = .clear
    //        lbl.font = UIFont.systemFont(ofSize: WH(11))
    //        lbl.textColor = RGBColor(0x999999)
    //        lbl.numberOfLines = 1
    //        lbl.textAlignment = .left
    //        lbl.adjustsFontSizeToFitWidth = true
    //        lbl.minimumScaleFactor = 0.6
    //        return lbl
    //    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("LiveIntroProductInfoView deinit~!@")
        self.killNSTimer()
    }
    func setupView() {
        self.addSubview(bgView)
        self.addSubview(dirImageView)
        bgView.addSubview(productImageView)
        bgView.addSubview(iconView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(priceLabel)
        bgView.addSubview(shopView)
        
        shopView.layer.addSublayer(contentLayer)
        
        shopView.addSubview(shopIcon)
        shopView.addSubview(lightImageView)
        shopView.addSubview(shopDirImageView)
        shopView.frame =  CGRect.init(x: SCREEN_WIDTH - WH(86.7 + 6 + 12 + 69 + 7) , y: WH(49), width: WH(69), height:WH(24))
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: WH(69), height:WH(24))
        shopIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(shopView)
            make.left.equalTo(shopView).offset(WH(6))
        }
        shopDirImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(shopView)
            make.right.equalTo(shopView).offset(WH(-5))
            make.height.equalTo(WH(10))
            make.width.equalTo(WH(10))
        }
        lightImageView.frame = CGRect.init(x: WH(-18), y: 0, width: WH(18), height:WH(24))
        
        
        // self.shineAnimation(shineView: lightImageView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(WH(-6))
        }
        dirImageView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(6))
            make.width.equalTo(WH(12))
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(WH(18))
        }
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(WH(8))
            make.left.equalTo(bgView).offset(WH(6))
            make.height.equalTo(WH(65))
            make.width.equalTo(WH(65))
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(WH(8))
            make.left.equalTo(productImageView.snp.right).offset(WH(8))
            make.width.equalTo(WH(144))
            make.height.equalTo(WH(16))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(WH(5))
            make.left.equalTo(productImageView.snp.right).offset(WH(6))
            make.right.equalTo(bgView).offset(WH(-20))
            make.height.equalTo(WH(14))
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(14))
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(bgView).offset(WH(-85))
            make.height.equalTo(WH(16))
        }
        
        //        self.nobuyReasonLbl.snp.makeConstraints { (make) in
        //            make.top.equalTo(titleLabel.snp.bottom).offset(WH(12))
        //             make.left.equalTo(titleLabel.snp.left) 43 14 16  73 87
        //            make.right.equalTo(bgView).offset(WH(-85))
        //            make.height.equalTo(WH(19))
        //        }
        //
        //        statesDescLbl.snp.makeConstraints { (make) in
        //            make.top.equalTo(titleLabel.snp.bottom).offset(WH(12))
        //            make.left.equalTo(titleLabel.snp.left)
        //            make.right.equalTo(bgView).offset(WH(-85))
        //            make.height.equalTo(WH(19))
        //        }
        
        
    }
    //直播回放
    func configView(_ productInfo:HomeCommonProductModel?) {
        if let productModel = productInfo{
            self.isHidden = false
            self.startNSTimer()
            if let strProductPicUrl = productModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.productImageView.image = UIImage.init(named: "image_default_img")
            }
            self.titleLabel.text = String(format: "%@", productModel.productFullName ?? "")
            
            self.priceLabel.isHidden = true
            if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
                if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0 &&
                        productModel.liveStreamingFlag == 1) {
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥%.2f", (productModel.promotionPrice ?? 0))
                }
            }
        }else{
            self.killNSTimer()
            self.isHidden = true
        }
    }
    //单个视频详情
    func configVideoDetailView(_ productInfo:HomeCommonProductModel?) {
        if let productModel = productInfo{
            self.isHidden = false
            shopView.isHidden = true
            iconView.isHidden = true
            self.killNSTimer()
            
            titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(bgView).offset(WH(12))
                make.left.equalTo(productImageView.snp.right).offset(WH(6))
                make.right.equalTo(bgView).offset(WH(-20))
                make.height.equalTo(WH(14))
            }
            priceLabel.snp.updateConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(WH(14))
            }
            productImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(bgView).offset(WH(7))
                make.left.equalTo(bgView).offset(WH(6))
                make.height.equalTo(WH(54))
                make.width.equalTo(WH(54))
            }
            if let strProductPicUrl = productModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.productImageView.image = UIImage.init(named: "image_default_img")
            }
            self.titleLabel.text = String(format: "%@", productModel.productFullName ?? "")
            self.priceLabel.isHidden = true
            if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
                if(productModel.price != nil && productModel.price != 0.0){
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥%.2f", productModel.price!)
                }
                if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0) {
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥%.2f", (productModel.promotionPrice ?? 0))
                }
            }
        }else{
            self.killNSTimer()
            self.isHidden = true
        }
    }
    //光束华滑动的动画
    @objc func shineAnimation(){
        let basicAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        basicAnimation.duration = 0.8
        // basicAnimation.beginTime = CACurrentMediaTime() + 2
        //        basicAnimation.timeOffset = 2//CACurrentMediaTime() + 2
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fromValue = WH(-18)
        basicAnimation.toValue = WH(69 + 18)
        basicAnimation.autoreverses = false
        basicAnimation.fillMode = CAMediaTimingFillMode.removed
        basicAnimation.repeatCount = 1//Float(CGFloat.greatestFiniteMagnitude)
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        lightImageView.layer.add(basicAnimation, forKey: "Asong")
    }
    // 实例化方法
    func createNSTimer()
    {
        // weak var weakSelf = self
        weak var weakSelf = self
        if #available(iOS 10.0, *) {
            self.timer = Timer(timeInterval: 2.4, repeats: true, block: {(timer) in
                weakSelf!.shineAnimation()
            })
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 2.4, target: self, selector: #selector(shineAnimation), userInfo: nil, repeats: true);
        }
        self.stopNSTimer()
    }
    // 开始计数
    func startNSTimer()
    {
        if self.timer == nil
        {
            self.createNSTimer()
        }
        self.timer.fireDate = NSDate.distantPast
    }
    // 停止计数
    func stopNSTimer()
    {
        if (self.timer != nil){
            self.timer.fireDate = NSDate.distantFuture
        }
        
    }
    // 注释释放
    func killNSTimer()
    {
        if (self.timer != nil)
        {
            if self.timer.isValid
            {
                self.timer.invalidate();
                self.timer = nil;
            }
        }
        
    }
    
}

