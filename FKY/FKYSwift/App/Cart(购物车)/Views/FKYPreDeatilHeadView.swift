//
//  FKYPreDeatilHeadView.swift
//  FKY
//
//  Created by yyc on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//购物车查看明细头视图

import UIKit

class FKYPreDeatilHeadView: UIView {
    //企业标签
    fileprivate var tagIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //企业名称
    fileprivate lazy var enterpriseLabel : UILabel = {
        let label = UILabel()
        label.font =  t21.font
        label.textColor = t31.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //顶部分隔线
//    fileprivate lazy var topLine : UIView = {
//        let view = UIView()
//        view.backgroundColor = bg7
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.white
        self.addSubview(tagIcon)
        tagIcon.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(WH(12))
            make.left.equalTo(self.snp.left).offset(WH(18))
           // make.width.equalTo(WH(61))
            //make.height.equalTo(WH(15))
        })
        self.addSubview(enterpriseLabel)
        enterpriseLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(tagIcon.snp.centerY)
            make.left.equalTo(tagIcon.snp.right).offset(WH(7))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(18+61+7+10))
            make.height.equalTo(WH(14))
        })
//        self.addSubview(topLine)
//        topLine.snp.makeConstraints({ (make) in
//            make.top.left.right.equalTo(self)
//            make.height.equalTo(0.5)
//        })
    }
}
//MARK:数据处理
extension FKYPreDeatilHeadView {
    func configPreDetailHeadViewData(_ dataModel : Any) {
        if let model = dataModel as? CartMerchantInfoModel {
            enterpriseLabel.text = model.supplyName
            if let type = model.supplyType,type == 0 {
                //自营
                if let str = model.shortWarehouseName ,str.count > 0 {
                    if let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: str, colorType: .blue) {
                         tagIcon.image = tagImage
                    }else {
                       tagIcon.image = UIImage(named: "self_shop_icon")
                    }
                }else {
                    tagIcon.image = UIImage(named: "self_shop_icon")
                }
            }else {
                //mp
                tagIcon.image = UIImage(named: "mp_shop_icon")
            }
        }else if let model = dataModel as? CartChangeInfoModel {
            enterpriseLabel.text = model.supplyName
            if let type = model.supplyType,type == "0" {
                //自营
                if let str = model.shortWarehouseName ,str.count > 0 {
                    if let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: str, colorType: .blue) {
                         tagIcon.image = tagImage
                    }else {
                       tagIcon.image = UIImage(named: "self_shop_icon")
                    }
                }else {
                    tagIcon.image = UIImage(named: "self_shop_icon")
                }
            }else {
                //mp
                tagIcon.image = UIImage(named: "mp_shop_icon")
            }
        }else if let model = dataModel as? PDOrderChangeInfoModel {
            enterpriseLabel.text = model.supplyName
            if let type = model.supplyType,type == "0" {
                //自营
                if let str = model.shortWarehouseName ,str.count > 0 {
                    if let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: str, colorType: .blue) {
                         tagIcon.image = tagImage
                    }else {
                       tagIcon.image = UIImage(named: "self_shop_icon")
                    }
                }else {
                    tagIcon.image = UIImage(named: "self_shop_icon")
                }
            }else {
                //mp
                tagIcon.image = UIImage(named: "mp_shop_icon")
            }
        }
        
        
    }
    //商品异常弹框中使用
//    func hideTopLine(_ hasHide:Bool) {
//        tagIcon.snp.updateConstraints { (make) in
//            make.top.equalTo(self.snp.top).offset(WH(13))
//        }
//        topLine.isHidden = hasHide
//    }
    
}
