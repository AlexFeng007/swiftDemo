//
//  COPopTitleView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单弹出视图之顶部标题栏

import UIKit

class COPopTitleView: UIView {
    // MARK: - Property
    
    // 取消回调
    var closeAction: (()->())?
    // 确定回调
    var doneAction: (()->())?
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "请输入"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 取消btn
    fileprivate lazy var btnClose: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        //btn.alpha = 0.8
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.closeAction else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        return btn
    }()
    
    // 确定btn
    fileprivate lazy var btnDone: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.setTitleColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), for: .highlighted)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.doneAction else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        return btn
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(lblTitle)
        addSubview(btnClose)
        addSubview(btnDone)
        
        btnClose.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        btnDone.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-WH(15))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(btnClose.snp.right).offset(WH(10))
            make.right.equalTo(btnDone.snp.left).offset(-WH(10))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configView() {
        
    }
    
    //
    func setTitle(_ title: String?) {
        guard let title = title, title.isEmpty == false else {
            lblTitle.text = "请输入"
            return
        }
        
        lblTitle.text = title
    }
    
    // 右侧确定btn不展示
    func updateDoneStatus(_ showFlag: Bool) {
        btnDone.isHidden = !showFlag
    }
}
