//
//  FKYContactView.swift
//  FKY
//
//  Created by hui on 2019/8/19.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYContactView: UIView {
    //
    fileprivate lazy var strOneLabel : UILabel = {
        let label = UILabel()
        label.text = "旧手机号不可用？"
        label.fontTuple = t20
        label.textAlignment = .center
        return label
    }()
    //手机号码
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = t20.font
        label.isUserInteractionEnabled = true
        label.textColor = RGBColor(0xFF2D5D)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.bk_(whenTapped: {
            FKYProductAlertView.show(withTitle: nil, leftTitle: "拨号", rightTitle: "取消", message:self.phoneStr, handler: { (alertView, isRight) in
                if !isRight {
                    UIApplication.shared.openURL(URL.init(string: "tel:"+self.phoneStr)!)
                }
            })
        })
        return label
    }()
    //
    fileprivate lazy var strTwoLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t20
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //
    fileprivate lazy var strThreeLabel : UILabel = {
        let label = UILabel()
        label.text = "更换绑定手机号码"
        label.fontTuple = t20
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    var phoneStr = ""
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.addSubview(self.strOneLabel)
        self.strOneLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.right.left.equalTo(self)
        }
        let bgView = UIView()
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.strOneLabel.snp.bottom).offset(WH(5))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(20))
            make.height.equalTo(WH(13))
        }
        
        bgView.addSubview(self.strTwoLabel)
        self.strTwoLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bgView)
            make.left.equalTo(bgView.snp.left)
        }
        
        bgView.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bgView)
            make.left.equalTo(self.strTwoLabel.snp.right)
        }
        
        bgView.addSubview(self.strThreeLabel)
        self.strThreeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bgView)
            make.left.equalTo(self.phoneLabel.snp.right)
            make.right.equalTo(bgView.snp.right)
        }
    }
    func configData(_ infoModel :FKYSalesPersonInfoModel){
        if let name = infoModel.salesName ,name.count > 0 ,let salePhone = infoModel.salesPhoneNumber ,salePhone.count > 0 {
           //有bd信息
            strTwoLabel.text = "请联系BD\(name)："
            self.phoneLabel.text = salePhone
            self.phoneStr = salePhone
        }else if let consumerPhone = infoModel.consumerHotline ,consumerPhone.count > 0  {
            strTwoLabel.text = "请拨打1药城客服电话"
            self.phoneLabel.text = consumerPhone
            self.phoneStr = consumerPhone
        }else{
            self.strOneLabel.text = ""
            self.phoneLabel.text = ""
            self.strTwoLabel.text = ""
            self.strThreeLabel.text = ""
        }
    }
}
