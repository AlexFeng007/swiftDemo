//
//  ShopListCouponCenterCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class ShopListCouponCenterCell: UITableViewCell {
    
    fileprivate lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ShopListCouponBg_icon"))
        return imageView
    }()
    
    // 店铺logo
    lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.layer.shadowColor = UIColor.gray.cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 0)
        iv.layer.shadowOpacity = 1.0
        return iv
    }()
    
    // 名称
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .left
        return label
    }()
    
    // 有效期
    fileprivate lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    // 使用限制
    fileprivate lazy var limitLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.layer.cornerRadius = WH(2)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        return label
    }()
    
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    fileprivate lazy var promotionSignL: PromotionTagLabel = {
        let sign = PromotionTagLabel(frame: CGRect(x: 0, y: 0, width: WH(51), height: WH(15)))
        return sign
    }()
    
    fileprivate lazy var selectedBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: WH(12))
        button.layer.cornerRadius = WH(4)
        button.layer.masksToBounds = true
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let block = strongSelf.clickBlock {
                    block(strongSelf.isGet, strongSelf.isLimit)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate var isGet: Bool = false
    
    fileprivate var isLimit: Bool = false
    
    fileprivate var model: ShopListCouponModel?
    
    var clickBlock: ((Bool,Bool)->())?

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
        selectionStyle = .none
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(14))
            make.top.bottom.equalTo(contentView)
        })
        
        contentView.addSubview(img)
        img.snp.makeConstraints({ (make) in
            make.left.equalTo(self.bgImageView).offset(WH(19))
            make.centerY.equalTo(contentView).offset(-2)
            make.width.equalTo(WH(70))
            make.height.equalTo(WH(70))
        })
        
        contentView.addSubview(promotionSignL)
        promotionSignL.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img.snp.left)
            make.top.equalTo(self.img.snp.top).offset(WH(5))
            make.width.equalTo(WH(51))
            make.height.equalTo(WH(15))
        })
        
        contentView.addSubview(selectedBtn)
        selectedBtn.snp.makeConstraints({ (make) in
            let offset = (SCREEN_WIDTH-WH(28))/4-WH(64)
            make.right.equalTo(self.bgImageView.snp.right).offset(-offset/2)
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(64))
            make.height.equalTo(WH(24))
        })
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.top.equalTo(self.img.snp.top)
            make.right.equalTo(self.selectedBtn.snp.left).offset(-WH(20))
        })
        
        contentView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(2))
            make.right.equalTo(self.selectedBtn.snp.left).offset(-WH(20))
            make.height.equalTo(WH(12))
        })
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.img.snp.bottom)
            make.height.equalTo(WH(18))
        })
        
        contentView.addSubview(limitLabel)
        limitLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.priceLabel.snp.right).offset(WH(8))
            make.bottom.equalTo(self.img.snp.bottom)
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(0))
        })
    }
    
    func configView(_ model: ShopListCouponModel) {
        self.model = model
        
        if let strProductPicUrl = model.shopLogo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.img.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        
        if let limit = model.isLimitProduct {
            switch (limit) {
            case 0:
                promotionSignL.isHidden = false
                promotionSignL.text = "店铺通用"
                promotionSignL.configView(RGBColor(0xFF2D5C))
                isLimit = false
            case 1:
                promotionSignL.isHidden = false
                promotionSignL.text = "部分单品"
                promotionSignL.configView(RGBColor(0xFF8D21))
                isLimit = true
            default:
                promotionSignL.isHidden = true
                break
            }
        }
        if let code = model.couponCode, code.count > 0 {
            isGet = true
            selectedBtn.setTitle("去下单", for: .normal)
            selectedBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xDE23FF), RGBColor(0xFF62F0), WH(64))
            bgImageView.image = UIImage(named: "ShopListCouponBg_selected_icon")
        } else {
            isGet = false
            selectedBtn.setTitle("立即领取", for: .normal)
            selectedBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF2D5C), RGBColor(0xFF5A9B), WH(64))
            bgImageView.image = UIImage(named: "ShopListCouponBg_icon")
        }
        
        titleLabel.text = model.couponName
        if let showTime = model.couponTimeText {
            periodLabel.text = showTime
        }else {
            periodLabel.text = "\(model.begindate!)-\(model.endDate!)"
        }
        priceLabel.text = "￥\(model.denomination  ?? 0)"
        
        let limitStr = "满\(model.limitprice ?? 0)可用"
        limitLabel.text = limitStr
        
        let string = limitStr as NSString
        let width = string.width(with: UIFont.systemFont(ofSize: WH(12)), constrainedToHeight: WH(18))+8
        limitLabel.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
        self.layoutIfNeeded()
    }
}
