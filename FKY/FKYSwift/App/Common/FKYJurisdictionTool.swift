//
//  FKYJurisdictionTool.swift
//  FKY
//
//  Created by hui on 2019/3/29.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
import AssetsLibrary

//权限判断工具类
class FKYJurisdictionTool: NSObject {
    //判断相机权限
    @objc static func getCameraJueiaDiction() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        let CameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if CameraStatus == .restricted || CameraStatus == .denied {
            FKYProductAlertView.show(withTitle: "无法访问相机",
                                     leftTitle: "设置",
                                     rightTitle: "取消",
                                     message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机",
                                     handler: { (_, isRight) in
                                        if isRight == false {
                                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                                        }
            })
            return false
        }
        
        return true
    }
    
    //判断相册权限
    @objc static func getPhotoLibraryJueiaDiction() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            return false
        }
        let photoStatus = ALAssetsLibrary.authorizationStatus()
        if photoStatus == .restricted || photoStatus == .denied {
            FKYProductAlertView.show(withTitle: "无法访问相册",
                                     leftTitle: "设置",
                                     rightTitle: "取消",
                                     message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册",
                                     handler: { (_, isRight) in
                                        if isRight == false {
                                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                                        }
                                        
            })
            return false
        }
//        if photoStatus == .notDetermined {
//            //用户第一次访问相册权限是否开启，ios系统会弹系统提示框
//            return false
//        }
        return true
    }
}
