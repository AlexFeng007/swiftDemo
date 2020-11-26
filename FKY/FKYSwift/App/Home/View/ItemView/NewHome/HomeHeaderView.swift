//
//  HomeHeaderView.swift
//  FKY
//
//  Created by 寒山 on 2019/3/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 icon 和banner

import UIKit

class HomeHeaderView: UIView {
    var bannerData:HomeCircleBannerModel?
    var iconData:HomeFucButtonModel?
    // banner View
    public lazy var bannerView: HomeCircleBannerView = {
        let view = HomeCircleBannerView ()
        return view
    }()
    // icon View
    
    public lazy var iconView: HomeFucButtonView = {
        let view = HomeFucButtonView ()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bg1
        self.addSubview(bannerView)
        self.addSubview(iconView)
        bannerView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(WH(10) + (SCREEN_WIDTH - 20)*110/355.0)
        })
        iconView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(bannerView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(WH(102))
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configContent(_ list :[HomeTemplateModel]){
        for content  in list  {
            if content.type == .navigation014 {
                self.iconData = (content.contents as! HomeFucButtonModel)
                self.iconView.configCell(fucBtModel: self.iconData)
            }else if content.type == .banner001{
                self.bannerData = (content.contents as! HomeCircleBannerModel)
                bannerView.bindModel(self.bannerData!)
            }
        }
    }
}
