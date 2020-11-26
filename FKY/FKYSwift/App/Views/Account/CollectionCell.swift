//
//  CollectionCell.swift
//  FKY
//
//  Created by mahui on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

var imageCellWidth = (SCREEN_WIDTH ) / 2

class ImageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    var imageView = UIImageView()
    var uploadImageClosure : emptyClosure?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() -> () {
        
        self.imageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset(j1 + j2)
                make.right.equalTo(contentView.snp.right).offset(-(j1+j2))
                make.top.equalTo(contentView.snp.top).offset((j1+j2))
                make.bottom.equalTo(contentView.snp.bottom).offset(-(j1+j2))
                
            })
            view.layer.borderWidth = 2
            view.layer.borderColor = bg2.cgColor
            return view
        }()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ImageCell.tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() -> () {
        if self.uploadImageClosure != nil {
            self.uploadImageClosure!()
        }
    }
    
    func configCell(_ url : String?) -> () {
        self.imageView.image = nil
        if url != nil {
            let smallImageUrl = url!.smallImageUrlString().addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
            self.imageView.sd_setImage(with: URL.init(string: smallImageUrl), placeholderImage: UIImage.init(named: "image_placeholder"))
        }else{
            self.imageView.image = UIImage(named: "image_placeholder")
        }
    }
    
    func configCell(_ url : String? , errorContent: String?){
        self.imageView.image = nil
        if url != nil {
            let smallImageUrl = url!.smallImageUrlString().addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
            self.imageView.sd_setImage(with: URL.init(string: smallImageUrl), placeholderImage: UIImage.init(named: "image_placeholder"))
        }
    }
}

class AddImageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    var imageView = UIImageView()
    var addImageClosure : emptyClosure?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() -> () {
        
        self.imageView = {
            let view = UIImageView()
            contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset((j1+j2))
                make.right.equalTo(contentView.snp.right).offset(-(j1+j2))
                make.top.equalTo(contentView.snp.top).offset((j1+j2))
                make.bottom.equalTo(contentView.snp.bottom).offset(-(j1+j2))
                
            })
            view.layer.borderWidth = 2
            view.layer.borderColor = bg2.cgColor
            view.image = UIImage.init(named: "icon_qualitication_upload")
            return view
        }()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ImageCell.tapAction))
        self.addGestureRecognizer(tap)
    }
    
    func tapAction() -> () {
        if self.addImageClosure != nil {
            self.addImageClosure!()
        }
    }
}


class collectionViewHeader: UICollectionReusableView {
    
    fileprivate var titleLabel : UILabel?
    fileprivate var button: UIButton?
    fileprivate var refuseReasonLabel: UILabel?
    var touchClosure: emptyClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button = {
            let btn = UIButton()
            addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let closure = strongSelf.touchClosure {
                    closure()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        titleLabel = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.centerY.equalTo(self)
            })
            label.fontTuple = t24
            return label
        }()
        
        let v = UIView()
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(WH(10))
        }
        v.backgroundColor = bg2
        
        refuseReasonLabel = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.right.equalTo(self).offset(WH(-j1))
                make.centerY.equalTo(self)
                make.left.equalTo(self.titleLabel!.snp.right).offset(j1)
            })
            label.fontTuple = t32
            return label
        }()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHeaderView(_ text : String) -> () {
        configHeaderView(text, refuseReason: nil)
        
    }
    
    func configHeaderView(_ text : String, refuseReason: String?) -> () {
        if text == "企业其他资质" {
            titleLabel?.text = text
            let width = self.titleLabel!.singleLineLenght()
            titleLabel?.snp.makeConstraints({ (make) in
                make.width.equalTo(width)
            })
        }else{
            let str = "* " + text
            let att = NSMutableAttributedString.init(string: str)
            let rang = NSMakeRange(0, 1)
            att.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.red], range: rang)
            titleLabel?.attributedText = att
            titleLabel?.text = str
            let width = self.titleLabel!.singleLineLenght()
            titleLabel?.snp.makeConstraints({ (make) in
                make.width.equalTo(width)
            })
            titleLabel?.attributedText = att
        }
        if refuseReason != nil {
            refuseReasonLabel?.text = refuseReason!
        }else{
            refuseReasonLabel?.text = ""
        }

    }
}


enum FromType : Int {
    case startType
    case endType
}
typealias openDatePickerWithType = (_ type:FromType)->()

