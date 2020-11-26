//
//  HomeOneAdPageCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeOneAdPageCell: UITableViewCell {
    
    var checkAdBlock: ((Int)->())? //查看广告
    
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 广告图片
    public lazy var imgView: AnimatedImageView = {
        let iv = AnimatedImageView()
        iv.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAdBlock {
                closure(0)
            }
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        iv.backgroundColor = .clear
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(imgView)
        
        bgView.snp.makeConstraints({ (make) in
            make.right.bottom.equalTo(contentView).offset(WH(-10))
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(contentView);
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(bgView)
        })
    }
    
    func  configCell(_ model: HomeADInfoModel) {
        let imgDefault = getBannerDefaultImg()
        if let imageList = model.iconImgDTOList, imageList.isEmpty == false {
            for index in 0..<imageList.count {
                let imgeModel = imageList[index] as HomeBrandDetailModel
                if index == 0 {
                    if let strProductPicUrl = imgeModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                        if strProductPicUrl.lowercased().hasSuffix("gif") {
                            // gif
                            DispatchQueue.global().async {[weak self] in
                                guard let strongSelf = self else {
                                    return
                                }
                                let imageData = NSData(contentsOf: urlProductPic)
                                DispatchQueue.main.async {[weak self] in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    if let gifData = imageData, gifData.length > 0 {
                                        //self.imgView.gifData = gifData
                                        // 解决tableview滑动时Gif动画停止的问题
                                        if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                            strongSelf.imgView.image = img
                                        }
                                        else {
                                            strongSelf.imgView.image = imgDefault
                                        }
                                    }
                                    else {
                                        strongSelf.imgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                                    }
                                }
                            }
                        }
                        else {
                            // 非gif
                            self.imgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func getBannerDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: WH(84)))
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
//MARK:商家特惠
extension HomeOneAdPageCell {
    fileprivate func getPreferentialShopAdDefaultImg() -> UIImage? {
           let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: WH(87)))
           view.backgroundColor = RGBColor(0xF4F4F4)
           view.layer.masksToBounds = true
           view.layer.cornerRadius = WH(8.0)
           
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
    func configPreferentialShopAdView(_ picStr :String?) {
        bgView.snp.remakeConstraints({ (make) in
            make.right.equalTo(self).offset(WH(-10))
            make.left.top.equalTo(self).offset(WH(10))
            make.bottom.equalTo(self);
        })
        let imgDefault = getPreferentialShopAdDefaultImg()
        self.imgView.image = imgDefault
        self.imgView.layer.shadowRadius = WH(0)
        self.imgView.clipsToBounds = true
        self.imgView.layer.cornerRadius = WH(8)
        if let strProductPicUrl = picStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            if strProductPicUrl.lowercased().hasSuffix("gif") {
                // gif
                DispatchQueue.global().async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let imageData = NSData(contentsOf: urlProductPic)
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        if let gifData = imageData, gifData.length > 0 {
                            //self.imgView.gifData = gifData
                            // 解决tableview滑动时Gif动画停止的问题
                            if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                strongSelf.imgView.image = img
                            }
                            else {
                                strongSelf.imgView.image = imgDefault
                            }
                        }
                        else {
                            strongSelf.imgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                        }
                    }
                }
            }
            else {
                // 非gif
                self.imgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
            }
        }
    }
    static func  getCellContentHeight() -> CGFloat{
           return (SCREEN_WIDTH - 20)*84/355.0 + WH(10)
       }
}
