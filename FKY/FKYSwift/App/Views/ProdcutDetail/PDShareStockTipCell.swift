//
//  PDShareStockTipCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  共享库存之弹出视图cell

import UIKit

class PDShareStockTipCell: UITableViewCell {
    // MARK: - Property
    
    // 商品图片
    fileprivate lazy var imgviewProduct: UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = .clear
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 商品名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        //lbl.text = "三九/999 感冒灵颗粒 三九/999 感冒灵颗粒"
        return lbl
    }()
    
    // 规格
    fileprivate lazy var lblSpec: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        //lbl.text = "2000u:700u*10粒*3板"
        return lbl
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .right
        //lbl.text = "¥ 33.95"
        return lbl
    }()
    
    // 厂家
    fileprivate lazy var lblFactory: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        //lbl.text = "曼秀雷敦(中国)药业有限公司"
        return lbl
    }()
    
//    // 提示内容视图
//    fileprivate lazy var viewTip: UIView = {
//        let view = UIView()
//        view.backgroundColor = RGBColor(0xFFF2F2)
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = WH(2)
//
//        // tip
//        view.addSubview(self.lblTip)
//        self.lblTip.snp.makeConstraints { (make) in
//            make.left.equalTo(view).offset(WH(10))
//            make.right.equalTo(view).offset(-WH(10))
//            make.top.bottom.equalTo(view)
//        }
//
//        return view
//    }()
//    // 文字提示
//    fileprivate lazy var lblTip: UILabel = {
//        let lbl = UILabel()
//        lbl.backgroundColor = .clear
//        lbl.font = UIFont.systemFont(ofSize: WH(10))
//        lbl.textColor = RGBColor(0xFF2D5C)
//        lbl.textAlignment = .left
//        //lbl.text = "该商品需从上海进行调拨，预计可发货时间：2019-06-01"
//        lbl.numberOfLines = 2
//        return lbl
//    }()
//    // 向上箭头
//    fileprivate lazy var imgviewTriangle: UIImageView = {
//        let imgview = UIImageView()
//        imgview.backgroundColor = .clear
//        imgview.contentMode = UIViewContentMode.scaleAspectFit
//        imgview.image = UIImage(named: "img_triangle_up")
//        return imgview
//    }()
    
    // 底部分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(imgviewProduct)
        contentView.addSubview(lblName)
        contentView.addSubview(lblPrice)
        contentView.addSubview(lblSpec)
        contentView.addSubview(lblFactory)
//        addSubview(viewTip)
//        addSubview(imgviewTriangle)
        contentView.addSubview(viewLine)
        
        imgviewProduct.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            //make.top.equalTo(self).offset(WH(8))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(80))
            make.height.equalTo(WH(80))
        }
        lblPrice.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(15))
            make.top.equalTo(contentView).offset(WH(18))
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(90))
            make.width.greaterThanOrEqualTo(WH(40))
        }
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(12))
            make.right.equalTo(lblPrice.snp.left).offset(-WH(10))
            make.centerY.equalTo(lblPrice)
            make.height.equalTo(WH(20))
        }
        lblSpec.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(12))
            make.right.equalTo(contentView).offset(-WH(10))
            make.top.equalTo(lblName.snp.bottom).offset(WH(2))
            //make.height.equalTo(WH(16))
        }
        lblFactory.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(12))
            make.right.equalTo(contentView).offset(-WH(10))
            make.top.equalTo(lblSpec.snp.bottom).offset(WH(12))
            //make.height.equalTo(WH(16))
        }
//        viewTip.snp.makeConstraints { (make) in
//            make.left.equalTo(self).offset(WH(15))
//            make.right.equalTo(self).offset(-WH(15))
//            make.bottom.equalTo(self).offset(-WH(18))
//            make.height.equalTo(WH(32))
//        }
//        imgviewTriangle.snp.makeConstraints { (make) in
//            make.left.equalTo(viewTip.snp.left).offset(WH(40))
//            make.bottom.equalTo(viewTip.snp.top)
//            make.width.equalTo(WH(10))
//            make.height.equalTo(WH(4))
//        }
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        // 当冲突时，lblPrice不被压缩，lblName可以被压缩
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblPrice.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblName.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblPrice不被拉伸，lblName可以被拉伸
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblPrice.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        lblName.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    
    // MARK: - Test
    
    func test() {
        // 名称
        lblName.text = "伊可欣 维生素ad滴剂超长超大容量 感冒发烧流鼻涕必血良药"
        
        // 价格
        lblPrice.text = "¥ 68.50"
        changePriceStyle()
        
        // 规格
        lblSpec.text = "2000u:700u*10粒*3板"
        
        // 厂家
        lblFactory.text = "曼秀雷敦(中国)药业有限公司"
        
        // 图片
        imgviewProduct.image = UIImage(named: "image_default_img")
        
        // 提示
//        lblTip.text = "该商品需从上海进行调拨，预计可发货时间：2019-06-01 该商品需从上海进行调拨 敬请关注。"
    }
    
    
    // MARK: - Public
    
    func configCell(_ product: FKYPostphoneProductModel?) {
        guard let model = product else {
            return
        }
        
        // 名称
        lblName.text = model.productName
        
        // 价格
        var price: Float = 0
        if let p = model.productPrice, p > 0 {
            price = p
        }
        lblPrice.text = String(format: "¥ %.2f", price)
        changePriceStyle()
        
        // 规格
        lblSpec.text = model.specification
        
        // 厂家
        lblFactory.text = model.manufactures
        
        // 图片
        if let pUrl = model.productImageUrl, pUrl.isEmpty == false {
            if let url = pUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                imgviewProduct.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage(named: "image_default_img"))
            }
            else {
                imgviewProduct.image = UIImage(named: "image_default_img")
            }
        }
        else {
            imgviewProduct.image = UIImage(named: "image_default_img")
        }
        
        // 提示
//        lblTip.text = model.shareStockVO?.desc
    }
    //购物车中弹框赋值
    func configJHDCell(_ product: FKYCartGroupInfoModel?) {
        guard let model = product else {
            return
        }
        
        // 名称
        lblName.text = model.productName
        
        // 价格
        var price: Float = 0
        if let p = model.productPrice, p.floatValue > 0 {
            price = p.floatValue
        }
        lblPrice.text = String(format: "¥ %.2f", price)
        changePriceStyle()
        
        // 规格
        lblSpec.text = model.specification
        
        // 厂家
        lblFactory.text = model.manufactures
        
        // 图片
        if let pUrl = model.productImageUrl, pUrl.isEmpty == false {
            if let url = pUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                imgviewProduct.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage(named: "image_default_img"))
            }
            else {
                imgviewProduct.image = UIImage(named: "image_default_img")
            }
        }
        else {
            imgviewProduct.image = UIImage(named: "image_default_img")
        }
        
        // 提示
        //        lblTip.text = model.shareStockVO?.desc
    }
    
    // 底部分隔线是否显示
    func showBottomLine(_ showFlag: Bool) {
        viewLine.isHidden = !showFlag
    }
    
    
    // MARk: - Private
    
    // 调整价格展示方式
    fileprivate func changePriceStyle() {
        // 现价
        if let content = lblPrice.text, content.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: content)
            attributedString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor:RGBColor(0x000000)], range: NSRange.init(location: 0, length: content.count))
            attributedString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(10)), NSAttributedString.Key.foregroundColor:RGBColor(0x000000)], range: NSRange.init(location: 0, length: 1))
            lblPrice.attributedText = attributedString
        }
    }
}
