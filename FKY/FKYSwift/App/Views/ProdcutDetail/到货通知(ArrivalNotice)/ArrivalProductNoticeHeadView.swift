//
//  ArrivalProductNoticeHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/10.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ArrivalProductNoticeHeadCell: UITableViewCell {
    
    var changePhoneNumText: ( (String?)->() )?
    var changeProductNumText: ( (String?)->() )?
    var sendArrivalNoticeAction: emptyClosure?
    //白色背景
    fileprivate lazy var bgContentView: UIView = {
        let view = UIView ()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    //缺货商品
    fileprivate lazy var stockOutView: StockOutProductView = {
        let view = StockOutProductView ()
        return view
    }()
    
    //分割线
    fileprivate lazy var topLineView: UIView = {
        let view = UIView ()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    fileprivate lazy var centerLineView: UIView = {
        let view = UIView ()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    fileprivate lazy var bottomLineView: UIView = {
        let view = UIView ()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    lazy var phoneNumInputView:ArrivalProductNoticeInputView = {
        let inputView = ArrivalProductNoticeInputView()
        inputView.initView(.userPhoneType)
        inputView.changeText = { [weak self] (txt) in
            guard let strongSelf = self else {
                return
            }
            // 保存内容
            strongSelf.updateSubmitBtnStatus()
            if let block = strongSelf.changePhoneNumText{
                block(txt)
            }
        }
        return inputView
    }()
    
    lazy var productNumInputView:ArrivalProductNoticeInputView = {
        let inputView = ArrivalProductNoticeInputView()
        inputView.initView(.productNumInfoType)
        inputView.changeText = { [weak self] (txt) in
            guard let strongSelf = self else {
                return
            }
            // 保存内容
            strongSelf.updateSubmitBtnStatus()
            if let block = strongSelf.changeProductNumText{
                block(txt)
            }
        }
        return inputView
    }()
    /// 提交按钮容器视图
    lazy var containerSubmitView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    /// 提交按钮
    lazy var submitButton:UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xFFABBD), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        //btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setTitleColor(UIColor.white, for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("提交", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block =  strongSelf.sendArrivalNoticeAction{
                block()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.text = "— 根据上述商品，为您推荐相似商品如下 —"
        return lbl
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(bgContentView)
        bgContentView.addSubview(stockOutView)
        bgContentView.addSubview(topLineView)
        bgContentView.addSubview(centerLineView)
        bgContentView.addSubview(bottomLineView)
        
        bgContentView.addSubview(phoneNumInputView)
        bgContentView.addSubview(productNumInputView)
        bgContentView.addSubview(containerSubmitView)
        containerSubmitView.addSubview(submitButton)
        contentView.addSubview(lblTip)
        
        bgContentView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(WH(9))
            make.right.equalTo(contentView).offset(WH(-9))
            make.bottom.equalTo(contentView).offset(WH(-44))
        }
        stockOutView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(bgContentView)
            make.height.equalTo(WH(0))
        }
        topLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(stockOutView.snp.bottom)
            make.height.equalTo(0.5)
        }
        productNumInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(topLineView.snp.bottom)
            make.height.equalTo(WH(50))
        }
        
        centerLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(productNumInputView.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        phoneNumInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(centerLineView.snp.bottom)
            make.height.equalTo(WH(50))
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(phoneNumInputView.snp.bottom)
            make.height.equalTo(0.5)
        }
        self.containerSubmitView.snp_makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(bottomLineView.snp.bottom)
            make.height.equalTo(WH(62))
        }
        
        self.submitButton.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(WH(11))
            make.height.equalTo(WH(42))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(WH(-15))
            make.height.equalTo(WH(14))
        }
    }
    func configView(_ product: HomeCommonProductModel?,_ phoneNum:String?,_ productNum:String?,_ unit: String?,_ hasRecommend:Bool?) {
        if let _ = product{
            stockOutView.configView(product)
            topLineView.isHidden = false
            stockOutView.snp.updateConstraints { (make) in
                make.height.equalTo(StockOutProductView.getCellContentHeight(product))
            }
        }else{
            topLineView.isHidden = true
            stockOutView.configView(nil)
            stockOutView.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
        }
        if hasRecommend == true{
            lblTip.isHidden = false
        }else{
            lblTip.isHidden = true
        }
        phoneNumInputView.configView(.userPhoneType, phoneNum)
        productNumInputView.configView(.productNumInfoType, productNum, unit)
        self.updateSubmitBtnStatus()
    }
    //获取行高
    @objc static func getCellContentHeight(_ product: HomeCommonProductModel?) -> CGFloat{
        var Cell = WH(220)
        if let _ = product{
            Cell += StockOutProductView.getCellContentHeight(product)
        }
        return Cell
    }
    // 实时更新提交按钮状态
    fileprivate func updateSubmitBtnStatus() {
        // 电话号码
        guard let phoneNum = phoneNumInputView.getContent(), phoneNum.isEmpty == false else {
            submitButton.isEnabled = false
            return
        }
        // 数量
        guard let productNum = productNumInputView.getContent(), productNum.isEmpty == false else {
            submitButton.isEnabled = false
            return
        }
        // 可点击
        submitButton.isEnabled = true
    }
}
class ArrivalProductNoticeInputView: UIView {
    var changeText: ( (String?)->() )?
    var beginEditing: emptyClosure?
    var endEditing: emptyClosure?
    
