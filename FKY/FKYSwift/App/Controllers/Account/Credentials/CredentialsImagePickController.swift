//
//  CredentialsImagePickController.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/27.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  图片上传类

import UIKit
import SDWebImage

enum ImageUploadStatus: Int {
    case none = 0
    case begin
    //case uploading
    case complete
}

typealias SingleStringArrayClosure = (_ imageUrls:[String], _ imageFilenames:[String], _ errorInfo: [(uploadIndex: Int, errorMsg: String)], _ toUploadImageCount: Int)->(Void)
typealias ImageUploadStatusClosure = (ImageUploadStatus)->(Void)


protocol CameraDelegate: class {
    func toUploadImage(_ takePhoto: UIImage)
}


// MARK: -
// MARK: - UIImagePickerCameraDelegateObject
class UIImagePickerCameraDelegateObject: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK:- Property
    weak var delegateUploadHander: CameraDelegate?
    
    // MARK:- UIImagePickerControllerDelegate
    // 已选中图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        if type == "public.image" {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                TZImageManager.default().savePhoto(with: image, completion: nil)
                if let delegate = self.delegateUploadHander {
                    delegate.toUploadImage(image)
                }
            }
        }
    }
    
    // 取消选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: -
// MARK: - CredentialsImagePickController
class CredentialsImagePickController: UIViewController {
    // MARK: - Property
    
    var maxImagesCount: Int = 5 // 最大可上传图片数量
    var maxImgData = 1.2 // 最大1.2M...<可修改>
    
    var uploadImageCompletionClosure: SingleStringArrayClosure?
    var uploadStatusClosure: ImageUploadStatusClosure?
    
    fileprivate lazy var cameraDelegate: UIImagePickerCameraDelegateObject = {
        let cameraDelegate: UIImagePickerCameraDelegateObject = UIImagePickerCameraDelegateObject()
        cameraDelegate.delegateUploadHander = self
        return cameraDelegate
    }()
    
    fileprivate var currentImageIndex: Int = 0
    fileprivate var chooseImagesCount: Int = 0
    fileprivate var uploadFinalUrl: [String] = []
    fileprivate var uploadFinalFileName: [String] = []
    fileprivate var erroInfo: [(uploadIndex: Int, errorMsg: String)] = []
    fileprivate var gcdGroup: DispatchGroup = DispatchGroup()
    
    fileprivate var pickerVC: UIImagePickerController?
    fileprivate var imagePickerVC: UIImagePickerController {
        get {
            if self.pickerVC == nil {
                self.pickerVC = UIImagePickerController()
                self.pickerVC!.delegate = cameraDelegate
                // set appearance / 改变相册选择页的导航栏外观
                self.pickerVC!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
                self.pickerVC!.navigationBar.tintColor = self.navigationController!.navigationBar.tintColor
                var tzBarItem: UIBarButtonItem? = nil
                var BarItem: UIBarButtonItem? = nil
                if #available(iOS 9.0, *) {
                    tzBarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [TZImagePickerController.self])
                    BarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIImagePickerController.self])
                } else {
                    //
                }
                if BarItem != nil {
                    let titleTextAttributes = tzBarItem?.titleTextAttributes(for: UIControl.State())
                    BarItem!.setTitleTextAttributes(titleTextAttributes, for: UIControl.State())
                }
            }
            return self.pickerVC!
        }
        set {
            self.pickerVC = newValue
        }
    }
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: - Public
extension CredentialsImagePickController {
    //MARK: - 选择图片
    
