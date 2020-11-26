//
//  FKYexceptionContentCell.swift
//  FKY
//
//  Created by yyc on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYexceptionContentCell: UITableViewCell {
    //MARK:ui属性
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = t7.color
        return label
    }()
    //状态描述
    fileprivate lazy var statusDesLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = t11.font
        label.textColor = t73.color
        label.textAlignment = .right
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
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(15))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(16))
        })
        contentView.addSubview(statusDesLabel)
        statusDesLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.width.lessThanOrEqualTo(WH(100))
            make.height.equalTo(WH(17))
        })
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
}
extension FKYexceptionContentCell {
    func configExceptionCellData(_ dataModel:Any,_ hideLine:Bool) {
        contentLabel.text = ""
        statusDesLabel.isHidden = true
        if let shopModel = dataModel as? CartMerchantInfoModel {
            contentLabel.snp.remakeConstraints({ (make) in

                make.top.equalTo(contentView.snp.top)
                make.right.equalTo(contentView.snp.right).offset(-WH(15))
                make.left.equalTo(contentView.snp.left).offset(WH(15))
                make.bottom.equalTo(contentView.snp.bottom).offset(-WH(16))
            })
            //未达起送金额
            if let minNum = shopModel.supplySaleSill ,let needNum = shopModel.needAmount,needNum.floatValue > 0 {
                let minMoney = String.init(format: "¥%.2f",minNum.floatValue)
                let needMoney = String.init(format: "¥%.2f",needNum.floatValue)
                let str = "满\(minMoney)起送，还差\(needMoney)"
                let attStr = NSMutableAttributedString.init(string: str)
                attStr.yy_setColor(t73.color, range:((str as NSString).range(of: minMoney)))
                attStr.yy_setColor(t73.color, range:((str as NSString).range(of: needMoney)))
                contentLabel.attributedText = attStr
            }
            contentLabel.font = UIFont.systemFont(ofSize: WH(16))
        }else if let prdModel = dataModel as? CartChangeProductInfoModel {
            contentLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(contentView.snp.top)
                make.right.equalTo(statusDesLabel.snp.left).offset(-WH(10))
                make.left.equalTo(contentView.snp.left).offset(WH(15))
                make.bottom.equalTo(contentView.snp.bottom).offset(-WH(16))
            })
            contentLabel.text = "\(prdModel.productName ?? "") \(prdModel.specification ?? "")"
            statusDesLabel.isHidden = false
            statusDesLabel.text = "其他变化"
            if let statusStr = prdModel.statusCode  {
                if statusStr == "002070000004" {
                    statusDesLabel.text = "库存变化"
                }else if statusStr == "002070000005" {
                    statusDesLabel.text = "价格变化"
                }
            }
        }
        bottomLine.isHidden = hideLine
    }
}
