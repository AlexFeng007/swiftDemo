//
//  FKYReceiveHeader.swift
//  FKY
//
//  Created by mahui on 16/9/19.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp确认收货界面顶部headview

import Foundation
import SnapKit

class FKYReceiveHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var supply : UILabel?
    fileprivate var contact : UILabel?
    
    func setupView() -> () {
        // 标题
        let title = UILabel()
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j1)
            make.top.equalTo(self)
            make.height.equalTo(h11)
        }
        title.font = t7.font
        title.textColor = t7.color
        title.text = "选择收货商品数量"
        
        // 图标
        let icon = UIImageView()
        icon.image = UIImage.init(named: "icon_account_shop_image")
        self.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.left)
            make.width.height.equalTo(WH(20))
            make.top.equalTo(title.snp.bottom).offset(WH(6))
        }
        
        // 供应商
        supply = {
           let v = UILabel()
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(WH(5))
                make.centerY.equalTo(icon)
                make.height.equalTo(WH(30))
                make.width.greaterThanOrEqualTo(SCREEN_WIDTH/2)
            })
            v.font = t7.font
            v.textColor = t7.color
            v.textAlignment = .left
            return v
        }()
        
        // 联系方式
        contact = {
            let v = UILabel()
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.right.equalTo(self.snp.right).offset(-j1)
                make.centerY.equalTo(icon)
                make.height.equalTo(WH(30))
                make.left.equalTo((supply?.snp.right)!).offset(WH(5))
            })
            v.font = t25.font
            v.textColor = t25.color
            v.textAlignment = .right
            return v
        }()
        
        // 当冲突时，contact不被压缩，supply可以被压缩
        // 当前lbl抗压缩（不想变小）约束的优先级高 UILayoutPriority
        contact?.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗压缩（不想变小）约束的优先级低
        supply?.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 底部分隔线
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        line.backgroundColor = m2
    }
    
    @objc func configCellWithModel(_ receive : FKYReceiveModel) -> () {
        supply?.text = receive.supplyName
        contact?.text = receive.qq
    }
}
