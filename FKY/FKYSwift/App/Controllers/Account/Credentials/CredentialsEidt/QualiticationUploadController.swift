//
//  QualiticationUploadController.swift
//  FKY
//
//  Created by mahui on 2016/11/1.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  上传资质...<不再使用>

import Foundation

typealias commonClosure = (_ isSelected : Bool)->()

// 编辑状态, 查看状态
enum ControllerUseType : Int {
    case forRegitster
    case forEdit
}


class QualiticationUploadController: UIViewController {
    //MARK: - Private Property
    fileprivate lazy var segment: HMSegmentedControl = {
        let titles = ["批发企业", "零售企业", "批零一体"]
        var normalImages = [UIImage]()
        var selectedImages = [UIImage]()
        for (index, value) in titles.enumerated() {
            if let normalImage = self.segmentTitleImage(withTag: "\(index+1)", title: value, size: CGSize.init(width: SCREEN_WIDTH/3, height: WH(49)), isSelected: false) {
                normalImages.append(normalImage)
            }
            if let selectedImage = self.segmentTitleImage(withTag: "\(index+1)", title: value, size: CGSize.init(width: SCREEN_WIDTH/3, height: WH(49)), isSelected: true) {
                selectedImages.append(selectedImage)
            }
        }
        
        let sv: HMSegmentedControl = HMSegmentedControl(sectionImages: normalImages, sectionSelectedImages: selectedImages)
        sv.selectionIndicatorColor = RGBColor(0xff2d5c)
        sv.selectionIndicatorHeight = 2
        sv.selectionStyle = .fullWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.indexChangeBlock = { index in
            self.selectedIndex = index
        }
        return sv
    }()
    
    // 添加图片 AlertView
    fileprivate lazy var imageSourceView: CredentialsUploadImageSourceView = {
        let v = CredentialsUploadImageSourceView()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let segHeight = self.isAllInOne ? WH(49) : 0
        let sv = UIScrollView(frame: CGRect(x: 0, y: naviBarHeight()+segHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - segHeight - naviBarHeight()))
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .white
        sv.contentSize = CGSize(width: SCREEN_WIDTH.multiple(self.isAllInOne ? 3 : 1), height: SCREEN_HEIGHT - segHeight - naviBarHeight())
        return sv
    }()
    
    fileprivate var value: Int = 0
    fileprivate var selectedIndex: Int {
        get {
            return value
        }
        set {
            value = newValue
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(self.value), y: 0)
            }) { (ret) in
                
            }
        }
    }
    
    // 当前选中的View
    fileprivate var currentQualiticationView: QualiticationCollectionView {
        get {
            return collectionViews[selectedIndex]
        }
    }
    
    fileprivate var collectionViews = [QualiticationCollectionView]()
    fileprivate var imageUploadController: CredentialsImagePickController?
    fileprivate weak var selectedImageView: UIImageView?
    fileprivate var selectedImageIndex: IndexPath?
    fileprivate var currentEdit: [String]?
    
    fileprivate var originZZModelHashString: String = ""
    fileprivate var credentialsBaseInfoService = CredentialsBaseInfoProvider()
    fileprivate var isAllInOne: Bool { // 是否是批零一体企业
        get {
            return (self.zzModel?.enterprise?.isWholesaleRetail == 1)
        }
    }
    
    // 说明：定义下面两个model数组，用于解决用户上传资质证书成功后，切换三证合一开关，从而导致之前上传的资质证书model消失的问题~!@
    //（非批零一体 or 批零一体之批发企业）对应的资质model数组...<用于临时保存用户新增/更新的资质证书model>
    fileprivate var qcModelList: [ZZFileProtocol] = []
    //（批零一体之零售企业 & 批零一体之批零一体）对应的资质model数组...<用于临时保存用户新增/更新的资质证书model>
    fileprivate var qcRetailModelList: [ZZFileProtocol] = []
    
    //MARK: - Public Property
    var navBar : UIView?
    var fileHelper = ZZUploadHelpFile()
    var controllerType : ControllerUseType = .forRegitster
    var zzModel : ZZModel? 
    // 通过企业名称获取的企业信息model
    var enterpriseInfoFromErp: ZZEnterpriseInfo?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 从缓存中取数据
        self.readCacheData()
        
        // 设置用于更新的数据源
        self.setupRefreshData()
        
        // 导航栏UI
        self.setupNavBar()
        
        // 内容UI
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("QualiticationUploadController 销毁")
    }
}


// MARK: - UI
extension QualiticationUploadController {
    // 导航栏UI
    fileprivate func setupNavBar() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("上传资质")
        self.fky_hiddedBottomLine(false)
        self.NavigationTitleLabel!.fontTuple = t14
        
