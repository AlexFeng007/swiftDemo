//
//  SearchShopInfoHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  搜索顶部店铺信息

import UIKit

class SearchShopInfoHeadView: UIView {
    var gotoShopAction: emptyClosure?//进入店铺
    //背景视图
    //  头边状态 和渐变
    fileprivate var bgView: UIView = {
        let gradientColors: [CGColor] = [RGBAColor(0xFFB088, alpha: 0.22).cgColor,RGBAColor(0xFD61B4, alpha: 0.22).cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.masksToBounds = true
        gradientLayer.borderColor = RGBAColor(0xFF2D5C, alpha: 0.22).cgColor
        gradientLayer.borderWidth = 0.5
        gradientLayer.cornerRadius = WH(4)
        
        //设置frame和插入view的layer
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(10), height: WH(66)))
        headView.backgroundColor = UIColor.clear
        gradientLayer.frame = headView.bounds
        headView.layer.insertSublayer(gradientLayer, at: 0)
        return headView
    }()
    
    //店铺名称
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = t73.font
        label.textColor = t7.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    // 收藏按钮
    fileprivate lazy var shopBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = t33.font
        btn.setTitle("进店", for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.backgroundColor = RGBColor(0xFFFFFF)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(13)
        btn.isEnabled = false
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            guard let block = strongSelf.gotoShopAction else {
//                return
//            }
//            block()
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // loading子视图
    fileprivate lazy var loadingItemView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.init(style: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    lazy var tagsContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    //专区描述字段
    fileprivate var desLabel: UILabel = {
        let label = UILabel()
        //label.isHidden = true
        label.fontTuple = t3
        label.font = t29.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        shopBtn.isHidden = true
        self.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(WH(5))
            make.right.equalTo(self.snp.right).offset(WH(-5))
            make.top.equalTo(self.snp.top).offset(WH(13))
            make.bottom.equalTo(self.snp.bottom).offset(WH(-10))
        })
        
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(14))
            make.top.equalTo(bgView.snp.top).offset(WH(13))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(WH(200))
        })
        
        bgView.addSubview(shopBtn)
        shopBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView.snp.right).offset(-WH(18))
            make.centerY.equalTo(bgView.snp.centerY)
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(61))
        })
        
        
        
        bgView.addSubview(tagsContentView)
        tagsContentView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(62))
        }
        
        bgView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(tagsContentView.snp.centerY)
            make.left.equalTo(tagsContentView.snp.right).offset(WH(6))
        }
        bgView.addSubview(self.loadingItemView)
        self.loadingItemView.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        self.loadingItemView.startAnimating()
    }
}
extension SearchShopInfoHeadView {
    //店铺首页section的头视图
    func configShopMainHeadViewData(_ baseModel : SearchShopInfoModel?){
        self.loadingItemView.stopAnimating()
        if let model = baseModel {
            //自营店铺信息
            shopBtn.isHidden = false
            desLabel.isHidden = false
            titleLabel.text = model.enterpriseName ?? ""
            var desStr = ""
            if model.sendThreshold != nil{
                desStr = "\(model.sendThreshold ?? "")元起送"
            }
            
            if model.freeShippingThreshold != nil {
                desStr = desStr  + " \(model.freeShippingThreshold ?? "")元包邮"
            }
            desLabel.text = desStr
            //动态添加tag
            _ = tagsContentView.subviews.map {
                $0.removeFromSuperview()
            }
            
            var tips = [String]()
            var tagImgView: UIImageView? = nil
            
            if let isZY = model.isSelfShop, isZY == 1 {
                if let houseName = model.storeName, houseName.isEmpty == false {
                    if let image = FKYSelfTagManager.shareInstance.tagNameImageForSearch(tagName: houseName, colorType: .red,font:UIFont.boldSystemFont(ofSize: WH(10))) {
                        tagImgView = UIImageView(image: image)
                        tagsContentView.addSubview(tagImgView!)
                        tagImgView!.snp.makeConstraints { (make) in
                            make.centerY.equalTo(tagsContentView)
                            make.left.equalTo(tagsContentView)
                        }
                    }else {
                        tips.append("自营")
                    }
                }else {
                    tips.append("自营")
                }
            }
            var lastTipLabel: UILabel?
            for (index, tip) in tips.enumerated() {
                let width = tip.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t28.font], context: nil).size.width + WH(12)
                
                let label = configLabelTip(tip)
                if let isZY = model.isSelfShop, isZY == 1, index == 0, tagImgView == nil {
                    label.backgroundColor = t73.color
                    label.textColor = t1.color
                } else {
                    label.textColor = t73.color
                }
                tagsContentView.addSubview(label)
                label.snp.makeConstraints { (make) in
                    make.centerY.equalTo(tagsContentView)
                    make.height.equalTo(WH(16))
                    make.width.equalTo(width)
                    if lastTipLabel != nil {
                        make.left.equalTo(lastTipLabel!.snp.right).offset(WH(5))
                    }else {
                        if tagImgView != nil {
                            make.left.equalTo(tagImgView!.snp.right).offset(WH(5))
                        }else {
                            make.left.equalTo(tagsContentView)
                        }
                        
                    }
                }
                
                lastTipLabel = label
            }
            
        }
    }
    
    //创建tag label
    func configLabelTip(_ tip: String) -> UILabel {
        let label = UILabel()
        label.text = tip
        label.font = t28.font
        label.layer.borderColor = t73.color.cgColor
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        return label
    }
}
