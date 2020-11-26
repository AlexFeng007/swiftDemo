//
//  FKYJSOrderDetailInfoCell.swift
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

@objc
enum FKYJSOrderDetailInfoCellType : NSInteger {
    case rejected // 拒收
    case replenishment // 补货
}

class FKYJSOrderDetailInfoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc var orderDetailClosure: emptyClosure?
    fileprivate var orderId : UILabel?
    fileprivate var originOrderId : UIButton?
    fileprivate var status : UILabel?
    fileprivate var date : UILabel?
    
    fileprivate func setupView() -> (){
        
        orderId = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(j1)
                make.right.equalTo(self.contentView).offset(j1)
                make.top.equalTo(self.contentView.snp.top).offset(j4)
                make.height.equalTo(j7)
            })
            label.textColor = t9.color
            label.font = t9.font
            return label
        }()
        
        originOrderId = {
            let label = UIButton()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.orderId!)
                make.top.equalTo(orderId!.snp.bottom)
                make.height.equalTo(j7)
            })
            
            label.fontTuple = t9
            label.contentHorizontalAlignment = .left
            _ = label.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let strongSelf = self else {
                   return
                }
                if(strongSelf.orderDetailClosure != nil){
                    strongSelf.orderDetailClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return label
        }()
        
        status = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.orderId!)
                make.top.equalTo(originOrderId!.snp.bottom)
                make.height.equalTo(j7)
            })
            label.textColor = t9.color
            label.font = t9.font
            return label
        }()
        
        date = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.orderId!)
                make.top.equalTo(status!.snp.bottom)
                make.height.equalTo(j7)
            })
            label.textColor = t9.color
            label.font = t9.font
            return label
        }()
    }
    
    @objc func configCellWithModel(_ model : FKYOrderModel? , cellType : FKYJSOrderDetailInfoCellType) -> () {
        if model == nil {
            return
        }
        if cellType == .rejected {
            orderId?.text = "拒收订单编号: " + String(model!.exceptionOrderId)
            status?.text = "拒收状态: " + model!.getOrderStatus()
        }else{
            orderId?.text = "补货订单编号: " + String(model!.exceptionOrderId)
            status?.text = "补货状态: " + model!.getOrderStatus()
        }
        if model!.applyTime == nil {
            model!.applyTime = ""
        }
        date?.text = "申请时间: " + model!.applyTime
        var str = "原始订单编号: "
        if model!.exceptionOrderId != nil {
            str = "原始订单编号: " + String(model!.orderId)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = WH(5)
        paragraphStyle.alignment = .center
        let attr = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: t35.color,
                                                                       NSAttributedString.Key.font: t35.font,
                                                                       NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                                       NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
        attr.setAttributes([NSAttributedString.Key.foregroundColor: t9.color,
                            NSAttributedString.Key.font: t9.font,
                            NSAttributedString.Key.paragraphStyle: paragraphStyle,
                            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)],
                           range: NSMakeRange(0, ("原始订单编号: " as NSString).length))
        originOrderId!.setAttributedTitle(attr, for: UIControl.State())
    }
}
