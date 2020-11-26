//
//  RDCProductListCell.swift
//  FKY
//
//  Created by 寒山 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之商品cell

import UIKit

class RCDProductListCell: UITableViewCell {
    
    // 商品图片
    fileprivate lazy var imageV: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "image_default_img"))
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    // 商品名称
    fileprivate lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    // 退换货数量
    fileprivate lazy var numL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.textAlignment = .right
        return label
    }()
    
    // 购买总数
    fileprivate lazy var amountL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.textAlignment = .left
        return label
    }()
    
    // 下分隔线
    fileprivate lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 上分隔线
    fileprivate lazy var lineTopV: UIView = {
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
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = RGBColor(0xffffff)
        
        contentView.addSubview(imageV)
        contentView.addSubview(titleL)
        contentView.addSubview(amountL)
        contentView.addSubview(numL)
        contentView.addSubview(lineV)
        contentView.addSubview(lineTopV)
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(20))
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(WH(76))
        }
    
        numL.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(15))
            make.centerY.equalTo(contentView)
        }
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.right.equalTo(numL.snp.left).offset(-WH(10))
            make.centerY.equalTo(contentView.snp.centerY).offset(WH(-14))
        }
        
        amountL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.right.equalTo(numL.snp.left).offset(-WH(15))
            make.top.equalTo(titleL.snp.bottom).offset(WH(10))
        }
        
        lineV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        lineTopV.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        // 顶部分隔线默认隐藏
        lineTopV.isHidden = true
        
        // 当冲突时，numL不被压缩，titleL可以被压缩
        // 当前lbl抗压缩（不想变小）约束的优先级高
        numL.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        titleL.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，numL不被拉伸，titleL可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        numL.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        titleL.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    func configCell(_ model: Any?) {
        guard let obj = model else {
            return
        }
        
        if (obj as AnyObject).isKind(of:RCRmaDetailInfoModel.self) {
            // 退换货详情中的商品model
            let item: RCRmaDetailInfoModel = obj as! RCRmaDetailInfoModel
            // 名称
            titleL.text = item.goodsName
            // 总购买数量
            let amount = item.amount
            amountL.text =  "已购买" + amount! + "件"
            // 退换货数量
            let rmaCount = item.rmaCount
            numL.attributedText  = self.amountString(rmaCount!)
            // 图片
            imageV.sd_setImage(with: URL(string: (item.img)!), placeholderImage: UIImage(named: "image_default_img"))
        }
        else if (obj as AnyObject).isKind(of:FKYOrderProductModel.self) {
            // 退换货提交界面之弹出视图中的商品model
            let item: FKYOrderProductModel = obj as! FKYOrderProductModel
            // 名称
            titleL.text = item.productName
            // 总购买数量
            if let amount = item.quantity {
                let value = Int(amount)
                amountL.text =  "已购买" + "\(value)" + "件"
            }
            else {
                amountL.text = nil
            }
            // 退换货数量
            let rmaCount = item.steperCount
            numL.attributedText  = self.amountString("\(rmaCount)")
            // 图片
            imageV.sd_setImage(with: URL(string: (item.productPicUrl)!), placeholderImage: UIImage(named: "image_default_img"))
        }
    }
    
    // 底部分隔线是否显示
    func showBottomLine(_ showFlag: Bool) {
        lineV.isHidden = !showFlag
    }
    
    // 顶部分隔线是否显示
    func showTopLine(_ showFlag: Bool) {
        lineTopV.isHidden = !showFlag
    }
    
    fileprivate func amountString(_ amount:String) -> (NSMutableAttributedString) {
        let amountTmpl = NSMutableAttributedString()
        
        var amountStr = NSAttributedString(string:"申请")
        amountTmpl.append(amountStr)
        amountTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x999999),
                                 range: NSMakeRange(amountTmpl.length - amountStr.length, amountStr.length))
        
        amountStr = NSAttributedString(string: String(format: " x%@", amount))
        amountTmpl.append(amountStr)
        amountTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x151515),
                                 range: NSMakeRange(amountTmpl.length - amountStr.length, amountStr.length))
        amountTmpl.addAttribute(NSAttributedString.Key.font,
                                 value: FKYBoldSystemFont(WH(12)),
                                 range: NSMakeRange(amountTmpl.length - amountStr.length, amountStr.length))
        
        return amountTmpl
    }
}

