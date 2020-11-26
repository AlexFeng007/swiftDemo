//
//  FKYAddBankCardInputCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 提示按钮点击事件
//let FKY_tipsButtonClicked = "tipsButtonClicked"

/// 输入框完成编辑
let FKY_inputTFEndEdit = "inputTFEndEdit"

class FKYAddBankCardInputCell: UITableViewCell {

    /// 相机识别银行卡
    static let FKY_ocrButtonClicked = "ocrButtonClicked"
    /// 监控当前输入框是输入还是删除 1 输入 2 删除
    var inputType = 0
    
    /// 上一次输入的长度
    var lastCount = 0
    
    ///上方分割线
    var topMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        view.isHidden = true
        return view
    }()
    
    ///下方分割线
    var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    /// title文描
    lazy var titleDesLabel:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize:WH(13))
        return lb
    }()
    
    /// 输入框右侧删除按钮
    lazy var clearBtn:UIButton = {
        let bt  = UIButton()
        bt.setBackgroundImage(UIImage(named:"bandingBankCard_Clear_Icon"), for: .normal)
        bt.addTarget(self, action: #selector(FKYAddBankCardInputCell.clearBtnClicked), for: .touchUpInside)
        bt.frame = CGRect(x: 0, y: 0, width: WH(16), height: WH(16))
        return bt
    }()
    
    /// 输入框
    lazy var inputTF:UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.attributedPlaceholder = NSAttributedString.init(string:" ", attributes: [.font:UIFont.systemFont(ofSize:WH(12)),.foregroundColor:RGBColor(0xCCCCCC)])
        tf.font = .systemFont(ofSize: WH(13))
        tf.rightView = self.clearBtn
        tf.rightViewMode = .whileEditing
        return tf
    }()
    
    /// 提示按钮
    lazy var tipsButton:UIButton = {
        let bt = UIButton()
        //bt.setBackgroundImage(UIImage(named:"addBankCard_tipIcon"), for: .normal)
        bt.setBackgroundImage(UIImage(named:"bank_card_scan"), for: .normal)
        bt.addTarget(self, action: #selector(FKYAddBankCardInputCell.tipsButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// cell数据
    var cellModel = FKYAddBankCardCellModel()
    
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

//MARK: - 数据展示
extension FKYAddBankCardInputCell {
    func configCell(cellModel:FKYAddBankCardCellModel){
        self.cellModel = cellModel
        self.defaultLayout()
        
        if self.cellModel.isLastCell {
            self.layoutLastCell()
            self.bottomMarginLine.isHidden = true
        }else{
            self.bottomMarginLine.isHidden = false
        }
        
        if self.cellModel.showTipBtn == true{
            
        }else{
            self.haveNoTipsButtonLayout()
        }
        
        if self.cellModel.paramKey == "idCardNo" , self.cellModel.inputText.isEmpty == false,self.cellModel.inputText.count > 8 {// 身份证号码打星星
            let startIndex = self.cellModel.inputText.index(self.cellModel.inputText.startIndex, offsetBy: 6)
            let endIndex = self.cellModel.inputText.index(self.cellModel.inputText.endIndex, offsetBy: -5)
            let ranges = startIndex...endIndex
            let replaceText = self.cellModel.inputText.replacingCharacters(in: ranges, with: "********")
            self.inputTF.text = self.inserSpeaceInIDCardNUM(IDNum: replaceText)
        }else if self.cellModel.paramKey == "bankCardNo" ,self.cellModel.isNeedMSK == false, self.cellModel.inputText.isEmpty == false,self.cellModel.inputText.count > 8{
            
            self.inputTF.text = self.insertSpeaceWithFourCharacter(str: self.cellModel.inputText)
        }
        else{
            self.inputTF.text = self.cellModel.inputText
        }
        
        self.titleDesLabel.text = self.cellModel.titleText
        self.inputTF.placeholder = self.cellModel.holderText
        
        if self.cellModel.isCanInput == true {
            self.inputTF.isUserInteractionEnabled = true
            self.titleDesLabel.textColor = RGBColor(0x333333)
            self.inputTF.textColor = .black
        }else{
            self.inputTF.isUserInteractionEnabled = false
            self.titleDesLabel.textColor = RGBColor(0x999999)
            self.inputTF.textColor = RGBColor(0x999999)
        }
        
        if self.cellModel.paramKey == "bankCardNo" {// 银行卡
            self.inputTF.keyboardType = .numberPad
        }else if self.cellModel.paramKey == "mobile"{// 手机号
            self.inputTF.keyboardType = .numberPad
        }
    }
}

//MARK: - 事件响应
extension FKYAddBankCardInputCell {
    
    /// 提示按钮点击
    @objc func tipsButtonClicked(){
        self.routerEvent(withName: FKYAddBankCardInputCell.FKY_ocrButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 清空按钮点击
    @objc func clearBtnClicked(){
        self.inputTF.text = ""
    }
}

//MARK: - 私有方法
extension FKYAddBankCardInputCell {
    
    /// 每4个字符插入一个空格
    func insertSpeaceWithFourCharacter(str:String) -> String{
        var returnStr = str
        var startOffset = 4
        while startOffset < returnStr.count {
            let insertIndex = returnStr.index(returnStr.startIndex, offsetBy: startOffset)
            returnStr.insert(" ", at: insertIndex)
            startOffset += 5
        }
        return returnStr
    }
    
    /// 按照身份证规则插入空格
    func inserSpeaceInIDCardNUM(IDNum:String) -> String{
        var returnStr = IDNum
        let insertOffset1 = 6
        let insertOffset2 = 15
        guard IDNum.count >= insertOffset1 else{
            return IDNum
        }
        let insertIndex1 = IDNum.index(IDNum.startIndex, offsetBy: insertOffset1)
        returnStr.insert(" ", at: insertIndex1)
        
        guard IDNum.count >= insertOffset2 else{
            return returnStr
        }
        
        let insertIndex2 = IDNum.index(IDNum.startIndex, offsetBy: insertOffset2)
        returnStr.insert(" ", at: insertIndex2)
        return returnStr
    }
}

//MARK: - UITextField代理
extension FKYAddBankCardInputCell:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if #available(iOS 13.0, *){
            return true
        }
        
        let markRange = textField.markedTextRange
        
        guard markRange == nil else{
            return true
        }
        
        var inputText = textField.text ?? ""

        if inputText.count >= self.lastCount {// 输入
            /// 插入空格
            if self.cellModel.paramKey == "idCardNo" {// 身份证
                let paramterStr = inputText.replacingOccurrences(of: " ", with: "")
                if paramterStr.count>=18,string.isEmpty == false{
                    self.lastCount = inputText.count
                    return false
                }
                inputText = self.inserSpeaceInIDCardNUM(IDNum: paramterStr)
            }else if self.cellModel.paramKey == "bankCardNo"{// 银行卡
                let paramterStr = inputText.replacingOccurrences(of: " ", with: "")
                inputText = self.insertSpeaceWithFourCharacter(str: paramterStr)
            }else if self.cellModel.paramKey == "mobile" {// 手机号
                if inputText.count>=11,string.isEmpty == false{
                    self.lastCount = inputText.count
                    return false
                }
            }
        }else if inputText.count < self.lastCount{// 删除的时候不做处理
            
        }
        self.lastCount = inputText.count
        textField.text = inputText
        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var inputText = textField.text ?? ""
        let markRange = textField.markedTextRange
        
        guard markRange == nil else{
            return 
        }
        
        guard inputText.count != self.lastCount else{
            return
        }
        if inputText.count > self.lastCount {// 输入
            /// 插入空格
            if self.cellModel.paramKey == "idCardNo" {// 身份证
                var paramterStr = inputText.replacingOccurrences(of: " ", with: "")
                while paramterStr.count>18 {
                    paramterStr.removeLast()
                }
                inputText = self.inserSpeaceInIDCardNUM(IDNum: paramterStr)
            }else if self.cellModel.paramKey == "bankCardNo"{// 银行卡
                let paramterStr = inputText.replacingOccurrences(of: " ", with: "")
                inputText = self.insertSpeaceWithFourCharacter(str: paramterStr)
            }else if self.cellModel.paramKey == "mobile" {// 手机号
                if inputText.count>11{
                    while inputText.count>11 {
                        inputText.removeLast()
                    }
                }
            }
        }else if inputText.count < self.lastCount{// 删除的时候不做处理
            
        }
        self.lastCount = inputText.count
        textField.text = inputText
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let inputText = textField.text ?? ""
        let paramterStr = inputText.replacingOccurrences(of: " ", with: "")
        self.cellModel.inputText = paramterStr
        self.routerEvent(withName: FKY_inputTFEndEdit, userInfo: [FKYUserParameterKey:self.cellModel])
    }
}

//MARK: - UI
extension FKYAddBankCardInputCell {
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = RGBColor(0xFFFFFF)
        
        self.contentView.addSubview(self.topMarginLine)
        self.contentView.addSubview(self.titleDesLabel)
        self.contentView.addSubview(self.inputTF)
        self.contentView.addSubview(self.tipsButton)
        self.contentView.addSubview(self.bottomMarginLine)
        
        self.topMarginLine.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.titleDesLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-15))
            make.width.equalTo(WH(57))
        }
        
        self.inputTF.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleDesLabel.snp_right).offset(WH(17))
            //make.centerY.equalTo(self.titleDesLabel)
            make.top.bottom.equalTo(self.titleDesLabel)
            make.right.equalTo(self.tipsButton.snp_left).offset(WH(-16))
        }
        
        self.tipsButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleDesLabel)
            make.right.equalToSuperview().offset(WH(-30))
            make.width.height.equalTo(WH(17))
        }
        
        self.bottomMarginLine.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    /// 恢复初始布局
    func defaultLayout() {
        self.titleDesLabel.snp_updateConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-15))
            make.width.equalTo(WH(57))
        }
        self.tipsButton.snp_updateConstraints { (make) in
            make.width.height.equalTo(WH(16))
        }
    }
    
    /// 最后一个cell 设置距离下方的空白距离
    func layoutLastCell(){
        self.titleDesLabel.snp_updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-23))
        }
        self.tipsButton.snp_updateConstraints { (make) in
            make.width.height.equalTo(WH(16))
        }
    }
    
    /// 没有提示按钮的布局
    func haveNoTipsButtonLayout(){
        self.tipsButton.snp_updateConstraints { (make) in
            make.width.height.equalTo(WH(0))
        }
    }
}
