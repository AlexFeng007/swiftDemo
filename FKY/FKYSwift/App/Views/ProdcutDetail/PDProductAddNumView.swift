//
//  PDProductAddNumView.swift
//  FKY
//
//  Created by hui on 2018/5/16.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class PDProductAddNumView: UIView {
    fileprivate lazy var settingBtn: UIButton = {
        let button = UIButton()
        button.setTitle("加入购物车", for: UIControl.State())
        button.backgroundColor = btn21.defaultStyle.color
        button.setTitleColor(btn21.title.color, for: UIControl.State())
        button.titleLabel?.font = t10.font
        button.backgroundColor = RGBColor(0xFF2D5C)
        button.setTitleColor(UIColor.white, for:UIControl.State())
        // 加入购物车
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addNumClosure {
                if let num = strongSelf.stepper.countLabel.text, num.count > 0 {
                    closure(Int(num)!)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    @objc lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        //stepper.changeViewPatternWithSingle()
        stepper.setAddFlag(true)
        stepper.productDetailUiUpdatePattern()
        stepper.resetCountLabelPattern()
        stepper.toastBlock = { [weak self] (str) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.toastClosure {
                closure(str!)
            }
        }
        return stepper
    }()
    
    fileprivate lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x555555)
        label.font = t9.font
        label.text = "选择购买数量"
        return label
    }()
    
    @objc var addNumClosure: IntClosure?
    @objc var toastClosure: SingleStringClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg5
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(self.settingBtn)
        self.settingBtn.snp.makeConstraints ({ (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(WH(46))
        })
        
        self.addSubview(self.stepper)
        self.stepper.snp.makeConstraints ({ (make) in
            //make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.settingBtn.snp.top).offset(-WH(25))
            make.height.equalTo(WH(36))
            //make.width.equalTo(WH(129))
            make.left.right.equalTo(self)
        })
        
        self.addSubview(self.titleLable)
        self.titleLable.snp.makeConstraints ({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.stepper.snp.top).offset(-WH(18))
            make.height.equalTo(WH(13))
        })
    }
    
    @objc func configViewWithProductDetailModel(_ model : FKYProductObject) -> () {
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count.intValue
        }else{
            num = 0
        }
        //限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if let info = model.productLimitInfo, info.surplusBuyNum > 0 {
            exceedLimitBuyNum = info.surplusBuyNum
        }else{
            exceedLimitBuyNum = 0
        }
        //判断特价商品
        var istj : Bool = false
        var minCount = 0
//        if model.productPromotion != nil  {
//            istj = true
//            minCount = (model.productPromotion?.minimumPacking)!
//        }
        if let num = model.minBatch, num.intValue > 0 {
            istj = true
            minCount = num.intValue
        }
        //
        let quantityCount = model.carOfCount != nil ?  model.carOfCount.intValue : 0
        
        //
        var baseCount = 1
        var stepCount = 1
        if let num = model.minPackage ,num.intValue > 0 {
            baseCount = num.intValue
            stepCount = num.intValue
        }
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj, and:minCount)
    }
}
