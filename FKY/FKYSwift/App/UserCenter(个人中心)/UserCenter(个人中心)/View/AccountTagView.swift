//
//  AccountTagView.swift
//  FKY
//
//  Created by 寒山 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class AccountTagView: UIView {
    
    //标签背景
    fileprivate lazy var tagBgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "account_info_tag_bg")
        //view.contentMode = .bottom
        return view
    }()
    //cell title
    fileprivate var tagTitleabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xffffff)
        return label
    }()
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ui
    func setupView() {
        self.backgroundColor = .clear
        self.addSubview(tagBgView)
        tagBgView.addSubview(tagTitleabel)
        tagBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        tagTitleabel.snp.makeConstraints { (make) in
            make.center.equalTo(tagBgView)
        }
    }
    func configTagView(_ tagStr:String){
        tagTitleabel.text = tagStr
    }
}
