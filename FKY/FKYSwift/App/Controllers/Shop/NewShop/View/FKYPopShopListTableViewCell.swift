//
//  FKYPopShopListTableViewCell.swift
//  FKY
//
//  Created by yyc on 2019/12/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYPopShopListTableViewCell: UITableViewCell {
    //MARK:ui属性
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    //限额描述
    fileprivate lazy var descLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(11))
        //label.fontTuple = t7
        return label
    }()
    //底部分隔线
    fileprivate lazy var bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = bg7
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-WH(13))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
        })
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-WH(21))
           // make.left.equalTo(self.snp.left).offset(WH(15))
        })
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.left.equalTo(contentView.snp.left).offset(WH(13))
            make.right.equalTo(contentView.snp.right).offset(-WH(12))
            make.height.equalTo(0.5)
        })
    }

}
extension FKYPopShopListTableViewCell {
    func configPopShopListTableViewCellData(_ contentStr:String,_ hideLine:Bool) {
        descLabel.isHidden = true
        contentLabel.text = contentStr
        bottomLine.isHidden = hideLine
    }
}
extension FKYPopShopListTableViewCell {
    func configPopBankListTableViewCellData(_ model:FKYBankIndeModel,_ hideLine:Bool) {
        descLabel.isHidden = false
        bottomLine.snp.updateConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(16))
           // make.right.equalTo(self.snp.right).offset(-WH(16))
        })
        contentLabel.snp.updateConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(16))
        })
        contentLabel.text = model.bankName ?? ""
        descLabel.text = model.limitDesc ?? ""
        bottomLine.isHidden = hideLine
    }
}
