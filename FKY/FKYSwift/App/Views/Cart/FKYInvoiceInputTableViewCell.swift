//
//  FKYInvoiceInputTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/1/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYInvoiceInputTableViewCell: UITableViewCell {
    
    // MARK: - 控件
    fileprivate lazy var titleTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = t7.color
        label.font = t61.font
        return label
    }()
    fileprivate lazy var contentTF : UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        tf.textColor = t9.color
        tf.font = t9.font
        return tf
    }()
    //向右箭头
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon_cart_gray_arrow_right")
        return img
    }()
    // 底部分隔线
    fileprivate lazy var bottomLine : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = bg7
        return view
    }()
    // 顶部分隔线
    fileprivate lazy var topLine : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = bg7
        return view
    }()
    //点击
    fileprivate lazy var clickButton: UIButton = {
        let button = UIButton()
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTapBlock {
                block()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    var infoModel : FKYInvoiceModel? //模型
    var typeCellIndex  =  1 // 记录cell的类型
    var clickTapBlock : (()->(Void))?//选择银行类型
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView()  {
        contentView.addSubview(titleTypeLabel)
        titleTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.top.equalTo(contentView.snp.top).offset(WH(15))
            make.width.equalTo(WH(62))
            make.height.equalTo(WH(13))
        }
        contentView.addSubview(contentTF)
        contentTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleTypeLabel.snp.right).offset(WH(18))
            make.height.equalTo(WH(13))
            make.centerY.equalTo(self.titleTypeLabel.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-WH(13))
        }
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.height.equalTo(0.5)
        })
        contentView.addSubview(topLine)
        topLine.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.height.equalTo(0.5)
        })
        contentView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(20))
            make.centerY.equalTo(contentView.snp.centerY)
        })
        contentView.addSubview(clickButton)
        clickButton.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentTF.snp.left)
            make.top.bottom.right.equalTo(contentView)
        })
        contentTF.delegate = self
        contentTF.rx.text.bind { [weak self] (text) in
            guard let strongSelf = self else {
                return
            }
            if let str = text, str.isEmpty == false {
                strongSelf.changeToUppercased(str)
            }
        }.disposed(by: disposeBag)
        
    }
}
extension FKYInvoiceInputTableViewCell {
    func changeToUppercased(_ str:String) {
        if self.typeCellIndex == 1{
            contentTF.text = str.uppercased()
        }
    }
    /*
     新逻辑：
     一>待审核 都不允许更改
     二>审核通过  审核通过 ->是不是分店开总店开关  是的： 允许修改企业名称和纳税人识别号/不是：不允许修改 ； 其他信息可以修改
     三> 审核不通过 都允许修改
     */
    func configInvoiceInput(_ titleStr:String,_ typeIndex:Int,_ infoDesModel : FKYInvoiceModel?) {
        bottomLine.isHidden = true
        topLine.isHidden = true
        contentTF.isUserInteractionEnabled = false
        rightImageView.isHidden = true
        titleTypeLabel.text = titleStr
        clickButton.isHidden = true
        if let model = infoDesModel {
            self.typeCellIndex = typeIndex
            self.infoModel = model
            //判读是否能修改逻辑
            //1待审核；2审核通过；3审核不通过 接口为null会解析为0
            //
            if (typeIndex == 0 && model.deliverStatus == 1) ||  (typeIndex == 1 && model.deliverStatus == 1) {
                //资管审核通过
                if model.branchSwitch == 1 {
                    contentTF.isUserInteractionEnabled = true
                    contentTF.textColor = t9.color
                    clickButton.isHidden = true
                }else {
                    //不允许更改
                    contentTF.isUserInteractionEnabled = false
                    contentTF.textColor = t11.color
                    clickButton.isHidden = true
                }
            }else{
                //资管审核不通过或者非企业名称和纳税人识别号判断
                if model.billStatus == 1 {
                    //都不允许更改
                    contentTF.isUserInteractionEnabled = false
                    contentTF.textColor = t11.color
                    clickButton.isHidden = true
                }else {
                    //都允许修改
                    contentTF.isUserInteractionEnabled = true
                    contentTF.textColor = t9.color
                    if typeIndex == 6 {
                        //银行类型
                        clickButton.isHidden = false
                        contentTF.isUserInteractionEnabled = false
                    }
                }
            }
            
            if typeIndex == 0 {
                //企业名称
                titleTypeLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(WH(61))
                    make.top.equalTo(contentView.snp.top).offset(WH(15))
                    make.height.equalTo(WH(13))
                }
                contentTF.text = model.enterpriseName
                contentTF.placeholder = "请填写企业名称"
            }else if  typeIndex == 1 {
                //纳税人识别号
                titleTypeLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(WH(87))
                    make.top.equalTo(contentView.snp.top).offset(WH(12))
                    make.height.equalTo(WH(13))
                }
                contentTF.text = model.taxpayerIdentificationNumber
                contentTF.placeholder = "如果三证合一，请填写统一社会信用代码"
            }else{
                if titleStr.contains("*") {
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.width.equalTo(WH(62))
                        make.height.equalTo(WH(18))
                    }
                    contentTF.snp.updateConstraints { (make) in
                        make.right.equalTo(contentView.snp.right).offset(-WH(13))
                    }
                }else{
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.width.equalTo(WH(54))
                        make.height.equalTo(WH(18))
                    }
                    contentTF.snp.updateConstraints { (make) in
                        make.right.equalTo(contentView.snp.right).offset(-WH(13))
                    }
                }
                if typeIndex == 4 {
                    //注册地址
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(contentView.snp.top).offset(WH(6))
                    }
                    contentTF.text = model.registeredAddress
                    contentTF.placeholder = "请填写注册地址"
                }else if typeIndex == 5 {
                    //注册电话
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(contentView.snp.top).offset(WH(6))
                    }
                    contentTF.text = model.registeredTelephone
                    contentTF.placeholder = "请填写注册电话号码"
                }else if typeIndex == 6 {
                    //银行类型
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(contentView.snp.top).offset(WH(11))
                    }
                    bottomLine.isHidden = false
                    topLine.isHidden = false
                    contentTF.snp.updateConstraints { (make) in
                        make.right.equalTo(contentView.snp.right).offset(-WH(40))
                    }
                    rightImageView.isHidden = false
                    contentTF.text = model.bankTypeVO.name
                    contentTF.placeholder = "请选择银行类型"
                }else if typeIndex == 7 {
                    //开户银行
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(contentView.snp.top).offset(WH(12))
                    }
                    contentTF.text = model.openingBank
                    contentTF.placeholder = "请填写开户银行"
                }else if typeIndex == 8 {
                    //银行账号
                    titleTypeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(contentView.snp.top).offset(WH(9))
                    }
                    contentTF.text = model.bankAccount
                    contentTF.placeholder = "请填写银行账户"
                }
            }
        }else {
            contentTF.text = ""
        }
    }
    //更新模型中对应的字段
    fileprivate func updateModelData(_ inputStr:String) {
        if let model = self.infoModel {
            if typeCellIndex == 0 {
                //企业名称
                model.enterpriseName = inputStr
            }else if  typeCellIndex == 1 {
                //纳税人识别号
                model.taxpayerIdentificationNumber = inputStr
            }else if  typeCellIndex == 4 {
                //注册地址
                model.registeredAddress = inputStr
            }else if  typeCellIndex == 5 {
                //注册电话
                model.registeredTelephone = inputStr
            }else if  typeCellIndex == 6 {
                //银行类型
            }else if  typeCellIndex == 7 {
                //开户银行
                model.openingBank = inputStr
            }else if  typeCellIndex == 8 {
                //银行账号
                model.bankAccount = inputStr
            }
        }
    }
}
extension FKYInvoiceInputTableViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty == false {
            // 不为空...<去掉前后空格和空行>
            let txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
            textField.text = txt
            self.updateModelData(txt)
        }
    }
}
