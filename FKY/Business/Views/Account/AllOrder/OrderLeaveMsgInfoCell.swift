//
//  OrderLeaveMsgInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2019/1/3.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
typealias CopyLeaveMsgAction = ()->()

class OrderLeaveMsgInfoCell: UITableViewCell {
    @objc var copyMsgAction : CopyLeaveMsgAction? //复制留言
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate var titleLabel : UILabel?
    fileprivate var detailLabel : UILabel?
    fileprivate var copyButton : UILabel?
    fileprivate func setupView() -> () {
        titleLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(j1)
                make.top.equalTo(self.contentView).offset(WH(13))
            })
            view.font = UIFont.systemFont(ofSize: WH(13))
            view.textColor = RGBColor(0x909090)
            view.text = "卖家留言"
            return view
        }()
        copyButton = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView).offset(WH(-11))
                make.width.equalTo(WH(40))
                make.bottom.equalTo(self.contentView).offset(WH(-18))
            })
            view.isUserInteractionEnabled = true
            view.sizeToFit()
            view.font = UIFont.boldSystemFont(ofSize: WH(13))
            view.textAlignment = .right
            view.attributedText = self.copyAttributeString()
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
                if let clouser = self?.copyMsgAction {
                     clouser()
                }
            }).disposed(by: disposeBag)
            view.addGestureRecognizer(tapGesture)
            return view
        }()
        
        detailLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in  
                make.left.equalTo(self.contentView.snp.left).offset(j1)
                make.top.equalTo(self.titleLabel!.snp.bottom).offset(WH(10))
                make.right.equalTo(self.copyButton!.snp.left)
            })
            view.font = t8.font
            view.textColor = t8.color
            view.numberOfLines = 0
            view.lineBreakMode = .byWordWrapping
            return view
        }()

        let line = UIView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.right.equalTo(self.contentView).offset(-j1)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(lineHeight)
        }
        line.backgroundColor = m2
    }
    fileprivate func copyAttributeString() -> (NSMutableAttributedString) {
        let freightTmpl = NSMutableAttributedString()
        
        var freightStr = NSAttributedString(string:"|")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x333333),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        
        freightStr = NSAttributedString(string:" 复制")
        freightTmpl.append(freightStr)
        freightTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: RGBColor(0x3F7FDC),
                                 range: NSMakeRange(freightTmpl.length - freightStr.length, freightStr.length))
        return freightTmpl
    }
    @objc func configCell(_ msgStr : String) -> () {
        self.detailLabel!.text =  msgStr
    }

}
