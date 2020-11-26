//
//  SearchProductInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
// 商品类型
@objc enum SearchProductInfoType: Int {
    case CommonProduct = 0   // 普通商品
    case TJProduct = 1   // 特价商品
    case MZProduct = 2   // 满折商品
}
// 商品类型
@objc enum SearchProductType: Int {
    case CommonSearch = 0   // 普通搜索
    case JBPSearch = 1   // 聚宝盆搜索
    case ShopSearch = 2   // 店铺内搜索
}
@objc class SearchProductInfoCell: UITableViewCell {
    @objc fileprivate var callback: ShopListCellActionCallback?
    @objc var fullGiftClosure: SingleStringClosure?//满赠信息查看
    @objc var addUpdateProductNum: emptyClosure?//更新加车
    @objc var touchItem: emptyClosure?//进入商详
    @objc var clickJBPContentArea: emptyClosure?//进入聚宝盆商家专区
    @objc var clickShopContentArea: emptyClosure?//进入店铺详情
    @objc var loginClosure: emptyClosure?//登录
    @objc  var productArriveNotice: emptyClosure?//到货通知
    @objc var clickComboBtn: emptyClosure?//点击购买套餐按钮
    var productState: Int?//当前商品状态
    //背景
    @objc fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
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
    // 商品图片
    @objc fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    // 抢光图片
    @objc fileprivate lazy var soldOutImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "sold_out_icon")
        return iv
    }()
    
    //商品基本信息
    @objc fileprivate lazy var baseInfoView: ProductBaseInfoView = {
        let view = ProductBaseInfoView()
        return view
    }()
    //商品促销信息
    @objc fileprivate lazy var promationInfoView: ProductPromationInfoView = {
        let view = ProductPromationInfoView()
        return view
    }()
    //商品价格信息
    @objc fileprivate lazy var priceInfoView: ProductPriceInfoView = {
        let view = ProductPriceInfoView()
        return view
    }()
    //状态信息
    @objc fileprivate lazy var statusInfoView: ProductStatusInfoView = {
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
    @objc fileprivate lazy var cartInfoView: ProductCartInfoView = {
        let view = ProductCartInfoView()
        view.addUpdateCartAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addProductCartAction()
        }
        view.clickCombotAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickComboBtn{
                block()
            }
        }
        return view
    }()
    //    // 供应商
    //    fileprivate lazy var vendorLabel: UILabel = {
    //        let label = UILabel()
    //        label.numberOfLines = 1
    //        label.textColor = RGBColor(0x999999)
    //        label.font = UIFont.systemFont(ofSize: WH(12))
    //        return label
    //    }()
    // 供应商
    @objc fileprivate lazy var verderInfoView: ProductVendorInfoView = {
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
    
    // 满赠信息
    @objc fileprivate lazy var presenterInfoView: ProductPresenterInfoView = {
        let view = ProductPresenterInfoView()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.fullGiftClosure {
                //传出满赠内容，兼容老版本没有满赠商品返回
                closure(strongSelf.presenterInfoView.fullGiftDescL.text!)
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //分割线
    @objc fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    @objc override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - UI
    @objc func setupView() {
        self.backgroundColor = bg1
        contentView.addSubview(contentBgView)
        contentView.addSubview(lineView)
        
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(statusInfoView)
        contentBgView.addSubview(cartInfoView)
        contentBgView.addSubview(verderInfoView)
        contentBgView.addSubview(presenterInfoView)
        contentBgView.addSubview(soldOutImgView)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.right.left.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-1)
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(contentBgView).offset(WH(15))
            make.width.height.equalTo(WH(100))
        })
        
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(imgView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(imgView.snp.top)
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
        
        presenterInfoView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView)
            make.right.equalTo(contentBgView)
            make.bottom.equalTo(contentBgView)
            make.height.equalTo(0)
        })
        
        verderInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(priceInfoView.snp.right)
            make.height.equalTo(WH(12))
        })
        
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.top).offset(WH(-7))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        statusInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        cartInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.top).offset(WH(22))  //10个高度是购物车空白区域 12 个高度是正常供应商的名称高度
            make.right.equalTo(contentBgView).offset(WH(-3 - 9))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(contentView)
        })
        presenterInfoView.isHidden = true
    }
    @objc  func configCell(_ product: Any) {
        presenterInfoView.isHidden = true
        soldOutImgView.isHidden = true
        if let model = product as? HomeProductModel {
            //图片
            if let strProductPicUrl = model.productPicUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
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
            
            cartInfoView.configCell(model)
            
            if let status = model.statusDesc ,status != 0{
                if status == -5{
                    //到货通知
                    soldOutImgView.isHidden = false
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(27))
                        make.width.equalTo(WH(90))
                        make.bottom.equalTo(verderInfoView.snp.bottom)
                    })
                    verderInfoView.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                    })
                }else{
                    let maxW = ProductStatusInfoView.getContentStates(model).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                //单品不可购买，显示套餐按钮
                if let num = model.singleCanBuy , num == 1 {
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.width.equalTo(WH(90))
                        make.height.equalTo(WH(50))
                    })
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                }else {
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 45))
                    })
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.width.height.equalTo(WH(50))
                    })
                }
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                })
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        if let model = product as? HomeCommonProductModel {
            //图片
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            
            
            baseInfoView.configCell(model)
            baseInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductBaseInfoView.getHomeContentHeight(model))
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
            
            cartInfoView.configCell(model)
            
            if let status = model.statusDesc ,status != 0{
                if status == -5{
                    //到货通知
                    soldOutImgView.isHidden = false
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(27))
                        make.width.equalTo(WH(90))
                        make.bottom.equalTo(verderInfoView.snp.bottom)
                    })
                    verderInfoView.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                    })
                }else{
                    let maxW = ProductStatusInfoView.getContentStates(model).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(22 + 45))
                })
                cartInfoView.snp.updateConstraints({ (make) in
                    make.width.height.equalTo(WH(50))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(presenterInfoView.snp.top).offset(WH(-13))
                })
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        self.layoutIfNeeded()
        
    }
    //
    //MARK:设置可以点击店铺名称进入店铺详情
    @objc func resetCanClickShopArea(_ product:Any,_ searchType:SearchProductType = .CommonSearch) {
        self.verderInfoView.resetClickShopView(product,searchType)
    }
    //订单列表专供
    @objc func resetCanClickShopAreaForOrder(_ product:Any) {
        self.verderInfoView.resetClickShopView(product)
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
    //商品加车
    func addProductCartAction(){
        if let closure = self.addUpdateProductNum {
            closure()
        }
    }
    //获取行高
    @objc static func getCellContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? HomeProductModel {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = Cell + WH(20)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        if let model = product as? HomeCommonProductModel {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getHomeContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = Cell + WH(20)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        return 0
    }
}

//钩子搜索商品
@objc class SearchGZProductInfoCell: UITableViewCell {
    var checkPromotionAction: emptyClosure?//到货通知
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFAFB)
        view.layer.cornerRadius = WH(4)
        view.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkPromotionAction {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //钩子商品活动状态
    fileprivate lazy var productTypeView: SearchProductTypeView = {
        let view = SearchProductTypeView()
        return view
    }()
    // 商品图片
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    //排序视图
    fileprivate lazy var rankView : FKYRankingView = {
        let iv = FKYRankingView()
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
    //商品价格信息
    fileprivate lazy var priceInfoView: SearchProductTypePriceView = {
        let view = SearchProductTypePriceView()
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
    // MARK: - UI
    func setupView() {
        self.backgroundColor = bg1
        contentView.addSubview(contentBgView)
        contentView.addSubview(lineView)
        contentBgView.addSubview(productTypeView)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(rankView)
        contentBgView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(contentView).offset(WH(4))
            make.bottom.right.equalTo(contentView).offset(WH(-4))
        })
        
        productTypeView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(5))
            make.left.equalTo(contentBgView).offset(WH(10))
            make.height.equalTo(WH(20))
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(36))
            make.left.equalTo(contentBgView).offset(WH(11))
            make.width.height.equalTo(WH(100))
        })
        rankView.snp.makeConstraints({ (make) in
            make.top.equalTo(imgView.snp.top).offset(WH(4))
            make.left.equalTo(imgView.snp.left).offset(WH(2))
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(47))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(imgView.snp.top)
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-18))
            make.height.equalTo(0)
        })
        
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(contentBgView).offset(WH(-18))
            make.height.equalTo(0)
        })
        
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-12))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView)
            make.height.equalTo(WH(26))
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(self)
        })
        
    }
    
    @objc func configCell(_ product: Any) {
        rankView.isHidden = true
        if let model = product as? HomeProductModel {
            //图片
            if let strProductPicUrl = model.productPicUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            productTypeView.configCell(model)
            baseInfoView.configCell(model)
            baseInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
            })
            
            promationInfoView.showPromotionIcon(model)
            promationInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
            })
            priceInfoView.configCell(model)
            //            if (ProductPromationInfoView.getContentHeight(model)) > 0{
            //                priceInfoView.snp.updateConstraints({ (make) in
            //                    // make.top.equalTo(promationInfoView.snp.bottom).offset(WH(1))
            //                    make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
            //                })
            //            }else{
            //                priceInfoView.snp.updateConstraints({ (make) in
            //                    //make.top.equalTo(promationInfoView.snp.bottom).offset(WH(15))
            //                    make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
            //                })
            //            }
            self.layoutIfNeeded()
        }else if let model = product as?  SearchMpHockProductModel{
            if let strProductPicUrl = model.productPicPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            productTypeView.configCell(model)
            baseInfoView.configCell(model)
            baseInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
            })
            
            promationInfoView.showPromotionIcon(model)
            promationInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
            })
            priceInfoView.configCell(model)
            //            priceInfoView.snp.updateConstraints({ (make) in
            //                make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
            //            })
            self.layoutIfNeeded()
        }else if let model = product as?  ShopProductCellModel{
            rankView.isHidden = false
            self.rankView.configRankingViewData(model.hotRank ?? 0)
            if let strProductPicUrl = model.prdPic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            model.isZiYingFlag = 1
            productTypeView.configCell(model)
            baseInfoView.configCell(model)
            baseInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
            })
            
            promationInfoView.showPromotionIcon(model)
            promationInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
            })
            priceInfoView.configCell(model)
            //            priceInfoView.snp.updateConstraints({ (make) in
            //                // make.top.equalTo(promationInfoView.snp.bottom).offset(WH(1))
            //                make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
            //            })
        }
    }
    //获取行高
    @objc
    static func getCellContentHeight(_ product: Any) -> CGFloat{
        
        if let model = product as? HomeProductModel {
            var Cell = WH(40)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            if (ProductPromationInfoView.getContentHeight(model)) == 0{
                Cell = Cell + WH(14) //无活动的时候增加价格和效期的间距
            }else{
                Cell = Cell + WH(6) //增加距离活动标签的距离
            }
            Cell = Cell + WH(1)
            Cell = Cell + WH(26)
            Cell = Cell + WH(16)
            Cell = (Cell > WH(130 + 25)) ? Cell:WH(130 + 25)
            return Cell
        }
        if let model = product as? SearchMpHockProductModel {
            var Cell = WH(40)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            if (ProductPromationInfoView.getContentHeight(model)) == 0{
                Cell = Cell + WH(14) //无活动的时候增加价格和效期的间距
            }else{
                Cell = Cell + WH(6) //增加距离活动标签的距离
            }
            Cell = Cell + WH(1)
            Cell = Cell + WH(26)
            Cell = Cell + WH(16)
            Cell = (Cell > WH(130 + 25)) ? Cell:WH(130 + 25)
            return Cell
        }
        if let model = product as? ShopProductCellModel{
            var Cell = WH(40)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            if (ProductPromationInfoView.getContentHeight(model)) == 0{
                Cell = Cell + WH(14) //无活动的时候增加价格和效期的间距
            }else{
                Cell = Cell + WH(6) //增加距离活动标签的距离
            }
            Cell = Cell + WH(1)
            Cell = Cell + WH(26)
            Cell = Cell + WH(16)
            Cell = (Cell > WH(130 + 25)) ? Cell:WH(130 + 25)
            return Cell
        }
        return 0
    }
}
