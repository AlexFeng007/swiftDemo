//
//  FKYHomeBannerCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class HomeBannerCell: UICollectionViewCell, SDCycleScrollViewDelegate {
    //MARK: - Property
    fileprivate lazy var cycleView: SDCycleScrollView = {
        let cycle = SDCycleScrollView ()
        cycle.showPageControl = true
        cycle.pageControlDotSize = CGSize(width: 10, height: 2)
        cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
//        cycle.currentPageDotColor = RGBColor(0xe60012)
//        cycle.pageDotColor = RGBAColor(0xffffff, alpha:0.7)
        cycle.currentPageDotImage = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 10, height: 2))
        cycle.pageDotImage = UIImage.imageWithColor(RGBAColor(0xFFFFFF, alpha: 0.5), size: CGSize.init(width: 10, height: 2))
        cycle.autoScroll = true
        cycle.delegate = self
        return cycle
    }()
    
    fileprivate lazy var activityButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_shop_time"), for: UIControl.State())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if strongSelf.goToActivityClosure != nil {
                strongSelf.goToActivityClosure!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var giftInfoLabel: FKYCornerRadiusLabel = {
        let label = FKYCornerRadiusLabel()
        label.backgroundColor = RGBAColor(0x000000, alpha: 0.65)
        label.textColor = RGBColor(0xFFFFFF)
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    fileprivate var banners:[Any]?
    
    var selectedBannerClosure: SingleStringClosure?
    var selecteHomeBannerClosure : ((HomeCircleBannerItemModel)->(Void))? //
    var goToActivityClosure: emptyClosure?
    
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.contentView.addSubview(cycleView)
        cycleView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        
        self.contentView.addSubview(self.activityButton)
        self.activityButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-WH(10))
            make.height.equalTo(WH(25))
            make.width.equalTo(WH(68))
        })
        
        giftInfoLabel.MaxWidth = SCREEN_WIDTH - WH(5) - WH(-8)
        self.contentView.addSubview(giftInfoLabel)
        giftInfoLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(5))
            make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(WH(-8))
            make.top.equalTo(self.contentView.snp.top).offset(WH(10))
        })
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let closure = self.selectedBannerClosure, let banner = self.banners?[index] as? HomeBannerModel {
            if banner.schema?.count > 0 {
                closure(banner.schema!)
            }
        }
        else if let closure = self.selecteHomeBannerClosure, let banner = self.banners?[index] as? HomeCircleBannerItemModel {
            closure(banner)
        }
    }
    
    func configCellForActivityShop(_ banners: [HomeBannerModel]?,activityButtonHiden:Bool, activityInfo:String?) {
        self.configCell(banners, activityButtonHiden: activityButtonHiden)
        if let s = activityInfo {
            self.giftInfoLabel.isHidden = false
            self.giftInfoLabel.text = s
        }else{
            self.giftInfoLabel.isHidden = true
        }
    }
    
    func configCell(_ banners: [HomeBannerModel]?,activityButtonHiden:Bool) {
        self.activityButton.isHidden = activityButtonHiden
        if let ban = banners {
            self.banners = banners!
            self.cycleView.imageURLStringsGroup = ban.map({$0.imgUrl!})
        }else{
            self.cycleView.imageURLStringsGroup = []
        }
    }
    
    // 店铺馆列表轮播图
    func configShopListCell(_ banners: [HomeBannerModel]?) {
        self.activityButton.isHidden = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius =  WH(5)
        if let ban = banners {
            self.banners = banners!
            self.cycleView.imageURLStringsGroup = ban.map({$0.imgUrl!})
        }else{
            self.cycleView.imageURLStringsGroup = []
        }
    }

}
