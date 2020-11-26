//
//  RIImageTitleCRView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之企业类型视图...<section-header>

import UIKit

class RIImageTitleCRView: UICollectionReusableView {
    // MARK: - Property
    
    var callback: ( (Bool)->(Void) )?
    
    // 当前企业类型索引
    var typeIndex = 0
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(16))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.text = "是否三证合一"
        return lbl
    }()
    
    // 开关
    fileprivate lazy var switchSelect: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = RGBColor(0xFF2D5C)
        view.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return view
    }()
    
    
    // MARK: - LiftCircle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(lblTitle)
        addSubview(lblTip)
        addSubview(switchSelect)
        
        lblTitle.snp.makeConstraints { (make) in
            //make.top.equalTo(self).offset(WH(25))
            make.top.equalTo(self).offset(WH(0))
            make.left.equalTo(self).offset(WH(15))
            make.right.equalTo(self).offset(-WH(20))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(12))
            make.left.equalTo(self).offset(WH(15))
            make.right.equalTo(self).offset(-WH(130))
        }
        
        switchSelect.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblTip)
            make.right.equalTo(self).offset(-WH(16))
        }
    }
    
    
    // MARK: - Public
    
    //
    func configView(_ content: String?, _ show: Bool, _ value: Bool) {
        lblTitle.text = content ?? "企业"
        if show {
            // 显示三证合一开关
            lblTip.isHidden = false
            switchSelect.isHidden = false
            switchSelect.setOn(value, animated: false)
        }
        else {
            // 不显示
            lblTip.isHidden = true
            switchSelect.isHidden = true
        }
    }
    
    //
    @objc func switchValueChanged() {
        guard let block = callback else {
            return
        }
        block(switchSelect.isOn)
    }
}
