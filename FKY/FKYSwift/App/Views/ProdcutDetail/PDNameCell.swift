//
//  PDNameCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之名称cell

import UIKit

class PDNameCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblName: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.numberOfLines = 0 // 最多10行
        return lbl
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(lblName)
        lblName.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(1), left: WH(10), bottom: WH(3), right: WH(10)))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            lblName.isHidden = true
            return
        }
        // 标题
        var name = ""
        if let pdName = model.shortName, pdName.isEmpty == false {
            name = pdName
        }
        if let spec = model.spec, spec.isEmpty == false {
            name = name + " " + spec
        }
        if model.isZiYingFlag == 1 {
            lblName.attributedText = PDNameCell.getProductDetailHouseTitleAttrStr(name,3,model.ziyingWarehouseName)
        }else {
            lblName.attributedText = PDNameCell.getProductDetailHouseTitleAttrStr(name,model.shopExtendType,model.shopExtendTag)
        }
        lblName.isHidden = false
    }
}

extension PDNameCell {
    //获取0 普通店铺 1 旗舰店 2 加盟店 3 自营店）店铺专用
    @objc static func getProductDetailHouseTitleAttrStr(_ productName:String,_ tagtype:NSInteger, _ selfHouseName: String?) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        if tagtype == 3{
            //自营
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "自营", tagName: houseName, colorType: .blue) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - tagImage.size.height)/2.0-WH(2), width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = FKYSelfTagManager.shareInstance.creatZiyingTag()
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - WH(18))/2.0-WH(1.5), width: WH(36), height: WH(18))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor :  RGBColor(0x000000), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(17))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 2{
            // 加盟店
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "药城", tagName: houseName, colorType: .purple) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - tagImage.size.height)/2.0-WH(2), width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = FKYSelfTagManager.shareInstance.creatZiyingTag()
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - WH(18))/2.0-WH(1.5), width: WH(36), height: WH(18))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x000000), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(17))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 1{
            //旗舰店
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameForMpOrZiyingDetailImage(selfTagStr: "药城", tagName: houseName, colorType: .orange) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - tagImage.size.height)/2.0-WH(2), width: tagImage.size.width, height:tagImage.size.height)
            }else {
                shopImage = FKYSelfTagManager.shareInstance.creatZiyingTag()
                textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - WH(18))/2.0-WH(1.5), width: WH(36), height: WH(18))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x000000), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(17))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if tagtype == 0{
            //mp
            shopImage =  UIImage(named: "mp_shop_icon") // FKYSelfTagManager.shareInstance.creatMPTag()
            let textAttachment : NSTextAttachment = NSTextAttachment()
            textAttachment.image = shopImage
            //textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - WH(18))/2.0-WH(1.5), width: WH(36), height: WH(18))
            textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(17)).lineHeight - WH(15))/2.0+WH(1.5), width: WH(30), height: WH(15))
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x000000), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(17))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else {
            //自营没值得时候
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:"%@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x000000), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(17))])
            attributedStrM.append(productNameStr)
        }
        return attributedStrM;
    }
    //计算高度
    @objc static func getContentHeight(_ model: FKYProductObject?) -> CGFloat {
        guard let model = model else {
            // 隐藏
            return WH(0)
        }
        // 标题
        var name = ""
        if let pdName = model.shortName, pdName.isEmpty == false {
            name = pdName
        }
        if let spec = model.spec, spec.isEmpty == false {
            name = name + " " + spec
        }
        var attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        if model.isZiYingFlag == 1 {
            attributedStrM = PDNameCell.getProductDetailHouseTitleAttrStr(name,3,model.ziyingWarehouseName)
        }else {
            attributedStrM = PDNameCell.getProductDetailHouseTitleAttrStr(name,model.shopExtendType,model.shopExtendTag)
        }
        let contentSize = attributedStrM.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(10) - WH(10), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
        return ceil((contentSize.height + WH(4)) > WH(208+4) ? WH(208+4):contentSize.height + WH(4))
    }
}
