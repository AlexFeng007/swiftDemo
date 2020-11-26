//
//  StockOutProductView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class StockOutProductView: UIView {
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
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
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .left
        //        label.adjustsFontSizeToFitWidth = true
        //        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(contentBgView)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(soldOutImgView)
        contentBgView.addSubview(priceLabel)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(12))
            make.left.equalTo(contentBgView).offset(WH(10))
            make.width.height.equalTo(WH(100))
        })
        
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(imgView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(12))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView).offset(WH(-11))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-13))
            make.height.equalTo(WH(19))
        })
    }
    /// 10086为无意义的标志位 可理解为空状态
    @objc func configView(_ product: HomeCommonProductModel?) {
        if let model = product   {
            //图片
            soldOutImgView.isHidden = false
            if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.imgView.image = UIImage.init(named: "image_default_img")
            }
            baseInfoView.configCell(model)
            baseInfoView.snp.updateConstraints({ (make) in
                make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
            })
            if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
                
                if(model.price != nil && model.price != 0.0){
                    self.priceLabel.isHidden = false
                    self.priceLabel.text = String.init(format: "¥ %.2f", model.price!)
                }
                if (model.promotionPrice != nil && model.promotionPrice != 0.0) {
                    self.priceLabel.text = String.init(format: "¥ %.2f", (model.promotionPrice ?? 0))
                }
                if let _ = model.vipPromotionId ,let vipNum = model.visibleVipPrice ,vipNum > 0 {
                    if let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                        //会员
                        self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                    }else{
                        //非会员
                        self.priceLabel.text = String.init(format: "¥ %.2f",model.price!)
                    }
                }
                
                // 对价格大小调整
                if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                    let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                    priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                    self.priceLabel.attributedText = priceMutableStr
                }
            }
        }
    }
    //获取行高
    @objc static func getCellContentHeight(_ product: HomeCommonProductModel?) -> CGFloat{
        var Cell = WH(52)
        if let model = product{
            Cell += ProductBaseInfoView.getContentHeight(model)
        }
        return Cell
    }
}
