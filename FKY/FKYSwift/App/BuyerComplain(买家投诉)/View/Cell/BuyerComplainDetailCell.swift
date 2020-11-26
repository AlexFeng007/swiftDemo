//
//  BuyComplainDetailCell.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class BuyComplainDetailCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var titleLabel : UILabel?
    fileprivate var detailLabel : UILabel?
    
    fileprivate func setupView() -> () {
        
        titleLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(WH(30))
                make.top.equalTo(self.contentView).offset(WH(20))
            })
            view.font = UIFont.systemFont(ofSize: WH(13))
            view.textColor = RGBColor(0x333333)
            return view
        }()

        detailLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(WH(30))
                make.right.equalTo(self.contentView.snp.right).offset(WH(-30))
                make.top.equalTo((self.titleLabel?.snp.bottom)!).offset(WH(14))
            })
            view.font = t8.font
            view.textColor = t8.color
            view.numberOfLines = 0
            view.lineBreakMode = .byWordWrapping
            return view
        }()
    }
    func configCell(_ model: ComplainDetailInfoModel? , _ index: Int) -> () {
        if index == 0 {
            //投诉详情
            titleLabel?.text =  "投诉详情"
            self.detailLabel!.text = model!.complaintContent
        }else if index == 1{
            //商家解释
            titleLabel?.text =  "商家解释"
            self.detailLabel!.text = model!.complaintSellerReply
        }else if index == 2{
            //平台处理结果
            titleLabel?.text =  "平台处理结果"
            self.detailLabel!.text = model!.complaintPlatformReply
        }
    }
}
