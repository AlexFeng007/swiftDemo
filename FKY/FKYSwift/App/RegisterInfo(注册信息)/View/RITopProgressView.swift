//
//  RITopProgressView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]顶部进度视图

import UIKit

// 标题
let txtColorNormal = RGBColor(0x666666)
let txtColorSelect = RGBColor(0x333333)
let txtFontNormal = UIFont.systemFont(ofSize: WH(13))
let txtFontSelect = UIFont.boldSystemFont(ofSize: WH(13))
// 序号
let bgColorNormal = RGBColor(0xF0F0F0)
let bgColorSelect = RGBColor(0xFF2D5C)
let numberColorNormal = RGBColor(0x999999)
let numberColorSelect = RGBColor(0xFFFFFF)
let numberFontNormal = UIFont.systemFont(ofSize: WH(14))
let numberFontSelect = UIFont.boldSystemFont(ofSize: WH(14))


class RITopProgressView: UIView {
    // MARK: - Property
    
    // 序号1
    fileprivate lazy var lblNumber1: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = bgColorSelect
        lbl.font = numberFontSelect
        lbl.textColor = numberColorSelect
        lbl.textAlignment = .center
        lbl.text = "1"
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(12)
        return lbl
    }()
    // 标题1
    fileprivate lazy var lblTitle1: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = txtFontSelect
        lbl.textColor = txtColorSelect
        lbl.textAlignment = .center
        lbl.text = "填写基本信息"
        return lbl
    }()
    // 图片1
    fileprivate lazy var imgviewSuccess1: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleToFill
        imgview.image = UIImage.init(named: "image_doc_success")
        return imgview
    }()
    
    // 序号2
    fileprivate lazy var lblNumber2: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = bgColorNormal
        lbl.font = numberFontNormal
        lbl.textColor = numberColorNormal
        lbl.textAlignment = .center
        lbl.text = "2"
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(12)
        return lbl
    }()
    // 标题2
    fileprivate lazy var lblTitle2: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = txtFontNormal
        lbl.textColor = txtColorNormal
        lbl.textAlignment = .center
        lbl.text = "上传资质照片"
        return lbl
    }()
    // 图片2
    fileprivate lazy var imgviewSuccess2: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleToFill
        imgview.image = UIImage.init(named: "image_doc_success")
        return imgview
    }()

    // 序号3
    fileprivate lazy var lblNumber3: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = bgColorNormal
        lbl.font = numberFontNormal
        lbl.textColor = numberColorNormal
        lbl.textAlignment = .center
        lbl.text = "3"
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = WH(12)
        return lbl
    }()
    // 标题3
    fileprivate lazy var lblTitle3: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = txtFontNormal
        lbl.textColor = txtColorNormal
        lbl.textAlignment = .center
        lbl.text = "完善资料成功"
        return lbl
    }()
    // 图片3
    fileprivate lazy var imgviewSuccess3: UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleToFill
        imgview.image = UIImage.init(named: "image_doc_success")
        return imgview
    }()
    
    // 左分隔线
    fileprivate lazy var viewLineLeft: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF0F0F0)
        return view
    }()

    // 右分隔线
    fileprivate lazy var viewLineRight: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF0F0F0)
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        
        addSubview(lblNumber2)
        addSubview(lblTitle2)
        addSubview(imgviewSuccess2)
        addSubview(lblNumber1)
        addSubview(lblTitle1)
        addSubview(imgviewSuccess1)
        addSubview(lblNumber3)
        addSubview(lblTitle3)
        addSubview(imgviewSuccess3)
        
        lblNumber2.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-WH(12))
            make.centerX.equalTo(self)
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(24))
        }
        lblTitle2.snp.makeConstraints { (make) in
            make.top.equalTo(lblNumber2.snp.bottom).offset(WH(6))
            make.centerX.equalTo(lblNumber2)
        }
        imgviewSuccess2.snp.makeConstraints { (make) in
            make.center.equalTo(lblNumber2)
            make.size.equalTo(CGSize(width: WH(12), height: WH(10)))
        }
        
        lblNumber1.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblNumber2)
            make.left.equalTo(self).offset(WH(68))
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(24))
        }
        lblTitle1.snp.makeConstraints { (make) in
            make.top.equalTo(lblNumber1.snp.bottom).offset(WH(6))
            make.centerX.equalTo(lblNumber1)
        }
        imgviewSuccess1.snp.makeConstraints { (make) in
            make.center.equalTo(lblNumber1)
            make.size.equalTo(CGSize(width: WH(12), height: WH(10)))
        }
        
        lblNumber3.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblNumber2)
            make.right.equalTo(self).offset(-WH(68))
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(24))
        }
        lblTitle3.snp.makeConstraints { (make) in
            make.top.equalTo(lblNumber3.snp.bottom).offset(WH(6))
            make.centerX.equalTo(lblNumber3)
        }
        imgviewSuccess3.snp.makeConstraints { (make) in
            make.center.equalTo(lblNumber3)
            make.size.equalTo(CGSize(width: WH(12), height: WH(10)))
        }
        
        // 默认隐藏
        imgviewSuccess1.isHidden = true
        imgviewSuccess2.isHidden = true
        imgviewSuccess3.isHidden = true
        
        // 左分隔线
        addSubview(viewLineLeft)
        viewLineLeft.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblNumber2)
            make.left.equalTo(lblNumber1.snp.right).offset(WH(12))
            make.right.equalTo(lblNumber2.snp.left).offset(-WH(12))
            make.height.equalTo(2)
        }
        
        // 右分隔线
        addSubview(viewLineRight)
        viewLineRight.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblNumber2)
            make.left.equalTo(lblNumber2.snp.right).offset(WH(12))
            make.right.equalTo(lblNumber3.snp.left).offset(-WH(12))
            make.height.equalTo(2)
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ index: Int) {
        if index == 1 {
            // 步骤1
            lblNumber1.backgroundColor = bgColorSelect
            lblNumber1.font = numberFontSelect
            lblNumber1.textColor = numberColorSelect
            lblTitle1.font = txtFontSelect
            lblTitle1.textColor = txtColorSelect
            imgviewSuccess1.isHidden = true
            lblNumber1.text = "1"
            
            lblNumber2.backgroundColor = bgColorNormal
            lblNumber2.font = numberFontNormal
            lblNumber2.textColor = numberColorNormal
            lblTitle2.font = txtFontNormal
            lblTitle2.textColor = txtColorNormal
            imgviewSuccess2.isHidden = true
            lblNumber2.text = "2"
            
            lblNumber3.backgroundColor = bgColorNormal
            lblNumber3.font = numberFontNormal
            lblNumber3.textColor = numberColorNormal
            lblTitle3.font = txtFontNormal
            lblTitle3.textColor = txtColorNormal
            imgviewSuccess3.isHidden = true
            lblNumber3.text = "3"
            
            viewLineLeft.backgroundColor = RGBColor(0xF0F0F0)
            viewLineRight.backgroundColor = RGBColor(0xF0F0F0)
        }
        else if index == 2 {
            // 步骤2
            lblNumber1.backgroundColor = bgColorSelect
            lblNumber1.font = numberFontSelect
            lblNumber1.textColor = numberColorSelect
            lblTitle1.font = txtFontNormal
            lblTitle1.textColor = txtColorNormal
            imgviewSuccess1.isHidden = false
            lblNumber1.text = ""
            
            lblNumber2.backgroundColor = bgColorSelect
            lblNumber2.font = numberFontSelect
            lblNumber2.textColor = numberColorSelect
            lblTitle2.font = txtFontSelect
            lblTitle2.textColor = txtColorSelect
            imgviewSuccess2.isHidden = true
            lblNumber2.text = "2"
            
            lblNumber3.backgroundColor = bgColorNormal
            lblNumber3.font = numberFontNormal
            lblNumber3.textColor = numberColorNormal
            lblTitle3.font = txtFontNormal
            lblTitle3.textColor = txtColorNormal
            imgviewSuccess3.isHidden = true
            lblNumber3.text = "3"
            
            viewLineLeft.backgroundColor = RGBColor(0xFF2D5C)
            viewLineRight.backgroundColor = RGBColor(0xF0F0F0)
        }
        else if index == 3 {
            // 步骤3
            lblNumber1.backgroundColor = bgColorSelect
            lblNumber1.font = numberFontSelect
            lblNumber1.textColor = numberColorSelect
            lblTitle1.font = txtFontNormal
            lblTitle1.textColor = txtColorNormal
            imgviewSuccess1.isHidden = false
            lblNumber1.text = ""
            
            lblNumber2.backgroundColor = bgColorSelect
            lblNumber2.font = numberFontSelect
            lblNumber2.textColor = numberColorSelect
            lblTitle2.font = txtFontNormal
            lblTitle2.textColor = txtColorNormal
            imgviewSuccess2.isHidden = false
            lblNumber2.text = ""
            
            lblNumber3.backgroundColor = bgColorSelect
            lblNumber3.font = numberFontSelect
            lblNumber3.textColor = numberColorSelect
            lblTitle3.font = txtFontSelect
            lblTitle3.textColor = txtColorSelect
            imgviewSuccess3.isHidden = true
            lblNumber3.text = "3"
            
            viewLineLeft.backgroundColor = RGBColor(0xFF2D5C)
            viewLineRight.backgroundColor = RGBColor(0xFF2D5C)
        }
        else if index == 4 {
            // 步骤4完成
            lblNumber1.backgroundColor = bgColorSelect
            lblNumber1.font = numberFontSelect
            lblNumber1.textColor = numberColorSelect
            lblTitle1.font = txtFontNormal
            lblTitle1.textColor = txtColorNormal
            imgviewSuccess1.isHidden = false
            lblNumber1.text = ""
            
            lblNumber2.backgroundColor = bgColorSelect
            lblNumber2.font = numberFontSelect
            lblNumber2.textColor = numberColorSelect
            lblTitle2.font = txtFontNormal
            lblTitle2.textColor = txtColorNormal
            imgviewSuccess2.isHidden = false
            lblNumber2.text = ""
            
            lblNumber3.backgroundColor = bgColorSelect
            lblNumber3.font = numberFontSelect
            lblNumber3.textColor = numberColorSelect
            lblTitle3.font = txtFontNormal
            lblTitle3.textColor = txtColorNormal
            imgviewSuccess3.isHidden = false
            lblNumber3.text = ""
            
            viewLineLeft.backgroundColor = RGBColor(0xFF2D5C)
            viewLineRight.backgroundColor = RGBColor(0xFF2D5C)
        }
        else {
            // error
            lblNumber1.backgroundColor = bgColorSelect
            lblNumber1.font = numberFontSelect
            lblNumber1.textColor = numberColorSelect
            lblTitle1.font = txtFontSelect
            lblTitle1.textColor = txtColorSelect
            
            lblNumber2.backgroundColor = bgColorNormal
            lblNumber2.font = numberFontNormal
            lblNumber2.textColor = numberColorNormal
            lblTitle2.font = txtFontNormal
            lblTitle2.textColor = txtColorNormal
            
            lblNumber3.backgroundColor = bgColorNormal
            lblNumber3.font = numberFontNormal
            lblNumber3.textColor = numberColorNormal
            lblTitle3.font = txtFontNormal
            lblTitle3.textColor = txtColorNormal
            
            viewLineLeft.backgroundColor = RGBColor(0xF0F0F0)
            viewLineRight.backgroundColor = RGBColor(0xF0F0F0)
        }
    }
}
