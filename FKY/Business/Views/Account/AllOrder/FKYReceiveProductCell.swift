//
//  FKYReceiveProductCell.swift
//  FKY
//
//  Created by mahui on 16/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp确认收货界面之商品cell

import Foundation
import SnapKit

typealias GetProductNowCount = (Int, FKYReceiveProductModel)->()

class FKYReceiveProductCell: UITableViewCell {
    // MARK: - Property
    fileprivate var icon : UIImageView?
    fileprivate var name : UILabel?
    fileprivate var supply : UILabel?
    fileprivate var originNum : UILabel?
    fileprivate var realNum : UILabel?
    fileprivate var stepper : ShopStepper?
    @objc var nowCountBolock : GetProductNowCount?
    var productModel : FKYReceiveProductModel?
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    fileprivate func setupView() -> () {
        icon = {
           let v = UIImageView()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(j1)
                //make.top.equalTo(self.contentView.snp.top).offset(j4)
                make.centerY.equalTo(self.contentView)
                make.width.equalTo(p5.width)
                make.height.equalTo(p5.height)
            })
            return v
        }()
        name = {
            let v = UILabel()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo((icon?.snp.right)!).offset(j1)
                make.right.equalTo(self.contentView).offset(-WH(10))
                make.top.equalTo(self.contentView).offset(WH(5));
                make.height.equalTo(h8)
            })
            v.font = UIFont.boldSystemFont(ofSize: WH(13))
            v.textColor = t9.color
            return v
        }()
        supply = {
            let v = UILabel()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo((icon?.snp.right)!).offset(j1)
                make.top.equalTo(self.name!.snp.bottom)
                make.height.equalTo(h9)
            })
            v.font = t11.font
            v.textColor = t11.color
            return v
        }()

        originNum = {
            let v = UILabel()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo((icon?.snp.right)!).offset(j1)
                make.top.equalTo(self.supply!.snp.bottom)
                make.height.equalTo(h8)
            })
            v.fontTuple = t22;
            v.text = "采购数量: "
            return v
        }()
        
        stepper = {
            let v = ShopStepper()
            v.mpReceiveFlag = true
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(-j1)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-j1)
                make.height.equalTo(WH(28))
                make.width.equalTo(WH(120))
            })
            return v
        }()
        realNum = {
            let v = UILabel()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.right.equalTo((stepper?.snp.left)!).offset(-j1)
                make.centerY.equalTo(self.stepper!.snp.centerY)
                make.height.equalTo(h8)
            })
            v.fontTuple = t22;
            v.text = "实收货:"
            return v
        }()
        
        let line = UIView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(j1)
            make.right.equalTo(self.contentView)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.contentView)
        }
        line.backgroundColor = m2
        
        //
        stepper?.updateProductClosure = {(count : Int) in
            if self.nowCountBolock != nil {
                self.nowCountBolock!(count, self.productModel!)
            }
        }
    }
    
    // MARK: - Public
    @objc func configCellWithModel(_ receiveProduct : FKYReceiveProductModel?) -> () {
        self.productModel = receiveProduct
        
        if let model = receiveProduct {
            // 图片
            if let imgurl = model.productPicUrl, imgurl.isEmpty == false {
                icon?.sd_setImage(with: URL.init(string: imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "image_default_img"))
            }
            else {
                icon?.image = UIImage.init(named: "image_default_img")
            }
            // 名称
            var pname: String!
            var spec: String!
            if let n = model.productName, n.isEmpty == false {
                pname = n
            }
            if let s = model.spec, s.isEmpty == false {
                spec = s
            }
            if pname != nil, spec != nil {
                name?.text = pname + " " + spec
            }
            else if pname != nil {
                name?.text = pname
            }
            else if spec != nil {
                name?.text = spec
            }
            else {
                name?.text = nil
            }
            // 供应商
            if let fname = model.factoryName, fname.isEmpty == false {
                supply?.text = fname
            }
            else {
                supply?.text = nil
            }
            
            // 采购数量...<不再显示>
            if let buyNumber = model.buyNumber, buyNumber.intValue > 0 {
                originNum?.text = "采购数量: \(buyNumber)"
            }
            else {
                originNum?.text = "采购数量: "
            }
            originNum?.isHidden = true
            // 数量输入框
            if let deliveryCount = model.deliveryProductCount, deliveryCount.intValue >= 0 {
                stepper?.configStepperWithNowCount(0, stepCount: 1, stockCount: deliveryCount.intValue, nowCount: model.inputNumber)
                stepper?.updateButtonStatus()
            }
            else {
                stepper?.configStepperWithNowCount(0, stepCount: 1, stockCount: 0, nowCount: 0)
                stepper?.updateButtonStatus()
            }
        }
        else {
            icon?.image = UIImage.init(named: "image_default_img")
            name?.text = nil
            supply?.text = nil
            originNum?.text = "采购数量: "
            originNum?.isHidden = true
            stepper?.configStepperWithNowCount(0, stepCount: 1, stockCount: 0, nowCount: 0)
            stepper?.updateButtonStatus()
        }
    }
}
