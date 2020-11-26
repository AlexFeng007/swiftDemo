//
//  ExpiredMessageInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/2/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class ExpiredMessageInfoCell: UITableViewCell {
    //时间显示区域
    fileprivate lazy var timeLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = t31.font
        view.textAlignment = .left
        view.textColor = ColorConfig.color999999
        view.text = "2020-01-01 14:47:50"
       // view.backgroundColor = UIColor.blue
        return view
    }()
    //文件和描述区域
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()

    
    //资质图
    fileprivate lazy var fileImageView: UIImageView! = {
        let img = UIImageView()
        return img
    }()
    
    fileprivate lazy var tipTitleLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.boldSystemFont(ofSize: WH(16))
        view.textAlignment = .left
        view.textColor = ColorConfig.color333333
        view.text = "您的证照即将过期"
        return view
    }()
    fileprivate lazy var tipLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.systemFont(ofSize: WH(12))
        view.textAlignment = .left
        view.textColor = ColorConfig.color666666
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
       // view.backgroundColor = UIColor.red
        view.text = "您的食品经营许可证将于2020-01-31（30天后）过期。证照过期后，1药城将不会为您发货。请及时更新证照，以免影响采购。 去更新>>"
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(timeLb)
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(fileImageView)
        contentBgView.addSubview(tipTitleLb)
        contentBgView.addSubview(tipLb)
        
        timeLb.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(11))
            make.height.equalTo(WH(14))
        })
        
        contentBgView.snp.makeConstraints({ (make) in
            make.top.equalTo(timeLb.snp.bottom).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.bottom.equalTo(contentView)
        })
        
        fileImageView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(contentBgView)
            make.height.equalTo(WH(155))
        })
        
        tipTitleLb.snp.makeConstraints({ (make) in
            make.top.equalTo(fileImageView.snp.bottom).offset(WH(15))
            make.left.equalTo(contentBgView).offset(WH(15))
            make.right.equalTo(contentBgView).offset(WH(-15))
            make.height.equalTo(WH(16))
        })
        
        tipLb.snp.makeConstraints({ (make) in
            make.top.equalTo(tipTitleLb.snp.bottom).offset(WH(9))
            make.left.equalTo(contentBgView).offset(WH(15))
            make.right.bottom.equalTo(contentBgView).offset(WH(-15))
            
        })
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configCell(_ model:ExpiredTipsInfoModel) {
        tipLb.attributedText = ExpiredMessageInfoCell.getExpiredContentAttrStr(model)
        tipTitleLb.text = model.title ?? ""
        timeLb.text = model.showTime ?? ""
        if let picUrl = model.imgUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let fileUrl = URL(string: picUrl ) {
            self.fileImageView.sd_setImage(with: fileUrl , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.fileImageView.image = UIImage.init(named: "image_default_img")
        }
        self.layoutIfNeeded()
    }
    static func calculateHeight(_ model:ExpiredTipsInfoModel) -> CGFloat {
        let attributedText = ExpiredMessageInfoCell.getExpiredContentAttrStr(model)
        let contentSize = attributedText.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(50), height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
        var contentHeight = contentSize.height + 1
        contentHeight  += WH(245)
        return contentHeight
    }
    //selfHouseName自营仓名
    static func getExpiredContentAttrStr(_ model:ExpiredTipsInfoModel) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString(string: model.content ?? "", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))])
        let firstrange: NSRange? = (attributedStrM.string as NSString).range(of: "请及时更新证照，以免影响1药城为您发货。")
        let secnodRange: NSRange? = (attributedStrM.string as NSString).range(of: "证照过期后，1药城将不会为您发货。")
        if firstrange != nil && firstrange?.location != NSNotFound {
            attributedStrM.addAttribute(.foregroundColor, value: RGBColor(0xFF2D5C), range: firstrange!)
        }else if secnodRange != nil && secnodRange?.location != NSNotFound {
            attributedStrM.addAttribute(.foregroundColor, value: RGBColor(0xFF2D5C), range: secnodRange!)
        }
        return  attributedStrM
    }
    
    
    // self.layoutIfNeeded()
    // contentLayer.frame =  CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: (ProductInfoListCell.getCellContentHeight(model) - WH(10)))
}
