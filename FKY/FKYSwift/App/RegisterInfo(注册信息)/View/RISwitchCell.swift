
//
//  RISwitchCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]文字输入界面之开关ccell

import UIKit

class RISwitchCell: UITableViewCell {
    // MARK: - Property

    var callback: ( (RITextInputType, Bool)->(Void) )?
    
    // cell类型...<默认为与收货人信息一致>
    var cellType: RITextInputType = .samePersonSelect
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 开关
    fileprivate lazy var switchSelect: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = RGBColor(0xFF2D5C)
        view.isUserInteractionEnabled = false // 禁用
        //view.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return view
    }()
    
    // 覆盖在UISwitch上的视图
    fileprivate lazy var viewSwitch: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(switchSelect)
        contentView.addSubview(viewSwitch)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblTip)
        
        switchSelect.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-WH(16))
        }
        viewSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(switchSelect).offset(-WH(5))
            make.right.equalTo(switchSelect).offset(WH(5))
            make.top.equalTo(switchSelect).offset(-WH(5))
            make.bottom.equalTo(switchSelect).offset(WH(5))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-WH(10))
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(switchSelect.snp.left).offset(-WH(25))
        }
        lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(switchSelect.snp.left).offset(-WH(25))
        }
    }
    
    
    // MARk: - Action
    
    func setupAction() {
        // 避免用户手动切换UISwitch与直接给UISwitch赋值时，均触发valueChanged对应的方法，从而导致逻辑混乱
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.callback else {
                return
            }
            // 当前状态
            let status = strongSelf.switchSelect.isOn
            // 更新状态
            strongSelf.switchSelect.setOn(!status, animated: true)
            // 回调
            block(strongSelf.cellType, strongSelf.switchSelect.isOn)
        }).disposed(by: disposeBag)
        viewSwitch.addGestureRecognizer(tapGesture)
    }
}


// MARK: -

extension RISwitchCell {
    //
    func configCell(_ show: Bool, _ type: RITextInputType, _ status: Bool) {
        guard show else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 保存类型
        cellType = type
        // 赋值
        switchSelect.isOn = status
        
        // 根据类型设置标题
        lblTitle.text = type.typeName
        lblTip.text = type.typeDescription
    }
    
    // 开关状态改变
//    func switchValueChanged() {
//        guard let block = callback else {
//            return
//        }
//        block(cellType, switchSelect.isOn)
//    }
    
    // 手动设置开关状态，不需要回调
    func updateSwitchValue(_ selected: Bool) {
        //switchSelect.isOn = selected
        switchSelect.setOn(selected, animated: true)
    }
}
