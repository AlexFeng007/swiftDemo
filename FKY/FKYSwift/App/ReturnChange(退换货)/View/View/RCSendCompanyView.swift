//
//  RCSendCompanyView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  回寄信息之快递公司视图

import UIKit

class RCSendCompanyView: UIView {
    // MARK: - Property
    
    // closure
    var selectSendCompany: (()->())? // 选择快递公司
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "快递公司"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var txtfieldName: UITextField = {
        let txtfield = UITextField()
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .right
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.placeholder = "选择快递公司"
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "选择快递公司", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.isEnabled = false
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
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectSendCompany else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(lblTitle)
        addSubview(txtfieldName)
        addSubview(imgviewArrow)
        addSubview(btnSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(20))
            make.centerY.equalTo(self)
            make.width.equalTo(WH(60))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-15))
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        txtfieldName.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(0))
            make.centerY.equalTo(self)
        }
        btnSelect.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(self).offset(WH(-20))
            make.centerY.equalTo(self)
            make.height.equalTo(WH(40))
        }
        
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(20))
            make.right.equalTo(self).offset(WH(-20))
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ company: RCSendCompanyModel?) {
        guard let model = company else {
            txtfieldName.text = nil
            return
        }
        txtfieldName.text = model.carrierName
    }
}
