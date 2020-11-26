//
//  HomeAdContentCell.swift
//  FKY
//
//  Created by 寒山 on 2019/3/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 广告类型cell

import UIKit

class HomeAdContentCell: UITableViewCell {

    var touchItem: emptyClosure? // 商详
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    // 广告图片
    public lazy var imgView: UIImageView = {
        let iv = UIImageView()
        //iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    public lazy var selectedBtn: UIButton = {
        let iv = UIButton()
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(imgView)
        bgView.addSubview(selectedBtn)
       
        bgView.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView).offset(WH(-10))
            make.left.top.equalTo(contentView).offset(WH(10))
            make.bottom.equalTo(contentView);
        })
        imgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(bgView)
        })
        selectedBtn.snp.makeConstraints({ (make) in
            make.edges.equalTo(bgView)
        })
        _ = selectedBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.touchItem {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    func  configCell(_ model: HomeADInfoModel){
        let imgDefault = getBannerDefaultImg()
        if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: imgDefault)
        }
    }
    fileprivate func getBannerDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - 20)*193/355.0))
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
