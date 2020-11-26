//
//  RCListHeaderView.swift
//  FKY
//
//  Created by 乔羽 on 2018/10/30.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

typealias CancelHandleClourse = ()->()


class RCListHeaderViewCell: UITableViewCell {
    
    fileprivate lazy var imageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "icon_cart_shopicon")
        return imgV
    }()
    
    fileprivate lazy var companyNameL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    fileprivate lazy var statusL: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF3563)
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let topV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        topV.backgroundColor = RGBColor(0xf7f7f7)
        
        let backgroundV = UIView()
        backgroundV.backgroundColor = UIColor.white
        contentView.addSubview(backgroundV)
        contentView.addSubview(topV)
        backgroundV.addSubview(imageV)
        backgroundV.addSubview(companyNameL)
        backgroundV.addSubview(statusL)
        
        backgroundV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(10))
        }
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundV).offset(WH(15))
            make.centerY.equalTo(backgroundV)
            make.width.height.equalTo(WH(20))
        }
        
        companyNameL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(10))
            make.centerY.equalTo(backgroundV)
            make.right.equalTo(statusL.snp.left).offset(WH(20))
        }
        
        statusL.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundV).offset(-WH(14))
            make.centerY.equalTo(backgroundV)
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        backgroundV.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ model: RCListModel?) {
        companyNameL.text = model!.venderName
        statusL.text = model!.statusCode 
    }
}

class RCLFooterViewCell: UITableViewCell {
    // block
    var cancelHandle: CancelHandleClourse?
    var jumpHandle: (()->())?
    
    fileprivate lazy var imageV: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    fileprivate lazy var operationL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    fileprivate lazy var amountL: UILabel = {
        let label = UILabel()
        label.fontTuple = t49
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        return label
    }()
    
