//
//  PDFixedGroupItemCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/3/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详(固定)套餐之套餐中单个商品cell...<固定套餐>

import UIKit

class PDFixedGroupItemCell: UITableViewCell {
    // MARK: - Property
    
    // closure
//    var JumpToProductDetailCallback: JumpToProductDetailClosure? // 跳转到商详
    
    // 商品model
    var product: FKYProductGroupItemModel?
    
    // 商品图片
    fileprivate lazy var imgviewProduct: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
//        imageView.layer.borderColor = RGBColor(0xF5F5F5).cgColor
//        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 规格
    fileprivate lazy var lblSpe: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 生产厂家 or 供应商
    fileprivate lazy var lblCompany: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 有效期
    fileprivate lazy var lblDate: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 预计发货时间标签
    fileprivate lazy var dispatchTagLabel: UILabel = {
        let label = UILabel()
        label.font = t39.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = WH(2)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = 0.5
        return label
    }()
    
    // 起购量
    fileprivate lazy var lblMinBuy: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        return label
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .left
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 单位
//    fileprivate lazy var lblUnit: UILabel! = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.clear
//        label.textColor = RGBColor(0x9B9B9B)
//        label.font = UIFont.systemFont(ofSize: WH(14))
//        label.textAlignment = .center
//        return label
//    }()
    
    // 数量
    fileprivate lazy var lblNumber: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textAlignment = .right
//        label.minimumScaleFactor = 0.8
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // 标题
//    fileprivate lazy var lblTitle: UILabel! = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.clear
//        label.textColor = RGBColor(0x9B9B9B)
//        label.font = UIFont.systemFont(ofSize: WH(13))
//        label.textAlignment = .center
//        label.text = "购买 : "
//        return label
//    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupView()
        self.setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.imgviewProduct)
        self.contentView.addSubview(self.lblName)
        self.contentView.addSubview(self.lblSpe)
        self.contentView.addSubview(self.lblCompany)
        self.contentView.addSubview(self.lblDate)
        self.contentView.addSubview(self.dispatchTagLabel)
        self.contentView.addSubview(self.lblMinBuy)
        self.contentView.addSubview(self.lblPrice)
//        self.contentView.addSubview(self.lblUnit)
        self.contentView.addSubview(self.lblNumber)
//        self.contentView.addSubview(self.lblTitle)
        
        // 商品图片
        imgviewProduct.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(12))
            make.size.equalTo(CGSize(width: WH(80), height: WH(80)))
        }
        
        // 名称
        lblName.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(15))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 规格
        lblSpe.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblName.snp.bottom).offset(WH(5))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 生产厂家 or 供应商
        lblCompany.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblSpe.snp.bottom).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 有效期至
        lblDate.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblCompany.snp.bottom).offset(WH(5))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 共享库存标签
        dispatchTagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(lblName)
            make.top.equalTo(self.lblDate.snp.bottom).offset(WH(8))
            make.width.equalTo(WH(145))
            make.height.equalTo(WH(18))
        })
        
         /*******************************************/
        
//        // 单位
//        lblUnit.snp.makeConstraints { (make) in
//            make.right.bottom.equalTo(self.contentView).offset(WH(-10))
//            make.height.equalTo(WH(18))
//            make.width.lessThanOrEqualTo(WH(60)) // 单位不能无限长
//        }

        // 数量
        lblNumber.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-WH(10))
            //make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(WH(60)) // 数量不能无限长
        }

