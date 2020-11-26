//
//  FKYShopPrdTitleView.swift
//  FKY
//
//  Created by yyc on 2020/3/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopPrdTitleView: UIView {
    
    //MARK:ui属性
    //底部背景图片
    fileprivate var bgImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_prd_bg_pic")
        return img
    }()
    
    //头部背景view
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = RGBColor(0xFFFFFF)
        return label
    }()
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_right_pic")
        return img
    }()
    fileprivate var leftImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_left_pic")
        return img
    }()
    
    //查看更多
    fileprivate lazy var moreDesLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .right
        label.font = t3.font
        label.textColor = RGBColor(0xFFFFFF)
        label.text = "查看更多"
        label.isHidden = true
        return label
    }()
    
    //向右的箭头
    fileprivate var rightArrowImageView: UIImageView = {
        let img = UIImageView()
        img.isHidden = true
        img.image = UIImage.init(named: "shop_right_arrows_pic")
        return img
    }()
    
    // 点击更多按钮
    fileprivate lazy var fucntionBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.isHidden = true
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickViewBlock {
                block(1)
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //业务属性
    var clickViewBlock : ((Int)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension FKYShopPrdTitleView {
    fileprivate func setupView(){
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints({ (make) in
            make.top.right.bottom.left.equalTo(self)
        })
        bgImageView.addSubview(topView)
        topView.snp.makeConstraints({ (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(WH(40))
        })
        
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(topView.snp.centerY);
            make.width.lessThanOrEqualTo(WH(120))
        })
        topView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(14))
            make.centerY.equalTo(topView.snp.centerY);
        })
        
        topView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-WH(14))
            make.centerY.equalTo(topView.snp.centerY);
        })
        
        topView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(20))
            make.centerY.equalTo(topView.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        topView.addSubview(moreDesLabel)
        moreDesLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightArrowImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(topView.snp.centerY);
            make.width.lessThanOrEqualTo(WH(85))
        })
        self.addSubview(fucntionBtn)
        fucntionBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(rightArrowImageView.snp.right)
            make.centerY.equalTo(topView.snp.centerY);
            make.left.equalTo(moreDesLabel.snp.left)
            make.height.equalTo(WH(30))
        })
    }
}
extension FKYShopPrdTitleView {
    func configShopPrdViewData(_ promotionPrdModel:FKYShopPromotionBaseInfoModel) {
        titleLabel.text = promotionPrdModel.title
        if let urlInt = promotionPrdModel.type , urlInt == 106 {
            rightArrowImageView.isHidden = false
            moreDesLabel.isHidden = false
            fucntionBtn.isHidden = false
        }else {
            if let url = promotionPrdModel.jumpInfoMore ,url.count > 0 {
                rightArrowImageView.isHidden = false
                moreDesLabel.isHidden = false
                fucntionBtn.isHidden = false
            }else {
                rightArrowImageView.isHidden = true
                moreDesLabel.isHidden = true
                fucntionBtn.isHidden = true
            }
        }
    }
}
