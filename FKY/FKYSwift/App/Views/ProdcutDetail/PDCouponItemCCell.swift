//
//  PDCouponItemCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/1/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (商详)优惠券cell上的单个优惠券ccell

import UIKit

class PDCouponItemCCell: UICollectionViewCell {
    //MARK: - Property
    
    // 背景图
    fileprivate lazy var imgviewBg: UIImageView! = {
        let imgview = UIImageView()
        //imgview.image = UIImage.init(named: "img_coupon_item_bg")
       // imgview.image = UIImage.init(named: "img_pd_coupon_bg")
        
//        if let image = UIImage.init(named: "img_coupon_item_bg") {
//            var img = image.stretchableImage(withLeftCapWidth: 20, topCapHeight: 10)
//            imgview.image = img
//        }
        
        return imgview
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFFFFFF)
        lbl.font = UIFont.systemFont(ofSize: WH(11))
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(self.imgviewBg)
        self.imgviewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        self.contentView.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            //make.edges.equalTo(self)
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(4))
            make.right.equalTo(contentView).offset(WH(-4))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ showContent: Bool, _ coupon: Any?) {
        self.imgviewBg?.isHidden = !showContent
        self.lblTitle.isHidden = !showContent
        
        if let model = coupon as? CouponTempModel {
            //店铺详情中返回的入口模型
            if model.tempType == 0 {
                //店铺券
                self.imgviewBg.image = UIImage.init(named: "shop_coupon_small_pic")
            }else {
                //平台券
                self.imgviewBg.image = UIImage.init(named: "platform_coupon_small_bg_pic")
            }
            self.lblTitle.text = PDCouponItemCCell.getCouponTitle(model.limitprice,model.denomination)
        }else if let model = coupon as? CommonCouponNewModel {
            //商品详情中返回的入口模型
            if model.tempType == 0 {
                //店铺券
                self.imgviewBg.image = UIImage.init(named: "shop_coupon_small_pic")
            }else {
                //平台券
                self.imgviewBg.image = UIImage.init(named: "platform_coupon_small_bg_pic")
            }
            self.lblTitle.text = PDCouponItemCCell.getCouponTitle(model.limitprice,model.denomination)
        }else {
            self.lblTitle.text = nil
        }
    }
    
    // 计算单个优惠券标题文字的宽度...<不再使用当前方法，按测试要示，优惠券ccell宽度固定~!@>
    @objc class func getCouponItemWidth(_ coupon: Any?) -> CGFloat {
        var title = "" // 标题
        if let model = coupon as? CouponTempModel {
            //店铺详情中返回的入口模型
            title = PDCouponItemCCell.getCouponTitle(model.limitprice,model.denomination)
        }else if let model = coupon as? CommonCouponNewModel {
            title = PDCouponItemCCell.getCouponTitle(model.limitprice,model.denomination)
        }else {
            // 默认宽度
            return WH(88)
        }
        // 开始计算
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(20))
        let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13))]
        let strSize = title.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        var width = strSize.width + WH(5) * 2
        
        // 最小宽度
        if width < WH(88) {
            width = WH(88)
        }
        // 最大宽度
        //let maxWidth = ( SCREEN_WIDTH - WH(97) - WH(5) ) / 2 // 一行放两个时的最大宽度
        let maxWidth = SCREEN_WIDTH - WH(97) // 一行放一个时的最大宽度
        if width > maxWidth {
            width = maxWidth
        }
        return width
    }
    
    
    // MARK: - Private
    
    // 拼接优惠券标题文字
    fileprivate class func getCouponTitle(_ limitprice : Int?,_ denomination : Int?) -> String {
        var total: String = "--"
        var save: String = "--"
        if let t = limitprice {
            total = "\(t)"
        }
        if let s = denomination {
            save = "\(s)"
        }
        let title = "满" + total + "减" + save
        return title
    }
}
