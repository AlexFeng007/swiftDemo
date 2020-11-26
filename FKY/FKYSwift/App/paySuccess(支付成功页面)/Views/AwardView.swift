//
//  AwardView.swift
//  RewardViewDemo
//
//  Created by cuixuerui on 2019/4/9.
//  Copyright © 2019 cuixuerui. All rights reserved.
//

import UIKit

class AwardView: UIView {
    
    let textArcView = CXRTextArcView()
    let imageView = UIImageView()
    private var baseAngle: CGFloat = 0
    private var radius: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupLayout()
    }
    
    private func setup() {
        addSubview(textArcView)
        addSubview(imageView)
    }
    
    private func setupLayout() {
        textArcView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(WH(60))
            make.width.equalTo(WH(60))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
    }
    
    func set(baseAngle: CGFloat, radius: CGFloat) {
        // 设置圆弧 Label
        textArcView.textAttributes = [.foregroundColor: RGBColor(0x7A5221),
                                      .font: UIFont.boldSystemFont(ofSize: WH(14))]
        textArcView.characterSpacing = 0.85
        textArcView.baseAngle = baseAngle
        textArcView.radius = radius
    }
    
    func set(title: String, image: String) {
        textArcView.text = title
        imageView.image = UIImage(imageLiteralResourceName: image)
    }

}

// MARK: - 数据显示
extension AwardView{
    /// 展示数据
    func configData(prizeModel:FKYPrizeModel){
        self.textArcView.text = prizeModel.showName
        if Int(prizeModel.priseLevel) ?? 0 == 0{/// 谢谢惠顾
            self.imageView.image = UIImage(named:prizeModel.prisePicture)
        }else{
            self.imageView.sd_setImage(with: URL(string: prizeModel.prisePicture))
        }
    }
}


