//
//  RCPopCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货相关界面(填写回寄信息、退换货提交)之弹出视图中的cell

import UIKit

class RCPopCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    var selectBlock: (()->())? // 选择完回调
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        return lbl
    }()
    // 单选按钮
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard btn.isSelected == false else {
                // 若当前已选中，则不作任何处理
                return
            }
            guard let block = strongSelf.selectBlock else {
                // block不能为空
                return
            }
            btn.isSelected = true
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // 分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
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
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(btnSelect)
        btnSelect.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-15))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(20))
            make.right.equalTo(btnSelect.snp.left).offset(WH(-20))
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(20))
            make.right.equalTo(contentView).offset(WH(-20))
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ model: Any?) {
        guard let obj = model else {
            return
        }
        if (obj as AnyObject).isKind(of:RCSendCompanyModel.self) {
            let item: RCSendCompanyModel = obj as! RCSendCompanyModel
            lblTitle.text = item.carrierName
        }
        else if (obj as AnyObject).isKind(of:RCApplyReasonModel.self) {
            let item: RCApplyReasonModel = obj as! RCApplyReasonModel
            lblTitle.text = item.name
        }else if (obj as AnyObject).isKind(of:ComplaintTypeInfoModel.self) {
            let item: ComplaintTypeInfoModel = obj as! ComplaintTypeInfoModel
            lblTitle.text = item.typeDesc
        }
    }
    
    // 选中状态
    func setSelectedStatus(_ selected: Bool) {
        btnSelect.isSelected = selected
    }
    
    // 隐藏分隔线
    func showBottomLine(_ show: Bool) {
        viewLine.isHidden = !show
    }
    
    // 返回当前选择按钮的选中状态
    func checkSelectStatus() -> Bool {
        return btnSelect.isSelected
    }
}
