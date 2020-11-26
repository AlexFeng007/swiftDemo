//
//  FKYNoNewPrdListDataView.swift
//  FKY
//
//  Created by yyc on 2020/3/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNoNewPrdListDataView: UIView {
    // 无数据图片
    fileprivate lazy var noDateImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    //商品名称
    fileprivate lazy var tipeLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension FKYNoNewPrdListDataView {
    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xF2F2F2)
        addSubview(noDateImageView)
        noDateImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(151))
            make.height.width.equalTo(WH(100))
        }
        addSubview(tipeLabel)
        tipeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(noDateImageView.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(20))
            make.width.equalTo(SCREEN_WIDTH-WH(20))
        }
    }
    //新品登记空态图
    func resetNewPrdListEmpty() {
        noDateImageView.image = UIImage.init(named: "new_prd_set_empty_pic")
        tipeLabel.text = "暂无已登记的记录"
    }
    //商品列表空态图
    func resetPreferentialData() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        noDateImageView.image = UIImage.init(named: "searchEmpty_icon")
        tipeLabel.text = "活动暂无商品"
        noDateImageView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(133))
            make.height.width.equalTo(WH(100))
        }
    }
}
