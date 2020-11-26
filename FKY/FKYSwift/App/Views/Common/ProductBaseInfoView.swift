//
//  ProductBaseInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品列表 基础信息  商品名 厂家名 效期  

import UIKit

class ProductBaseInfoView: UIView {
    //商品名 自营标签
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //厂家名
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    //效期
    // 有效期名字
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = t16.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    // 有效期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
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
        self.addSubview(titleLabel)
        self.addSubview(factoryLabel)
        self.addSubview(timeTitleLabel)
        self.addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.top.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0)
        })
        factoryLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(14))
        })
        
        timeTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.top.equalTo(factoryLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(14))
        })
        
        timeLabel.snp.makeConstraints({ (make) in
            //make.right.equalTo(self)
            make.left.equalTo(timeTitleLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(timeTitleLabel.snp.centerY)
        })
    }
    //获取行高 卡片式的 商品名 SCREEN_WIDTH - WH(130 + 23)   平铺式的最大宽度 SCREEN_WIDTH - WH(100 + 25 + 22)
    func confighHomeCell(_ product: Any) {
        if let model = product as? HomeProductModel{
            //商品名 自营标签
            if let productName = model.productFullName{
                if let shopTag = model.ext_shop_tag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.ext_type != nil ?model.ext_type!:3, model.ext_shop_tag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                    
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.ziyingTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }
            }
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }else if let model = product as? ShopProductCellModel {
            //商品名 自营标签
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag, model.ziyingTag)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryNameCn
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
    }
    //获取行高 卡片式的 商品名 SCREEN_WIDTH - WH(130 + 23)   平铺式的最大宽度 SCREEN_WIDTH - WH(100 + 25 + 22)
    func configCell(_ product: Any) {
        // self.backgroundColor = UIColor.blue
        if let model = product as? HomeProductModel {
            //商品名 自营标签
            if let productName = model.productFullName{
                if let shopTag = model.ext_shop_tag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.ext_type != nil ?model.ext_type!:3, model.ext_shop_tag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                    
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.ziyingTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }
            }
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? FKYProductObject {
            //商品名 自营标签
            var name = ""
            if let pdName = model.shortName, pdName.isEmpty == false {
                name = pdName
            }
            if let spec = model.spec, spec.isEmpty == false {
                name = name + " " + spec
            }
            if let _ = model.shortName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(name,model.isZiYingFlag, model.ziyingWarehouseName)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadline, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        
        if let model = product as? SearchMpHockProductModel{
            //商品名 自营标签
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag, model.ziyingTag)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? ShopProductCellModel {
            //商品名 自营标签
            if let productName = model.productFullName{
                // let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,1)
                titleLabel.text = productName
                if let ziyingTag = model.ziyingTag,ziyingTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,1, model.ziyingTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,0, model.ziyingTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }
                
            }
            
            factoryLabel.text = model.factoryNameCn
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            //商品名 自营标签
            if let productName = model.productFullName{
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ? model.shopExtendType!:3, model.shopExtendTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                    
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }
                
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? HomeCommonProductModel {
            //商品名 自营标签
            if let productName = model.productFullName{
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ? model.shopExtendType!:3, model.shopExtendTag)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    titleLabel.attributedText = attributedString
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleLabel.snp.updateConstraints({ (make) in
                        make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    })
                }
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? ShopProductItemModel {
            //商品名 自营标签
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName, model.ziyingFlag != nil ? model.ziyingFlag!: 3, model.ziyingWarehouseName)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? FKYFullProductModel{
            //商品名 自营标签
            if let productName = model.productFullName{
                //                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,3)
                //                titleLabel.attributedText = attributedString
                //                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.text = productName
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //商品名 自营标签
            if let productName = model.productFullName{
                //  let attributedString = productName//ProductBaseInfoView.getProductTitleAttrStr(productName,3)
                titleLabel.text = productName
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size//productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? FKYTogeterBuyModel{
            //一起购信息
            if let productName = model.projectName{
                //                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,3)
                //                titleLabel.attributedText = attributedString
                //                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.text = productName
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as?  ShopListProductItemModel{
            //品种汇推荐
            //            if let productName = model.productFullName{
            ////                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,3)
            ////                titleLabel.attributedText = attributedString
            ////                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
            //                titleLabel.text = productName
            //                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSFontAttributeName : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            //                titleLabel.snp.updateConstraints({ (make) in
            //                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            //                })
            //            }
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                titleLabel.attributedText = attributedString
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.expiryDate, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }
        if let model = product as? FKYPreferetailModel{
            //MARK:商家特惠列表
            if let productName = model.productFullName{
                //  let attributedString = productName//ProductBaseInfoView.getProductTitleAttrStr(productName,3)
                titleLabel.text = productName
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(10+9+100+10+22+10), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size//productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
        }else if let model = product as? FKYPackageRateModel {
            //MARK:单品包邮
            if let productName = model.productFullName{
                titleLabel.text = productName
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(10+9+100+10+22+10), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size//productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleLabel.snp.updateConstraints({ (make) in
                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                })
            }
            factoryLabel.text = model.factoryName
            // 有效期 和生产日期
            if let time = model.deadLine, time.isEmpty == false {
                let deadLineStr :String? // 有效期
                if time.contains(" ") {
                    let arr = time.split(separator: " ")
                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                        deadLineStr = String(date)
                    }
                    else {
                        deadLineStr = ""
                    }
                }
                else {
                    deadLineStr = time
                }
                timeTitleLabel.isHidden = false
                timeLabel.isHidden = false
                timeTitleLabel.text = "效期"
                timeLabel.text = deadLineStr
            }
            else {
                timeTitleLabel.isHidden = true
                timeLabel.isHidden = true
            }
            
        }
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
    }
    //    func configFirstPageCell(_ product: Any) {
    //        if let model = product as? ShopProductCellModel {
    //            //商品名 自营标签
    //            if let productName = model.productFullName{
    //                // let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,1)
    //                titleLabel.text = productName
    //                let contentSize = productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
    //                titleLabel.snp.updateConstraints({ (make) in
    //                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
    //                })
    //            }
    //
    //            factoryLabel.text = model.factoryNameCn
    //            // 有效期 和生产日期
    //            if let time = model.deadLine, time.isEmpty == false {
    //                let deadLineStr :String? // 有效期
    //                if time.contains(" ") {
    //                    let arr = time.split(separator: " ")
    //                    if arr.count >= 2, let date = arr.first, date.isEmpty == false {
    //                        deadLineStr = String(date)
    //                    }
    //                    else {
    //                        deadLineStr = ""
    //                    }
    //                }
    //                else {
    //                    deadLineStr = time
    //                }
    //                timeTitleLabel.isHidden = false
    //                timeLabel.isHidden = false
    //                timeTitleLabel.text = "效期"
    //                timeLabel.text = deadLineStr
    //            }
    //            else {
    //                timeTitleLabel.isHidden = true
    //                timeLabel.isHidden = true
    //            }
    //        }
    //        titleLabel.numberOfLines = 2
    //        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
    //    }
    //获取行高 卡片式的 商品名 SCREEN_WIDTH - WH(130 + 23)   平铺式的最大宽度 SCREEN_WIDTH - WH(100 + 25 + 22)
    static func getHomeContentHeight(_ product: Any) -> CGFloat {
        if let model = product as? HomeProductModel{
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let shopTag = model.ext_shop_tag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.ext_type != nil ?model.ext_type!:3, model.ext_shop_tag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.ziyingTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
        }else if let model = product as? ShopProductCellModel{
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag, model.ziyingTag)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? HomeCommonProductModel {
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ?model.shopExtendType!:3, model.shopExtendTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        
        return 0
    }
    //获取行高 卡片式的 商品名 SCREEN_WIDTH - WH(130 + 23)   平铺式的最大宽度 SCREEN_WIDTH - WH(100 + 25 + 22)
    static func getContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? HomeProductModel {
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let shopTag = model.ext_shop_tag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.ext_type != nil ?model.ext_type!:3, model.ext_shop_tag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.ziyingTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        if let model = product as? FKYProductObject{
            var titleHeight = 0.0
            var name = ""
            if let pdName = model.shortName, pdName.isEmpty == false {
                name = pdName
            }
            if let spec = model.spec, spec.isEmpty == false {
                name = name + " " + spec
            }
            
            if let _ = model.shortName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",name),model.isZiYingFlag, model.ziyingWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadline, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.priceInfo.status != "0"{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? SearchMpHockProductModel{
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag, model.ziyingTag)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? ShopProductItemModel{
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName), model.ziyingFlag != nil ? model.ziyingFlag!: 3, model.ziyingWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        if let model = product as? ShopProductCellModel {
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let ziyingTag = model.ziyingTag,ziyingTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),1, model.ziyingTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }else{
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),0, model.ziyingTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        if let model = product as? OftenBuyProductItemModel{
            //常购清单
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ? model.shopExtendType!:3, model.shopExtendTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                    
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(productName,model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
                
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        if let model = product as? HomeCommonProductModel {
            var titleHeight = 0.0
            if let productName = model.productFullName{
                if let shopTag = model.shopExtendTag,shopTag.isEmpty == false{
                    let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr(String(format:"%@",productName),model.shopExtendType != nil ?model.shopExtendType!:3, model.shopExtendTag)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }else {
                    let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                    let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(130 + 23), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                    titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
                }
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        if let model = product as? FKYFullProductModel{
            var titleHeight = 0.0
            if let productName = model.productFullName{
                //                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),3)
                //                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) +  WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? FKYTogeterBuyModel{
            //一起购信息
            var titleHeight = 0.0
            if let productName = model.projectName{
                //                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),3)
                //                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as?  ShopListProductItemModel{
            //品种汇推荐
            //            var titleHeight = 0.0
            //            if let productName = model.productFullName{
            ////                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),3)
            ////                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
            //                  let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSFontAttributeName : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            //                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            //            }
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let attributedString = ProductBaseInfoView.getProductTitleAttrStr(String(format:"%@",productName),model.isZiYingFlag != nil ?model.isZiYingFlag!:3, model.shortWarehouseName)
                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(100 + 25 + 22), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.expiryDate, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? FKYPreferetailModel{
            //MARK:商家特惠列表
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(10+9+100+10+22+10), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) +  WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        if let model = product as? FKYPackageRateModel {
            //MARK:单品包邮
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let contentSize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(10+9+100+10+22+10), height: WH(40)), options: .usesLineFragmentOrigin,attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) +  WH(38)
            }else{
                return CGFloat(titleHeight) + WH(19)
            }
        }
        return 0
    }
    
    static func getShopFirstContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? ShopProductCellModel {
            var titleHeight = 0.0
            if let productName = model.productFullName{
                let contentSize = productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
                titleHeight = Double((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            }
            if let time = model.deadLine, time.isEmpty == false {
                return CGFloat(titleHeight) + WH(38)
            }else{
                if model.statusDesc != 0{
                    return CGFloat(titleHeight) + WH(38)
                }
                return CGFloat(titleHeight) + WH(19)
            }
            
        }
        return 0
    }
    
    //生成符文本
    //selfHouseName自营仓名
    static func getProductTitleAttrStr(_ productName:String,_ isSelfShop:NSInteger, _ selfHouseName: String?) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        if isSelfShop == 1{
            //自营
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .blue) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(16)).lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = UIImage(named: "self_shop_icon")
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if isSelfShop == 0{
            //mp
            shopImage = UIImage(named: "mp_shop_icon")
            let textAttachment : NSTextAttachment = NSTextAttachment()
            textAttachment.image = shopImage
            textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else {
            //自营没值得时候
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:"%@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            attributedStrM.append(productNameStr)
        }
        return attributedStrM;
    }
    //获取0 普通店铺 1 旗舰店 2 加盟店 3 自营店）打标
    static func getProductHouseTitleAttrStr(_ productName:String,_ tagtype:NSInteger, _ selfHouseName: String?) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        if tagtype == 3{
            //自营
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .blue) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(16)).lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = UIImage(named: "self_shop_icon")
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 2{
            // 加盟店
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: houseName, colorType: .purple) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(16)).lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = UIImage(named: "self_shop_icon")
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 1{
            //旗舰店
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: houseName, colorType: .orange) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(16)).lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = UIImage(named: "self_shop_icon")
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 0{
            //mp
            shopImage = UIImage(named: "mp_shop_icon")
            let textAttachment : NSTextAttachment = NSTextAttachment()
            textAttachment.image = shopImage
            textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else {
            //自营没值得时候
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:"%@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            attributedStrM.append(productNameStr)
        }
        return attributedStrM;
    }
    
    //获取0 普通店铺 1 旗舰店 2 加盟店 3 自营店）打标 !!!!!!商品详情专用（标签高度为18，字体为12）
    static func getProductHouseImage(_ tagtype:NSInteger, _ selfHouseName: String?) -> (UIImage?) {
        //图片
        var shopImage : UIImage?
        if tagtype == 3{
            //自营
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "自营", tagName: houseName, colorType: .blue) {
                shopImage = tagImage
            }else {
                shopImage = UIImage(named: "self_shop_icon")
            }
        }else if tagtype == 2{
            // 加盟店
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "药城", tagName: houseName, colorType: .purple) {
                shopImage = tagImage
            }else {
                shopImage = UIImage(named: "self_shop_icon")
            }
        }else if tagtype == 1{
            //旗舰店
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "药城", tagName: houseName, colorType: .orange) {
                shopImage = tagImage
            }else {
                shopImage = UIImage(named: "self_shop_icon")
            }
        }else if tagtype == 0{
            //mp
            shopImage = UIImage(named: "mp_shop_icon")
        }
        return shopImage
    }
}
