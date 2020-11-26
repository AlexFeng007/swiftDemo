//
//  FKYItroductMaskView.swift
//  FKY
//
//  Created by yyc on 2020/11/10.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYItroductMaskView: UIView {
    var maskImage : [String] = [] //引导图
    var currectIndex = 0
    var viewArray = [UIView]()
    var type = 0  //1:代表首页引导图
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(_ type:Int){
        self.type = type
        if self.type == 1 {
            self.maskImage = ["home_shop_guide_1","home_shop_guide_2"]
        }
        self.backgroundColor =  RGBAColor(0x000000,alpha: 0.4)
        for index in 0..<(maskImage.count) {
            let view  = self.creatMashImageVew(index)
            viewArray.append(view)
            self.addSubview(view)
            if index != 0 {
                view.isHidden = true;
            }
        }
    }
    
    fileprivate func creatMashImageVew(_ index:Int) -> (UIView) {
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        let maskImageView =  UIImageView()
        maskImageView.image = UIImage.init(named:maskImage[index])
        bgView.addSubview(maskImageView)
        
        let btn = UIButton()
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  (_) in
            self.msskBunClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        bgView.addSubview(btn)
        
        //搜索结果页引导图
        if self.type == 1 {
            if index == 0{
                btn.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(bgView)
                    make.bottom.equalTo(maskImageView.snp.bottom)
                    make.width.equalTo(WH(80))
                    make.height.equalTo(WH(80))
                })
                let bootSpace = bootSaveHeight()
                let desSpace = bootSpace > 0 ? bootSpace-10 : -2
                maskImageView.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(bgView)
                    make.bottom.equalTo(bgView).offset(-desSpace)
                    make.width.equalTo(WH(375))
                    make.height.equalTo(WH(203))
                })
            }else if index == 1{
                btn.snp.makeConstraints({ (make) in
                    make.edges.equalTo(bgView)
                })
                maskImageView.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(bgView)
                    make.top.equalTo(bgView).offset(naviBarHeight()+WH(52))
                    make.width.equalTo(WH(375))
                    make.height.equalTo(WH(288))
                })
            }
        }
        return bgView
    }
    fileprivate func msskBunClick(){
        if self.type == 1 {
            if currectIndex < maskImage.count - 1{
                let bgV = viewArray[currectIndex];
                let bgV1 = viewArray[currectIndex + 1];
                bgV.isHidden = true
                bgV1.isHidden = false
            }
            if currectIndex == 0 {
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
                    let viewController = vc as! FKYTabBarController
                    viewController.index = 2
                })
            }
        }
        //移除当前视图
        if currectIndex == (maskImage.count - 1){
            self.removeFromSuperview()
        }
        currectIndex += 1
    }
    
}
let NEW_HOME_MASK = "NEW_HOME_MASK_6.8.20"

extension FKYItroductMaskView {
    static func setUpHomeShophWelcomePage() {
        //只在5.0.0 上展示蒙版
        let appVersion = FKYAnalyticsUtility.appVersion()
        let userDefault = UserDefaults.standard
        if  userDefault.bool(forKey: NEW_HOME_MASK) == false && appVersion == "6.8.20" {
            userDefault.set(true, forKey: NEW_HOME_MASK)
            userDefault.synchronize()
            let window = UIApplication.shared.keyWindow
            let mashView = FKYItroductMaskView()
            mashView.setUpView(1)
            window!.rootViewController?.view.addSubview(mashView)
            mashView.snp.makeConstraints({ (make) in
                make.edges.equalTo((window!.rootViewController?.view)!)
            })
        }
    }
}
