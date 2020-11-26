//
//  FKYCredentialsAddDestrictCell.swift
//  FKY
//
//  Created by airWen on 2017/7/16.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCredentialsAddDestrictCell: UICollectionViewCell {
    //MARK: Property
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    fileprivate lazy var btnAddDestrict: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        button.setTitleColor(RGBColor(0xFE403B), for: UIControl.State())
        button.setTitle("  +新增销售区域  ", for: UIControl.State())
        return button
    }()
    
    //MARK: Public Proeprty
    var addDestrictClosure : emptyClosure?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        //make.left.equalTo(self.contentView).offset(16)
        super.init(frame: frame)
        
        self.backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
            make.centerY.equalTo(self.contentView.snp.centerY)
        })
        
        btnAddDestrict.addTarget(self, action: #selector(onBtnAddDestrict(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnAddDestrict)
        btnAddDestrict.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.top.bottom.equalTo(self.contentView)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: User Action
    @objc func onBtnAddDestrict(_ sender: UIButton) {
        if let addDestrictClosure = self.addDestrictClosure {
            addDestrictClosure()
        }
    }
    //MARK: Public Method
    func configCell(_ title: String?){
        titleLabel.text = title
    }
    
}