        // 返回
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 返回前缓存资质数据
            strongSelf.saveCacheData()
            FKYNavigator.shared().pop()
        }
    }
    
    // 内容视图UI
    fileprivate func setupView() {
        // 上传图片弹出框
        self.view.addSubview(self.imageSourceView)
        self.view.sendSubviewToBack(self.imageSourceView)
        self.imageSourceView.selectSourceClosure = {[weak self] sourceType in
            if let strongSelf = self {
                if sourceType == "Album" {
                    // 相册
                    strongSelf.imageUploadController!.pushImagePickerController()
                } else if (sourceType == "Camera") {
                    // 相机
                    strongSelf.imageUploadController!.takePhoto()
                }
            }
        }
        
        // 最终的上传图片vc类
        self.imageUploadController = CredentialsImagePickController()
        self.addChild(self.imageUploadController!)
        self.view.addSubview(self.imageUploadController!.view)
        self.view.sendSubviewToBack(self.imageUploadController!.view)
        // 图片上传完成closure
        self.imageUploadController!.uploadImageCompletionClosure = { [weak self] (imageUrlArr, filenames, errorInfo, toUploadImageCount) in
            // guard
            guard let strongSelf = self else {
                return
            }
            guard let currentIndexPath = strongSelf.selectedImageIndex else {
                return
            }
            
            // 数据源model...<元组>
            var tuple = strongSelf.currentQualiticationView.dataSource[currentIndexPath.section-1]
            // 当前证件类型
            guard let fileType = QCType(rawValue: tuple.fileType) else {
                return
            }
            
            // toast
            if errorInfo.count > 0 {
                if (toUploadImageCount > 1) {
                    // 上传多张图片时失败
                    var errorMsg = "\(fileType.description)上传成功了\(imageUrlArr.count)/\(toUploadImageCount):\n"
                    let failStrings = errorInfo.map({ (errorTuple) -> String in
                        return "第\(errorTuple.uploadIndex)上传失败：\(errorTuple.errorMsg)"
                    })
                    errorMsg.append((failStrings as NSArray).componentsJoined(by: "\n"))
                    strongSelf.toast(errorMsg, delay: 1.0, numberOfLines: 0)
                }
                else {
                    // 上传1张图片时失败
                    if let errorTuple = errorInfo.first {
                        strongSelf.toast("\(fileType.description)上传失败\n\(errorTuple.errorMsg)", delay: 1.0, numberOfLines: 0)
                    }
                    else {
                        strongSelf.toast("\(fileType.description)上传失败\n")
                    }
                }
            } // 有上传失败情况
            
            // 当前已上传图片数量
            var uploadNumber = 0
            for i in 0..<tuple.fileModels.count {
                // 账号类型不同，返回的数据model类型也不同
                let item: ZZFileProtocol? = tuple.fileModels[i]
                // fileName、filePath两字段同时存在时，表示当前资质文件model一定有上传图片
                if let obj = item, let fileName: String = obj.fileName, fileName.isEmpty == false, let filePath: String = obj.filePath, filePath.isEmpty == false {
                    uploadNumber += 1
                }
                else {
                    // 图片相关属性为空，表示当前图片已被删除
                }
            }
            print("已上传图片数量：" + "\(uploadNumber)" + ", 当前资质类型最大可上传图片数量:" + "\(fileType.maxCount)")
            
            // (之前已上传成功的图片数量)超过规定最大数量...<不处理>
            if uploadNumber >= fileType.maxCount {
                return
            }
            // 上传的图片均失败...<不处理>
            if imageUrlArr.count == 0 {
                return
            }
            
            // 至少上传成功1张图片
            let leftUploadNumber = fileType.maxCount - uploadNumber // 待上传图片数量
            var countFinal = imageUrlArr.count // 当前已上传、待处理的图片数量
            if imageUrlArr.count > leftUploadNumber {
                // 异常...<当前上传的图片数量超过所需的图片数量>
                countFinal = leftUploadNumber
            }
            print("已上传、待处理的最终图片数量：" + "\(countFinal)")
            
            // 遍历图片model
            for index in 0..<countFinal {
                // 当前图片url
                let imgUrl = imageUrlArr[index]
                // 逻辑处理
                if strongSelf.currentQualiticationView.viewType == .undefined || strongSelf.currentQualiticationView.viewType == .wholeSale {
                    // 非批零一体 or 批零一体之批发企业
                    if tuple.fileModels.count == 1, fileType.maxCount == 1 {
                        // 有证件号和效期的情况，只会有一个model
                        // 已存在资质model，说明用户是删除图片后重新上传...<更新>
                        let model: ZZFileModel = tuple.fileModels.first as! ZZFileModel
                        model.typeId = tuple.fileType       // 资质证书类型id
                        model.filePath = imgUrl             // 图片路径
                        model.fileName = filenames[index]   // 图片名称
                        // 若文字model不为空，且当前资质model中的文字为空，则直接赋值
                        if let textModel = tuple.fileText {
                            if model.qualificationNo == nil, let qNumber = textModel.qualificationNo, qNumber.isEmpty == false {
                                model.qualificationNo = qNumber
                            }
                            if model.starttime == nil, let sTime = textModel.starttime, sTime.isEmpty == false {
                                model.starttime = sTime
                            }
                            if model.endtime == nil, let eTime = textModel.endtime, eTime.isEmpty == false {
                                model.endtime = eTime
                            }
                        }
                        // 更新
                        tuple.fileModels.removeAll()
                        tuple.fileModels.append(model)
                        
                        // refresh
                        var updateIndex = -1
                        for index in 0..<strongSelf.qcModelList.count {
                            let obj: ZZFileProtocol = strongSelf.qcModelList[index]
                            if obj.typeId == model.typeId {
                                updateIndex = index
                                break
                            }
                        } // for
                        if updateIndex >= 0 {
                            // 更新
                            strongSelf.qcModelList[updateIndex] = model
                        }
                        else {
                            // 插入...<error>
                            strongSelf.qcModelList.append(model)
                        }
                    }
                    else {
                        // 新建model...<新增>
                        let model = ZZFileModel()
                        model.typeId = tuple.fileType       // 资质证书类型id
                        model.filePath = imgUrl             // 图片路径
                        model.fileName = filenames[index]   // 图片名称
                        // 若文字model不为空，则直接赋值
                        if let textModel = tuple.fileText {
                            if let qNumber = textModel.qualificationNo, qNumber.isEmpty == false {
                                model.qualificationNo = qNumber
                            }
                            if let sTime = textModel.starttime, sTime.isEmpty == false {
                                model.starttime = sTime
                            }
                            if let eTime = textModel.endtime, eTime.isEmpty == false {
                                model.endtime = eTime
                            }
                        }
                        
                        if fileType.maxCount == 1 {
                            // 仅能上传单张时，先删除
                            tuple.fileModels.removeAll()
                        }
                        // 加入...<可能只有一个（第一次加入），也可能有多个>
                        tuple.fileModels.append(model)
                        
                        if fileType.maxCount == 1 {
                            // 仅能上传单张时，先删除
                            var updateIndex = -1
                            for index in 0..<strongSelf.qcModelList.count {
                                let obj: ZZFileProtocol = strongSelf.qcModelList[index]
                                if obj.typeId == model.typeId {
                                    updateIndex = index
                                    break
                                }
                            } // for
                            if updateIndex >= 0 {
                                strongSelf.qcModelList.remove(at: updateIndex)
                            }
                        }
                        // refresh...<插入>
                        strongSelf.qcModelList.append(model)
                        
                        if tuple.fileModels.count == 1 {
                            // 1张
                            if fileType.maxCount > 1 {
                                // 当前类型可传多张
                                //tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                                tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forEdit]
                            } else {
                                // 当前类型仅只能传1张...<设置为默认样式:左边图片，右边描述>
                                //tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                            }
                        }
                        else {
                            // 已上传多张
                            if (tuple.fileModels.count < fileType.maxCount) {
                                // 未超过最大个数
                                tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                            }
                        }
                    }
                }
                else {
                    // 其它企业类型...<无证件号/效期>
                    if tuple.fileModels.count == 1, fileType.maxCount == 1 {
                        // 已存在资质model，说明用户是删除图片后重新上传...<更新>
                        let model: ZZAllInOneFileModel = tuple.fileModels.first as! ZZAllInOneFileModel
                        model.typeId = tuple.fileType       // 资质证书类型id
                        model.filePath = imgUrl             // 图片路径
                        model.fileName = filenames[index]   // 图片名称
                        // 如果是新用户注册时，没有获取的enterpriseid，则先置0
                        if let enterpriseid = strongSelf.zzModel?.enterprise?.enterpriseId {
                            model.enterpriseId = Int(enterpriseid)
                        } else {
                            model.enterpriseId = 0
                        }
                        // 更新...<保证只有一个model>
                        tuple.fileModels.removeAll()
                        tuple.fileModels.append(model)
                        
                        // refresh
                        var updateIndex = -1
                        for index in 0..<strongSelf.qcRetailModelList.count {
                            let obj: ZZFileProtocol = strongSelf.qcRetailModelList[index]
                            if obj.typeId == model.typeId {
                                updateIndex = index
                                break
                            }
                        } // for
                        if updateIndex >= 0 {
                            // 更新
                            strongSelf.qcRetailModelList[updateIndex] = model
                        }
                        else {
                            // 插入...<error>
                            strongSelf.qcRetailModelList.append(model)
                        }
                    }
                    else {
                        // 新建model...<新增>
                        let model = ZZAllInOneFileModel()
                        model.typeId = tuple.fileType       // 资质证书类型id
                        model.filePath = imgUrl             // 图片路径
                        model.fileName = filenames[index]   // 图片名称
                        // 如果是新用户注册时，没有获取的enterpriseid，则先置0
                        if let enterpriseid = strongSelf.zzModel?.enterprise?.enterpriseId {
                            model.enterpriseId = Int(enterpriseid)
                        } else {
                            model.enterpriseId = 0
                        }
                        
                        if fileType.maxCount == 1 {
                            // 仅能上传单张时，先删除
                            tuple.fileModels.removeAll()
                        }
                        // 加入...<可能只有一个（第一次加入），也可能有多个>
                        tuple.fileModels.append(model)
                        
                        if fileType.maxCount == 1 {
                            // 仅能上传单张时，先删除
                            var updateIndex = -1
                            for index in 0..<strongSelf.qcRetailModelList.count {
                                let obj: ZZFileProtocol = strongSelf.qcRetailModelList[index]
                                if obj.typeId == model.typeId {
                                    updateIndex = index
                                    break
                                }
                            } // for
                            if updateIndex >= 0 {
                                strongSelf.qcRetailModelList.remove(at: updateIndex)
                            }
                        }
                        // refresh...<插入>
                        strongSelf.qcRetailModelList.append(model)
                        
                        if tuple.fileModels.count == 1 {
                            // 1张
                            if fileType.maxCount > 1 {
                                // 当前类型可传多张
                                //tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                                tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forEdit]
                            }else {
                                // 当前类型仅只能传1张...<设置为默认样式:左边图片，右边描述>
                                //tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                            }
                        }
                        else {
                            // 已上传多张
                            if (tuple.fileModels.count < fileType.maxCount) {
                                // 未超过最大个数
                                tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                            }
                        }
                    }
                } // 其它企业类型...<无证件号/效期>
            } // for
            
            // 赋值
            strongSelf.currentQualiticationView.dataSource[currentIndexPath.section-1] = tuple
            // 刷新
            strongSelf.currentQualiticationView.reloadData()
        }
        // 上传状态更新closure
        self.imageUploadController!.uploadStatusClosure = { [weak self] status in
            guard let strongSelf = self else {
                return
            }
            if status == .begin {
                strongSelf.showLoading()
            }
            if status == .complete {
                strongSelf.dismissLoading()
            }
        }
        
        // 批零一体
        if isAllInOne {
            view.addSubview(segment)
            segment.snp.makeConstraints({ (make) in
                make.top.equalTo((navBar?.snp.bottom)!)
                make.left.right.equalTo(view)
                make.height.equalTo(WH(49))
            })
        }
        
        // scrollview容器视图
        view.addSubview(scrollView)
        // 各内容视图...<批零一体有3个页面>
        let numberOfViews = isAllInOne ? 3 : 1
        for index in 0..<numberOfViews {
            let qcView = QualiticationCollectionView()
            qcView.zzModel = self.zzModel
            qcView.controllerType = self.controllerType
            qcView.operation = self
            if isAllInOne {
                // 0 1 2
                qcView.viewType = QualiticationViewType(rawValue: index)!
            } else {
                qcView.viewType = .undefined
            }
            qcView.viewTost = { msg in
                self.toast(msg)
            }
            scrollView.addSubview(qcView)
            qcView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            collectionViews.append(qcView)
            // 封装数据源
            reloadQualitications(withView: qcView)
        }
    }
}


// MARK: - Cache Data
extension QualiticationUploadController {
    // 从缓存中取数据
    fileprivate func readCacheData() {
        guard .forRegitster == self.controllerType else {
            return
        }
        
        // 保存hash值
        originZZModelHashString = ZZModelQCListInfoPartInfo.qcListHashString(zzModel?.qcList, qualificationRetailList: zzModel?.qualificationRetailList, is3merge1: zzModel?.enterprise?.is3merge1, is3merge2: zzModel?.enterpriseRetail?.is3merge1, isWholesaleRetail: zzModel?.enterprise?.isWholesaleRetail)
        
        // 读取缓存model
        if let partInfo = ZZModelQCListInfoPartInfo.getQCListInfo() {
            // 有缓存的数据
            if let qcList = partInfo.qcList {
                // （非批零一体 or 批零一体之批发企业）对应的资质model数组
                self.zzModel?.qcList = qcList
            }
            if let qualificationRetailList = partInfo.qualificationRetailList {
                // （批零一体之零售企业 & 批零一体之批零一体）对应的资质model数组
                self.zzModel?.qualificationRetailList = qualificationRetailList
            }
            self.zzModel?.enterprise?.is3merge1 = partInfo.is3merge1
            self.zzModel?.enterpriseRetail?.is3merge1 = partInfo.is3merge2
            self.zzModel?.enterprise?.isWholesaleRetail = partInfo.isWholesaleRetail
        }
    }
    
    // 缓存数据
    fileprivate func saveCacheData() {
        guard .forRegitster == self.controllerType else {
            return
        }
        
        // 数据源...<不同类型>
        var fileModels: [ZZFileProtocol] = []
        var allInOneFileModels: [ZZFileProtocol] = []
        
//        for (_, value) in collectionViews.enumerated() {
//            value.dataSource.forEach({ (tuple) in
//                if value.viewType == .undefined || value.viewType == .wholeSale {
//                    // 非批零一体 or 批零一体之批发企业
//                    //fileModels.append(contentsOf: tuple.fileModels)
//
//                    // 针对用户未上传资质图片而先填写证件号/效期的状态，需要新建model来保存
//                    if tuple.fileModels.count > 0 {
//                        // 有资质model
//                        fileModels.append(contentsOf: tuple.fileModels)
//                    }
//                    else {
//                        // 无资质model
//                        if let textModel = tuple.fileText {
//                            // 判断有无文字内容
//                            var hasValue = false
//                            if let qNumber = textModel.qualificationNo, qNumber.isEmpty == false {
//                                hasValue = true
//                            }
//                            if let sTime = textModel.starttime, sTime.isEmpty == false {
//                                hasValue = true
//                            }
//                            if let eTime = textModel.endtime, eTime.isEmpty == false {
//                                hasValue = true
//                            }
//                            // 有文字则需要新建model来保存
//                            if hasValue {
//                                var model: ZZFileProtocol = ZZFileModel()
//                                model.qualificationNo = textModel.qualificationNo
//                                model.starttime = textModel.starttime
//                                model.endtime = textModel.endtime
//                                model.typeId = tuple.fileType
//                                fileModels.append(contentsOf: [model])
//                            }
//                        }
//                    }
//                }
//                else {
//                    // 其它企业类型
//                    allInOneFileModels.append(contentsOf: tuple.fileModels)
//                }
//            }) // for
//        } // for
        
        // 直接缓存用于实时更新refresh的两个最终数组
        fileModels = Array.init(qcModelList)
        allInOneFileModels = Array.init(qcRetailModelList)
        
        // 需缓存的model
        let partInfo: ZZModelQCListInfoPartInfo = ZZModelQCListInfoPartInfo(qcList: fileModels as? [ZZFileModel], qualificationRetailList: allInOneFileModels as? [ZZAllInOneFileModel], is3merge1: zzModel?.enterprise?.is3merge1, is3merge2: zzModel?.enterpriseRetail?.is3merge1, isWholesaleRetail: zzModel?.enterprise?.isWholesaleRetail)
        
        // 比较model的hash是否相同...<不同则缓存>
        if self.originZZModelHashString != partInfo.qcListHashString() {
            // 缓存
            partInfo.saveQCList()
        }
    }
}


// MARK: - RefreshData
extension QualiticationUploadController {
    // 设置/创建包含所有资质类型、用于实时更新/保存的最大资质类型model列表
    fileprivate func setupRefreshData() {
        // 所有资质类型model列表
        let listType: [QCType] = ZZUploadHelpFile.getAllQcTypeList()
        // 所有资质类型数据model列表
        let lisQc: [ZZFileProtocol] = ZZUploadHelpFile.getAllQcModelList(true, listType)
        let lisQcRetail: [ZZFileProtocol] = ZZUploadHelpFile.getAllQcModelList(false, listType)
        
        //
        guard let model = zzModel else {
            qcModelList.removeAll()
            qcModelList.append(contentsOf: lisQc)
            qcRetailModelList.removeAll()
            qcRetailModelList.append(contentsOf: lisQcRetail)
            return
        }
        
        if let list = model.qcList, list.count > 0 {
            ZZUploadHelpFile.setValueForAllQcModelList(lisQc, list)
            
            // 手动增加其它资质model...<因为资质数组（最大集合）中并未包含其它资质这种（可上传多图片）类型>
            var listFinal: [ZZFileProtocol] = Array.init(lisQc)
            for obj in list {
                if obj.typeId == 35 || obj.typeId == 37 {
                    listFinal.append(obj)
                }
            }
            
            qcModelList.removeAll()
            qcModelList.append(contentsOf: listFinal)
        }
        else {
            qcModelList.removeAll()
            qcModelList.append(contentsOf: lisQc)
        }
        
        if let list = model.qualificationRetailList, list.count > 0 {
            ZZUploadHelpFile.setValueForAllQcModelList(lisQcRetail, list)
            
            // 手动增加其它资质model...<因为资质数组（最大集合）中并未包含其它资质这种（可上传多图片）类型>
            var listFinal: [ZZFileProtocol] = Array.init(lisQcRetail)
            for obj in list {
                if obj.typeId == 35 || obj.typeId == 37 {
                    listFinal.append(obj)
                }
            }
            
            qcRetailModelList.removeAll()
            qcRetailModelList.append(contentsOf: listFinal)
        }
        else {
            qcRetailModelList.removeAll()
            qcRetailModelList.append(contentsOf: lisQcRetail)
        }
    }
    
    // 实时更新refresh数据...<仅针对证件号/效期的实时更新>
    fileprivate func updateRefreshData(_ model: ZZFileProtocol, _ isNormal: Bool) {
        if isNormal {
            // 非批零一体 or 批零一体之批发企业
            var updateIndex = -1 // 待更新的model索引
            for index in 0..<self.qcModelList.count {
                let obj: ZZFileProtocol = self.qcModelList[index]
                if obj.typeId == model.typeId {
                    updateIndex = index
                    break
                }
            } // for
            if updateIndex >= 0 {
                // 找到则更新
                var qc: ZZFileProtocol = self.qcModelList[updateIndex]
                qc.qualificationNo = model.qualificationNo
                qc.starttime = model.starttime
                qc.endtime = model.endtime
            }
        }
        else {
            // 其它企业类型...<无证件号/效期>...<当前情况不可能出现>
            var updateIndex = -1 // 待更新的model索引
            for index in 0..<self.qcRetailModelList.count {
                let obj: ZZFileProtocol = self.qcRetailModelList[index]
                if obj.typeId == model.typeId {
                    updateIndex = index
                    break
                }
            } // for
            if updateIndex >= 0 {
                // 找到则更新
                var qc: ZZFileProtocol = self.qcRetailModelList[updateIndex]
                qc.qualificationNo = model.qualificationNo
                qc.starttime = model.starttime
                qc.endtime = model.endtime
            }
        }
    }
}


// MARK: - Notification
extension QualiticationUploadController {
    // 收到通知时缓存
    @objc func appResignActive() {
        self.saveCacheData()
    }
}


// MARK: - Private
extension QualiticationUploadController {
    // 分段
    fileprivate func segmentTitleImage(withTag number: String, title: String, size: CGSize, isSelected: Bool) -> UIImage? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width-10, height: size.height))
        view.backgroundColor = .white
        
        let tag = UILabel(frame: CGRect(x: WH(18), y: WH(16), width: WH(18), height: WH(18)))
        tag.text = number
        tag.textAlignment = .center
        tag.font = UIFont.boldSystemFont(ofSize: WH(13))
        tag.textColor = .white
        tag.backgroundColor = isSelected ? RGBColor(0xff394e) : RGBColor(0xdcdcdc)
        tag.layer.cornerRadius = WH(9)
        tag.layer.masksToBounds = true
        view.addSubview(tag)
        
        let titleLabel = UILabel(frame: CGRect(x: WH(39), y: WH(15), width: WH(70), height: WH(21)))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: WH(15))
        titleLabel.textColor = isSelected ? RGBColor(0xff394e) : RGBColor(0x343434)
        view.addSubview(titleLabel)
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // 刷新CollectionView 重置dataSource ...<关键方法：首次展示、三证合一开关切换后的刷新>
    fileprivate func reloadQualitications(withView view: QualiticationCollectionView) {
        self.showLoading()
        view.dataSource = []
        
        DispatchQueue.global().async { [weak self] in
            // guard
            guard let strongSelf = self else {
                return
            }
            guard let zzModel = strongSelf.zzModel, let enterpriseTypeList = zzModel.listTypeInfo else {
                return
            }
            
            // 是否三证合一
            var is3merge1 = false // 默认为非三证合一
            if view.viewType == .undefined { // 非批零一体
                is3merge1 = (zzModel.enterprise?.is3merge1 == 1)
            }
            else if view.viewType == .wholeSale { // 批零一体之批发企业
                is3merge1 = (zzModel.enterprise?.is3merge1 == 1)
            }
            else if view.viewType == .retail { // 批零一体之零售企业
                is3merge1 = (zzModel.enterpriseRetail?.is3merge1 == 1)
            }
            // 证件类型列表...<根据接口返回的企业类型(可包含多个)来确定资质证件列表>
            view.qcTypes = strongSelf.fileHelper.fetchTypeList(view.viewType, is3merge1: is3merge1, typeList: enterpriseTypeList,roleType: (zzModel.enterprise?.roleType)!)
            
            if view.viewType == .undefined || view.viewType == .wholeSale {
                // 非批零一体 or 批零一体之批发企业
                // 换一种说法：仅一个tab（非批发企业 or  批发企业之非批零一体） or 三个tab时的第一个tab（批零一体之批发企业）
                
                //if let qcList = zzModel.qcList {
                if strongSelf.qcModelList.count > 0 {
                    // 有资质列表数据~!@
                    let qcList = strongSelf.qcModelList
                    
                    // 遍历所有证件类型model
                    for qcType in view.qcTypes {
                        if let alreadyUploadFileTypeArray = (qcList as NSArray).filtered(using: NSPredicate(format: "typeId == \(qcType.rawValue)")) as? [ZZFileModel], alreadyUploadFileTypeArray.count > 0 {
                            // 有已上传(保存)的资质model...<匹配当前资质类型>
                            
                            // 注：代码修改后，对于qcModelList，仅有当前一种情况，即qcModelList一定有值，且包含所有资质类型model~!@
                            
                            // 待赋值数据
                            var fileModels: [ZZFileModel] = [] // 证件model数组
                            var cellType: [UploadCredentialImageCell] = [] // cell数组
                            var maxIndex = alreadyUploadFileTypeArray.count // 已上传数量???...<资质model个数，不一定包含图片>
                            if alreadyUploadFileTypeArray.count > qcType.maxCount {
                                maxIndex = qcType.maxCount
                            }
                            
                            for fileModel in alreadyUploadFileTypeArray[0..<maxIndex] {
                                fileModels.append(fileModel.copy() as! ZZFileModel)
                                cellType.append(UploadCredentialImageCell.forEdit)
                            } // for
                            
                            if fileModels.count <= 1 {
                                // 单张 or 无
                                if qcType.maxCount > 1 {
                                    // 可上传多张
                                    cellType.append(UploadCredentialImageCell.forEdit)
                                }
                                else {
                                    // 仅可上传1张
                                    cellType = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                                }
                            }
                            else {
                                // 多张
                                if (fileModels.count < qcType.maxCount) {
                                    cellType.append(UploadCredentialImageCell.forEdit)
                                }
                            }
                            
                            // 判断当前类型资质文件model是否有证件号和效期可以直接赋值
                            if fileModels.count > 0 {
                                // 更新...<带证件号和效期的资质类型，仅需上传1张图片，故只会有一个资质model>
                                strongSelf.setTextContentForEnterpriseInfoFromErp(fileModels.first!, qcType)
                            }
                            
                            // 证件号和效期model
                            var textModel: ZZFileTextModel? = nil
                            if qcType.rawValue != 37 && qcType.rawValue != 35 {
                                // 有证件号和效期
                                cellType.append(UploadCredentialImageCell.forIDnumber)
                                // 初始化并赋值
                                textModel = ZZFileTextModel()
                                strongSelf.showEnterpriseInfoFromErp(textModel!, qcType)
                            }
                            else {
                                // 无证件号和效期
                            }
                            
                            view.dataSource.append((qcType.rawValue, fileModels, textModel, cellType))
                        }
                        else {
                            // 未有上传(保存)的资质model
                            
                            // 先设置为默认样式...<左边图片，右边描述>
                            var cellType: [UploadCredentialImageCell] = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                            
                            // 证件号和效期model
                            var textModel: ZZFileTextModel? = nil
                            if qcType.rawValue != 37 && qcType.rawValue != 35 {
                                // 有证件号和效期...<新增样式：下边文字输入>
                                cellType.append(UploadCredentialImageCell.forIDnumber)
                                // 初始化并赋值
                                textModel = ZZFileTextModel()
                                strongSelf.showEnterpriseInfoFromErp(textModel!, qcType)
                            }
                            else {
                                // 无证件号和效期
                            }
                            
                            view.dataSource.append((qcType.rawValue, [], textModel, cellType))
                        }
                    } // for
                }
                else {
                    // 无资质列表~!@
                    
                    // 遍历所有证件类型model
                    for qcType in view.qcTypes {
                        // 默认cell类型...<左图片，右描述>
                        var cellType: [UploadCredentialImageCell] = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                        
                        // 证件号和效期model
                        var textModel: ZZFileTextModel? = nil
                        if qcType.rawValue != 37 && qcType.rawValue != 35 {
                            // 有证件号和效期...<下方>
                            cellType.append(UploadCredentialImageCell.forIDnumber)
                            // 初始化并赋值
                            textModel = ZZFileTextModel()
                            strongSelf.showEnterpriseInfoFromErp(textModel!, qcType)
                        }
                        else {
                            // 无证件号和效期
                        }
                        
                        // 加入
                        view.dataSource.append((qcType.rawValue, [], textModel, cellType))
                    } // for
                }
            }
            else {
                // 其它企业类型...<不上传证件号和效期>
                // 换一种说法：三个tab时的第二个tab（批零一体之零售企业） or 第三个tab（批零一体之批零一体）
                
                //if let qcList: [ZZAllInOneFileModel] = zzModel.qualificationRetailList {
                if strongSelf.qcRetailModelList.count > 0 {
                    // 有资质列表数据~!@
                    let qcList = strongSelf.qcRetailModelList
                    
                    // 遍历所有证件类型model
                    for qcType in view.qcTypes {
                        if let alreadyUploadFileTypeArray = (qcList as NSArray).filtered(using: NSPredicate(format: "typeId == \(qcType.rawValue)")) as? [ZZAllInOneFileModel], alreadyUploadFileTypeArray.count > 0 {
                            // 有已上传(保存)的资质model...<匹配当前资质类型>
                            
                            // 注：代码修改后，对于qcModelList，仅有当前一种情况，即qcModelList一定有值，且包含所有资质类型model~!@
                            
                            // 待赋值数据
                            var fileModels: [ZZAllInOneFileModel] = [] // 证件model数组
                            var cellType: [UploadCredentialImageCell] = []
                            var maxIndex = alreadyUploadFileTypeArray.count
                            if alreadyUploadFileTypeArray.count > qcType.maxCount {
                                maxIndex = qcType.maxCount
                            }
                            
                            // 加入资质model
                            for fileModel in alreadyUploadFileTypeArray[0..<maxIndex] {
                                fileModels.append(fileModel.copy() as! ZZAllInOneFileModel)
                                cellType.append(UploadCredentialImageCell.forEdit)
                            }
                            
                            if fileModels.count <= 1 {
                                // 0张 or 1张
                                if qcType.maxCount > 1 {
                                    // 当前类型可传多张
                                    cellType.append(UploadCredentialImageCell.forEdit)
                                }
                                else {
                                    // 当前类型仅只能传1张...<设置为默认样式:左边图片，右边描述>
                                    cellType = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                                }
                            }
                            else {
                                // 已上传多张
                                if (fileModels.count < qcType.maxCount) {
                                    cellType.append(UploadCredentialImageCell.forEdit)
                                }
                            }
                            
                            view.dataSource.append((qcType.rawValue, fileModels, nil, cellType))
                        }
                        else {
                            // 未有上传(保存)的资质model...<设置为默认样式:左边图片，右边描述>
                            
                            let cellType: [UploadCredentialImageCell] = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                            view.dataSource.append((qcType.rawValue, [], nil, cellType))
                        }
                    } // for
                }
                else {
                    // 无资质列表~!@
                    
                    for qcType in view.qcTypes {
                        // 设置为默认样式:左边图片，右边描述
                        let cellType: [UploadCredentialImageCell] = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                        view.dataSource.append((qcType.rawValue, [], nil, cellType))
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                view.reloadData()
                strongSelf.dismissLoading()
            }
        }
    }
    
    // 将erp接口返回的相关资质的证件号/效期等文字保存在对应的资质model中
    fileprivate func setTextContentForEnterpriseInfoFromErp(_  fileModel: ZZFileModel, _ qcType: QCType) {
        guard let modelErp = self.enterpriseInfoFromErp else {
            return
        }
        // erp企业信息不为空
//        if qcType.rawValue == 23 {
//            // 营业执照
//            if let modelCer = modelErp.businessLicense {
//                // 营业执照model不为空
//                if fileModel.qualificationNo == nil, let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
//                    // 证件号
//                    fileModel.qualificationNo = qNumber
//                }
//                if fileModel.starttime == nil, let sTime = modelCer.startTime, sTime.isEmpty == false {
//                    // 开始日期
//                    fileModel.starttime = sTime
//                }
//                if fileModel.endtime == nil, let eTime = modelCer.endTime, eTime.isEmpty == false {
//                    // 截止日期
//                    fileModel.endtime = eTime
//                }
//            }
//        }
//        else if qcType.rawValue == 26 {
        if qcType.rawValue == 26 {
            // gsp
            if let modelCer = modelErp.gspCertification {
                // gsp model不为空
                if fileModel.qualificationNo == nil, let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
                    // 证件号
                    fileModel.qualificationNo = qNumber
                }
                if fileModel.starttime == nil, let sTime = modelCer.startTime, sTime.isEmpty == false {
                    // 开始日期
                    fileModel.starttime = sTime
                }
                if fileModel.endtime == nil, let eTime = modelCer.endTime, eTime.isEmpty == false {
                    // 截止日期
                    fileModel.endtime = eTime
                }
            }
        }
        else if qcType.rawValue == 27 {
            // 药品经营许可证
            if let modelCer = modelErp.businessCertification {
                // 经营许可证model不为空
                if fileModel.qualificationNo == nil, let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
                    // 证件号
                    fileModel.qualificationNo = qNumber
                }
                if fileModel.starttime == nil, let sTime = modelCer.startTime, sTime.isEmpty == false {
                    // 开始日期
                    fileModel.starttime = sTime
                }
                if fileModel.endtime == nil, let eTime = modelCer.endTime, eTime.isEmpty == false {
                    // 截止日期
                    fileModel.endtime = eTime
                }
            }
        }
    }
    
    // 创建证件号/效期的model用来保存从erp接口返回的数据...<主要用于当前类型的资质model未创建时临时保存文本内容>
    fileprivate func showEnterpriseInfoFromErp(_  textModel: ZZFileTextModel, _ qcType: QCType) {
        guard let modelErp = self.enterpriseInfoFromErp else {
            return
        }
        // erp企业信息不为空
//        if qcType.rawValue == 23 {
//            // 营业执照
//            if let modelCer = modelErp.businessLicense {
//                // 营业执照model不为空
//                if let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
//                    // 证件号
//                    textModel.qualificationNo = qNumber
//                }
//                if let sTime = modelCer.startTime, sTime.isEmpty == false {
//                    // 开始日期
//                    textModel.starttime = sTime
//                }
//                if let eTime = modelCer.endTime, eTime.isEmpty == false {
//                    // 截止日期
//                    textModel.endtime = eTime
//                }
//            }
//        }
//        else if qcType.rawValue == 26 {
        if qcType.rawValue == 26 {
            // gsp
            if let modelCer = modelErp.gspCertification {
                // gsp model不为空
                if let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
                    // 证件号
                    textModel.qualificationNo = qNumber
                }
                if let sTime = modelCer.startTime, sTime.isEmpty == false {
                    // 开始日期
                    textModel.starttime = sTime
                }
                if let eTime = modelCer.endTime, eTime.isEmpty == false {
                    // 截止日期
                    textModel.endtime = eTime
                }
            }
        }
        else if qcType.rawValue == 27 {
            // 药品经营许可证
            if let modelCer = modelErp.businessCertification {
                // 经营许可证model不为空
                if let qNumber = modelCer.qualificationNo, qNumber.isEmpty == false {
                    // 证件号
                    textModel.qualificationNo = qNumber
                }
                if let sTime = modelCer.startTime, sTime.isEmpty == false {
                    // 开始日期
                    textModel.starttime = sTime
                }
                if let eTime = modelCer.endTime, eTime.isEmpty == false {
                    // 截止日期
                    textModel.endtime = eTime
                }
            }
        }
    }
    
    // 保存
    fileprivate func toSaveFileUpdateInfo(_ view: QualiticationCollectionView, didClickSubmitStep button: UIButton) {
        // 检测内容合法性
        fileHelper.validateSubmitQualitication(withZZModel: zzModel!, currentViewType: currentQualiticationView.viewType, qviews: collectionViews) { [weak self] (errorMsg, param, ret) in
            guard let strongSelf = self else {
                return
            }
            button.isUserInteractionEnabled = true
            if ret {
                strongSelf.showLoading()
                // 保存资质
                strongSelf.credentialsBaseInfoService.sazeZZFile(param, complete: { [weak self] (result, message) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.dismissLoading()
                    strongSelf.toast(message)
                    if result {
                        FKYNavigator.shared().pop()
                    }
                })
            }
            else {
                strongSelf.toast(errorMsg)
            }
        }
    }
    
    // 查看大图
    fileprivate func showPhotoBrowser(_ image: UIImage?, url: String, superView: UIView) {
        view.endEditing(true)
        
        if url.isEmpty == true, image == nil {
            return
        }
        
        // imageview
//        let imgview = UIImageView.init(frame: CGRect.init(x: (SCREEN_WIDTH - WH(0)) / 2, y: (SCREEN_HEIGHT - WH(0)) / 2, width: WH(0), height: WH(0)))
//        imgview.contentMode = UIViewContentMode.scaleAspectFit
//        if let img: UIImage = image {
//            // 有图片
//            if img.size.width == 800, img.size.height == 800 {
//                // 默认占用图，非用户上传图...<占用图800*800>
//                imgview.sd_setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "image_default_img"))
//            }
//            else {
//                // 用户上传图片
//                imgview.image = img
//            }
//        }
//        else {
//            // 无图片
//            imgview.sd_setImage(with: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "image_default_img"))
//        }
//        // 新版查看大图
//        let imageViewer = XHImageViewer.init()
//        imageViewer.showPageControl = true
//        imageViewer.userPageNumber = true
//        imageViewer.hideWhenOnlyOne = true
//        imageViewer.showSaveBtn = true
//        imageViewer.show(withImageViews: [imgview], selectedView: imgview)
        
        /*
         说明：关于资质相关的四个查看大图功能，需要有保存与旋转图片功能。
         */
        
        // 老版查看大图...<体验不好，不再使用>
        let photo = SKPhoto.photoWithImageURL(url)
        photo.shouldCachePhotoURLImage = true
        // 弹出查看图片vc
        let browser = SKPhotoBrowser(originImage: image!, photos: [photo], animatedFromView: superView)
        browser.delegate = self
        browser.showDeleteButton = true // 增加删除图片功能
        browser.initializePageIndex(0)
        FKYNavigator.shared().topNavigationController.present(browser, animated: true, completion: nil)
    }
}


