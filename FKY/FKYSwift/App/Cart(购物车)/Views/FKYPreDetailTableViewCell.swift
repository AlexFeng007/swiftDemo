//
//  FKYPreDetailTableViewCell.swift
//  FKY
//
//  Created by yyc on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//购物车查看明细cell

import UIKit

class FKYPreDetailTableViewCell: UITableViewCell {
    //MARK:ui属性
    //标题
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font =  t61.font
        label.textColor = t31.color
        return label
    }()
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    //背景阴影
    fileprivate lazy var bgTopView : UIView = {
        let view = UIView()
        view.backgroundColor = bg2
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.contentView.addSubview(bgTopView)
//        bgTopView.snp.makeConstraints({ (make) in
//            make.top.equalTo(self.snp.top)
//            make.width.equalTo(SCREEN_WIDTH - WH(10))
//            make.height.equalTo(31)
//            make.left.equalTo(self.snp.left).offset(WH(5))
//        })
        bgTopView.addSubview(titleLabel)
        bgTopView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(bgTopView.snp.centerY)
            make.right.equalTo(bgTopView.snp.right).offset(-WH(10))
            make.height.equalTo(WH(14))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH/2)
        })
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgTopView.snp.left).offset(WH(11))
            make.centerY.equalTo(bgTopView.snp.centerY)
            make.height.equalTo(WH(13))
            make.width.lessThanOrEqualTo(WH(80))
        })
    }
    
}
extension FKYPreDetailTableViewCell {
    func configPreDetailCellData(_ titleStr:String?,_ contentStr:String?,_ typeIndex:Int) {
        // typeIndex : 1（活动优惠）2(共优惠)
        self.layoutIfNeeded()
        contentLabel.textColor = t31.color
        contentLabel.font = t61.font
        bgTopView.backgroundColor = bg2
        if typeIndex == 0 {
            bgTopView.frame = CGRect.init(x: WH(5), y: 0, width: SCREEN_WIDTH - WH(10), height: WH(31))
            bgTopView.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(0))
            bgTopView.backgroundColor = RGBColor(0xffffff)
        }else if typeIndex == 1 {
            bgTopView.frame = CGRect.init(x: WH(5), y: WH(1), width: SCREEN_WIDTH - WH(10), height: WH(32))
            bgTopView.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), radius: WH(4))
        }else if typeIndex == 2 {
            bgTopView.frame = CGRect.init(x: WH(5), y: WH(-1), width: SCREEN_WIDTH - WH(10), height: WH(32))
            bgTopView.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), radius: WH(4))
            contentLabel.textColor = t73.color
            contentLabel.font = t21.font
        }else if typeIndex == 3 {
            bgTopView.frame = CGRect.init(x: WH(5), y: 0, width: SCREEN_WIDTH - WH(10), height: WH(32))
            bgTopView.fky_addCorners(corners: UIRectCorner(rawValue: UIRectCorner.allCorners.rawValue), radius: WH(0))
        }
        contentLabel.text = "\(contentStr ?? "")"
        titleLabel.text = titleStr
    }
}
