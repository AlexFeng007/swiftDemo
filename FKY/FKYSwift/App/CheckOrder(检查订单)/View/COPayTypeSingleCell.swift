//
//  COPayTypeSingleCell.swift
//  FKY
//
//  Created by My on 2019/12/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COPayTypeSingleCell: UITableViewCell {
    
    //1 - 在线  3 - 线下
    var selectedPayTypeClosure: ((Int) -> ())?

    //埋点1-在线支付  2-线下转账
    var payTypeBIClosure: ((Int) -> ())?
    
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.text = "支付方式"
        return lbl
    }()
    
    fileprivate lazy var payTypeLb: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.text = "在线支付"
        return lbl
    }()
    
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        return btn
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        configContentViews()
        configBtnActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension COPayTypeSingleCell {
    func configContentViews() {
        contentView.addSubview(lblTitle)
        contentView.addSubview(payTypeLb)
        contentView.addSubview(btnSelect)
        contentView.addSubview(viewLine)
        
        lblTitle.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(11))
        }
        
        payTypeLb.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-WH(11))
        }
        
        btnSelect.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(payTypeLb.snp_left)
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
    }
    
    func configBtnActions() {
        _ = btnSelect.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard let strongSelf = self else {
                return
            }
            //选中则不可反选
            guard strongSelf.btnSelect.isSelected == false else {
                return
            }
            strongSelf.btnSelect.isSelected = true
            strongSelf.selectedPayTypeClosure?(1)
            strongSelf.payTypeBIClosure?(1)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func configCellStatus(_ payType: Int?, _ isShowCorner: Bool) {
        showCorner(isShowCorner)
        if let type = payType, type == 1 {
            btnSelect.isSelected = true
        }else {
            btnSelect.isSelected = false
        }
    }
    
    
    func showCorner(_ isShowCorner: Bool) {
        if isShowCorner {
            viewLine.isHidden = true
            layoutIfNeeded()
            self.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), radius: WH(8))
            return
        }
        mask = nil
        viewLine.isHidden = false
    }
}
