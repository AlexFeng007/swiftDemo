//
//  UITextFieldExtension.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

//class UITextFieldExtension: NSObject {
//
//}

extension UITextField {
    func configTFPlaceholder(placeholder:String,textFont:UIFont = .systemFont(ofSize:WH(13)),textColor:UIColor = RGBColor(0xCCCCCC)){
        self.attributedPlaceholder = NSAttributedString.init(string:placeholder, attributes: [.font:textFont,.foregroundColor:textColor])
    }
}
