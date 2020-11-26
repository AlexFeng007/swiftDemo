//
//  FKYAllSaleListTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/8/2.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
typealias CopyIdAction = ()->()
typealias CheckAction = ()->()

class FKYAllSaleListTableViewCell: UITableViewCell {
    var copyIdAction : CopyIdAction?
    //标题/
    fileprivate lazy var titleNameL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    /*********退货才有**************/
    //
    fileprivate lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "退款金额:"
        label.textAlignment = .right
        label.fontTuple = t3
        return label
    }()
    //退款金额
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t49
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //备注(动态计算)
    fileprivate lazy var remakLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //申请时间
    fileprivate lazy var applyTimeLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        return label
    }()
    //订单号
    fileprivate lazy var orderNumLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        return label
    }()
    
    fileprivate lazy var copyBtn: UIButton = { [weak self] in
           let btn = UIButton(type: .system)
           btn.setTitle("复制", for: .normal)
           btn.setTitleColor(RGBColor(0x000000), for: .normal)
           btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
           btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
           btn.layer.borderWidth = 0.5
           btn.layer.cornerRadius = 4
           btn.clipsToBounds = true
           btn.bk_addEventHandler({ (btn) in
               if self!.copyIdAction != nil {
                   self!.copyIdAction!()
               }
           }, for: .touchUpInside)
           return btn
       }()
    
    //撤销申请背景图
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(bgView)
            make.height.equalTo(WH(1))
        }
        bgView.addSubview(self.cancleBtn)
        self.cancleBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(70))
            make.right.equalTo(bgView.snp.right).offset(-WH(14))
        }
        return bgView
    }()
    
    fileprivate lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        return line
    }()
    
    fileprivate lazy var cancleBtn: UIButton = { [weak self] in
        let btn = UIButton(type: .system)
        btn.setTitle("撤销申请", for: .normal)
        btn.setTitleColor(RGBColor(0x000000), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        btn.bk_addEventHandler({ [weak self] (btn) in
            if let strongSelf = self {
                if let block = strongSelf.cancelHandle  {
                    block()
                }
            }
        }, for: .touchUpInside)
        return btn
        }()
    
    // MARK: - Init
    var cancelHandle: CancelHandleClourse?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor =  RGBColor(0xffffff)
        contentView.addSubview(self.titleNameL)
        self.titleNameL.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(16))
        }
        contentView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleNameL.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-WH(14))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(WH(100))
        }
        contentView.addSubview(self.priceNameLabel)
        self.priceNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleNameL.snp.centerY)
            make.right.equalTo(self.priceLabel.snp.left).offset(-WH(2))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(WH(70))
        }
        contentView.addSubview(self.remakLabel)
        self.remakLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleNameL.snp.bottom).offset(WH(6))
            make.left.equalTo(self.titleNameL.snp.left)
            make.right.equalTo(self.snp.right).offset(-WH(15))
            make.height.equalTo(WH(14))
        }
        contentView.addSubview(self.applyTimeLabel)
        self.applyTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.remakLabel.snp.bottom).offset(WH(10))
            make.left.equalTo(self.titleNameL.snp.left)
            make.right.equalTo(self.snp.right).offset(-WH(15))
        }
        contentView.addSubview(self.orderNumLabel)
        self.orderNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.applyTimeLabel.snp.bottom).offset(WH(5))
            make.left.equalTo(self.titleNameL.snp.left)
            //make.right.equalTo(self.snp.right).offset(-WH(15))
        }
        
        contentView.addSubview(self.copyBtn)
        self.copyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.orderNumLabel.snp.centerY)
            make.left.equalTo(self.orderNumLabel.snp.right).offset(WH(3))
            make.height.equalTo(WH(19))
            make.width.equalTo(WH(40))
        }
        
        contentView.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(WH(55))
        }
    }

}
extension FKYAllSaleListTableViewCell {
    func configAllSaleListCell(_ model : FKYAllAfterSaleModel) {
        self.priceLabel.isHidden = true
        self.priceNameLabel.isHidden = true
        self.bgView.snp.updateConstraints { (make) in
            make.height.equalTo(WH(0))
        }
        self.bgView.isHidden = true
        self.cancleBtn.isHidden = true
        self.lineView.isHidden = true
        var title_w = WH(150)
        
        if model.easOrderType == "2" {
            //单据
            //拼接描述
            var titleStr = ""
            if let SecondTypeStr = model.easOrderSecondTypeStr ,SecondTypeStr.count > 0 {
                titleStr = SecondTypeStr
            }
            if let thirdTypeStr = model.easOrderThirdTypeStr ,thirdTypeStr.count > 0 {
                if titleStr.count > 0 {
                    titleStr = titleStr + "-" + thirdTypeStr
                }else {
                    titleStr = thirdTypeStr
                }
            }
            self.titleNameL.text = titleStr
            title_w = SCREEN_WIDTH-WH(25)
        }else {
            //退货or换货
            if  let num = model.rmaBizType ,num == 1 {
                 self.titleNameL.text = "极速理赔"
            }else {
                self.titleNameL.text = "\(model.easOrderSecondTypeStr ?? "") \(model.backWayName ?? "" )"
            }
            if model.easOrderSecondType == "0" {
                //退货
                //显示退款总数
                if let totalPrice = model.refundAmount,totalPrice > 0 {
                    title_w = WH(150)
                    self.priceLabel.text = String(format: "￥%.2f", totalPrice)
                    self.priceLabel.isHidden = false
                    self.priceNameLabel.isHidden = false
                    // 对退款调整样式
                    if let priceStr = self.priceLabel.text,priceStr.contains("￥") {
                        let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                        priceMutableStr.addAttributes([NSAttributedString.Key.font:t38.font], range: NSMakeRange(0, 1))
                        self.priceLabel.attributedText = priceMutableStr
                    }
                }
            }
            //判断撤销申请按钮显示与否
            if  model.easOrderstatus == "ASWA" {
                self.bgView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(55))
                }
                self.bgView.isHidden = false
                self.cancleBtn.isHidden = false
                self.lineView.isHidden = false
        
            }
        }
        let titleH =  (self.titleNameL.text ?? "").boundingRect(with: CGSize(width: title_w, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t7.font], context: nil).height
    
        self.titleNameL.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(titleH + 1)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
        }
        
        //判断是否有备注信息
        if model.easOrderType == "2", let str = model.completeContent ,str.count > 0 {
            //单据且有备注信息
            let contentLabelH =  str.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(30), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t16.font], context: nil).height
            self.remakLabel.snp.updateConstraints { (make) in
                make.top.equalTo(self.titleNameL.snp.bottom).offset(WH(6))
                make.height.equalTo(contentLabelH+WH(1))
            }
            self.remakLabel.text = str
            self.remakLabel.isHidden = false
        }else {
            self.remakLabel.snp.updateConstraints { (make) in
                make.top.equalTo(self.titleNameL.snp.bottom).offset(WH(0))
                make.height.equalTo(WH(0))
            }
            self.remakLabel.isHidden = true
        }
        
        self.applyTimeLabel.text = "申请时间：\(model.date ?? "")"
        self.orderNumLabel.text = "订单号：\(model.orderId ?? "")"
    }
    //计算高度
    static func configCellHeight(_ model : FKYAllAfterSaleModel) -> CGFloat {
        var cell_h = WH(82)-WH(16)
        
        if model.easOrderType == "1" && model.easOrderstatus == "ASWA" {
            //退换货并且状态为审核中
            cell_h = cell_h + WH(55)
        }
        if model.easOrderType == "2", let str = model.completeContent ,str.count > 0 {
            let contentLabelH =  str.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(30), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t16.font], context: nil).height
            cell_h = cell_h + contentLabelH + WH(6)
        }
        
        //计算title的高度
        var title_w = WH(150)
        var titleStr = ""
        if model.easOrderType == "2" {
            if let SecondTypeStr = model.easOrderSecondTypeStr ,SecondTypeStr.count > 0 {
                titleStr = SecondTypeStr
            }
            if let thirdTypeStr = model.easOrderThirdTypeStr ,thirdTypeStr.count > 0 {
                if titleStr.count > 0 {
                    titleStr = titleStr + "-" + thirdTypeStr
                }else {
                    titleStr = thirdTypeStr
                }
            }
            title_w = SCREEN_WIDTH-WH(25)
        }else {
            titleStr = "\(model.easOrderSecondTypeStr ?? "") \(model.backWayName ?? "" )"
            if model.easOrderSecondType == "0" {
                if let totalPrice = model.refundAmount,totalPrice > 0 {
                    title_w = WH(150)
                }
            }
        }
        let titleH =  titleStr.boundingRect(with: CGSize(width: title_w, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t7.font], context: nil).height
        if titleH < WH(16) {
            cell_h = cell_h+WH(16)
        }else {
            cell_h = cell_h+titleH
        }
        return cell_h
    }
}
