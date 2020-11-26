//
//  CODetailSelectCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  通用的详情选择cell...<支付方式、发票>

import UIKit

class CODetailSelectCell: UITableViewCell {
    // MARK: - Property
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "发票信息"
        return lbl
    }()
    
    
    // 内容
    fileprivate lazy var txtfieldContent: UITextField = {
        let txtfield = UITextField()
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .right
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.placeholder = "请选择发票类型"
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请选择发票类型", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.isEnabled = false // 不可激活
        return txtfield
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
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
        selectionStyle = .none
        clipsToBounds = true
        layer.cornerRadius = WH(8)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(txtfieldContent)
        contentView.addSubview(imgviewArrow)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
            make.width.lessThanOrEqualTo(WH(120))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-11))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(7), height: WH(12)))
        }
        txtfieldContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.right).offset(-WH(15))
            make.centerY.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ content: String?) {
       txtfieldContent.text = content
    }
}
