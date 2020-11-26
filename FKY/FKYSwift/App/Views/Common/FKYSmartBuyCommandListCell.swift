//
//  FKYSmartBuyCommandListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSmartBuyCommandListCell: UITableViewCell {
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
            //            if let closure = strongSelf.touchItem {
            //                closure()
            //            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // 商品图片
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    //商品名 自营标签
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x4C4C4C)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //规格
    fileprivate lazy var spuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        return label
    }()
    
    //厂家名
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    //活动标签
    var promotionTypeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        return label
    }()
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 特价...<带中划线>
    fileprivate lazy var tjPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = t11.font
        label.textColor = RGBColor(0x666666)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = RGBColor(0x666666)
        
        return label
    }()
    
    // 特价(标签)
    fileprivate lazy var promotionPriceIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        label.text = "特价"
        return label
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
        print("FKYSmartBuyCommandListCell")
    }
    // MARK: - UI
    func setupView() {
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(spuLabel)
        contentBgView.addSubview(factoryLabel)
        contentBgView.addSubview(promotionTypeLabel)
        contentBgView.addSubview(priceLabel)
        contentBgView.addSubview(tjPrice)
        contentBgView.addSubview(promotionPriceIcon)
        contentBgView.addSubview(lineView)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView)
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(12))
            make.left.equalTo(contentBgView).offset(WH(22))
            make.width.height.equalTo(WH(80))
        })
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(imgView.snp.right).offset(WH(16))
            make.top.equalTo(contentBgView).offset(WH(12))
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        spuLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(4))
            //make.height.equalTo(WH(16))
        })
        
        factoryLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(spuLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(14))
        })
        
        promotionTypeLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(factoryLabel.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(18))
            make.width.equalTo(0)
        })
        
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView).offset(-12)
            make.left.equalTo(titleLabel.snp.left)
            make.width.greaterThanOrEqualTo(WH(50))
            make.height.equalTo(WH(19))
        })
        
        promotionPriceIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(priceLabel.snp.right).offset(j4)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        })
        
        tjPrice.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.priceLabel.snp.centerY)
            make.left.equalTo(self.promotionPriceIcon.snp.right).offset(WH(5))
            make.width.lessThanOrEqualTo(WH(SCREEN_WIDTH/4))
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(contentBgView)
        })
    }
    func configCell(_ model:HomeCommonProductModel) {
        if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.imgView.image = UIImage.init(named: "image_default_img")
        }
        spuLabel.text = model.spec ?? ""
        if let productName = model.spuName{
            var titleHeight = 0.0
            if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ?model.shopExtendType!:3, model.shopExtendTag)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(140), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                titleLabel.attributedText = attributedString
            }else {
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(140), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                titleLabel.attributedText = attributedString
            }
            
//            let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(140), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            titleLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(titleHeight)
            })
        }
        factoryLabel.text = model.factoryName
        
        if let priceChange = model.priceChange,priceChange.isEmpty == false{
            self.promotionTypeLabel.isHidden = false
            self.promotionTypeLabel.text = "成本降低\(priceChange)"
            let limitedW = self.promotionTypeLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).width
            let deslimitW = limitedW! + WH(8)
            self.promotionTypeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(deslimitW)
            }
        }else{
            self.promotionTypeLabel.isHidden = true
        }
        
        //价格
        self.priceLabel.isHidden = true
        self.promotionPriceIcon.isHidden = true
        self.tjPrice.isHidden = true
        
        if model.statusDesc == -5 || model.statusDesc == -13 || model.statusDesc == 0{
            if(model.price != nil && model.price != 0.0){
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥ %.2f", model.price!)
            }
            if (model.promotionPrice != nil && model.promotionPrice != 0.0) {
                self.priceLabel.text = String.init(format: "¥ %.2f", (model.promotionPrice ?? 0))
                self.tjPrice.text = String.init(format: "¥ %.2f", (model.price!))
                self.tjPrice.isHidden = false;
                self.promotionPriceIcon.isHidden = false
            }
            
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
        
    }
    //获取行高
    static func  getCellContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? HomeCommonProductModel {
            var Cell = WH(12)
            if let productName = model.spuName{
                var titleHeight = 0.0
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ?model.shopExtendType!:3, model.shopExtendTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(140), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                     
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(140), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                     
                }
                Cell = Cell + CGFloat(titleHeight)
            }
            Cell = Cell + WH(21)
            Cell = Cell + WH(20)
            if let priceChange = model.priceChange,priceChange.isEmpty == false{
                Cell = Cell + WH(24)
            }
            Cell = Cell + WH(34)
            
            return Cell > WH(104) ? Cell:WH(104)
        }
        return 0
    }
    
}
