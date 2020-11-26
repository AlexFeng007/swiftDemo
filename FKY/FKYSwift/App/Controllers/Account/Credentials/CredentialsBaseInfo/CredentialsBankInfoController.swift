//
//  CredentialsBankInfoController.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  (填写基本信息之)<编辑>企业银行信息

import UIKit

typealias BankInfoSaveClosure = (ZZBankInfoModel?)->(Void)

class CredentialsBankInfoController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout  {
    //MARK: - Property
    
    fileprivate lazy var imageSourceView: CredentialsUploadImageSourceView = {
        let v = CredentialsUploadImageSourceView()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(CredentialsInputCollectionCell.self, forCellWithReuseIdentifier: "CredentialsInputCollectionCell")
        cv.register(FKYCredentialsBankImageCell.self, forCellWithReuseIdentifier: "FKYCredentialsBankImageCell")
        cv.register(FKYCredentialsBaseInfoAddressDetailCollectionCell.self, forCellWithReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    fileprivate var navBar: UIView?
    fileprivate var rightBar: UIButton?
    fileprivate var titleArray: [String] = ["开户银行","银行账号","开户名","银行开户许可证"]
    fileprivate var aryDataType: [ZZEnterpriseBankInputType] = [.BankName, .BankCode, .BankAccountName, .BankPic]
    
    fileprivate var imageUploadController: CredentialsImagePickController?
    fileprivate var picArr: [String]? = [String]()
    fileprivate var editBankInfoModel: ZZBankInfoModel = ZZBankInfoModel()
    fileprivate weak var selectedImageView: UIImageView?
    
    var canEdit: Bool = false
    var refuseReason: String?
    var bankInfoModel: ZZBankInfoModel? {
        willSet{
            if let newvalue = newValue {
                self.editBankInfoModel.bankName = newvalue.bankName
                self.editBankInfoModel.bankCode = newvalue.bankCode
                self.editBankInfoModel.accountName = newvalue.accountName
                if nil == self.editBankInfoModel.QCFile {
                    self.editBankInfoModel.QCFile = ZZFileModel()
                }
                if let filePath = newvalue.QCFile?.filePath {
                    self.editBankInfoModel.QCFile?.filePath = "\(filePath)"
                }
            }
        }
    }
    var useFor: ViewConrollerUseType = .forUpdate
    var selectedTitle: String?
    var originBankModelHashDes: String = ""
    var saveClosure: BankInfoSaveClosure?
    
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        originBankModelHashDes = self.editBankInfoModel.hashString()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal"){ [weak self] in
            if let strongSelf = self {
                strongSelf.view.endEditing(true)
                switch strongSelf.useFor {
                case .forRegister:
                    if strongSelf.isEditBankInfo() {
                        FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "您更改的信息还未保存，确定返回？", handler: { (alertView, isRight) in
                            if isRight {
                                FKYNavigator.shared().pop()
                            }
                        })
                    }else {
                        FKYNavigator.shared().pop()
                    }
                case .forUpdate:
                    FKYNavigator.shared().pop()
                }
            }
        }
        self.fky_setupRightImage("") { [weak self] in
            if let strongSelf = self {
                strongSelf.saveBankInfo()
            }
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.setTitleColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), for: .highlighted)
        self.NavigationBarRightImage!.fontTuple = t19
        
        if canEdit {
            self.fky_setupTitleLabel("编辑企业银行信息")
            self.NavigationBarRightImage?.isHidden = false
        }else{
            self.fky_setupTitleLabel("企业银行信息")
            self.NavigationBarRightImage?.isHidden = true
        }
        self.fky_hiddedBottomLine(false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        self.view.addSubview(imageSourceView)
        self.view.sendSubviewToBack(imageSourceView)
        imageSourceView.selectSourceClosure = {[weak self] sourceType in
            if let strongSelf = self {
                if sourceType == "Album" {
                    strongSelf.imageUploadController!.pushImagePickerController()
                }else if(sourceType == "Camera"){
                    strongSelf.imageUploadController!.takePhoto()
                }
            }
        }
        
        self.imageUploadController = CredentialsImagePickController()
        self.imageUploadController!.maxImagesCount = 1
        self.addChild(self.imageUploadController!)
        self.view.addSubview(self.imageUploadController!.view)
        self.view.sendSubviewToBack(self.imageUploadController!.view)
        self.imageUploadController!.uploadImageCompletionClosure = { [weak self] (imageUrlArr, filenames, errorInfo, toUploadImageCount) in
            if let strongSelf = self {
                if let QCFile = strongSelf.editBankInfoModel.QCFile {
                    QCFile.filePath = imageUrlArr.first
                    QCFile.fileName = filenames.first
                }else{
                    strongSelf.editBankInfoModel.QCFile = ZZFileModel()
                    strongSelf.editBankInfoModel.QCFile?.filePath = imageUrlArr.first
                    strongSelf.editBankInfoModel.QCFile?.fileName = filenames.first
                }
                if errorInfo.count > 0 {
                    if let errorTuple = errorInfo.first {
                        strongSelf.toast("银行开户许可证上传失败\\n\(errorTuple.errorMsg)")
                    }else{
                        strongSelf.toast("银行开户许可证上传失败\\n")
                    }
                }
                strongSelf.collectionView.reloadData()
            }
        }
        // 图片上传状态机
        self.imageUploadController?.uploadStatusClosure = { status in
            if status == .begin {
                self.showLoading()
            }
            if status == .complete {
                self.dismissLoading()
            }
        }
    }
    
    
    //MARK: - Private
    
    //
    fileprivate func isEditBankInfo() -> Bool {
        return !(originBankModelHashDes == self.editBankInfoModel.hashString())
    }
    
    //
    fileprivate func saveBankInfo() {
        // 保存
        self.collectionView.endEditing(true)
        
        if let bankName = self.editBankInfoModel.bankName {
            if 0 < bankName.count {
                let words = bankName.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    self.toast("开户银行填写有误")
                    return
                }
            }else {
                self.toast("请先填写开户银行")
                return
            }
        }else {
            self.toast("请先填写开户银行")
            return
        }
        
        if let bankCode = self.editBankInfoModel.bankCode {
            if 0 < bankCode.count {
                let words = bankCode.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    self.toast("银行账号填写有误")
                    return
                }
            }else {
                self.toast("请先填写银行账号")
                return
            }
        }else {
            self.toast("请先填写银行账号")
            return
        }
        
        if let accountName = self.editBankInfoModel.accountName {
            if 0 < accountName.count {
                let words = accountName.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let justwords = words.joined(separator: "")
                if 0 >= justwords.count {
                    self.toast("银行开户名填写有误")
                    return
                }
            }else {
                self.toast("请先填写银行开户名")
                return
            }
        }else {
            self.toast("请先填写银行开户名")
            return
        }

        if self.editBankInfoModel.QCFile?.filePath == nil || self.editBankInfoModel.QCFile?.filePath == "" {
            self.toast("请先上传银行开户许可证")
            return
        }
        
        if let closure = self.saveClosure {
            closure(self.editBankInfoModel)
        }
        
        FKYNavigator.shared().pop()
    }
    
    //
    fileprivate func showPhotoBrowser(_ image: UIImage?, url: String, superView: UIView) {
        if url.isEmpty == true, image == nil {
            return
        }
        
        // imageview
        let imgview = UIImageView.init(frame: CGRect.init(x: (SCREEN_WIDTH - WH(0)) / 2, y: (SCREEN_HEIGHT - WH(0)) / 2, width: WH(0), height: WH(0)))
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        imgview.sd_setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "image_default_img"))
        // 新版查看大图
        let imageViewer = XHImageViewer.init()
        imageViewer.showPageControl = true
        imageViewer.userPageNumber = true
        imageViewer.hideWhenOnlyOne = true
        imageViewer.showSaveBtn = true
        imageViewer.show(withImageViews: [imgview], selectedView: imgview)
    }
    
    
    // MARK: - CollectionViewDelegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryDataType.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentType = aryDataType[indexPath.row]
        switch contentType {
        case .BankAccountName: // 开户名
            fallthrough
        case .BankName: // 开户银行
            var content = ""
            if .BankName == contentType {
                if let bankName = self.editBankInfoModel.bankName {
                    content = bankName
                }
            }
            else if .BankAccountName == contentType {
                if let accountName = self.editBankInfoModel.accountName {
                    content = accountName
                }
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBaseInfoAddressDetailCollectionCell", for: indexPath) as! FKYCredentialsBaseInfoAddressDetailCollectionCell
            cell.canEdit = self.canEdit
            
            cell.configCell(contentType.rawValue, content: content, type: .BankName, defaultContent: contentType.description, isShowStarView: false)
            cell.updateLayout(contentType)
            cell.inputTextMaxLong = 60
            cell.saveClosure = {[weak self] msg in
                if let strongSelf = self {
                    if .BankName == contentType {
                        strongSelf.editBankInfoModel.bankName = msg
                    } else if .BankAccountName == contentType {
                        strongSelf.editBankInfoModel.accountName = msg
                    }
                }
            }
            return cell
        case .BankCode: // 银行账号
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CredentialsInputCollectionCell", for: indexPath) as! CredentialsInputCollectionCell
            cell.isCanEdit = self.canEdit
            
            var content = ""
            if let bankCode = self.editBankInfoModel.bankCode {
                content = bankCode
            }
            cell.configCell(contentType.rawValue, content: content, type: .BankCode, defaultContent: contentType.description, isShowStarView: false)
            cell.saveClosure = { [weak self] msg in
                if let strongSelf = self {
                    strongSelf.editBankInfoModel.bankCode = msg
                }
            }
            return cell
        case .BankPic: // 开户证明（图片）
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCredentialsBankImageCell", for: indexPath) as! FKYCredentialsBankImageCell
            cell.isCanEdit = self.canEdit
            // 增加图片
            cell.addImageClosure = { [weak self, weak collectionView] in
                if let strongCollectionView = collectionView {
                    strongCollectionView.endEditing(true)
                }
                if let strongSelf = self {
                    strongSelf.view.bringSubviewToFront(strongSelf.imageSourceView)
                    strongSelf.imageSourceView.showClosure!()
                    strongSelf.imageUploadController!.maxImagesCount = 1//(5 - midModel.pathList.count)
                }
            }
            // 删除图片
            cell.deleteImageClosure = { [weak self, weak collectionView] in
                if let strongSelf = self {
                    if let QCFile = strongSelf.editBankInfoModel.QCFile {
                        QCFile.filePath = ""
                    }else{
                        strongSelf.editBankInfoModel.QCFile = ZZFileModel()
                        strongSelf.editBankInfoModel.QCFile?.filePath = ""
                    }
                    if let strongCollectionView = collectionView {
                        strongCollectionView.reloadData()
                    }
                }
            }
            
            if let fileModel = self.editBankInfoModel.QCFile, let imgUrl = fileModel.filePath {
                cell.configCell(contentType.rawValue, imgUrl: imgUrl)
                cell.viewLargerImageClosure = {[weak self] (image, imageView) in
                    if let strongSelf = self {
                        strongSelf.selectedImageView = imageView
                        strongSelf.showPhotoBrowser(image, url: imgUrl, superView: imageView)
                    }
                }
            }
            else {
                cell.configCell(contentType.rawValue, imgUrl: nil)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentType = aryDataType[indexPath.row]
        switch contentType {
        case .BankName:
            fallthrough
        case .BankCode:
            fallthrough
        case .BankAccountName:
            return CGSize(width: SCREEN_WIDTH, height: WH(56))
        case .BankPic:
            return CGSize(width: SCREEN_WIDTH, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.refuseReason != nil {
            let height = self.refuseReason!.heightForRefuseReason() + h8 + h1
            return CGSize(width: SCREEN_WIDTH,height: height)
        }
        return CGSize(width: SCREEN_WIDTH, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            v.configCell("拒绝原因:", content: self.refuseReason)
            v.backgroundColor = bg1
            return v
        }
        else {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            return v
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
