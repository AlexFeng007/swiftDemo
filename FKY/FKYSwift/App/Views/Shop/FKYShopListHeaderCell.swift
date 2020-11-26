//
//  FKYShopListHeaderCell.swift
//  FKY
//
//  Created by hui on 2018/11/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopListHeaderCell: UICollectionViewCell {
    //MARK:UI控件
    // 图片
   fileprivate lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "shaixuan_normal") //shaixuan_select
        return iv
    }()
    
    // 名称
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "筛选"
        label.font = t24.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
   
    // 加车按钮
    fileprivate lazy var siftBtn: UIButton = {
        let button = UIButton()
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickSiftBtnClosure {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
     var clickSiftBtnClosure: emptyClosure? //点击筛选
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:UI布局
    func setupView() {
        self.backgroundColor = UIColor.white
        // 名称
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-WH(17))
        })
        // 图片
        self.contentView.addSubview(self.img)
        img.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(titleLabel.snp.left).offset(-WH(7))
            make.height.equalTo(WH(14))
            make.width.equalTo(WH(16))
        })
        self.contentView.addSubview(self.siftBtn)
        siftBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.img.snp.left)
            make.right.top.bottom.equalTo(contentView)
        })
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        self.contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
        
    }
    func refreshData(_ isSelected:Bool) {
        if isSelected == true {
            img.image = UIImage(named: "shaixuan_select")
            titleLabel.textColor = RGBColor(0xFF2D5C)
        }else {
            img.image = UIImage(named: "shaixuan_normal")
            titleLabel.textColor = RGBColor(0x333333)
        }
    }
}