    // 选择相片...<弹出相片选择界面>
    func pushImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 弹出第三方相片选择界面~!@
            let pickerVC = TZImagePickerController(maxImagesCount: self.maxImagesCount, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
            // 设置代理
            pickerVC?.pickerDelegate = self
            // 设置默认选中原图
            pickerVC?.isSelectOriginalPhoto = true
            // 设置不允许选中视频
            pickerVC?.allowPickingVideo = false
            // 设置内部不显示拍照按钮
            pickerVC?.allowTakePicture = false
            // 设置超时时间
            pickerVC?.timeout = 12
            // 设置状态栏样式
            pickerVC?.statusBarStyle = .default
            if #available(iOS 13.0, *) {
                pickerVC?.statusBarStyle = .darkContent
            }
            // 设置外观
//            pickerVC?.oKButtonTitleColorNormal = .white
//            pickerVC?.oKButtonTitleColorDisabled = .lightGray
            pickerVC?.naviBgColor = .white
            pickerVC?.naviTitleColor = .black
            pickerVC?.naviTitleFont = UIFont.boldSystemFont(ofSize: WH(16))
            pickerVC?.barItemTextColor = .black
            pickerVC?.barItemTextFont = UIFont.systemFont(ofSize: WH(15))
            pickerVC?.navigationBar.barTintColor = .green
            pickerVC?.navigationBar.isTranslucent = false
            pickerVC?.iconThemeColor = UIColor.init(red: 31/255.0, green: 185/255.0, blue: 34/255.0, alpha: 1.0)
            pickerVC?.showPhotoCannotSelectLayer = true
            pickerVC?.cannotSelectLayerColor = UIColor.white.withAlphaComponent(0.7)
            // 自定义导航栏上的返回按钮
            pickerVC?.navLeftBarButtonSettingBlock = { leftButton in
                leftButton?.setImage(UIImage.init(named: "icon_back_new_red_normal"), for: .normal)
                leftButton?.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
            }
            // 选择完成
            pickerVC?.didFinishPickingPhotosHandle = { photos,assets,isSelectOriginalPhoto in
                //
                print("didFinishPickingPhotosHandle")
            }
            if #available(iOS 13, *) {
                pickerVC!.modalPresentationStyle = .fullScreen
            }
            // 显示
            self.present(pickerVC!, animated: true, completion: nil)
        }
    }
    
    // 相机拍照
    func takePhoto() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied {
            // 无相机权限
            FKYProductAlertView.show(withTitle: "无法访问相机", leftTitle: "设置", rightTitle: "取消", message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机", handler: { (_, isRight) in
                if isRight == false {
                    self.openSetting()
                }
            })
        }
        else if authStatus == .notDetermined {
            // 防止用户首次拍照拒绝授权时相机页黑屏
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.takePhoto()
                    })
                }
            }
            // 拍照之前还需要检查相册权限
        }
        //else if (TZImageManager.default().authorizationStatus() == 2) {
        else if PHPhotoLibrary.authorizationStatus().rawValue == 2 {
            // 已被拒绝，没有相册权限，将无法保存拍的照片
            FKYProductAlertView.show(withTitle: "无法访问相册", leftTitle: "设置", rightTitle: "取消", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", handler: { (_, isRight) in
                if isRight == false {
                    self.openSetting()
                }
            })
        }
        //else if (TZImageManager.default().authorizationStatus() == 0) {
        else if PHPhotoLibrary.authorizationStatus().rawValue == 0 {
            // 未请求过相册权限
            TZImageManager.default().requestAuthorization(completion: {
                self.takePhoto()
            })
        }
        else {
            // 调用相机
            let sourceType: UIImagePickerController.SourceType = .camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerVC.sourceType = sourceType
                self.imagePickerVC.modalPresentationStyle = .overCurrentContext
                if #available(iOS 13, *) {
                    self.imagePickerVC.modalPresentationStyle = .fullScreen
                }
                self.present(self.imagePickerVC, animated: true, completion: nil)
            }
            else {
                print("模拟器中无法打开照相机,请在真机中使用")
            }
        }
    }
    
    
    //MARK: - 保存图片
    
    // 保存图片...<需要先通过url来下载图片，然后才进行保存操作>
    func savePhotoToAlbum(_ url: String) {
        //if (TZImageManager.default().authorizationStatus() == 2) {
        //if PHPhotoLibrary.authorizationStatus().rawValue == 2 {
        if !FKYJurisdictionTool.getPhotoLibraryJueiaDiction() {
            // 无相册权限
//            FKYProductAlertView.show(withTitle: "无法访问相册", leftTitle: "设置", rightTitle: "取消", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", handler: { (_, isRight) in
//                self.openSetting()
//            })
        }
        else {
            // 有相册权限
            SDWebImageManager.shared().downloadImage(with: URL(string: url)!, options: .lowPriority, progress: nil) { (image, _, _, _, _) in
                TZImageManager.default()?.savePhoto(with: image, completion: { (phAsset, error) in
                    if (error != nil) {
                        // 失败
                        self.toast(error?.localizedDescription)
                    }
                    else {
                        // 成功
                        self.toast("保存成功")
                    }
                })
            }
        }
    }
    
    // 保存图片...<直接保存图片>
    func saveImageToAlbum(_ img: UIImage) {
        //if (TZImageManager.default().authorizationStatus() == 2) {
        //if PHPhotoLibrary.authorizationStatus().rawValue == 2 {
        if !FKYJurisdictionTool.getPhotoLibraryJueiaDiction() {
            // 无相册权限
//            FKYProductAlertView.show(withTitle: "无法访问相册", leftTitle: "设置", rightTitle: "取消", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", handler: { (_, isRight) in
//                self.openSetting()
//            })
        }
        else {
            // 有相册权限
            TZImageManager.default()?.savePhoto(with: img, completion: { (phAsset, error) in
                if (error != nil) {
                    // 失败
                    self.toast(error?.localizedDescription)
                }
                else {
                    // 成功
                    self.toast("保存成功")
                }
            })
        }
    }
}


