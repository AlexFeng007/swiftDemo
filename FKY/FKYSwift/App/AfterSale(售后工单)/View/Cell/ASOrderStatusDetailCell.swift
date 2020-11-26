//
//  ASOrderStatusDetailCell.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ASOrderStatusDetailCell: UITableViewCell {

    fileprivate lazy var asTypeNameL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
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
       contentView.addSubview(asTypeNameL)
       asTypeNameL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.centerY.equalTo(contentView)
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }

    func configView(_ model : ASApplyListInfoModel){
        asTypeNameL.text = model.secondTypeName
        //        statusL.text = model!.statusCode
    }


}