// MARK: - QualiticationCollectionViewOperation
extension QualiticationUploadController: QualiticationCollectionViewOperation {
    // 更新资质证起始日期
    func qualiticationView(_ view: QualiticationCollectionView, idStartTimeTextFieldEndEditing indexPath: IndexPath, idStartTimeText: String, textField: UITextField) {
        var tuple = currentQualiticationView.dataSource[indexPath.section-1]
        if var model = tuple.fileModels.first {
            model.starttime = idStartTimeText
            // 实时更新refresh数据
            if view.viewType == .undefined || view.viewType == .wholeSale {
                // 非批零一体 or 批零一体之批发企业
                self.updateRefreshData(model, true)
            }
            else {
                // 其它企业类型...<无证件号/效期>...<当前情况不可能出现>
                self.updateRefreshData(model, false)
            }
        }
        else {
            // 代码修改后，当前情况不会出现~!@
            if let textModel = tuple.fileText {
                textModel.starttime = idStartTimeText
            }
            else {
                let tModel = ZZFileTextModel()
                tModel.starttime = idStartTimeText
                tuple.fileText = tModel
            }
        }
    }
    
    // 更新资质证截止日期
    func qualiticationView(_ view: QualiticationCollectionView, idEndTimeTextFieldEndEditing indexPath: IndexPath, idEndTimeText: String, datePicker: UIDatePicker) {
        var tuple = currentQualiticationView.dataSource[indexPath.section-1]
        if var model = tuple.fileModels.first {
            model.endtime = idEndTimeText
            // 实时更新refresh数据
            if view.viewType == .undefined || view.viewType == .wholeSale {
                // 非批零一体 or 批零一体之批发企业
                self.updateRefreshData(model, true)
            }
            else {
                // 其它企业类型...<无证件号/效期>...<当前情况不可能出现>
                self.updateRefreshData(model, false)
            }
        }
        else {
            // 代码修改后，当前情况不会出现~!@
            if let textModel = tuple.fileText {
                textModel.endtime = idEndTimeText
            }
            else {
                let tModel = ZZFileTextModel()
                tModel.endtime = idEndTimeText
                tuple.fileText = tModel
            }
        }
    }
    
