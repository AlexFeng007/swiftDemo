//
//  FKYScanVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit


class FKYScanVC: LBXScanViewController {
    
    /// 搜索的viewmodel
    lazy var viewModel = FKYNewProductRegisterViewModel()
    
    /// 是否需要带回扫码结果
    var isNeedPopBackWithScanResualt = false
    
    /// 顶部标题
    lazy var topTitleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "扫码找药"
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.textAlignment = .center
        return lb
    }()
    
    ///条码结果回调
    var barcodeCallBack:((_ barcode:String)->())?
    
    ///返回按钮
    lazy var naviBackButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "togeterBack"), for: .normal)
        bt.addTarget(self, action: #selector(FKYScanVC.naviBackButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 闪关灯开启状态
    var isOpenedFlash: Bool = false
    
    /// flashLight闪光灯按钮
    lazy var flashLightButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "Scan_flash_light_off"), for: .normal)
        bt.addTarget(self, action: #selector(FKYScanVC.flashLightButtonClicked), for: .touchUpInside)
        bt.setEnlargeEdgeWith(top: 30, right: 30, bottom: 30, left: 30)
        return bt
    }()
    
    /// 闪光灯按钮文描
    lazy var flashLightButtonLabel:UILabel = {
        let lb = UILabel()
        lb.text = "轻触照亮"
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: WH(14))
        return lb
    }()
    
    /// 扫描提示文描
    lazy var tipLabel:UILabel = {
        let lb = UILabel()
        lb.text = "将商品条形码放入框内，即可自动扫描"
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: WH(14))
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.installProperty()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isOpenCamera() else {// 没有开启摄像头权限
            self.showCameraPermissionAlert()
            return
        }
        self.setupUI()
    }
    
    /// 扫描结束
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        //            for result: LBXScanResult in arrayResult {
        //                if let str = result.strScanned {
        //                    print(str)
        //                    return
        //                }
        //            }
        let result: LBXScanResult = arrayResult[0]
        guard let resultStr = result.strScanned else{
            return
        }
        
        guard resultStr.count > 0 else{
            return
        }
        
        if self.isNeedPopBackWithScanResualt{
            self.searchProduct(resultStr)
        }else{
            
            let extendParams:[String :AnyObject] = ["keyword" : resultStr as AnyObject]
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I8011", itemPosition: "1", itemName: "识别成功并搜索", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: self)
            FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let searchVC = vc as! FKYSearchResultVC
                searchVC.barCode = resultStr
                searchVC.keyWordSoruceType = 1
                searchVC.fromWhere = "扫码搜索页面"
                searchVC.isFromScanVC = true
            })
        }
    }
    
}

//MARK: - 用户事件响应
extension FKYScanVC {
    
    /// 闪光灯按钮点击
    @objc func flashLightButtonClicked(){
        self.switchFlashLight()
    }
    
    /// 返回按钮点击
    @objc func naviBackButtonClicked(){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I8010", itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        FKYNavigator.shared()?.pop()
    }
    
}

//MARK: - UI
extension FKYScanVC {
    func setupUI(){
        self.tipLabel.removeFromSuperview()
        self.flashLightButton.removeFromSuperview()
        self.flashLightButtonLabel.removeFromSuperview()
        self.topTitleLabel.removeFromSuperview()
        self.naviBackButton.removeFromSuperview()
        
        self.view.addSubview(self.tipLabel)
        self.view.addSubview(self.flashLightButton)
        self.view.addSubview(self.flashLightButtonLabel)
        self.view.addSubview(self.topTitleLabel)
        self.view.addSubview(self.naviBackButton)
        
        // iPhoneX适配
        var topMargin = WH(30)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                topMargin = iPhoneX_SafeArea_TopInset
            }
        }
        
        self.naviBackButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(WH(23))
            make.left.equalTo(self.view).offset(WH(22))
            make.top.equalTo(self.view).offset(topMargin)
        }
        
        self.topTitleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.naviBackButton)
        }
        
        self.tipLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.snp_centerY).offset(WH(100))
        }
        
        self.flashLightButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.flashLightButtonLabel.snp_top).offset(WH(-5))
            make.width.height.equalTo(WH(23))
        }
        
        self.flashLightButtonLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(WH(-117))
            make.centerX.equalTo(self.flashLightButton)
        }
    }
    
    func installProperty(){
        self.arrayCodeType = [AVMetadataObject.ObjectType.ean8 as NSString,AVMetadataObject.ObjectType.ean13 as NSString,AVMetadataObject.ObjectType.code93 as NSString,AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
        var style = LBXScanViewStyle()
        style.photoframeAngleW = 0
        style.photoframeAngleH = 0
        style.photoframeLineW = 0
        style.xScanRetangleOffset = WH(69)
        style.color_NotRecoginitonArea = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.scanStyle = style
        self.startScan()
    }
}

//MARK: - 私有方法
extension FKYScanVC {
    
    /// 切换闪光灯状态
    func switchFlashLight(){
        scanObj?.changeTorch()
        //        if let callBack = self.barcodeCallBack{
        //            callBack("6920312611029")
        //            FKYNavigator.shared()?.pop()
        //        }
        self.isOpenedFlash = !self.isOpenedFlash
        
        if self.isOpenedFlash
        {
            self.flashLightButton.setBackgroundImage(UIImage(named: "Scan_flash_light_on"), for:UIControl.State.normal)
            self.flashLightButtonLabel.text = "轻触关闭"
        }else{
            self.flashLightButton.setBackgroundImage(UIImage(named: "Scan_flash_light_off"), for:UIControl.State.normal)
            self.flashLightButtonLabel.text = "轻触照亮"
        }
    }
    
    /// 判断是否开启摄像头权限
    func isOpenCamera() -> Bool{
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.denied{//明确拒绝用户访问硬件支持的媒体类型的客户
            return false
        }else{
            return true
        }
    }
    
    /// 相机权限弹窗
    func showCameraPermissionAlert(){
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您未开启摄像头权限，请通过设置->隐私->相机->1药城 开启摄像头权限", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            self.naviBackButtonClicked()
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                
            }
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - 网络请求
extension FKYScanVC {
    
    /// 搜索商品
    func searchProduct(_ barCode:String){
        let dic = ["barcode":barCode]
        self.showLoading()
        self.viewModel.requestStandardProductList(param: dic as [String : AnyObject], callBack: {[weak self] (isSucccess, msg) in
            guard let strongSelf = self else {
                return
            }
            // 请求完成
            strongSelf.dismissLoading()
            if strongSelf.viewModel.searchResult == 0{
                if let callBack = strongSelf.barcodeCallBack{
                    callBack(barCode)
                    FKYNavigator.shared()?.pop()
                }
            }else{
                let extendParams:[String :AnyObject] = ["keyword" : barCode as AnyObject]
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I8011", itemPosition: "1", itemName: "识别成功并搜索", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: strongSelf)
                FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                    let searchVC = vc as! FKYSearchResultVC
                    searchVC.barCode = barCode
                    searchVC.keyWordSoruceType = 1
                    searchVC.fromWhere = "扫码搜索页面"
                    searchVC.isFromScanVC = true
                })
            }
        })
    }
}
