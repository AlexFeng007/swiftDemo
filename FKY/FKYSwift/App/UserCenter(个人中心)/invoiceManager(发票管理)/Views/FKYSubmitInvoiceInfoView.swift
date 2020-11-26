//
//  FKYSubmitInvoiceInfoView.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

///提交按钮点击事件
let FKY_submitInvoiceInfo = "submitInvoiceInfo"
///查看增资协议
let FKY_checkProtocol = "checkProtocol"
///选中协议按钮点击
let FKY_selectProtocolClicked = "selectProtocolClicked"

class FKYSubmitInvoiceInfoView: UIView {
    
    ///协议选中按钮
    lazy var selectBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "img_pd_select_select"), for: .selected)
//        btn.setBackgroundImage(UIImage(named: "icon_invoice_unselected"), for: .normal)
//        btn.setBackgroundImage(UIImage(named: "icon_invoice_selected"), for: .selected)
        btn.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
        btn.setEnlargeEdgeWith(top: 10, right: 10, bottom: 10, left: 10)
        return btn
    }()
    
    ///描述label
    lazy var desLB:UILabel = {
        let lb = UILabel()
        lb.text = "我已阅读并同意"
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize: WH(13))
        return lb
    }()
    
    ///协议按钮
    lazy var protocolBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("《增票资质确认书》", for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.addTarget(self, action: #selector(protocolButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    ///提交按钮
    lazy var submitBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = WH(4.0)
        btn.layer.masksToBounds = true
        btn.setTitle("提交审核", for: .normal)
        btn.addTarget(self, action: #selector(submitInvoiceInfo), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 事件响应
extension FKYSubmitInvoiceInfoView {
    @objc func submitInvoiceInfo(){
        self.routerEvent(withName: FKY_submitInvoiceInfo, userInfo: [FKYUserParameterKey:""])
    }
    
    ///选中按钮点击
    @objc func selectButtonClicked(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        self.routerEvent(withName: FKY_selectProtocolClicked, userInfo: [FKYUserParameterKey:self.selectBtn.isSelected])
    }
    
    ///协议按钮点击
    @objc func protocolButtonClicked(){
        self.routerEvent(withName: FKY_checkProtocol, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - 刷新数据
extension FKYSubmitInvoiceInfoView {
    func showData(data:FKYInvoiceViewModel){
        if data.invoiceType == .normalInvoiceType{
            nromalInvoiceLayout()
            enableSubmitBtnAction()
        }else{
            if data.invoiceRawData.billStatus == 0 {//从未提交过发票信息
                
            }else{
                nromalInvoiceLayout()
            }
            unableSubmitBtnAction()
        }
    }
    
    ///允许提交按钮点击
    func enableSubmitBtnAction(){
        self.submitBtn.backgroundColor = RGBColor(0xFF2D5C)
        self.submitBtn.setTitleColor(.white, for: .normal)
        self.submitBtn.isUserInteractionEnabled = true
    }
    
    ///不允许提交按钮点击
    func unableSubmitBtnAction(){
        self.submitBtn.isUserInteractionEnabled = false
        self.submitBtn.backgroundColor = RGBColor(0xF4F4F4)
        self.submitBtn.setTitleColor(RGBColor(0xCCCCCC), for: .normal)
    }
}

//MARK: - UI
extension FKYSubmitInvoiceInfoView {
    func setupView(){
        
        self.backgroundColor = RGBColor(0xFFFFFF)
        
        self.addSubview(submitBtn)
        self.addSubview(selectBtn)
        self.addSubview(desLB)
        self.addSubview(protocolBtn)
        
        selectBtn.snp_makeConstraints { (make) in
            make.left.equalTo(submitBtn)
            make.top.equalTo(self).offset(WH(10))
            make.width.height.equalTo(WH(17))
        }
        
        desLB.snp_makeConstraints { (make) in
            make.left.equalTo(selectBtn.snp_right).offset(WH(7))
            make.centerY.equalTo(selectBtn)
        }
        
        protocolBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(selectBtn)
            make.left.equalTo(desLB.snp_right)
        }
        
        submitBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(30))
            make.right.equalTo(self).offset(WH(-30))
            make.top.equalTo(selectBtn.snp_bottom).offset(WH(11))
            make.bottom.equalTo(self).offset(WH(-10))
        }
    }
    
    ///普票的布局
    func nromalInvoiceLayout(){
        selectBtn.snp_updateConstraints { (make) in
            make.top.equalTo(self).offset(WH(0))
            make.height.equalTo(0)
        }
        desLB.isHidden = true
        protocolBtn.isHidden = true
//        desLB.snp_remakeConstraints { (make) in
//            make.left.equalTo(selectBtn.snp_right).offset(WH(7))
//            make.centerY.equalTo(selectBtn)
//            make.height.equalTo(0)
//        }
//
//        protocolBtn.snp_remakeConstraints { (make) in
//            make.centerY.equalTo(selectBtn)
//            make.left.equalTo(desLB.snp_right)
//            make.height.equalTo(0)
//        }
        
    }
}
