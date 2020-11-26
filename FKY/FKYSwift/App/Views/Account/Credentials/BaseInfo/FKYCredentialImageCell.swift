//
//  FKYQualiticationImageCell.swift
//  FKY
//
//  Created by airWen on 2017/7/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

//MARK: Class FKYQualiticationImageCell
class FKYQualiticationImageCell: UICollectionViewCell {
    // 必填项有证件号和有效期
    var isMust : Bool = false
    
    fileprivate lazy var btnImgCotent : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(3)
        return button
    }()
    
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    //资质文件过期文描
    fileprivate lazy var imgExpiredDesc: UILabel = {
           let label = UILabel()
           label.textColor = RGBColor(0xFF2859)
           label.font = UIFont.systemFont(ofSize: WH(12))
           label.numberOfLines = 0
           label.lineBreakMode = .byCharWrapping
           return label
       }()
    
    var viewLargerImageClosure : ((_ image: UIImage, _ superView: UIImageView)->())?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        btnImgCotent.addTarget(self, action: #selector(onBtnImgCotent(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnImgCotent)
        btnImgCotent.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(WH(90))
            make.height.equalTo(WH(60))
            make.leading.equalTo(contentView.snp.leading).offset(WH(15))
        })
        
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(btnImgCotent.snp.top)
            make.trailing.equalTo(contentView.snp.trailing).offset(-WH(12))
            make.left.equalTo(btnImgCotent.snp.right).offset(WH(15))
        })
        
        self.contentView.addSubview(imgExpiredDesc)
        imgExpiredDesc.snp.makeConstraints({ (make) in
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(5))
            make.trailing.equalTo(contentView.snp.trailing).offset(-WH(12))
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-2)
            make.left.equalTo(btnImgCotent.snp.right).offset(WH(15))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: Public Method
    func configCell(imageUrl: String?, title: NSAttributedString?,_ exprireTips:String?) {
        btnImgCotent.setImage(nil, for: UIControl.State())
        if let imageUrl = imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), imageUrl != "" {
            let smallImageUrl = imageUrl.smallImageUrlString()
            btnImgCotent.sd_setImage(with: URL.init(string: smallImageUrl), for: UIControl.State(), placeholderImage: UIImage.init(named: "image_placeholder"))
        }else{
            btnImgCotent.setImage(UIImage(named: "image_placeholder"), for: UIControl.State())
        }
        
        lblTitle.attributedText = title
        imgExpiredDesc.text = exprireTips ?? ""
    }
    
    //MARK: User Action
    @objc func onBtnImgCotent(_ sender: UIButton) {
        if let imageOfUpload = sender.image(for: UIControl.State()) {
            if let viewLargerImageClosure = self.viewLargerImageClosure, let imageView = sender.imageView {
                viewLargerImageClosure(imageOfUpload, imageView)
            }
        }
    }
}

// 编辑状态, 查看状态
enum UploadCredentialImageCell : Int {
    case forEdit
    case forDesc
    case forIDnumber // 证件号和效期
}

//MARK: Class FKYQualiticationEditImageCell
class FKYQualiticationEditImageCell: UICollectionViewCell {
    
