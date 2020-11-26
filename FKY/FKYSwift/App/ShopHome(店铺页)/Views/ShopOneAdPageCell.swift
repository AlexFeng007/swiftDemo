//
//  ShopOneAdPageCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ShopOneAdPageCell: UITableViewCell {
    var checkAdBlock: ((Int)->())? //查看广告
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //view.layer.masksToBounds = true
        //view.layer.cornerRadius = WH(4)
        return view
    }()
    
    // 广告图片
    public lazy var imgView: AnimatedImageView = {
        let iv = AnimatedImageView()
        iv.isUserInteractionEnabled = true
        // shadowCode
        iv.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5).cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        iv.layer.shadowOpacity = 1
        iv.layer.shadowRadius = 4
        iv.clipsToBounds = false;
        
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
        //        iv.layer.masksToBounds = true
        //        iv.layer.cornerRadius = WH(8)
        iv.backgroundColor = .clear
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
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(bgView)
        bgView.addSubview(imgView)
        
        bgView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(WH(-10))
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
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: WH(87)))
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
    static func  getCellContentHeight() -> CGFloat{
        return (SCREEN_WIDTH - 20)*88/355.0 + WH(10)
    }
}
