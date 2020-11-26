//
//  FKYShopNoticeCell.swift
//  FKY
//
//  Created by yyc on 2020/10/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 店铺馆公告

import UIKit

class FKYShopNoticeCell: UITableViewCell {

    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    //公告图
    fileprivate lazy var noticeView: UIImageView! = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_notice_mask")
        return img
    }()
    // 情报小站视图
    fileprivate lazy var noticeCircle: FKYSinglePageCircleView! = {
        let view = FKYSinglePageCircleView.init(frame: CGRect.zero)
        view.initNoticViewConfig()
        view.backgroundColor = UIColor.clear
        view.circleType = .transitionType   // transitionType / scrollType
        view.autoScrollTimeInterval = 3
        if view.circleType == .scrollType {
            view.msgWidth = SCREEN_WIDTH - j7 * 2
            view.msgHeight = WH(25)
            view.maxSecitons = 3
            view.userCanScroll = false
        }
        view.isUserInteractionEnabled = true
        view.tapActionCallback = { [weak self] (index, content) in
            // 更新情报小站索引
            if let strongSelf = self {
                if let arr = strongSelf.noticeArr ,let block = strongSelf.clickNoticViewBlock {
                    block(index,arr[index])
                }
            }
        }
        return view
    }()
    
    var noticeArr:[HomePublicNoticeItemModel]? //情报数据
    var clickNoticViewBlock :((Int,HomePublicNoticeItemModel)->(Void))?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
extension FKYShopNoticeCell {
    func setupView() {
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        
        contentView.addSubview(bgView)
        bgView.addSubview(noticeView)
        bgView.addSubview(noticeCircle)
        
        bgView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView).offset(WH(-10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.left.equalTo(contentView).offset(WH(10))
            make.height.equalTo(WH(36))
        })
        
        noticeView.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView.snp.left).offset(WH(10))
            make.width.equalTo(WH(65))
        })
        
        noticeCircle.snp.makeConstraints ({ (make) in
            make.left.equalTo(self.noticeView.snp.right).offset(WH(8))
            make.right.equalTo(bgView.snp.right).offset(-WH(19))
            make.centerY.equalTo(self.noticeView.snp.centerY)
            make.height.equalTo(WH(13))
        })
    }
    // 配置cell
    func configCell(_ noticeList: [HomePublicNoticeItemModel]?) {
        if let arr = noticeList, arr.count > 0{
            self.noticeArr = arr
            var msgDataSource = [String]()
            for  noticeItem in arr {
                msgDataSource.append(noticeItem.title!)
            }
            noticeCircle.currentIndex = 0
            noticeCircle.msgDataSource = msgDataSource
        }
    }
}
