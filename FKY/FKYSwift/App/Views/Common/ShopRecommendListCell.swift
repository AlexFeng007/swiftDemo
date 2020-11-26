//
//  ShopRecommendListCell.swift
//  FKY
//
//  Created by 寒山 on 2019/8/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  品种汇 普品展示

import UIKit

class ShopRecommendListCell: UITableViewCell {
    fileprivate var callback: ShopListCellActionCallback?
    var addUpdateProductNum: emptyClosure?//更新加车
    var loginClosure: emptyClosure?//登录
    var productArriveNotice: emptyClosure?//到货通知
    var productState: Int?//当前商品状态
    @objc var clickComboBtn: emptyClosure?//点击购买套餐按钮
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
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
    fileprivate lazy var vendorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    //浏览次数、查看次数、购买次数
    fileprivate lazy var oftenBuyInfoView: OftenBuyInfoDetailView = {
        let view = OftenBuyInfoDetailView()
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
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(statusInfoView)
        contentBgView.addSubview(cartInfoView)
        contentBgView.addSubview(vendorLabel)
        contentBgView.addSubview(soldOutImgView)
        contentBgView.addSubview(oftenBuyInfoView)
        
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
            make.top.equalTo(contentBgView).offset(WH(15))
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
        
        vendorLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(priceInfoView.snp.right)
            make.height.equalTo(WH(12))
        })
        
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.top).offset(WH(-7))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        statusInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        cartInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.bottom).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-3 - 9))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        oftenBuyInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(vendorLabel.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-3))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.height.equalTo(0)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(self)
        })
    }
    func configCell(_ product: Any) {
        soldOutImgView.isHidden = true
        oftenBuyInfoView.isHidden = true
        productState = 10086 //初始化
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
            
            self.vendorLabel.text = model.vendorName
            
            cartInfoView.configCell(model)
            
            if let status = model.statusDesc ,status != 0{
                if status == -5{
                    //到货通知
                    soldOutImgView.isHidden = false
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                        make.width.equalTo(WH(90))
                        make.bottom.equalTo(vendorLabel.snp.bottom)
                    })
                    vendorLabel.snp.updateConstraints({ (make) in
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
                            make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(vendorLabel.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                vendorLabel.snp.updateConstraints({ (make) in
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
                    make.bottom.equalTo(vendorLabel.snp.bottom)
                })
                
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            //图片
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
            
            statusInfoView.configCell(model)
            
            self.vendorLabel.text = model.supplyName
            
            cartInfoView.configCell(model)
            
            if let num = model.singleCanBuy , num == 1 {
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                })
                cartInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(WH(50))
                    make.width.equalTo(WH(90))
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
                make.bottom.equalTo(vendorLabel.snp.bottom)
            })
            
            oftenBuyInfoView.configCell(model)
            oftenBuyInfoView.isHidden = false
            let detail = model.detailStr
            if detail.isEmpty == false{
                oftenBuyInfoView.snp.updateConstraints({ (make) in
                    make.height.equalTo(OftenBuyInfoDetailView.getContentHeight(model))
                })
                vendorLabel.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - OftenBuyInfoDetailView.getContentHeight(model)))
                })
            }else{
                vendorLabel.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                })
            }
        }
        if let model = product as? ShopListProductItemModel {
            //图片
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
            
            statusInfoView.configCell(model)
            
            self.vendorLabel.text = model.productSupplyName
            
            cartInfoView.configCell(model)
            
            if let status = model.statusDesc ,status != 0{
                if status == -5{
                    //到货通知
                    soldOutImgView.isHidden = false
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                        make.width.equalTo(WH(90))
                        make.bottom.equalTo(vendorLabel.snp.bottom)
                    })
                    vendorLabel.snp.updateConstraints({ (make) in
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
                            make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(vendorLabel.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                vendorLabel.snp.updateConstraints({ (make) in
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
                    make.bottom.equalTo(vendorLabel.snp.bottom)
                })
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        if let model = product as? ShopProductCellModel {
            //图片
            if let strProductPicUrl = model.prdPic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
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
           
            self.vendorLabel.text = model.vendorName
            
            cartInfoView.configCell(model)
            
            if let status = model.statusDesc ,status != 0{
                if status == -5{
                    //到货通知
                    soldOutImgView.isHidden = false
                    priceInfoView.snp.updateConstraints({ (make) in
                        make.right.equalTo(contentBgView).offset(-WH(22 + 90))
                    })
                    statusInfoView.snp.updateConstraints({ (make) in
                        make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                        make.width.equalTo(WH(90))
                        make.bottom.equalTo(vendorLabel.snp.bottom)
                    })
                    vendorLabel.snp.updateConstraints({ (make) in
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
                            make.bottom.equalTo(vendorLabel.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13 - ProductStatusInfoView.getContentHeight(model)))
                        })
                    }else{
                        statusInfoView.snp.updateConstraints({ (make) in
                            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
                            make.bottom.equalTo(vendorLabel.snp.bottom)
                            make.width.equalTo(maxW)
                        })
                        vendorLabel.snp.updateConstraints({ (make) in
                            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
                        })
                    }
                }
                
            }else{
                vendorLabel.snp.updateConstraints({ (make) in
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
                    make.width.equalTo(WH(0))
                    make.bottom.equalTo(vendorLabel.snp.bottom)
                })
            }
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        
        self.layoutIfNeeded()
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
    static func  getCellContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? HomeProductModel {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        if let model = product as? ShopProductCellModel {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        if let model = product as? ShopListProductItemModel {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + OftenBuyInfoDetailView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        return 0
    }
//    //获取行高
//    static func getFirstPageContentHeight(_ product: Any) -> CGFloat{
//        if let model = product as? ShopProductCellModel {
//            var Cell = WH(15)
//            Cell = Cell + ProductBaseInfoView.getShopFirstContentHeight(model)
//            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
//            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
//            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
//            Cell = Cell + WH(32)
//            Cell = (Cell > WH(130)) ? Cell:WH(130)
//            return Cell
//        }
//        return 0
//    }
    
}
extension ShopRecommendListCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let m = model as? ShopListProductItemModel {
            return HomeCommonProductInfoCell.getCellContentHeight(m)
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListProductItemModel {
            configCell(m)
        }
        //        else {
        //            configCell(nil)
        //        }
    }
}