    //MARK: Private Proeprty
    fileprivate lazy var btnAddImage: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.setBackgroundImage( UIImage(named: "icon_add_image"), for: UIControl.State())
        return button
    }()
    
    fileprivate lazy var btnDeleteImage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage( UIImage(named: "icon_delete26x26"), for: UIControl.State())
        button.isHidden = true;
        return button
    }()
    
    //MARK: Public Proeprty
    var addImageClosure : emptyClosure?
    var viewLargerImageClosure : ((_ image: UIImage, _ superView: UIImageView)->())?
    var deleteImageClosure : emptyClosure?
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        btnAddImage.addTarget(self, action: #selector(onBtnAddImage(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnAddImage)
        btnAddImage.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(WH(80))
            make.height.equalTo(WH(80))
            make.leading.equalTo(contentView.snp.leading).offset(WH(19))
        })
        
        btnDeleteImage.addTarget(self, action: #selector(onBtnDeleteImage(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnDeleteImage)
        btnDeleteImage.snp.makeConstraints({ (make) in
            make.right.equalTo(self.btnAddImage.snp.right).offset(WH(5))
            make.top.equalTo(self.btnAddImage.snp.top).offset(WH(-5))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(imageUrl: String?) {
        self.btnAddImage.setImage(nil, for: UIControl.State())
        if let imageUrl = imageUrl, imageUrl != "" {
            let smallImageUrl = imageUrl.smallImageUrlString()
            btnAddImage.sd_setImage(with: URL(string: smallImageUrl), for: UIControl.State(), placeholderImage: UIImage(named: "image_placeholder"))
            btnDeleteImage.isHidden = false
        }else{
            btnDeleteImage.isHidden = true
        }
    }
    
    // 无数据时重置
    func resetCell() {
        self.btnAddImage.setImage(nil, for: UIControl.State())
        btnDeleteImage.isHidden = true
    }
    
    //MARK: User Action
    @objc func onBtnAddImage(_ sender: UIButton) {
        if let imageOfUpload = sender.image(for: UIControl.State()) {
            if let viewLargerImageClosure = self.viewLargerImageClosure, let imageView = sender.imageView {
                viewLargerImageClosure(imageOfUpload, imageView)
            }
        }else{
            if let addImageClosure = self.addImageClosure {
                addImageClosure()
            }
        }
    }
    
    @objc func onBtnDeleteImage(_ sender: UIButton) {
        if let deleteImageClosure = self.deleteImageClosure {
            deleteImageClosure()
        }
    }
}

//MARK: Class FKYQualiticationEditImageDesCell
class FKYQualiticationEditImageDesCell: UICollectionViewCell {
    //MARK: Private Proeprty
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-WH(16))
            make.top.greaterThanOrEqualTo(contentView.snp.top).offset(2)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-2)
            make.leading.equalTo(contentView.snp.leading).offset(WH(16))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(title: NSAttributedString?) {
        lblTitle.attributedText = title
    }
}


// 证件号和效期cell
class FKYQualiticationEditIDnumberCell: UICollectionViewCell , UITextFieldDelegate {
    fileprivate lazy var idNumberLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x161616)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
//        label.attributedText = self.addMustTitle(str: "证件号")
        return label
    }()
    
    fileprivate lazy var idTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x161616)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
