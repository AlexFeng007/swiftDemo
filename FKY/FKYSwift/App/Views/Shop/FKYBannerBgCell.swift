//
//  FKYBannerBgCell.swift
//  FKY
//
//  Created by hui on 2018/11/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYBannerBgCell: UICollectionViewCell {
    // MARK: - Property
    // 轮播视图
    fileprivate lazy var cycleView: SDCycleScrollView = {
        let cycle = SDCycleScrollView ()
        cycle.showPageControl = true
        cycle.pageControlDotSize = CGSize(width: 10, height: 2)
        cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycle.currentPageDotImage = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 10, height: 2))
        cycle.pageDotImage = UIImage.imageWithColor(RGBAColor(0xFFFFFF, alpha: 0.5), size: CGSize.init(width: 10, height: 2))
        cycle.autoScroll = true
        cycle.delegate = self
        cycle.layer.masksToBounds = true
        cycle.layer.cornerRadius =  WH(5)
        return cycle
    }()
    
    fileprivate lazy var bgImageView: UIView = {
        let view = UIView()
        let finalSize = CGSize(width: SCREEN_WIDTH, height: 92)
        let layerHeight = finalSize.height * 0.4
        let layer = CAShapeLayer()
        let bezier = UIBezierPath() 
        bezier.move(to: CGPoint(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint(x: 0, y: finalSize.height - layerHeight),
                            controlPoint: CGPoint(x: finalSize.width / 2, y: finalSize.height))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH).cgColor
        view.layer.addSublayer(layer)
        return view
    }()
    var selectedBannerClosure: ((String,Int)->(Void))? //精选店回调
    var selecteHomeBannerClosure : ((HomeCircleBannerItemModel ,Int)->(Void))? //中药材回调
    fileprivate var banners:[Any]?
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:UI布局
    func setupView() {
        self.backgroundColor = UIColor.white
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(WH(92))
        }
        self.layoutIfNeeded()
        // 背景圆形渐变图
        let roundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        roundView.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth:Float(SCREEN_WIDTH))
        contentView.addSubview(roundView)
        roundView.snp.makeConstraints { (make) in
            make.height.equalTo(SCREEN_HEIGHT)
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(160))
            make.centerX.equalTo(contentView)
        }
        contentView.addSubview(cycleView)
        cycleView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(17))
            make.right.equalTo(contentView).offset(-WH(17))
            make.top.equalTo(contentView).offset(WH(8))
            make.height.equalTo(WH(160))
        }
    }
}
extension FKYBannerBgCell : SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let closure = self.selectedBannerClosure, let banner = self.banners?[index] as? HomeBannerModel {
            if let schema = banner.schema ,schema.count > 0 {
                closure(banner.schema!,index)
            }
        } else if let closure = self.selecteHomeBannerClosure, let banner = self.banners?[index] as? HomeCircleBannerItemModel {
            closure(banner,index)
        }
    }
    //中药材录播图
    func configNewMedicineListCell(_ banners: [HomeCircleBannerItemModel]?){
        if let ban = banners {
            self.banners = banners!
            self.cycleView.imageURLStringsGroup = ban.map({$0.imgPath!})
        }else{
            self.cycleView.imageURLStringsGroup = []
        }
    }
    //店铺馆列表轮播图
    func configShopListCell(_ banners: [HomeBannerModel]?){
        if let ban = banners {
            self.banners = banners!
            self.cycleView.imageURLStringsGroup = ban.map({$0.imgUrl!})
        }else{
            self.cycleView.imageURLStringsGroup = []
        }
    }
    
}

