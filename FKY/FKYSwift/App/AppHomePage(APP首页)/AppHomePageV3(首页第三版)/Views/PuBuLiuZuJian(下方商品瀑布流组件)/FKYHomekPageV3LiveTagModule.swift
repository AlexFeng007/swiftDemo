//
//  FKYHomekPageV3LiveTagModule.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  直播标签

import UIKit

class FKYHomekPageV3LiveTagModule: UIView {

    lazy var liveIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Home_Page_Live_icon")
        return image
    }()
    
    lazy var liveTitle:UILabel = {
        let lb = UILabel()
        lb.text = "直播中"
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .boldSystemFont(ofSize: WH(12))
        return lb
    }()
    
    lazy var containerView1:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        return view
    }()
    
    lazy var subTitleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: WH(12))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 展示数据
extension FKYHomekPageV3LiveTagModule{
    
    func showTestData(){
        showText(title: "直播中", subTitleText: 123)
    }
    
    func showText(title:String,subTitleText:Int){
        liveTitle.text = title
        subTitleLB.text = "\(subTitleText)观看"
    }
}

//MARK: - UI
extension FKYHomekPageV3LiveTagModule{
    func setupUI(){
        
        backgroundColor = RGBAColor(0x000000, alpha: 0.3)
        
        containerView1.addSubview(liveIcon)
        containerView1.addSubview(liveTitle)
        addSubview(containerView1)
        addSubview(subTitleLB)
        
        liveIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(7))
            make.centerY.equalToSuperview()
            make.width.equalTo(WH(8.6))
            make.height.equalTo(WH(11))
        }
        
        liveTitle.snp_makeConstraints { (make) in
            make.left.equalTo(liveIcon.snp_right).offset(WH(2))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-7))
        }
        
        containerView1.snp_makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        subTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(containerView1.snp_right).offset(WH(6))
            make.right.equalToSuperview().offset(WH(-6))
            make.centerY.equalToSuperview()
        }
    }
    
    /// 设置圆角
    func configDisplayInfo(){
        self.layoutIfNeeded()
        containerView1.setMutiRoundingCorners(WH(8), [.topLeft,.bottomRight])
        self.setMutiRoundingCorners(WH(8), [.topLeft,.bottomRight])
    }
}
