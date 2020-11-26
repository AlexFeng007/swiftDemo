//
//  FKYShopMainBannerTableViewCell.swift
//  FKY
//
//  Created by yyc on 2019/11/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopMainBannerTableViewCell: UITableViewCell {
    // 轮播视图
    fileprivate lazy var viewBanner: FKYCirclePageView = {
        let view = FKYCirclePageView.init(frame: CGRect(x: WH(10), y: WH(10), width:SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - WH(20))*80/355.0))
        view.autoScroll = true
        view.autoScrollTimeInterval = 2
        view.infiniteLoop = true
        view.infiniteLoopWhenOnlyOne = false
        view.maxSecitons = 100
        // 查看详情
        view.bannerDetailCallback = { [weak self] (index, content)  in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickBannerItem ,let model = content as? FKYShopAdArrModel {
                block(index,model)
            }
        }
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    var clickBannerItem : ((Int,FKYShopAdArrModel)->(Void))?
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor =  bg1
        contentView.addSubview(viewBanner)
        viewBanner.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(10))
        }
    }
    func configShopBannerData(_ adArr:[FKYShopAdArrModel]?){
        if let arr = adArr ,arr.count > 0 {
            self.isHidden = false
            viewBanner.configDataSource(adArr)
        }else {
            self.isHidden = true
            viewBanner.configDataSource(nil)
        }
    }
    //计算高度
    static func configShopBannerCellH() -> CGFloat{
        return (SCREEN_WIDTH - WH(20))*80/355.0 + WH(20)
    }

}
