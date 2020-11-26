//
//  FKYHomePageProductTagItem.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageProductTagItem: UICollectionViewCell {
    lazy var tagLB:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(10))
        lb.layer.cornerRadius = WH(16/2.0)
        lb.layer.masksToBounds = true
        lb.textAlignment = .center
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

//MARK: - 数据展示
extension FKYHomePageProductTagItem{
    func showTestData(){
        tagLB.text = "1起购  "
        configColor(bgColor: RGBColor(0xFF2D5C), textColor: RGBColor(0xFFFFFF))
    }
    
    func configItemData(displayType:Int,tagText:String){
        tagLB.text = "\(tagText)  "
        // 特价-1  VIP-2  TIP-3 其他-4
        if displayType == 1 {
            disPlayType1()
        }else if displayType == 2{
            disPlayType2()
        }else if displayType == 3 {
            disPlayType3()
        }else if displayType == 4{
            disPlayType4()
        }
    }
}

//MARK: - UI
extension FKYHomePageProductTagItem{
    func setupUI(){
        contentView.addSubview(tagLB)
        
        tagLB.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(16))
        }
    }
    
    func configColor(bgColor:UIColor,textColor:UIColor){
        tagLB.backgroundColor = bgColor
        tagLB.textColor = textColor
    }
    
    func disPlayType1(){
        configColor(bgColor: RGBColor(0xFF2D5C), textColor: RGBColor(0xFFFFFF))
    }
    
    func disPlayType2(){
        configColor(bgColor: UIColor.gradientLeftToRightColor(RGBColor(0x566771), RGBColor(0x182F4C), WH(40)), textColor: RGBColor(0xFFDEAE))
        tagLB.layer.borderWidth = WH(0)
    }
    
    func disPlayType3(){
        configColor(bgColor: RGBColor(0xFFEDE7), textColor: RGBColor(0xFF2D5C))
        tagLB.layer.borderWidth = WH(0)
    }
    
    func disPlayType4(){
        configColor(bgColor: RGBColor(0xFFFFFF), textColor: RGBColor(0xFF2D5C))
        tagLB.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        tagLB.layer.borderWidth = WH(1)
    }
}
