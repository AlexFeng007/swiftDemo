//
//  HomeThreeAdPageCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeThreeAdPageCell: UITableViewCell {
    
    var checkAdBlock :((Int)->())? //查看广告
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //view.layer.masksToBounds = true
        // view.layer.cornerRadius = WH(4)
        return view
    }()
    
    // 广告图片
    public lazy var imgView: AnimatedImageView = {
        let iv = AnimatedImageView()
        iv.isUserInteractionEnabled = true
        // shadowCode
        //        iv.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5).cgColor
        //        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        //        iv.layer.shadowOpacity = 1
        //        iv.layer.shadowRadius = 4
        //        iv.clipsToBounds = false;
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAdBlock {
                closure(0)
            }
        }).disposed(by: disposeBag)
        //        iv.layer.masksToBounds = true
        //        iv.layer.cornerRadius = WH(8)
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    public lazy var secondImgView: AnimatedImageView = {
        let iv = AnimatedImageView()
        iv.isUserInteractionEnabled = true
        // shadowCode
        //        iv.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5).cgColor
        //        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        //        iv.layer.shadowOpacity = 1
        //        iv.layer.shadowRadius = 4
        //        iv.clipsToBounds = false;
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAdBlock {
                closure(1)
            }
        }).disposed(by: disposeBag)
        //        iv.layer.masksToBounds = true
        //        iv.layer.cornerRadius = WH(8)
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    public lazy var thirdImgView: AnimatedImageView = {
        let iv = AnimatedImageView()
        iv.isUserInteractionEnabled = true
        // shadowCode
        //        iv.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5).cgColor
        //        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        //        iv.layer.shadowOpacity = 1
        //        iv.layer.shadowRadius = 4
        //        iv.clipsToBounds = false;
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAdBlock {
                closure(2)
            }
        }).disposed(by: disposeBag)
        //        iv.layer.masksToBounds = true
        //        iv.layer.cornerRadius = WH(8)
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(imgView)
        bgView.addSubview(thirdImgView)
        bgView.addSubview(secondImgView)
        
        let space = (SCREEN_WIDTH - WH(112)*3 - WH(20))/2.0
        
        bgView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView).offset(WH(-10))
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView);
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.height.width.equalTo(WH(112))
            make.top.equalTo(bgView);
            make.left.equalTo(bgView).offset(WH(10))
        })
        
        secondImgView.snp.makeConstraints({ (make) in
            make.height.width.equalTo(WH(112))
            make.top.equalTo(bgView);
            make.left.equalTo(imgView.snp.right).offset(space)
        })
        
        thirdImgView.snp.makeConstraints({ (make) in
            make.height.width.equalTo(WH(112))
            make.top.equalTo(bgView);
            make.left.equalTo(secondImgView.snp.right).offset(space)
        })
    }
    
    func  configCell(_ model: HomeADInfoModel){
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
                else if index == 1 {
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
                                        //self.secondImgView.gifData = gifData
                                        // 解决tableview滑动时Gif动画停止的问题
                                        if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                            strongSelf.secondImgView.image = img
                                        }
                                        else {
                                            strongSelf.secondImgView.image = imgDefault
                                        }
                                    }
                                    else {
                                        strongSelf.secondImgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                                    }
                                }
                            }
                        }
                        else {
                            // 非gif
                            self.secondImgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                        }
                    }
                }
                else if index == 2 {
                    if let strProductPicUrl = imgeModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                        if  strProductPicUrl.lowercased().hasSuffix("gif") {
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
                                        //self.thirdImgView.gifData = gifData
                                        // 解决tableview滑动时Gif动画停止的问题
                                        if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                            strongSelf.thirdImgView.image = img
                                        }
                                        else {
                                            strongSelf.thirdImgView.image = imgDefault
                                        }
                                    }
                                    else {
                                        strongSelf.thirdImgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                                    }
                                }
                            }
                        }
                        else {
                            // 非gif
                            self.thirdImgView.sd_setImage(with: urlProductPic, placeholderImage: imgDefault)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func getBannerDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: WH(112), height: WH(112)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4.0)
        
        let imgview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: WH(112), height: WH(112)))
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
    static func  getCellContentHeight() -> CGFloat{
        return WH(122)
    }
}
