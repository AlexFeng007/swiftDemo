//
//  FKYLotteryRecommendTipCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYLotteryRecommendTipCell: UITableViewCell {
    
    /// tipView
    lazy var tipView = FKYRecommendProductSectionHeaderView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - ui
extension FKYLotteryRecommendTipCell{
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.tipView)
        
        self.tipView.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
            make.height.equalTo(WH(34))
        }
    }
}
