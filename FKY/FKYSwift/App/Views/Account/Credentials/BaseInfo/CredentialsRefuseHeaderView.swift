//
//  CredentialsRefuseHeaderView.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class CredentialsRefuseHeaderView: UICollectionReusableView {
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupView()
    }
    
    fileprivate var titleLable:UILabel?
    fileprivate var contentLable:UILabel?
    fileprivate var bottomSeparator: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        titleLable = {
            let lable = UILabel()
            self.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.top.equalTo(self)
                make.height.equalTo(WH(h8))
            })
            lable.fontTuple = t24
            return lable
        }()
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j1)
            make.right.equalTo(self.snp.right).offset(-j1)
            make.top.equalTo(self.titleLable!.snp.bottom)
            make.height.equalTo(1)
        }
        line.backgroundColor = bg2
        contentLable = {
            let lable = UILabel()
            self.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(WH(j1))
                make.top.equalTo(line.snp.bottom).offset(j1)
                make.right.equalTo(self).offset(-j1)
//                make.height.equalTo(WH(h8))
            })
            lable.fontTuple = t31
            lable.numberOfLines = 0
            return lable
        }()
        
        bottomSeparator = {
            let line = UIView()
            self.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.bottom.right.left.equalTo(self)
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
//        self.contentLable?.text = content
    }
}
