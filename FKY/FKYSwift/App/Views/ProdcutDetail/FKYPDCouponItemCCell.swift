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
        imgview.image = UIImage.init(named: "img_coupon_item_bg")
        
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
        lbl.textColor = RGBColor(0xFFF0F1)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
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
            make.edges.equalTo(self)
        }
        
        self.contentView.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            //make.edges.equalTo(self)
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(j11)
            make.right.equalTo(self).offset(-j11)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ showContent: Bool, _ coupon: CouponTempModel?) {
        self.imgviewBg?.isHidden = !showContent
        self.lblTitle.isHidden = !showContent
        
        if let item = coupon {
            self.lblTitle.text = FKYPDCouponItemCCell.getCouponTitle(item)
        }
        else {
            self.lblTitle.text = nil
        }
    }
    
    // 计算单个优惠券标题文字的宽度...<不再使用当前方法，按测试要示，优惠券ccell宽度固定~!@>
    class func getCouponItemWidth(_ coupon: CouponTempModel?) -> CGFloat {
        if let item = coupon {
            // 标题
            let title = FKYPDCouponItemCCell.getCouponTitle(item)
            
            // 开始计算
            let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(20))
            let dic = [NSFontAttributeName: UIFont.systemFont(ofSize: WH(13))]
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
        // 默认宽度
        return WH(88)
    }
    
    
    // MARK: - Private
    
    // 拼接优惠券标题文字
    fileprivate class func getCouponTitle(_ coupon: CouponTempModel) -> String {
        var total: String = "--"
        var save: String = "--"
        if let t = coupon.limitprice {
            total = "\(t)"
        }
        if let s = coupon.denomination {
            save = "\(s)"
        }
        let title = "满" + total + "减" + save
        return title
    }
}
