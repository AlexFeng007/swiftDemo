//
//  ASListStatusFooterCell.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ASListStatusFooterCell: UITableViewCell {

    fileprivate lazy var asTypeReasonNameL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    fileprivate lazy var dealWayL: UILabel = {
        let label = UILabel()
        label.fontTuple = t23
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    fileprivate lazy var dealTimeL: UILabel = {
        let label = UILabel()
        label.fontTuple = t23
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.white
        contentView.addSubview(asTypeReasonNameL)
        contentView.addSubview(dealWayL)
        contentView.addSubview(dealTimeL)
        
        asTypeReasonNameL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.right.equalTo(contentView).offset(WH(-18))
            make.top.equalTo(contentView).offset(WH(13))
            make.height.equalTo(WH(14))
        }
        
        dealWayL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.right.equalTo(contentView).offset(WH(-18))
            make.top.equalTo(asTypeReasonNameL.snp.bottom).offset(WH(10))
        }
        
        dealTimeL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.right.equalTo(contentView).offset(WH(-18))
            make.top.equalTo(dealWayL.snp.bottom).offset(WH(8))
            make.bottom.equalTo(contentView).offset(WH(-18))
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ model : ASApplyListInfoModel) {
        //ASApplyStatus.ASApplyStatus_Complete.rawValue
        asTypeReasonNameL.text = model.secondTypeName
        if model.status == ASApplyStatus.ASApplyStatus_Complete.rawValue{
            dealWayL.text = model.completeContent
            if model.completeDateStr != nil && model.completeDateStr!.isEmpty == false {
                dealTimeL.text = "处理完成时间  " +  model.completeDateStr!
            }
            dealWayL.isHidden = false
            dealTimeL.isHidden = false
        }else if model.status == ASApplyStatus.ASApplyStatus_Dealing.rawValue || model.status == ASApplyStatus.ASApplyStatus_Wait.rawValue{
            dealWayL.isHidden = true
            dealTimeL.isHidden = true
        }
    }
}
