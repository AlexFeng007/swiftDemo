//
//  FKYOpenInvoiceMoreTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/1/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYOpenInvoiceMoreTableViewCell: UITableViewCell {
    // MARK: - 控件
    fileprivate lazy var invoiceTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "填写其他信息"
        label.fontTuple = t11
        label.textAlignment = .center
        return label
    }()
    fileprivate var downImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "downIcon")
        return img
    }()
    //点击
    fileprivate lazy var clickButton: UIButton = {
        let button = UIButton()
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickOpenBlock {
                block()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    var clickOpenBlock : (()->(Void))?//展开
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
            make.centerX.equalTo(contentView.snp.centerX).offset(-WH(5))
            make.height.equalTo(WH(12))
            make.top.equalTo(contentView.snp.top)
        }
        contentView.addSubview(downImageView)
        downImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.invoiceTypeLabel.snp.centerY)
            make.left.equalTo(self.invoiceTypeLabel.snp.right).offset(WH(3))
        }
        contentView.addSubview(clickButton)
        clickButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.invoiceTypeLabel.snp.left)
            make.right.equalTo(self.downImageView.snp.right)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
