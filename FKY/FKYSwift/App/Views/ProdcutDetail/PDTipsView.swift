//
//  PDTipsView.swift
//  FKY
//
//  Created by 寒山 on 2020/3/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class PDTipsView: UIView {
    
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        //imgview.image = UIImage.init(named: "icon_account_black_arrow")
        //imgview.image = UIImage.init(named: "img_pd_group_arrow")
        imgview.image = UIImage.init(named: "pd_bottom_dir")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 不可购买背景
    fileprivate lazy var nobuyView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFCF1)
        return view
    }()
    
    
    // 不可购买提示
    fileprivate lazy var nobuyLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0xE8772A)
        lbl.textAlignment = .center
        lbl.text = "您的所在地无法购买此商品"
        return lbl
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFE1CC)
        return view
    }()
    
    fileprivate lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bg5
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        //不可购买的提示
        addSubview(nobuyView)
        nobuyView.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.left.right.equalTo(self)
        }
        nobuyView.isHidden = true // 默认隐藏
        // 不可购买相关控件
        nobuyView.addSubview(nobuyLbl)
        nobuyLbl.snp.makeConstraints { (make) in
            make.edges.equalTo(nobuyView)
        }
        
        nobuyView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.left.right.equalTo(self)
        }
        nobuyView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.left.right.equalTo(self)
        }
        
        nobuyView.addSubview(imgviewArrow)
        imgviewArrow.isHidden = true
        imgviewArrow.snp.makeConstraints { (make) in
            make.height.equalTo(WH(13))
            make.width.equalTo(WH(7))
            make.right.equalTo(self).offset(WH(-10))
            make.centerY.equalTo(self)
        }
        
        
    }
    // 绑定model
    @objc func configView(_ model: FKYProductObject?, showBtn showContactBtn: Bool) {
        guard let _ = model else {
            return
        }
        // settingViewData(model,showContactBtn)
        
    }
    // 商品是否可购买的提示展示逻辑
    @objc func updatePurchaseStatus(_ prdModel:FKYProductObject?){
        self.isUserInteractionEnabled = false
        imgviewArrow.isHidden = true
        if let model = prdModel {
            if model.priceInfo.tips.count > 0 {
                if model.priceInfo.status == "2"{
                    nobuyView.isHidden = false
                    nobuyLbl.text = model.priceInfo.tips //"经营范围有误，去更新经营范围"
                    imgviewArrow.isHidden = false
                    self.isUserInteractionEnabled = true
                }else {
                    nobuyView.isHidden = false
                    nobuyLbl.text = model.priceInfo.tips
                }
            }else {
                nobuyView.isHidden = true
            }
        }
    }
    // 商品是否可购买的提示展示逻辑
    //    @objc func updatePurchaseStatus(_ canBuy: Bool, tip: String?, status: NSNumber?, showCombo: Bool) {
    //        self.isUserInteractionEnabled = false
    //        imgviewArrow.isHidden = true
    //        if status!.intValue == -5{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "商品暂时缺货"
    //        }else if status!.intValue == -2{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "商品控销，不可购买"
    //        }else if status!.intValue ==  -3{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "资质认证后可见"
    //        }else if status!.intValue == 1{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "超过商家销售区域"
    //        }else if status!.intValue == -13{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "已达限购总数"
    //        }else if status!.intValue == -7{
    //            nobuyView.isHidden = false
    //            nobuyLbl.text = "已下架"
    //        }else if canBuy{
    //            // 可购买
    //            if showCombo == true {
    //                nobuyView.isHidden = false
    //                nobuyLbl.text = "单品暂不支持销售，买套餐更优惠"
    //            }else {
    //                nobuyView.isHidden = true
    //            }
    //            // viewUpdate.isHidden = true
    //        }
    //        else {
    //            // 不可购买
    //            nobuyView.isHidden = false
    //            // viewUpdate.isHidden = true
    //            if status!.intValue == 2{
    //                nobuyView.isHidden = false
    //                nobuyLbl.text = "经营范围有误，去更新经营范围"
    //                imgviewArrow.isHidden = false
    //                self.isUserInteractionEnabled = true
    //            }else if let t = tip, t.isEmpty == false {
    //                nobuyLbl.text = t
    //            }
    //            else {
    //                nobuyLbl.text = "当前商品暂不可购买"
    //            }
    //        }
    //    }
}
