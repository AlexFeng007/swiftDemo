//
//  RCSubmitInfoReasonCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货提交界面之申请原因cell

import UIKit

class RCSubmitInfoReasonCell: UITableViewCell {
    // MARK: - Property
    
    // closure
//    var selectApplyReason: (()->())? // 选择申请原因
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "申请原因"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var txtfieldName: UITextField = {
        let txtfield = UITextField()
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .left
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x666666)
        txtfield.placeholder = "请选择"
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请选择", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.isEnabled = false // 不可输入
        return txtfield
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_pd_arrow_gray")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 按钮
//    fileprivate lazy var btnSelect: UIButton = {
//        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = .clear
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            guard let block = strongSelf.selectApplyReason else {
//                return
//            }
//            block()
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
//        return btn
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(txtfieldName)
        contentView.addSubview(imgviewArrow)
//        addSubview(btnSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(60))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-10))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        txtfieldName.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(0))
            make.centerY.equalTo(contentView)
        }
//        btnSelect.snp.makeConstraints { (make) in
//            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
//            make.right.equalTo(self).offset(WH(-10))
//            make.centerY.equalTo(self)
//            make.height.equalTo(WH(40))
//        }
        
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ reason: RCApplyReasonModel?) {
        guard let model = reason, let name = model.name, name.isEmpty == false else {
            txtfieldName.text = nil
            return
        }
        txtfieldName.text = name
    }
}
