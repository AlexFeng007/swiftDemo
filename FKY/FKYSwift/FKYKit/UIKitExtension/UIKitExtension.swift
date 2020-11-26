//
//  UIKitExtension.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//
import UIKit
import Darwin

extension UILabel {
    var fontTuple:labelTuple {
        get{
            return (color: self.textColor, font: self.font)
        }
        set{
            self.textColor = newValue.color
            self.font = newValue.font
        }
    }
    
    func singleLineLenght() -> CGFloat {
        if let txt = self.text {
            let str = (txt as NSString)
            return (str.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.font.lineHeight), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : self.font], context: nil).size.width + 1)
        }
        return 0
    }
}

extension UIButton {
    var fontTuple:labelTuple {
        get{
            return (color: self.titleLabel!.textColor, font: self.titleLabel!.font)
        }
        set{
            self.setTitleColor(newValue.color, for: UIControl.State())
            self.titleLabel!.font = newValue.font
        }
    }
    func setTitleLeftImageRightWithSpace(_ space:CGFloat){
        let imageSize = self.imageView!.image!.size;
        let labelText: NSString = self.titleLabel!.text! as NSString
        let textLength = labelText.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:self.titleLabel!.font], context: nil).size.width
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (textLength + space/2.0), bottom: 0, right: -(textLength + space/2.0))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + space/2.0), bottom: 0, right: (imageSize.width + space/2.0))
    }
    
    func singleLineLenght() -> CGFloat {
        if let text = self.titleLabel?.text {
            let str = (text as NSString)
            return str.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.titleLabel!.font.lineHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.titleLabel!.font], context: nil).size.width
        }
        return 0
    }
}

extension UICollectionViewFlowLayout {
    fileprivate struct AssociatedKeys {
        static var maxSpacing = "maxSpacing"
    }
    var maximunInteritemSpacing: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.maxSpacing) as? CGFloat)!
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.maxSpacing,
                newValue as CGFloat,
                .OBJC_ASSOCIATION_ASSIGN
            )
        }
    }
}

extension UIColor {
    class func gradientLeftToRightColor(_ leftColor:UIColor,_ rightColor : UIColor,_ viewW:CGFloat) -> UIColor {
        let size = CGSize.init(width: viewW, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let colors = [leftColor.cgColor,rightColor.cgColor]
        let gradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: nil)
        context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor.init(patternImage:img!)
    }
}

extension UIImage {
    // 图片压缩...<先压质量，再压尺寸>
    // 当前图片压缩效率较高，10m以内的图片基本在1s内可压缩完~!@
    class func compressImage(_ image: UIImage, _ length: Double?) -> Data? {
        // image转data失败
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        // 图片无大小限制，不压缩，直接返回
        guard let maxLength = length, maxLength > 0 else {
            return data
        }
        // 当前图片小于等于限制大小，不压缩，直接返回
        guard Double(data.count) > 1024 * 1024 * maxLength else {
            return data
        }
        
        /***************************************************************/
        
        // 1. 先压质量...<0.9>...<简单的用0.9压一下，压缩后的实际图片大小比0.9倍原图要小得多，但显示效果差别不大>
        guard let imgData = image.jpegData(compressionQuality: 0.9) else {
            // 若失败，则直接返回
            return data
        }
        // 2. 再压尺寸
        //var zipScale = 1.0  // 压缩比例
        var compressData = imgData // 当前图片data
        print("origin-image count: \(Double(compressData.count) / 1024 / 1024) m")
        
        // 若当前图片大小是限制大小的2位以上
        while Double(compressData.count) >= 1024 * 1024 * maxLength * 2 {
            // 转图片
            guard let compressImage = UIImage.init(data: compressData) else {
                // error
                return compressData
            }
            
            // 压缩一半...<0.7 * 0.7 = 0.49 约等于0.5>
            if let img = compressImage.imageScaleDown(0.7) {
                // img转data
                if let zipData = img.jpegData(compressionQuality: 1.0) {
                    compressData = zipData
                    print("[compress half]+++")
                }
                else {
                    // error
                    return compressData
                }
            }
            else {
                // error
                return compressData
            }
        } // while
        
        // 压缩图片...<需小于1.2M>
        while Double(compressData.count) > 1024 * 1024 * maxLength {
            // 转图片
            guard let compressImage = UIImage.init(data: compressData) else {
                // error
                return compressData
            }
            
            // 压缩一半...<0.9 * 0.9 = 0.81 约等于0.8>
            if let img = compressImage.imageScaleDown(0.9) {
                // img转data
                if let zipData = img.jpegData(compressionQuality: 1.0)  {
                    compressData = zipData
                    print("[compress]+++")
                }
                else {
                    // error
                    return compressData
                }
            }
            else {
                // error
                return compressData
            }
        } // while
        
