//
//  ProductVendorInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/11/20.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  供应商名字 或者 jbp商家

import UIKit

class ProductVendorInfoView: UIView {
    var clickJBPContentAction: emptyClosure?//更新加车
    var clickShopDeatilAction: emptyClosure?//进入店铺详情加车
    
    //供应商区域区域
    fileprivate lazy var shopContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.bk_(whenTapped:  { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.clickShopDeatilAction else {
                return
            }
            block()
        })
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
    // 进店铺
    fileprivate lazy var rightdesLabel: UILabel = {
        let label = UILabel()
        label.text = "进店"
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 箭头指示器
    fileprivate lazy var shopImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .right
        iv.image = UIImage(named: "right_dir_jpb")
        return iv
    }()
    
    //聚宝盆区域
    fileprivate lazy var jbpContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.bk_(whenTapped:  { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.clickJBPContentAction else {
                return
            }
            block()
        })
        return view
    }()
    //聚宝盆商家名字
    fileprivate lazy var jbpVendorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    // 进聚宝盆专区
    fileprivate lazy var rightJBPdesLabel: UILabel = {
        let label = UILabel()
        label.text = "进专区"
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 箭头指示器
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .right
        iv.image = UIImage(named: "right_dir_jpb")
        return iv
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
        self.addSubview(shopContentView)
        shopContentView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(WH(12))
        })
        
        shopContentView.addSubview(vendorLabel)
        vendorLabel.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(shopContentView)
            make.right.lessThanOrEqualTo(shopContentView).offset(WH(-7-26-7))
        })
        shopContentView.addSubview(rightdesLabel)
        rightdesLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(vendorLabel.snp.right).offset(WH(7))
            make.centerY.equalTo(vendorLabel.snp.centerY)
            make.width.equalTo(WH(26))
        })
        
        shopContentView.addSubview(shopImgView)
        shopImgView.snp.makeConstraints({ (make) in
            make.left.equalTo(rightdesLabel.snp.right)
            make.centerY.equalTo(vendorLabel.snp.centerY)
            make.height.width.equalTo(WH(7))
        })
        
        self.addSubview(jbpContentView)
        jbpContentView.addSubview(jbpVendorLabel)
        jbpContentView.addSubview(imgView)
        jbpContentView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(shopContentView.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(12))
        })
        
        jbpVendorLabel.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(jbpContentView)
            make.right.lessThanOrEqualTo(jbpContentView).offset(WH(-7-38-7))
        })
        jbpContentView.addSubview(rightJBPdesLabel)
        rightJBPdesLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(jbpVendorLabel.snp.right).offset(WH(7))
            make.centerY.equalTo(jbpVendorLabel.snp.centerY)
            make.width.equalTo(WH(38))
        })
        imgView.snp.makeConstraints({ (make) in
            make.left.equalTo(rightJBPdesLabel.snp.right)
            make.centerY.equalTo(jbpVendorLabel.snp.centerY)
            make.height.width.equalTo(WH(7))
        })
    }
    //设置可以点击店铺名称，进入店铺
    // needShowEnterShop 在店铺内搜索或者专区搜不展示进店入口但是展示进专区的入口
    func resetClickShopView(_ product:Any,_ searchType:SearchProductType = .CommonSearch) {
        //有专区不显示进入店铺的箭头
        var showJBP = false
        if let model = product as? HomeCommonProductModel {
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    showJBP = true
                }
            }
        } else if let model = product as? HomeProductModel{
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    showJBP = true
                }
            }
        }
        if showJBP == false{
            shopImgView.isHidden = false
            rightdesLabel.isHidden = false
            shopContentView.isUserInteractionEnabled = true
            vendorLabel.snp.updateConstraints({ (make) in
                make.right.lessThanOrEqualTo(shopContentView).offset(WH(-7-26-7))
            })
        }
        if searchType == .JBPSearch{
            rightJBPdesLabel.isHidden = true
            imgView.isHidden = true
            jbpContentView.isUserInteractionEnabled = false
            shopImgView.isHidden = true
            rightdesLabel.isHidden = true
            shopContentView.isUserInteractionEnabled = false
            vendorLabel.snp.updateConstraints({ (make) in
                make.right.lessThanOrEqualTo(shopContentView).offset(WH(0))
            })
        }else if searchType == .ShopSearch{
            shopImgView.isHidden = true
            rightdesLabel.isHidden = true
            shopContentView.isUserInteractionEnabled = false
            vendorLabel.snp.updateConstraints({ (make) in
                make.right.lessThanOrEqualTo(shopContentView).offset(WH(0))
            })
        }
    }
    func configCell(_ product: Any) {
        shopContentView.isHidden = true
        shopImgView.isHidden = true
        rightdesLabel.isHidden = true
        vendorLabel.snp.updateConstraints({ (make) in
            make.right.lessThanOrEqualTo(shopContentView).offset(WH(0))
        })
        shopContentView.isUserInteractionEnabled = false
        
        jbpContentView.isHidden = true
        jbpContentView.isUserInteractionEnabled = false
        
        if let model = product as? HomeCommonProductModel {
            //首页
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.supplyName
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    jbpContentView.isHidden = false
                    jbpVendorLabel.text = vendorName
                    jbpContentView.isUserInteractionEnabled = true
                }
            }
        }else if let model = product as? HomeProductModel {
            //搜索 满减满赠专区 未登录不展示专区
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.vendorName
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    jbpContentView.isHidden = false
                    jbpVendorLabel.text = vendorName
                    jbpContentView.isUserInteractionEnabled = true
                }
            }
        }else if let model = product as? ShopProductItemModel{
            //店铺内全部商品
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.sellerName
        }else if let model = product as? ShopProductCellModel {
            //店铺管商家商品
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.vendorName
        }
        else if let model = product as? ShopListProductItemModel {
            //店铺管商家商品
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.productSupplyName
        }else if let model = product as? FKYFullProductModel{
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.enterpriseName
        }else if let model = product as? FKYMedicinePrdDetModel{
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.productSupplyName
        }else if let model = product as? FKYPreferetailModel{
            //MARK:商家特惠列表
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.frontSellerName
        }else if let model = product as? FKYPackageRateModel{
            //MARK:单品包邮
            self.shopContentView.isHidden = false
            self.vendorLabel.text = model.frontSellerName
        }
    }
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(12)
        if let model = product as? HomeCommonProductModel {
            //首页
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    Cell =  Cell + WH(20)
                }
            }
        }else if let model = product as? HomeProductModel {
            //搜索 满减满赠专区  未登录不展示专区
            if model.statusDesc == 0{
                if let vendorName = model.shopName,vendorName.isEmpty == false{
                    Cell =  Cell + WH(20)
                }
            }
        }else if let model = product as? ShopProductItemModel{
            //店铺内全部商品
        }else if let model = product as? ShopProductCellModel {
            //店铺管商家商品
        }
        else if let model = product as? ShopListProductItemModel {
            //店铺管商家商品
        }else if let model = product as? FKYFullProductModel{
            
        }else if let model = product as? FKYMedicinePrdDetModel{
            
        }
        return Cell
    }
}
