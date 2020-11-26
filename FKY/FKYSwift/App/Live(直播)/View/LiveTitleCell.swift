//
//  LiveTitleCell.swift
//  FKY
//
//  Created by yyc on 2020/9/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveTitleCell: UITableViewCell {

    //
    fileprivate lazy var livePrdTitleabel: UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = t33.font
        label.text = "好物抢先看"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.contentView.addSubview(livePrdTitleabel)
        livePrdTitleabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView.snp.left).offset(WH(10))
        }
    }
}
