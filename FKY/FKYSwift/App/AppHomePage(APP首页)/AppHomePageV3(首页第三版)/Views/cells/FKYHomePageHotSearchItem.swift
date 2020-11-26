//
//  FKYHomePageHotSearchItem.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  常搜词item

import UIKit

class FKYHomePageHotSearchItem: UICollectionViewCell {
    lazy var searchKeyWordLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageHotSearchItem{
    func showText(text:String){
        searchKeyWordLB.text = text
    }
}

//MARK: - UI
extension FKYHomePageHotSearchItem{
    func setupUI(){

        contentView.addSubview(searchKeyWordLB)
        self.layer.cornerRadius = WH(18/2.0)
        self.layer.masksToBounds = true
        searchKeyWordLB.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            
           // make.left.equalToSuperview().offset(WH(14))
            //make.right.equalToSuperview().offset(WH(-14))
            
           // make.width.greaterThanOrEqualTo(WH(72-14-14))
           // make.height.equalTo(WH(18))
        }
        
    }
    
    /// 配置展示样式
    func configDisplay(textColor:UIColor , backgroundColor:UIColor){
        searchKeyWordLB.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