        print("final-image count: \(Double(compressData.count) / 1024 / 1024) m")
        return compressData
    }
    
    @objc class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageWithTwoColor(_ leftcolor: UIColor,_ rightcolor: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(leftcolor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width/2.0, height: size.height))
        
        context.setFillColor(rightcolor.cgColor)
        context.fill(CGRect(x: size.width/2.0, y: 0, width: size.width/2.0, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithTintColor(_ tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor, blendMode: .destinationIn)
    }
    
    func imageWithGradientTintColor(_ tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor, blendMode: .overlay)
    }
    
    func imageWithTintColor(_ tintColor: UIColor, blendMode:CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        
        let tintedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return tintedImage;
    }
}

extension NSDictionary {
    func mapToObject<B: JSONAbleType>(_ classType: B.Type) -> B {
        return B.fromJSON(self as! [String : AnyObject])
    }
}

extension NSArray {
    func mapToObjectArray<B: JSONAbleType>(_ classType: B.Type) -> [B]? {
        if let dicts = self as? [NSDictionary] {
            //筛选
            let desArr = dicts.filter({(d:Any) -> Bool in
                if ((d as? [String : AnyObject]) != nil) {
                    return true
                }else {
                    return false
                }
            })
            return desArr.map {(j) in
                B.fromJSON(j as! [String : AnyObject])
            }
        }
        return nil
    }
    
    func reverseToJSON() -> [[String: AnyObject]] {
        return self.map({ (T) -> [String: AnyObject] in
            if T is ReverseJSONType {
                return (T as! ReverseJSONType).reverseJSON()
            }
            return ["": "" as AnyObject]
        })
    }
}

extension String {
    // 不再支持小图模式
    func smallImageUrlString() -> String {
        //return self + "@400w_400h"
        return self
    }
    
    func heightForFontAndWidth(_ font: UIFont, width: CGFloat, attributes:[String : AnyObject]?) -> CGFloat {
        var dic = [NSAttributedString.Key : Any]()
        if let attr = attributes {
            for (key, value) in attr {
                let name = NSAttributedString.Key.init(rawValue: key)
                dic[name] = value
            }
        }
        
        return self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: dic, context: nil).size.height
    }
    
    func widthForFontAndHeight(_ font: UIFont, Height: CGFloat, attributes:[String : AnyObject]?) -> CGFloat {
        var dic = [NSAttributedString.Key : Any]()
        if let attr = attributes {
            for (key, value) in attr {
                let name = NSAttributedString.Key.init(rawValue: key)
                dic[name] = value
            }
        }
        
        return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: Height), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: dic, context: nil).size.width
    }
    
    // 拒绝原因文描高度
    func heightForRefuseReason() -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = WH(10)
        paragraphStyle.alignment = .left
        
        let attrs: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.foregroundColor: t31.color, NSAttributedString.Key.font: t31.font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        var dic = [String : AnyObject]()
        for (key, value) in attrs {
            dic[key.rawValue] = value
        }
        
        let refuseStyle = RefuseReasonStyle()
        let FontHeightFor50 = "测试五十字测试五十字测试五十字测试五十字测试五十字测试五十字测试五十字测试五十字测试五十字测试五十字".heightForFontAndWidth(refuseStyle.font, width: refuseStyle.width, attributes: dic)
        
        var height = self.heightForFontAndWidth(refuseStyle.font, width: refuseStyle.width, attributes: dic)
        if height > FontHeightFor50 {
            height = FontHeightFor50
        }
        height = height + (j1 * 2) + 1
        return height
    }
    
    func transformToPinyin() -> String {
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        
        let strPinYin = String(mutableString)
        
        //去掉空格
        return strPinYin.replacingOccurrences(of: " ", with: "")
    }
}


extension UISegmentedControl {
    @objc
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            let tintColorImage = UIImage(color: tintColor)
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: tintColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }
}

extension UIImage{
    //MARK:获取默认图片
    @objc static func getCommonDefaultImg(_ bgRect:CGRect) -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: bgRect.origin.x, y: bgRect.origin.y, width: bgRect.size.width, height: bgRect.size.height))
        view.backgroundColor = RGBColor(0xE5E5E5)
        
        let imgview = UIImageView.init(frame: CGRect.init(x: WH(bgRect.size.width - 82)/2.0, y: WH(bgRect.size.height - 47)/2.0, width: WH(82), height: WH(47)))
        imgview.image = UIImage.init(named: "live_list_placeholder_icon")
        imgview.contentMode = .scaleAspectFit
        imgview.center = view.center
        view.addSubview(imgview)
        
        // 调整屏幕密度（缩放系数）
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let contextRef = UIGraphicsGetCurrentContext() {
            view.layer.render(in: contextRef)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imgFinal = img {
            return imgFinal
        }
        else {
            return UIImage.init(named: "banner-placeholder")!
        }
    }
}