//MARK: - Private
extension CredentialsImagePickController {
    // 打开设置
    fileprivate func openSetting() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    // 图片编码,压缩,上传 <队列上传 整体封装>
    fileprivate func uploadImage(_ image: UIImage) {
        // 上传图片开始
        self.currentImageIndex = self.currentImageIndex + 1
        if let closure = self.uploadStatusClosure,self.currentImageIndex == 1 {
            closure(.begin)
        }
        
        //
        let concurrentQueue = DispatchQueue(label: "fky.uploadImage-\(image.hashValue)", attributes: .concurrent)
        self.gcdGroup.enter()
        
        //
        concurrentQueue.async(group: gcdGroup) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 压缩 & 上传图片...<new>
            if let imgData = UIImage.compressImage(image, strongSelf.maxImgData) {
                // 图片压缩成功
                
                // 上传图片...<new>
                strongSelf.requestForImageUpload(imgData, strongSelf.currentImageIndex)
                
                // 上传图片...<old>
                //self.requestForUploadImage(imgData, self.currentImageIndex)
            }
            else {
                // 图片压缩失败
                strongSelf.erroInfo.append((uploadIndex: strongSelf.currentImageIndex, errorMsg: "图片压缩失败"))
                strongSelf.gcdGroup.leave()
            }
            
            // 压缩 & 上传图片...<old>
            //self.requestForUploadImageWithCompress(image)
        }
        
