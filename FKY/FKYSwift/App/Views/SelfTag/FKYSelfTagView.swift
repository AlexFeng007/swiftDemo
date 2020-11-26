//
//  FKYSelfTagView.swift
//  FKY
//
//  Created by My on 2019/11/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYSelfTagView: UIView {
    
    //tag
    lazy  var tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = RGBColor(0xFFFFFF)
        label.font = FKYSelfTagManager.shareInstance.tagTextFont
        return label
    }()
    
    //仓库名
    lazy  var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FKYSelfTagManager.shareInstance.tagTextFont
        return label
    }()
    
    
    init(frame: CGRect, tag: String, tagWidth: CGFloat, tagName: String, tagNameWidth: CGFloat, color: UIColor, _ borderWidth: CGFloat, _ tagFont:UIFont, _ tagHeight:CGFloat) {
        super.init(frame: frame)
        
        setupViews(tag, tagWidth, tagName, tagNameWidth, color, tagFont)
        addCorners(color,borderWidth,tagHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FKYSelfTagView {
    func setupViews(_ tag: String, _ tagWidth: CGFloat, _ tagName: String, _ tagNameWidth: CGFloat, _ color: UIColor, _ tagFont:UIFont) {
        //backgroundColor = RGBColor(0xFFFFFF)
        self.backgroundColor = UIColor.clear
        tagLabel.text = tag
        tagLabel.backgroundColor = color
        tagLabel.font = tagFont
        
        nameLabel.text = tagName
        nameLabel.textColor = color
        nameLabel.font = tagFont
        
        addSubview(tagLabel)
        addSubview(nameLabel)
        
        tagLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(tagWidth)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(tagLabel.snp_right)
            make.width.equalTo(tagNameWidth)
        }
        
        layoutIfNeeded()
    }
    
    func addCorners(_ color: UIColor, _ borderWidth: CGFloat, _ tagHeight:CGFloat) {
        tagLabel.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.bottomLeft.rawValue), radius: tagHeight/2)
        
        nameLabel.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topRight.rawValue | UIRectCorner.bottomRight.rawValue), radius: tagHeight/2, borderColor: color, borderWidth: borderWidth)
    }
}

class FKYComboMainProductTagView: UIView {
    
    //tag
    lazy  var tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        return label
    }()
    
    init(frame: CGRect, tag: String, tagWidth: CGFloat, color: UIColor, _ borderWidth: CGFloat) {
        super.init(frame: frame)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = FKYComboMainProductFlagManager.shareInstance.tagHeight/2
        setupViews(tag, tagWidth,color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FKYComboMainProductTagView {
    func setupViews(_ tag: String, _ tagWidth: CGFloat, _ color: UIColor) {
        //backgroundColor = RGBColor(0xFFFFFF)
        self.backgroundColor = UIColor.clear
        
        tagLabel.text = tag
        tagLabel.backgroundColor = UIColor.clear
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
     
}