    // 更新资质证件号
    func qualiticationView(_ view: QualiticationCollectionView, idNumberTextFieldDidEndEditing indexPath: IndexPath, idNumberText: String, textField: UITextField) {
        var tuple = currentQualiticationView.dataSource[indexPath.section-1]
        if var model = tuple.fileModels.first {
            model.qualificationNo = idNumberText
            // 实时更新refresh数据
            if view.viewType == .undefined || view.viewType == .wholeSale {
                // 非批零一体 or 批零一体之批发企业
                self.updateRefreshData(model, true)
            }
            else {
                // 其它企业类型...<无证件号/效期>...<当前情况不可能出现>
                self.updateRefreshData(model, false)
            }
        }
        else {
            // 代码修改后，当前情况不会出现~!@
            if let textModel = tuple.fileText {
                textModel.qualificationNo = idNumberText
            }
            else {
                let tModel = ZZFileTextModel()
                tModel.qualificationNo = idNumberText
                tuple.fileText = tModel
            }
        }
    }
    // 三证合一开关操作回调
    func qualiticationViewWillRefetchDataSource(_ view: QualiticationCollectionView) {
        // 刷新数据源
        reloadQualitications(withView: view)
    }
    
    // 上传图片
    func qualiticationView(_ view: QualiticationCollectionView, willOpenPhotosAt indexPath: IndexPath, maxPhotoNumber: Int) {
        // 保存索引
        self.selectedImageIndex = indexPath
        // 显示上传图片弹窗
        self.view.bringSubviewToFront(imageSourceView)
        self.imageSourceView.showClosure!()
        // 设置当前图片最大上传数量
        self.imageUploadController!.maxImagesCount = maxPhotoNumber
    }
    