        // 上传图片结束
        if self.chooseImagesCount == self.currentImageIndex {
            print("图片已全部上传完毕~!@")
            gcdGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if let uploadImageCompletionClosure = strongSelf.uploadImageCompletionClosure {
                    let sorted = strongSelf.erroInfo.sorted(by: { (errorTuple1, errorTuple2) -> Bool in
                        return errorTuple1.uploadIndex < errorTuple2.uploadIndex
                    })
                    uploadImageCompletionClosure(strongSelf.uploadFinalUrl, strongSelf.uploadFinalFileName, sorted, strongSelf.chooseImagesCount)
                }
                if let closure = strongSelf.uploadStatusClosure {
                    closure(.complete)
                }
            }
        }
        else {
            print("图片未全部上传完毕...")
        }
    }
}

    
//MARK: - Upload
extension CredentialsImagePickController {
    // 新的接口上传图片...<不包含压缩>
    // <URL地址：http://upload.111.com.cn/uploadfile (测试环境请配置host: upload.111.com.cn 10.6.80.229)>
    fileprivate func requestForImageUpload(_ imgData: Data, _ uploadIndex: Int) {
        /*
         [说明]
         上传图片的两种方式：
         1. base64方式：直接将图片转为base64编码，并作为value加入dic中，将dic作为接口入参传递;
         2. 文件流方式：将图片转为data数据流，在接口请求(当前使用AFN)中加入formData中;
         另：当前接口使用文件流方式；但若直接将文件流data作为value加入dic中，接口会报错<no file upload>。
        */
        
        // 入参
        var param: Dictionary<String, Any> = [String: Any]()
        param["tag"] = "yc" // url二级目录，区分不同应用模块，避免文件被相互覆盖...<可为空>...<若tag为空，默认为common>
        param["filename"] = CredentialsImagePickController.createImageName() // 文件名...<可为空>...<若filename为空，自动生成uuid作为文件名>
        //param["file"] = imgData // 上传(图片)文件流...<不可为空>...<当前图片data不作为value加入dic>
        // 上传图片
        FKYRequestService.sharedInstance()?.requestForUploadPic(withParam: param, image: nil, data: imgData, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 失败
            guard success else {
                var msg = "上传失败!"
                if let tip: String = model as? String, tip.isEmpty == false {
                    msg = tip
                }
                strongSelf.erroInfo.append((uploadIndex: uploadIndex, errorMsg: msg))
                strongSelf.gcdGroup.leave()
                return
            }
            // 成功
            if let url: String = model as? String, url.isEmpty == false {
                // 有返回url
                print(url)
                // 获取图片名称
                var fileName: String = ""
                let list: [String] = url.components(separatedBy: "/")
                if list.count > 0 {
                    fileName = list.last ?? ""
                }
                strongSelf.uploadFinalFileName.append(fileName) // 保存图片name
                strongSelf.uploadFinalUrl.append(url) // 保存图片url
                strongSelf.gcdGroup.leave()
            }
            else {
                // 返回url为空
                strongSelf.erroInfo.append((uploadIndex: uploadIndex, errorMsg: "上传失败!"))
                strongSelf.gcdGroup.leave()
            }
        })
    }
    
    // 旧的接口上传图片...<不包含压缩>
    // <https://usermanage.yaoex.com/api/enterpriseInfo/uploadPic>
    fileprivate func requestForUploadImage(_ imgData: Data, _ uploadIndex: Int) {
        //let request = NSMutableURLRequest(url: URL(string:"https://usermanage.yaoex.com/api/enterpriseInfo/uploadPic")!) as NSMutableURLRequest
        let request = NSMutableURLRequest(url: URL(string:API_YC_UPLOAD_PIC)!) as NSMutableURLRequest
        request.httpMethod = "POST"
        request.httpBody = imgData
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: (request as URLRequest), completionHandler: { (data, response, error) in
            if let data = data, data.count > 0 {
                // 上传成功
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                do {
                    if let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        // 返回数据ok
                        if let dict = dic["data"] as? NSDictionary {
                            // 有data
                            if let imgUrl = dict["imgUrl"] as? String {
                                // 有imgUrl...<成功~!@>
                                self.uploadFinalUrl.append(imgUrl) // 保存图片url
                                let filename = dict["fileName"] as? String
                                self.uploadFinalFileName.append(filename ?? "") // 保存图片filename
                                self.gcdGroup.leave()
                            }
                            else {
                                // 无imgUrl
                                var failureReason = "上传失败！"
                                if let error = dic["message"] as? String {
                                    failureReason = error
                                }
                                self.erroInfo.append((uploadIndex: uploadIndex, errorMsg: failureReason))
                                self.gcdGroup.leave()
                            }
                        }
                        else {
                            // 无data
                            var failureReason = "上传失败。"
                            if let errorMsg = dic["message"] as? String {
                                failureReason = errorMsg
                            }
                            else if let errorObj = error {
                                failureReason = errorObj.localizedDescription
                            }
                            self.erroInfo.append((uploadIndex: uploadIndex, errorMsg: failureReason))
                            self.gcdGroup.leave()
                        }
                    }
                    else {
                        // 返回数据错误
                        self.erroInfo.append((uploadIndex: uploadIndex, errorMsg: "上传失败"))
                        self.gcdGroup.leave()
                    }
                }
                catch {
                    // error
                    self.erroInfo.append((uploadIndex: uploadIndex, errorMsg: error.localizedDescription))
                    self.gcdGroup.leave()
                }
            }
            else {
                // 上传失败
                var failureReason = "上传失败了。"
                if let errorObj = error {
                    if -1009 == (errorObj as NSError).code || -1005 == (errorObj as NSError).code {
                        failureReason = "无法连接到网络"
                    }
                    else if -1001 == (errorObj as NSError).code {
                        failureReason = "图片上传超时"
                    }
                    else {
                        failureReason = errorObj.localizedDescription
                    }
                }
                self.erroInfo.append((uploadIndex: uploadIndex, errorMsg: failureReason))
                self.gcdGroup.leave()
            }
        })
        task.resume()
    }
    
    // 旧的接口上传图片...<包含压缩>...<by郭辉>
    // <https://usermanage.yaoex.com/api/enterpriseInfo/uploadPic>
    fileprivate func requestForUploadImageWithCompress(_ image: UIImage) {
        FKYRequestService.sharedInstance()?.uploadIMMessagePicture(image, param: nil, uploadUrl: API_YC_UPLOAD_PIC, completionBlock: { [weak self] (isSuccess, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            if isSuccess {
                // 成功
                if let data = response as? NSDictionary, let dict = data["data"] as? NSDictionary, let imgUrl = dict["imgUrl"] as? String {
                    // 上传成功
                    let filename = dict["fileName"] as? String // 获取图片名称
                    strongSelf.uploadFinalFileName.append(filename ?? "") // 保存图片filename
                    strongSelf.uploadFinalUrl.append(imgUrl) // 保存图片url
                    strongSelf.gcdGroup.leave()
                }
                else {
                    // 上传失败
                    var failureReason = "上传失败"
                    if let data = response as? NSDictionary,let errorMsg = data["message"] as? String {
                        failureReason = errorMsg
                    }
                    strongSelf.erroInfo.append((uploadIndex: strongSelf.currentImageIndex, errorMsg: failureReason))
                    strongSelf.gcdGroup.leave()
                }
            }
            else {
                // 失败
                strongSelf.erroInfo.append((uploadIndex: strongSelf.currentImageIndex, errorMsg: error?.localizedDescription ?? "上传失败！"))
                strongSelf.gcdGroup.leave()
            }
        })
    }
}