class collectionViewFooter: UICollectionReusableView, UITextFieldDelegate {
    
    fileprivate var num : UILabel?
    fileprivate var startL : UILabel?
    fileprivate var startR : UILabel?
    fileprivate var endL : UILabel?
    fileprivate var endR : UILabel?
    fileprivate var textfield : UITextField?
    var inputText :String?
    var startDate :String?
    var endDate :String?
    var saveClosure: SingleStringClosure?
    var selectedDateClouser : openDatePickerWithType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        num = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.top.equalTo(self)
                make.height.equalTo(WH(h10))
            })
            label.fontTuple = t24
            label.text = "证书号码"
            return label
        }()
        
        textfield = {
            let t = UITextField()
            self.addSubview(t)
            t.snp.makeConstraints({ (make) in
                make.right.equalTo(self.snp.right).offset(WH(-j1))
                make.height.equalTo(WH(h10))
                make.centerY.equalTo(self.num!)
                make.width.equalTo(WH(150))
            })
            t.textAlignment = .right
            t.font = t24.font
            t.placeholder = "请输入"
            t.delegate = self
            return t
        }()
        startL = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.top.equalTo(self.num!.snp.bottom)
                make.height.equalTo(WH(h10))
            })
            label.fontTuple = t24
            label.text = "有效期开始时间"
            
            return label
        }()
        let rightIcon = UIButton()
        self.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-j1)
            make.centerY.equalTo(self.startL!)
            make.height.width.equalTo(WH(20))
        }
        rightIcon.setImage(UIImage.init(named: "icon_account_black_arrow"), for: UIControl.State())
        _ = rightIcon.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tapActionFromStart()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        startR = {
            let label = UILabel()
            self.addSubview(label)
            label.isUserInteractionEnabled = true
            label.snp.makeConstraints({ (make) in
                make.right.equalTo(rightIcon.snp.left).offset(WH(-j1))
                make.centerY.equalTo(self.startL!)
                make.height.equalTo(WH(h10))
            })
            label.fontTuple = t24
            return label
        }()
        
        
        endL = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.top.equalTo(self.startL!.snp.bottom)
                make.height.equalTo(WH(h10))
            })
            label.fontTuple = t24
            label.text = "有效期结束时间"
            return label
        }()
        let leftIcon = UIButton()
        self.addSubview(leftIcon)
        leftIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-j1)
            make.centerY.equalTo(self.endL!)
            make.height.width.equalTo(WH(20))
        }
        leftIcon.setImage(UIImage.init(named: "icon_account_black_arrow"), for: UIControl.State())
        _ = leftIcon.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tapActionFromEnd()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        endR = {
            let label = UILabel()
            self.addSubview(label)
            label.isUserInteractionEnabled = true
            label.snp.makeConstraints({ (make) in
                make.right.equalTo(leftIcon.snp.left).offset(WH(-j1))
                make.centerY.equalTo(self.endL!)
                make.height.equalTo(WH(h10))
            })
            label.fontTuple = t24
            return label
        }()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(collectionViewFooter.tapActionFromEnd))
        let taps = UITapGestureRecognizer.init(target: self, action: #selector(collectionViewFooter.tapActionFromStart))
        
        endR?.addGestureRecognizer(tap)
        startR?.addGestureRecognizer(taps)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapActionFromStart() -> () {
        if self.selectedDateClouser != nil {
            self.selectedDateClouser!(FromType.startType)
        }
    }
    @objc func tapActionFromEnd() -> () {
        if self.selectedDateClouser != nil {
            self.selectedDateClouser!(FromType.endType)
        }
    }
    
    func configFooterView(_ model:ZZMidModel) -> () {
        textfield?.text = model.fileCode
        startR?.text = self.dateFormatter(model.startDate)
        endR?.text = self.dateFormatter(model.endDate)
    }
    
    func dateFormatter(_ string : String) -> (String) {
        if string.count > 0 && string.contains("-"){
            let fomatter = DateFormatter.init()
            fomatter.dateFormat = "yyyy-MM-dd"
            let date = fomatter.date(from: string)
            fomatter.dateFormat = "yyyy年MM月dd日"
            let final = fomatter.string(from: date!)
            return final
        }
        if string.count > 0 && string.contains("年"){
            return string
        }
        return "请选择"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.saveClosure!(text)
        }
    }
}
