//
//  FKYCouponTagManager.swift
//  FKY
//
//  Created by yyc on 2020/9/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

@objc class FKYCouponTagManager: NSObject {
    @objc static let shareInstance = FKYCouponTagManager()
    var selfCouponTagImages: Dictionary<String, UIImage> = [:]
    
    @objc var tagTextFont = t28.font
     let tagHeight: CGFloat = WH(15)
    //根据仓库名生成Image
    @objc func tagCouponNameImage(tagName: String, lableColor: UIColor ,type:Int) -> UIImage? {
        
        guard tagName.isEmpty == false else {
            return nil
        }
        //存储key
        let key = "\(tagName)*\(type)"
        if let image = selfCouponTagImages[key] {
            return image
        }
        
        let tagLabel = UILabel()
        tagLabel.text = tagName
        tagLabel.textColor = lableColor
        tagLabel.font = t28.font
        tagLabel.textAlignment = .center
        tagLabel.layer.borderWidth = 0.5
        tagLabel.layer.borderColor = lableColor.cgColor
        tagLabel.layer.cornerRadius = WH(2)
        tagLabel.frame = CGRect(x: 0, y: 0, width: textWidth(tagName), height: tagHeight)

        //渲染image
        UIGraphicsBeginImageContextWithOptions(tagLabel.frame.size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            tagLabel.layer.render(in:ctx)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let tagImg = img else { return nil }
        selfCouponTagImages[key] = tagImg
        return tagImg
    }
    func textWidth(_ text: String) -> CGFloat {
        return text.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:tagHeight), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : tagTextFont], context: nil).width + WH(4)
    }
}

//MARK:获取富文本
extension FKYCouponTagManager {
    func getCouponsTagAttributedString(tagName: String, tableColor: UIColor ,type:Int, coupStr:String) -> NSMutableAttributedString {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let textAttachment : NSTextAttachment = NSTextAttachment()
        if let tagImage = FKYCouponTagManager.shareInstance.tagCouponNameImage(tagName: tagName, lableColor: tableColor,type:type) {
            let couponImage = tagImage
            let line_h = UIFont.boldSystemFont(ofSize: WH(14)).lineHeight
            var offset_y : CGFloat = 0.0
            if tagImage.size.height > line_h {
                offset_y = -(tagImage.size.height - line_h)
            }else {
                offset_y = -(line_h - tagImage.size.height)
            }
            textAttachment.bounds = CGRect(x: 0, y: offset_y, width: tagImage.size.width, height:tagImage.size.height)
            textAttachment.image = couponImage
        }
        let couponsNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",coupStr), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))])
        
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        attributedStrM.append(couponsNameStr)
        return attributedStrM
    }
}
