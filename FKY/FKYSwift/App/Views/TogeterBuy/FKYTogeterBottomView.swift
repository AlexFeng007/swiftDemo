//
//  FKYTogeterBottomView.swift
//  FKY
//
//  Created by hui on 2018/10/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterBottomView: UIView {
    fileprivate lazy var activityStatueLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF394E)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        return label
    }()
    fileprivate lazy var activityStatueTwoLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF394E)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.text = "认购已结束"
        return label
    }()
    // 抢购
    fileprivate lazy var statusBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("未登录", for: .normal)
        btn.titleLabel?.font = t17.font
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.clickStatusBtnAction()
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        return btn
    }()
    // 加车按钮
    fileprivate lazy var stepperBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = t73.font
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.backgroundColor = RGBColor(0xFFEDE7)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.addCartBlock {
                block()
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        return btn
    }()
    
    // 加车控件
//    fileprivate lazy var stepper: CartStepper = {
//        let stepper = CartStepper()
//        stepper.togeterBuyDetailPattern()
//        //
//        stepper.toastBlock = { [weak self] (str) in
//            guard let strongSelf = self else {
//                return
//            }
//            if let closure = strongSelf.toastAddProductNum {
//                closure(str!)
//            }
//        }
//        // 修改数量时候
//        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
//            guard let strongSelf = self else {
//                return
//            }
//            if let closure = strongSelf.updateAddProductNum {
//                closure(count,typeIndex)
//            }
//        }
//        //点击了➕
//        stepper.addBlock = { [weak self] in
//            guard let strongSelf = self else {
//                return
//            }
//            if let closure = strongSelf.addCartBlock {
//                closure()
//            }
//        }
//        return stepper
//    }()
    
    //var updateAddProductNum: addCarClosure? //加车更新
    //var toastAddProductNum : SingleStringClosure? //加车提示
    var clickStatusBtn: ((_ typeIndex : Int)->())? //点击功能按钮
    var addCartBlock : (()->())? //点击加车按钮号
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        self.addSubview(self.activityStatueLabel)
        self.activityStatueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(24))
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(WH(16))
        }
        self.addSubview(self.activityStatueTwoLabel)
        self.activityStatueTwoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.activityStatueLabel.snp.bottom).offset(WH(2))
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(WH(16))
        }
        self.addSubview(self.statusBtn)
        self.statusBtn.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.snp.top).offset(WH(11))
            make.centerX.equalTo(strongSelf.snp.centerX)
            make.width.equalTo(WH(160))
            make.height.equalTo(WH(43))
        }
        self.addSubview(stepperBtn)
        
        
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        self.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(0.5)
        })
    }
    
}
extension FKYTogeterBottomView {
    func configViewData(_ detailModel : FKYTogeterBuyDetailModel?) {
        if let model = detailModel {
            self.activityStatueLabel.isHidden = true
            self.activityStatueTwoLabel.isHidden = true
            self.statusBtn.isHidden = true
            self.stepperBtn.isHidden = true
            self.statusBtn.snp.remakeConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.snp.top).offset(WH(11))
                make.centerX.equalTo(strongSelf.snp.centerX)
                make.width.equalTo(WH(160))
                make.height.equalTo(WH(43))
            }
            if FKYLoginAPI.loginStatus() == .unlogin {
                //未登录
                self.statusBtn.isHidden = false
                self.statusBtn.setTitle("未登录", for: .normal)
                self.statusBtn.tag = 0
            }else {
                if model.projectStatus == 4  {
                    self.activityStatueLabel.isHidden = false
                    self.activityStatueLabel.text = "认购已结束"
                    self.backgroundColor = RGBColor(0xFFF7F6)
                    self.activityStatueLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.top).offset(WH(24))
                    }
                }else if model.projectStatus == 3 {
                    self.activityStatueLabel.isHidden = false
                    self.activityStatueLabel.text = "成团成功"
                    self.backgroundColor = RGBColor(0xFFF7F6)
                    self.activityStatueLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.top).offset(WH(15))
                    }
                    self.activityStatueTwoLabel.isHidden = false
                }
                else if model.projectStatus == 2 {
                    self.activityStatueLabel.isHidden = false
                    self.activityStatueLabel.text = "成团失败"
                    self.backgroundColor = RGBColor(0xFFF7F6)
                    self.activityStatueLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.top).offset(WH(24))
                    }
                }
                else if model.projectStatus == 5 {
                    self.activityStatueLabel.isHidden = false
                    self.activityStatueLabel.text = "认购未开始"
                    self.backgroundColor = RGBColor(0xFFF7F6)
                    self.activityStatueLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.top).offset(WH(24))
                    }
                }
                else if model.projectStatus == 0 {
                    self.statusBtn.isHidden = false
                    
                    if detailModel?.isCheck == "0" {
                        self.statusBtn.tag = 2
                        self.statusBtn.setTitle("资质未认证", for: .normal)
                    }else {
                        //可以购买状态
                        self.statusBtn.tag = 1
                        self.stepperBtn.isHidden = false
                        self.backgroundColor = RGBColor(0xffffff)
                        self.statusBtn.snp.remakeConstraints {[weak self] (make) in
                            guard let strongSelf = self else {
                                return
                            }
                            make.top.equalTo(strongSelf.snp.top).offset(WH(10))
                            make.right.equalTo(strongSelf.snp.right).offset(-WH(20))
                            make.width.equalTo(WH(160))
                            make.height.equalTo(WH(42))
                        }
                        self.statusBtn.setTitle("立即购买", for: .normal)
                        stepperBtn.snp.makeConstraints({[weak self] (make) in
                            guard let strongSelf = self else {
                                return
                            }
                            make.centerY.equalTo(strongSelf.statusBtn.snp.centerY)
                            make.left.equalTo(strongSelf).offset(WH(20))
                            make.right.equalTo(strongSelf.statusBtn.snp.left).offset(-WH(15))
                            make.height.equalTo(WH(42))
                        })
                    }
                }
            }
            
            //为0代表达到最大可购买数量了设置加车器不能点击了
            if  model.surplusNum != nil && model.surplusNum! == 0  {
                self.stepperBtn.isEnabled = false
            }else {
                self.stepperBtn.isEnabled = true
                if model.carOfCount != 0 {
                    self.stepperBtn.setTitle("已加入购物车 (\(model.carOfCount))", for: .normal)
                }else {
                    self.stepperBtn.setTitle("加入购物车", for: .normal)
                }
            }
        }
    }
    func clickStatusBtnAction(){
        if let block = self.clickStatusBtn {
            block(self.statusBtn.tag)
        }
    }
    //初始化加车计数器
//    func configStepCount(_ model : FKYTogeterBuyDetailModel) {
//        //
//        var num: NSInteger = 0
//        if let count = model.currentInventory {
//            num = count
//        }else{
//            num = 0
//        }
//
//        //限购的数量
//        var exceedLimitBuyNum : NSInteger = 0
//        if  model.surplusNum != nil && model.surplusNum! > 0 {
//            exceedLimitBuyNum = model.surplusNum!
//        }else{
//            exceedLimitBuyNum = 0
//        }
//
//        //计算特价
//        let quantityCount = model.carOfCount != 0 ? model.carOfCount : 0
//
//        //
//        var baseCount = model.projectUnit ?? 1
//        var stepCount = model.projectUnit ?? 1
//        if baseCount == 0 {
//            baseCount = 1
//        }
//        if stepCount == 0 {
//            stepCount = 1
//        }
//
//        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:false,and:0)
//    }
}
