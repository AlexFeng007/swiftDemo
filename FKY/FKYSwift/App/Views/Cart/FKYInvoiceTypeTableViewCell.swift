//
//  FKYInvoiceTypeTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/1/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

//选择发票类型头部
class FKYInvoiceTypeTableViewCell: UITableViewCell {
    // MARK: - 控件
    // 发票类型
    fileprivate lazy var invoiceTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "发票类型"
        label.font = t61.font
        label.textColor = t9.color
        return label
    }()
    //类型提示
    fileprivate lazy var tipButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart_rebeat_icon"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTipBlock {
                block()
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //发票类型按钮1
    fileprivate lazy var typeOneBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = WH(4)
        button.titleLabel?.font = t16.font
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtnBlock {
                block(0)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //发票类型按钮2
    fileprivate lazy var typeTwoBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = WH(4)
        button.titleLabel?.font = t16.font
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtnBlock {
                block(1)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //发票类型按钮3
    fileprivate lazy var typeThreeBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = WH(4)
        button.titleLabel?.font = t16.font
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtnBlock {
                block(2)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //描述文字
    fileprivate lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = t31.font
        label.textColor = t23.color
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    var clickTipBlock : (()->(Void))?//点击提示
    var clickTypeBtnBlock : ((Int)->(Void))? //点击类型按钮
    fileprivate var btnArr = [UIButton]() //类型按钮数组
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
        contentView.addSubview(invoiceTypeLabel)
        invoiceTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(14))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(17))
            make.width.lessThanOrEqualTo(WH(80))
        }
        contentView.addSubview(tipButton)
        tipButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.invoiceTypeLabel.snp.centerY)
            make.left.equalTo(self.invoiceTypeLabel.snp.right).offset(WH(2))
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(20))
        }
        let btnW = (SCREEN_WIDTH-WH(40))/3.0
        contentView.addSubview(typeOneBtn)
        typeOneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.invoiceTypeLabel.snp.bottom).offset(WH(8))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(40))
            make.width.equalTo(btnW)
        }
        contentView.addSubview(typeTwoBtn)
        typeTwoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.typeOneBtn.snp.centerY)
            make.left.equalTo(self.typeOneBtn.snp.right).offset(WH(5))
            make.height.equalTo(WH(40))
            make.width.equalTo(btnW)
        }
        contentView.addSubview(typeThreeBtn)
        typeThreeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.typeOneBtn.snp.centerY)
            make.left.equalTo(self.typeTwoBtn.snp.right).offset(WH(5))
            make.height.equalTo(WH(40))
            make.width.equalTo(btnW)
        }
        contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.typeOneBtn.snp.bottom).offset(round(WH(10)))
            make.left.equalTo(contentView.snp.left).offset(round(WH(15)))
            make.right.equalTo(contentView.snp.right).offset(-round(WH(15)))
            make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(15)))
        }
        self.btnArr.append(typeOneBtn)
        self.btnArr.append(typeTwoBtn)
        self.btnArr.append(typeThreeBtn)
    }
}
extension FKYInvoiceTypeTableViewCell {
    func configInvoiceTypeData(_ invoiceArr : [Int],_ selectNum:Int,_ tipStr:String)  {
        typeOneBtn.isHidden = true
        typeTwoBtn.isHidden = true
        typeThreeBtn.isHidden = true
        //1-增值税专用发票 2-增值税普通发票 3-增值税电子普通发票
        for (index ,value) in invoiceArr.enumerated() {
            let btn = self.btnArr[index]
            btn.isHidden = false
            if value == 2 {
                btn.setTitle("纸质普通发票", for: .normal)
            }else if value == 3 {
                btn.setTitle("电子普通发票", for: .normal)
            }else {
                btn.setTitle("专用发票", for: .normal)
            }
            if index == selectNum {
                //选中
                btn.backgroundColor = RGBColor(0xFFEDE7)
                btn.layer.borderColor = t73.color.cgColor
                btn.layer.borderWidth = WH(1)
                btn.setTitleColor(t73.color, for: .normal)
            }else {
                //未选中
                btn.backgroundColor = RGBColor(0xF4F4F4)
                btn.setTitleColor(RGBColor(0x333333), for: .normal)
                btn.layer.borderWidth = WH(0)
            }
        }
        desLabel.text = tipStr
    }
    
}
