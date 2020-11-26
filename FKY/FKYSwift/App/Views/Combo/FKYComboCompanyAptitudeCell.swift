//
//  FKYComboCompanyAptitudeCell.swift
//  FKY
//
//  Created by Andy on 2018/10/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  企业资质cell

import UIKit

class FKYComboCompanyAptitudeCell: UICollectionViewCell {
    var _CompanyName : String?
    var CompanyName : String? {
        set {
            _CompanyName = newValue
            CompanyNameLabel.text = newValue
        }
        get {
            return _CompanyName
        }
    }
    
    fileprivate lazy var backView : UIView = {
        let view = UIView.init()
        view.backgroundColor = .white
        view.layer.cornerRadius = WH(21)
        
        return view
    }()
    
    fileprivate lazy var CompanyNameLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.textColor = RGBColor(0x333333)
        label.text = self.CompanyName
        return label
    }()
    
    fileprivate lazy var AptitudeButton : UIButton = {
        let button  = UIButton.init(type: UIButton.ButtonType.custom)
        let font = UIFont.boldSystemFont(ofSize: WH(12))
        let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x999999)]
        button.setAttributedTitle(NSAttributedString.init(string: "企业资质", attributes: attributes), for: UIControl.State.normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(40), bottom: 0, right: 0)
        button.setImage(UIImage.init(named: "紫色箭头"), for: UIControl.State.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: WH(50), bottom: 0, right: 0)
        button.addTarget(self, action: #selector(onAptitudeButtonClick(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var companyAptitudeDetailBlock: emptyClosure?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.contentView.addSubview(self.backView)
        backView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(contentView)
        }
        
        self.backView.addSubview(self.CompanyNameLabel)
        CompanyNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(21))
            make.top.equalTo(contentView.snp.top).offset(WH(9))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(9))
            make.right.equalTo(contentView.snp.right).offset(-WH(100))
        }
        
        self.backView.addSubview(self.AptitudeButton)
        AptitudeButton.snp.makeConstraints { (make) in
            make.width.equalTo(WH(70))
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(6))
        }
        
    }
    
    // MARK: -Private method
    @objc func onAptitudeButtonClick(_ sender: UIButton) {
        if self.companyAptitudeDetailBlock != nil {
            self.companyAptitudeDetailBlock!()
        }
        
    }
    
    
}
