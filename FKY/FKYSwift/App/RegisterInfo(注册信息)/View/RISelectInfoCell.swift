//
//  RISelectInfoCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]文字输入界面之点击选择ccell

import UIKit

class RISelectInfoCell: UITableViewCell {
    // MARK: - Property
    
    // 用户点击当前cell中btn的回调block
    var callback: ( (RITextInputType)->(Void) )?
    
    // cell类型...<默认为所在地区>
    var cellType: RITextInputType = .enterpriseArea
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        //txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .default
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.systemFont(ofSize: WH(14))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = ""
        //txtfield.tintColor = RGBColor(0xFF2D5C)
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        //txtfield.setValue(UIFont.systemFont(ofSize: WH(13)), forKeyPath: "_placeholderLabel.font")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        //txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtfield.isEnabled = false // 禁止输入...<只作展示>
        return txtfield
    }()
    
    // 箭头
    fileprivate lazy var imgviewArrow: UIImageView! = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "img_pd_arrow_gray")
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    // 选择btn
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.callback else {
                return
            }
            block(strongSelf.cellType)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
        
        contentView.addSubview(lblStar)
        contentView.addSubview(lblTitle)
        contentView.addSubview(imgviewArrow)
        contentView.addSubview(txtfield)
        contentView.addSubview(btnSelect)
        
        lblStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(110))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-WH(10))
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        txtfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(132))
            make.right.equalTo(imgviewArrow.snp.left).offset(-WH(8))
            make.height.equalTo(WH(36))
        }
        btnSelect.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(txtfield.snp.left).offset(0)
        }
    }
}


extension RISelectInfoCell {
    //
    func configCell(_ show: Bool, _ type: RITextInputType, _ content: String?) {
        guard show else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 保存类型
        cellType = type
        // 赋值
        txtfield.text = content
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        txtfield.placeholder = type.typeDescription
        
        txtfield.attributedPlaceholder = NSAttributedString.init(string: type.typeDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        
        // 箭头
//        imgviewArrow.isHidden = false
//        if type == .enterpriseName || type == .enterpriseNameRetail {
//            imgviewArrow.isHidden = true
//        }
        
        // 是否必填...<必填显示星号>
        lblStar.isHidden = !type.typeInputMust
        if lblStar.isHidden {
            // 非必填
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(15))
            }
        }
        else {
            // 必填...<显示星号>
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(22))
            }
        }
        layoutIfNeeded()
    }
}
