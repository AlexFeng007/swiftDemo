//
//  BuyerComplainInfoHeaderView.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class BuyerComplainInfoHeaderView: UIView {
    
    fileprivate lazy var  bgView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGBColor(0xFFFCF1)
        return lineView
    }()
    
    fileprivate lazy var verderNameL: UILabel = {
        let label = UILabel()
        label.text = "商家"
        label.fontTuple = t7
        return label
    }()
    fileprivate lazy var orderNumL: UILabel = {
        let label = UILabel()
        label.text = "订单号"
        label.fontTuple = t7
        return label
    }()
    fileprivate lazy var complainTypeL: UILabel = {
        let label = UILabel()
        label.text = "类型"
        label.fontTuple = t7
        return label
    }()
    fileprivate lazy var disposeStutsL: UILabel = {
        let label = UILabel()
        label.text = "处理状态"
        label.fontTuple = t7
        return label
    }()
    fileprivate lazy var disposeTimeL: UILabel = {
        let label = UILabel()
        label.text = "处理时间"
        label.fontTuple = t7
        return label
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(bgView)
        bgView.addSubview(verderNameL)
        bgView.addSubview(orderNumL)
        bgView.addSubview(complainTypeL)
        bgView.addSubview(disposeStutsL)
        bgView.addSubview(disposeTimeL)
        
        bgView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-18))
            make.left.equalTo(self).offset(WH(18))
            make.top.equalTo(self).offset(WH(12))
            make.bottom.equalTo(self).offset(WH(-16))
        }
        verderNameL.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(WH(19))
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        
        orderNumL.snp.makeConstraints { (make) in
            make.top.equalTo(verderNameL.snp.bottom).offset(WH(16))
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        complainTypeL.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumL.snp.bottom).offset(WH(16))
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        disposeStutsL.snp.makeConstraints { (make) in
            make.top.equalTo(complainTypeL.snp.bottom).offset(WH(16))
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        disposeTimeL.snp.makeConstraints { (make) in
            make.top.equalTo(disposeStutsL.snp.bottom).offset(WH(16))
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(14))
        }
        
    }
    func configHeaderView(_ model : ComplainDetailInfoModel){
        verderNameL.text =  "商家：" + model.sellerName!
        orderNumL.text = "订单号：" + model.flowId!
        complainTypeL.text = "类型：" + model.complaintTypeName!
        disposeStutsL.attributedText = self.statusAttributeString( model.complaintStatusName!)
        disposeTimeL.text = "处理时间：" + model.orderCreateTime!
    }
    fileprivate func statusAttributeString(_ statusTypeStr:String?) -> (NSMutableAttributedString) {
        
        let statusTmpl = NSMutableAttributedString()
        
        var statusStr = NSAttributedString(string:"处理状态：")
        statusTmpl.append(statusStr)
        statusTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0x333333),
                                range: NSMakeRange(statusTmpl.length - statusStr.length, statusStr.length))
        
        statusStr = NSAttributedString(string:statusTypeStr!)
        statusTmpl.append(statusStr)
        statusTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: UIColor.red,
                                range: NSMakeRange(statusTmpl.length - statusStr.length, statusStr.length))
        return statusTmpl
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
