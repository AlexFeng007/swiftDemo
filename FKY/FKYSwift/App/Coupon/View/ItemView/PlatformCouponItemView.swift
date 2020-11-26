//
//  PlatformCouponItemView.swift
//  FKY
//
//  Created by Rabe on 18/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  平台优惠券

import Foundation

protocol PlatformCouponItemViewOperation {
    /// 点击领取优惠券操作
    func onClickReceiveCouponAction(_ model: AnyObject) -> Void
    
    func onClickUseShopAction(_ model: AnyObject) -> Void

}

class PlatformCouponItemView: CouponItemView {
    // MARK: - properties
    var operation: PlatformCouponItemViewOperation?
    
    /// 子类业务差异化的ui属性
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - delegates
    
    // MARK: - action
    
    // MARK: - data
    
    /// 子类可覆载以下方法，设置非通用数据赋值及修改约束以满足业务场景
    override func configSettings() {
        let limitDesc = "查看可用商家"
        var unLimitDesc = "可购买全平台内的任意商品"
        let limitTitle = "1药城平台通用券"
        let unLimitTitle = "全平台通用"
        if let _ = model as? CouponTempModel {
            // 购物车、商品详情不会出现平台券
        } else if let vo = model as? CouponModel {
            unLimitDesc = ""
            detailDescLabel.text = vo.isLimitShop == 0 ? unLimitDesc : limitDesc
            titleDescLabel.text = vo.isLimitShop == 0 ? unLimitTitle : limitTitle
            detailDescLabel.textColor = RGBColor(0x487ae8)
            detailDescLabel.attributedText =  detailDescLabel.text?.fky_getAttributedStringWithUnderLine()
            if(vo.status==0 && vo.isLimitShop==1){
                detailDescLabel.isHidden=false
            }else{
                 detailDescLabel.isHidden=true
            }
            subTitleDescLabel.text = vo.couponDescribe
        } else if let vo = model as? FKYReCheckCouponModel {
            // 检查订单页限制文描由接口返回
            titleDescLabel.text = vo.tempEnterpriseName
            detailDescLabel.text = vo.isLimitProduct == 0 ? unLimitDesc : limitDesc
            if vo.tempEnterpriseName == limitTitle{
                detailDescLabel.text = limitDesc
                detailDescLabel.textColor = RGBColor(0x487ae8)
                 detailDescLabel.attributedText =  detailDescLabel.text?.fky_getAttributedStringWithUnderLine()
            }
//            if(vo.isUseCoupon==1){
//                detailDescLabel.isHidden=false
//            }else{
//                detailDescLabel.isHidden=true
//            }
            
        } else {
            print("未知优惠券item对象！")
        }
        //detailDescLabel.text =
    }
    override func detailDescLabelClick() {
         super.detailDescLabelClick()
        self.operation?.onClickUseShopAction(self.model!)
    }
    
    // MARK: - ui
    func setupView() {
        timeLabel.snp.updateConstraints { (make) in
            //make.top.equalTo(self.subTitleDescLabel.snp_bottom).offset(WH(0))
            make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(-7))
        }
        
        _ = interactButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.operation?.onClickReceiveCouponAction(strongSelf.model!)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    // MARK: - private methods
        
        
}
