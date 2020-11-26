//
//  ShopCouponItemView.swift
//  FKY
//
//  Created by Rabe on 18/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  店铺优惠券

import Foundation
import SnapKit

protocol ShopCouponItemViewOperation {
    /// 点击查看更多商品
    func onClickSearchProductAction(_ model: AnyObject) -> Void
    
    /// 点击领取优惠券操作
    func onClickReceiveCouponAction(_ model: AnyObject) -> Void
}

class ShopCouponItemView: CouponItemView {
    // MARK: - properties
    var operation: ShopCouponItemViewOperation?
    
    /// 子类业务差异化的ui属性
    /// 查看可用商品
    fileprivate lazy var seeProductLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .left
        label.textColor = RGBColor(0x477ae9)
        let str = "查看可用商品"
        label.attributedText = str.fky_getAttributedStringWithUnderLine()
        label.isUserInteractionEnabled = true
        label.bk_(whenTouches: 1, tapped: 1, handler: {
            self.operation?.onClickSearchProductAction(self.model!)
        })
        return label
    }()
    
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
        let limitDesc = "可购买该店铺内的指定商品"
        let unLimitDesc = "可购买该店铺内的任意商品"
        if let vo = model as? CouponTempModel {
            detailDescLabel.text = vo.isLimitProduct == 0 ? unLimitDesc : limitDesc
            titleDescLabel.text = vo.tempEnterpriseName
        } else if let vo = model as? CouponModel {
            detailDescLabel.text = ""
            if vo.couponDescribe.count > 0 {
                subTitleDescLabel.text = vo.couponDescribe
            }else {
                subTitleDescLabel.text = vo.isLimitProduct == 0 ? unLimitDesc : limitDesc
            }
            titleDescLabel.text = vo.tempEnterpriseName
            // 点击领取后如果成功，变更按钮状态
            if vo.receiveCouponStatus == 1 {
                interactButton.setTitle("已领取", for: .normal)
                interactButton.setTitleColor(RGBColor(0xffffff), for: .normal)
                interactButton.backgroundColor = RGBColor(0xffab7c)
                interactButton.isEnabled = false
            }
        } else if let vo = model as? FKYReCheckCouponModel {
            detailDescLabel.text = vo.isLimitProduct == 0 ? unLimitDesc : limitDesc
            titleDescLabel.text = vo.tempEnterpriseName
        } else {
            print("未知优惠券item对象！")
        }
        // 优惠券在商详页出现时，不展示此内容。 已过期的优惠券，就不用显示了
        if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE || usageType == . PRODUCTDETAIL_GET_COUPON_RECEIVED || usageType == .MY_COUPON_LIST_OUTDATE || usageType == .MY_COUPON_LIST_USED{
            seeProductLabel.isHidden = true
            timeLabel.snp.updateConstraints { (make) in
                //make.top.equalTo(bgView.snp.centerY).offset(WH(5))
                make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(-7))
            }
        } else {
            seeProductLabel.isHidden = false
            timeLabel.snp.updateConstraints { (make) in
                //make.top.equalTo(bgView.snp.centerY).offset(WH(-5))
                make.top.equalTo(self.titleDescLabel.snp_bottom).offset(WH(-7))
            }
        }
        
        // 优惠券弹窗点击领取允许点击整个优惠券区域进行领取
        if usageType == .PRODUCTDETAIL_GET_COUPON_RECEIVE || usageType == .CART_GET_COUPON_RECEIVE {
            self.bk_(whenTouches: 1, tapped: 1, handler: {
                self.operation?.onClickReceiveCouponAction(self.model!)
            })
        }
    }
    
    // MARK: - ui
    
    func setupView() {
        addSubview(seeProductLabel)
        
        seeProductLabel.snp.makeConstraints { (make) in
            make.left.equalTo(detailDescLabel)
            make.top.equalTo(subTitleDescLabel.snp.bottom).offset(WH(5))
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
