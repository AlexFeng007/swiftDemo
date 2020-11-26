//
//  FKYHomekPageV3PlayVideoTagModule.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomekPageV3PlayVideoTagModule: UIView {

    lazy var playIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"Home_Page_Play_Video_Tag")
        return image
    }()
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    
//    var containerView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomekPageV3PlayVideoTagModule{
    
    func showTestData(){
        showText(time: "02:29")
    }
    
    /// 展示时长
    /// - Parameter leftTime: 剩余时间，时间戳，单位秒
    func showTime(leftTime:Int){
        let leftSec:Int = leftTime%60
        let leftMin:Int = leftTime/60
        showText(time: String(format: "%02d:%02d", leftMin,leftSec))
    }
    
    func showText(time:String){
        titleLB.text = time
    }
}

//MARK: - UI
extension FKYHomekPageV3PlayVideoTagModule{
    func setupUI(){
//        addSubview(containerView)
        
        backgroundColor = RGBAColor(0x000000, alpha: 0.3)
        addSubview(playIcon)
        addSubview(titleLB)
        
        playIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(9))
            make.centerY.equalToSuperview()
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(9))
        }
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalTo(playIcon.snp_right).offset(WH(3))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-10))
        }
        
    }
    
    /// 设置圆角
    func configDisplayInfo(){
        self.layoutIfNeeded()
        self.setMutiRoundingCorners(WH(8), [.topLeft,.bottomRight])
    }
}
