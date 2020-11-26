//
//  FKYInvoiceInfoInputCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

///发票信息输入完成
let FKY_endInputInvoiceInfo = "endInputInvoiceInfo"

///弹出银行选择器
let FKY_popBankSelector = "popBankSelector"

class FKYInvoiceInfoInputCell: UITableViewCell {

    ///cellModel
    var cellModel = FKYInvoiceCellModel()
    ///输入信息
    lazy var inputTitleLB:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(13.0))
        label.textColor = RGBColor(0x333333)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    ///信息输入框
    lazy var inputTF:UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = .systemFont(ofSize: WH(13))
        return tf
    }()
    
    ///右边按钮附件
    lazy var accessoryBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "invoice_clearBtn_icon"), for: .normal)
        btn.addTarget(self, action: #selector(clearTFText), for: .touchUpInside)
        btn.isHidden = true
        btn.setEnlargeEdgeWith(top: 10, right: 10, bottom: 10, left: 10)
        return btn
    }()
    
    ///下方分割线附件
    lazy var accessoryButtonMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
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

//MARK: - 用户事件响应
extension FKYInvoiceInfoInputCell{
    
}

//MARK: - 刷新数据
extension FKYInvoiceInfoInputCell{
    func showData(cellData:FKYInvoiceCellModel){
        self.cellModel = cellData
        self.inputTitleLB.text = cellData.titleName
        self.inputTF.text = cellData.inputText
        self.accessoryButtonMarginLine.isHidden = cellData.isHiddenMarginLine
        self.inputTF.isUserInteractionEnabled = cellData.isCanEditer
        if cellData.isCanEditer {
            self.inputTF.textColor = RGBColor(0x333333)
        }else{
            self.inputTF.textColor = RGBColor(0x999999)
        }
//        self.inputTF.placeholder = cellData.inputHolder
        self.inputTF.attributedPlaceholder = holderAttr(cellData.inputHolder)
        if cellData.AccessoryType == .bottomLine {
//            accessoryButtonMarginLine.isHidden = false
            TNFCellLayout()
        }else if cellData.AccessoryType == .phoneCellType{
            self.accessoryBtn.setBackgroundImage(UIImage(named: "invoice_clearBtn_icon"), for: .normal)
            accessoryBtn.isUserInteractionEnabled = true
//            accessoryButtonMarginLine.isHidden = false
        }else if cellData.AccessoryType == .bankCellTypr{
            accessoryBtn.isHidden = false
//            accessoryButtonMarginLine.isHidden = false
            bankCellLayout()
        }else{
            normalCellLayout()
        }
    }
    
    ///占位文描富文本
    func holderAttr (_ text:String) -> NSAttributedString{
        let att = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x999999), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(13))])
        return att
    }
}

//MARK: - UITextFieldDelegate
extension FKYInvoiceInfoInputCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.accessoryBtn.isHidden = false
        ///弹出银行选择器
        if self.cellModel.AccessoryType == .bankCellTypr{
            self.routerEvent(withName: FKY_popBankSelector, userInfo: [FKYUserParameterKey:""])
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.cellModel.AccessoryType != .bankCellTypr {
            self.accessoryBtn.isHidden = true
        }
        self.cellModel.inputText = textField.text ?? ""
        self.routerEvent(withName: FKY_endInputInvoiceInfo, userInfo: [FKYUserParameterKey:[self.cellModel.paramKey:self.inputTF.text ?? ""]])
        
    }
    
    @objc func clearTFText(){
        self.inputTF.text = ""
        self.routerEvent(withName: FKY_endInputInvoiceInfo, userInfo: [FKYUserParameterKey:[self.cellModel.paramKey:self.inputTF.text ?? ""]])
    }
    
}

//MARK: - UI
extension FKYInvoiceInfoInputCell {
    
    func setupView(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(inputTitleLB)
        self.contentView.addSubview(inputTF)
        self.contentView.addSubview(accessoryBtn)
        self.contentView.addSubview(accessoryButtonMarginLine)
        
        inputTitleLB.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(15))
        }
        
        inputTF.snp_makeConstraints { (make) in
            make.centerY.equalTo(inputTitleLB)
            make.left.equalTo(inputTitleLB.snp_right).offset(WH(18))
            make.right.equalTo(accessoryBtn.snp_left).offset(WH(-11))
        }
        
        accessoryBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(inputTitleLB)
            make.right.equalTo(self.contentView).offset(WH(-13))
            make.width.height.equalTo(WH(16))
        }
        
        accessoryButtonMarginLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(accessoryBtn)
            make.left.equalTo(inputTitleLB)
            make.height.equalTo(0.5)
        }
    }
    
    ///常规cell布局方案
    func normalCellLayout(){
        accessoryBtn.isUserInteractionEnabled = true
        self.accessoryBtn.setBackgroundImage(UIImage(named: "invoice_clearBtn_icon"), for: .normal)
//        accessoryButtonMarginLine.isHidden = true
        inputTF.snp_remakeConstraints { (make) in
            make.centerY.equalTo(inputTitleLB)
            make.left.equalTo(inputTitleLB.snp_right).offset(WH(18))
            make.right.equalTo(self.contentView).offset(WH(-16))
        }
    }
    
    ///税号布局方案
    func TNFCellLayout(){
        accessoryBtn.isUserInteractionEnabled = true
        accessoryButtonMarginLine.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
        
        inputTF.snp_remakeConstraints { (make) in
            make.centerY.equalTo(inputTitleLB)
            make.left.equalTo(inputTitleLB.snp_right).offset(WH(18))
            make.right.equalTo(self).offset(WH(-16))
        }
    }
    
    ///退款中银行cell的布局
    func saleReturnLayout(){
        accessoryButtonMarginLine.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.left.equalTo(inputTitleLB)
            make.height.equalTo(0.5)
        }
    }
    
    ///银行布局方案
    func bankCellLayout(){
        accessoryBtn.isUserInteractionEnabled = false
        accessoryBtn.setBackgroundImage(UIImage(named: "icon_account_black_arrow"), for: .normal)
    }
    
    ///获取行高
    static func getCellHeight() -> CGFloat{
        return WH(38.0)
    }
}

fileprivate var rectNameKey:(Character?,Character?,Character?,Character?)

extension UIButton
{
    func setEnlargeEdgeWith(top:CGFloat,right:CGFloat,bottom:CGFloat,left:CGFloat)
    {
        objc_setAssociatedObject(self, &rectNameKey.0, top, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &rectNameKey.1, right, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &rectNameKey.2, bottom, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &rectNameKey.3, left, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let topEdge = objc_getAssociatedObject(self, &rectNameKey.0) as? CGFloat,
            let rightEdge = objc_getAssociatedObject(self, &rectNameKey.1) as? CGFloat,
            let bottomEdge = objc_getAssociatedObject(self, &rectNameKey.2) as? CGFloat,
            let leftEdge = objc_getAssociatedObject(self, &rectNameKey.3) as? CGFloat
        {
            return CGRect(x: bounds.origin.x - leftEdge, y: bounds.origin.y - topEdge, width: bounds.width + leftEdge + rightEdge, height: bounds.height + topEdge + bottomEdge).contains(point) ? self : nil
        }
        return super.hitTest(point, with: event)
    }
}