    // 查看上传资质大图
    func qualiticationView(_ view: QualiticationCollectionView, willSeePhotoDetailAt indexPath: IndexPath, imageView: UIImageView, image: UIImage, fileUrl: String) {
        self.selectedImageView = imageView
        self.selectedImageIndex = indexPath
        self.showPhotoBrowser(image, url: fileUrl, superView: imageView)
    }
    
    // 提交
    func qualiticationView(_ view: QualiticationCollectionView, didClickNextStep button: UIButton) {
        button.isUserInteractionEnabled = false
        guard (self.zzModel?.enterprise?.roleType) != nil else {
            return
        }
        
        // 检测内容合法性
        fileHelper.validateSubmitQualitication(withZZModel: zzModel!, currentViewType: currentQualiticationView.viewType, qviews: collectionViews) { [weak self] (errorMsg, param, ret) in
            guard let strongSelf = self else {
                return
            }
            button.isUserInteractionEnabled = true
            if ret {
                // 到下一步
                strongSelf.segment.selectedSegmentIndex = strongSelf.selectedIndex + 1
                strongSelf.selectedIndex = strongSelf.segment.selectedSegmentIndex
            } else {
                // 不满足下一步条件
                strongSelf.toast(errorMsg)
            }
        }
    }
    
    // 提交
    func qualiticationView(_ view: QualiticationCollectionView, didClickSubmitStep button: UIButton) {
        button.isUserInteractionEnabled = false
        guard (self.zzModel?.enterprise?.roleType) != nil else {
            return
        }
        
        guard controllerType != .forEdit else {
            // 编辑模式仅保存
            toSaveFileUpdateInfo(view, didClickSubmitStep: button)
            return
        }
        
        // 新增模式先保存、然后提交审核
        fileHelper.validateSubmitQualitication(withZZModel: zzModel!, currentViewType: currentQualiticationView.viewType, qviews: collectionViews) { [weak self] (errorMsg, param, ret) in
            guard let strongSelf = self else {
                return
            }
            if ret {
                // 提交内容
                strongSelf.showLoading()
                // 保存资质
                strongSelf.credentialsBaseInfoService.sazeZZFile(param, complete: { [weak self] (result, message) in
                    guard let strongSelf = self else {
                        return
                    }
                    button.isUserInteractionEnabled = true
                    if result {
                        let submitParam = ["is3merge1": strongSelf.zzModel?.enterprise?.is3merge1,
                                           "is3merge2": strongSelf.zzModel?.enterpriseRetail?.is3merge1]
                        strongSelf.credentialsBaseInfoService.submitToService(submitParam as [String : AnyObject], complete: { [weak self] (result, message) in
                            guard let strongSelf = self else {
                                return
                            }
                            if result {
                                if strongSelf.controllerType == .forRegitster {
                                    ZZModelQCListInfoPartInfo.removeQCList()
                                }
                                strongSelf.dismissLoading()
                                let vc = CredentialsCompleteViewController()
                                FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
                                return
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(message)
                        })
                    }
                    else {
                        strongSelf.dismissLoading()
                        strongSelf.toast(message)
                    }
                })
            }
            else {
                // 不满足提交条件
                button.isUserInteractionEnabled = true
                strongSelf.toast(errorMsg)
            }
        }
    }
    
    // 用户删除图片前的相关处理
    func qualiticationView(_ view: QualiticationCollectionView, _ removeFlag: Bool, _ model: ZZFileProtocol, _ qcType: Bool) {
        if removeFlag {
            // 删除
            if qcType {
                // 非批零一体 or 批零一体之批发企业
                var removeIndex = -1 // 待删除的model索引
                for index in 0..<self.qcModelList.count {
                    let obj: ZZFileProtocol = self.qcModelList[index]
                    if obj.typeId == model.typeId, obj.filePath == model.filePath, obj.fileName == model.fileName {
                        removeIndex = index
                        break
                    }
                } // for
                if removeIndex >= 0 {
                    // 找到则直接删除
//                    self.qcModelList.remove(at: removeIndex)
                    
                    if let fileType = QCType(rawValue: model.typeId), fileType.maxCount == 1 {
                        // 非其它资质...<仅可传1张>...<不删除，只更新>
                        var qc: ZZFileProtocol = self.qcModelList[removeIndex]
                        qc.filePath = nil
                        qc.fileName = nil
                    }
                    else {
                        // 其它资质...<可传多张>...<直接删除>
                        self.qcModelList.remove(at: removeIndex)
                    }
                }
            }
            else {
                // 批零一体之零售企业 & 批零一体之批零一体
                var removeIndex = -1 // 待删除的model索引
                for index in 0..<self.qcRetailModelList.count {
                    let obj: ZZFileProtocol = self.qcRetailModelList[index]
                    if obj.typeId == model.typeId, obj.filePath == model.filePath, obj.fileName == model.fileName {
                        removeIndex = index
                        break
                    }
                } // for
                if removeIndex >= 0 {
                    // 找到则直接删除
//                    self.qcRetailModelList.remove(at: removeIndex)
                    
                    if let fileType = QCType(rawValue: model.typeId), fileType.maxCount == 1 {
                        // 非其它资质...<仅可传1张>...<不删除，只更新>
                        var qc: ZZFileProtocol = self.qcRetailModelList[removeIndex]
                        qc.filePath = nil
                        qc.fileName = nil
                    }
                    else {
                        // 其它资质...<可传多张>...<直接删除>
                        self.qcRetailModelList.remove(at: removeIndex)
                    }
                }
            }
        }
        else {
            // 更新
            if qcType {
                // 非批零一体 or 批零一体之批发企业
                var updateIndex = -1 // 待更新的model索引
                for index in 0..<self.qcModelList.count {
                    let obj: ZZFileProtocol = self.qcModelList[index]
                    if obj.typeId == model.typeId, obj.filePath == model.filePath, obj.fileName == model.fileName {
                        updateIndex = index
                        break
                    }
                } // for
                if updateIndex >= 0 {
                    // 找到则更新...<删除图片相关字段值>
                    var qc: ZZFileProtocol = self.qcModelList[updateIndex]
                    qc.filePath = nil
                    qc.fileName = nil
                }
            }
            else {
                // 批零一体之零售企业 & 批零一体之批零一体
                var updateIndex = -1 // 待更新的model索引
                for index in 0..<self.qcRetailModelList.count {
                    let obj: ZZFileProtocol = self.qcRetailModelList[index]
                    if obj.typeId == model.typeId, obj.filePath == model.filePath, obj.fileName == model.fileName {
                        updateIndex = index
                        break
                    }
                } // for
                if updateIndex >= 0 {
                    // 找到则更新...<删除图片相关字段值>
                    var qc: ZZFileProtocol = self.qcRetailModelList[updateIndex]
                    qc.filePath = nil
                    qc.fileName = nil
                } //
            } //
        } //
    }
}


// MARK: - UIScrollViewDelegate
extension QualiticationUploadController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / self.view.bounds.size.width
        segment.setSelectedSegmentIndex(UInt(index), animated: true)
        selectedIndex = Int(index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}


// MARK: - SKPhotoBrowserDelegate <当前查看大图控件因检验不佳故不再使用>
extension QualiticationUploadController: SKPhotoBrowserDelegate {
    //
    func didDismissAtPageIndex(_ index: Int) {
        self.currentQualiticationView.reloadData()
    }

