//
//  PDFixedGroupNumberView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/3/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详(固定)套餐之套餐数量控制视图...<section footer>

import UIKit

class PDFixedGroupNumberView: UIView {
    // MARK: - Property
    
    // closure
    var addCallback: CartStepperViewClousre? // 加
    var minusCallback: CartStepperViewClousre? // 减
    var validateTextinputCallback: CartStepperViewClousre? // 检测输入合法性
    var updateRealTimeCallback: PDGroupStepperViewUpdateClousre?
    
    // 套餐model
    var group: FKYProductGroupModel?
    
    //每周限购数量
    fileprivate lazy var lblUnit: UILabel! = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(8)
        label.layer.masksToBounds = true
        return label
    }()
    
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x000000)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.text = "购买数量"
        return label
    }()
    
    // 数量输入控件
    fileprivate lazy var stepper: PDGroupStepperView! = {
        let view = PDGroupStepperView()
        //view.changeStepperColor(.white)
        view.addCallback = { (currentCount: Int) -> Void in
            self.addCallback!(currentCount)
        }
        view.minusCallback = { (currentCount: Int) -> Void in
            self.minusCallback!(currentCount)
        }
        view.validateTextinputCallback = { (currentCount: Int) -> Void in
            self.validateTextinputCallback!(currentCount)
        }
        view.updateRealTimeCallback = { (currentCount: Int, msg: String?) -> Void in
            self.updateRealTimeCallback!(currentCount, msg)
        }
        return view
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
        backgroundColor = RGBColor(0xF7F7F7)
        addSubview(lblUnit)
        addSubview(lblTitle)
        addSubview(stepper)
        // 标题
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(17))
            make.left.equalTo(self.snp.left).offset(WH(11))
            make.height.equalTo(WH(16))
        }
        
        // 每周限购
        lblUnit.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(15))
            make.right.equalTo(self.snp.right).offset(-WH(11))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(80))
        }
        // 数量输入控件
        stepper.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-WH(17))
            make.top.equalTo(self.snp.top).offset(WH(50))
        }
        // 分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    // 配置view
    func configView(_ group: FKYProductGroupModel? , _ index: Int) {
        self.group = group
        if let item = group {
            // 有传商品数据
            lblUnit.isHidden = true
            lblUnit.text = ""
            if let perNum = item.maxBuyNumPerDay,perNum.intValue > 0 {
                lblUnit.isHidden = false
                lblUnit.text = "每日限购\(perNum.intValue)套"
                let _ = lblUnit.adjustTagLabelContentInset(WH(6))
            }
            // 设置数量及状态
            self.stepper.updateStepperNumber(withCount: item.getGroupNumber())
            self.stepper.enableAddButton(item.checkAddBtnStatus())
            self.stepper.enableMinusButton(item.checkMinusBtnStatus())
            self.stepper.minimum = 1
            self.stepper.maximum = item.getMaxGroupNumber()
        }
    }
    
    // 更新套餐数量
    func updateGroupNumber(_ number: Int) {
        if let item = group {
            item.groupNumber = number
            self.stepper.updateStepperNumber(withCount: item.getGroupNumber())
            self.stepper.enableAddButton(item.checkAddBtnStatus())
            self.stepper.enableMinusButton(item.checkMinusBtnStatus())
            self.stepper.minimum = 1
            self.stepper.maximum = item.getMaxGroupNumber()
        }
    }
    
    
    // MARK: - Private
    
    
}
