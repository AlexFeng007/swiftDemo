//
//  UIImageViewExtension.swift
//  FKY
//
//  Created by Rabe on 26/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

extension UIImageView {
    /// 根据传入size大小生成工程默认商品占位图
    ///
    /// - Parameter size: 商品图片imageView的size
    /// - Returns: 商品默认占位图
    @objc func productPlaceHolderImage(withSize size: CGSize) -> UIImage {
        return imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", size)
    }
    
    /// 根据颜色及图片生成一张默认占位图
    ///
    /// - Parameters:
    ///   - color: 底色
    ///   - imageName: 居中图片
    ///   - size: 占位图大小（传入imageView的size）
    /// - Returns: 生成好的占位图
    @objc func imageWithColor(_ color: UIColor, _ imageName: String, _ size: CGSize) -> UIImage {
        let image = UIImage.imageWithColor(color, size: size)
        let middleImage = UIImage.init(named: imageName)
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        middleImage?.draw(in: CGRect(x: image.size.width/2-(middleImage?.size.width)!/2, y: image.size.height/2-(middleImage?.size.height)!/2, width: (middleImage?.size.width)!, height: (middleImage?.size.height)!))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage.init(named: "icon_home_placeholder_image_logo")!
    }
}