//        label.attributedText = self.addMustTitle(str: "证件效期")
        return label
    }()
    
    fileprivate lazy var idNumberTextField : UITextField = {
        let textField = UITextField()
        let holderStr = "请填写证件的证件号"
        let placeholderAtt = NSMutableAttributedString(string: holderStr)
        placeholderAtt.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: NSMakeRange(0, (holderStr as NSString).length))
        textField.attributedPlaceholder = placeholderAtt
        textField.textColor = RGBColor(0x161616)
        textField.font = UIFont.systemFont(ofSize: WH(15))
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldViewDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var startTimeDatePickView : UIDatePicker = {
        let datePick = UIDatePicker()
        datePick.datePickerMode = .date
        datePick.setDate(Date(), animated: true)
        datePick.addTarget(self, action: #selector(onStartTimeDatePickChange(_:)), for: .valueChanged)
        
        return datePick
    }()
    
    fileprivate lazy var endTimeDatePickView : UIDatePicker = {
        let datePick = UIDatePicker()
        datePick.datePickerMode = .date
        datePick.setDate(Date(), animated: true)
        datePick.addTarget(self, action: #selector(onEndTimeDatePickChange(_:)), for: .valueChanged)
        
        return datePick
    }()
    
    fileprivate lazy var idStartTimeTextField : UITextField = {
        let textField = UITextField()
        let holderStr = "请选择起始日期"
        let placeholderAtt = NSMutableAttributedString(string: holderStr)
        placeholderAtt.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: NSMakeRange(0, (holderStr as NSString).length))
        textField.attributedPlaceholder = placeholderAtt
        textField.delegate = self
        textField.inputView = self.startTimeDatePickView
        textField.textColor = RGBColor(0x161616)
        textField.font = UIFont.systemFont(ofSize: WH(14))
        return textField
    }()
    
    fileprivate lazy var idEndTimeTextField : UITextField = {
        let textField = UITextField()
        let holderStr = "请选择截止日期"
        let placeholderAtt = NSMutableAttributedString(string: holderStr)
        placeholderAtt.setAttributes([NSAttributedString.Key.foregroundColor: RGBColor(0x9A9A9A),NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(14))], range: NSMakeRange(0, (holderStr as NSString).length))
        textField.attributedPlaceholder = placeholderAtt
        textField.delegate = self
        textField.inputView = self.endTimeDatePickView
        textField.textColor = RGBColor(0x161616)
        textField.font = UIFont.systemFont(ofSize: WH(14))
        return textField
    }()
    
    fileprivate lazy var idNumberLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    fileprivate lazy var idStartTimeLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    fileprivate lazy var idEndTimeLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var idNumberTextFieldEndEditing : ((_ idNumberText: String, _ textField: UITextField)->())?
    var idStartTimeTextFieldEndEditing : ((_ idStartTimeText: String, _ textField: UITextField)->())?
    var idEndTimeTextFieldEndEditing : ((_ idEndTimeText: String, _ datePicker: UIDatePicker)->())?
    var showToast : ((_ msg:String)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(idNumberLabel)
        self.contentView.addSubview(idTimeLabel)
        self.contentView.addSubview(idNumberTextField)
        self.contentView.addSubview(idStartTimeTextField)
        self.contentView.addSubview(idEndTimeTextField)
        self.contentView.addSubview(idNumberLine)
        self.contentView.addSubview(idStartTimeLine)
        self.contentView.addSubview(idEndTimeLine)
        
        idNumberLabel.snp.makeConstraints({ (make) in
            make.top.greaterThanOrEqualTo(contentView.snp.top).offset(5)
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(80))
        })
        
        idTimeLabel.snp.makeConstraints({ (make) in
            make.top.greaterThanOrEqualTo(contentView.snp.top).offset(45)
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(80))
        })
        
        idNumberTextField.snp.makeConstraints({ (make) in
            make.top.equalTo(idNumberLabel.snp.top)
            make.left.equalTo(idNumberLabel.snp.right).offset(WH(24))
            make.height.equalTo(WH(40))
            make.right.equalTo(contentView.snp.right)
        })
        
        idStartTimeTextField.snp.makeConstraints({ (make) in
            make.top.equalTo(idTimeLabel.snp.top)
            make.left.equalTo(idTimeLabel.snp.right).offset(WH(24))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(110))
        })
        
        idEndTimeTextField.snp.makeConstraints({ (make) in
            make.top.equalTo(idTimeLabel.snp.top)
            make.left.equalTo(idStartTimeTextField.snp.right).offset(WH(20))
            make.height.equalTo(WH(40))
            make.right.equalTo(contentView.snp.right)
        })
        
        idNumberLine.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0.5))
            make.left.equalTo(idNumberLabel.snp.right).offset(WH(15))
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(idNumberLabel.snp.bottom).offset(WH(-5))
        }
        
        idStartTimeLine.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0.5))
            make.left.equalTo(idTimeLabel.snp.right).offset(WH(15))
            make.right.equalTo(idStartTimeTextField.snp.right)
            make.bottom.equalTo(idTimeLabel.snp.bottom).offset(WH(-5))
        }
        
        idEndTimeLine.snp.makeConstraints { (make) in
            make.height.equalTo(WH(0.5))
            make.left.equalTo(idEndTimeTextField.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(idTimeLabel.snp.bottom).offset(WH(-5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // UITextField delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField .isEqual(idNumberTextField) {
            if let idNumberTextFieldEndEditing = self.idNumberTextFieldEndEditing {
                idNumberTextFieldEndEditing(textField.text!,textField)
            }
        }else if textField .isEqual(idStartTimeTextField) {
            if let idStartTimeTextFieldEndEditing = self.idStartTimeTextFieldEndEditing {
                idStartTimeTextFieldEndEditing(textField.text!,textField)
            }
        }
    }
    
    //禁止用户输入文字
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField .isEqual(idStartTimeTextField) || textField .isEqual(idEndTimeTextField){
            return false
        } else {
            return true
        }
    }
    
    //
    @objc func textFieldViewDidChange(_ textField: UITextField) {
        // 过滤表情符
        if NSString.stringContainsEmoji(textField.text) || NSString.hasEmoji(textField.text) {
            textField.text = NSString.disableEmoji(textField.text)
        }
    }
    
    @objc func onStartTimeDatePickChange(_ sender : UIDatePicker) {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd";
        let dateStr : String = formatter.string(from: sender.date)
        
        //获取结束 没有下面
        if self.idEndTimeTextField.text?.isEmpty == false && dateStr.isEmpty == false {
            if self.compareEndTimeAndStartTime(self.idEndTimeTextField.text!,dateStr) == false{
               // self.toast("起始日期不能大于截止日期")
                if let block = self.showToast {
                    block("起始日期不能大于截止日期")
                }
                return
            }
        }
        
        self.idStartTimeTextField.text = dateStr;
//        if let idStartTimeTextFieldEndEditing = self.idStartTimeTextFieldEndEditing {
//            idStartTimeTextFieldEndEditing(dateStr,sender)
//        }
    }
    
    @objc func onEndTimeDatePickChange(_ sender : UIDatePicker) {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd";
        let dateStr : String = formatter.string(from: sender.date)
        //获取开始  没有下面
        if  self.idStartTimeTextField.text?.isEmpty == false && dateStr.isEmpty == false {
            if self.compareEndTimeAndStartTime(dateStr,self.idStartTimeTextField.text!) == false{
               // self.toast("截止日期不能小于起始日期")
                let msg = "截止日期不能小于起始日期"
                if let block = self.showToast {
                     block(msg)
                }
                return
            }
        }
        self.idEndTimeTextField.text = dateStr;
        if let idEndTimeTextFieldEndEditing = self.idEndTimeTextFieldEndEditing {
            idEndTimeTextFieldEndEditing(dateStr,sender)
        }
    }
    
    // 名称
    func configCell(idNumberLabelText : NSMutableAttributedString?) {
        idNumberLabel.attributedText = idNumberLabelText
    }
    
    // 名称
    func configCell(idTimeLabelText : NSMutableAttributedString?) {
        idTimeLabel.attributedText = idTimeLabelText
    }
    
    // 内容
    func configCell(idNumberStr: String?, startTime : String?, endTime : String?) {
        if (idNumberStr != nil) {
            idNumberTextField.text = idNumberStr
        } else {
            idNumberTextField.text = nil
        }
        
        if startTime != nil && (startTime?.count)! >= 10 {
            let index1 = startTime?.index((startTime?.startIndex)!, offsetBy: 10)
            idStartTimeTextField.text = startTime?.substring(to: index1!)
        } else {
            idStartTimeTextField.text = nil
        }
        
        if endTime != nil && (endTime?.count)! >= 10 {
            let index1 = endTime?.index((endTime?.startIndex)!, offsetBy: 10)
            idEndTimeTextField.text = endTime?.substring(to: index1!)
        } else {
            idEndTimeTextField.text = nil
        }
    }
    //开始时间结束时间比较
    func compareEndTimeAndStartTime(_ endStr:String,_ startStr:String) -> (Bool){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let formatterNormal = DateFormatter()
        formatterNormal.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var endDate = formatter.date(from: endStr)
        var startDate = formatter.date(from: startStr)
        
        if  endDate == nil{
            endDate = formatterNormal.date(from: endStr)
        }
        if  startDate == nil{
            startDate = formatterNormal.date(from: startStr)
        }
        if endDate == nil || startDate == nil{
            return true
        }
        if endDate!.compare(startDate!) == .orderedAscending{
            // 结束时间 小于 开始时间
            return false
        }
        return true
        
    }
//    func addMustTitle(str : NSString?) -> NSMutableAttributedString {
//        let allImageDes = "*\(str!)"
//        let mutabelAttribute = NSMutableAttributedString(string: allImageDes)
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.paragraphSpacingBefore = 10
//        paragraphStyle.alignment = .left
//        mutabelAttribute.setAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, (allImageDes as NSString).length))
//
//        mutabelAttribute.setAttributes([NSForegroundColorAttributeName: RGBColor(0xFF394E),NSFontAttributeName: UIFont.systemFont(ofSize: WH(16))], range: NSMakeRange(0, 1))
//        mutabelAttribute.setAttributes([NSForegroundColorAttributeName: RGBColor(0x161616),NSFontAttributeName: UIFont.systemFont(ofSize: WH(16))], range: (allImageDes as NSString).range(of: str! as String))
//        return mutabelAttribute
//    }
}
