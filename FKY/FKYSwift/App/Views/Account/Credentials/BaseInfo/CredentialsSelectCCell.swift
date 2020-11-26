//
//  CredentialsSelectCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2017/11/2.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  编辑／修改地址界面之选择地区ccell

import UIKit
import SnapKit

class CredentialsSelectCCell: UICollectionViewCell {
    //MARK: - Property
    
    // 标题...<不可压缩，不可拉伸>
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    // 箭头
    fileprivate lazy var indicatorView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_account_black_arrow")
        return iv
    }()
    
    // 内容...<可压缩，可拉伸>
    fileprivate lazy var contentTxtfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请填写"
        //tf.setValue(RGBColor(0x9F9F9F), forKeyPath: "_placeholderLabel.textColor")
        tf.attributedPlaceholder = NSAttributedString.init(string: "请填写", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(15)), NSAttributedString.Key.foregroundColor: RGBColor(0x9F9F9F)])
        tf.textColor = RGBColor(0x343434)
        tf.font = UIFont.systemFont(ofSize: WH(15))
        tf.textAlignment = .right
        tf.isEnabled = false // 不可输入
        tf.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
        tf.setContentHuggingPriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
        return tf
    }()
    
    //MARK: - Lift Circle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    func setupView() {
        self.backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(j5)
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-5))
            make.width.height.equalTo(WH(25))
            make.centerY.equalTo(self.contentView)
        })

        self.contentView.addSubview(contentTxtfield)
        contentTxtfield.snp.makeConstraints({ (make) in
            make.right.equalTo(self.indicatorView.snp.left).offset(2)
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.titleLabel.snp.right).offset(j1)
        })
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xD8D8D8)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(j5)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(0.6)
        })
    }
    
    //MARK: - Public Method
    func configCell(_ title: String, content: String?) {
        self.titleLabel.text = title
        self.contentTxtfield.text = content
    }
}
