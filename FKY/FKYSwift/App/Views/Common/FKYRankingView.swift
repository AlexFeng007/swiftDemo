//
//  FKYRankingView.swift
//  FKY
//
//  Created by yyc on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRankingView: UIView {
    
    // 状态图片
    fileprivate lazy var bgImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    //排名
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.textColor = t34.color
        label.font = t33.font
        label.adjustsFontSizeToFitWidth  = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()
    //分割线
    fileprivate lazy var horizontalLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = t34.color
        return label
    }()
    //热销描述
    fileprivate lazy var hotDesLabel : UILabel = {
        let label = UILabel()
        label.textColor = t34.color
        label.font = t28.font
        label.text = "热销"
        label.alpha = 0.7
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
extension FKYRankingView {
    fileprivate  func setupView() {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        bgImageView.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView)
            make.right.equalTo(bgImageView.snp.right).offset(-WH(2))
            make.left.equalTo(bgImageView.snp.left).offset(WH(2))
            make.height.equalTo(WH(20))
        }
        bgImageView.addSubview(horizontalLabel)
        horizontalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(WH(18))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(7))
            make.left.equalTo(bgImageView.snp.left).offset(WH(7))
            make.height.equalTo(WH(0.5))
        }
        bgImageView.addSubview(hotDesLabel)
        hotDesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLabel.snp.bottom).offset(WH(1))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(2))
            make.left.equalTo(bgImageView.snp.left).offset(WH(2))
            make.height.equalTo(WH(14))
        }
    }
}
extension FKYRankingView {
    func configRankingViewData(_ num:Int?) {
        if let numIndex = num {
            self.isHidden = true
            self.numLabel.text = "\(numIndex)"
            if numIndex == 1 {
                self.bgImageView.image  = UIImage(named: "rank_one_pic")
                self.isHidden = false
            }else if numIndex == 2 {
                self.bgImageView.image  = UIImage(named: "rank_two_pic")
                self.isHidden = false
            }else if numIndex == 10086{
                self.isHidden = true
            }else {
                self.bgImageView.image  = UIImage(named: "rank_other_pic")
                self.isHidden = false
            }
        }else {
            self.isHidden = true
        }
    }
}
