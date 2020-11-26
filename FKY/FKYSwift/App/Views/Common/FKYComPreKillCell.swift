//
//  FKYComPreKillCell.swift
//  FKY
//
//  Created by yyc on 2020/4/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYComPreKillCell: UITableViewCell {
    fileprivate var callback: ShopListCellActionCallback?
    var addUpdateProductNum: emptyClosure?//更新加车
    var loginClosure: emptyClosure?//登录
    var productState: Int?//当前商品状态
    var refreshDataWithTimeOut : ((_ typeTimer: Int)->())? //倒计时结束刷新
    @objc var clickJBPContentArea: emptyClosure?//进入聚宝盆商家专区
    @objc var clickShopContentArea: emptyClosure?//进入店铺详情
    var productArriveNotice: emptyClosure?//到货通知
    @objc var touchItem: emptyClosure?//进入商详
    
    //到家时
    fileprivate lazy var timeView: ProductInfoTimeView = {
        let view = ProductInfoTimeView()
        view.backgroundColor = RGBColor(0xffffff)
        view.refreshDataWithTimeOut  = { [weak self] typeTimer in
            if let strongSelf = self {
                if let block = strongSelf.refreshDataWithTimeOut {
                    block(typeTimer)
                }
            }
        }
        
        return view
    }()
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.touchItem {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CALayer()
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        // bgLayer1.masksToBounds = true
        bgLayer1.cornerRadius = WH(4)
        bgLayer1.shadowColor = UIColor(red: 0.15, green: 0.18, blue: 0.34, alpha: 0).cgColor
        bgLayer1.shadowOffset = CGSize(width: 0, height: 0)
        bgLayer1.shadowOpacity = 1
        bgLayer1.shadowRadius = WH(15)
        bgLayer1.shouldRasterize = true
        bgLayer1.rasterizationScale = UIScreen.main.scale
        return bgLayer1
    }()
    
    // 商品图片
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    // 抢光图片
    fileprivate lazy var soldOutImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "sold_out_icon")
        return iv
    }()
    
    //商品基本信息
    fileprivate lazy var baseInfoView: ProductBaseInfoView = {
        let view = ProductBaseInfoView()
        return view
    }()
    //商品促销信息
    fileprivate lazy var promationInfoView: ProductPromationInfoView = {
        let view = ProductPromationInfoView()
        return view
    }()
    // 供应商
    fileprivate lazy var verderInfoView: ProductVendorInfoView = {
        let view = ProductVendorInfoView()
        view.clickJBPContentAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickJBPContentArea {
                closure()
            }
        }
        view.clickShopDeatilAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickShopContentArea {
                closure()
            }
        }
        
        return view
    }()
    //商品价格信息
    fileprivate lazy var priceInfoView: ProductPriceInfoView = {
        let view = ProductPriceInfoView()
        return view
    }()
    //状态信息
    fileprivate lazy var statusInfoView: ProductStatusInfoView = {
        let view = ProductStatusInfoView()
        view.productArriveNotice = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.statusViewTapAction()
        }
        return view
    }()
    // 加车信息
    fileprivate lazy var cartInfoView: ProductCartInfoView = {
        let view = ProductCartInfoView()
        view.addUpdateCartAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addProductCartAction()
        }
        return view
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        print("FKYComPreKillCell销毁")
        timeView.stopCount()
    }
    // MARK: - UI
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        contentView.addSubview(contentBgView)
        contentBgView.layer.addSublayer(contentLayer)
        contentBgView.addSubview(timeView)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(verderInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(statusInfoView)
        contentBgView.addSubview(cartInfoView)
        contentBgView.addSubview(soldOutImgView)
        contentBgView.addSubview(lineView)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.top.equalTo(contentView).offset(WH(10))
            make.bottom.equalTo(contentView).offset(WH(0))
        })
        
        timeView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView.snp.left).offset(WH(8))
            make.top.equalTo(contentBgView.snp.top).offset(WH(11))
            make.right.equalTo(contentBgView.snp.right).offset(-WH(8))
            make.height.equalTo(WH(0))
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(timeView.snp.bottom).offset(WH(5))
            make.left.equalTo(contentBgView).offset(WH(9))
            make.width.height.equalTo(WH(100))
        })
        
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(imgView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(timeView.snp.bottom).offset(WH(5))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        verderInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(priceInfoView.snp.right)
            make.height.equalTo(WH(0))
        })
        
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.top).offset(WH(-7))
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        statusInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        cartInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-10))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(contentBgView)
        })
    }
    func configCell(_ model:FKYPreferetailModel,nowLocalTime : Int64) {
        //图片
        lineView.isHidden = true
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (FKYComPreKillCell.getCellContentHeight(model,nowLocalTime) - WH(10)))
        soldOutImgView.isHidden = true
        if let strProductPicUrl = model.productPicPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.imgView.image = UIImage.init(named: "image_default_img")
        }
        timeView.resetTimeLabelLayout()
        timeView.configPrefertailTimeCell(model,nowLocalTime: nowLocalTime)
        timeView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductInfoTimeView.getPreferentialContentHeight(model,nowLocalTime))
        })
        baseInfoView.configCell(model)
        baseInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
        })
        promationInfoView.showPromotionIcon(model)
        promationInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
        })
        priceInfoView.configCell(model)
        priceInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
        })
        
        statusInfoView.configCell(model)
        verderInfoView.configCell(model)
        verderInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductVendorInfoView.getContentHeight(model))
        })
        cartInfoView.configPreferetialCell(model)
        
        if let status = model.priceStatus ,status != 0{
            if status == -5 {
                //到货通知
                soldOutImgView.isHidden = false
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(13 + 5 + 90))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(WH(90))
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
            }else{
                let maxW = ProductStatusInfoView.getContentStates(model).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(13)-5-maxW)
                })
                if status == 2{
                    //不可购买 不再经营范围
                    verderInfoView.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                        make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                        make.width.equalTo(maxW)
                    })
                }else{
                    verderInfoView.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                        make.bottom.equalTo(verderInfoView.snp.bottom)
                        make.width.equalTo(maxW)
                    })
                }
            }
            
        }else{
            verderInfoView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            })
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(15 + 85))
            })
            
            cartInfoView.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(85))
                make.height.equalTo(WH(36))
            })
            statusInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                make.width.equalTo(0)
                make.bottom.equalTo(verderInfoView.snp.bottom)
            })
        }
        
        //productState = model.priceStatus ?? 10086 //防止状态空
        //        if model.percentage == 100 {
        //            soldOutImgView.isHidden = false
        //        }
        
        self.layoutIfNeeded()
    }
    //商品加车
    func addProductCartAction(){
        if FKYLoginAPI.loginStatus() != .unlogin{
            if let closure = self.addUpdateProductNum {
                closure()
            }
        }else{
            //未登录
            if let closure = self.loginClosure {
                closure()
            }
        }
    }
    //登录或者到货提醒
    func statusViewTapAction(){
        if productState == -1{
            //未登录
            if let closure = self.loginClosure {
                closure()
            }
        }else if productState == -5{
            //到货通知
            if let closure = self.productArriveNotice {
                closure()
            }
        }
    }
    
    //MARK:设置可以点击店铺名称进入店铺详情
    @objc func resetCanClickShopArea(_ product:Any,_ searchType:SearchProductType = .CommonSearch) {
        self.verderInfoView.resetClickShopView(product,searchType)
    }
    //获取行高
    static func  getCellContentHeight(_ product: Any, _ nowLocalTime : Int64) -> CGFloat{
        if let model = product as? FKYPreferetailModel {
            var Cell = WH(10) + WH(11+5) + WH(20)
            Cell = Cell + ProductInfoTimeView.getPreferentialContentHeight(model,nowLocalTime)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = Cell > WH(11+5+100+20+10) ? Cell:WH(11+5+100+20+10)
            return Cell
        }
        if let model = product as? FKYPackageRateModel {
            var Cell = WH(10) + WH(11+5) + WH(20)
            Cell = Cell + ProductInfoTimeView.getPreferentialContentHeight(model,nowLocalTime)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = Cell > WH(11+5+100+20+10) ? Cell:WH(11+5+100+20+10)
            return Cell
        }
        return 0
    }
    
}
//MARK:单品包邮
extension FKYComPreKillCell {
    func configPackageCell(_ model:FKYPackageRateModel,nowLocalTime : Int64,_ isCheck:String?,_ isSelfTag:Bool?) {
        //图片
        lineView.isHidden = true
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (FKYComPreKillCell.getCellContentHeight(model,nowLocalTime) - WH(10)))
        soldOutImgView.isHidden = true
        if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.imgView.image = UIImage.init(named: "image_default_img")
        }
        timeView.resetTimePackageLabelLayout()
        timeView.configPrefertailTimeCell(model,nowLocalTime: nowLocalTime)
        timeView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductInfoTimeView.getPreferentialContentHeight(model,nowLocalTime))
        })
        baseInfoView.configCell(model)
        baseInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
        })
        promationInfoView.showPromotionIcon(model)
        promationInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
        })
        priceInfoView.configCell(model)
        priceInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
        })
        
        statusInfoView.configYQGCell(model,nowLocalTime:nowLocalTime,isCheck)
        verderInfoView.configCell(model)
        verderInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductVendorInfoView.getContentHeight(model))
        })
        cartInfoView.configSinglePackageRateCarView(model,nowLocalTime:nowLocalTime,isCheck,isSelfTag)
        
        if (FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0") {
            //资质未认证
            let maxW = ProductStatusInfoView.getContentYQGStates(model, nowLocalTime: nowLocalTime, isCheck).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(13)-5-maxW)
            })
            verderInfoView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            })
            statusInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                make.bottom.equalTo(verderInfoView.snp.bottom)
                make.width.equalTo(maxW)
            })
        }else{
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(15 + 85))
            })
            verderInfoView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            })
            cartInfoView.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(85))
                make.height.equalTo(WH(36))
            })
            statusInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                make.width.equalTo(0)
                make.bottom.equalTo(verderInfoView.snp.bottom)
            })
        }
        if model.percentage == 100 || model.inventoryLeft == 0 || ((model.inventoryLeft ?? 0) < (model.baseNum ?? 1)) {
            soldOutImgView.isHidden = false
        }else if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) < (model.baseNum ?? 1){
            soldOutImgView.isHidden = false
        }
        self.layoutIfNeeded()
    }
}
