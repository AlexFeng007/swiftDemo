//
//  FKYMedicineTitleCell.swift
//  FKY
//
//  Created by hui on 2018/11/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMedicineTitleCell: UICollectionViewCell {
    // 标题视图
    fileprivate lazy var viewTitle: FKYRecommendTitleView! = {
        let view = FKYRecommendTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.hideMoreBtn(true)
        return view
    }()
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        viewTitle.title = title ?? "专区"
    }
}
