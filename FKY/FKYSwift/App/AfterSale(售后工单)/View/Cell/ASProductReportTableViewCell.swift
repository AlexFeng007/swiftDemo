//
//  ASProductReportTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/5/8.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class ASProductReportTableViewCell: UITableViewCell {

    // MARK: - Property
    // closure
    var selectBlock: (()->())? // 选择完回调
    // 单选按钮
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectBlock else {
                // block不能为空
                return
            }
            block()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // 商品图片
   fileprivate lazy var productImg: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        return lbl
    }()
    // 批号
//    fileprivate lazy var spuNumLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.backgroundColor = .clear
//        lbl.font = t11.font
//        lbl.textColor = RGBColor(0x999999)
//        lbl.textAlignment = .left
//        return lbl
//    }()
    // 商品数量
    fileprivate lazy var productNumLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = t11.font
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        return lbl
    }()
    // 分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(btnSelect)
        btnSelect.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(4))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(30), height: WH(30)))
        }
        contentView.addSubview(productImg)
        productImg.snp.makeConstraints { (make) in
            make.left.equalTo(btnSelect.snp.right).offset(WH(10))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(70), height: WH(70)))
        }
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(19))
            make.left.equalTo(productImg.snp.right).offset(WH(17))
            make.right.equalTo(contentView.snp.right).offset(WH(-5))
            make.height.equalTo(WH(14))
        }
//        contentView.addSubview(spuNumLabel)
//        spuNumLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(lblTitle.snp.bottom).offset(WH(11))
//            make.left.equalTo(lblTitle.snp.left)
//            make.right.equalTo(contentView.snp.right).offset(WH(-5))
//            make.height.equalTo(WH(12))
//        }
        contentView.addSubview(productNumLabel)
        productNumLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(17))
            make.left.equalTo(lblTitle.snp.left)
            make.right.equalTo(contentView.snp.right).offset(WH(-5))
            make.height.equalTo(WH(12))
        }
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
}

extension ASProductReportTableViewCell {
    // 配置cell
    func configCell(_ productModel:ASApplyBaseProductModel) {
        self.productImg.image = UIImage.init(named: "image_default_img")
        if  let urlStr = productModel.productPicUrl , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImg.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        lblTitle.text = productModel.productName
        //spuNumLabel.text = "批号：\(productModel.batchNo ?? "")"
        productNumLabel.text = "商品数量：\(productModel.productCount ?? 0)"
    }
    
    // 选中状态
    func setSelectedStatus(_ selected: Bool) {
        btnSelect.isSelected = selected
    }
}
