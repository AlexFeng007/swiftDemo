//
//  FKYFindPasswordViewController.swift
//  FKY
//
//  Created by hui on 2019/6/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//  找回密码

import UIKit

class FKYFindPasswordViewController: UIViewController {
    //MARK: - UI属性
    
    // title
    fileprivate lazy var titleView : FKYPasswordTitleView = {
        let view = FKYPasswordTitleView()
        view.titleLabel.text = "找回密码"
        return view
    }()
    
    // 手机号
    fileprivate lazy var phoneView : FKYPhoneView = {
        let view = FKYPhoneView()
        view.phoneTxtfield.placeholder = "请输入手机号或企业名称"
        view.type = 2
        view.phoneTxtfield.returnKeyType = .search
        view.changeTextfield = { [weak self] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
                strongSelf.getShopInfoWithInputStr()
                strongSelf.selectedIndex = nil
            }
        }
        view.beginEditing = { [weak self] in
            if let strongSelf = self {
                strongSelf.refreshPhoneViewError(nil)
            }
        }
        view.endEditing = { [weak self] in
            if let strongSelf = self {
                if strongSelf.shopNameSearchTabel.isHidden == true {
                    let _ = strongSelf.validatePhoneNum(1)
                }
            }
        }
        view.doneEditing = { [weak self] in
            if let strongSelf = self {
                let _ = strongSelf.validatePhoneNum(1)
                strongSelf.shopNameSearchTabel.isHidden = true
                strongSelf.view.endEditing(true)
            }
        }
        
        return view
    }()
    
    // 图像验证码
    fileprivate lazy var verifyView : FKYVerifyView = {
        let view = FKYVerifyView()
        view.changeTextfield = { [weak self] in
            if let strongSelf = self {
                strongSelf.updateNextBtn()
            }
        }
        view.changePicCode = { [weak self] in
            if let strongSelf = self {
                strongSelf.getPicCode()
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
                strongSelf.vertifyPhoneOrCompany()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var shopNameSearchTabel: UITableView = {
        let table: UITableView = UITableView()
        table.backgroundColor = RGBColor(0xF8F8F8)
        table.separatorStyle = .none
        table.isHidden = true
        table.delegate = self
        table.dataSource = self
        table.register(FKYShopNameWithFindPassTabCell.self, forCellReuseIdentifier: "FKYShopNameWithFindPassTabCell")
        return table
    }()
    
    var picCodeModel : FKYAccountPicCodeModel?
    var searchDataArr :[FKYAssCompanyModel] = [] //联想数组
    var selectedIndex : Int? //记录点击来联想的cell
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPicCode()
        self.verifyView.verifyTxtfield.text = ""
    }
}

extension FKYFindPasswordViewController {
    fileprivate func setupView() {
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self.view)
            make.height.equalTo(LOGIN_ABOUT_H)
        }
        self.view.addSubview(self.phoneView)
        self.phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(WH(38))
            make.left.equalTo(self.view.snp.left).offset(WH(30))
            make.right.equalTo(self.view.snp.right).offset(-WH(30))
            make.height.equalTo(WH(44))
        }
        self.view.addSubview(self.verifyView)
        self.verifyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom).offset(WH(18))
            make.left.equalTo(self.view.snp.left).offset(WH(30))
            make.right.equalTo(self.view.snp.right).offset(-WH(30))
            make.height.equalTo(WH(44))
        }
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.verifyView.snp.bottom).offset(WH(40))
            make.left.equalTo(self.view.snp.left).offset(WH(30))
            make.right.equalTo(self.view.snp.right).offset(-WH(30))
            make.height.equalTo(WH(42))
        }
        self.view.addSubview(self.shopNameSearchTabel)
        self.shopNameSearchTabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom).offset(-bootSaveHeight())
        }
    }
    
    fileprivate func updateNextBtn() {
        //判断是否下一步能点击
        if let phoneStr = self.phoneView.phoneTxtfield.text,phoneStr.count > 0 ,
            let verifyStr = self.verifyView.verifyTxtfield.text,verifyStr.count > 0{
            if self.validatePhoneNum(2) == false {
                self.nextButton.backgroundColor = RGBColor(0xFFABBD)
                self.nextButton.isUserInteractionEnabled = false
            }else {
                self.nextButton.backgroundColor = RGBColor(0xFF2D5D)
                self.nextButton.isUserInteractionEnabled = true
            }
        }else {
            self.nextButton.backgroundColor = RGBColor(0xFFABBD)
            self.nextButton.isUserInteractionEnabled = false
        }
    }
}

