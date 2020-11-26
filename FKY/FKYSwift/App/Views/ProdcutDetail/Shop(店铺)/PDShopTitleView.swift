//
//  PDShopTitleView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class PDShopTitleView: UIView {
    // MARK: - Property
    
    // 进入店铺回调
    var shopDetailClosure: (()->())?
    
    // icon
    fileprivate lazy var imgviewIcon: UIImageView = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "icon_shop")
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    // 详情btn...<商品优惠券与优惠券码不可同时使用的提示>
    fileprivate lazy var btnDetail: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitle("进入店铺", for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.setTitleColor(UIColor.init(red: 125.0/255, green: 35.0/255, blue: 51.0/255, alpha: 1), for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(14))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.shopDetailClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 名称
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        //lbl.text = "广东壹号药业有限公司"
        return lbl
    }()
    
    // 数量
    fileprivate lazy var lblNumber: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.adjustsFontSizeToFitWidth = true
        //lbl.text = "上架商品123456种"
        return lbl
    }()
    
    // 数量
   fileprivate lazy var lblStoreDesc: UILabel = {
       let lbl = UILabel(frame: .zero)
       lbl.backgroundColor = .clear
       lbl.font = UIFont.systemFont(ofSize: WH(12))
       lbl.textAlignment = .left
       lbl.textColor = RGBColor(0x666666)
       //lbl.text = "上架商品123456种"
       return lbl
   }()
    
    // 分割线
    lazy var viewLineBottom:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    lazy var selfIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(imgviewIcon)
        imgviewIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.top.equalTo(self).offset(WH(12))
            make.height.width.equalTo(WH(44))
        }

        addSubview(btnDetail)
        btnDetail.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(10))
            make.top.equalTo(self).offset(WH(20))
            make.size.equalTo(CGSize(width: WH(72), height: WH(30)))
        }

        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
            make.right.equalTo(btnDetail.snp.left).offset(-WH(10))
            make.top.equalTo(self).offset(WH(18))
            make.height.equalTo(WH(14))
        }

        addSubview(lblNumber)
        lblNumber.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
            make.right.equalTo(btnDetail.snp.left).offset(-WH(10))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(13))
        }
 
         addSubview(lblStoreDesc)
         lblStoreDesc.snp.makeConstraints { (make) in
           make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
           make.right.equalTo(btnDetail.snp.right)
           make.bottom.equalTo(self).offset(-WH(6))
           make.height.equalTo(WH(14))
       }
        addSubview(selfIcon)
        selfIcon.snp.makeConstraints { (make) in
            make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
            make.centerY.equalTo(lblNumber)
        }

        // 下分隔线
        addSubview(self.viewLineBottom)
        self.viewLineBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Event
    
    // 设置事件
    fileprivate func setupAction() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.shopDetailClosure else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Public
    
    func configView(_ imgUrl: String?, _ shopName: String?, _ productNumber: String?, _ shopModel: FKYProductShopModel?,_ product: FKYProductObject?) {
        // 店铺名称
        lblTitle.text = shopName ?? ""
        // 图片
        let imgDefault = UIImage.init(named: "icon_shop")
        if let imgUrl = imgUrl, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            imgviewIcon.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
        }
        else {
            imgviewIcon.image = imgDefault
        }
        if let shop = shopModel,shop.zhuanquTag == true{
            btnDetail.setTitle("进入专区", for: .normal)
            lblStoreDesc.isHidden = false
            if let shop = shopModel,let storeName = shop.realEnterpriseName,storeName.isEmpty == false{
                lblStoreDesc.text = "由[\(storeName)]负责开票售后服务"
                // 富文本
                let content = "由[\(storeName)]负责开票售后服务"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
                let smallFont = UIFont.systemFont(ofSize: WH(12))
                let bigFont = UIFont.boldSystemFont(ofSize: WH(12))
                let textColor = RGBColor(0x666666)
                let typeColor = RGBColor(0xFF2D5C)
                let range: NSRange = NSMakeRange(1, storeName.count + 2)
                attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
                attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
                lblStoreDesc.attributedText = attributedString
            }
                      
        }else{
            lblStoreDesc.isHidden = true
            btnDetail.setTitle("进入店铺", for: .normal)
        }
        // 商品数量
        if let count = productNumber, count.isEmpty == false {
            lblNumber.text = "上架商品\(count)种"
            // 富文本
            let content = "上架商品\(count)种"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
            let smallFont = UIFont.systemFont(ofSize: WH(13))
            let bigFont = UIFont.systemFont(ofSize: WH(13))
            let textColor = RGBColor(0x666666)
            let typeColor = RGBColor(0xFF2D5C)
            let range: NSRange = NSMakeRange(4, count.count)
            attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
            lblNumber.attributedText = attributedString

            // 居上
            lblTitle.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(WH(18))
            }
            if let shop = shopModel, shop.ziyingTag == true, let houseName = shop.ziyingWarehouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .red) {
                selfIcon.isHidden = false
                selfIcon.image = tagImage
                lblNumber.snp.updateConstraints { (make) in
                    make.left.equalTo(imgviewIcon.snp.right).offset(WH(12) + tagImage.size.width)
                }
            }else {
                selfIcon.isHidden = true
                lblNumber.snp.updateConstraints { (make) in
                    make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
                }
            }
//            if let prdModel = product {
//                if let str = prdModel.shopExtendTag ,str.isEmpty == false {
//                    if prdModel.shopExtendType != 0 , let tagImage = ProductBaseInfoView.getProductHouseImage(prdModel.shopExtendType ,str) {
//                        selfIcon.isHidden = false
//                        selfIcon.image = tagImage
//                        lblNumber.snp.updateConstraints { (make) in
//                            make.left.equalTo(imgviewIcon.snp.right).offset(WH(12) + tagImage.size.width)
//                        }
//                    }else {
//                        selfIcon.isHidden = true
//                        lblNumber.snp.updateConstraints { (make) in
//                            make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
//                        }
//                    }
//                }else {
//                    if let shop = shopModel, shop.ziyingTag == true, let houseName = shop.ziyingWarehouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .red) {
//                        selfIcon.isHidden = false
//                        selfIcon.image = tagImage
//                        lblNumber.snp.updateConstraints { (make) in
//                            make.left.equalTo(imgviewIcon.snp.right).offset(WH(12) + tagImage.size.width)
//                        }
//                    }else {
//                        selfIcon.isHidden = true
//                        lblNumber.snp.updateConstraints { (make) in
//                            make.left.equalTo(imgviewIcon.snp.right).offset(WH(10))
//                        }
//                    }
//                }
//            }
        }
        else {
            selfIcon.isHidden = true
            lblNumber.text = nil
            lblNumber.attributedText = nil
            // 居中
            lblTitle.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(WH(25))
            }
        }
        layoutIfNeeded()
    }
}
