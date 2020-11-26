//
//  HomeBannerCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeBannerListCell: UITableViewCell {
    var bannerData:HomeCircleBannerModel?
    
    public lazy var bannerView: HomeCircleBannerView = {
        let view = HomeCircleBannerView ()
        return view
    }()

    
    var cellData:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = .clear
        bannerView.backgroundColor = .clear
        
        self.selectionStyle = .none
        contentView.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(0))
            make.left.right.equalTo(contentView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo((SCREEN_WIDTH - 20)*110/355.0)
            make.bottom.equalToSuperview().offset(WH(-8))
        }
    }
    
    
}

//MARK: - 数据展示
extension HomeBannerListCell{
    
    func configContent(_ model :HomeCircleBannerModel){
        self.bannerData =  model
        bannerView.bindModel(self.bannerData!)
    }
    
    /// 展示数据
    func configCell(cellData:FKYHomePageV3CellModel){
        self.cellData = cellData
        bannerView.configData(banner: self.cellData.cellModel.contents.banners)
    }
    /*
    // 展示测试数据
    func showTestData(){
        bannerView.showTestData()
    }
    */
}
