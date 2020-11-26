//
//  FKYGetCodeAfterFindPassViewController.swift
//  FKY
//
//  Created by hui on 2019/8/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYGetCodeAfterFindPassViewController: UIViewController {
    
    //MARK: - UI属性
    
    // title
    fileprivate lazy var titleView : FKYCertainCodeView = {
        let view = FKYCertainCodeView()
        return view
    }()
    // 短信验证码
    fileprivate lazy var messageView : FKYMessageView = {
        let view = FKYMessageView()
        view.changeTextfield = { [weak self] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
            }
        }
        //获取短信验证码
        view.getSMSCodeBlock = { [weak self] in
            if let strongSelf = self {
                strongSelf.getSMSCode()
            }
        }
        return view
    }()
    
    //下一步
    fileprivate lazy var nextButton : UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.setTitle("下一步", for: [.normal])
        btn.setTitleColor(RGBColor(0xFFFFFF), for: [.normal])
        btn.titleLabel?.font = t12.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.backgroundColor = RGBColor(0xFFABBD) //FF2D5D
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self{
                strongSelf.checkSMSCode()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var contactView : FKYContactView = {
        let view = FKYContactView()
        return view
    }()
    // 修改手机号
//    fileprivate lazy var changeLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = RGBColor(0x999999)
//        label.font = t35.font
//        label.textAlignment = .center
//        let str = "手机号不可用？点此修改"
//        let att = NSMutableAttributedString.init(string: str)
//        att.addAttributes([NSForegroundColorAttributeName:RGBColor(0xFF2D5C)], range:((str as NSString).range(of: "点此修改")))
//        label.attributedText = att
//        return label
//    }()
    //点击修改手机号
//    fileprivate lazy var clickChangeButton : UIButton = {
//        let btn = UIButton()
//        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//            if let strongSelf = self{
//
//            }
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//        return btn
//    }()
    
    //上个界面传过来的入参
    var retrieveOneModel : FKYRetrieveOneModel?
    var verifyStr : String? //图形验证码
    var picCodeModel : FKYAccountPicCodeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.titleView.configData(self.retrieveOneModel)
        self.getSalesPersonInfo()
        self.messageView.beginTimerDown()
    }
}
extension FKYGetCodeAfterFindPassViewController {
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self.view)
            make.height.equalTo(CERTAIN_CODE_H)
        }
        
        self.view.addSubview(self.messageView)
        self.messageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(WH(38))
            make.left.equalTo(self.view.snp.left).offset(WH(30))
            make.right.equalTo(self.view.snp.right).offset(-WH(30))
            make.height.equalTo(WH(44))
        }
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageView.snp.bottom).offset(WH(40))
            make.left.equalTo(self.view.snp.left).offset(WH(30))
            make.right.equalTo(self.view.snp.right).offset(-WH(30))
            make.height.equalTo(WH(42))
        }
        self.view.addSubview(self.contactView)
        self.contactView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nextButton.snp.bottom).offset(WH(40))
            make.left.equalTo(self.view.snp.left).offset(WH(10))
            make.right.equalTo(self.view.snp.right).offset(-WH(10))
            make.height.equalTo(WH(32))
        }
    }
    fileprivate func updateNextBtn() {
        //判断是否下一步能点击
        if let codeStr = self.messageView.messageTxtfield.text ,codeStr.count > 0 {
            self.nextButton.backgroundColor = RGBColor(0xFF2D5D)
            self.nextButton.isUserInteractionEnabled = true
        }else {
            self.nextButton.backgroundColor = RGBColor(0xFFABBD)
            self.nextButton.isUserInteractionEnabled = false
        }
    }
}
extension  FKYGetCodeAfterFindPassViewController {
    //获取短信验证码
    fileprivate func getSMSCode() {
        var params :[String : Any] = [:]
        params["type"] = "1"
        params["mobile"] = self.retrieveOneModel?.mobile
        params["code"] = verifyStr
        if let identity = self.picCodeModel?.identity {
            params["identity"] = identity
        }
        self.showLoading()
        FKYRequestService.sharedInstance()?.requestForGetSMSCodeDataInPassword(withParam: params, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            strongSelf.messageView.beginTimerDown()
            strongSelf.toast("验证码已发送")
        })
    }
    //验证短信验证码
    fileprivate func checkSMSCode() {
        var params :[String : Any] = [:]
        params["code"] = self.messageView.messageTxtfield.text
        if let picModel = self.picCodeModel {
            params["identity"] = picModel.identity
        }
        FKYRequestService.sharedInstance()?.requestForFindPasswordTwo(withParam: params , completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            FKYNavigator.shared().openScheme(FKY_SetPassword.self, setProperty: { (svc) in
                let v = svc as! FKYSetPasswordViewController
                v.retrieveOneModel = strongSelf.retrieveOneModel
                v.identityStr = strongSelf.picCodeModel?.identity
                v.phoneStr = strongSelf.retrieveOneModel?.mobile
            }, isModal: false, animated: true)
        })
    }
    //获取bd人员信息
    func getSalesPersonInfo(){
        FKYRequestService.sharedInstance()?.requestForSalesPersonInfo(withParam: ["enterpriseId":self.retrieveOneModel?.enterpriseId ?? ""] , completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                return
            }
            if let oneModel = model as? FKYSalesPersonInfoModel {
                strongSelf.contactView.configData(oneModel)
            }
        })
    }
}
