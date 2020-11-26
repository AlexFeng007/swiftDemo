//
//  FKYAddBankCardConfirmCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 绑定按钮点击
let FKY_confirmBtnClicked = "confirmBtnClicked"

/// 选中协议按钮点击
let FKY_selectBtnClicked = "selectBtnClicked"

/// 查看协议按钮点击
let FKY_lookProtocolBtnClicked = "lookProtocolBtnClicked"

class FKYAddBankCardConfirmCell: UITableViewCell {

    /// 查看支持银行事件
    static var FKY_LookBankListAction = "LookBankListAction"
    
    /// 选中协议按钮
    lazy var selecProtocolBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"icon_cart_selected"), for: .selected)
        bt.setBackgroundImage(UIImage(named:"bandingBankCard_selectProtocol_Unselected"), for: .normal)
        bt.addTarget(self, action: #selector(FKYAddBankCardConfirmCell.selectBtnClicked), for: .touchUpInside)
        bt.isSelected = true
        return bt
    }()
    
    /// 查看协议按钮
    lazy var lookProtocolBtn:UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .systemFont(ofSize: WH(12))
        bt.setTitleColor(RGBColor(0xFF2D5D), for: .normal)
        bt.addTarget(self, action: #selector(FKYAddBankCardConfirmCell.lookProtocolBtnClicked), for: .touchUpInside)
        bt.setTitle("《1药城快捷支付协议》", for: .normal)
        return bt
    }()
    
    /// 协议文描
    lazy var protocolDes:UILabel = {
        let lb = UILabel()
        lb.text = "已阅读并同意签署"
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 确定按钮
    lazy var confirmBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("绑定银行卡", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: WH(15))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.addTarget(self, action: #selector(FKYAddBankCardConfirmCell.confirmBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 查看支持的银行按钮
    lazy var lookBankListBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("查看支持的银行", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: WH(12))
        bt.setTitleColor(RGBColor(0x666666), for: .normal)
        bt.setImage(UIImage(named:"seeMore_Icon"),for: .normal)
        //bt.layoutButton(style: .Right, imageTitleSpace: 5)
        bt.addTarget(self, action: #selector(FKYAddBankCardConfirmCell.lookBankListBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - 数据显示
extension FKYAddBankCardConfirmCell {
    func isShowProtocol(_ isShow:Bool){
        guard isShow == false else{// 隐藏的时候才走下面布局
            return
        }
        self.selecProtocolBtn.isHidden = true
        self.protocolDes.isHidden = true
        self.lookProtocolBtn.isHidden = true
        self.lookProtocolBtn.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(WH(0))
            //make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.protocolDes).offset(WH(0))
            make.right.lessThanOrEqualToSuperview().offset(WH(-5))
        }
    }
}

//MARK: - 响应事件
extension FKYAddBankCardConfirmCell {
    
    /// 绑定按钮点击
    @objc func confirmBtnClicked(){
        self.routerEvent(withName: FKY_confirmBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 选中协议按钮点击
    @objc func selectBtnClicked(){
        self.selecProtocolBtn.isSelected = !self.selecProtocolBtn.isSelected
        self.routerEvent(withName: FKY_selectBtnClicked, userInfo: [FKYUserParameterKey:self.selecProtocolBtn.isSelected])
    }
    
    /// 查看协议按钮点击
    @objc func lookProtocolBtnClicked(){
        self.routerEvent(withName: FKY_lookProtocolBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 查看支持银行按钮点击
    @objc func lookBankListBtnClicked(){
        self.routerEvent(withName: FKYAddBankCardConfirmCell.FKY_LookBankListAction, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYAddBankCardConfirmCell {
    
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.selecProtocolBtn)
        self.contentView.addSubview(self.protocolDes)
        self.contentView.addSubview(self.lookProtocolBtn)
        self.contentView.addSubview(self.confirmBtn)
        self.contentView.addSubview(self.lookBankListBtn)
        
        self.selecProtocolBtn.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(14))
            make.left.equalToSuperview().offset(WH(26))
            make.right.lessThanOrEqualToSuperview().offset(WH(-5))
            make.width.height.equalTo(WH(26))
        }
        
        self.protocolDes.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.selecProtocolBtn.snp_right).offset(WH(0))
        }
        
        self.lookProtocolBtn.snp_makeConstraints { (make) in
            //make.top.equalTo(self.selecProtocolBtn.snp_bottom).offset(WH(5))
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.protocolDes.snp_right).offset(WH(0))
            make.right.lessThanOrEqualToSuperview().offset(WH(-5))
        }
        
        self.confirmBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.lookProtocolBtn.snp_bottom).offset(WH(10))
            //make.bottom.equalToSuperview().offset(WH(-10))
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(WH(-30))
            make.height.equalTo(WH(42))
        }
        
        self.lookBankListBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.confirmBtn.snp_bottom).offset(WH(10))
            make.bottom.equalToSuperview().offset(WH(-10))
            make.centerX.equalToSuperview()
            //make.left.equalToSuperview().offset(WH(30))
            //make.right.equalToSuperview().offset(WH(-30))
            //make.height.equalTo(WH(42))
        }
        self.lookBankListBtn.layoutIfNeeded()
        self.lookBankListBtn.layoutButton(style: .Right, imageTitleSpace: 0)
    }
    
    /// 不展示协议时候的布局
    func haveNoLayout(){
        self.selecProtocolBtn.snp_remakeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(14))
            make.left.equalToSuperview().offset(WH(26))
            make.width.height.equalTo(WH(26))
            make.height.equalTo(0)
        }
        
        self.protocolDes.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.selecProtocolBtn.snp_right).offset(WH(0))
            make.height.equalTo(0)
        }
        
        self.lookProtocolBtn.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.protocolDes.snp_right).offset(WH(0))
            make.height.equalTo(0)
        }
    }
}
