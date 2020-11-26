//
//  FKYQualificationInfoSectionHeader.swift
//  FKY
//
//  Created by airWen on 2017/7/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYQualificationInfoSectionHeader: UICollectionReusableView {
    //MARK: Property
    fileprivate lazy var lblTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0x343434)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    fileprivate lazy var viewDecorate : UIView = {
        let v: UIView = UIView()
        v.backgroundColor = RGBColor(0x3580FA)
        return v
    }()
    
    fileprivate lazy var lblRightTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textColor = RGBColor(0xFF394E)
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var imgArrow : UIImageView = {
        let iamgeView = UIImageView()
        iamgeView.image = UIImage(named: "icon_account_black_arrow")
        iamgeView.backgroundColor = UIColor.clear
        return iamgeView
    }()
    
    fileprivate lazy var touchMask : UIControl = {
        let control = UIControl()
        control.backgroundColor = UIColor.clear
        return control
    }()
    
    //MARK: Property
    var didSelectedClosure : emptyClosure?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.addSubview(viewDecorate)
        viewDecorate.snp.makeConstraints({ (make) in
            make.width.equalTo(3)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(0.38)
            make.leading.equalTo(self.snp.leading).offset(WH(14))
        })
        
        self.addSubview(imgArrow)
        imgArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-2)
        })
        
        self.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(viewDecorate.snp.trailing).offset(WH(4))
        })
        
        self.addSubview(lblRightTitle)
        lblRightTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(imgArrow.snp.leading)
            make.leading.greaterThanOrEqualTo(lblTitle.snp.trailing).offset(8)
        })
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        self.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
            make.leading.equalTo(self.snp.leading).offset(16)
        })
        
        touchMask.addTarget(self, action: #selector(onTouchMask(_:)), for: .touchUpInside)
        self.addSubview(touchMask)
        touchMask.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(title: String, rightTitle: String?, canEdit: Bool) {
        lblTitle.text = title
        
        if let rightTitle = rightTitle, rightTitle != "" {
            lblRightTitle.text = rightTitle
            lblRightTitle.isHidden = false
        }else {
            lblRightTitle.isHidden = true
        }
        imgArrow.isHidden = !canEdit
    }
    
    //MARK: User Action
    @objc func onTouchMask(_ sender: UIControl) {
        if let didSelectedClosure = self.didSelectedClosure {
            didSelectedClosure()
        }
    }
}