    // 删除已上传图片...<查看大图时删除图片>
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        guard let selectedIndex = self.selectedImageIndex else {
            reload()
            return
        }
        guard currentQualiticationView.dataSource.count > selectedIndex.section-1 else {
            reload()
            return
        }

        // 数据源
        var tuple = currentQualiticationView.dataSource[selectedIndex.section-1]
        // 删除逻辑
        if tuple.fileModels.count > selectedIndex.row {
            if tuple.cellTypes.contains(UploadCredentialImageCell.forIDnumber) {
                // refresh
                let obj: ZZFileProtocol = tuple.fileModels[selectedIndex.row]
                // 更新数据源...<一定是 非批零一体 or 批零一体之批发企业>
                self.qualiticationView(currentQualiticationView, false, obj, true)

                // 有证件号和效期的model...<未删除整个model，仅对model中的两个值置空>
                tuple.fileModels[selectedIndex.row].fileName = nil
                tuple.fileModels[selectedIndex.row].filePath = nil
            }
            else {
                // refresh
                let obj: ZZFileProtocol = tuple.fileModels[selectedIndex.row]
                if currentQualiticationView.viewType == .wholeSale || currentQualiticationView.viewType == .undefined {
                    // 非批零一体 or 批零一体之批发企业
                    self.qualiticationView(currentQualiticationView, true, obj, true)
                }
                else {
                    // 其它企业类型
                    self.qualiticationView(currentQualiticationView, true, obj, false)
                }

                // 直接删除掉当前索引处的model
                tuple.fileModels.remove(at: selectedIndex.row)
                tuple.cellTypes.remove(at: selectedIndex.row)
                // 仅针对直接删除的逻辑
                if tuple.fileModels.count <= 1, let fileType = QCType(rawValue: tuple.fileType) {
                    // 0张 or 1张
                    if fileType.maxCount > 1 {
                        // 当前类型可上传多张
                        if tuple.fileModels.count == 0 {
                            tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                        }
                    }
                    else {
                        // 当前类型仅可上传1张
                        tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                    }
                }
                else {
                    // 多张
                    if tuple.cellTypes.count == tuple.fileModels.count {
                        // 再加一个
                        tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                    }
                }
            }
            // 更新
            currentQualiticationView.dataSource[selectedIndex.section-1] = tuple
            // 刷新
            currentQualiticationView.reloadData()
        }

        reload()
    }

    //
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return self.selectedImageView
    }
}
