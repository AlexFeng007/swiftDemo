//
//  FKYEnterBaseInfoTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/11/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYEnterBaseInfoTableViewCell: UITableViewCell {
    //MARK:ui属性
    //标题
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = t61.font
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingMiddle
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.fontTuple =  t8
        label.numberOfLines = 0
        return label
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(83))
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(15))
            make.height.greaterThanOrEqualTo(WH(13))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(15))
        })
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.top.equalTo(contentLabel.snp.top).offset(WH(1.5))
            make.height.equalTo(WH(13))
            make.width.equalTo(WH(55))
        })
    }
    func configEnterBaseInfo(_ titleStr:String, _ contentStr:String, _ isNeedHTMLTag:Bool = false) {
        if contentStr.isEmpty == true{
            self.titleLabel.isHidden = true
            self.contentLabel.isHidden = true
        }else{
            self.titleLabel.isHidden = false
            self.contentLabel.isHidden = false
        }
        self.titleLabel.text = titleStr
        self.contentLabel.text = contentStr
        self.contentLabel.textColor = RGBColor(0x666666)
        self.backgroundColor = RGBColor(0xFFFFFF)
        
        if isNeedHTMLTag == true{
            //标题和内容一行的样式
            let contentAttStr = contentStr.fky_getAttributedHTMLStringWithLineSpace(WH(5))
            var lineSpace = WH(0)
            if let content_w = contentAttStr?.boundingRect(with: CGSize(width: SCREEN_WIDTH-round(WH(14))-round(WH(14)), height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil).width {
                if content_w > WH(18) {
                    lineSpace = WH(5)
                }
            }
            contentAttStr?.yy_setLineSpacing(lineSpace, range: NSMakeRange(0, contentAttStr?.length ?? 0))
            self.contentLabel.attributedText = contentAttStr
            //self.contentLabel.font = t31.font
        }
    }
    
    func configTextColor(color:UIColor) {
        self.contentLabel.textColor = color
    }

}
