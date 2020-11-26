//
//  CredentialsRefuseSectionView.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class CredentialsRefuseSectionView: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    fileprivate var titleLable:UILabel?
    fileprivate var contentLable:UILabel?
    fileprivate var bottomSeparator: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        titleLable = {
            let lable = UILabel()
            contentView.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset(WH(j1))
                make.top.equalTo(contentView)
                make.height.equalTo(WH(h8))
            })
            lable.fontTuple = t24
            return lable
        }()
        let line = UIView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(j1)
            make.right.equalTo(contentView.snp.right).offset(-j1)
            make.top.equalTo(self.titleLable!.snp.bottom)
            make.height.equalTo(1)
        }
        line.backgroundColor = bg2
        contentLable = {
            let lable = UILabel()
            contentView.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset(WH(j1))
                make.top.equalTo(line.snp.bottom).offset(j1)
                make.right.equalTo(contentView).offset(-j1)
//                make.height.equalTo(WH(h8))
            })
            lable.fontTuple = t31
            lable.numberOfLines = 0
            return lable
        }()
        
        bottomSeparator = {
            let line = UIView()
            contentView.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.bottom.right.left.equalTo(contentView)
                make.height.equalTo(h1)
            }
            line.backgroundColor = bg2
            return line
        }()
        
    }
    
    func configCell(_ title:String,content:String?) {
        self.titleLable?.text = title
        if let txt = content {
            var str = txt as NSString
            if str.length > 50 {
                str = str.substring(to: 49) as NSString
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = WH(10)
            paragraphStyle.alignment = .left
            let attrs = [NSAttributedString.Key.foregroundColor: t31.color,NSAttributedString.Key.font: t31.font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            self.contentLable?.attributedText = NSAttributedString(string: (str as String), attributes: attrs)
        }
    }
}
