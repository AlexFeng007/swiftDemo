//
//  RebateDetailController.swift
//  FKY
//
//  Created by 寒山 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  返利金详情列表

import UIKit

class RebateDetailController: UIViewController {
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    
    var rebateDetailListModel = FKYRebateDetailViewModel()
    
    var rebateRecordType: FKYRebateRecordType = .FKYRebateRecordTypeTotal
    
    lazy var rebateRecordVC: DelayRebateDetailController = { [weak self] in
        let vc = DelayRebateDetailController()
        vc.rebateRecordType = self?.rebateRecordType ?? .FKYRebateRecordTypeTotal
        vc.rebateRecordBlock = { [weak self](balance) in
            self?.balanceView.bindBalance(balance)
        }
        return vc
        }()
    
    lazy var balanceView: FKYBalanceView = { [weak self] in
        if (self?.rebateRecordType == .FKYRebateRecordTypeTotal) {
            let view = FKYBalanceView(frame: CGRect.zero, type: .FKYBalanceTypeTotal)
            return view
        } else {
            let view = FKYBalanceView(frame: CGRect.zero, type: .FKYBalanceTypePending)
            return view
        }}()
    
    lazy var tableTitleLabel: UILabel = { [weak self] in
        let lb = UILabel()
        if (self?.rebateRecordType == .FKYRebateRecordTypeTotal) {
            lb.text = "累计明细"
        } else {
            lb.text = "待到账明细"
        }
        lb.font = t7.font
        lb.textColor = RGBColor(0x999999)
        return lb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestData()
        self.requestRebateDetailList()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xffffff)
        
        if(rebateRecordType == .FKYRebateRecordTypeTotal) {
          fky_setupTitleLabel("累计余额")
        }else if(rebateRecordType == .FKYRebateRecordTypePending) {
           fky_setupTitleLabel("待到账余额")
        }
        
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(balanceView)
        balanceView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(WH(107))
        }
        
        let titleBg = UIView()
        titleBg.backgroundColor = RGBColor(0xF2F2F2)
        view.addSubview(titleBg)
        titleBg.addSubview(tableTitleLabel)
        titleBg.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(balanceView.snp.bottom)
            make.height.equalTo(WH(52))
        }
        tableTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(15))
            make.right.equalToSuperview().offset(WH(-15))
            make.bottom.equalTo(titleBg.snp.bottom).offset(WH(-10))
        }
        
        addChild(rebateRecordVC)
        view.addSubview(rebateRecordVC.view)
        rebateRecordVC.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(titleBg.snp.bottom)
        }
    }
    
    func requestData() -> Void {
        rebateRecordVC.shouldFirstLoadData()
    }
}

//MARK: - 网络请求
extension RebateDetailController{
    func requestRebateDetailList(){
        self.rebateDetailListModel.requestRebateInfo { (isSuccess, msg) in
            guard isSuccess else{
                self.toast(msg)
                return
            }
            self.balanceView.showTopTipWithType(type: self.rebateDetailListModel.isShareRebate)
        }
    }
}

