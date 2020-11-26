//
//  RIEmptyCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/11.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之空态ccell

import UIKit

class RIEmptyCCell: UICollectionViewCell {
    // MARK: - Property
    
    
    // (底部)背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        
        contentView.addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(11), left: WH(0), bottom: WH(0), right: WH(0)))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell() {
        //
    }
}
