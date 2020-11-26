//
//  ProductCartInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品正常加车信息 包含普品的 加车信息  还有一起购  秒杀的加车信息（未开始 正在抢  已抢完）

import UIKit

class ProductCartInfoView: UIView {
    var type: ShopListSecondKillType = .unknow
    var addUpdateCartAction: emptyClosure?//更新加车
    // 加车按钮
    fileprivate lazy var cartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "new_shop_car_icon"), for: UIControl.State())
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addUpdateCartAction {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //抢购按钮
    var cartBadgeView : JSBadgeView?
    var secondKillBadgeView : JSBadgeView?
    var productModel:Any? //商品模型
    
    // 抢购
    fileprivate lazy var addProductView: UIView = {
        let view = UIView()
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [UIColor(red: 1, green: 0.35, blue: 0.58, alpha: 1).cgColor, UIColor(red: 1, green: 0.18, blue: 0.36, alpha: 1).cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame =  CGRect.init(x: 0, y: 0, width: WH(85), height: WH(36))
        bgLayer.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        view.layer.addSublayer(bgLayer)
        // shadowCode
        view.layer.shadowColor = UIColor(red: 1, green: 0.18, blue: 0.36, alpha: 0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: WH(2))
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = WH(4)
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addUpdateCartAction {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //已抢完 未开始
    fileprivate lazy var endStatueView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    //已售数量比列
    public lazy var percentNumLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = t26.font
        label.textAlignment = .center
        return label
    }()
    //正进行
    public lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = t21 .font
        label.textAlignment = .center
        return label
    }()
    
    //已完成 h未开始
    public lazy var endStatusLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xCCCCCC)
        label.font = t21 .font
        label.textAlignment = .center
        return label
    }()
    
    
    //MARK: 购买套餐按钮
    var clickCombotAction: emptyClosure?//点击套餐按钮
    fileprivate lazy var shopComboBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = bg1
        button.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(14))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(13)
        button.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        button.layer.borderWidth = 1
        button.setTitle("购买套餐", for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickCombotAction {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(self.cartIcon)
        self.addSubview(self.addProductView)
        self.addSubview(self.endStatueView)
        self.addProductView.addSubview(self.percentNumLabel)
        self.addProductView.addSubview(self.statusLabel)
        self.endStatueView.addSubview(self.endStatusLabel)
        self.addSubview(self.shopComboBtn)
        
        self.cartIcon.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalTo(self)
        })
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.cartIcon, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-14), y: WH(15))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            return cbv
        }()
        
        self.addProductView.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalTo(self)
        })
        self.endStatueView.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalTo(self)
        })
        self.percentNumLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.snp.centerY).offset(WH(-2))
            make.centerX.equalTo(self.addProductView)
        })
        self.statusLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.percentNumLabel.snp.bottom)
            make.centerX.equalTo(self.addProductView)
        })
        
        self.endStatusLabel.snp.makeConstraints({ (make) in
            make.center.equalTo(self.endStatueView)
        })
        
        secondKillBadgeView = {
            let cbv = JSBadgeView.init(parentView: self, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-4), y: WH(2))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            cbv?.badgeStrokeColor =  RGBColor(0xFF2D5C)
            cbv?.badgeStrokeWidth =  1
            //cbv?.badgeOverlayColor = RGBColor(0xFF2D5C)
            // cbv?.layer.borderWidth = 1
            return cbv
        }()
        
        shopComboBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(-WH(10))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
    }
    func configCell(_ product: Any) {
        // statusMsg
        self.cartIcon.isHidden = true
        self.shopComboBtn.isHidden = true
        self.addProductView.isHidden = true
        self.endStatueView.isHidden = true
        self.percentNumLabel.isHidden = true
        self.statusLabel.isHidden = true
        self.endStatusLabel.isHidden = true
        self.productModel = product
        self.cartBadgeView?.badgeText = ""
        self.secondKillBadgeView?.badgeText = ""
        self.isHidden = true
        if let model = product as? HomeProductModel {
            if let status = model.statusDesc,status == 0{
                //单品不可购买，显示套餐按钮
                if let num = model.singleCanBuy , num == 1 {
                    self.shopComboBtn.isHidden = false
                }else {
                    self.cartIcon.isHidden = false
                    if model.carOfCount > 0 && model.carId != 0 {
                        self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                    }
                }
                self.isHidden = false
            }
        }
        if let model = product as? ShopProductItemModel  {
            if let status = model.statusDesc,status == 0{
                if let num = model.singleCanBuy , num == 1 {
                    self.shopComboBtn.isHidden = false
                }else {
                    self.cartIcon.isHidden = false
                    if model.carOfCount > 0 && model.carId != 0 {
                        self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                    }
                }
                self.isHidden = false
            }
        }
        if let model = product as? ShopProductCellModel {
            if let status = model.statusDesc,status == 0{
                self.cartIcon.isHidden = false
                self.isHidden = false
                if model.carOfCount > 0 && model.carId != 0 {
                    self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                }
            }
        }
        //MARK:搜索商品无结果显示常够清单
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            if let num = model.singleCanBuy , num == 1 {
                self.shopComboBtn.isHidden = false
            }else {
                self.cartIcon.isHidden = false
                if model.carOfCount > 0 && model.carId != 0 {
                    self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                }
            }
            self.isHidden = false
        }
        //MARK:店铺详情最下面的常够清单使用
        if let model = product as? HomeCommonProductModel {
            if let status = model.statusDesc,status == 0{
                if let num = model.singleCanBuy , num == 1 {
                    self.shopComboBtn.isHidden = false
                }else {
                    self.cartIcon.isHidden = false
                    if model.carOfCount > 0 && model.carId != 0 {
                        self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                    }
                }
                self.isHidden = false
            }
        }
        if let model = product as? FKYFullProductModel{
            if let status = model.statusDesc,status == 0{
                self.cartIcon.isHidden = false
                self.isHidden = false
                if model.carOfCount > 0 && model.carId != 0 {
                    self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                }
            }
        }
        
        if let  model = product as?  ShopListProductItemModel{
            //品种汇推荐
            if let status = model.statusDesc,status == 0{
                self.cartIcon.isHidden = false
                self.isHidden = false
                if model.carOfCount > 0 && model.carId != 0 {
                    self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                }
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            if let status = model.statusDesc {
                if status == -1 || status == -3{
                    return
                }
            }
            self.isHidden = false
            //店铺管秒杀特惠
            var timeInterval: Int64 = 0
            if let sys = model.sysTimeMillis, let up = model.upTimeMillis, let down = model.downTimeMillis {
                if sys < up {
                    type = .willBegin
                    timeInterval = up - sys
                } else if up <= sys, sys < down {
                    type = .shopping
                    timeInterval = down - sys
                } else if sys > down {
                    type = .alreadyEnd
                } else {
                    type = .unknow
                }
            } else {
                type = .unknow
            }
            if model.carOfCount > 0 && model.carId != 0{
                self.secondKillBadgeView?.isHidden = false
                self.secondKillBadgeView?.badgeText = "\(model.carOfCount)"
            }else{
                self.secondKillBadgeView?.isHidden = true
            }
            switch (type) {
            case .unknow:
                self.endStatueView.isHidden = false
                self.endStatusLabel.isHidden = false
                self.endStatusLabel.text = "已抢完"
                self.statusLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.percentNumLabel.snp.bottom)
                    make.centerX.equalTo(self.addProductView)
                })
            case .shopping:
                self.addProductView.isHidden = false
                self.percentNumLabel.isHidden = true
                self.statusLabel.isHidden = false
                self.statusLabel.text = "马上抢"
                self.statusLabel.snp.remakeConstraints({ (make) in
                    make.center.equalTo(self.addProductView)
                })
            //self.percentNumLabel.text = "已售\(model.seckillProgress ?? "")%"
            case .willBegin:
                self.endStatueView.isHidden = false
                self.endStatusLabel.isHidden = false
                self.endStatusLabel.text = "未开始"
                self.statusLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.percentNumLabel.snp.bottom)
                    make.centerX.equalTo(self.addProductView)
                })
                self.secondKillBadgeView?.isHidden = true
            case .alreadyEnd:
                // 已抢完
                self.endStatueView.isHidden = false
                self.endStatusLabel.isHidden = false
                self.endStatusLabel.text = "已抢完"
                self.statusLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.percentNumLabel.snp.bottom)
                    make.centerX.equalTo(self.addProductView)
                })
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            if let status = model.statusDesc,status == 0{
                self.cartIcon.isHidden = false
                self.isHidden = false
                if model.carOfCount > 0 && model.carId != 0 {
                    self.cartBadgeView?.badgeText = "\(model.carOfCount)"
                }
            }
        }
    }
    
    func configSeckillCell(_ product: Any, isStart: Bool) {
        self.cartIcon.isHidden = true
        self.shopComboBtn.isHidden = true
        self.addProductView.isHidden = true
        self.endStatueView.isHidden = true
        self.percentNumLabel.isHidden = true
        self.statusLabel.isHidden = true
        self.endStatusLabel.isHidden = true
        self.isHidden = true
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            if model.carOfCount > 0 && model.carId != 0{
                self.secondKillBadgeView?.isHidden = false
                self.secondKillBadgeView?.badgeText = "\(model.carOfCount)"
            }else{
                self.secondKillBadgeView?.isHidden = true
            }
            self.isHidden = false
            if(model.showPrice == "false"){
                
            }else{
                if !isStart{
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "未开始"
                    self.secondKillBadgeView?.isHidden = true
                    // 活动未开始
                }else{
                    if model.seckillOut! == "false"{
                        self.addProductView.isHidden = false
                        self.percentNumLabel.isHidden = false
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = "马上抢"
                        self.percentNumLabel.text = "已售\(model.seckillProgress ?? "")%"
                    }else{
                        // 已抢完
                        self.endStatueView.isHidden = false
                        self.endStatusLabel.isHidden = false
                        self.endStatusLabel.text = "已抢完"
                    }
                }
            }
            
        }
    }
    //MARK:一起购
    func configYQGCell(_ product: Any,nowLocalTime : Int64,_ isCheck:String?) {
        self.cartIcon.isHidden = true
        self.shopComboBtn.isHidden = true
        self.addProductView.isHidden = true
        self.endStatueView.isHidden = true
        self.percentNumLabel.isHidden = true
        self.statusLabel.isHidden = true
        self.endStatusLabel.isHidden = true
        self.isHidden = true
        if let model = product as? FKYTogeterBuyModel{
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
            }else {
                self.isHidden = false
                //加车数量
                if  model.carOfCount > 0 && model.carId != 0 {
                    self.secondKillBadgeView?.isHidden = false
                    self.secondKillBadgeView?.badgeText = "\(model.carOfCount)"
                    
                }else{
                    self.secondKillBadgeView?.isHidden = true
                }
                //抢购完了
                if model.percentage == 100 {
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "已抢完"
                }else{
                    self.addProductView.isHidden = false
                    self.percentNumLabel.isHidden = false
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "马上抢"
                    self.percentNumLabel.text = "已售\(model.percentage ?? 0)%"
                }
                if  model.surplusNum != nil && model.surplusNum! == 0  {
                    self.addProductView.isHidden = true
                    self.endStatueView.isHidden = true
                    self.percentNumLabel.isHidden = true
                    self.statusLabel.isHidden = true
                    self.endStatusLabel.isHidden = true
                    
                    //                self.addProductBtn.setTitle("已达限购总数", for: .normal)
                }
            }
            //倒计时相关
            if let _ =  model.endTime,let beginInterval = model.beginTime {
                if beginInterval > nowLocalTime {
                    //活动未开始(按钮置灰隐藏进度条及百分比显示)
                    self.addProductView.isHidden = true
                    self.percentNumLabel.isHidden = true
                    self.statusLabel.isHidden = true
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "未开始"
                }
            }
        }
        
    }
    
    //MARK:商家特惠
    func configPreferetialCell(_ product: Any) {
        self.cartIcon.isHidden = true
        self.shopComboBtn.isHidden = true
        self.addProductView.isHidden = true
        self.endStatueView.isHidden = true
        self.percentNumLabel.isHidden = true
        self.statusLabel.isHidden = true
        self.endStatusLabel.isHidden = true
        self.isHidden = true
        if let model = product as? FKYPreferetailModel{
            if let status = model.priceStatus,status == 0{
                self.isHidden = false
                //加车数量
                if  model.carOfCount > 0 && model.carId != 0 {
                    self.secondKillBadgeView?.isHidden = false
                    self.secondKillBadgeView?.badgeText = "\(model.carOfCount)"
                    
                }else{
                    self.secondKillBadgeView?.isHidden = true
                }
                //抢购完了
                if let killOut = model.seckillOut, killOut == "false" {
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "已抢完"
                    self.statusLabel.snp.remakeConstraints({ (make) in
                        make.top.equalTo(self.percentNumLabel.snp.bottom)
                        make.centerX.equalTo(self.addProductView)
                    })
                }else{
                    self.addProductView.isHidden = false
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "马上抢"
                    if let progressNum = model.seckillProgress {
                        self.percentNumLabel.isHidden = false
                        self.percentNumLabel.text = "已售\(progressNum)%"
                        self.statusLabel.snp.remakeConstraints({ (make) in
                            make.top.equalTo(self.percentNumLabel.snp.bottom)
                            make.centerX.equalTo(self.addProductView)
                        })
                    }else {
                        self.statusLabel.snp.remakeConstraints({ (make) in
                            make.center.equalTo(self.addProductView)
                        })
                    }
                }
            }
        }
    }
    //MARK:单品包邮
    func configSinglePackageRateCarView(_ product: Any,nowLocalTime : Int64, _ isCheck:String?,_ isSelfTag:Bool?) {
        self.cartIcon.isHidden = true
        self.shopComboBtn.isHidden = true
        self.addProductView.isHidden = true
        self.endStatueView.isHidden = true
        self.percentNumLabel.isHidden = true
        self.statusLabel.isHidden = true
        self.endStatusLabel.isHidden = true
        self.isHidden = true
        //只能直接购买
        self.secondKillBadgeView?.isHidden = true
        self.statusLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(self.percentNumLabel.snp.bottom)
            make.centerX.equalTo(self.addProductView)
        })
        if let model = product as? FKYPackageRateModel{
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
            }else {
                self.isHidden = false
                //加车数量
                //            if  model.carOfCount > 0 && model.carId != 0 {
                //                self.secondKillBadgeView?.isHidden = false
                //                self.secondKillBadgeView?.badgeText = "\(model.carOfCount)"
                //            }else{
                //                self.secondKillBadgeView?.isHidden = true
                //            }
                //抢购完了
                if model.percentage == 100 || model.inventoryLeft == 0 || ((model.inventoryLeft ?? 0) < (model.baseNum ?? 1)){
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "已抢完"
                }else if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) < (model.baseNum ?? 1){
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "已抢完"
                }else{
                    self.addProductView.isHidden = false
                    
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "马上抢"
                    if let selfTag = isSelfTag,selfTag == true {
                        self.percentNumLabel.isHidden = false
                        self.percentNumLabel.text = "已售\(model.percentage ?? 0)%"
                    }else{
                        self.percentNumLabel.isHidden = true
                        self.statusLabel.snp.remakeConstraints({ (make) in
                           // make.top.equalTo(self.percentNumLabel.snp.bottom)
                            make.center.equalTo(self.addProductView)
                        })
                    }
                }
                if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) == 0 ,model.percentage != 100 {
                    //已达限购数量
                    self.addProductView.isHidden = true
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "已限购"
                    //                    self.addProductView.isHidden = true
                    //                    self.endStatueView.isHidden = true
                    //                    self.percentNumLabel.isHidden = true
                    //                    self.statusLabel.isHidden = true
                    //                    self.endStatusLabel.isHidden = true
                }
                
            }
            //倒计时相关
            if let _ =  model.endTime,let beginInterval = model.beginTime {
                if beginInterval > nowLocalTime {
                    //活动未开始(按钮置灰隐藏进度条及百分比显示)
                    self.addProductView.isHidden = true
                    self.percentNumLabel.isHidden = true
                    self.statusLabel.isHidden = true
                    self.endStatueView.isHidden = false
                    self.endStatusLabel.isHidden = false
                    self.endStatusLabel.text = "未开始"
                }
            }
        }
    }
}
