//
//  BCInputInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/1/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class BCInputInfoView: UIView {
    //E5E5E5
    fileprivate lazy var  upLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGBColor(0xE5E5E5)
        return lineView
    }()
    
    fileprivate lazy var  orderTimeL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "下单时间"
        return label
    }()
    fileprivate lazy var orderTimeDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var  orderNumL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "订单号"
        return label
    }()
    
    fileprivate lazy var orderNumDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var  sellerTitleL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "卖家"
        return label
    }()
    
    fileprivate lazy var sellerTitleDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var  sellerContactL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "卖家联系方式"
        return label
    }()

    fileprivate lazy var sellerContactDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()

    fileprivate lazy var  buyerTitleL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "买家"
        return label
    }()

    fileprivate lazy var buyerTitleDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var  buyerContactL: UILabel = {
        let label = UILabel()
        label.fontTuple = t9
        label.font = UIFont.boldSystemFont(ofSize: WH(13))
        label.sizeToFit()
        label.text = "买家联系方式"
        return label
    }()
    
    fileprivate lazy var buyerContactDL: UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var  dowmLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGBColor(0xE5E5E5)
        return lineView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.addSubview(upLineView)
        self.addSubview(orderTimeL)
        self.addSubview(orderTimeDL)
        self.addSubview(orderNumL)
        self.addSubview(orderNumDL)
        self.addSubview(sellerTitleL)
        self.addSubview(sellerTitleDL)
        self.addSubview(sellerContactL)
        self.addSubview(sellerContactDL)
        self.addSubview(buyerTitleL)
        self.addSubview(buyerTitleDL)
        self.addSubview(buyerContactL)
        self.addSubview(buyerContactDL)
        self.addSubview(dowmLineView)
        
        upLineView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        orderTimeL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self).offset(WH(16))
            make.height.equalTo( WH(13))
        }
        orderTimeDL.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(WH(-17))
            make.centerY.equalTo(orderTimeL.snp.centerY)
        }
        orderNumL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self.orderTimeL.snp.bottom).offset(WH(14))
            make.height.equalTo( WH(13))
        }
        orderNumDL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-17))
            make.centerY.equalTo(orderNumL.snp.centerY)
        }
        
        sellerTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self.orderNumL.snp.bottom).offset(WH(14))
            make.height.equalTo( WH(13))
        }
        sellerTitleDL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-17))
            make.centerY.equalTo(sellerTitleL.snp.centerY)
        }
        sellerContactL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self.sellerTitleL.snp.bottom).offset(WH(14))
            make.height.equalTo( WH(13))
        }
        sellerContactDL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-17))
            make.centerY.equalTo(sellerContactL.snp.centerY)
        }
        
        buyerTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self.sellerContactL.snp.bottom).offset(WH(14))
            make.height.equalTo( WH(13))
        }
        buyerTitleDL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-17))
            make.centerY.equalTo(buyerTitleL.snp.centerY)
        }
        buyerContactL.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self.buyerTitleL.snp.bottom).offset(WH(14))
            make.height.equalTo( WH(13))
        }
        buyerContactDL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-17))
            make.centerY.equalTo(buyerContactL.snp.centerY)
        }
        dowmLineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    func configView(_ model:ComplainSellerInfoModel){
        //下单时间
        self.orderTimeDL.text =  model.orderCreateTime
        //订单编号
        self.orderNumDL.text = model.flowId
        //卖家
        self.sellerTitleDL.text = model.sellerName
        //卖家联系方式
        self.sellerContactDL.text = model.sellerMobile
        //买家
        self.buyerTitleDL.text = model.buyerName
        //买家联系方式
        self.buyerContactDL.text = model.buyerMobile
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
