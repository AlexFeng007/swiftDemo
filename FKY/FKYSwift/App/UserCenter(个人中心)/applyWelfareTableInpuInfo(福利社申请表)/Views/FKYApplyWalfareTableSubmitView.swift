//
//  FKYApplyWalfareTableSubmitView.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 提交按钮点击
let FKY_applyWalfareSubmitBtnClicked = "applyWalfareSubmitBtnClicked"

class FKYApplyWalfareTableSubmitView: UIView {

    /// 分割线
    var marginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 提交按钮
    lazy var submitBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("提交申请", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(15))
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(FKYApplyWalfareTableSubmitView.submitBtnclicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK - 响应事件
extension FKYApplyWalfareTableSubmitView{
    
    /// 提交按钮点击
    @objc func submitBtnclicked(){
        self.routerEvent(withName: FKY_applyWalfareSubmitBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
}


//MARK - UI
extension FKYApplyWalfareTableSubmitView{
    func setupUI(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.submitBtn)
        self.addSubview(self.marginLine)
        
        self.marginLine.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.submitBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(WH(-30))
            make.top.equalToSuperview().offset(WH(11))
            make.bottom.equalToSuperview().offset(WH(-11))
            make.height.equalTo(WH(42))
        }
    }
}
