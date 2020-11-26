//
//  RCSendAddressView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/21.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  回寄信息之地址视图

import UIKit

class RCSendAddressView: UIView {
    // MARK: - Property
    
    // 内容视图
    fileprivate lazy var viewContent: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = .white
        
        // 上分隔线
        let viewLineTop = UIView()
        viewLineTop.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        // 下分隔线
        let viewLineBottom = UIView()
        viewLineBottom.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "商家收货地址"
        return lbl
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        return lbl
    }()
    
    // 手机号
    fileprivate lazy var lblPhone: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .right
        return lbl
    }()
    
    // 地址
    fileprivate lazy var lblAddress: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.numberOfLines = 4
        lbl.minimumScaleFactor = 0.9
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
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
        backgroundColor = RGBColor(0xF4F4F4)
        
        addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self).offset(WH(10))
            make.bottom.equalTo(self).offset(WH(-10))
        }
        
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(lblName)
        viewContent.addSubview(lblPhone)
        viewContent.addSubview(lblAddress)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(20))
            make.top.equalTo(viewContent).offset(WH(15))
            make.height.equalTo(WH(20))
        }
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(20))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(12))
            make.height.equalTo(WH(20))
        }
        lblPhone.snp.makeConstraints { (make) in
            make.right.equalTo(viewContent).offset(WH(-20))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(12))
            make.left.equalTo(lblName.snp.right).offset(WH(10))
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH/2)
            make.width.greaterThanOrEqualTo(WH(92))
        }
        lblAddress.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(20))
            make.right.equalTo(viewContent).offset(WH(-20))
            make.bottom.equalTo(viewContent).offset(WH(-10))
            make.top.equalTo(lblName.snp.bottom).offset(WH(8))
        }
        
        // 当冲突时，lblPhone不被压缩，lblName可以被压缩
        // 当前lbl抗压缩（不想变小）约束的优先级高
        lblPhone.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        lblName.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 当冲突时，lblPhone不被拉伸，lblName可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblPhone.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblName.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    
    // MARK: - Public
    
    func configView(_ address: String?, _ name: String?, _ phone: String?) {
        lblName.text = name
        lblPhone.text = phone
        lblAddress.text = address
    }
}
