//
//  QualiticationCollectionView
//  FKY
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//  上传资质之资质图片列表视图...<不再使用>

import UIKit
import MJRefresh


typealias commonClosure = (_ isSelected : Bool)->()

// 编辑状态, 查看状态
enum ControllerUseType : Int {
    case forRegitster
    case forEdit
}

/// 资质列表类型
///
/// - undefined: -1 非批零一体
/// - wholeSale: 0 批零一体之批发企业
/// - retail: 1 批零一体之零售企业
/// - wholeSaleAndRetail: 2 批零一体之批零一体
enum QualiticationViewType: Int {
    case undefined = -1
    case wholeSale = 0
    case retail = 1
    case wholeSaleAndRetail = 2
}

protocol QualiticationCollectionViewOperation {
    func qualiticationViewWillRefetchDataSource(_ view: QualiticationCollectionView)
    func qualiticationView(_ view: QualiticationCollectionView, willOpenPhotosAt indexPath: IndexPath, maxPhotoNumber: Int)
    func qualiticationView(_ view: QualiticationCollectionView, willSeePhotoDetailAt indexPath: IndexPath, imageView: UIImageView, image: UIImage, fileUrl: String)
    func qualiticationView(_ view: QualiticationCollectionView, didClickNextStep button: UIButton)
    func qualiticationView(_ view: QualiticationCollectionView, didClickSubmitStep button: UIButton)
    func qualiticationView(_ view: QualiticationCollectionView, idNumberTextFieldDidEndEditing indexPath: IndexPath, idNumberText: String, textField: UITextField)
    func qualiticationView(_ view: QualiticationCollectionView, idStartTimeTextFieldEndEditing indexPath: IndexPath, idStartTimeText: String, textField: UITextField)
    func qualiticationView(_ view: QualiticationCollectionView, idEndTimeTextFieldEndEditing indexPath: IndexPath, idEndTimeText: String, datePicker: UIDatePicker)
    func qualiticationView(_ view: QualiticationCollectionView, _ removeFlag: Bool, _ model: ZZFileProtocol, _ qcType: Bool)
}


