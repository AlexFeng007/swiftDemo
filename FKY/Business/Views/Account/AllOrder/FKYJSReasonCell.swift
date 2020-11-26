//
//  FKYJSReasonCell.swift
//  FKY
//
//  Created by mahui on 16/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

typealias TextViewDidEndEditing = (_ text : String)->()

class FKYJSReasonCell: UITableViewCell, UITextViewDelegate {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc var textViewDidEndEditing: TextViewDidEndEditing?
    fileprivate var textView : UITextView?
    
    func setupView() -> () {
        let v = UILabel()
        self.contentView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.top.equalTo(self.contentView).offset(h6)
            make.height.equalTo(h9)
        }
        v.font = t9.font
        v.textColor = t9.color
        v.text = "申请原因"
        
        let view = UITextView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.top.equalTo(v.snp.bottom).offset(h1)
            make.height.equalTo(s6.size.height)
            make.right.equalTo(self.contentView).offset(-j1)
        }
        
        view.layer.borderWidth = s6.border.width
        view.layer.borderColor = s6.border.color.cgColor
        view.font = s6.title.font
        view.textColor = s6.title.color
        view.delegate = self
    }    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewDidEndEditing!(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.endEditing(true)
            if  self.textViewDidEndEditing != nil {
                self.textViewDidEndEditing!(textView.text)
            }
            return false
        }
        
        if textView.text.count > 50 {
            return false
        }
        return true
    }
}
