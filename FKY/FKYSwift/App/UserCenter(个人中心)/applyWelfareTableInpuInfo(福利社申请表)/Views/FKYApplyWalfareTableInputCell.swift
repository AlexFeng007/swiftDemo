//
//  FKYApplyWalfareTableInputCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  信息输入cell

import UIKit

/// 查看更多按钮点击时间
let FKY_seeMoreBtnClicked = "seeMoreBtnClicked"

/// 结束编辑
let FKY_applyWalfareTableEndEditing = "applyWalfareTableEndEditing"

class FKYApplyWalfareTableInputCell: UITableViewCell {

    /// cellModel
    var cellModel = FKYApplyWalfareTableCellModel()
    
    /// 输入title
    lazy var inputTitle:UILabel = {
        let lb = UILabel()
        lb.text = "暂无标题"
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize:WH(13))
        return lb
    }()
    
    /// 输入框
    lazy var inputTF:UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.font = .systemFont(ofSize: WH(13))
        tf.configTFPlaceholder(placeholder: "暂无提示")
        return tf
    }()
    
    /// 查看更多按钮
    lazy var seeMoreBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"seeMore_Icon"), for: .normal)
        bt.addTarget(self, action: #selector(FKYApplyWalfareTableInputCell.seeMoreBtnClicked), for: .touchUpInside)
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
extension FKYApplyWalfareTableInputCell {
    func configCell(cellModel:FKYApplyWalfareTableCellModel){
        self.cellModel = cellModel
        self.inputTitle.text = self.cellModel.inputTitle1
        self.inputTF.configTFPlaceholder(placeholder: self.cellModel.holderText)
        self.inputTF.text = self.cellModel.inputText1
        
        if self.cellModel.cellType == .inputCell{// 输入cell
            self.hideSeeMoreBtnLayout()
        }else if self.cellModel.cellType == .moreSelectCell {// 选择cell
            self.showSeeMoreBtnLayout()
        }
        
        if cellModel.isCanEditer == true {
            self.inputTitle.textColor = RGBColor(0x333333)
            self.inputTF.textColor = RGBColor(0x333333)
            self.inputTF.isUserInteractionEnabled = true
        }else{
            self.inputTF.isUserInteractionEnabled = false
            self.inputTitle.textColor = RGBColor(0x999999)
            self.inputTF.textColor = RGBColor(0x999999)
        }
    }
    
}

//MARK: - 私有方法
extension FKYApplyWalfareTableInputCell {
    
    /// 查看更多按钮点击
    @objc func seeMoreBtnClicked(){
        self.routerEvent(withName: FKY_seeMoreBtnClicked, userInfo: [FKYUserParameterKey:self.cellModel.popType])
    }
}

//MARK: - UITextFieldDelegate代理
extension FKYApplyWalfareTableInputCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.cellModel.cellType == .moreSelectCell {
            self.routerEvent(withName: FKY_seeMoreBtnClicked, userInfo: [FKYUserParameterKey:self.cellModel.popType])
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.routerEvent(withName: FKY_applyWalfareTableEndEditing, userInfo: [FKYUserParameterKey:["submitKey":self.cellModel.paramKey,"submitValue":textField.text ?? ""] ])
    }
}


//MARK: - UI
extension FKYApplyWalfareTableInputCell {
    
    func setupUI(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.inputTitle)
        self.contentView.addSubview(self.inputTF)
        self.contentView.addSubview(self.seeMoreBtn)
        
//        self.inputTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.inputTitle.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(15))
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-15))
            make.width.equalTo(WH(100))
        }
        
        self.inputTF.snp_makeConstraints { (make) in
            make.left.equalTo(self.inputTitle.snp_right)
            make.top.equalTo(self.inputTitle)
            make.bottom.equalTo(self.inputTitle)
            make.right.equalTo(self.seeMoreBtn.snp_left)
        }
        
        self.seeMoreBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-20))
            make.centerY.equalToSuperview()
            make.width.equalTo(WH(10))
            make.height.equalTo(WH(15))
        }
        
    }
    
    /// 没有查看更多按钮时候的布局
    func hideSeeMoreBtnLayout(){
        self.seeMoreBtn.snp_updateConstraints { (make) in
            make.width.equalTo(WH(0))
        }
    }
    
    /// 有查看更多时候的布局
    func showSeeMoreBtnLayout(){
        self.seeMoreBtn.snp_updateConstraints { (make) in
            make.width.equalTo(WH(10))
        }
    }
    
}
