//
//  COPayTypeDoubleCell.swift
//  FKY
//
//  Created by My on 2019/12/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COPayTypeDoubleCell: UITableViewCell {
    
    //1 - 在线  3 - 线下
    var selectedPayTypeClosure: ((Int) -> ())?
    
    //埋点1-在线支付  2-线下转账
    var payTypeBIClosure: ((Int) -> ())?
    
    private var configLabelClosure: (UIColor, UIFont, String) -> UILabel = {
        (textColor, font, text) in
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = text
        return label
    }
    
    private var configBtnClosure: () -> UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        return btn
    }
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    
    private lazy var lblTitle: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.boldSystemFont(ofSize: WH(13)), "支付方式")
    
    private lazy var lineLb: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(13)), "在线支付")
    
    private lazy var offLb: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(13)), "线下转账")
    
    //在线
    private lazy var offBtn: UIButton = self.configBtnClosure()
    //线下转账
    private lazy var lineBtn: UIButton = self.configBtnClosure()
    
    
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


extension COPayTypeDoubleCell {
    func configContentViews() {
        contentView.addSubview(lblTitle)
        contentView.addSubview(lineLb)
        contentView.addSubview(offLb)
        contentView.addSubview(offBtn)
        contentView.addSubview(lineBtn)
        contentView.addSubview(viewLine)
        
        
        lblTitle.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(11))
        }
        
        offLb.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-WH(11))
        }
        
        offBtn.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(offLb.snp_left)
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        lineLb.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(offBtn.snp_left).offset(-WH(5))
        }
        
        lineBtn.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(lineLb.snp_left)
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
        }
    }
    
    func configBtnActions() {
        _ = offBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard let strongSelf = self else {
                return
            }
            //选中则不选
            guard strongSelf.offBtn.isSelected == false else {
                return
            }
            strongSelf.offBtn.isSelected = true
            strongSelf.lineBtn.isSelected = false
            
            strongSelf.selectedPayTypeClosure?(3)
            strongSelf.payTypeBIClosure?(2)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        _ = lineBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard let strongSelf = self else {
                return
            }
            //选中则不选
            guard strongSelf.lineBtn.isSelected == false else {
                return
            }
       
            strongSelf.lineBtn.isSelected = true
            strongSelf.offBtn.isSelected = false
            
            strongSelf.selectedPayTypeClosure?(1)
            strongSelf.payTypeBIClosure?(1)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    
    func configCellStatus(_ payType: Int?, _ isShowCorner: Bool) {
        showCorner(isShowCorner)
        lineBtn.isSelected = false
        offBtn.isSelected = false
        guard let type = payType, type > 0 else {
            return
        }
        
        if type == 1 {
            lineBtn.isSelected = true
        } else if type == 3 {
            offBtn.isSelected = true
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
