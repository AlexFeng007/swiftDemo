//
//  FKYYflIntroDetailViewController.swift
//  FKY
//
//  Created by yyc on 2020/5/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYYflIntroDetailViewController: UIViewController {
    
    fileprivate var navBar: UIView?
    //底部
    fileprivate lazy var bgScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.isScrollEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = bg1
        return sv
    }()
    // 是否选择
    fileprivate lazy var agreeBtn: UIButton = {
        let btn = UIButton()
        btn.isSelected = true
        btn.setImage(UIImage(named: "yfl_selected_no_pic"), for: .normal)
        btn.setImage(UIImage(named: "yfl_selected_pic"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateAgrrBtnStatus()
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //
    fileprivate lazy var tipLabel:UILabel = {
        let lb = UILabel()
        lb.text = "请勾选同意"
        lb.fontTuple = t3
        return lb
    }()
    //
    fileprivate lazy var tipProtocolLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x6786FB)
        lb.text = "《药店福利社-返利协议》"
        lb.font = t3.font
        lb.isUserInteractionEnabled = true
        lb.bk_(whenTapped:  { [weak self] in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = "https://m.yaoex.com/web/h5/maps/index.html?pageId=101533&type=release"
            })
        })
        return lb
    }()
    // 申请按钮
    fileprivate lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        //btn.setTitle("申请加入", for: .normal)
        btn.backgroundColor = RGBColor(0xFFABBD)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(18))
        btn.layer.cornerRadius = WH(45)/2.0
        btn.layer.shadowColor = RGBAColor(0xF72A31, alpha: 0.48).cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 1
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.clickSubmitBtn()
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    var yflModel : FKYYflInfoModel? //请求回的模型
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.getYflInfo()
    }
    deinit {
        print("FKYYflIntroDetailViewController deinit~!@")
    }
    
}
extension FKYYflIntroDetailViewController {
    fileprivate func clickSubmitBtn(){
        //进入药福利申请
        if let model = self.yflModel {
            let extendParams = ["pageValue":"药福利申请"]
            if model.status == 5 || model.status == 7 || model.status == 8 {
                //审核通过
                FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { (vc) in
                    let controller = vc as! FKYNewShopItemViewController
                    controller.shopId = "\(model.virtualId ?? 0)"
                    controller.shopType = "1"
                }, isModal: false)
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6701", itemPosition: "2", itemName: "去采购", itemContent: nil, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
            }else {
                //申请or重新申请
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6701", itemPosition: "1", itemName: "申请加入", itemContent: nil, itemTitle: nil, extendParams: extendParams as [String : AnyObject], viewController: self)
                FKYNavigator.shared()?.openScheme(FKY_ApplyWalfareTable.self, setProperty: { (vc) in
                    if let desVc = vc as? FKYApplyWalfareTableVC {
                        desVc.yflModel = model
                    }
                })
            }
        }
    }
    fileprivate func updateAgrrBtnStatus(){
        self.agreeBtn.isSelected = !self.agreeBtn.isSelected
        if let model = self.yflModel {
            if model.status == 1 || model.status == 4 {
                //账户认证中
            }else if model.status == 5 || model.status == 7 || model.status == 8 {
                //审核通过
            }else if model.status == 6 {
                //审核不通过
            }else {
                //未知状态
                if self.agreeBtn.isSelected == true {
                    submitBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFB6962), RGBColor(0xF6272E), SCREEN_WIDTH-WH(30))
                    submitBtn.isUserInteractionEnabled = true
                }else {
                    submitBtn.backgroundColor = RGBColor(0xFFABBD)
                    submitBtn.isUserInteractionEnabled = false
                }
            }
        }
    }
    fileprivate func setupView(){
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        fky_setupTitleLabel("药福利")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.view.backgroundColor = bg1
        self.view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(WH(15))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(8)-bootSaveHeight())
            make.height.equalTo(WH(45))
            make.width.equalTo(SCREEN_WIDTH-WH(30))
        }
        self.view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(WH(10))
            make.bottom.equalTo(submitBtn.snp.top).offset(-WH(3))
            make.width.height.equalTo(WH(28))
        }
        self.view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(agreeBtn.snp.right).offset(WH(8))
            make.centerY.equalTo(agreeBtn.snp.centerY)
            make.height.equalTo(WH(18))
        }
        self.view.addSubview(tipProtocolLabel)
        tipProtocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp.right)
            make.centerY.equalTo(agreeBtn.snp.centerY)
            make.height.equalTo(WH(18))
        }
        
        self.view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(agreeBtn.snp.top).offset(-WH(3))
        }
        var lastImageView : UIImageView?
        for i in 0...6 {
            let yflImageView = UIImageView()
            yflImageView.image = UIImage(named: "yfl_intro_\(i+1)_pic")
            bgScrollView.addSubview(yflImageView)
            if let lastView = lastImageView {
                yflImageView.snp.makeConstraints { (make) in
                    make.left.equalTo(bgScrollView)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.top.equalTo(lastView.snp.bottom)
                }
            }else {
                yflImageView.snp.makeConstraints { (make) in
                    make.left.equalTo(bgScrollView)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.top.equalTo(bgScrollView.snp.top)
                }
            }
            lastImageView = yflImageView
        }
        if let lastView = lastImageView {
            bgScrollView.snp.makeConstraints { (make) in
                make.bottom.equalTo(lastView.snp.bottom)
            }
        }
    }
}
//MARK:网络请求及处理刷新ui
extension FKYYflIntroDetailViewController {
    fileprivate func updateSubmitBtnWithData(){
        if let model = self.yflModel {
            if model.status == 1 || model.status == 4 {
                //账户认证中
                submitBtn.setTitle("开店申请 审核中", for: .normal)
                submitBtn.isUserInteractionEnabled = false
                submitBtn.backgroundColor = RGBColor(0xFFABBD)
            }else if model.status == 5 || model.status == 7 || model.status == 8 {
                //审核通过
                submitBtn.isUserInteractionEnabled = true
                submitBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFB6962), RGBColor(0xF6272E), SCREEN_WIDTH-WH(30))
                submitBtn.setTitle("已开店 去采购", for: .normal)
            }else if model.status == 6 {
                submitBtn.setTitle("审核不通过", for: .normal)
                submitBtn.isUserInteractionEnabled = false
                submitBtn.backgroundColor = RGBColor(0xFFABBD)
            }else {
                //未知状态
                submitBtn.setTitle("申请加入", for: .normal)
                if self.agreeBtn.isSelected == true {
                    submitBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFB6962), RGBColor(0xF6272E), SCREEN_WIDTH-WH(30))
                    submitBtn.isUserInteractionEnabled = true
                }else {
                    submitBtn.backgroundColor = RGBColor(0xFFABBD)
                    submitBtn.isUserInteractionEnabled = false
                }
            }
        }else {
            //未知状态
            submitBtn.setTitle("申请加入", for: .normal)
            if self.agreeBtn.isSelected == true {
                submitBtn.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFB6962), RGBColor(0xF6272E), SCREEN_WIDTH-WH(30))
                submitBtn.isUserInteractionEnabled = true
            }else {
                submitBtn.backgroundColor = RGBColor(0xFFABBD)
                submitBtn.isUserInteractionEnabled = false
            }
        }
    }
    fileprivate func getYflInfo(){
        FKYRequestService.sharedInstance()?.requestForGetYflOpenShopInfo(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            guard success else {
                let msg = error?.localizedDescription ?? "获取失败"
                strongSelf.toast(msg)
                return
            }
            if let infoModel = model as? FKYYflInfoModel {
                strongSelf.yflModel = infoModel
                //如果接口data返回null，表示未申请过
                strongSelf.updateSubmitBtnWithData()
            }
        })
    }
    
}
