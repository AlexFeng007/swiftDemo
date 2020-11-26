//
//  FKYPrdHeaderView.swift
//  FKY
//
//  Created by yyc on 2020/11/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYPrdHeaderView: UITableViewHeaderFooterView {

    // 标题视图
    fileprivate lazy var viewTitle: FKYRecommendTitleView! = {
        let view = FKYRecommendTitleView.init(frame: CGRect.zero)
        view.resetLayoutForShopPromotionHeaderView()
        view.backgroundColor = RGBColor(0xf4f4f4)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        self.setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:UI布局
    func setupView() {
        contentView.addSubview(viewTitle)
        viewTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    func configTitle(_ title : String?)  {
        viewTitle.resetTitleName(title ?? "专区")
    }

}
