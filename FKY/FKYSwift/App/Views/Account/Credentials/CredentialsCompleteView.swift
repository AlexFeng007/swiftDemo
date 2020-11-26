//
//  CredentialsCompleteView.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/4.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class CredentialsCompleteTopView: UIView {
    //MARK: Property
    fileprivate lazy var imageViewContent: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "image_credentials_complete_top")
        return iv
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGBColor(0x3580FA)
        
        addSubview(imageViewContent)
        if(IS_IPHONE6PLUS) {
            let imageSize: CGSize = imageViewContent.intrinsicContentSize
            imageViewContent.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.centerY.equalTo(self)
                make.centerX.equalTo(self)
                make.width.equalTo(imageSize.width*1.2)
            })
        }else {
            imageViewContent.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Override UIView
    override var intrinsicContentSize : CGSize {
        if(IS_IPHONE6PLUS) {
            return CGSize(width: SCREEN_WIDTH, height: imageViewContent.intrinsicContentSize.height*1.2)
        }else {
            return CGSize(width: SCREEN_WIDTH, height: imageViewContent.intrinsicContentSize.height)
        }
    }
    
}

class CredentialsCompleteView: UIView {
    
    fileprivate var telephoneTitleLabel: UILabel?
    fileprivate var telephoneLabel: UILabel?
//    private var addressTitleLabel: UILabel?
    fileprivate var addressDetailLabel: UILabel?
    fileprivate var remindDetailLabel: UILabel?
    
    //MARK: Private Method
    fileprivate func setupView() {
        
        let viewTop = CredentialsCompleteTopView()
        addSubview(viewTop)
        viewTop.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        })
        
        let warningLabel = UILabel()
        warningLabel.font = UIFont.systemFont(ofSize: WH(16))
        warningLabel.textColor = RGBColor(0x343434)
        warningLabel.textAlignment = .center
        warningLabel.text = "请您继续将纸质资料邮寄给我们!"
        warningLabel.backgroundColor = RGBColor(0xF5F5F5)
        addSubview(warningLabel)
        warningLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(viewTop.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(WH(44))
        })
        
        let imageViewAddress = UIImageView()
        imageViewAddress.image = UIImage(named: "icon_credentials_complete_location")
        addSubview(imageViewAddress)
        imageViewAddress.snp.makeConstraints({ (make) in
            if IS_IPHONE5{
                make.top.equalTo(warningLabel.snp.bottom).offset(WH(22))
            }else{
                make.top.equalTo(warningLabel.snp.bottom).offset(WH(32))
            }
            make.leading.equalTo(self.snp.leading).offset(WH(16))
        })
        
        let lblAddressTitle = UILabel()
        lblAddressTitle.font = UIFont.systemFont(ofSize: WH(16))
        lblAddressTitle.textColor = RGBColor(0x343434)
        lblAddressTitle.text = "收件地址"
        addSubview(lblAddressTitle)
        lblAddressTitle.snp.makeConstraints({ (make) in
            make.leading.equalTo(imageViewAddress.snp.trailing).offset(WH(8))
            make.centerY.equalTo(imageViewAddress.snp.centerY)
        })
        
        let addressDetailLabel = UILabel()
        addressDetailLabel.font = UIFont.systemFont(ofSize: WH(16))
        addressDetailLabel.textColor = RGBColor(0x343434)
        addressDetailLabel.text = "广东省广州市越秀区共和西路1号2层A区"
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblAddressTitle.snp.leading)
            make.top.equalTo(lblAddressTitle.snp.bottom).offset(WH(4))
        })
        
        let imageViewTelephone = UIImageView()
        imageViewTelephone.image = UIImage(named: "icon_credentials_complete_contact")
        addSubview(imageViewTelephone)
        imageViewTelephone.snp.makeConstraints({ (make) in
            if IS_IPHONE5{
                make.top.equalTo(addressDetailLabel.snp.bottom).offset(WH(20))
            }else {
                make.top.equalTo(addressDetailLabel.snp.bottom).offset(WH(24))
            }
            make.leading.equalTo(self.snp.leading).offset(WH(16))
        })
        
        let lblTelephoneTitle = UILabel()
        lblTelephoneTitle.font = UIFont.systemFont(ofSize: WH(16))
        lblTelephoneTitle.textColor = RGBColor(0x343434)
        lblTelephoneTitle.text = "联系电话"
        addSubview(lblTelephoneTitle)
        lblTelephoneTitle.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblAddressTitle.snp.leading)
            make.centerY.equalTo(imageViewTelephone.snp.centerY)
        })
        
        let lblTelephone = UILabel()
        lblTelephone.font = UIFont.systemFont(ofSize: WH(16))
        lblTelephone.textColor = RGBColor(0x343434)
        lblTelephone.text = "020-62352149"
        addSubview(lblTelephone)
        lblTelephone.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblAddressTitle.snp.leading)
            make.top.equalTo(lblTelephoneTitle.snp.bottom).offset(WH(4))
        })

        let imageViewContact = UIImageView()
        imageViewContact.image = UIImage(named: "icon_credentials_complete_linkman")
        addSubview(imageViewContact)
        imageViewContact.snp.makeConstraints({ (make) in
            if IS_IPHONE5{
                make.top.equalTo(lblTelephone.snp.bottom).offset(WH(20))
            }else{
                make.top.equalTo(lblTelephone.snp.bottom).offset(WH(24))
            }
            make.leading.equalTo(self.snp.leading).offset(WH(16))
        })

        let lblContactTitle = UILabel()
        lblContactTitle.font = UIFont.systemFont(ofSize: WH(16))
        lblContactTitle.textColor = RGBColor(0x343434)
        lblContactTitle.text = "联系人"
        addSubview(lblContactTitle)
        lblContactTitle.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblAddressTitle.snp.leading)
            make.centerY.equalTo(imageViewContact.snp.centerY)
        })
        
        let lblContact = UILabel()
        lblContact.font = UIFont.systemFont(ofSize: WH(16))
        lblContact.textColor = RGBColor(0x343434)
        lblContact.text = "苏小宁"
        addSubview(lblContact)
        lblContact.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblContactTitle.snp.leading)
            make.top.equalTo(lblContactTitle.snp.bottom).offset(WH(4))
        })
        
        let viewRemindDetail = FKYTipsUIView()
        viewRemindDetail.setTipsContent("友情提示：当前我司暂不支持到付邮件，请不要选择到付方式将资质资料邮寄至1药城，以免产生不必要的费用，谢谢！", numberOfLines: 0, backgroundColor: RGBColor(0xFFF2F3), textColor: RGBColor(0xFF394E), egdeMargin: 12)
        addSubview(viewRemindDetail)
        viewRemindDetail.snp.makeConstraints({ (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        })
        
        backgroundColor = bg1
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
