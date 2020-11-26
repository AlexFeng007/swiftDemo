//
//  CommonProductItemCell.swift
//  FKY
//
//  Created by 寒山 on 2019/8/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  店铺内首页

import UIKit

class CommonProductItemCell: UICollectionViewCell {
    var clickJBPContentArea: emptyClosure?//进入聚宝盆商家专区
    var addUpdateProductNum: emptyClosure?//更新加车
    var touchItem: emptyClosure?//进入商详
    var loginClosure: emptyClosure?//登录
    var productArriveNotice: emptyClosure?//到货通知
    var productState: Int?//当前商品状态
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = RGBColor(0xffffff)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.touchItem {
                closure()
            }
        }).disposed(by: disposeBag)
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
        
        return view
    }()
    //    // 供应商
    //    fileprivate lazy var verderInfoView: UILabel = {
    //        let label = UILabel()
    //        label.numberOfLines = 1
    //        label.textColor = RGBColor(0x999999)
    //        label.font = UIFont.systemFont(ofSize: WH(12))
    //        return label
    //    }()
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
        return view
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        contentBgView.addSubview(verderInfoView)
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
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        verderInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
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
    }
    func configCell(_ product: Any) {
        soldOutImgView.isHidden = true
        if let model = product as? FKYFullProductModel {
            //图片
            if let strProductPicUrl = model.productImgUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
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
            cartInfoView.configCell(model)
            productState = model.statusDesc ?? 10086 //防止状态空
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
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
        }
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
                            //  make.bottom.equalTo(verderInfoView.snp.bottom).offset(ProductStatusInfoView.getContentHeight(model))
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
                    make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
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
        if let model = product as? FKYFullProductModel {
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
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
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
        return 0
    }
}
