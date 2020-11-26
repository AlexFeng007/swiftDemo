//
//  FKYSelectItemQuantityView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商品数量选择

import UIKit

class FKYSelectItemQuantityView: UIView {

    /// 减少商品数量
    static let FKY_ProductNumberDownAction = "ProductNumberDownAction"
    /// 增加商品数量
    static let FKY_ProductNumberUpAction = "ProductNumberUpAction"
    /// 完成输入数量  用户手动输入商品数量时候触发
    static let FKY_InputProductNumberAction = "InputProductNumberAction"
    /// 展示错误信息
    static let FKY_PopErrorMsgAction = "PopErrorMsgAction"
    
    /// 当前商品的model
    var productModel:FKYProductModel = FKYProductModel()
    
    /// 减少按钮
    lazy var downBtn: UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "btn_pd_minus_gray"), for: .normal)
        bt.addTarget(self, action: #selector(FKYSelectItemQuantityView.downBtnClicked), for: .touchUpInside)
        return bt
    }()

    /// 增加按钮
    lazy var upBtn: UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "icon_jia_new"), for: .normal)
        bt.addTarget(self, action: #selector(FKYSelectItemQuantityView.upBtnClicked), for: .touchUpInside)
        return bt
    }()

    /// 数量输入框
    lazy var numberInputTF: UITextField = {
        let tf = UITextField()
        tf.text = ""
        tf.delegate = self
        tf.keyboardType = .numberPad;
        tf.backgroundColor = RGBColor(0xF6F6F6)
        tf.layer.cornerRadius = WH(4)
        tf.layer.masksToBounds = true
        tf.textAlignment = .center
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 数据展示
extension FKYSelectItemQuantityView {
    
    /// 显示商品数量
    func showProductNum(_ num:Int){
        self.numberInputTF.text = "\(num)"
    }
    
    /// 展示商品信息
    func showProductInfo(product:FKYProductModel){
        self.productModel = product
        self.numberInputTF.text = "\(self.productModel.preBuyNum)"
        
        if self.productModel.isMinimumBuyNum {
            self.downBtn.setBackgroundImage(UIImage(named:"btn_pd_minus_gray"), for: .normal)
        }else{
            self.downBtn.setBackgroundImage(UIImage(named:"icon_jian_new"), for: .normal)
        }
        
        if self.productModel.isMaximumBuyNum {
            self.upBtn.setBackgroundImage(UIImage(named:"btn_pd_add_gray"), for: .normal)
        }else{
            self.upBtn.setBackgroundImage(UIImage(named:"icon_jia_new"), for: .normal)
        }
    }
}

//MARK: - 事件响应
extension FKYSelectItemQuantityView {

    /// 数量减按钮点击
    @objc func downBtnClicked() {
        if self.productModel.isMinimumBuyNum {
            return
        }
        self.routerEvent(withName: FKYSelectItemQuantityView.FKY_ProductNumberDownAction, userInfo: [FKYUserParameterKey: (self.productModel,1,"")])
    }

    /// 数量加按钮点击
    @objc func upBtnClicked() {
        if self.productModel.isMaximumBuyNum {
            return
        }
        self.routerEvent(withName: FKYSelectItemQuantityView.FKY_ProductNumberUpAction, userInfo: [FKYUserParameterKey: (self.productModel,2,"")])
    }

    /// 用户完成数量输入
    @objc func inputNumAction() {
        self.routerEvent(withName: FKYSelectItemQuantityView.FKY_InputProductNumberAction, userInfo: [FKYUserParameterKey: (self.productModel,3,self.numberInputTF.text ?? "0")])
    }

    /// 弹出错误信息
    func popErrorMsg(msg:String){
        self.routerEvent(withName: FKYSelectItemQuantityView.FKY_PopErrorMsgAction, userInfo: [FKYUserParameterKey: msg])
    }

}

//MARK: - 私有方法
extension FKYSelectItemQuantityView {
    
}

//MARK: - UITextField代理
extension FKYSelectItemQuantityView: UITextFieldDelegate {

    /// 文本有变动
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: string)
        if !isValid {
            self.popErrorMsg(msg: "只能输入正整数")
            return false
        }
        return true
    }
    /// 结束编辑
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputNumAction()
    }
}

//MARK - UI
extension FKYSelectItemQuantityView {
    
    func setupUI(){
        self.addSubview(self.downBtn)
        self.addSubview(self.upBtn)
        self.addSubview(self.numberInputTF)
        
        self.downBtn.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(5))
            make.top.equalToSuperview().offset(WH(5))
            make.bottom.equalToSuperview().offset(WH(-5))
            make.width.equalTo(self.downBtn.snp_height).multipliedBy(1)
        }
        
        self.upBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-5))
            make.top.equalToSuperview().offset(WH(5))
            make.bottom.equalToSuperview().offset(WH(-5))
            make.width.equalTo(self.upBtn.snp_height).multipliedBy(1)
        }
        
        self.numberInputTF.snp_makeConstraints { (make) in
            make.left.equalTo(self.downBtn.snp_right).offset(WH(18))
            make.right.equalTo(self.upBtn.snp_left).offset(WH(-18))
            //make.centerY.equalToSuperview().offset(WH(5))
            //make.bottom.equalToSuperview().offset(WH(5))
            make.top.equalToSuperview().offset(WH(5))
            make.bottom.equalToSuperview().offset(WH(-5))
        }
    }
}
