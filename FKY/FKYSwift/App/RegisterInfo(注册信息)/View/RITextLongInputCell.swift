//
//  RITextLongInputCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/11.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]文字输入界面之长文字输入ccell

import UIKit

class RITextLongInputCell: UITableViewCell {
    // MARK: - Property
    
    var changeText: ( (String?, CGFloat, Bool)->() )?
    var beginEditing: ( ()->() )?
    var endEditing: ( ()->() )?
    
    // cell类型...<默认为企业详细地址>
    var cellType: RITextInputType = .enterpriseAddress
    
    //
    var dicHeight: Dictionary<Int, CGFloat> =
        [ RITextInputType.enterpriseAddress.rawValue: cellHeightInput,
          RITextInputType.enterpriseAddressRetail.rawValue: cellHeightInput,
          RITextInputType.receiveAddress.rawValue: cellHeightInput,
          RITextInputType.saleAddress.rawValue: cellHeightInput ]
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 输入框
    fileprivate lazy var txtview: UITextView = {
        let view = UITextView.init(frame: CGRect.zero)
        view.delegate = self
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.keyboardType = .default
        view.returnKeyType = .done
        view.font = UIFont.systemFont(ofSize: WH(14))
        view.textColor = RGBColor(0x333333)
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        //view.textContainerInset = UIEdgeInsetsMake(WH(2), 0 , 0, 0)
        //view.layoutManager.allowsNonContiguousLayout = false
        return view
    }()
    
    // 提示
    var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x999999).withAlphaComponent(0.6)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblStar)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblTip)
        contentView.addSubview(txtview)
        
        // 居中
        lblStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(110))
        }
        lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(132))
        }
        
        // 居上
//        lblStar.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView).offset(WH(16))
//            make.left.equalTo(contentView).offset(WH(15))
//        }
//        lblTitle.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView).offset(WH(16))
//            make.left.equalTo(contentView).offset(WH(15))
//            make.width.lessThanOrEqualTo(WH(100))
//        }
//        lblTip.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView).offset(WH(16))
//            make.left.equalTo(contentView).offset(WH(124))
//        }
        
        txtview.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(128))
            make.right.equalTo(contentView).offset(-WH(15))
            make.top.equalTo(contentView).offset(WH(9))
            make.bottom.equalTo(contentView).offset(-WH(7))
            make.height.equalTo(WH(30))
        }
    }
}


extension RITextLongInputCell {
    //
    func configCell(_ show: Bool, _ type: RITextInputType, _ content: String?) {
        guard show else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 保存类型
        cellType = type
        // 赋值
        txtview.text = content
        
        if let txt = content, txt.isEmpty == false {
            lblTip.isHidden = true
        }
        else {
            lblTip.isHidden = false
        }
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        lblTip.text = type.typeDescription
        txtview.keyboardType = type.typeKeyboard
    
        // 是否必填...<必填显示星号>
        lblStar.isHidden = !type.typeInputMust
        if lblStar.isHidden {
            // 非必填
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(15))
            }
        }
        else {
            // 必填...<显示星号>
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(22))
            }
        }
        
        // 计算文字高度
        let height = calcuateTextHeight()
        // 保存
        updateCellHeight(cellType, height)
        // 更新
        txtview.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        layoutIfNeeded()
    }
    func setTextViewEditAble(_ editAble:Bool?){
        txtview.isEditable = editAble ?? true
    }
}


extension RITextLongInputCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // 提示语隐藏
        //lblTip.isHidden = true
        
        if let closure = beginEditing {
            closure()
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let txt = textView.text, txt.count > 0 {
            lblTip.isHidden = true
        }
        else {
            lblTip.isHidden = false
        }
        
        if let closure = endEditing {
            closure()
        }
    }
    
    // 禁止换行
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // emoji
        guard let inputMode = textView.textInputMode, let language = inputMode.primaryLanguage, language.isEmpty == false else {
            return false
        }
        if language == "emoji" {
            // 禁止输入emoji
            return false
        }
        
        if text == "\n" {
            // 完成
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // 字数限制&统计
    func textViewDidChange(_ textView: UITextView) {
        // 有未选中的字符
//        if let selectedRange = textView.markedTextRange, let newText = textView.text(in: selectedRange), newText.isEmpty == false {
//            return
//        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textView.text) || NSString.hasEmoji(textView.text) {
            textView.text = NSString.disableEmoji(textView.text)
        }
        
        // 过滤空格
        if let txt = textView.text, txt.isEmpty == false {
            // 先判断是否有包含空格...<如果每次均直接设置的话，则光标每次都会重置到最后>
            if (txt as NSString).contains(" ") {
                textView.text = txt.replacingOccurrences(of: " ", with: "")
            }
        }
        
        // 字数限制
        if let content = textView.text, content.isEmpty == false {
            // 有输入
            lblTip.isHidden = true
            // 字数限制
            let count = cellType.typeNumberMax
            if content.count >= count + 1 {
                textView.text = content.substring(to: content.index(content.startIndex, offsetBy: count))
            }
        }
        else {
            // 无输入
            lblTip.isHidden = false
        }
        
        // 计算文字高度
        let height = calcuateTextHeight()
        
        // 判断是否需要更新cell高度
        var updateFlag = false
        if getCellHeight(cellType) != height {
            // 赋值
            updateFlag = true
            // 保存
            updateCellHeight(cellType, height)
            // 更新
            txtview.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            contentView.layoutIfNeeded()
        }
        
        // 回调
        if let block = changeText {
            block(textView.text, height + WH(16), updateFlag)
        }
    }
}


extension RITextLongInputCell {
    // 计算txtview高度
    func calcuateTextHeight() -> CGFloat {
        // 固定宽度
        let width = SCREEN_WIDTH - WH(143)
        // 计算尺寸
        let size = txtview.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        // 获取实际高度
        var height = size.height + 2
        if height <= WH(30) {
            // 下限
            height = WH(30)
        }
        // 对字数进行限制，故不在此处限制最大高度
//        if height >= WH(122) {
//            // 上限...<6行>...<待确认>
//            height = WH(122)
//        }
        return height
    }
    
    // 更新cell高度
    func updateCellHeight(_ type: RITextInputType, _ height: CGFloat) {
        dicHeight[type.rawValue] = height
    }
    
    // 获取当前类型cell高度
    func getCellHeight(_ type: RITextInputType) -> CGFloat {
        return dicHeight[type.rawValue] ?? cellHeightInput
    }
}
