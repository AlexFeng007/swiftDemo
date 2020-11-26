//
//  FKYShopAttHeadView.swift
//  FKY
//
//  Created by yyc on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopAttHeadView: UIView {
    //MARK:ui属性
    //红色标
    fileprivate lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFF2D5C)
        return label
    }()
    //一级标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    //抢购中文字描述
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = t3.font
        label.textColor = RGBColor(0x666666)
        return label
    }()
    
    //向右的箭头
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
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
    
    func setupView(){
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(10))
            make.centerY.equalTo(self.snp.centerY);
            make.width.lessThanOrEqualTo(WH(100))
        })
        
        self.addSubview(tagLabel)
        tagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.width.equalTo(WH(3))
            make.height.equalTo(WH(12))
        })
        
        self.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(99))
        })
        self.addSubview(fucntionBtn)
        fucntionBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.right)
            make.centerY.equalTo(titleLabel.snp.centerY);
            make.left.equalTo(tipLabel.snp.left)
            make.height.equalTo(WH(30))
        })
        rightImageView.isHidden = true
        tipLabel.isHidden = true
        fucntionBtn.isHidden = true
    }

}
extension FKYShopAttHeadView {
    func resetShopAttentionHeadView(_ type:Int){
        if type == 1 {
            rightImageView.isHidden = true
            tipLabel.isHidden = true
            fucntionBtn.isHidden = true
            titleLabel.text = "优选好店"
        }else {
            rightImageView.isHidden = false
            tipLabel.isHidden = false
            fucntionBtn.isHidden = false
            titleLabel.text = "关注的店铺"
            tipLabel.text = "全部店铺"
        }
    }
}