    // view类型
    var cellType: ArrivalNoticeTextInputType = .productNumInfoType
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 输入框
    fileprivate lazy var txtfield: UITextField = {
        let txtfield = UITextField()
        txtfield.delegate = self
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.keyboardType = .default
        txtfield.returnKeyType = .done
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x333333)
        txtfield.autocapitalizationType = .none
        txtfield.autocorrectionType = .no
        txtfield.clearButtonMode = .whileEditing
        txtfield.placeholder = ""
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x9F9F9F)])
        txtfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return txtfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
        
        self.addSubview(lblTitle)
        self.addSubview(txtfield)
        
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(60))
        }
        txtfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(85))
            make.right.equalTo(self).offset(-WH(15))
            make.height.equalTo(WH(36))
        }
    }
    
}
extension ArrivalProductNoticeInputView {
    //
    func initView(_ type: ArrivalNoticeTextInputType) {
        // 显示
        self.isHidden = false
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        txtfield.placeholder = type.typeDescription
        txtfield.keyboardType = type.typeKeyboard
        
        txtfield.attributedPlaceholder = NSAttributedString.init(string: type.typeDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0xCCCCCC)])
        
        layoutIfNeeded()
    }
    func configView(_ type: ArrivalNoticeTextInputType,_ content:String?, _ productUnit:String? = ""){
        if type == .userPhoneType{
            txtfield.placeholder = type.typeDescription
            txtfield.text = content
        }else if type == .productNumInfoType{
            if productUnit?.isEmpty == false{
                txtfield.placeholder = type.typeDescription + String(format: "(%@)",productUnit ?? "")
            }else{
                txtfield.placeholder = type.typeDescription
            }
            txtfield.text = content
        }
    }
    //
    func getContent() -> String? {
        guard let content = txtfield.text, content.isEmpty == false else {
            return nil
        }
        // 去左右空格
        let txt = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return txt
    }
}


extension ArrivalProductNoticeInputView {
    // 仅可输入数字
    class func onlyInputTheNumber(_ string: String) -> Bool {
        let numString = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: string)
        return number
    }
}


extension ArrivalProductNoticeInputView: UITextFieldDelegate {
    // 监听UITextField变化
    @objc func textfieldDidChange(_ textField: UITextField) {
        // 有未选中的字符
        if let selectedRange = textField.markedTextRange, let newText = textField.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
        
        // 过滤空格
        if let txt = textField.text, txt.isEmpty == false {
            // 先判断是否有包含空格
            if (txt as NSString).contains(" ") {
                textField.text = txt.replacingOccurrences(of: " ", with: "")
            }
        }
        
        if cellType == .userPhoneType || cellType == .productNumInfoType{
            // 过滤掉非数字
            if let txt = textField.text, txt.isEmpty == false {
                if !RITextInputCell.onlyInputTheNumber(txt) {
                    // 包含非数字
                    textField.text = NSString.getPureNumber(txt)
                }
            }
        }
        
        // 字数限制
        if let content = textField.text, content.isEmpty == false {
            // 有输入
            let count = cellType.typeNumberMax
            if content.count >= count + 1 {
                textField.text = (content as NSString).substring(to: count)
            }
        }
        
        // 回调
        if let block = changeText {
            block(textField.text)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let closure = beginEditing {
            closure()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let closure = endEditing {
            closure()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
// 资料管理之输入框类型
enum ArrivalNoticeTextInputType: Int {
    // 所有类型
    case productNumInfoType = 0             // 合数输入
    case userPhoneType = 1             // 填写手机号
    
    
    // 标题
    var typeName: String {
        switch self {
        case .productNumInfoType:
            return "采购数："
        case .userPhoneType:
            return "手机号："
        }
    }
    // 描述
    var typeDescription: String {
        switch self {
        case .productNumInfoType:
            return "填写数量"
        case .userPhoneType:
            return "填写手机号码"
        }
    }
    // 是否必填
    var typeInputMust: Bool {
        switch self {
        case .productNumInfoType:
            return false
        case .userPhoneType:
            return false
        }
    }
    
    // 输入框最大可输入字数
    var typeNumberMax: Int {
        switch self {
        case .productNumInfoType:
            return 50
        case .userPhoneType:
            return 12
        }
    }
    // 输入框键盘类型
    var typeKeyboard: UIKeyboardType {
        switch self {
        case .productNumInfoType:
            return .numberPad
        case .userPhoneType:
            return .numberPad
        }
    }
}
