//
//  ProductInfoListCell.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  店铺内全部商品 首页 优惠券可用商品

import UIKit
typealias emptyClosure = ()->()
class ProductInfoListCell: UITableViewCell {
    @objc var addUpdateProductNum: emptyClosure?//更新加车
    @objc var touchItem: emptyClosure?//进入商详
    @objc var loginClosure: emptyClosure?//登录
    @objc var clickJBPContentArea: emptyClosure?//进入聚宝盆商家专区
    @objc var productArriveNotice: emptyClosure?//到货通知
    @objc var clickShopContentArea: emptyClosure?//进入店铺详情
    @objc var clickComboBtn: emptyClosure?//点击购买套餐按钮
    var productState: Int?//当前商品状态
    
    /// 底部分割线，默认隐藏
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        view.isHidden = true
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
        bgLayer1.shadowColor = UIColor(red: 0.15, green: 0.18, blue: 0.34, alpha: 0.15).cgColor
        bgLayer1.shadowOffset = CGSize(width: 0, height: 0)
        bgLayer1.shadowOpacity = 1
        bgLayer1.shadowRadius = WH(15)
        bgLayer1.shouldRasterize = true
        bgLayer1.rasterizationScale = UIScreen.main.scale
        
        return bgLayer1
    }()
    // 选择按钮
    //    fileprivate lazy var selectedBtn:UIButton = {
    //        let iv = UIButton()
    //        _ = iv.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
    //            guard let strongSelf = self else {
    //                return
    //            }
    //            if let closure = strongSelf.touchItem {
    //                closure()
    //            }
    //            }, onError: nil, onCompleted: nil, onDisposed: nil)
    //        return iv
    //    }()
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
    
    //    fileprivate lazy var vendorLabel: UILabel = {
    //        let label = UILabel()
    //        label.numberOfLines = 1
    //        label.textColor = RGBColor(0x999999)
    //        label.font = UIFont.systemFont(ofSize: WH(12))
    //        return label
    //    }()
    
    //价优信息
    fileprivate lazy var priceExcellentInfoView: PriceExcellentInfoView = {
        let view = PriceExcellentInfoView()
        return view
    }()
    
    //浏览次数、查看次数、购买次数
    fileprivate lazy var oftenBuyInfoView: OftenBuyInfoDetailView = {
        let view = OftenBuyInfoDetailView()
        return view
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
        self.layer.masksToBounds = true
        
        contentView.addSubview(contentBgView)
        contentBgView.layer.addSublayer(contentLayer)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(rankView)
        contentBgView.addSubview(soldOutImgView)
        contentBgView.addSubview(oftenBuyInfoView)
        contentBgView.addSubview(priceExcellentInfoView)
        //self.contentBgView.addSubview(selectedBtn)
        contentBgView.addSubview(cartInfoView)
        contentBgView.addSubview(statusInfoView)
        contentBgView.addSubview(verderInfoView)
        self.contentBgView.addSubview(self.bottomMarginLine)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.top.equalTo(contentView).offset(WH(10))
            make.bottom.equalTo(contentView).offset(WH(0))
        })
        
        //        selectedBtn.snp.makeConstraints({ (make) in
        //            make.edges.equalTo(self.contentBgView)
        //        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(contentBgView).offset(WH(10))
            make.width.height.equalTo(WH(100))
        })
        rankView.snp.makeConstraints({ (make) in
            make.top.equalTo(imgView.snp.top).offset(WH(4))
            make.left.equalTo(imgView.snp.left).offset(WH(2))
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(47))
        })
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(imgView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
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
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        priceExcellentInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(priceInfoView.snp.top).offset(WH(0))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        statusInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        cartInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(verderInfoView.snp.top).offset(WH(22))  //10个高度是购物车空白区域 12 个高度是正常供应商的名称高度
            make.right.equalTo(contentBgView).offset(WH(-3))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        oftenBuyInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(verderInfoView.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-3))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.height.equalTo(0)
        })
        
        self.bottomMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    /// 订单列表中cell的展示样式
    @objc func orderListLayoutType(){
        self.bottomMarginLine.isHidden = false
        self.contentBgView.backgroundColor = RGBColor(0xFFFFFF)
        self.contentLayer.removeFromSuperlayer()
        self.contentBgView.snp_updateConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(0))
            make.right.equalTo(contentView).offset(WH(0))
            make.top.equalTo(contentView).offset(WH(0))
            make.bottom.equalTo(contentView).offset(WH(0))
        })
    }
    
    /// 10086为无意义的标志位 可理解为空状态
    @objc func configCell(_ product: Any, _ rankIndex:Int = 10086) {
        //设置排名
        self.rankView.configRankingViewData(rankIndex)

        if let model = product as? HomeCommonProductModel {
            //图片
            contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
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
            priceExcellentInfoView.configCell(model)
            priceExcellentInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(PriceExcellentInfoView.getContentHeight(model))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
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
                    let maxW = model.statusMsg!.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(13 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
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
                //单品不可购买，显示套餐按钮
                if let num = model.singleCanBuy , num == 1 {
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
                    })
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(WH(50))
                        make.width.equalTo(WH(90))
                    })
                }else {
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(13 + 45))
                    })
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.width.height.equalTo(WH(50))
                    })
                }
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
            }
            oftenBuyInfoView.configCell(model)
            let detail = model.detailStr
            
            if detail.isEmpty == false &&  model.statusDesc == 0{
                oftenBuyInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(OftenBuyInfoDetailView.getContentHeight(model))
                })
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - OftenBuyInfoDetailView.getContentHeight(model)))
                })
            }else{
                oftenBuyInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(OftenBuyInfoDetailView.getContentHeight(model))
                })
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
            }
            
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        else if let model = product as? ShopProductItemModel{
            //图片
            contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.picPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
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
            priceExcellentInfoView.configCell(model)
            priceExcellentInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(PriceExcellentInfoView.getContentHeight(model))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
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
                //单品不可购买，显示套餐按钮
                if let num = model.singleCanBuy , num == 1 {
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
                    })
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(WH(50))
                        make.width.equalTo(WH(90))
                    })
                }else {
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(13 + 45))
                    })
                    cartInfoView.snp.updateConstraints({ (make) in
                        make.width.height.equalTo(WH(50))
                    })
                }
                
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
            }
            
            
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        else if let model = product as? HomeProductModel{
            //图片
            contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.productPicUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            
            
            baseInfoView.confighHomeCell(model)
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
            priceExcellentInfoView.configCell(model)
            priceExcellentInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(PriceExcellentInfoView.getContentHeight(model))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
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
                    make.right.equalTo(contentBgView).offset(-WH(13 + 45))
                })
                cartInfoView.snp.updateConstraints({ (make) in
                    make.width.height.equalTo(WH(50))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
            }
            
            
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        else if let model = product as? ShopProductCellModel {
            //图片
            contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.prdPic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            baseInfoView.confighHomeCell(model)
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
            
            priceExcellentInfoView.configCell(model)
            priceExcellentInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(PriceExcellentInfoView.getContentHeight(model))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
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
                        make.right.equalTo(contentBgView).offset(-WH(22 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                verderInfoView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
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
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }else if let model = product as? FKYMedicinePrdDetModel {
            //图片
            contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
            soldOutImgView.isHidden = true
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
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
            priceExcellentInfoView.configCell(model)
            priceExcellentInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(PriceExcellentInfoView.getContentHeight(model))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + 90))
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
                        make.right.equalTo(contentBgView).offset(-WH(13 + maxW))
                    })
                    if status == 2{
                        //不可购买 不再经营范围
                        verderInfoView.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            //  make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
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
                    make.right.equalTo(contentBgView).offset(-WH(13 + 45))
                })
                cartInfoView.snp.updateConstraints({ (make) in
                    make.width.height.equalTo(WH(50))
                })
                statusInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                    make.width.equalTo(0)
                    make.bottom.equalTo(verderInfoView.snp.bottom)
                })
            }
            
            
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        //contentLayer.needsLayout()
        self.contentView.layoutIfNeeded()
    }
    //MARK:设置可以点击店铺名称进入店铺详情
    @objc func resetCanClickShopArea(_ product:Any,_ searchType:SearchProductType = .CommonSearch) {
        self.verderInfoView.resetClickShopView(product,searchType)
    }
    @objc func resetContentLayerColor() {
        self.contentLayer.shadowColor = RGBColor(0xF4F4F4).cgColor
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
    @objc static func getCellContentHeight(_ product:Any) -> CGFloat{
        var Cell = WH(25)
        if let model = product as? HomeCommonProductModel {
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = Cell + OftenBuyInfoDetailView.getContentHeight(model)
            Cell = Cell + PriceExcellentInfoView.getContentHeight(model)
            Cell = (Cell + WH(20)) > WH(140) ? (Cell + WH(20)): WH(140)
        } else if let model = product as? ShopProductItemModel{
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = (Cell + WH(20)) > WH(140) ? (Cell + WH(20)): WH(140)
        }else if let model = product as? HomeProductModel{
            Cell = Cell + ProductBaseInfoView.getHomeContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = (Cell + WH(20)) > WH(140) ? (Cell + WH(20)): WH(140)
        }else if let model = product as? ShopProductCellModel{
            Cell = Cell + ProductBaseInfoView.getHomeContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = (Cell + WH(20)) > WH(140) ? (Cell + WH(20)): WH(140)
        }else if let model = product as? FKYMedicinePrdDetModel {
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + ProductVendorInfoView.getContentHeight(model)
            Cell = (Cell + WH(20)) > WH(140) ? (Cell + WH(20)): WH(140)
        }
        return Cell
    }
}
