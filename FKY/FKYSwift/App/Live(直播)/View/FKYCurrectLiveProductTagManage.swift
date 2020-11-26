//
//  FKYCurrectLiveProductTagManage.swift
//  FKY
//
//  Created by 寒山 on 2020/9/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCurrectLiveProductTagManage: NSObject {
    
    @objc static let shareInstance = FKYCurrectLiveProductTagManage()
    
    //保存生成的自营仓库image
    var selfTagImages: Dictionary<String, UIImage> = [:]

    //搜索低匹配
    @objc func tagNameImageForLive() -> UIImage? {
        
        //存储key
//        let key = "live" + "currectProduct"
//        if let image = selfTagImages[key] {
//            return image
//        }
    
        let tagView = FKYCurreectLiveTagView(frame: CGRect(x: 0, y: 0, width: WH(48) , height: WH(18)))
        
        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagView.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagView.layer.render(in:ctx)
            tagView.layer.backgroundColor = UIColor.clear.cgColor
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        //selfTagImages[key] = tagImg
        return tagImg
    }
}


class FKYCurreectLiveTagView: UIView {
    
    //讲解中标签
    fileprivate lazy var iconView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xE8FFFD)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x1FC7BC)
        label.backgroundColor = .clear
        label.text = "讲解中"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.width.equalTo(WH(48))
            make.height.equalTo(WH(18))
        }
        layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


