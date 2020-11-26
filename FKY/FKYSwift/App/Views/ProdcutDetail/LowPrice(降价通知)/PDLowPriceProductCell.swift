//
//  PDLowPriceProductCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class PDLowPriceProductCell: UITableViewCell {
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
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    //商品基本信息
    fileprivate lazy var baseInfoView: ProductBaseInfoView = {
        let view = ProductBaseInfoView()
        return view
    }()
    //商品价格信息
    fileprivate lazy var priceInfoView: ProductPriceInfoView = {
        let view = ProductPriceInfoView()
        return view
    }()
    //商品促销信息
    fileprivate lazy var promationInfoView: ProductPromationInfoView = {
        let view = ProductPromationInfoView()
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
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(15))
            make.left.equalTo(contentView).offset(WH(15))
            make.width.height.equalTo(WH(100))
        })
        contentView.addSubview(baseInfoView)
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(WH(15))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-22))
            make.height.equalTo(0)
        })
        contentView.addSubview(promationInfoView)
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-13))
            make.height.equalTo(0)
        })
        
        contentView.addSubview(vendorLabel)
        vendorLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-13))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.height.equalTo(WH(12))
        })
        
        contentView.addSubview(priceInfoView)
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.top).offset(WH(-7))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.height.equalTo(0)
        })
    }
    func configCell(_ model: FKYProductObject) {
        
        if let strProductPicUrl = model.mainImg?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.imgView.image = UIImage.init(named: "image_default_img")
        }
        // 标题
        var name = ""
        if let pdName = model.shortName, pdName.isEmpty == false {
            name = pdName
        }
        if let spec = model.spec, spec.isEmpty == false {
            name = name + " " + spec
        }
        baseInfoView.configCell(model)
        baseInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
        })
        promationInfoView.showPromotionIcon(model)
        promationInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
        })
        
        //        let attributedString = ProductBaseInfoView.getProductTitleAttrStr(name,Int(model.isZiYingFlag), model.ziyingWarehouseName)
        //        titleLabel.attributedText = attributedString
        //        let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(121), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
        //        titleLabel.snp.updateConstraints({ (make) in
        //            make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
        //        })
        self.vendorLabel.text = model.sellerName ?? ""
        priceInfoView.configCell(model)
        priceInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
        })
    }
    //获取行高
    static func  getCellContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? FKYProductObject {
            var Cell = WH(15)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > WH(130)) ? Cell:WH(130)
            return Cell
        }
        return 0
    }
}
