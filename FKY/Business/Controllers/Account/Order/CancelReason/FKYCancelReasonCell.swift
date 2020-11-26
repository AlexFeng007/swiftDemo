//
//  FKYCancelReasonCell.swift
//  FKY
//
//  Created by My on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYCancelReasonCell: UITableViewCell {
 
    // closure
    var selectBlock: (()->())? // 选择完回调
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.numberOfLines = 0
        return lbl
    }()

    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 单选按钮
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                if strongSelf.btnSelect.isSelected {
                    return
                }
                strongSelf.selectBlock?()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension FKYCancelReasonCell {
    func setupView() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(btnSelect)
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-WH(30))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(40), height: WH(40)))
        }
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(30))
            make.right.equalTo(btnSelect.snp.left).offset(WH(-10))
             make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(lblTitle)
            make.right.equalTo(btnSelect)
            make.height.equalTo(WH(0.8))
        }
    }
    
    func configCell(_ model: FKYOrderResonModel, _ selected: Bool, _ hideLine: Bool) {
        lblTitle.text = model.reason
        btnSelect.isSelected = selected
        line.isHidden = hideLine
    }
}
