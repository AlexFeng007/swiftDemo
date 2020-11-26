//
//  FKYSplashView.swift
//  FKY
//
//  Created by hui on 2018/7/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

let BT_H = WH(27)
typealias SplashClickBlock = (FKYSplashModel)->(Void)


class FKYSplashView: UIControl {
    // MARK: - Property
    fileprivate var block : SplashClickBlock?
    fileprivate var hideBlock : emptyClosure?
    fileprivate var logic: HomeLogic?
    fileprivate var model: FKYSplashModel?
    fileprivate var timer: Timer!
    fileprivate var totalCountNum : Int = 3
    fileprivate var bgImageView : UIImageView = {
        let view = UIImageView.init(frame:UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        view.image = UIImage.init(named: "launch_image_backg.jpg")
        return view
    }()
    fileprivate var centreImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "launch_image_lg.png")
        view.contentMode = .scaleAspectFit
        return view
    }()
    fileprivate var closeBt : UIButton = {
        let bt = UIButton()
        bt.backgroundColor = RGBAColor(0x000000, alpha: 0.3)
        bt.setTitleColor(RGBColor(0xffffff), for: .normal)
        bt.titleLabel?.font = t1.font
        bt.layer.masksToBounds = true
        bt.layer.cornerRadius = BT_H/2.0
        bt.isHidden = true
        return bt
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("+++")
    }
    
    // MARK: - Class
    
    @objc static func showSplashView(inSuperView bgView : UIView, withClickBlock clickblock : @escaping SplashClickBlock, andHideBlock hideblock : @escaping emptyClosure) -> FKYSplashView {
        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        
        // 创建广告图
        let splashView = FKYSplashView.init(frame:UIScreen.main.bounds)
        splashView.block = clickblock
        splashView.hideBlock = hideblock
        //splashView.isHidden = true
        splashView.addSubview(splashView.bgImageView)
        splashView.addSubview(splashView.centreImageView)
        splashView.centreImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(splashView.snp.centerX)
            make.centerY.equalTo(splashView.snp.centerY)
            make.width.equalTo(240)
            make.height.equalTo(118)
        }
        splashView.addSubview(splashView.closeBt)
        splashView.closeBt.snp.makeConstraints { (make) in
            make.right.equalTo(splashView.snp.right).offset(-WH(15))
            make.height.equalTo(BT_H)
            make.width.equalTo(WH(61))
            make.top.equalTo(splashView.snp.top).offset(WH(45-64)+naviBarHeight())
        }
        
        // 关闭
        splashView.closeBt.bk_addEventHandler({ (bt) in
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.AD_TIP_ITEM_CODE.rawValue, itemPosition: "0", itemName: "跳过按钮", itemContent: nil, itemTitle: nil, extendParams: ["pagecode":"fullScreenAds" as AnyObject], viewController: nil)
            //隐藏
            splashView.hideView()
            FKYAnalyticsManager.sharedInstance.resetReferPageCodeOnViewHide("fullScreenAds")
        }, for: .touchUpInside)
        // 广告图点击
        splashView.bgImageView.bk_(whenTapped: {
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName:nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.AD_PIC_ITEM_CODE.rawValue, itemPosition: "0", itemName: "点击开屏广告", itemContent: nil, itemTitle: nil, extendParams:["pagecode":"fullScreenAds" as AnyObject], viewController: nil)
            FKYAnalyticsManager.sharedInstance.h5ReferPageCode = "fullScreenAds"
            if let model = splashView.model {
                clickblock(model)
            }
        })
        
        // 请求数据
        splashView.logic = HomeLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HomeLogic
        splashView.requestData()
        
        // 展示
        bgView.addSubview(splashView)
        
        bgView.bringSubviewToFront(splashView)
        
        return splashView
    }
    
    
    // MARK: - Public
    
    // 隐藏view
    @objc func hideView() {
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        //UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        self.stopAutoCount()
        self.alpha = 0.0
        self.isHidden = true
        if let block = self.hideBlock {
            block()
        }
        removeFromSuperview()
    }
    
    
    // MARK: - Private
    
    // 开始轮播
    fileprivate func beginCount() {
        // 取消timer
        stopAutoCount()
        //UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        // 启动timer
        let date = NSDate.init(timeIntervalSinceNow: 0)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(autoCountAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        // 判断是否显示倒计时按钮
        self.totalCountNum = (self.model?.holdTime)!
        self.closeBt.setTitle("\(self.totalCountNum)s关闭", for: .normal)
        if self.model?.skipFlag == "1" {
            self.closeBt.isHidden = false
        }
    }
    
    // 停止轮播
    fileprivate func stopAutoCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 倒计时操作
    @objc fileprivate func autoCountAction() {
       // UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        if self.totalCountNum == 0 {
            FKYAnalyticsManager.sharedInstance.resetReferPageCodeOnViewHide("fullScreenAds")
            self.hideView()
        }else {
            self.closeBt.setTitle("\(self.totalCountNum)s关闭", for: .normal)
        }
        self.totalCountNum = self.totalCountNum - 1
    }
    
    
    // MARK: - Request
    
    fileprivate func requestData() {
        self.logic?.getAdvertisementData(completion: { (responseObj, error) in
            if error == nil {
                // 请求成功
                if let data = responseObj as? NSDictionary {
                    // 有数据
                    self.model = data.mapToObject(FKYSplashModel.self)
                    self.beginCount()
                    if let url = self.model?.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                        self.bgImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: "launch_image_backg.jpg"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
                            if image != nil {
                                self.bgImageView.isUserInteractionEnabled = true
                                self.centreImageView.isHidden = true
                            }
                        })
                    }
                }
                else {
                    // 无数据
                    self.hideView()
                }
            }
            else {
                // 请求失败
                self.hideView()
                
                if let err = error {
                    // 请求失败
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请手动重新登录")
                    }
                }
            }
        })
    }
}
