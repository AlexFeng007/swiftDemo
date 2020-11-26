//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

class HotSaleCell: UITableViewCell {
    // MARK: - properties
    fileprivate lazy var productTitleLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    fileprivate lazy var productDescLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate lazy var productOwnerLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0xc3c3c3)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate lazy var sellPriceLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0xff2d5c)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        return label
    }()
    
    fileprivate lazy var originPriceLabel: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0xc3c3c3)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate lazy var productImageView: UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var rankingImageView: UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var addCartButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "icon_hone_hotsale_addcart"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            let viewModel = AddCartViewModel(1, stepCount: 2, stockCount: 200, unit: "盒")
            AddCartPanelView.show(withViewModel: viewModel, {
                
            })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - ui
    func setupView() {
        addCartButton.isHidden = true
        originPriceLabel.isHidden = true
        
        contentView.addSubview(productImageView)
        productImageView.addSubview(rankingImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(productDescLabel)
        contentView.addSubview(productOwnerLabel)
        contentView.addSubview(sellPriceLabel)
        contentView.addSubview(originPriceLabel)
        contentView.addSubview(addCartButton)
        productImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WH(80), height: WH(80)))
            make.left.equalTo(contentView).offset(WH(13))
            make.top.equalTo(contentView).offset(WH(15))
            make.bottom.equalTo(contentView).offset(WH(-20))
        }
        
        rankingImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(productImageView)
        }
        
        productTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(18))
            make.left.equalTo(productImageView.snp.right).offset(WH(14))
            make.right.equalTo(contentView).offset(-WH(10))
        }
        
        productDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.right.equalTo(contentView).offset(-WH(10))
            make.top.equalTo(productTitleLabel.snp.bottom).offset(WH(5))
        }
        
        productOwnerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.right.equalTo(contentView).offset(-WH(10))
            make.top.equalTo(productDescLabel.snp.bottom).offset(WH(5))
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xe5e5e5)
        contentView.addSubview(line)
        sellPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.top.equalTo(productOwnerLabel.snp.bottom).offset(WH(10))
            make.bottom.equalTo(line.snp.top).offset(WH(-15))
        }
        
        originPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sellPriceLabel.snp.right).offset(WH(8))
            make.centerY.equalTo(sellPriceLabel)
        }
        
        addCartButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(17))
            make.centerY.equalTo(contentView)
        }

        line.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
}

// MARK: - delegates
extension  HotSaleCell {
    
}

// MARK: - action
extension  HotSaleCell {
    
}

// MARK: - data
extension  HotSaleCell {
    func config(withModel model: HotSaleModel, atIndexPath indexPath: IndexPath) {
        productImageView.sd_setImage(with: URL.init(string: model.showpic!.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!), placeholderImage: productImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(80), height: WH(80))))
        if indexPath.row <= 2 {
            rankingImageView.isHidden = false
            rankingImageView.image = UIImage.init(named: "icon_home_hotsale_No\(indexPath.row+1)")
        } else {
            rankingImageView.isHidden = true
        }
        
        productTitleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - WH(107) - WH(48)
        productTitleLabel.text = model.shortName
        productDescLabel.text = model.spec!
        productOwnerLabel.text = model.factoryName
        sellPriceLabel.text = model.showPrice
        if model.priceFlag == 0 {
            sellPriceLabel.font = UIFont.systemFont(ofSize: WH(12))
        } else {
            sellPriceLabel.font = UIFont.boldSystemFont(ofSize: WH(14))
        }
//        let priceString = NSMutableAttributedString.init(string: "￥17.9")
//        priceString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
//        originPriceLabel.attributedText = priceString
    }
}

// MARK: - ui
extension  HotSaleCell {
    
}

// MARK: - private methods
extension  HotSaleCell {
    
}