//        // 标题
//        lblTitle.snp.makeConstraints { (make) in
//            //make.centerY.equalTo(lblUnit)
//            make.bottom.equalTo(self.contentView).offset(WH(-10))
//            make.right.equalTo(lblNumber.snp.left).offset(-WH(4))
//            make.height.equalTo(WH(18))
//        }
        
        /*******************************************/
        
        // 起购量
        lblMinBuy.snp.makeConstraints { (make) in
            make.top.equalTo(self.dispatchTagLabel.snp.bottom).offset(WH(10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
            make.bottom.equalTo(self.contentView).offset(WH(-15)) // 用于设置cell高度自适应
//            make.right.lessThanOrEqualTo(self.lblTitle.snp.left).offset(WH(-5))
        }
        
        // 价格
        lblPrice.snp.makeConstraints { (make) in
            //make.top.equalTo(self.lblDate.snp.bottom).offset(WH(5))
            make.left.equalTo(self.lblMinBuy.snp.right).offset(WH(5))
//            make.right.lessThanOrEqualTo(self.lblTitle.snp.left).offset(WH(-5))
            //make.right.equalTo(self.contentView).offset(WH(-10))
            make.centerY.equalTo(self.lblMinBuy).offset(WH(-2))
        }
        
//        // 当冲突时，lblMinBuy不被拉伸，lblPrice可以被拉伸
//        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
//        self.lblMinBuy.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
//        // 当前lbl抗拉伸（不想变大）约束的优先级低
//        self.lblPrice.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
        
        // 分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        self.contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Action
    
    func setupAction() {
        // 点击图片进入商详
//        let tapGesture = UITapGestureRecognizer()
//        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
//            if let closure = self?.JumpToProductDetailCallback {
//                closure()
//            }
//        }).disposed(by: disposeBag)
//        self.imgviewProduct.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: FKYProductGroupItemModel? , _ indexpath: IndexPath) {
        self.product = product
        
        if let item = product {
            // 有传商品数据
            
            // 商品图片
            if var imgPath = item.filePath, imgPath.isEmpty == false {
                // 有返回图片url
                if imgPath.hasPrefix("//") {
                    imgPath = imgPath.substring(from: imgPath.startIndex)
                    //imgPath = imgPath.substring(from: imgPath.startIndex.advanced(by: 1))
                    //imgPath = imgPath.substring(with: imgPath.startIndex.advanced(by: 1)..<imgPath.endIndex)
                }
                let imgUrl = "https://p8.maiyaole.com/" + imgPath
                self.imgviewProduct.sd_setImage(with: URL.init(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "img_product_default"))
            }
            else {
                // 未返回图片url
                self.imgviewProduct.image = UIImage.init(named: "img_product_default")
            }
            
            // 商品标题
            let pName: String! = item.productName
            let sName: String! = item.shortName
            if pName != nil, pName.isEmpty == false {
                if sName != nil, sName.isEmpty == false {
                    self.lblName.text = pName + " " + sName
                }
                else {
                    self.lblName.text = pName
                }
            }
            else {
                self.lblName.text = sName
            }
            
            // 商品规格
            self.lblSpe.text = item.spec!
            
            // 生产厂家
            self.lblCompany.text = item.factoryName!
            
            // 有效期
            if let str = item.deadLine ,str.count > 0 {
                self.lblDate.text = "有效期至: \(str)"
//                let mStr = NSMutableAttributedString(string: "有效期至: \(date)", attributes: [NSForegroundColorAttributeName:RGBColor(0x555555)])
//                mStr.addAttribute(NSForegroundColorAttributeName, value:RGBColor(0x9B9B9B), range:NSRange(location:0,length:4))
//                self.lblDate.attributedText = mStr
            }
            else {
                self.lblDate.text = nil
//                self.lblDate.attributedText = nil
            }
            
            // 预计发货时间
            if let des = item.shareStockDesc, des.count > 0 {
                // 打标
                self.dispatchTagLabel.isHidden = false
                let maxW = des.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t39.font], context: nil).width
                let desW = maxW+WH(6) > (SCREEN_WIDTH - WH(12+80+10+10)) ? (SCREEN_WIDTH - WH(12+80+10+10)) : maxW+WH(6)
                self.dispatchTagLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.lblDate.snp.bottom).offset(WH(8))
                    make.height.equalTo(WH(18))
                    make.width.equalTo(desW)
                })
                self.dispatchTagLabel.text = item.shareStockDesc
            }
            else {
                // 不打标
                self.dispatchTagLabel.isHidden = true
                self.dispatchTagLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.lblDate.snp.bottom).offset(WH(0))
                    make.height.equalTo(WH(0))
                })
            }
            
            // 起订量
            var strMinBuy: String! = nil
            if item.doorsill != nil, item.doorsill.intValue > 0 {
                // 有返回起订量
                if item.unitName != nil, item.unitName.isEmpty == false {
                    strMinBuy = "满\(item.doorsill!.intValue)\(item.unitName!):"
                }
                else {
                    strMinBuy = "满\(item.doorsill!.intValue):"
                }
            }
            else {
                // 未返回起订量
                if item.unitName != nil, item.unitName.isEmpty == false {
                    strMinBuy = "每\(item.unitName!):"
                }
            }
            self.lblMinBuy.text = strMinBuy
            
            // 价格
            var strPrice: String = "¥"
            if item.originalPrice != nil {
                if item.discountMoney != nil {
                    // 有返回节省金额
                    let priceFinal = item.originalPrice.floatValue - item.discountMoney.floatValue
                    //strPrice = "¥\(priceFinal)"
                    strPrice = String.init(format: "¥%.2f", priceFinal)
                }
                else {
                    // 未返回节省金额
                    //strPrice = "¥\(item.originalPrice.floatValue)"
                    strPrice = String.init(format: "¥%.2f", item.originalPrice.floatValue)
                }
            }
            //self.lblPrice.text = strPrice
            let att = NSMutableAttributedString.init(string: strPrice)
            att.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(18)), NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C)], range: NSMakeRange(0, att.length))
            att.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12))], range: NSMakeRange(0, 1))
            self.lblPrice.attributedText = att
            
            // 单位
//            if item.unitName != nil, item.unitName.isEmpty == false {
//                self.lblUnit.text = item.unitName
//            }
//            else {
//                self.lblUnit.text = nil
//            }

            // 数量
            let number = item.getProductNumber()
            self.lblNumber.text = "x" + "\(number)"
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Private
    
    
}
