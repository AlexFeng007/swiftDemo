//
//  ASListStatusHeaderCell.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ASListStatusHeaderCell: UITableViewCell {

    fileprivate lazy var asTypeNameL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
       // label.sizeToFit()
       // label.backgroundColor = .blue
        return label
    }()
    
    fileprivate lazy var asApplyTimeL: UILabel = {
        let label = UILabel()
        label.fontTuple = t23
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    fileprivate lazy var statusL: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF3563)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    fileprivate lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        return line
    }()
    
    fileprivate lazy var topLineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        return line
    }()
    
    fileprivate lazy var  backgroundV: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let topV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        topV.backgroundColor = RGBColor(0xf7f7f7)
        
        contentView.addSubview(backgroundV)
        contentView.addSubview(topV)
        backgroundV.addSubview(asTypeNameL)
        backgroundV.addSubview(asApplyTimeL)
        backgroundV.addSubview(statusL)
        
        backgroundV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(10))
        }
        
        asTypeNameL.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundV).offset(WH(18))
            make.centerY.equalTo(backgroundV)
        }
        
        asApplyTimeL.snp.makeConstraints { (make) in
            make.left.equalTo(asTypeNameL.snp.right).offset(WH(5))
            make.centerY.equalTo(backgroundV)
            make.right.equalTo(statusL.snp.left).offset(WH(-5))
        }
        
        statusL.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundV).offset(-WH(14))
            make.centerY.equalTo(backgroundV)
            make.width.lessThanOrEqualTo(WH(100))
        }
        
        backgroundV.addSubview(topLineView)
        topLineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
        
        backgroundV.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ model : ASApplyListInfoModel) {
        if  let num = model.rmaBizType ,num == 1 {
            asTypeNameL.text = "极速理赔"
        }else {
            asTypeNameL.text = model.firstTypeName
        }
        asApplyTimeL.text = model.applyTimeStr
        statusL.text = model.statusStr
        
        let str =  asTypeNameL.text
        let mjContentLabelW =  str!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height:WH(20)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: WH(14))], context: nil).width
        
        asTypeNameL.snp.remakeConstraints { (make) in
            make.left.equalTo(backgroundV).offset(WH(18))
            make.centerY.equalTo(backgroundV)
            make.width.equalTo(mjContentLabelW + WH(5))
        }
        
        if model.firstTypeId == ASTypeECode.ASType_Bill.rawValue || model.firstTypeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
            lineView.isHidden = true
        }else{
            lineView.isHidden = false
        }
    }

}
