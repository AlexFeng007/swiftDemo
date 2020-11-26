//
//  RCSubmitInfoTypeCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/29.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货提交界面之退回方式cell

import UIKit

class RCSubmitInfoTypeCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    var selectBackType: ((RCSendBackType)->())? // 选择退回方式
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "退回方式"
        return lbl
    }()
    
    // 按钮0-上门取件
    fileprivate lazy var btnPickup: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        btn.setTitle("上门取件", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectBackType else {
                return
            }
            strongSelf.btnPickup.isSelected = true
            strongSelf.btnReturn.isSelected = false
            strongSelf.btnRefuse.isSelected = false
            block(.homePickup)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 按钮1-顾客寄回
    fileprivate lazy var btnReturn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        btn.setTitle("客户寄回", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectBackType else {
                return
            }
            strongSelf.btnPickup.isSelected = false
            strongSelf.btnReturn.isSelected = true
            strongSelf.btnRefuse.isSelected = false
            block(.customerSend)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 按钮2-已拒收/快递员已带回
    fileprivate lazy var btnRefuse: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        btn.setTitle("已拒收/快递员已带回", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.selectBackType else {
                return
            }
            //            guard strongSelf.btnRefuse.isSelected == false else {
            //                return
            //            }
            strongSelf.btnPickup.isSelected = false
            strongSelf.btnReturn.isSelected = false
            strongSelf.btnRefuse.isSelected = true
            block(.refuseReceive)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(btnPickup)
        contentView.addSubview(btnReturn)
        contentView.addSubview(btnRefuse)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(60))
        }
        btnPickup.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(2))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(88), height: WH(32)))
        }
        btnReturn.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(2))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(88), height: WH(32)))
        }
        btnRefuse.snp.makeConstraints { (make) in
            make.left.equalTo(btnPickup.snp.right).offset(WH(10))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(160), height: WH(32)))
        }
        
        // 默认隐藏
        btnPickup.isHidden = true
        btnReturn.isHidden = true
        btnRefuse.isHidden = true
        
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ showType: RCSendBackShowType, _ selectType: RCSendBackType?) {
        switch showType {
        case .noShow:
            // (三个)均不显示
            btnPickup.isHidden = true
            btnReturn.isHidden = true
            btnRefuse.isHidden = true
            // 均不选中
            btnPickup.isSelected = false
            btnReturn.isSelected = false
            btnRefuse.isSelected = false
            // 直接返回
            return
        case .showHomePickup:
            // (左侧)显示上门取件...<右侧一直显示已拒收/快递员已带回>
            btnPickup.isHidden = false
            btnReturn.isHidden = true
            btnRefuse.isHidden = false
        case .showCustomerSend:
            // (左侧)显示顾客寄回...<右侧一直显示已拒收/快递员已带回>
            btnPickup.isHidden = true
            btnReturn.isHidden = false
            btnRefuse.isHidden = false
        case .showOnyCustomerSend:
            //(左侧)显示顾客寄回
            btnPickup.isHidden = true
            btnReturn.isHidden = false
            btnRefuse.isHidden = true
        }
        
        // 未有选择
        guard let type = selectType else {
            btnPickup.isSelected = false
            btnReturn.isSelected = false
            btnRefuse.isSelected = false
            return
        }
        
        switch type {
        case .homePickup:
            // 上门取件
            btnPickup.isSelected = true
            btnReturn.isSelected = false
            btnRefuse.isSelected = false
        case .customerSend:
            // 顾客寄回
            btnPickup.isSelected = false
            btnReturn.isSelected = true
            btnRefuse.isSelected = false
        case .refuseReceive:
            // 已拒收/快递员已带回
            btnPickup.isSelected = false
            btnReturn.isSelected = false
            btnRefuse.isSelected = true
        }
    }
}
