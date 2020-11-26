//
//  HomeSearchView.swift
//  FKY
//
//  Created by Rabe on 08/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class HomeSearchView: UIView {
    // MARK: - properties
    fileprivate lazy var searchTextLabel: UILabel! = {
        let label = UILabel()
        label.text = HomeString.SEARCH_BAR_TEXT
        label.font = FontConfig.font14
        label.textColor = ColorConfig.color999999
        return label
    }()
    
    lazy var searchImageView: UIImageView! = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: HomeString.SEARCH_BAR_SEARCH_ICON_IMGNAME)
        return imgView
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ui
    func setupView() {
        layer.cornerRadius = WH(HomeConstant.HOME_SEARCH_ITEM_VIEW_HEIGHT)/2.0
        
        addSubview(searchTextLabel)
        addSubview(searchImageView)
        
        searchImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(searchTextLabel.snp.left).offset(WH(-7))
        }
        searchTextLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(WH(12.5))
        }
    }
}

// MARK: - delegates
extension HomeSearchView {
    
}

// MARK: - action
extension HomeSearchView {
    
}

// MARK: - data
extension HomeSearchView {
    
}

// MARK: - private methods
extension HomeSearchView {
    
}