//MARK:刷新数据界面相关
extension FKYFindPasswordViewController {
    //刷新错误提示
    fileprivate func refreshPhoneViewError(_ errorStr : String?) {
        self.phoneView.refreshErrorLabel(errorStr)
        if  errorStr != nil {
            self.phoneView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(44+5+17))
            })
        }else{
            self.phoneView.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(44))
            })
        }
    }
    
    fileprivate func validatePhoneNum (_ type:Int) -> Bool {
        if let phoneStr = self.phoneView.phoneTxtfield.text , phoneStr.count > 0 {
            //只有纯数据才当成手机号码验证
            guard NSString.validateOnlyNumber(phoneStr) == true else {
                return true
            }
            let phoneValid = (phoneStr as NSString).isPhoneNumber()
            if phoneValid == false {
                if type == 1 {
                    self.refreshPhoneViewError("手机号输入有误")
                }
                return false
            }
            return true
        }
        return false
    }
}

//MARK:网络请求相关
extension FKYFindPasswordViewController {
    //获取图片验证码
    fileprivate func getPicCode() {
        FKYRequestService.sharedInstance()?.requestForGetImageCodeInPassword(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                strongSelf.picCodeModel = nil
                return
            }
            if let picModel = model as? FKYAccountPicCodeModel {
                strongSelf.picCodeModel = picModel
                strongSelf.verifyView.updatePicCodeImageView(picModel)
            }
        })
    }
    
    //验证手机号或者企业名称
    fileprivate func vertifyPhoneOrCompany() {
        if self.validatePhoneNum(2) == false {
            return
        }
        var params :[String : Any] = [:]
        params["mobile"] = self.phoneView.phoneTxtfield.text
        params["code"] = self.verifyView.verifyTxtfield.text
        if let picModel = self.picCodeModel {
            params["identity"] = picModel.identity
        }
        if let index = self.selectedIndex,index < self.searchDataArr.count{
            let companyModel = self.searchDataArr[index]
            params["enterpriseId"] = "\(companyModel.enterpriseId ?? 0)"
        }
        FKYRequestService.sharedInstance()?.requestForFindPasswordOne(withParam: params , completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                if let err = error {
                    let e = err as NSError
                    if let errCode = e.userInfo[HJErrorCodeKey] as? NSString, errCode == "-1" {
                        strongSelf.getPicCode()
                    }
                }
                return
            }
            if let oneModel = model as? FKYRetrieveOneModel {
                FKYNavigator.shared().openScheme(FKY_CertainCode.self, setProperty: { [weak self] (svc) in
                    if let strongSelf = self {
                        let v = svc as! FKYGetCodeAfterFindPassViewController
                        v.retrieveOneModel = oneModel
                        v.picCodeModel = strongSelf.picCodeModel
                        v.verifyStr = strongSelf.verifyView.verifyTxtfield.text
                    }
                }, isModal: false, animated: true)
            }
        })
    }
    
    //调用联想企业名称接口
    fileprivate func getShopInfoWithInputStr() {
        if let phoneStr = self.phoneView.phoneTxtfield.text , phoneStr.count > 0 {
            FKYRequestService.sharedInstance()?.requestForCompanyAbout(withParam: ["name":phoneStr], completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                guard success else {
                    // 失败
                    let msg = error?.localizedDescription ?? "获取失败"
                    strongSelf.toast(msg)
                    return
                }
                if let companyArr = model as? [FKYAssCompanyModel] {
                    strongSelf.searchDataArr = companyArr
                    //错误提示隐藏才显示联想
                    if strongSelf.phoneView.errorLabel.isHidden == true {
                        if strongSelf.searchDataArr.count > 0 {
                            strongSelf.shopNameSearchTabel.isHidden = false
                            strongSelf.shopNameSearchTabel.reloadData()
                        }else{
                            strongSelf.shopNameSearchTabel.isHidden = true
                            strongSelf.shopNameSearchTabel.reloadData()
                        }
                    }else {
                        strongSelf.shopNameSearchTabel.isHidden = true
                    }
                }else{
                    strongSelf.shopNameSearchTabel.isHidden = true
                }
            })
        }else {
            self.shopNameSearchTabel.isHidden = true
        }
    }
}
//MARK: - UITableViewDelegate,UITableViewDataSource
extension FKYFindPasswordViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchDataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(48)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FKYShopNameWithFindPassTabCell", for: indexPath) as! FKYShopNameWithFindPassTabCell
        let model = self.searchDataArr[indexPath.row]
        cell.configData(model.enterpriseName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.shopNameSearchTabel.isHidden = true
        self.selectedIndex = indexPath.row
        let model = self.searchDataArr[indexPath.row]
        self.phoneView.phoneTxtfield.text = model.enterpriseName
        self.view.endEditing(true)
        let _ = self.validatePhoneNum(1)
        self.updateNextBtn()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