class QualiticationCollectionView: UIView {
    // MARK: - properties
    //var dataSource: [ (fileType: Int, fileModels: [ZZFileProtocol], cellTypes: [UploadCredentialImageCell]) ] = []
    var dataSource: [ (fileType: Int, fileModels: [ZZFileProtocol], fileText: ZZFileTextModel?, cellTypes: [UploadCredentialImageCell]) ] = []
    var controllerType : ControllerUseType = .forRegitster
    var zzModel: ZZModel?
    var operation: QualiticationCollectionViewOperation?
    var viewType: QualiticationViewType = .undefined
    var qcTypes: [QCType] = [QCType]()
    var viewTost: ((_ msg:String)->())?//弹出toast
    fileprivate lazy var footerButton: UIButton = {
        let button = UIButton()
        if self.viewType == .wholeSale || self.viewType == .retail {
            button.setTitle("下一步", for: .normal)
        } else {
            button.setTitle(self.controllerType == .forEdit ? "保存" : "提交审核", for: .normal)
        }
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = RGBColor(0xff394e)
        button.layer.cornerRadius = WH(22)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.viewType == .wholeSale || strongSelf.viewType == .retail {
                strongSelf.operation?.qualiticationView(strongSelf, didClickNextStep: button)
            } else {
                strongSelf.operation?.qualiticationView(strongSelf, didClickSubmitStep: button)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.register(FKYQualiticatioSwitchCell.self, forCellWithReuseIdentifier: "FKYQualiticatioSwitchCell")
        view.register(FKYQualiticationEditImageCell.self, forCellWithReuseIdentifier: "FKYQualiticationEditImageCell")
        view.register(FKYQualiticationEditImageDesCell.self, forCellWithReuseIdentifier: "FKYQualiticationEditImageDesCell")
        view.register(FKYQualiticationEditIDnumberCell.self, forCellWithReuseIdentifier: "FKYQualiticationEditIDnumberCell")
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DefaultCollectionViewFooter")
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultCollectionViewHeader")
        view.backgroundColor = bg8
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - public
extension QualiticationCollectionView {
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - delegates
extension QualiticationCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {//三证合一
            return viewType == .wholeSaleAndRetail ? 0 : 1
        } else {
            return dataSource[section-1].cellTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:  //三证一体 item
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualiticatioSwitchCell", for: indexPath) as! FKYQualiticatioSwitchCell
            // 三证合一开关操作
            cell.isSelectedStatus = { [weak self, weak collectionView] (selected) in
                guard let strongSelf = self else {
                    return
                }
                
                /// - undefined: -1 非批零一体
                /// - wholeSale: 0 批零一体批发企业
                /// - retail: 1 批零一体零售企业
                /// - wholeSaleAndRetail: 2 批零一体批零一体
                if strongSelf.viewType == .undefined || strongSelf.viewType == .wholeSale {
                    strongSelf.zzModel?.enterprise?.is3merge1 = selected ? 1 : 0
                } else if strongSelf.viewType == .retail {
                    strongSelf.zzModel?.enterpriseRetail?.is3merge1 = selected ? 1 : 0
                }
                
                // 更新数据源
                strongSelf.operation?.qualiticationViewWillRefetchDataSource(strongSelf)
                
                // 刷新
                if let strongCollectionView = collectionView {
                    strongCollectionView.reloadData()
                }
            }
            // 配置
            if viewType == .undefined || viewType == .wholeSale {
                cell.configCell(zzModel?.enterprise?.is3merge1 == 1)
            } else if viewType == .retail {
                cell.configCell(zzModel?.enterpriseRetail?.is3merge1 == 1)
            }
            return cell
        case 1...dataSource.count: //上传图片item
            // 数据源
            let tuple = dataSource[indexPath.section-1]
            // cell类型
            let cellType = tuple.cellTypes[indexPath.row]
            //
            switch cellType {
            case .forDesc: // 查看
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualiticationEditImageDesCell", for: indexPath) as! FKYQualiticationEditImageDesCell
                cell.configCell(title: self.handlerUploadImageTips(tuple.fileType,viewType))
                return cell
            case .forEdit: // 编辑
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualiticationEditImageCell", for: indexPath) as! FKYQualiticationEditImageCell
                
                // 图片model数组
                let fileModels = dataSource[indexPath.section-1].fileModels
                
                // 当前索引处的图片moel
                var fileModel: ZZFileProtocol? = nil
                if indexPath.row < fileModels.count {
                    fileModel = fileModels[indexPath.row]
                }
                // 配置cell
                if let obj = fileModel, obj.typeId != 0 {
                    cell.configCell(imageUrl: obj.filePath)
                }
                else {
                    cell.resetCell()
                }
                
                // 当前已上传图片数量
                var uploadNumber = 0
                for i in 0..<fileModels.count {
                    let item: ZZFileProtocol? = fileModels[i] // 账号类型不同，返回的数据model类型也不同
                    if let obj = item, let fileName: String = obj.fileName, fileName.isEmpty == false, let filePath: String = obj.filePath, filePath.isEmpty == false {
                        uploadNumber += 1
                    }
                    else {
                        // 图片相关属性为空，表示当前图片已被删除
                    }
                }
                
                // 可上传图片数量
                var canUploadCount = 1
                if let fileType = QCType(rawValue: tuple.fileType) {
                    canUploadCount = fileType.maxCount - uploadNumber
                }
                if canUploadCount < 0 {
                    canUploadCount = 0
                }
                print("当前可上传图片个数：" + "\(canUploadCount)")
                
                // 上传
                cell.addImageClosure = { [weak self, weak collectionView] in
                    guard let strongSelf = self else {
                        return
                    }
                    guard let strongCollectionView = collectionView else {
                        return
                    }
                    strongCollectionView.endEditing(true)
                    strongSelf.operation?.qualiticationView(strongSelf, willOpenPhotosAt: indexPath, maxPhotoNumber: canUploadCount)
                }
                
                // 删除
                cell.deleteImageClosure = { [weak self, weak collectionView] in
                    guard let strongSelf = self else {
                        return
                    }
                    guard let strongCollectionView = collectionView else {
                        return
                    }
                    guard strongSelf.dataSource.count > indexPath.section-1 else {
                        return
                    }
                    // 元组
                    var tuple = strongSelf.dataSource[indexPath.section-1]
                    // 逻辑处理
                    if tuple.cellTypes.contains(UploadCredentialImageCell.forIDnumber) {
                        // 有证件号/效期...<一定是 非批零一体 or 批零一体之批发企业>
                        
                        guard tuple.fileModels.count > indexPath.row else {
                            return
                        }
                        
                        // refresh
                        let obj: ZZFileProtocol = tuple.fileModels[indexPath.row]
                        // 更新数据源...<一定是 非批零一体 or 批零一体之批发企业>
                        strongSelf.operation?.qualiticationView(strongSelf, false, obj, true)
                        
                        // 有证件号和效期的model（一定为非其它资质，且仅能上传一张图片）...<未删除整个model，仅对model中的两个值置空>
                        tuple.fileModels[indexPath.row].fileName = nil
                        tuple.fileModels[indexPath.row].filePath = nil
                    }
                    else {
                        // 无证件号/效期
                        
                        guard tuple.fileModels.count > indexPath.row else {
                            return
                        }
                        
                        // refresh
                        let obj: ZZFileProtocol = tuple.fileModels[indexPath.row]
                        if strongSelf.viewType == .wholeSale || strongSelf.viewType == .undefined {
                            // 非批零一体 or 批零一体之批发企业
                            strongSelf.operation?.qualiticationView(strongSelf, true, obj, true)
                        }
                        else {
                            // 其它企业类型
                            strongSelf.operation?.qualiticationView(strongSelf, true, obj, false)
                        }
                        
                        // 无证件号和效期的model...<直接删除掉当前索引处的model>
                        tuple.fileModels.remove(at: indexPath.row)
                        tuple.cellTypes.remove(at: indexPath.row)
                        
                        // 直接删除后的逻辑
                        if let fileType = QCType(rawValue: tuple.fileType) {
                            if tuple.fileModels.count <= 1 {
                                // 0 or 1张
                                if fileType.maxCount > 1 {
                                    // 当前资质类型一定是可以上传多张的
                                    if tuple.fileModels.count == 0 {
                                        tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
                                    }
                                }
                                else {
                                    // 当前资质类型一定是仅可以上传1张的
                                    tuple.cellTypes = [UploadCredentialImageCell.forEdit, UploadCredentialImageCell.forDesc]
//                                    let isMustUpload: Bool = ZZUploadHelpFile().isMustUploadFile(fileType.rawValue, roleType: self.zzModel!.enterprise?.roleType)
//                                    if isMustUpload && (self.viewType == .wholeSale || self.viewType == .undefined) {
//                                        tuple.cellTypes.append(UploadCredentialImageCell.forIDnumber)
//                                    }
                                }
                            }
                            else {
                                // 大于1，故当前资质类型一定是可以上传多张的
                                if tuple.cellTypes.count == tuple.fileModels.count, fileType.maxCount > tuple.cellTypes.count {
                                    // 删除后应该是有重新上传的入口
                                    tuple.cellTypes.append(UploadCredentialImageCell.forEdit)
                                }
                            }
                        }
                    }
                    // 刷新
                    strongSelf.dataSource[indexPath.section-1] = tuple
                    strongCollectionView.reloadData()
                }
                
                // 查看大图
                cell.viewLargerImageClosure = { [weak self] (image, imageView) in
                    guard let strongSelf = self else {
                        return
                    }
                    guard let obj = fileModel, let filePath = obj.filePath, filePath.isEmpty == false else {
                        return
                    }
                    strongSelf.operation?.qualiticationView(strongSelf, willSeePhotoDetailAt: indexPath, imageView: imageView, image: image, fileUrl: filePath)
                }
                
                //
                return cell
            case .forIDnumber: // 证件号和效期
                if (self.viewType == .undefined || self.viewType == .wholeSale) {
                    // 非批零一体 or 批零一体之批发企业
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYQualiticationEditIDnumberCell", for: indexPath) as! FKYQualiticationEditIDnumberCell
                    // 配置内容
                    var qNumber: String? = nil  // 证件号
                    var sTime: String? = nil    // 起始日期
                    var eTime: String? = nil    // 截止日期
                    if tuple.fileModels.count >= 1 {
                        // 有model
                        if let fModel: ZZFileProtocol = tuple.fileModels.first {
                            if let qNo = fModel.qualificationNo, qNo.isEmpty == false {
                                qNumber = qNo
                            }
                            if let sT = fModel.starttime, sT.isEmpty == false {
                                sTime = sT
                            }
                            if let eT = fModel.endtime, eT.isEmpty == false {
                                eTime = eT
                            }
                        }
                    }
                    else {
                        // 无model
                        if let textModel: ZZFileTextModel = tuple.fileText {
                            // 文本model不为空
                            if let qNo = textModel.qualificationNo, qNo.isEmpty == false {
                                qNumber = qNo
                            }
                            if let sT = textModel.starttime, sT.isEmpty == false {
                                sTime = sT
                            }
                            if let eT = textModel.endtime, eT.isEmpty == false {
                                eTime = eT
                            }
                        }
                    }
                    cell.showToast = { msg in
                        if let block = self.viewTost{
                            block(msg)
                        }
                    }
                    cell.configCell(idNumberStr: qNumber, startTime: sTime, endTime: eTime)
//                    cell.configCell(idNumberStr: tuple.fileModels.first?.qualificationNo, startTime: tuple.fileModels.first?.starttime, endTime: tuple.fileModels.first?.endtime)
                    // 配置标题
                    cell.configCell(idNumberLabelText: addMustTitle(tuple.fileType, str: "证件号"))
                    cell.configCell(idTimeLabelText: addMustTitle(tuple.fileType, str: "证件效期"))
                    // 证件号
                    cell.idNumberTextFieldEndEditing = { [weak self] (idNumberText , textField) in
                        if let strongSelf = self {
                            strongSelf.operation?.qualiticationView(strongSelf, idNumberTextFieldDidEndEditing: indexPath, idNumberText: idNumberText, textField: textField)
                        }
                    }
                    // 起始日期
                    cell.idStartTimeTextFieldEndEditing = { [weak self] (idStartTimeText , textField) in
                        if let strongSelf = self {
                            strongSelf.operation?.qualiticationView(strongSelf, idStartTimeTextFieldEndEditing: indexPath, idStartTimeText: idStartTimeText, textField: textField)
                        }
                    }
                    // 截止日期
                    cell.idEndTimeTextFieldEndEditing = { [weak self] (idEndTimeText , datePicker) in
                        if let strongSelf = self {
                            strongSelf.operation?.qualiticationView(strongSelf, idEndTimeTextFieldEndEditing: indexPath, idEndTimeText: idEndTimeText, datePicker: datePicker)
                        }
                    }
                    return cell
                } else {
                    // 其它企业类型
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                    return cell
                }
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if self.zzModel == nil && self.zzModel!.enterpriseTypeList == nil {
            return UICollectionReusableView()
        }
        if kind ==  UICollectionView.elementKindSectionHeader{ //最上面的灰色header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultCollectionViewHeader", for: indexPath)
            header.backgroundColor = bg8
            return header
        } else { //下面的按钮
            if indexPath.section == dataSource.count {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DefaultCollectionViewFooter", for: indexPath)
                view.backgroundColor = bg8
                view.addSubview(footerButton)
                footerButton.snp.makeConstraints({ (make) in
                    make.center.equalTo(view)
                    make.size.equalTo(CGSize(width: WH(343), height: WH(44)))
                })
                return view
            }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DefaultCollectionViewFooter", for: indexPath)
            view.backgroundColor = bg8
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(h17))
        case 1...dataSource.count:
            let cellType = dataSource[indexPath.section-1].cellTypes[indexPath.row]
            switch cellType {
            case .forDesc:
                return CGSize(width: (SCREEN_WIDTH-WH(80+16+16)), height: WH(100))
            case .forEdit:
                if (indexPath.row%2 == 0) {//左
                    return CGSize(width: WH(80+16+16), height: WH(100))
                }else{//右
                    return CGSize(width: (SCREEN_WIDTH-WH(80+16+16)), height: WH(100))
                }
            case .forIDnumber:
                if (self.viewType == .wholeSale || self.viewType == .undefined){
                    return CGSize (width: SCREEN_WIDTH, height: 90);
                }else{
                    return CGSize.zero
                }
            }
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: SCREEN_WIDTH, height: WH(10))
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case dataSource.count:
            return CGSize(width: SCREEN_WIDTH, height: WH(88))
        default:
            return CGSize.zero
        }
    }
}

// MARK: - action
extension QualiticationCollectionView {
    //
}

extension QualiticationCollectionView {
    fileprivate func addMustTitle(_ fileType: Int, str : NSString?) -> NSMutableAttributedString {
        let isMustUpload: Bool = ZZUploadHelpFile().isMustUploadFile(fileType, roleType: 3,drugScopeList:self.zzModel?.drugScopeList)
       // if fileType == 32 || fileType == 33 || fileType == 38 || fileType == 45 || fileType == 41 || fileType == 42 || fileType == 44 || !isMustUpload{
            // 二 三类医疗器械经营许可证，食品流通许可证， 采购委托书，开票资料，身份证、质保协议、这四个证件号和效期是非必填的
            let allImageDes = "\(str!)"
            let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
            return mutabelAttribute
//        }else {
//            let allImageDes = "*\(str!)"
//            let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.paragraphSpacingBefore = 10
//            paragraphStyle.alignment = .left
//            mutabelAttribute.setAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
//
//            mutabelAttribute.setAttributes([NSForegroundColorAttributeName: RGBColor(0xFF394E),NSFontAttributeName: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
//            mutabelAttribute.setAttributes([NSForegroundColorAttributeName: RGBColor(0x161616),NSFontAttributeName: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: str! as String))
//            return mutabelAttribute
//        }
    }
}

// MARK: - private methods
extension QualiticationCollectionView {
    fileprivate func handlerUploadImageTips(_ fileType: Int,_ viewType: QualiticationViewType) -> NSAttributedString {
        let isMustUpload: Bool = ZZUploadHelpFile().isMustUploadFile(fileType, roleType: self.zzModel?.enterprise?.roleType,drugScopeList:self.zzModel?.drugScopeList)
        if let fileTypeTitle = ZZUploadHelpFile().sectionTitle(fileType) {
            if self.controllerType == .forRegitster {
                if isMustUpload {
                    var uploadTip = "请上传正面、清晰的图像文件"
                    var allImageDes = "*\(fileTypeTitle)\n\(uploadTip)"
                    if fileType == 42{
                        uploadTip = "身份证正反面复印在一张A4纸上，盖店铺公章"
                        allImageDes = "*\(fileTypeTitle)\n(\(uploadTip))"
                    }
                    let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.paragraphSpacingBefore = 10
                    paragraphStyle.alignment = .left
                    mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                    
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x161616),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                    if fileType == 42{
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFE5050),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                    }
                    else {
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                    }
                    
                    return NSAttributedString(attributedString: mutabelAttribute)
                }
                else {
                    var uploadTip = "请上传正面、清晰的图像文件"
                    var allImageDes = "\(fileTypeTitle)\n\(uploadTip)"
                    if fileType == 42{
                        uploadTip = "身份证正反面复印在一张A4纸上，盖店铺公章"
                        allImageDes = "\(fileTypeTitle)\n(\(uploadTip))"
                    }
                    let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.paragraphSpacingBefore = 10
                    paragraphStyle.alignment = .left
                    mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                    
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x161616),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                    if fileType == 42 {
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFE5050),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                    }
                    else {
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                    }
                    
                    return NSAttributedString(attributedString: mutabelAttribute)
                }
            }
            else {
                if let errorContent = self.zzModel?.refuseReasonForSectionCellType(ZZEnterpriseInputType.ZZfile, zztype: fileType,viewType == .wholeSale ? 0 : 1), errorContent != "" {
                    
                    var allImageDes = "\(fileTypeTitle)\n\(errorContent)"
                    
                    if isMustUpload {
                        allImageDes = "*\(fileTypeTitle)\n\(errorContent)"
                    }
                    
                    let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.paragraphSpacing = 10
                    paragraphStyle.alignment = .left
                    mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                    
                    if isMustUpload {
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
                    }
                    
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x343434),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                    mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E ),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: errorContent))
                    return NSAttributedString(attributedString: mutabelAttribute)
                }
                else {
                    if isMustUpload {
                        var uploadTip = "请上传正面、清晰的图像文件"
                        var allImageDes = "*\(fileTypeTitle)\n\(uploadTip)"
                        if fileType == 42{
                            uploadTip = "身份证正反面复印在一张A4纸上，盖店铺公章"
                            allImageDes = "*\(fileTypeTitle)\n(\(uploadTip))"
                        }
                        let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.paragraphSpacingBefore = 10
                        paragraphStyle.alignment = .left
                        mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                        
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x161616),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                        if fileType == 42 {
                            mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFE5050),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                        }
                        else {
                            mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                        }
                        return NSAttributedString(attributedString: mutabelAttribute)
                    }
                    else {
                        var uploadTip = "请上传正面、清晰的图像文件"
                        var allImageDes = "\(fileTypeTitle)\n\(uploadTip)"
                        if fileType == 42{
                            uploadTip = "身份证正反面复印在一张A4纸上，盖店铺公章"
                            allImageDes = "\(fileTypeTitle)\n(\(uploadTip))"
                        }
                       
                        let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.paragraphSpacingBefore = 10
                        paragraphStyle.alignment = .left
                        mutabelAttribute.setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
                        
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFF394E),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
                        mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x161616),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: fileTypeTitle))
                        if fileType == 42 {
                            mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0xFE5050),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                        }
                        else {
                            mutabelAttribute.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: (allImageDes as NSString).range(of: uploadTip))
                        }
                        return NSAttributedString(attributedString: mutabelAttribute)
                    }
                }
            }
        }
        return NSAttributedString(string: "")
    }
}
