//
//  FKYNewProductRegisterInputCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 扫描按钮点击事件
let FKY_NewProductRegisterScanButtonClicked = "NewProductRegisterScanButtonClicked"

class FKYNewProductRegisterInputCell: UITableViewCell {

    /// 是否是第一个cell
    var isFirstCell = false
    /// 是否是最后一个cell
    var isLastCell = false
    /// cellModel
    var cellModel = FKYNewProductRegisterCellModel()
    
    /// 容器视图
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
//        view.layer.cornerRadius = 8
//        view.layer.masksToBounds = true
        return view
    }()
    
    /// 前面文描label
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: WH(13))
        lb.textColor = RGBColor(0x666666)
        lb.textAlignment = .left
        return lb
    }()
    
    /// 输入框
    lazy var inputTF:UITextField = {
        let tf = UITextField()
        tf.textColor = RGBColor(0x333333)
        tf.delegate = self
        return tf
    }()
    
    /// 扫描按钮
    lazy var scanButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "New_Product_Register_Scan_Icon"), for: .normal)
        bt.addTarget(self, action: #selector(FKYNewProductRegisterInputCell.scanButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 分割线
    lazy var marginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
//        self.addRoundedCorners()
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

//MARK: - 数据刷新
extension FKYNewProductRegisterInputCell {
    
    /// 显示cell信息
    func showCellData(cellModel:FKYNewProductRegisterCellModel) {
        self.cellModel = cellModel
        self.isFirstCell = self.cellModel.isFirstCell
        self.isLastCell = self.cellModel.isLastCell
        self.showInputCell()
    }
    
    /// 显示信息输入cell
    func showInputCell(){
        self.titleLabel.text = self.cellModel.titleTexxt
        self.inputTF.text = self.cellModel.inputText
        self.inputTF.placeholder = self.cellModel.holderText
        self.inputTF.isUserInteractionEnabled = self.cellModel.isEnabelTFEditer
        self.updataViewShowStatus()
        self.addRoundedCorners()
    }
}

//MARK: - 响应事件
extension FKYNewProductRegisterInputCell {
    
    /// 扫描按钮点击
    @objc func scanButtonClicked(){
        self.routerEvent(withName: FKY_NewProductRegisterScanButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
    
}

//MARK - 私有方法
extension FKYNewProductRegisterInputCell {
    
}


//MARK: - UI
extension FKYNewProductRegisterInputCell {
    func setupUI(){
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
//        self.titleLabel.backgroundColor = .red
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.inputTF)
        self.containerView.addSubview(self.scanButton)
        self.containerView.addSubview(self.marginLine)
        
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.inputTF)
//        self.contentView.addSubview(self.scanButton)
//        self.contentView.addSubview(self.marginLine)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }

        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(10))
            make.bottom.equalToSuperview().offset(WH(-10))
//            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(15))
            make.width.equalTo(WH(108))
        }

        self.inputTF.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp_right)
            make.right.equalTo(self.scanButton.snp_left)
        }

        self.scanButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(WH(30))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-10))
        }

        self.marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(0.5))
        }
        
    }
    
    /// 更新视图中各个视图的显示状态
    func updataViewShowStatus(){
        self.marginLine.isHidden = !self.cellModel.isNeedShowMarginLine
        self.scanButtonLayout()
    }
    
    /// 更改是否显示扫描按钮的布局
    func scanButtonLayout(){
        if self.cellModel.isShowScanButton {
            self.scanButton.snp_updateConstraints { (make) in
                make.width.equalTo(WH(30))
            }
        }else{
            self.scanButton.snp_updateConstraints { (make) in
                make.width.equalTo(WH(0))
            }
        }
    }
    
    /// 显示圆角
    func addRoundedCorners(){
        var corner:UIRectCorner = UIRectCorner()
        if self.isFirstCell && !self.isLastCell {
            corner = [.topRight, .topLeft]
        }else if !self.isFirstCell && self.isLastCell {
            corner = [.bottomRight, .bottomLeft]
        }else if self.isFirstCell && self.isLastCell {
            corner = [.topLeft,.topRight, .bottomRight, .bottomLeft]
        }
        self.layoutIfNeeded()
        var rect = self.containerView.bounds
        rect.size.width = SCREEN_WIDTH - WH(20)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: WH(8) ,height: WH(8) ))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.containerView.bounds
        maskLayer.path = maskPath.cgPath
        self.containerView.layer.mask = maskLayer
    }
}

//MARK: - TF代理
extension FKYNewProductRegisterInputCell:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cellModel.inputText = textField.text ?? ""
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.routerEvent(withName: FKY_NewProductRegisterInpuBI, userInfo: [FKYUserParameterKey:self.cellModel])
    }
}