    fileprivate lazy var amountTitleL: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        label.text = "退款金额:"
        return label
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
        btn.bk_addEventHandler({ (btn) in
            if self!.cancelHandle != nil {
                self!.cancelHandle!()
            }
        }, for: .touchUpInside)
        return btn
        }()
    
    fileprivate lazy var returnMsgBtn: UIButton = { [weak self] in
        let btn = UIButton(type: .system)
        btn.setTitle("回寄信息", for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        btn.bk_addEventHandler({ (btn) in
            guard let block = self!.jumpHandle else {
                return
            }
            block()
        }, for: .touchUpInside)
        return btn
        }()
    
    var rcModel: RCListModel?
    fileprivate lazy var firstView = UIView()
    fileprivate lazy var secondView = UIView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = true
        
        contentView.addSubview(firstView)
        firstView.addSubview(imageV)
        firstView.addSubview(operationL)
        firstView.addSubview(amountL)
        firstView.addSubview(amountTitleL)
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        firstView.addSubview(line)
        
        contentView.addSubview(secondView)
        secondView.addSubview(returnMsgBtn)
        secondView.addSubview(cancleBtn)
        secondView.isHidden = true
        
        let line2 = UIView()
        line2.backgroundColor = RGBColor(0xE5E5E5)
        secondView.addSubview(line2)
        
        // layout
        firstView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(WH(41))
        }
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(firstView).offset(WH(20))
            make.centerY.equalTo(firstView)
        }
        
        operationL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(10))
            make.centerY.equalTo(firstView)
        }
        
        amountL.snp.makeConstraints { (make) in
            make.right.equalTo(firstView).offset(-WH(14))
            make.centerY.equalTo(firstView)
        }
        
        amountTitleL.snp.makeConstraints { (make) in
            make.right.equalTo(amountL.snp.left).offset(0)
            make.centerY.equalTo(firstView)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(firstView)
            make.height.equalTo(0.5)
        }
        
        secondView.snp.makeConstraints { (make) in
            make.top.equalTo(firstView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(WH(54))
        }
        
        returnMsgBtn.snp.makeConstraints { (make) in
            make.right.equalTo(secondView).offset(-WH(14))
            make.centerY.equalTo(secondView)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(70))
        }
        
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(secondView).offset(-WH(14))
            make.centerY.equalTo(secondView)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(70))
        }
        
        line2.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(secondView)
            make.height.equalTo(0.5)
        }
    }
    //使用的地方被屏蔽了
    func configView(_ model: RCListModel?) {
        rcModel = model
        
        if model!.rmaType == 0 {
            amountL.isHidden = false
            amountTitleL.isHidden = false
            imageV.image = UIImage(named: "returnGood_icon")
            operationL.text = "退货 " + model!.backWayName!
        }else{
            amountL.isHidden = true
            amountTitleL.isHidden = true
            imageV.image = UIImage(named: "replaceGood_icon")
            operationL.text = "换货 " + model!.backWayName!
        }
        
        amountL.text = String(format: "￥%.2f", (model?.refundAmount)!)
        cancleBtn.isHidden = true
        returnMsgBtn.isHidden = true
        if Int((model?.status)!) == 0 {
            cancleBtn.isHidden = false
        }else if model?.backWay == "MIC" && ((Int((model?.status!)!) == 1)||(Int((model?.status)!) == 4)||(Int((model?.status)!) == 5))  {
            returnMsgBtn.isHidden = false
        }
        if Int((model?.status)!) == 0 || (model?.backWay == "MIC" && ((Int((model?.status)!) == 1)||(Int((model?.status)!) == 4)||(Int((model?.status)!) == 5)) && model?.isSendExpress == false )  {
            secondView.isHidden = false
        }else{
            secondView.isHidden = true
        }
    }
    func configASView(_ asModel: ASApplyListInfoModel?) {
        // rcModel = model
        if let model = asModel {
            if  let num = model.rmaBizType ,num == 1 {
                operationL.snp.remakeConstraints { (make) in
                    make.left.equalTo(firstView.snp.left).offset(WH(20))
                    make.centerY.equalTo(firstView)
                }
                amountL.isHidden = false
                amountTitleL.isHidden = false
                imageV.isHidden = true
                operationL.text = "极速理赔"
            }else {
                operationL.snp.remakeConstraints { (make) in
                    make.left.equalTo(imageV.snp.right).offset(WH(10))
                    make.centerY.equalTo(firstView)
                }
                imageV.isHidden = false
                if model.rmaType == 0 {
                    amountL.isHidden = false
                    amountTitleL.isHidden = false
                    imageV.image = UIImage(named: "returnGood_icon")
                    operationL.text = "退货 " + model.backWayName!
                }else{
                    amountL.isHidden = true
                    amountTitleL.isHidden = true
                    imageV.image = UIImage(named: "replaceGood_icon")
                    operationL.text = "换货 " + model.backWayName!
                }
            }
            
            amountL.isHidden = true
            amountTitleL.isHidden = true
            if let priceCount = model.refundAmount ,priceCount > 0 {
                amountL.text = String(format: "￥%.2f", priceCount)
                amountL.isHidden = false
                amountTitleL.isHidden = false
            }
            
            cancleBtn.isHidden = true
            returnMsgBtn.isHidden = true
            secondView.isHidden = true
            if model.status == 0 {
                cancleBtn.isHidden = false
                secondView.isHidden = false
            }
        }
        
        
        //当个订单列表
        //            if Int((model?.status)!) == 0 {
        //                cancleBtn.isHidden = false
        //            }else if model?.backWay == "MIC" && ((Int((model?.status!)!) == 1)||(Int((model?.status)!) == 4)||(Int((model?.status)!) == 5))  {
        //                returnMsgBtn.isHidden = false
        //            }
        //            if Int((model?.status)!) == 0 || (model?.backWay == "MIC" && ((Int((model?.status)!) == 1)||(Int((model?.status)!) == 4)||(Int((model?.status)!) == 5)) && model?.isSendExpress == false )  {
        //                secondView.isHidden = false
        //            }else{
        //                secondView.isHidden = true
        //            }
        
    }
}
