//
//  SelectReasonView.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

typealias SelectComplainTypeBlock = ()->()

class SelectReasonView: UIView {
    var selectTypeBlock: SelectComplainTypeBlock?
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "投诉类型"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var txtfieldName: UITextField = {
        let txtfield = UITextField()
        txtfield.backgroundColor = .clear
        txtfield.borderStyle = .none
        txtfield.textAlignment = .left
        txtfield.font = UIFont.systemFont(ofSize: WH(13))
        txtfield.textColor = RGBColor(0x666666)
        txtfield.placeholder = "请选择"
        //txtfield.setValue(RGBColor(0x999999), forKeyPath: "_placeholderLabel.textColor")
        txtfield.attributedPlaceholder = NSAttributedString.init(string: "请选择", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13)), NSAttributedString.Key.foregroundColor: RGBColor(0x999999)])
        txtfield.isEnabled = false // 不可输入
        return txtfield
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_pd_arrow_gray")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        backgroundColor = .white
        
        addSubview(lblTitle)
        addSubview(txtfieldName)
        addSubview(imgviewArrow)
        //        addSubview(btnSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.centerY.equalTo(self)
            make.width.equalTo(WH(60))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-10))
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        txtfieldName.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(0))
            make.centerY.equalTo(self)
        }
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectTypeBlock else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    func configCell(_ reason: String?) {
        txtfieldName.text = reason
    }
}
