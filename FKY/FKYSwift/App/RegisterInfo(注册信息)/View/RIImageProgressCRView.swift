//
//  RIImageProgressCRView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之顶部进度视图...<section-header>

import UIKit

class RIImageProgressCRView: UICollectionReusableView {
    // MARK: - Property
    
    // 进度条视图
    fileprivate lazy var viewProgress: RITopProgressView = {
        let view = RITopProgressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(80)))
        view.configView(2)
        return view
    }()
    
    
    // MARK: - LiftCircle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        
        addSubview(viewProgress)
        viewProgress.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0)))
        }
    }
    
    
    // MARK: - Public
    
    //
    func configView() {
        
    }
}
