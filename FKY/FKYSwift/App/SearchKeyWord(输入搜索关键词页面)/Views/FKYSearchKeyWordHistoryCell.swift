//
//  FKYSearchKeyWordHistoryCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchKeyWordHistoryCell: UICollectionViewCell {
    
    /// 主文字lb
    fileprivate var titleDesLabel:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize:WH(14))
        lb.textColor = RGBColor(0x333333)
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYSearchKeyWordHistoryCell{
    @objc func configData(text:String){
        self.titleDesLabel.text = text
    }
}

//MARK: - UI
extension FKYSearchKeyWordHistoryCell{
    func setupUI(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.layer.cornerRadius = WH(15)
        self.layer.masksToBounds = true
        self.contentView.addSubview(self.titleDesLabel)
        /*
        self.contentView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 15 - WH(30)-WH(10)-15)
        }
        */
        self.titleDesLabel.snp_makeConstraints { (make) in
            //make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.width.greaterThanOrEqualTo(WH(10))
            
            make.height.equalTo(WH(30))
        }
    }
    
    static func getItemSize(text:String) -> CGSize{
        var itemWidth = FKYSearchKeyWordHistoryCell.getItemWidthText(text: text);
        if (itemWidth < WH(30)) {
            itemWidth = WH(30);
        }
        if (itemWidth > (SCREEN_WIDTH - 12 - WH(30)-WH(10)-15)){
            itemWidth = SCREEN_WIDTH - 12 - WH(30)-WH(10)-15
        }
        return CGSize(width: itemWidth, height: WH(30))
    }
    
    static func getItemWidthText(text:String) -> CGFloat {
        let width = text.ga_widthForComment(fontSize: WH(14), height: CGFloat.greatestFiniteMagnitude)
        return width+WH(20);
    }
}
