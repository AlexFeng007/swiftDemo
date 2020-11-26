//
//  RIImageEmptyCRView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/11.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之底部空态视图...<section-footer>

import UIKit

class RIImageEmptyCRView: UICollectionReusableView {
    // MARK: - Property
    
    
    
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
        
    }
    
    
    // MARK: - Public
    
    //
    func configView() {
        
    }
}
