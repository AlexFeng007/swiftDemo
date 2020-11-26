//
//  FKYCertainCodeView.swift
//  FKY
//
//  Created by hui on 2019/8/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

let CERTAIN_CODE_H = naviBarHeight()-WH(64)+WH(30)+WH(26)+WH(48)+WH(12+13)+WH(50+33)+WH(8+13)

class FKYCertainCodeView: UIView {
    
    //返回按钮
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_back_pic"), for: [.normal])
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  (_) in
            FKYNavigator.shared().pop()
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //头像
    fileprivate lazy var iconImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage.init(named: "certainPass_pic")
        return iv
    }()
    
    // 公司名称
    fileprivate lazy var companyLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = t40.font
        label.textAlignment = .center
        return label
    }()
    
    // 标题
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "获取验证码"
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.boldSystemFont(ofSize: WH(24))
        return label
    }()
    
    // 验证码提示
    fileprivate lazy var codeLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = t30.font
        return label
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.addSubview(self.backBtn)
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset((naviBarHeight()-WH(64)+WH(30)))
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.height.width.equalTo(WH(24))
        }
        self.addSubview(self.iconImgView)
        self.iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.backBtn.snp.bottom).offset(WH(26))
            make.centerX.equalTo(self.snp.centerX)
            make.height.width.equalTo(WH(48))
        }
        self.addSubview(self.companyLabel)
        self.companyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView.snp.bottom).offset(WH(12))
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.right.equalTo(self.snp.right).offset(-WH(10))
            //make.height.equalTo(WH(13))
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.companyLabel.snp.bottom).offset(WH(50))
            make.left.equalTo(self.snp.left).offset(WH(30))
            make.height.equalTo(WH(33))
        }
        self.addSubview(self.codeLabel)
        self.codeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(8))
            make.left.equalTo(self.snp.left).offset(WH(30))
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.height.equalTo(WH(13))
        }
    }
    func configData(_ retrieveOneModel : FKYRetrieveOneModel?){
        if let oneModel = retrieveOneModel {
            if let arr =  oneModel.userNames {
                if arr.count > 3 {
                   let userNameStr = arr[0..<3].joined(separator: ", ")
                   self.companyLabel.text =  "\(userNameStr)等"
                }else {
                    self.companyLabel.text = arr.joined(separator: ", ")
                }
            }else {
                self.companyLabel.text = ""
            }
            if let str = oneModel.mobile {
                let phoneStr = (str as NSString).replacingCharacters(in:NSRange(location: 3, length: 4), with: "****")
                self.codeLabel.text = "验证码已发送到绑定手机号\(phoneStr)"
            }
        }
    }
}
