//
//  FKYShopActivityHeaderView.swift
//  FKY
//
//  Created by hui on 2019/6/20.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopActivityHeaderView: UIView {
    //ui相关
    //shop_icon
    fileprivate lazy var shopIconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "shop_icon_pic")
        return iv
    }()
    //shop_name
    fileprivate lazy var shopNameLabel : UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = t34.color
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    //文字描述背景
    fileprivate lazy var desBgView : UIView = {
        let iv = UIView()
        iv.frame = CGRect.init(x: WH(12), y: WH(5+20+9), width: SCREEN_WIDTH-WH(12)*2, height: WH(61))
        iv.backgroundColor = UIColor.white
        iv.layer.cornerRadius = WH(4)
        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        iv.layer.shadowColor = RGBColor(0x000000).cgColor
        iv.layer.shadowOpacity = 0.1;//阴影透明度，默认0
        iv.layer.shadowRadius = 6;//阴影半径
        return iv
    }()
    
    //已经购买过满减。满赠，返利提示
    fileprivate lazy var activityAlertLabel : UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = t31.color
        label.numberOfLines = 0
        return label
    }()
    //满减。满赠，返利活动文描
    fileprivate lazy var activityTipLabel : UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t37.color
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(self.shopIconImage)
        self.shopIconImage.snp.makeConstraints ({ (make) in
            make.top.equalTo(self.snp.top).offset(WH(5))
            make.left.equalTo(self.snp.left).offset(WH(9))
            make.height.width.equalTo(WH(20))
        })
        self.addSubview(self.shopNameLabel)
        self.shopNameLabel.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(self.shopIconImage.snp.centerY)
            make.left.equalTo(self.shopIconImage.snp.right)
            make.right.equalTo(self.snp.right).offset(-WH(12))
        })
        self.addSubview(self.desBgView)
        
        self.desBgView.addSubview(self.activityAlertLabel)
        self.activityAlertLabel.snp.makeConstraints ({ (make) in
            make.top.equalTo(self.desBgView.snp.top).offset(WH(12))
            make.left.equalTo(self.desBgView.snp.left).offset(WH(12))
            make.right.equalTo(self.desBgView.snp.right).offset(-WH(12))
        })
        self.desBgView.addSubview(self.activityTipLabel)
        self.activityTipLabel.snp.makeConstraints ({ (make) in
            make.bottom.equalTo(self.desBgView.snp.bottom).offset(-WH(12))
            make.left.equalTo(self.desBgView.snp.left).offset(WH(12))
            make.right.equalTo(self.desBgView.snp.right).offset(-WH(12))
        })
    }
    
}
//MARK:赋值及更新
extension FKYShopActivityHeaderView {
    func getShopActivityHeaderHeight(_ alertStr:String ,_ tipStr:String,_ shopName:String) -> CGFloat {
        self.shopNameLabel.text = shopName
        self.activityAlertLabel.text = alertStr
        self.activityTipLabel.text = tipStr
        var view_h = WH(5+20+9+12) //计算整体高度
        var bgView_h = WH(12+12+6) //计算整体高度
        var alertLabelH : CGFloat = 0
        var tipLabelH : CGFloat = 0
        if alertStr.count > 0 {
            alertLabelH =  alertStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(24)*2, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
            self.activityAlertLabel.isHidden = false
        }else {
            self.activityAlertLabel.isHidden = true
        }
        if alertLabelH > 0 {
            bgView_h = bgView_h + alertLabelH
        }else{
            bgView_h = bgView_h - WH(6)
        }
        if tipStr.count > 0 {
            tipLabelH =  tipStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(24)*2, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t28.font], context: nil).height
            self.activityTipLabel.isHidden = false
        }else {
            self.activityTipLabel.isHidden = true
        }
        if tipLabelH > 0 {
            bgView_h = bgView_h + tipLabelH
        }else{
            bgView_h = bgView_h - WH(6)
        }
        if tipLabelH == 0 && alertLabelH == 0 {
            bgView_h = 0
            view_h = view_h - WH(12) - WH(4)
            self.desBgView.isHidden = true
        }else{
            self.desBgView.isHidden = false
        }
        self.desBgView.frame = CGRect.init(x: WH(12), y: WH(5+20+9), width: SCREEN_WIDTH-WH(12)*2, height: bgView_h)
        return view_h + bgView_h
    }
}
