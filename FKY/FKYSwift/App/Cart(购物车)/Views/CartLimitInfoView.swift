//
//  CartLimitInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/12/12.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class CartLimitInfoView: UIView {
    fileprivate lazy var firstTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.layer.cornerRadius = WH(9)
        label.layer.masksToBounds = true
        return label
    }()
    
    fileprivate lazy var secondTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.layer.cornerRadius = WH(9)
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .clear
        self.addSubview(firstTagLabel)
        self.addSubview(secondTagLabel)
        
        firstTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(0)
            make.height.equalTo(WH(18))
        }
        
        secondTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstTagLabel.snp.right).offset(WH(6))
            make.bottom.equalTo(self)
            make.width.equalTo(0)
            make.height.equalTo(WH(18))
        }
    }
    func configTagView(_ productModel:CartProdcutnfoModel){
        //特价标签
        firstTagLabel.isHidden = true
        secondTagLabel.isHidden = true
        
        var tempTagTextList = [String]()
        if !(productModel.canUseCouponFlag ?? true) {
            tempTagTextList.append("不可用券")
        }
        
        if (productModel.reachLimitNum ?? false) {
            tempTagTextList.append("已达特价限购数量")
        }
        
        if (productModel.promotionVip?.reachVipLimitNum ?? false){
            tempTagTextList.append("已达会员价限购数量")
        }
        if productModel.isHasSomeKindPromotion(["2001"]){
             //有专享价
            if let joinDesc = productModel.getExclusivePromotionDesc(["2001"]) ,joinDesc.isEmpty == false{
                tempTagTextList.append(joinDesc)
            }
        }
        //搭配套餐 主品每次限购标
        if let limitNum = productModel.comboProductLimitNum,limitNum > 0{
             tempTagTextList.append("每次限购\(limitNum)\(productModel.unit ?? "个")")
        }
        //周限购标签
        if ([2].contains(productModel.productLimitBuy?.cycleType) ){
            tempTagTextList.append(productModel.productLimitBuy?.limitTextMsg ?? "")
        }
        if tempTagTextList.isEmpty == true{
            return
        }
        for index in 0...(tempTagTextList.count - 1){
            if index == 0{
                firstTagLabel.isHidden = false
                let tag = tempTagTextList[index]
                firstTagLabel.text = tag
                let priceContentSize = tag.boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(15)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(12))], context: nil).size
                firstTagLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(priceContentSize.width + WH(16))
                }
            }else if index == 1{
                
                secondTagLabel.isHidden = false
                let tag = tempTagTextList[index]
                secondTagLabel.text = tag
                let priceContentSize = tag.boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(15)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(12))], context: nil).size
                secondTagLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(priceContentSize.width + WH(16))
                }
            }
        }
    }
    
}
