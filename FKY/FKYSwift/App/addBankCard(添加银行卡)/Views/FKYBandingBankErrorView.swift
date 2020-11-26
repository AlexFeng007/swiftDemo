//
//  FKYBandingBankErrorView.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 绑定银行卡失败

import UIKit

/// 我知道了按钮点击
let FKY_knowButtonClicked = "knowButtonClicked"

///关闭验证码弹窗

class FKYBandingBankErrorView: UIView {
    /// 顶部title
    lazy var titleDesLB:UILabel = {
        let lb = UILabel()
        lb.text = "绑定银行卡失败"
        lb.textColor = RGBColor(0x000000)
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: WH(18))
        return lb
    }()
    
    /// 关闭按钮
    lazy var closeBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"btn_pd_group_close"), for: .normal)
        bt.addTarget(self, action: #selector(FKYBandingBankErrorView.closeVerificationView), for: .touchUpInside)
        return bt
    }()
    
    /// 上方分割线
    lazy var topMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    
    /// 下方分割线
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 失败原因
    lazy var errorLabel:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize:WH(14))
        lb.textColor = RGBColor(0x666666)
        lb.numberOfLines = 0
        return lb
    }()
    
    /// 确定按钮
    lazy var confirmBtn:UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(15))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.setTitle("我知道了", for: .normal)
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(FKYBandingBankErrorView.confirmBtnClicked), for: .touchUpInside)
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

// MARK: - 数据展示
extension FKYBandingBankErrorView{
    
    ///展示错误原因
    func showError(error:String){
        self.errorLabel.text = error
    }
    //通用其他类型提示
    func showTipsForCommon(_ tips:String,_ title:String){
        self.errorLabel.text = tips
        self.titleDesLB.text = title
    }
}

// MARK: - 事件响应
extension FKYBandingBankErrorView{
    
    /// 我知道了按钮点击
    @objc func confirmBtnClicked(){
        self.routerEvent(withName: FKY_knowButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 关闭错误弹窗
    @objc func closeVerificationView(){
        self.routerEvent(withName: FKY_closeVerificationView, userInfo: [FKYUserParameterKey:""])
    }
}

// MARK: - UI
extension FKYBandingBankErrorView{
    func setupUI(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.layer.cornerRadius = WH(4)
        self.layer.masksToBounds = true
        
        self.addSubview(self.titleDesLB)
        self.addSubview(self.closeBtn)
        self.addSubview(self.topMarginLine)
        self.addSubview(self.bottomMarginLine)
        self.addSubview(self.errorLabel)
        self.addSubview(self.confirmBtn)
        
        self.titleDesLB.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(WH(56))
        }
        
        self.closeBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-17))
            make.centerY.equalTo(self.titleDesLB)
            make.height.width.equalTo(WH(30))
        }
        
        self.topMarginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.titleDesLB.snp_bottom)
            make.height.equalTo(1)
        }
        
        self.errorLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(18))
            make.right.equalToSuperview().offset(WH(-18))
            make.top.equalTo(self.topMarginLine.snp_bottom).offset(WH(15))
        }
        
        self.confirmBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(17))
            make.right.equalToSuperview().offset(WH(-17))
            make.bottom.equalTo(self).offset(WH(-9))
            make.height.equalTo(42)
        }
        
        self.bottomMarginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.confirmBtn.snp_top).offset(WH(-9))
            make.height.equalTo(1)
        }
    }
}
