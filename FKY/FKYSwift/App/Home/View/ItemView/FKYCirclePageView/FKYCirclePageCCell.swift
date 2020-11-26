//
//  FKYCirclePageCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  轮播ccell

import UIKit

class FKYCirclePageCCell: UICollectionViewCell {
    // MARK: - Property
    
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.layer.masksToBounds = true
        imgview.layer.cornerRadius = WH(4.0)
        imgview.clipsToBounds = true
        return imgview
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
        backgroundColor = UIColor.white
        contentView.addSubview(imgviewPic)
        imgviewPic.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ imgUrl: String?) {
        let imgDefault = getBannerDefaultImg()
        if let url = imgUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            imgviewPic.sd_setImage(with: URL.init(string: url), placeholderImage: imgDefault)
        }
        else {
            imgviewPic.image = imgDefault
        }
    }
    
    
    // MARK: - Private
    
    fileprivate func getBannerDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - 20)*110/355.0))
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4.0)
        
        let imgview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: WH(120), height: WH(31)))
        imgview.image = UIImage.init(named: "icon_home_banner")
        imgview.contentMode = .scaleAspectFit
        imgview.center = view.center
        view.addSubview(imgview)
        
        // 调整屏幕密度（缩放系数）
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let contextRef = UIGraphicsGetCurrentContext() {
             view.layer.render(in: contextRef)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imgFinal = img {
            return imgFinal
        }
        else {
            return UIImage.init(named: "banner-placeholder")!
        }
    }
}