//MARK: - TZImagePickerControllerDelegate
extension CredentialsImagePickController: TZImagePickerControllerDelegate {
    // 已选中图片 <当前方法中的警告不能改；否则选择图片后不走回调>
    @objc func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool) {
        // 获取图片
        self.chooseImagesCount = assets.count
        self.currentImageIndex = 0
        self.uploadFinalUrl = []
        self.uploadFinalFileName = []
        self.erroInfo = []
        print("上传图片个数:\(assets.count)")
        assets.forEach { (asset) in
            TZImageManager.default()?.getOriginalPhoto(with: asset as? PHAsset, completion: { [weak self] (image, dict) in
                if let strongSelf = self, let selectedImage = image {
                    // 上传图片
                    strongSelf.uploadImage(selectedImage)
                }
            })
        } // for
    }
    
    // <当前方法中的警告不能改；否则选择图片后不走回调>
    @objc func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable: Any]]!) {
        //
    }
    
    // 取消选择
    @objc func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - CameraDelegate
extension CredentialsImagePickController: CameraDelegate {
    // 相机图片上传
    func toUploadImage(_ takePhoto: UIImage) {
        self.chooseImagesCount = 1
        self.currentImageIndex = 0
        self.uploadFinalUrl = []
        self.uploadFinalFileName = []
        self.erroInfo = []
        self.uploadImage(takePhoto)
    }
}


//MARK: - Class
extension CredentialsImagePickController {
    //
    @objc class func createImageName() -> String {
        // userid
        let userid: String = (FKYLoginAPI.loginStatus() == .unlogin) ? "1024" : FKYLoginAPI.currentUserId()
        
        // time
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        let time = formatter.string(from: Date())
        
        // uuid
        let uuid = UIDevice.readIdfvForDeviceId()
        
        // random number [10, 99)
        let max: UInt32 = 100
        let min: UInt32 = 10
        let number = arc4random_uniform(max - min) + min
        //let number = arc4random_uniform(100)
        
        // 图片名称
        let name: String = "iOS-YC" + "-" + userid + "-" + time + "-" + (uuid ?? "xzy") + "-" + String(number)
//        // hash后的最终名称
//        let hashName = (name as NSString).hash
//        // 带格式后缀
//        return String(hashName) + ".jpg"
        
        // md5加密...<32位>
        let finalName = (name as NSString).fromMD5()
        guard let fName = finalName, fName.isEmpty == false else {
            return name + ".jpg"
        }
        if fName.count < 10 || fName.count > 80 {
            return name + ".jpg"
        }
        return fName + ".jpg"
    }
}

