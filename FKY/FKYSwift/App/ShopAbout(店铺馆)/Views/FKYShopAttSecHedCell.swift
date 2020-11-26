//
//  FKYShopAttSecHedCell.swift
//  FKY
//
//  Created by yyc on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopAttSecHedCell: UITableViewCell {
    
    fileprivate lazy var titleView : FKYShopAttHeadView = {
        let view = FKYShopAttHeadView()
        view.clickViewBlock = { [weak self] type in
            if let strongSelf = self  {
                if let block = strongSelf.clickViewBlock {
                    block(1)
                }
            }
        }
        return view
    }()
    var clickViewBlock : ((Int)->(Void))?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(contentView)
            make.left.equalTo(contentView.snp.left).offset(WH(10))
        }
    }
    
    func configSectionHeadView() {
        titleView.resetShopAttentionHeadView(2)
    }
}
