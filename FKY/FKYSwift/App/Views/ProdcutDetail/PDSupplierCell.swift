//
//  PDSupplierCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之供应商cell
//  说明：商详不再使用当前cell

import UIKit

class PDSupplierCell: UITableViewCell {
    //MARK: - Property
    
    // closure
    var gotoShop: (()->())? // 进入店铺
    
    // 供应商
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .left
        return label
    }()
    
    // icon
    fileprivate lazy var imgviewIcon: UIImageView! = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "img_pd_supplier")
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    // 进入店铺
    fileprivate lazy var btnShop: UIButton! = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = .clear
        btn.setTitle("进入店铺", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.setTitleColor(RGBColor(0x999999), for: .normal)
        btn.setTitleColor(UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1), for: .highlighted)
        //btn.setImage(UIImage.init(named: "img_pd_group_arrow"), for: .normal)
        btn.setImage(UIImage.init(named: "img_pd_arrow_gray"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: -WH(120))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: WH(10))
        btn.bk_addEventHandler({ [weak self] (btn) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.gotoShop {
                closure()
            }
            }, for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupView()
        //test()
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
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(imgviewIcon)
        contentView.addSubview(lblTitle)
        contentView.addSubview(btnShop)
        
        imgviewIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(10))
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        
        btnShop.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(WH(5))
            make.size.equalTo(CGSize.init(width: WH(110), height: WH(38)))
        }
        
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(imgviewIcon.snp.right).offset(WH(7))
            make.right.equalTo(btnShop.snp.left).offset(WH(30))
        }
        
        // 下分隔线
        let viewLineBottom = UIView.init()
        viewLineBottom.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    //MARK: - Public
    
    func configCell(_ title: String?) {
        guard let title = title else {
            lblTitle.text = nil
            lblTitle.isHidden = true
            return
        }
        
        lblTitle.text = title
        lblTitle.isHidden = false
    }
    
    // 
    func settingCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        lblTitle.text = model.sellerName ?? ""
    }
}
